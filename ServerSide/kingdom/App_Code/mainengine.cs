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
using Newtonsoft.Json;

[ServiceContract]
[AspNetCompatibilityRequirements(RequirementsMode = AspNetCompatibilityRequirementsMode.Allowed)]
[ServiceBehavior(InstanceContextMode = InstanceContextMode.PerCall)]
public class MainEngine
{
	Encoding encoding = Encoding.UTF8;

    private string GetConnectionString()
    {
        return @"Server=(local); Database=tapfantasy; User ID=sa; Password=Sp1d3rm@n12";
    }

    [WebGet(UriTemplate = "CurrentTime")]
    public Stream CurrentTime()
    {
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(String.Format("{0:dd/MM/yyyy HH:mm:ss}", DateTime.UtcNow));
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "CurrentTimeIso")]
    public Stream CurrentTimeIso()
    {
        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(String.Format("{0:yyyy-MM-ddTHH:mm:ss}", DateTime.UtcNow));
        return new MemoryStream(returnBytes);
    }

    [WebGet(UriTemplate = "ProductIdentifiers/{game_id}")]
    public Stream ProductIdentifiers(string game_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM identifier WHERE game_id='" + game_id + "'", cn))
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

    [WebGet(UriTemplate = "ProductIdentifiersJson/{game_id}")]
    public Stream ProductIdentifiersJson(string game_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM identifier WHERE game_id='" + game_id + "'", cn))
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
    
    [WebGet(UriTemplate = "GetAllWorld")]
    public Stream GetAllWorld()
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM world ORDER BY recomended DESC", cn))
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
    
    [WebGet(UriTemplate = "GetWorld/{world_id}")]
    public Stream GetWorld(string world_id)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM world WHERE world_id=" + world_id, cn))
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

    [WebGet(UriTemplate = "GetProfile/{uid}")]
    public Stream GetProfile(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM profile LEFT JOIN world ON profile.world_id=world.world_id WHERE profile.uid='" + uid + "'", cn))
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

    [WebGet(UriTemplate = "GetProfileJson/{uid}")]
    public Stream GetProfileJson(string uid)
    {
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM profile LEFT JOIN world ON profile.world_id=world.world_id WHERE profile.uid='" + uid + "'", cn))
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

    [WebGet(UriTemplate = "LoginGameCenter/{uid}")]
    public Stream LoginGameCenter(string uid)
    {
        string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
            cn.Open();
            using (SqlCommand cmd1 = new SqlCommand("usp_LoginGameCenter", cn))
            {
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;

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
    
    [WebGet(UriTemplate = "UpdateDeviceToken/{uid}/{devicetoken}")]
    public Stream UpdateDeviceToken(string uid, string devicetoken)
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
    
    [WebGet(UriTemplate = "LoginEmail/{uid}/{email}/{password}/{latitude}/{longitude}/{devicetoken}")]
    public Stream LoginEmail(string uid, string email, string password, string latitude, string longitude, string devicetoken)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_LoginEmail", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@email", SqlDbType.VarChar).Value = email;
        		cmd1.Parameters.Add("@password", SqlDbType.VarChar).Value = password;
        		cmd1.Parameters.Add("@devicetoken", SqlDbType.VarChar).Value = devicetoken;
        		cmd1.Parameters.Add("@latitude", SqlDbType.Float).Value = latitude;
        		cmd1.Parameters.Add("@longitude", SqlDbType.Float).Value = longitude;
        		
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

    [WebGet(UriTemplate = "Register/{game_id}/{uid}/{password}/{email}/{devicetoken}")]
    public Stream Register(string game_id, string uid, string password, string email, string devicetoken)
    {
    	string result = "0";
        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd1 = new SqlCommand("usp_RegisterEmail", cn))
        	{
        		cmd1.CommandType = CommandType.StoredProcedure;
        		cmd1.Parameters.Add("@profile_uid", SqlDbType.VarChar).Value = uid;
        		cmd1.Parameters.Add("@email", SqlDbType.VarChar).Value = email;
        		cmd1.Parameters.Add("@password", SqlDbType.VarChar).Value = password;
        		cmd1.Parameters.Add("@devicetoken", SqlDbType.VarChar).Value = devicetoken;
        		cmd1.Parameters.Add("@game_id", SqlDbType.Int).Value = game_id;
        		
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
    
    [WebGet(UriTemplate = "PasswordRequest/{game_id}/{uid}/{email}")]
    public Stream PasswordRequest(string game_id, string uid, string email)
    {
    	string result = "0";

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	int count = 0;
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT count(*) FROM profile WHERE uid='" + uid + "'", cn))
            {
                cn.Open();
                count = (int)cmd.ExecuteScalar();
            }
        	
        	if (count > 0)
        	{
	            using (SqlCommand cmd = new SqlCommand("INSERT INTO password_request (request_date, request_game_id, request_uid, request_email) VALUES (GETDATE(), '" + game_id + "', '" + uid + "', '" + email + "')", cn))
	            {
	                cmd.ExecuteNonQuery();
	            }
	            
	            string request_id = string.Empty;
	            
	            using (SqlCommand cmd = new SqlCommand("SELECT request_id FROM password_request WHERE request_uid='" + uid + "'", cn))
            	{
	                SqlDataReader r1 = cmd.ExecuteReader();
	                while (r1.Read())
	                {
	                    if (!(r1.IsDBNull(0)))
	                    {
	                        request_id = r1["request_id"].ToString();
	                    }
	                }
	                r1.Close();
	            }
	            
	            result = SendMessage(email, "Password for App", "Click on this link to see your password: http://kingdom.tapfantasy.com/kingdom/GetPassword/" + request_id);
        	}
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    [WebGet(UriTemplate = "GetPassword/{guid}")]
    public Stream GetPassword(string guid)
    {
    	string result = "0";
    	string request_uid = "0";
    	string hmac_password = "0";

        using (SqlConnection cn = new SqlConnection(GetConnectionString()))
        {
        	cn.Open();
        	using (SqlCommand cmd = new SqlCommand("SELECT request_uid FROM password_request WHERE request_id='" + guid + "'", cn))
            {
                SqlDataReader r1 = cmd.ExecuteReader();
                while (r1.Read())
                {
                    if (!(r1.IsDBNull(0)))
                    {
                        request_uid = r1["request_uid"].ToString();
                    }
                }
                r1.Close();
	        }
        	
        	using (SqlCommand cmd = new SqlCommand("SELECT password FROM profile WHERE uid='" + request_uid + "'", cn))
            {
                SqlDataReader r1 = cmd.ExecuteReader();
                while (r1.Read())
                {
                    if (!(r1.IsDBNull(0)))
                    {
                        hmac_password = r1["password"].ToString();
                    }
                }
                r1.Close();
	        }
        	
        	result = "Your password is: " + ConvertHexToString(hmac_password);
        	
        }

        WebOperationContext.Current.OutgoingResponse.ContentType = "text/plain";
        byte[] returnBytes = encoding.GetBytes(result);
        return new MemoryStream(returnBytes);
    }
    
    public string ConvertHexToString(string HexValue)
	{
	    string StrValue = "";
	    while (HexValue.Length > 0)
	    {
	        StrValue += System.Convert.ToChar(System.Convert.ToUInt32(HexValue.Substring(0, 2), 16)).ToString();
	        HexValue = HexValue.Substring(2, HexValue.Length - 2);
	    }
	    return StrValue;
	}
    
    public string SendMessage(string mailTo, string subject, string body)
	{
    	string result = "1";
    	
    	MailMessage mailObj = new MailMessage("support@tapfantasy.com", mailTo, subject, body);
        SmtpClient smtp = new SmtpClient("smtp.elasticemail.com");
        
        //smtp.Host = "37.220.10.138";
        //smtp.UseDefaultCredentials = true;
        smtp.Credentials = new System.Net.NetworkCredential("support@tapfantasy.com", "810d7bec-524c-4bed-ad92-7ddbecc51b22");
        smtp.Port = 2525;
        //smtp.EnableSsl = true;
        //smtp.DeliveryMethod = SmtpDeliveryMethod.PickupDirectoryFromIis;
        //smtp.Credentials = CredentialCache.DefaultNetworkCredentials;
		//smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
        
        try
        {
        	smtp.Send(mailObj);
        }
        catch (Exception ex)
        {
            result = "-1";
        }
        
        return result;
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
    
}