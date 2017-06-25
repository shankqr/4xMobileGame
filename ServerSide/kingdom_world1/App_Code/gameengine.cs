using System;
using System.ServiceModel;
using System.ServiceModel.Activation;
using System.ServiceModel.Web;
using System.IO;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Globalization;
using System.Threading;
using System.Text.RegularExpressions;
using System.Net;
using System.Net.Mail;
using System.Collections.Generic;
using JdSoft.Apple.Apns.Notifications;
using JdSoft.Apple.AppStore;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using Microsoft.AspNet.SignalR;
using Hangfire;

[ServiceContract]
[AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
[ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall, IncludeExceptionDetailInFaults = true)]
public class GameEngine
{
	Encoding encoding = Encoding.UTF8;
    IHubContext connectionHub = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
	
    public static string GetConnectionString()
    {
        return Global.ConnectionString;
    }
    
    private string GetMainConnectionString()
    {
        return Global.MainConnectionString;
    }
    
    
    [WebGet(UriTemplate = "LoginWorld/{uid}/{devicetoken}/{alliance_id}")]
    public Stream LoginWorld(string uid, string devicetoken, string alliance_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_UpdateDeviceToken", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@devicetoken", SqlDbType.VarChar).Value = devicetoken;
                
                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                
                cmd1.ExecuteNonQuery();
                int ret = (int)cmd1.Parameters["@r"].Value;
	            
                result = ret.ToString();
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "PushNotiTest_pid/{profile_id}")]
    public Stream PushNotiTest_pid(string profile_id)
    {
        string result = "1";
        
        Push(profile_id, "Push notification from Kingdom World server. It works!");

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "PushNotiTest_devtoken/{devtoken}")]
    public Stream PushNotiTest_devtoken(string devtoken)
    {
        string result = "1";
        
        NotificationServ(devtoken, "Push notification from Kingdom World server. It works!");

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
	private void Push(string profile_id, string message)
    {
        string p12File = "push.p12";
        string devtoken = "0";
        
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd = new SqlCommand("SELECT devicetoken FROM profile WHERE profile_id=" + profile_id, cn))
            {
                SqlDataReader r1 = cmd.ExecuteReader();
                while (r1.Read())
                {
                    if (!(r1.IsDBNull(0)))
                    {
                        devtoken = r1["devicetoken"].ToString();
                    }
                }
                r1.Close();
	        }
        }
        
        if (devtoken != "0" && devtoken != "(null)" && devtoken != "" && message.Length>0)
        {
            bool sandbox = false;
            string p12FilePassword = "password123";
            string p12Filename = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, p12File);
            NotificationService service = new NotificationService(sandbox, p12Filename, p12FilePassword, 1);
            service.SendRetries = 5;
            service.ReconnectDelay = 5000;

            Notification alertNotification = new Notification(devtoken);
            alertNotification.Payload.Alert.Body = message;
            alertNotification.Payload.Sound = "default";
            alertNotification.Payload.Badge = 1;

            service.QueueNotification(alertNotification);
            service.Close();
            service.Dispose();
        }
    }
    
    private void NotificationServ(string devtoken, string message)
    {
        string p12File = "push.p12";
        
        bool sandbox = false;
        string p12FilePassword = "password123";
        string p12Filename = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory, p12File);
        NotificationService service = new NotificationService(sandbox, p12Filename, p12FilePassword, 1);
        service.SendRetries = 5;
        service.ReconnectDelay = 5000;

        Notification alertNotification = new Notification(devtoken);
        alertNotification.Payload.Alert.Body = message;
        alertNotification.Payload.Sound = "default";
        alertNotification.Payload.Badge = 1;

        service.QueueNotification(alertNotification);
        service.Close();
        service.Dispose();
    }
	
	private static string PostRequest(string url, string postData)
    {
        byte[] byteArray = Encoding.UTF8.GetBytes(postData);
        return PostRequest(url, byteArray);
    }

    private static string PostRequest(string url, byte[] byteArray)
    {
        try
        {
            WebRequest request = HttpWebRequest.Create(url);
            request.Method = "POST";
            request.ContentLength = byteArray.Length;
            request.ContentType = "text/plain";

            using (System.IO.Stream dataStream = request.GetRequestStream())
            {
                dataStream.Write(byteArray, 0, byteArray.Length);
                dataStream.Close();
            }

            using (WebResponse r = request.GetResponse())
            {
                using (System.IO.StreamReader sr = new System.IO.StreamReader(r.GetResponseStream()))
                {
                    return sr.ReadToEnd();
                }
            }
        }
        catch (Exception ex)
        {
            return string.Empty;
        }
    }

    private bool ReceiptVer(string receiptData)
    {
        string returnmessage = "";
        try
        {
            var json = new JObject(new JProperty("receipt-data", receiptData)).ToString();

            ASCIIEncoding ascii = new ASCIIEncoding();
            byte[] postBytes = Encoding.UTF8.GetBytes(json);

            string url_1 = "https://sandbox.itunes.apple.com/verifyReceipt";
            string url_2 = "https://buy.itunes.apple.com/verifyReceipt";

            var request = HttpWebRequest.Create(url_2);
            request.Method = "POST";
            request.ContentType = "application/json";
            request.ContentLength = postBytes.Length;

            using (var stream = request.GetRequestStream())
            {
                stream.Write(postBytes, 0, postBytes.Length);
                stream.Flush();
            }

            var sendresponse = request.GetResponse();

            string sendresponsetext = "";
            using (var streamReader = new StreamReader(sendresponse.GetResponseStream()))
            {
                sendresponsetext = streamReader.ReadToEnd().Trim();
            }
            returnmessage = sendresponsetext;

        }
        catch (Exception ex)
        {
            ex.Message.ToString();
        }

        var o = JObject.Parse(returnmessage);
        int status = (int)o["status"];

        bool result = false;
        if (status == 0)
        {
            result = true;
        }

        return result;
    }

    [OperationContract]
    [WebInvoke(UriTemplate = "/PostReportError", Method = "POST", BodyStyle = WebMessageBodyStyle.WrappedRequest)]
    public Stream PostReportError(Stream streamdata)
    {
        string result = "0";

        StreamReader reader = new StreamReader(streamdata);
        string sr = reader.ReadToEnd();
        reader.Close();
        reader.Dispose();

        Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(sr);

        string error_id = dic["error_id"];
        string uid = dic["uid"];
        string json = dic["json"];
	       
        int total = 0;
        if (ReceiptVer(json))
        //if (total>=0)
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                cn.Open();
                using (SqlCommand cmd1 = new SqlCommand("usp_PremiumCurrencyPurchased", cn))
                {
                    cmd1.CommandType = CommandType.StoredProcedure;
                    cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                    cmd1.Parameters.Add("@transaction_id", SqlDbType.Text).Value = json;
                    cmd1.Parameters.Add("@product_code", SqlDbType.VarChar).Value = error_id;
                    cmd1.Parameters.Add("@r", SqlDbType.Int);
                    cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                    try
                    {
                        cmd1.ExecuteNonQuery();
                        int ret = (int)cmd1.Parameters["@r"].Value;
                        result = ret.ToString();
                    }
                    catch (Exception ex)
                    {
                        result = ex.Message;
                    }
                }
            }
        }
        else
        {
            //Cheat Detected
        }
        

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetSettings")]
    public Stream GetSettings()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM settings WHERE settings_id=1", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetResearch")]
    public Stream GetResearch()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM research", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetUnit")]
    public Stream GetUnit()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM unit", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetBuilding")]
    public Stream GetBuilding()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM building", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetBuildingLevel")]
    public Stream GetBuildingLevel()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM building_level", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetHeroLevel")]
    public Stream GetHeroLevel()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_HeroLevel", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetProfileInfo/{profile_id}")]
    public Stream GetProfileInfo(string profile_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
			using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_Profile WHERE profile_id=" + profile_id, cn))
			{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }
    
    [WebGet(UriTemplate = "GetProfileRank/{profile_id}")]
    public Stream GetProfileRank(string profile_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_ProfileRank WHERE profile_id=" + profile_id, cn))
        	{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }

    [WebGet(UriTemplate = "GetBookmarks/{profile_id}")]
    public Stream GetBookmarks(string profile_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM bookmark WHERE profile_id=" + profile_id, cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "DeleteBookmark/{uid}/{bookmark_id}")]
    public Stream DeleteBookmark(string uid, string bookmark_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_BookmarkDelete", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@bookmark_id", SqlDbType.Int).Value = bookmark_id;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "CreateBookmark/{uid}/{title}/{label}/{map_x}/{map_y}")]
    public Stream CreateBookmark(string uid, string title, string label, string map_x, string map_y)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_BookmarkCreate", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@title", SqlDbType.VarChar).Value = title;
                cmd1.Parameters.Add("@label", SqlDbType.Int).Value = label;
                cmd1.Parameters.Add("@map_x", SqlDbType.Int).Value = map_x;
                cmd1.Parameters.Add("@map_y", SqlDbType.Int).Value = map_y;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetBaseAll/{profile_id}")]
    public Stream GetBaseAll(string profile_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM View_BaseCastleLevel WHERE profile_id=" + profile_id +" AND last_captured<GETUTCDATE() ORDER BY base_type ASC, building_level DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetBaseMain/{profile_id}")]
    public Stream GetBaseMain(string profile_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM base WHERE base_type=1 AND profile_id=" + profile_id , cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetBase/{base_id}/{profile_id}")]
    public Stream GetBase(string base_id, string profile_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sp_name = "usp_BaseFetch";
            
            using (SqlCommand cmd1 = new SqlCommand(sp_name, cn))
            {
                cn.Open();
                
                cmd1.CommandType = CommandType.StoredProcedure;
                
                cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
                cmd1.Parameters.Add("@profile_id", SqlDbType.VarChar).Value = profile_id;
                
                SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetBuildAll/{base_id}")]
    public Stream GetBuildAll(string base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM build WHERE base_id=" + base_id , cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetBuild/{base_id}/{building_id}")]
    public Stream GetBuild(string base_id, string building_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM View_Build WHERE base_id=" + base_id + " AND building_id=" + building_id , cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetItems/{profile_id}")]
    public Stream GetItems(string profile_id)
    {
        if (int.Parse(profile_id) > 0)
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string strSql = @"SELECT item.*, itemprofile.itemprofile_id, itemprofile.profile_id, itemprofile.quantity 
                FROM item LEFT JOIN itemprofile ON item.item_id=itemprofile.item_id AND item.item_valid=1 AND itemprofile.profile_id=" + profile_id +
                @" WHERE item.item_valid=1 ORDER BY item.item_id";
                using (SqlCommand cmd = new SqlCommand(strSql, cn))
                {
                    cn.Open();

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                    return new MemoryStream(returnBytes);
                }
            }
        }
        else
        {
            string result = "1";
            WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            byte[] returnBytes2 = encoding.GetBytes(result);
            return new MemoryStream(returnBytes2);
        }
    }
    
    [WebGet(UriTemplate = "GetReinforcementsFrom/{base_id}")]
    public Stream GetReinforcementsFrom(string base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_Reinforcements WHERE from_base_id=" + base_id, cn))
        	{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }
    
    [WebGet(UriTemplate = "GetReinforcementsTo/{base_id}")]
    public Stream GetReinforcementsTo(string base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_ReinforcementsTo WHERE to_base_id=" + base_id, cn))
        	{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }
    
    [WebGet(UriTemplate = "GetReinforcementsAt/{base_id}")]
    public Stream GetReinforcementsAt(string base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_ReinforcementsAt WHERE to_base_id=" + base_id, cn))
        	{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }
    
    [WebGet(UriTemplate = "GetTradesTo/{base_id}")]
    public Stream GetTradesTo(string base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_TradesArrive WHERE to_base_id=" + base_id, cn))
        	{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }
    
    [WebGet(UriTemplate = "GetAttacksFrom/{base_id}")]
    public Stream GetAttacksFrom(string base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_Attacks WHERE from_base_id=" + base_id, cn))
        	{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }
    
    [WebGet(UriTemplate = "GetAttacksArriveFrom/{base_id}")]
    public Stream GetAttacksArriveFrom(string base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_AttacksArrive WHERE from_base_id=" + base_id, cn))
        	{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }
    
    [WebGet(UriTemplate = "GetAttacksArriveTo/{base_id}")]
    public Stream GetAttacksArriveTo(string base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_AttacksArrive WHERE to_base_id=" + base_id, cn))
        	{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
                
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                
                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                	return new MemoryStream(returnBytes);
                }
            }
        }
        
        return null;
    }
	
    [WebGet(UriTemplate = "GetSearch/{name}")]
    public Stream GetSearch(string name)
    {
    	if (name.Length > 2)
    	{
    		using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        	{
			using (SqlCommand cmd = new SqlCommand("SELECT * FROM profile WHERE profile_name LIKE '%"+name+"%' AND profile_name NOT LIKE 'PROFILE %' ORDER BY xp DESC", cn))
			{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
				
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        	}
    	}
    	
        return new MemoryStream(Encoding.UTF8.GetBytes("1"));
    }
    
    [WebGet(UriTemplate = "GetSearchAlliance/{name}")]
    public Stream GetSearchAlliance(string name)
    {
    	if (name.Length > 2)
    	{
    		using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        	{
			using (SqlCommand cmd = new SqlCommand("SELECT * FROM View_Alliance WHERE alliance_name LIKE '%"+name+"%' AND leader_id != 0 ORDER BY power DESC", cn))
			{
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);
				
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        	}
    	}
    	
    	return new MemoryStream(Encoding.UTF8.GetBytes("1"));
    }
    
    [WebGet(UriTemplate = "GetProfilesTopLevel")]
    public Stream GetProfilesTopLevel() //Rankings
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1000 profile_id, profile_name, xp, kills, alliance_rank, profile_face FROM profile WHERE uid != '0' AND uid != '1' ORDER BY xp DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceTopLevel")]
    public Stream GetAllianceTopLevel() //Alliance Rankings
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1000 * FROM View_Alliance WHERE leader_id != 0 ORDER BY power DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceTopActive")]
    public Stream GetAllianceTopActive() //Alliance View
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 1000 * FROM View_Alliance WHERE leader_id != 0 ORDER BY kills DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetReport/{report_id}/{profile_id}/{alliance_id}")]
    public Stream GetReport(string report_id, string profile_id, string alliance_id)
    {
        //alliance id not being used currently
        if(ulong.Parse(report_id) >= 0 && int.Parse(profile_id) >= 0) 
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string strSql = string.Empty;
                strSql = "SELECT * FROM report WHERE ((profile1_id=" + profile_id + ") OR (profile2_id=" + profile_id + ")) AND report_id>" + report_id + " ORDER BY report_id DESC";

                using (SqlCommand cmd = new SqlCommand(strSql, cn))
                {
                    cn.Open();

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                    return new MemoryStream(returnBytes);
                }
            }
        }
        else
        {
            string result = "Data format incorrect";
            WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            byte[] returnBytes2 = encoding.GetBytes(result);
            return new MemoryStream(returnBytes2);
        }
    }

    
    [WebGet(UriTemplate = "GetRegions/{center_x}/{center_y}/{tiles_x}/{tiles_y}")]
    public Stream GetRegions(string center_x, string center_y, string tiles_x, string tiles_y)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            //Should return 1, 2 or 4 regions that the client frame is viewable
            using (SqlCommand cmd = new SqlCommand("usp_GetRegions", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@coordinate_x", SqlDbType.Int).Value = center_x;
                cmd.Parameters.Add("@coordinate_y", SqlDbType.Int).Value = center_y;
                cmd.Parameters.Add("@width", SqlDbType.Int).Value = tiles_x;
                cmd.Parameters.Add("@height", SqlDbType.Int).Value = tiles_y;
                
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetMapCities/{region_id}")]
    public Stream GetMapCities(string region_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {	
            using (SqlCommand cmd = new SqlCommand("usp_GetMapCities", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@region_id", SqlDbType.Int).Value = region_id;

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetMapCitiesExtended/{profile_id}/{region_id}")]
    public Stream GetMapCitiesExtended(string profile_id, string region_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {	
            using (SqlCommand cmd = new SqlCommand("usp_GetMapCities", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@region_id", SqlDbType.Int).Value = region_id;
                cmd.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;
                
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
        
    [WebGet(UriTemplate = "GetMapTerrain/{region_id}")]
    public Stream GetMapTerrain(string region_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {	
            using (SqlCommand cmd = new SqlCommand("usp_GetMapTerrain", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@region_id", SqlDbType.Int).Value = region_id;

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetMapVillages/{region_id}")]
    public Stream GetMapVillages(string region_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
             using (SqlCommand cmd = new SqlCommand("usp_GetMapVillages", cn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@region_id", SqlDbType.Int).Value = region_id;

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
	[WebGet(UriTemplate = "GetMail/{mail_id}/{profile_id}/{alliance_id}")]
    public Stream GetMail(string mail_id, string profile_id, string alliance_id)
    {
        if(ulong.Parse(mail_id) >= 0 && int.Parse(profile_id) >= 0) 
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string strSql = string.Empty;
                strSql = "SELECT * FROM mail LEFT JOIN mailprofile ON mail.mail_id=mailprofile.mail_id WHERE ( (mailprofile.profile_id=" + profile_id + ") OR (mail.everyone=1) OR (mail.alliance_id=" + alliance_id + ") ) AND mail.mail_id>" + mail_id + " ORDER BY mail.mail_id DESC";

                using (SqlCommand cmd = new SqlCommand(strSql, cn))
                {
                    cn.Open();

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                    return new MemoryStream(returnBytes);
                }
            }
        }
        else
        {
            string result = "Data format incorrect";
            WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            byte[] returnBytes2 = encoding.GetBytes(result);
            return new MemoryStream(returnBytes2);
        }
    }
    
    [WebGet(UriTemplate = "GetMailReply/{mail_id}")]
    public Stream GetMailReply(string mail_id)
    {
        if(ulong.Parse(mail_id) >= 0) 
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string strSql = string.Empty;
                strSql = "SELECT * FROM mail_reply WHERE mail_id=" + mail_id + " ORDER BY reply_id ASC";

                using (SqlCommand cmd = new SqlCommand(strSql, cn))
                {
                    cn.Open();

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                    return new MemoryStream(returnBytes);
                }
            }   
        }
        else
        {
            string result = "Data format incorrect";
            WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            byte[] returnBytes2 = encoding.GetBytes(result);
            return new MemoryStream(returnBytes2);
        }
    }
	
	[WebGet(UriTemplate = "GetChat/{last_chat_id}")]
    public Stream GetChat(string last_chat_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            last_chat_id = last_chat_id.Replace(",", "");
            if (last_chat_id != "0")
            {
                strSql = "SELECT * FROM chat WHERE chat_id>" + last_chat_id + " ORDER BY chat_id ASC";
            }
            else
            {
                strSql = "SELECT * FROM (SELECT TOP 10 * FROM chat ORDER BY chat_id DESC) AS TOP10 ORDER BY chat_id ASC";
            }

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceChat/{last_chat_id}/{alliance_id}")]
    public Stream GetAllianceChat(string last_chat_id, string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = string.Empty;
            last_chat_id = last_chat_id.Replace(",", "");
            if (last_chat_id != "0")
            {
                strSql = "SELECT * FROM alliance_chat WHERE target_alliance_id=" + alliance_id + " AND chat_id>" + last_chat_id + " ORDER BY chat_id ASC";
            }
            else
            {
                strSql = "SELECT * FROM (SELECT TOP 10 * FROM alliance_chat WHERE target_alliance_id=" + alliance_id + " ORDER BY chat_id DESC) AS TOP10 ORDER BY chat_id ASC";
            }

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceWall/{alliance_id}")]
    public Stream GetAllianceWall(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string strSql = "SELECT * FROM alliance_wall WHERE target_alliance_id=" + alliance_id + " ORDER BY chat_id ASC";

            using (SqlCommand cmd = new SqlCommand(strSql, cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [OperationContract]
	[WebInvoke(UriTemplate="/PostChat", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public string PostChat(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string profile_id = dic["profile_id"];
    	string profile_name = dic["profile_name"];
    	string profile_face = dic["profile_face"];
        string message = dic["message"];
    	string alliance_id = dic["alliance_id"];
    	string alliance_tag = dic["alliance_tag"];
    	string alliance_logo = dic["alliance_logo"];
    	string target_alliance_id = dic["target_alliance_id"];
    	string table_name = dic["table_name"];

        int int_alliance_id;
        int int_alliance_logo;
        int int_target_alliance_id;

	    if (!int.TryParse(alliance_id, out int_alliance_id))
	    {
	    	alliance_id = "0";
	    }

        if (!int.TryParse(alliance_logo, out int_alliance_logo))
	    {
	    	alliance_logo = "0";
	    }

        if (!int.TryParse(target_alliance_id, out int_target_alliance_id))
	    {
	    	target_alliance_id = "0";
	    }
        
        int chat_id = 0;
        string result = "";
        
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_PostChat", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@table_name", SqlDbType.VarChar).Value = table_name;
                cmd1.Parameters.Add("@poster_profile_id", SqlDbType.Int).Value = profile_id;
                cmd1.Parameters.Add("@poster_profile_name", SqlDbType.VarChar).Value = profile_name;
                cmd1.Parameters.Add("@poster_profile_face", SqlDbType.Int).Value = profile_face;
                cmd1.Parameters.Add("@message", SqlDbType.VarChar).Value = message;
                cmd1.Parameters.Add("@poster_alliance_id", SqlDbType.Int).Value = alliance_id;
                cmd1.Parameters.Add("@poster_alliance_tag", SqlDbType.VarChar).Value = alliance_tag;
                cmd1.Parameters.Add("@poster_alliance_logo", SqlDbType.Int).Value = alliance_logo;
                cmd1.Parameters.Add("@target_alliance_id", SqlDbType.Int).Value = target_alliance_id;
                
                cmd1.Parameters.Add("@chat_id", SqlDbType.Int);
                cmd1.Parameters["@chat_id"].Direction = ParameterDirection.Output;
                
                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                cmd1.ExecuteNonQuery();
                
                chat_id = (int)cmd1.Parameters["@chat_id"].Value;
            }
            
            if (String.Equals(table_name, "alliance_wall"))
            {
                if (chat_id > 0)
                {
                    result = "1";                
                }
                else
                {
                    result = "-1";
                }
            }
            else if (String.Equals(table_name, "chat"))
            {
                if (chat_id > 0)
                {
                    connectionHub.Clients.All.chat_kingdom(profile_id, profile_name, profile_face, message, alliance_id, alliance_tag, alliance_logo, target_alliance_id,chat_id.ToString());
                    result = "1";                
                }
                else
                {
                    result = "-1";
                }
            }
            else if (String.Equals(table_name, "alliance_chat"))
            {
                if (chat_id > 0)
                {
                    connectionHub.Clients.Group("a" + alliance_id).chat_alliance(profile_id, profile_name, profile_face, message, alliance_id, alliance_tag, alliance_logo, target_alliance_id,chat_id.ToString());
                    result = "1";                
                }
                else
                {
                    result = "-1";
                }
            }
            
            cn.Close();
        }
        
        return result;
	}
    
    [WebGet(UriTemplate = "DeleteMail/{mail_id}/{profile_id}")]
    public Stream DeleteMail(string mail_id, string profile_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_MailDelete", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;
                cmd1.Parameters.Add("@mail_id", SqlDbType.Int).Value = mail_id;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
	
	[OperationContract]
    [WebInvoke(UriTemplate = "/PostMailReply", Method = "POST", BodyStyle = WebMessageBodyStyle.WrappedRequest)]
	public Stream PostMailReply(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string profile_id = dic["profile_id"];
    	string profile_name = dic["profile_name"];
        string profile_face = dic["profile_face"];
        string message = dic["message"];
    	string mail_id = dic["mail_id"];
    	string from_id = dic["from_id"];
    	string reply_counter = dic["reply_counter"];

        string to_id = dic["to_id"];
        string is_alliance = dic["is_alliance"];

        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_MailReply", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;
                cmd1.Parameters.Add("@profile_name", SqlDbType.VarChar).Value = profile_name;
                cmd1.Parameters.Add("@profile_face", SqlDbType.Int).Value = profile_face;
                cmd1.Parameters.Add("@message", SqlDbType.VarChar).Value = message;
                cmd1.Parameters.Add("@mail_id", SqlDbType.Int).Value = mail_id;
                cmd1.Parameters.Add("@from_id", SqlDbType.Int).Value = from_id;
                cmd1.Parameters.Add("@reply_counter", SqlDbType.Int).Value = reply_counter;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();

                    if (is_alliance.Equals("1"))
                    {
                        connectionHub.Clients.Group("a" + to_id).mail_reply(profile_id, profile_name, profile_face, message, mail_id, from_id, reply_counter, to_id, is_alliance);
                    }
                    else
                    {
                        connectionHub.Clients.Group("p" + from_id).mail_reply(profile_id, profile_name, profile_face, message, mail_id, from_id, reply_counter, to_id, is_alliance);

                        connectionHub.Clients.Group("p" + to_id).mail_reply(profile_id, profile_name, profile_face, message, mail_id, from_id, reply_counter, to_id, is_alliance);
                    }
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostMailCompose", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostMailCompose(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string profile_id = dic["profile_id"];
    	string profile_name = dic["profile_name"];
        string profile_face = dic["profile_face"];
        string message = dic["message"];
    	string to_id = dic["to_id"];
    	string to_name = dic["to_name"];
        string is_alliance = dic["is_alliance"];

        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_MailCompose", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;
                cmd1.Parameters.Add("@profile_name", SqlDbType.VarChar).Value = profile_name;
                cmd1.Parameters.Add("@profile_face", SqlDbType.Int).Value = profile_face;
                cmd1.Parameters.Add("@message", SqlDbType.VarChar).Value = message;
                cmd1.Parameters.Add("@to_id", SqlDbType.Int).Value = to_id;
                cmd1.Parameters.Add("@to_name", SqlDbType.VarChar).Value = to_name;
                cmd1.Parameters.Add("@is_alliance", SqlDbType.Int).Value = is_alliance;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }

        if (is_alliance.Equals("0"))
    	{
            connectionHub.Clients.Group("p" + to_id).mail_send(result, profile_id, profile_name, profile_face, message, to_id, to_name, is_alliance, String.Format("{0:dd/MM/yyyy HH:mm:ss}", DateTime.UtcNow));
        }
    	else
    	{
            connectionHub.Clients.Group("a" + to_id).mail_send(result, profile_id, profile_name, profile_face, message, to_id, to_name, is_alliance, String.Format("{0:dd/MM/yyyy HH:mm:ss}", DateTime.UtcNow));
    	}

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostAllianceName", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostAllianceName(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string uid = dic["profile_uid"];
    	string a_id = dic["alliance_id"];
    	string text = dic["text"];
    	
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceName", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = a_id;
        		cmd1.Parameters.Add("@text", SqlDbType.VarChar).Value = text;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostAllianceTag", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostAllianceTag(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string uid = dic["profile_uid"];
    	string a_id = dic["alliance_id"];
    	string text = dic["text"];
    	
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceTag", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = a_id;
        		cmd1.Parameters.Add("@text", SqlDbType.VarChar).Value = text;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostAllianceMarquee", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostAllianceMarquee(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string uid = dic["profile_uid"];
    	string a_id = dic["alliance_id"];
    	string text = dic["text"];
    	
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceMarquee", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = a_id;
        		cmd1.Parameters.Add("@text", SqlDbType.VarChar).Value = text;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostAllianceDescription", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostAllianceDescription(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string uid = dic["profile_uid"];
    	string a_id = dic["alliance_id"];
    	string text = dic["text"];
    	
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceDescription", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = a_id;
        		cmd1.Parameters.Add("@text", SqlDbType.VarChar).Value = text;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}

    [OperationContract]
	[WebInvoke(UriTemplate="/AttackFormula", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream AttackFormula(Stream streamdata)
    {
        StreamReader reader = new StreamReader(streamdata);
        string json = reader.ReadToEnd();
        reader.Close();
        reader.Dispose();

        Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);

        string is_capture = dic["is_capture"];
        string is_npc = dic["is_npc"];
        string village_shared_defense_bonus = dic["village_shared_defense_bonus"];
        string p1_research_life = dic["p1_research_life"];
        string p1_hero_life = dic["p1_hero_life"];
        string p1_item_attack = dic["p1_item_attack"];
        string p1_research_attack = dic["p1_research_attack"];
        string p1_research_a_attack = dic["p1_research_a_attack"];
        string p1_research_b_attack = dic["p1_research_b_attack"];
        string p1_research_c_attack = dic["p1_research_c_attack"];
        string p1_research_d_attack = dic["p1_research_d_attack"];
        string p1_hero_attack = dic["p1_hero_attack"];
        string p1_hero_a_attack = dic["p1_hero_a_attack"];
        string p1_hero_b_attack = dic["p1_hero_b_attack"];
        string p1_hero_c_attack = dic["p1_hero_c_attack"];
        string p1_hero_d_attack = dic["p1_hero_d_attack"];
        string p1_a1 = dic["p1_a1"];
        string p1_b1 = dic["p1_b1"];
        string p1_c1 = dic["p1_c1"];
        string p1_d1 = dic["p1_d1"];
        string p1_a2 = dic["p1_a2"];
        string p1_b2 = dic["p1_b2"];
        string p1_c2 = dic["p1_c2"];
        string p1_d2 = dic["p1_d2"];
        string p1_a3 = dic["p1_a3"];
        string p1_b3 = dic["p1_b3"];
        string p1_c3 = dic["p1_c3"];
        string p1_d3 = dic["p1_d3"];
        string p2_research_life = dic["p2_research_life"];
        string p2_hero_life = dic["p2_hero_life"];
        string p2_item_defense = dic["p2_item_defense"];
        string p2_research_defense = dic["p2_research_defense"];
        string p2_hero_defense = dic["p2_hero_defense"];
        string p2_wall = dic["p2_wall"];
        string p2_total_villages = dic["p2_total_bases"];
        string p2_base_type = dic["p2_base_type"];
        string p2_a1 = dic["p2_a1"];
        string p2_b1 = dic["p2_b1"];
        string p2_c1 = dic["p2_c1"];
        string p2_d1 = dic["p2_d1"];
        string p2_a2 = dic["p2_a2"];
        string p2_b2 = dic["p2_b2"];
        string p2_c2 = dic["p2_c2"];
        string p2_d2 = dic["p2_d2"];
        string p2_a3 = dic["p2_a3"];
        string p2_b3 = dic["p2_b3"];
        string p2_c3 = dic["p2_c3"];
        string p2_d3 = dic["p2_d3"];
        string r2_a1 = dic["r2_a1"];
        string r2_b1 = dic["r2_b1"];
        string r2_c1 = dic["r2_c1"];
        string r2_d1 = dic["r2_d1"];
        string r2_a2 = dic["r2_a2"];
        string r2_b2 = dic["r2_b2"];
        string r2_c2 = dic["r2_c2"];
        string r2_d2 = dic["r2_d2"];
        string r2_a3 = dic["r2_a3"];
        string r2_b3 = dic["r2_b3"];
        string r2_c3 = dic["r2_c3"];
        string r2_d3 = dic["r2_d3"];

        string result = "1";

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_AttackFormula", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                
                cmd1.Parameters.Add("@tutorial_step", SqlDbType.Int).Value = "0";
                cmd1.Parameters.Add("@report_test", SqlDbType.Int).Value = "1";
                cmd1.Parameters.Add("@is_capture", SqlDbType.Int).Value = is_capture;
                cmd1.Parameters.Add("@is_npc", SqlDbType.Int).Value = is_npc;
                cmd1.Parameters.Add("@village_shared_defense_bonus", SqlDbType.Float).Value = village_shared_defense_bonus;

                cmd1.Parameters.Add("@p1_research_life", SqlDbType.Float).Value = p1_research_life;
                cmd1.Parameters.Add("@p1_hero_life", SqlDbType.Float).Value = p1_hero_life;
                cmd1.Parameters.Add("@p1_item_attack", SqlDbType.Float).Value = p1_item_attack;
                cmd1.Parameters.Add("@p1_research_attack", SqlDbType.Float).Value = p1_research_attack;
                cmd1.Parameters.Add("@p1_research_a_attack", SqlDbType.Float).Value = p1_research_a_attack;
                cmd1.Parameters.Add("@p1_research_b_attack", SqlDbType.Float).Value = p1_research_b_attack;
                cmd1.Parameters.Add("@p1_research_c_attack", SqlDbType.Float).Value = p1_research_c_attack;
                cmd1.Parameters.Add("@p1_research_d_attack", SqlDbType.Float).Value = p1_research_d_attack;
                cmd1.Parameters.Add("@p1_hero_attack", SqlDbType.Float).Value = p1_hero_attack;
                cmd1.Parameters.Add("@p1_hero_a_attack", SqlDbType.Float).Value = p1_hero_a_attack;
                cmd1.Parameters.Add("@p1_hero_b_attack", SqlDbType.Float).Value = p1_hero_b_attack;
                cmd1.Parameters.Add("@p1_hero_c_attack", SqlDbType.Float).Value = p1_hero_c_attack;
                cmd1.Parameters.Add("@p1_hero_d_attack", SqlDbType.Float).Value = p1_hero_d_attack;

                cmd1.Parameters.Add("@p1_a1", SqlDbType.Int).Value = p1_a1;
                cmd1.Parameters.Add("@p1_b1", SqlDbType.Int).Value = p1_b1;
                cmd1.Parameters.Add("@p1_c1", SqlDbType.Int).Value = p1_c1;
                cmd1.Parameters.Add("@p1_d1", SqlDbType.Int).Value = p1_d1;
                cmd1.Parameters.Add("@p1_a2", SqlDbType.Int).Value = p1_a2;
                cmd1.Parameters.Add("@p1_b2", SqlDbType.Int).Value = p1_b2;
                cmd1.Parameters.Add("@p1_c2", SqlDbType.Int).Value = p1_c2;
                cmd1.Parameters.Add("@p1_d2", SqlDbType.Int).Value = p1_d2;
                cmd1.Parameters.Add("@p1_a3", SqlDbType.Int).Value = p1_a3;
                cmd1.Parameters.Add("@p1_b3", SqlDbType.Int).Value = p1_b3;
                cmd1.Parameters.Add("@p1_c3", SqlDbType.Int).Value = p1_c3;
                cmd1.Parameters.Add("@p1_d3", SqlDbType.Int).Value = p1_d3;

                cmd1.Parameters.Add("@p2_research_life", SqlDbType.Float).Value = p2_research_life;
                cmd1.Parameters.Add("@p2_hero_life", SqlDbType.Float).Value = p2_hero_life;
                cmd1.Parameters.Add("@p2_item_defense", SqlDbType.Float).Value = p2_item_defense;
                cmd1.Parameters.Add("@p2_research_defense", SqlDbType.Float).Value = p2_research_defense;
                cmd1.Parameters.Add("@p2_hero_defense", SqlDbType.Float).Value = p2_hero_defense;
                cmd1.Parameters.Add("@p2_wall", SqlDbType.Int).Value = p2_wall;
                cmd1.Parameters.Add("@p2_total_villages", SqlDbType.Int).Value = p2_total_villages;
                cmd1.Parameters.Add("@p2_base_type", SqlDbType.Int).Value = p2_base_type;

                cmd1.Parameters.Add("@p2_a1", SqlDbType.Int).Value = p2_a1;
                cmd1.Parameters.Add("@p2_b1", SqlDbType.Int).Value = p2_b1;
                cmd1.Parameters.Add("@p2_c1", SqlDbType.Int).Value = p2_c1;
                cmd1.Parameters.Add("@p2_d1", SqlDbType.Int).Value = p2_d1;
                cmd1.Parameters.Add("@p2_a2", SqlDbType.Int).Value = p2_a2;
                cmd1.Parameters.Add("@p2_b2", SqlDbType.Int).Value = p2_b2;
                cmd1.Parameters.Add("@p2_c2", SqlDbType.Int).Value = p2_c2;
                cmd1.Parameters.Add("@p2_d2", SqlDbType.Int).Value = p2_d2;
                cmd1.Parameters.Add("@p2_a3", SqlDbType.Int).Value = p2_a3;
                cmd1.Parameters.Add("@p2_b3", SqlDbType.Int).Value = p2_b3;
                cmd1.Parameters.Add("@p2_c3", SqlDbType.Int).Value = p2_c3;
                cmd1.Parameters.Add("@p2_d3", SqlDbType.Int).Value = p2_d3;
                
                cmd1.Parameters.Add("@r2_a1", SqlDbType.Int).Value = r2_a1;
                cmd1.Parameters.Add("@r2_b1", SqlDbType.Int).Value = r2_b1;
                cmd1.Parameters.Add("@r2_c1", SqlDbType.Int).Value = r2_c1;
                cmd1.Parameters.Add("@r2_d1", SqlDbType.Int).Value = r2_d1;
                cmd1.Parameters.Add("@r2_a2", SqlDbType.Int).Value = r2_a2;
                cmd1.Parameters.Add("@r2_b2", SqlDbType.Int).Value = r2_b2;
                cmd1.Parameters.Add("@r2_c2", SqlDbType.Int).Value = r2_c2;
                cmd1.Parameters.Add("@r2_d2", SqlDbType.Int).Value = r2_d2;
                cmd1.Parameters.Add("@r2_a3", SqlDbType.Int).Value = r2_a3;
                cmd1.Parameters.Add("@r2_b3", SqlDbType.Int).Value = r2_b3;
                cmd1.Parameters.Add("@r2_c3", SqlDbType.Int).Value = r2_c3;
                cmd1.Parameters.Add("@r2_d3", SqlDbType.Int).Value = r2_d3;

                //OUTPUTS
                cmd1.Parameters.Add("@k1_a1", SqlDbType.Int);
                cmd1.Parameters["@k1_a1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_b1", SqlDbType.Int);
                cmd1.Parameters["@k1_b1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_c1", SqlDbType.Int);
                cmd1.Parameters["@k1_c1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_d1", SqlDbType.Int);
                cmd1.Parameters["@k1_d1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_a2", SqlDbType.Int);
                cmd1.Parameters["@k1_a2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_b2", SqlDbType.Int);
                cmd1.Parameters["@k1_b2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_c2", SqlDbType.Int);
                cmd1.Parameters["@k1_c2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_d2", SqlDbType.Int);
                cmd1.Parameters["@k1_d2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_a3", SqlDbType.Int);
                cmd1.Parameters["@k1_a3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_b3", SqlDbType.Int);
                cmd1.Parameters["@k1_b3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_c3", SqlDbType.Int);
                cmd1.Parameters["@k1_c3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k1_d3", SqlDbType.Int);
                cmd1.Parameters["@k1_d3"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@k2_a1", SqlDbType.Int);
                cmd1.Parameters["@k2_a1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_b1", SqlDbType.Int);
                cmd1.Parameters["@k2_b1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_c1", SqlDbType.Int);
                cmd1.Parameters["@k2_c1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_d1", SqlDbType.Int);
                cmd1.Parameters["@k2_d1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_a2", SqlDbType.Int);
                cmd1.Parameters["@k2_a2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_b2", SqlDbType.Int);
                cmd1.Parameters["@k2_b2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_c2", SqlDbType.Int);
                cmd1.Parameters["@k2_c2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_d2", SqlDbType.Int);
                cmd1.Parameters["@k2_d2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_a3", SqlDbType.Int);
                cmd1.Parameters["@k2_a3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_b3", SqlDbType.Int);
                cmd1.Parameters["@k2_b3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_c3", SqlDbType.Int);
                cmd1.Parameters["@k2_c3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@k2_d3", SqlDbType.Int);
                cmd1.Parameters["@k2_d3"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@i2_a1", SqlDbType.Int);
                cmd1.Parameters["@i2_a1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_b1", SqlDbType.Int);
                cmd1.Parameters["@i2_b1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_c1", SqlDbType.Int);
                cmd1.Parameters["@i2_c1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_d1", SqlDbType.Int);
                cmd1.Parameters["@i2_d1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_a2", SqlDbType.Int);
                cmd1.Parameters["@i2_a2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_b2", SqlDbType.Int);
                cmd1.Parameters["@i2_b2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_c2", SqlDbType.Int);
                cmd1.Parameters["@i2_c2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_d2", SqlDbType.Int);
                cmd1.Parameters["@i2_d2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_a3", SqlDbType.Int);
                cmd1.Parameters["@i2_a3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_b3", SqlDbType.Int);
                cmd1.Parameters["@i2_b3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_c3", SqlDbType.Int);
                cmd1.Parameters["@i2_c3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@i2_d3", SqlDbType.Int);
                cmd1.Parameters["@i2_d3"].Direction = ParameterDirection.Output;
                
                cmd1.Parameters.Add("@rk2_a1", SqlDbType.Int);
                cmd1.Parameters["@rk2_a1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_b1", SqlDbType.Int);
                cmd1.Parameters["@rk2_b1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_c1", SqlDbType.Int);
                cmd1.Parameters["@rk2_c1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_d1", SqlDbType.Int);
                cmd1.Parameters["@rk2_d1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_a2", SqlDbType.Int);
                cmd1.Parameters["@rk2_a2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_b2", SqlDbType.Int);
                cmd1.Parameters["@rk2_b2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_c2", SqlDbType.Int);
                cmd1.Parameters["@rk2_c2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_d2", SqlDbType.Int);
                cmd1.Parameters["@rk2_d2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_a3", SqlDbType.Int);
                cmd1.Parameters["@rk2_a3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_b3", SqlDbType.Int);
                cmd1.Parameters["@rk2_b3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_c3", SqlDbType.Int);
                cmd1.Parameters["@rk2_c3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@rk2_d3", SqlDbType.Int);
                cmd1.Parameters["@rk2_d3"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@p1_troops", SqlDbType.Int);
                cmd1.Parameters["@p1_troops"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@p1_injured", SqlDbType.Int);
                cmd1.Parameters["@p1_injured"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@p1_killed", SqlDbType.Int);
                cmd1.Parameters["@p1_killed"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@p1_hero_xp_gain", SqlDbType.Int);
                cmd1.Parameters["@p1_hero_xp_gain"].Direction = ParameterDirection.Output;
                
                cmd1.Parameters.Add("@r1_troops", SqlDbType.Int);
                cmd1.Parameters["@r1_troops"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@r1_injured", SqlDbType.Int);
                cmd1.Parameters["@r1_injured"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@r1_killed", SqlDbType.Int);
                cmd1.Parameters["@r1_killed"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@p2_troops", SqlDbType.Int);
                cmd1.Parameters["@p2_troops"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@p2_injured", SqlDbType.Int);
                cmd1.Parameters["@p2_injured"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@p2_killed", SqlDbType.Int);
                cmd1.Parameters["@p2_killed"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@p2_hero_xp_gain", SqlDbType.Int);
                cmd1.Parameters["@p2_hero_xp_gain"].Direction = ParameterDirection.Output;
                
                cmd1.Parameters.Add("@r2_troops", SqlDbType.Int);
                cmd1.Parameters["@r2_troops"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@r2_injured", SqlDbType.Int);
                cmd1.Parameters["@r2_injured"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@r2_killed", SqlDbType.Int);
                cmd1.Parameters["@r2_killed"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@r1", SqlDbType.Int);
                cmd1.Parameters["@r1"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@r2", SqlDbType.Int);
                cmd1.Parameters["@r2"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@r3", SqlDbType.Int);
                cmd1.Parameters["@r3"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@r4", SqlDbType.Int);
                cmd1.Parameters["@r4"].Direction = ParameterDirection.Output;
                cmd1.Parameters.Add("@r5", SqlDbType.Int);
                cmd1.Parameters["@r5"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@victory", SqlDbType.Int);
                cmd1.Parameters["@victory"].Direction = ParameterDirection.Output;

                cmd1.ExecuteNonQuery();
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);

    }
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostAllianceCreate", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostAllianceCreate(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string uid = dic["profile_uid"];
    	string name = dic["name"];
    	string tag = dic["tag"];
    	string mq = dic["marquee"];
    	
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceCreate", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@alliance_name", SqlDbType.VarChar).Value = name;
        		cmd1.Parameters.Add("@alliance_tag", SqlDbType.VarChar).Value = tag;
        		cmd1.Parameters.Add("@alliance_marquee", SqlDbType.VarChar).Value = mq;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
	
	[WebGet(UriTemplate = "GetEventSolo")]
    public Stream GetEventSolo()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM event_solo WHERE event_starting < GETUTCDATE() AND event_active = 1 ORDER BY event_id DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventAlliance")]
    public Stream GetEventAlliance()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM event_alliance WHERE event_starting < GETUTCDATE() AND event_active = 1 ORDER BY event_id DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventSoloNow")]
    public Stream GetEventSoloNow()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT TOP(20) profile_id, profile_name, alliance_id, profile_face, xp_gain FROM profile ORDER BY xp_gain DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventAllianceNow")]
    public Stream GetEventAllianceNow()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT TOP(20) * FROM View_AllianceEvent ORDER BY xp_gain DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventSoloResult/{event_id}")]
    public Stream GetEventSoloResult(string event_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd1 = new SqlCommand("EXECUTE usp_EventSoloResult", cn))
            {
                cn.Open();
                cmd1.ExecuteNonQuery();
        	}
        	
            using (SqlCommand cmd = new SqlCommand(@"SELECT TOP(20) profile_id, profile_name, alliance_id, profile_face, xp, xp_history as xp_gain FROM profile ORDER BY xp_history DESC", cn))
            {
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetEventAllianceResult/{event_id}")]
    public Stream GetEventAllianceResult(string event_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	using (SqlCommand cmd1 = new SqlCommand("EXECUTE usp_EventAllianceResult", cn))
            {
                cn.Open();
                cmd1.ExecuteNonQuery();
        	}
        	
            using (SqlCommand cmd = new SqlCommand(@"SELECT TOP(20) * FROM View_AllianceEventResult ORDER BY xp_gain DESC", cn))
            {
                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetSales")]
    public Stream GetSales()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM sales WHERE sale_starting < GETUTCDATE() AND sale_ending > GETUTCDATE() ORDER BY sale_id DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }

    [WebGet(UriTemplate = "GetSalesItems/{sale_id}")]
    public Stream GetSalesItems(string sale_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT sales_items.sale_id, sales_items.item_id, sales_items.quantity, item.item_name, item.item_image FROM sales_items INNER JOIN item ON sales_items.item_id=item.item_id WHERE sales_items.sale_id=" + sale_id, cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceDetail/{alliance_id}")]
    public Stream GetAllianceDetail(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	//SELECT *, row_number() over (order by power desc) as rank FROM View_Alliance
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_Alliance WHERE alliance_id=" + alliance_id, cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceMembers/{alliance_id}")]
    public Stream GetAllianceMembers(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT profile_id, profile_name, xp, kills, profile_face, alliance_rank FROM profile WHERE alliance_id=" + alliance_id + " ORDER BY xp DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceEvents/{alliance_id}")]
    public Stream GetAllianceEvents(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT TOP 20 * FROM alliance_event WHERE alliance_id=" + alliance_id + " ORDER BY event_id DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetAllianceDonations/{alliance_id}")]
    public Stream GetAllianceDonations(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT profile_id, max(profile_face) profile_face, max(profile_name) profile_name, SUM(currency_second) AS currency_second FROM alliance_donation WHERE alliance_id=" + alliance_id + " GROUP BY profile_id ORDER BY currency_second DESC", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
       
    [WebGet(UriTemplate = "GetAllianceApply/{alliance_id}")]
    public Stream GetAllianceApply(string alliance_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT DISTINCT * FROM View_AllianceApplyProfile WHERE alliance_id=" + alliance_id, cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    //
    // Stored Proc begins here
    //

    [WebGet(UriTemplate = "SendSpies/{uid}/{base_id}/{to_profile_id}/{to_base_id}/{spy}/{march_time}")]
    public Stream SendSpies(string uid, string base_id, string to_profile_id, string to_base_id, string spy, string march_time)
    {
        string result = "0";
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_SendSpies", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
                cmd1.Parameters.Add("@to_profile_id", SqlDbType.Int).Value = to_profile_id;
                cmd1.Parameters.Add("@to_base_id", SqlDbType.Int).Value = to_base_id;
                cmd1.Parameters.Add("@spy_sent", SqlDbType.Int).Value = spy;
                cmd1.Parameters.Add("@march_time", SqlDbType.Int).Value = march_time;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@quest_done", SqlDbType.Int);
                cmd1.Parameters["@quest_done"].Direction = ParameterDirection.Output;

                try
                {
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                    ret = 1;
                    if (ret == 1)
                    {
                        connectionHub.Clients.Group("p" + to_profile_id).send_spies(spy);

                        byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt)); //if success return a dict
                        return new MemoryStream(returnBytes);
                    }
                    else //Spy process failed
                    {
                        byte[] returnBytes2 = encoding.GetBytes(result);
                        return new MemoryStream(returnBytes2);
                    }
                    
                }
                catch (Exception ex)
                {
                    result="exception :"+ex.ToString();
                    byte[] returnBytes3 = encoding.GetBytes(result);
                    return new MemoryStream(returnBytes3);
                }

                int quest_done = (int)cmd1.Parameters["@quest_done"].Value;
                if (quest_done > 0)
                {
                    connectionHub.Clients.Group("u" + uid).quest_done(quest_done.ToString());
                }
            }
        }
    }
    
    [WebGet(UriTemplate = "SendTroops/{uid}/{base_id}/{to_profile_id}/{to_base_id}/{usp}/{hero}/{a1}/{b1}/{c1}/{d1}/{a2}/{b2}/{c2}/{d2}/{a3}/{b3}/{c3}/{d3}/{march_time}")]
    public Stream SendTroops(string uid, string base_id, string to_profile_id, string to_base_id, string usp, string hero, string a1, string b1, string c1, string d1, string a2, string b2, string c2, string d2, string a3, string b3, string c3, string d3, string march_time)
    {
       return SendTroopsExtended(uid,base_id,to_profile_id,to_base_id,usp,hero, a1, b1, c1, d1, a2, b2, c2, d2, a3, b3, c3, d3, march_time, "0");
    }
    
    [WebGet(UriTemplate = "SendTroopsExtended/{uid}/{base_id}/{to_profile_id}/{to_base_id}/{usp}/{hero}/{a1}/{b1}/{c1}/{d1}/{a2}/{b2}/{c2}/{d2}/{a3}/{b3}/{c3}/{d3}/{march_time}/{tutorial_step}")]
    public Stream SendTroopsExtended(string uid, string base_id, string to_profile_id, string to_base_id, string usp, string hero, string a1, string b1, string c1, string d1, string a2, string b2, string c2, string d2, string a3, string b3, string c3, string d3, string march_time,string tutorial_step)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            string sp_name = usp;
            if(String.Equals(usp, "usp_SendCapture"))
            {
                sp_name = "usp_SendAttack";
            }
            
            using (SqlCommand cmd1 = new SqlCommand(sp_name, cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
                cmd1.Parameters.Add("@to_profile_id", SqlDbType.Int).Value = to_profile_id;
                cmd1.Parameters.Add("@to_base_id", SqlDbType.Int).Value = to_base_id;

                cmd1.Parameters.Add("@hero", SqlDbType.Int).Value = hero;

                cmd1.Parameters.Add("@a1", SqlDbType.Int).Value = a1;
                cmd1.Parameters.Add("@b1", SqlDbType.Int).Value = b1;
                cmd1.Parameters.Add("@c1", SqlDbType.Int).Value = c1;
                cmd1.Parameters.Add("@d1", SqlDbType.Int).Value = d1;

                cmd1.Parameters.Add("@a2", SqlDbType.Int).Value = a2;
                cmd1.Parameters.Add("@b2", SqlDbType.Int).Value = b2;
                cmd1.Parameters.Add("@c2", SqlDbType.Int).Value = c2;
                cmd1.Parameters.Add("@d2", SqlDbType.Int).Value = d2;

                cmd1.Parameters.Add("@a3", SqlDbType.Int).Value = a3;
                cmd1.Parameters.Add("@b3", SqlDbType.Int).Value = b3;
                cmd1.Parameters.Add("@c3", SqlDbType.Int).Value = c3;
                cmd1.Parameters.Add("@d3", SqlDbType.Int).Value = d3;

                cmd1.Parameters.Add("@march_time", SqlDbType.Int).Value = march_time;
                
                if (String.Equals(usp, "usp_SendCapture")||String.Equals(usp, "usp_SendAttack"))
                {
                  cmd1.Parameters.Add("@tutorial_step", SqlDbType.Int).Value = tutorial_step;
                }
                
                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@row_id", SqlDbType.Int);
                cmd1.Parameters["@row_id"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@quest_done", SqlDbType.Int);
                cmd1.Parameters["@quest_done"].Direction = ParameterDirection.Output;

                string is_capture = "-1";
                if (String.Equals(usp, "usp_SendCapture"))
                {
                    is_capture = "1";
                }
                else if (String.Equals(usp, "usp_SendAttack"))
                {
                    is_capture = "0";
                }

                if (is_capture != "-1")
                {
                    cmd1.Parameters.Add("@is_capture", SqlDbType.Int).Value = is_capture;
                }

                try
                {
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();

                    int row_id = (int)cmd1.Parameters["@row_id"].Value;
                    string background_job_id_string ="";
                    int background_job_id =-1;
                    if (ret == 1)
                    {
                        if (String.Equals(usp, "usp_SendReinforcements"))
                        {
                            connectionHub.Clients.Group("p" + to_profile_id).send_reinforce(to_base_id);
                            
                            //Send Push Notification to client
                            Push(to_profile_id, "An ally member has just sent some reinforcements to you!");
                        }
                        else if (String.Equals(usp, "usp_SendAttack") || String.Equals(usp, "usp_SendCapture"))
                        {
                            if (to_profile_id != "0") //Attacking a human player so delay the attack
                            {
                                connectionHub.Clients.Group("p" + to_profile_id).send_attack(to_base_id, march_time); //Glow borders on victim
                                
                                double march_time_sec = double.Parse(march_time);

                                background_job_id_string = BackgroundJob.Schedule(() => AttackDelay(is_capture, uid, base_id, row_id.ToString(), to_profile_id, to_base_id), TimeSpan.FromSeconds(march_time_sec));
                                //another alternative is to replace attack_id to background_job_id
                                if (Int32.TryParse(background_job_id_string, out background_job_id))
                                {
                                    cmd1.CommandText = "usp_UpdateAttack";
                                    cmd1.Parameters.Clear();
                                    cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                                    cmd1.Parameters.Add("@attack_id", SqlDbType.VarChar).Value = row_id;
                                    cmd1.Parameters.Add("@background_job_id", SqlDbType.Int).Value = background_job_id;
                                    cmd1.Parameters.Add("@r", SqlDbType.Int);
                                    cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                                    adapter = new SqlDataAdapter(cmd1);
                                    DataTable dt2 = new DataTable();
                                    adapter.Fill(dt2);
                                    
                                    ret = (int)cmd1.Parameters["@r"].Value;
                                    
                                }
                                else
                                {
                                    ret=-1;
                                    background_job_id=-2;
                                }
                                
                                result = ret.ToString();

                                //Send Push Notification to client
                                Push(to_profile_id, "An attack has been launched againts to you. Prepare for battle!");
                            }
                        }

                        byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt)); //if success return a dict
                        return new MemoryStream(returnBytes);
                    }
                    else //Send troops failed
                    {
                        byte[] returnBytes2 = encoding.GetBytes(result);
                        return new MemoryStream(returnBytes2);
                    }
                }
                catch (Exception ex)
                {
                    byte[] returnBytes3 = encoding.GetBytes(result);
                    return new MemoryStream(returnBytes3);
                }

                int quest_done = (int)cmd1.Parameters["@quest_done"].Value;
                if (quest_done > 0)
                {
                    connectionHub.Clients.Group("u" + uid).quest_done(quest_done.ToString());
                }

            }
        }

    }

    [AutomaticRetry(Attempts = 0)]
    public void AttackDelay(string is_capture, string uid, string from_base_id, string attack_id, string to_profile_id, string to_base_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_AttackPvp", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@attack_id", SqlDbType.Int).Value = attack_id;
                cmd1.Parameters.Add("@is_capture", SqlDbType.Int).Value = is_capture;
                cmd1.Parameters.Add("@is_victory", SqlDbType.Int);
                cmd1.Parameters["@is_victory"].Direction = ParameterDirection.Output;

                if (is_capture == "1")
                {
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    int is_victory = (int)cmd1.Parameters["@is_victory"].Value;
                    if (is_victory == 1)
                    {
                        connectionHub.Clients.Group("u" + uid).base_gain(to_base_id);

                        if (to_profile_id != "0") //notify owner that his village is taken over
                        {
                            connectionHub.Clients.Group("p" + to_profile_id).base_lost(to_base_id);
                        }

                    }
                }
                else
                {
                    cmd1.ExecuteNonQuery();
                }

            }
        }

        connectionHub.Clients.Group("p" + to_profile_id).send_attack_processed(to_base_id);
        connectionHub.Clients.Group("u" + uid).send_attack_attacker(from_base_id);
    }

    [WebGet(UriTemplate = "SendResources/{uid}/{base_id}/{to_profile_id}/{to_base_id}/{r1}/{r2}/{r3}/{r4}/{r5}/{march_time}")]
    public Stream SendResources(string uid, string base_id, string to_profile_id, string to_base_id, string r1, string r2, string r3, string r4, string r5, string march_time)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_SendResources", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
                cmd1.Parameters.Add("@to_profile_id", SqlDbType.Int).Value = to_profile_id;
                cmd1.Parameters.Add("@to_base_id", SqlDbType.Int).Value = to_base_id;
                cmd1.Parameters.Add("@r1", SqlDbType.Int).Value = r1;
                cmd1.Parameters.Add("@r2", SqlDbType.Int).Value = r2;
                cmd1.Parameters.Add("@r3", SqlDbType.Int).Value = r3;
                cmd1.Parameters.Add("@r4", SqlDbType.Int).Value = r4;
                cmd1.Parameters.Add("@r5", SqlDbType.Int).Value = r5;
                cmd1.Parameters.Add("@march_time", SqlDbType.Int).Value = march_time;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@quest_done", SqlDbType.Int);
                cmd1.Parameters["@quest_done"].Direction = ParameterDirection.Output;

                try
                {
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                    if (ret == 1)
                    {
                        connectionHub.Clients.Group("p" + to_profile_id).send_resources(to_base_id);
                        
                        //Send Push Notification to client
                        Push(to_profile_id, "An ally member has just sent some resources to you!");
                        
                        byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt)); //if success return a dict
                        return new MemoryStream(returnBytes);
                    }
                    else //send failed
                    {
                        byte[] returnBytes2 = encoding.GetBytes(result);
                        return new MemoryStream(returnBytes2);
                    }
                }
                catch (Exception ex)
                {
                    byte[] returnBytes3 = encoding.GetBytes(result);
                    return new MemoryStream(returnBytes3);
                }

                int quest_done = (int)cmd1.Parameters["@quest_done"].Value;
                if (quest_done > 0)
                {
                    connectionHub.Clients.Group("u" + uid).quest_done(quest_done.ToString());
                }

            }
        }
    }

    [WebGet(UriTemplate = "GetProfile/{uid}")]
    public Stream GetProfile(string uid)
    {
        string result = "0";
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
	    
        //Thread.Sleep(TimeSpan.FromSeconds(30));
         
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand(@"SELECT * FROM View_Profile WHERE uid='" + uid + "'", cn))
            {
                cn.Open();

                SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                    return new MemoryStream(returnBytes);
                }
                else
                {
                    //Create new profile and new base on this world
                    using (SqlCommand cmd1 = new SqlCommand("usp_ProfileNew", cn))
                    {
                        cmd1.CommandType = CommandType.StoredProcedure;
                        cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;

                        cmd1.Parameters.Add("@r", SqlDbType.Int);
                        cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                        cmd1.ExecuteNonQuery();
                        
                        int ans = (int)cmd1.Parameters["@r"].Value;
                        
                        if (ans == 1)
                        {
                            return GetProfile(uid);
                        }
                        else
                        {
                            result = "-1";
                        }
                        
                    }
                }

            }
        }

        byte[] returnBytes2 = encoding.GetBytes(result);
        return new MemoryStream(returnBytes2);
    }
    
    [WebGet(UriTemplate = "BuyItem/{uid}/{item_id}")]
    public Stream BuyItem(string uid, string item_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_BuyItem", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@item_id", SqlDbType.Int).Value = item_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "HeroEquip/{uid}/{hero_field}/{item_id}")]
    public Stream HeroEquip(string uid, string hero_field, string item_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_HeroEquip", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@hero_field", SqlDbType.VarChar).Value = hero_field;
        		cmd1.Parameters.Add("@item_id", SqlDbType.Int).Value = item_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "UseItemHeroxp/{uid}/{item_id}")]
    public Stream UseItemHeroxp(string uid, string item_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_UseItemHeroxp", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@item_id", SqlDbType.Int).Value = item_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "UseItemResources/{uid}/{resource_type}/{base_id}/{item_id}")]
    public Stream UseItemResources(string uid, string resource_type, string base_id, string item_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_UseItemResources", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@resource_type", SqlDbType.VarChar).Value = resource_type;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@item_id", SqlDbType.Int).Value = item_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "RecruitSpy/{uid}/{base_id}")]
    public Stream RecruitSpy(string uid, string base_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_RecruitSpy", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "TeleportTo/{uid}/{base_id}/{map_x}/{map_y}")]
    public Stream TeleportTo(string uid, string base_id, string map_x, string map_y)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_TeleportTo", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
                cmd1.Parameters.Add("@map_x", SqlDbType.Int).Value = map_x;
                cmd1.Parameters.Add("@map_y", SqlDbType.Int).Value = map_y;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "DestroyBuilding/{uid}/{base_id}/{location}")]
    public Stream DestroyBuilding(string uid, string base_id, string location)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_DestroyBuilding", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@location", SqlDbType.Int).Value = location;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "BuildBuilding/{uid}/{base_id}/{b_id}/{b_level}/{b_location}")]
    public Stream BuildBuilding(string uid, string base_id, string b_id, string b_level, string b_location)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_BuildBuilding", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@b_id", SqlDbType.Int).Value = b_id;
        		cmd1.Parameters.Add("@b_level", SqlDbType.Int).Value = b_level;
        		cmd1.Parameters.Add("@b_location", SqlDbType.Int).Value = b_location;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@quest_done", SqlDbType.Int);
                cmd1.Parameters["@quest_done"].Direction = ParameterDirection.Output;

        		try
                {
                    cmd1.ExecuteNonQuery();

                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }

                int quest_done = (int)cmd1.Parameters["@quest_done"].Value;
                if (quest_done > 0)
                {
                    connectionHub.Clients.Group("u" + uid).quest_done(quest_done.ToString());
                }

        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "ResearchTech/{uid}/{base_id}/{research_id}")]
    public Stream ResearchTech(string uid, string base_id, string research_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_ResearchTech", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@research_id", SqlDbType.Int).Value = research_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@quest_done", SqlDbType.Int);
                cmd1.Parameters["@quest_done"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }

                int quest_done = (int)cmd1.Parameters["@quest_done"].Value;
                if (quest_done > 0)
                {
                    connectionHub.Clients.Group("u" + uid).quest_done(quest_done.ToString());
                }

        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "HealTroops/{uid}/{base_id}/{a1}/{b1}/{c1}/{d1}/{a2}/{b2}/{c2}/{d2}/{a3}/{b3}/{c3}/{d3}")]
    public Stream HealTroops(string uid, string base_id, string a1, string b1, string c1, string d1, string a2, string b2, string c2, string d2, string a3, string b3, string c3, string d3)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_HealTroops", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		
        		cmd1.Parameters.Add("@a1", SqlDbType.Int).Value = a1;
        		cmd1.Parameters.Add("@b1", SqlDbType.Int).Value = b1;
        		cmd1.Parameters.Add("@c1", SqlDbType.Int).Value = c1;
        		cmd1.Parameters.Add("@d1", SqlDbType.Int).Value = d1;
        		
        		cmd1.Parameters.Add("@a2", SqlDbType.Int).Value = a2;
        		cmd1.Parameters.Add("@b2", SqlDbType.Int).Value = b2;
        		cmd1.Parameters.Add("@c2", SqlDbType.Int).Value = c2;
        		cmd1.Parameters.Add("@d2", SqlDbType.Int).Value = d2;
        		
        		cmd1.Parameters.Add("@a3", SqlDbType.Int).Value = a3;
        		cmd1.Parameters.Add("@b3", SqlDbType.Int).Value = b3;
        		cmd1.Parameters.Add("@c3", SqlDbType.Int).Value = c3;
        		cmd1.Parameters.Add("@d3", SqlDbType.Int).Value = d3;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "TrainTroops/{uid}/{base_id}/{unit_type}/{unit_tier}/{unit_count}")]
    public Stream TrainTroops(string uid, string base_id, string unit_type, string unit_tier, string unit_count)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_TrainTroops", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@unit_type", SqlDbType.VarChar).Value = unit_type;
        		cmd1.Parameters.Add("@unit_tier", SqlDbType.VarChar).Value = unit_tier;
        		cmd1.Parameters.Add("@unit_count", SqlDbType.Int).Value = unit_count;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@quest_done", SqlDbType.Int);
                cmd1.Parameters["@quest_done"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }

                int quest_done = (int)cmd1.Parameters["@quest_done"].Value;
                if (quest_done > 0)
                {
                    connectionHub.Clients.Group("u" + uid).quest_done(quest_done.ToString());
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "ReinforcementsReturn/{uid}/{base_id}/{row_id}/{action_profile_id}")]
    public Stream ReinforcementsReturn(string uid, string base_id, string row_id, string action_profile_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_ReinforcementsReturn", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@row_id", SqlDbType.Int).Value = row_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                    if (ret == 1)
                    {
                        connectionHub.Clients.Group("p" + action_profile_id).reinforcements_return(row_id);
                    }
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }

        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "RecallAttack/{uid}/{base_id}/{item_id}/{type}")]
    public Stream RecallAttack(string uid, string base_id, string item_id, string type)
    {
      string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
            //required to be done here as hangfire function needs to be called
            
        	using (SqlCommand cmd1 = new SqlCommand("usp_RecallAttack", cn))
        	{  
                try
                {
                    cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                    cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
                    cmd1.Parameters.Add("@item_id", SqlDbType.Int).Value = item_id;
                    cmd1.Parameters.Add("@type", SqlDbType.Int).Value = type;
                    
                    cmd1.Parameters.Add("@r", SqlDbType.Int);
                    cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                
                    string background_job_id_string ="";
                    int new_time_span_from_now = (int)cmd1.Parameters["@new_time_span_from_now"].Value;
                    int background_job_id = (int)cmd1.Parameters["@background_job_id"].Value;
                    int attack_id = (int)cmd1.Parameters["@attack_id"].Value;
                    
                    cmd1.ExecuteNonQuery();
                    
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    
                    if(attack_id>=0&&ret==1)//valid attack exist, item available
                    {
                        string is_capture=cmd1.Parameters["@is_capture"].Value.ToString();
                        string from_profile_id=cmd1.Parameters["@from_profile_id"].Value.ToString();
                        string from_base_id=cmd1.Parameters["@from_base_id"].Value.ToString();
                        string to_profile_id=cmd1.Parameters["@to_profile_id"].Value.ToString();
                        string to_base_id=cmd1.Parameters["@to_base_id"].Value.ToString();
                        
                        BackgroundJob.Delete(background_job_id.ToString());
                    }
                    
                    result=ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "SpeedUp/{uid}/{base_id}/{item_id}/{type}")]
    public Stream SpeedUp(string uid, string base_id, string item_id, string type)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
            //required to be done here as hangfire function needs to be called
            
        	using (SqlCommand cmd1 = new SqlCommand("usp_Speedup", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@item_id", SqlDbType.Int).Value = item_id;
        		cmd1.Parameters.Add("@type", SqlDbType.Int).Value = type;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                
                cmd1.Parameters.Add("@new_time_span_from_now", SqlDbType.Int);
        		cmd1.Parameters["@new_time_span_from_now"].Direction = ParameterDirection.Output;
                
                cmd1.Parameters.Add("@attack_id", SqlDbType.Int);
        		cmd1.Parameters["@attack_id"].Direction = ParameterDirection.Output;
                
                cmd1.Parameters.Add("@background_job_id", SqlDbType.Int);
        		cmd1.Parameters["@background_job_id"].Direction = ParameterDirection.Output;
                
                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                    //For speedups that involves hangfire
                    if(ret==2)
                    {
                        string background_job_id_string ="";
                        int new_time_span_from_now = (int)cmd1.Parameters["@new_time_span_from_now"].Value;
                        int background_job_id = (int)cmd1.Parameters["@background_job_id"].Value;
                        string attack_id = cmd1.Parameters["@attack_id"].Value.ToString();
                        
                        //Get data from attack
                        cmd1.CommandText = "usp_GetAttack";
                        cmd1.Parameters.Clear();
                        cmd1.Parameters.Add("@attack_id", SqlDbType.VarChar).Value = attack_id;
                        cmd1.Parameters.Add("@from_profile_id", SqlDbType.Int);
                        cmd1.Parameters["@from_profile_id"].Direction = ParameterDirection.Output;
                        cmd1.Parameters.Add("@from_base_id", SqlDbType.Int);
                        cmd1.Parameters["@from_base_id"].Direction = ParameterDirection.Output;
                        cmd1.Parameters.Add("@to_profile_id", SqlDbType.Int);
                        cmd1.Parameters["@to_profile_id"].Direction = ParameterDirection.Output;
                        cmd1.Parameters.Add("@to_base_id", SqlDbType.Int);
                        cmd1.Parameters["@to_base_id"].Direction = ParameterDirection.Output;
                        cmd1.Parameters.Add("@is_capture", SqlDbType.Int);
                        cmd1.Parameters["@is_capture"].Direction = ParameterDirection.Output;
                        cmd1.Parameters.Add("@r", SqlDbType.Int);
                        cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                        
                        cmd1.ExecuteNonQuery();
                        
                        ret = (int)cmd1.Parameters["@r"].Value;
                        
                        if(ret==1)//valid attack exist
                        {
                            string is_capture=cmd1.Parameters["@is_capture"].Value.ToString();
                            string from_profile_id=cmd1.Parameters["@from_profile_id"].Value.ToString();
                            string from_base_id=cmd1.Parameters["@from_base_id"].Value.ToString();
                            string to_profile_id=cmd1.Parameters["@to_profile_id"].Value.ToString();
                            string to_base_id=cmd1.Parameters["@to_base_id"].Value.ToString();
                            
                            BackgroundJob.Delete(background_job_id.ToString());
                            background_job_id_string = BackgroundJob.Schedule(() => AttackDelay(is_capture, uid ,from_base_id , attack_id, to_profile_id, to_base_id), TimeSpan.FromSeconds(new_time_span_from_now));
                            //another alternative is to replace attack_id to background_job_id
                            if (Int32.TryParse(background_job_id_string, out background_job_id))
                            {
                                cmd1.CommandText = "usp_UpdateAttack";
                                cmd1.Parameters.Clear();
                                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                                cmd1.Parameters.Add("@attack_id", SqlDbType.Int).Value = attack_id;
                                cmd1.Parameters.Add("@background_job_id", SqlDbType.Int).Value = background_job_id;
                                cmd1.Parameters.Add("@r", SqlDbType.Int);
                                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                                cmd1.ExecuteNonQuery();
                                
                                ret = (int)cmd1.Parameters["@r"].Value;
                                
                            }
                            else //failed or invalid background job
                            {
                                ret=-1;
                                background_job_id=-2;
                            }
                        }
                    }
                    if(ret>0)
                    {
                        ret=1;
                    }
                    result=ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "ProfileFace/{uid}/{face_type}")]
    public Stream ProfileFace(string uid, string face_type)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_ProfileFace", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@face_type", SqlDbType.Int).Value = face_type;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "HeroType/{uid}/{type}")]
    public Stream HeroType(string uid, string type)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_HeroType", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@hero_type", SqlDbType.Int).Value = type;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceLogo/{uid}/{logo_type}")]
    public Stream AllianceLogo(string uid, string logo_type)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceLogo", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@logo_type", SqlDbType.Int).Value = logo_type;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
	[OperationContract]
	[WebInvoke(UriTemplate="/PostRenameProfile", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostRenameProfile(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string uid = dic["profile_uid"];
    	string text = dic["text"];
    	
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_RenameProfile", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@text", SqlDbType.VarChar).Value = text;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostRenameHero", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostRenameHero(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string uid = dic["profile_uid"];
    	string text = dic["text"];
    	
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_RenameHero", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@text", SqlDbType.VarChar).Value = text;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
	
	[OperationContract]
	[WebInvoke(UriTemplate="/PostRenameBase", Method="POST", BodyStyle=WebMessageBodyStyle.WrappedRequest)]
	public Stream PostRenameBase(Stream streamdata)
	{
    	StreamReader reader = new StreamReader(streamdata);
    	string json = reader.ReadToEnd();
    	reader.Close();
    	reader.Dispose();
    	
    	Dictionary<string, string> dic = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
    	
    	string uid = dic["profile_uid"];
    	string base_id = dic["base_id"];
    	string text = dic["text"];
        
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_RenameBase", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@text", SqlDbType.VarChar).Value = text;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
	}
    
    [WebGet(UriTemplate = "SpendPoint/{uid}/{hero_field}")]
    public Stream SpendPoint(string uid, string hero_field)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_HeroSpendPoint", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@hero_field", SqlDbType.VarChar).Value = hero_field;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceDonate/{alliance_id}/{profile_uid}/{currency_second}")]
    public Stream AllianceDonate(string alliance_id, string profile_uid, string currency_second)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceDonate", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = profile_uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
        		cmd1.Parameters.Add("@currency_second", SqlDbType.Int).Value = currency_second;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceUpgrade/{alliance_id}/{profile_uid}")]
    public Stream AllianceUpgrade(string alliance_id, string profile_uid)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceUpgrade", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = profile_uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceLeave/{alliance_id}/{profile_uid}")]
    public Stream AllianceLeave(string alliance_id, string profile_uid)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceLeave", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = profile_uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceKick/{alliance_id}/{profile_uid}/{action_profile_id}")]
    public Stream AllianceKick(string alliance_id, string profile_uid, string action_profile_id)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceKick", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = profile_uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
        		cmd1.Parameters.Add("@action_profile_id", SqlDbType.Int).Value = action_profile_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                    if (ret == 1)
                    {
                        connectionHub.Clients.Group("p" + action_profile_id).alliance_kick();
                        
                        //Send Push Notification to client
                        Push(action_profile_id, "Sorry! Your have been kicked out of your current Alliance.");
                    }
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceApply/{alliance_id}/{profile_uid}")]
    public Stream AllianceApply(string alliance_id, string profile_uid)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceApply", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = profile_uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceReject/{alliance_id}/{profile_uid}/{action_profile_id}")]
    public Stream AllianceReject(string alliance_id, string profile_uid, string action_profile_id)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceReject", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = profile_uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
        		cmd1.Parameters.Add("@action_profile_id", SqlDbType.Int).Value = action_profile_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceApprove/{alliance_id}/{profile_uid}/{action_profile_id}")]
    public Stream AllianceApprove(string alliance_id, string profile_uid, string action_profile_id)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceApprove", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = profile_uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
        		cmd1.Parameters.Add("@action_profile_id", SqlDbType.Int).Value = action_profile_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                    if (ret == 1)
                    {
                        connectionHub.Clients.Group("p" + action_profile_id).alliance_approve(alliance_id);
                        
                        //Send Push Notification to client
                        Push(action_profile_id, "Congratulations! Your have been accepted into an Alliance.");
                    }
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }

        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "AllianceTransfer/{alliance_id}/{profile_uid}/{action_profile_id}")]
    public Stream AllianceTransfer(string alliance_id, string profile_uid, string action_profile_id)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_AllianceTransfer", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = profile_uid;
        		cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
        		cmd1.Parameters.Add("@action_profile_id", SqlDbType.Int).Value = action_profile_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "GetQuest/{profile_id}")]
    public Stream GetQuest(string profile_id)
    {
        if (int.Parse(profile_id) > 0)
        {
            using (SqlConnection cn = new SqlConnection(GetConnectionString()))
            {
                string strSql = @"SELECT quest_type.quest_type_id, quest_type.name, quest_type.description, quest_type.reward, quest_type.image_url, quest_type.tutorial, quest_type.quest_group, quest_type.quest_order, 
				quest.quest_id, quest.profile_id, quest.claimed 
                FROM quest_type LEFT JOIN quest ON quest_type.quest_type_id=quest.quest_type_id AND quest_type.valid=1 AND quest.profile_id=" + profile_id +
                @" WHERE quest_type.valid=1 ORDER BY quest_type.quest_group, quest_type.quest_order ASC";
                using (SqlCommand cmd = new SqlCommand(strSql, cn))
                {
                    cn.Open();

                    SqlDataAdapter adapter = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    Encoding encoding = Encoding.UTF8;
                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                    return new MemoryStream(returnBytes);
                }
            }
        }
        else
        {
            string result = "1";
            Encoding encoding = Encoding.UTF8;
            WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
            byte[] returnBytes2 = encoding.GetBytes(result);
            return new MemoryStream(returnBytes2);
        }
    }

    [WebGet(UriTemplate = "ClaimQuest/{profile_id}/{quest_id}/{quest_type_id}")]
    public Stream ClaimQuest(string profile_id, string quest_id, string quest_type_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_ClaimQuest", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;
                cmd1.Parameters.Add("@quest_id", SqlDbType.Int).Value = quest_id;
                cmd1.Parameters.Add("@quest_type_id", SqlDbType.Int).Value = quest_type_id;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetLatestChat")]
    public Stream GetLatestChat()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            int ret=0;
            string chat_type = "";
            int chat_count = 0;  
        
            using (SqlCommand cmd1 = new SqlCommand("usp_GetChat", cn))
            {
                chat_type = "chat";
                chat_count =1;
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@table_name", SqlDbType.VarChar).Value = chat_type;
                cmd1.Parameters.Add("@chat_count", SqlDbType.Int).Value = chat_count;
                cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = 0;
                
                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                
                DataTable dt = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                adapter.Fill(dt);
                
                ret = (int)cmd1.Parameters["@r"].Value;  
                        
                WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                return new MemoryStream(returnBytes);
            }
        }
    }
    
    [WebGet(UriTemplate = "GetNearestVillage/{coordinate_x}/{coordinate_y}")]
    public Stream GetNearestVillage(string coordinate_x,string coordinate_y)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            int ret=0;
        
            using (SqlCommand cmd1 = new SqlCommand("usp_GetNearestVillage", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@coordinate_x", SqlDbType.Int).Value = coordinate_x;
                cmd1.Parameters.Add("@coordinate_y", SqlDbType.Int).Value = coordinate_y;
                /*
                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                */
                DataTable dt = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                    return new MemoryStream(returnBytes);
                }
            }
        }    
        
        return null;
    }
    
    [WebGet(UriTemplate = "UpdatePlayerTutorial/{profile_id}/{tutorial_on}/{last_completed_tutorial_step}")]
    public Stream UpdatePlayerTutorial(string profile_id,string tutorial_on, string last_completed_tutorial_step)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_UpdatePlayerTutorial", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;
                cmd1.Parameters.Add("@tutorial_on", SqlDbType.Int).Value = tutorial_on;
                cmd1.Parameters.Add("@last_completed_tutorial_step", SqlDbType.Int).Value = last_completed_tutorial_step;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
            }
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "DoSlot/{uid}/{token}")]
    public Stream DoSlot(string uid, string token)
    {
    	Random rnd = new Random();
		int random_win = rnd.Next(0, 35);
		
		int input_token = int.Parse(token);
		
		if ((random_win == 8) || (random_win == 10)) //Harder to get jackpot
		{
			random_win = rnd.Next(4, 10);
		}
		
		if ((random_win == 0) || (random_win == 5) || (random_win == 7) || (random_win == 9)) //No Rewards
		{
			random_win = rnd.Next(1, 3);
		}
		
		int total_win = random_win * input_token;
		
		if (random_win > 10) //No Rewards
		{
			total_win = 0;
		}
		
		string result = random_win.ToString();
    	
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            string sql_command = string.Empty;
            
            sql_command = "UPDATE profile SET xp=xp+5, xp_gain=xp_gain+5, xp_gain_a=xp_gain_a+5, currency_second=currency_second-" + token + "+" + total_win.ToString() + " WHERE uid='" + uid + "'";

            using (SqlCommand cmd = new SqlCommand(sql_command, cn))
            {
                cn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "ApplyBoost/{uid}/{base_id}/{item_id}/{type}")]
    public Stream ApplyBoost(string uid, string base_id, string item_id, string type)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
            //required to be done here as hangfire function needs to be called
            
        	using (SqlCommand cmd1 = new SqlCommand("usp_ApplyBoost", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@item_id", SqlDbType.Int).Value = item_id;
        		cmd1.Parameters.Add("@type", SqlDbType.Int).Value = type;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "ApplyProtection/{uid}/{base_id}/{item_id}")]
    public Stream ApplyProtection(string uid, string base_id, string item_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
            //required to be done here as hangfire function needs to be called
            
        	using (SqlCommand cmd1 = new SqlCommand("usp_ApplyProtection", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
        		cmd1.Parameters.Add("@item_id", SqlDbType.Int).Value = item_id;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetMissions/{profile_id}")]
    public Stream GetMissions(string profile_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            int ret = 0;

            using (SqlCommand cmd1 = new SqlCommand("usp_GetMissions", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;

                DataTable dt = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                adapter.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
                    byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt));
                    return new MemoryStream(returnBytes);
                }
            }
        }    
        
        return null;
    }
    
    [WebGet(UriTemplate = "StartMission/{profile_id}/{mission_id}/{mission_duration}")]
    public Stream StartMission(string profile_id, string mission_id, string mission_duration)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_StartMission", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;
        		cmd1.Parameters.Add("@mission_id", SqlDbType.Int).Value = mission_id;
                cmd1.Parameters.Add("@mission_duration", SqlDbType.Int).Value = mission_duration;
        		
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    
                    result = ex.Message;
                }
        	}
        }
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "ClaimMission/{profile_id}/{mission_id}/{mission_type_id}")]
    public Stream ClaimMission(string profile_id, string mission_id,string mission_type_id)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open(); 
        	using (SqlCommand cmd1 = new SqlCommand("usp_ClaimMission", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_id", SqlDbType.Int).Value = profile_id;
        		cmd1.Parameters.Add("@mission_id", SqlDbType.Int).Value = mission_id;
        		cmd1.Parameters.Add("@mission_type_id", SqlDbType.Int).Value = mission_type_id;
                
        		cmd1.Parameters.Add("@r", SqlDbType.Int);
        		cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                try
                {
                    cmd1.ExecuteNonQuery();
                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                }
                catch (Exception ex)
                {
                    result = ex.Message;
                }
        	}
        }
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    
    [WebGet(UriTemplate = "SendReinforcements/{uid}/{base_id}/{to_profile_id}/{to_base_id}/{usp}/{hero}/{a1}/{b1}/{c1}/{d1}/{a2}/{b2}/{c2}/{d2}/{a3}/{b3}/{c3}/{d3}/{march_time}/{tutorial_step}")]
    public Stream SendReinforcements(string uid, string base_id, string to_profile_id, string to_base_id, string usp, string hero, string a1, string b1, string c1, string d1, string a2, string b2, string c2, string d2, string a3, string b3, string c3, string d3, string march_time,string tutorial_step)
    {
        string result = "0";
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_SendReinforcements", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
                cmd1.Parameters.Add("@base_id", SqlDbType.Int).Value = base_id;
                cmd1.Parameters.Add("@to_profile_id", SqlDbType.Int).Value = to_profile_id;
                cmd1.Parameters.Add("@to_base_id", SqlDbType.Int).Value = to_base_id;

                cmd1.Parameters.Add("@hero", SqlDbType.Int).Value = hero;

                cmd1.Parameters.Add("@a1", SqlDbType.Int).Value = a1;
                cmd1.Parameters.Add("@b1", SqlDbType.Int).Value = b1;
                cmd1.Parameters.Add("@c1", SqlDbType.Int).Value = c1;
                cmd1.Parameters.Add("@d1", SqlDbType.Int).Value = d1;

                cmd1.Parameters.Add("@a2", SqlDbType.Int).Value = a2;
                cmd1.Parameters.Add("@b2", SqlDbType.Int).Value = b2;
                cmd1.Parameters.Add("@c2", SqlDbType.Int).Value = c2;
                cmd1.Parameters.Add("@d2", SqlDbType.Int).Value = d2;

                cmd1.Parameters.Add("@a3", SqlDbType.Int).Value = a3;
                cmd1.Parameters.Add("@b3", SqlDbType.Int).Value = b3;
                cmd1.Parameters.Add("@c3", SqlDbType.Int).Value = c3;
                cmd1.Parameters.Add("@d3", SqlDbType.Int).Value = d3;

                cmd1.Parameters.Add("@march_time", SqlDbType.Int).Value = march_time;

                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@row_id", SqlDbType.Int);
                cmd1.Parameters["@row_id"].Direction = ParameterDirection.Output;

                cmd1.Parameters.Add("@quest_done", SqlDbType.Int);
                cmd1.Parameters["@quest_done"].Direction = ParameterDirection.Output;

                try
                {
                    SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                    DataTable dt = new DataTable();
                    adapter.Fill(dt);

                    int ret = (int)cmd1.Parameters["@r"].Value;
                    result = ret.ToString();
                    ret = 1;
                    if (ret == 1)
                    {
                        //connectionHub.Clients.Group("p" + to_profile_id).send_spies(spy);

                        byte[] returnBytes = encoding.GetBytes(JsonConvert.SerializeObject(dt)); //if success return a dict
                        return new MemoryStream(returnBytes);
                    }
                    else //Spy process failed
                    {
                        byte[] returnBytes2 = encoding.GetBytes(result);
                        return new MemoryStream(returnBytes2);
                    }
                    
                }
                catch (Exception ex)
                {
                    result="exception :"+ex.ToString();
                    byte[] returnBytes3 = encoding.GetBytes(result);
                    return new MemoryStream(returnBytes3);
                }

                int quest_done = (int)cmd1.Parameters["@quest_done"].Value;
                if (quest_done > 0)
                {
                    connectionHub.Clients.Group("u" + uid).quest_done(quest_done.ToString());
                }
            }
        }
    }
}
