using System;
using System.Web;
using Microsoft.AspNet.SignalR;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.IO;
using System.Text;
using System.Data.SqlClient;
using System.Data;

public class ChatHub : Hub
{
    IHubContext connectionHub = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
    
    public void Login(string uid, string profile_id, string alliance_id)
    {
        Groups.Add(Context.ConnectionId, "u" + uid);

        // Tie the profile id as group (p?profile_id)
        Groups.Add(Context.ConnectionId, "p"+profile_id);

        if (int.Parse(alliance_id) > 0)
        {
            // Tie the alliance id as group (a?alliance_id)
            Groups.Add(Context.ConnectionId, "a"+alliance_id);
        }
        
        int ret=0;
            
        string chat_type = "";
        int chat_count = 0;  
        using (SqlConnection cn = new SqlConnection(Global.ConnectionString))
        {
            using (SqlCommand cmd1 = new SqlCommand("usp_GetChat", cn))
            {
                chat_type = "alliance_chat";
                chat_count =20;
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@table_name", SqlDbType.VarChar).Value = chat_type;
                cmd1.Parameters.Add("@chat_count", SqlDbType.Int).Value = chat_count;
                cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
                
                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                
                DataTable dt = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                adapter.Fill(dt);
                
                ret = (int)cmd1.Parameters["@r"].Value;
                if(ret==1)
                {
                    //dt.DefaultView.Sort = "chat_id ASC"; 
                    DataView dv = new DataView(dt);
                    dv.Sort = "[chat_id] ASC";
                    foreach(DataRowView row in dv)
                    //foreach(DataRow row in dt.Rows)
                    {
                        connectionHub.Clients.Group("u" + uid).chat_alliance_history(row["profile_id"].ToString(), row["profile_name"].ToString(), row["profile_face"].ToString(), row["message"].ToString(), row["alliance_id"].ToString(), row["alliance_tag"].ToString(), row["alliance_logo"].ToString(),row["target_alliance_id"].ToString(),row["chat_id"].ToString());
                    }
                }
                
            }
            
            ret=0;
            
            using (SqlCommand cmd1 = new SqlCommand("usp_GetChat", cn))
            {
                chat_type = "chat";
                cmd1.CommandType = CommandType.StoredProcedure;
                cmd1.Parameters.Add("@table_name", SqlDbType.VarChar).Value = chat_type;
                cmd1.Parameters.Add("@chat_count", SqlDbType.Int).Value = chat_count;
                cmd1.Parameters.Add("@alliance_id", SqlDbType.Int).Value = alliance_id;
                
                cmd1.Parameters.Add("@r", SqlDbType.Int);
                cmd1.Parameters["@r"].Direction = ParameterDirection.Output;
                
                DataTable dt = new DataTable();
                SqlDataAdapter adapter = new SqlDataAdapter(cmd1);
                adapter.Fill(dt);
                
                ret = (int)cmd1.Parameters["@r"].Value;
                if(ret==1)
                {
                    //dt.DefaultView.Sort = "chat_id ASC"; 
                    DataView dv = new DataView(dt);
                    dv.Sort = "[chat_id] ASC";
                    foreach(DataRowView row in dv)
                    //foreach(DataRow row in dt.Rows)
                    {
                        connectionHub.Clients.Group("u" + uid).chat_kingdom_history(row["profile_id"].ToString(), row["profile_name"].ToString(), row["profile_face"].ToString(), row["message"].ToString(), row["alliance_id"].ToString(), row["alliance_tag"].ToString(), row["alliance_logo"].ToString(),row["target_alliance_id"].ToString(),row["chat_id"].ToString());
                    }
                }
                
            }
        }
    }

    public void Logout(string uid, string profile_id, string alliance_id)
    {
        Groups.Remove(Context.ConnectionId, "u" + uid);

        Groups.Remove(Context.ConnectionId, "p" + profile_id);

        if (int.Parse(alliance_id) > 0)
        {
            Groups.Remove(Context.ConnectionId, "a" + alliance_id);
        }
    }
    
    public void AllianceGroupAdd(string profile_id, string alliance_id)
    {
        Groups.Add(Context.ConnectionId, "a" + alliance_id);
    }

    public void AllianceGroupRemove(string profile_id, string alliance_id)
    {
        Groups.Remove(Context.ConnectionId, "a" + alliance_id);
    }
    
}