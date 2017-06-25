using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Global
/// </summary>
public static class Global
{
    static string _lastChat;
    static string _lastPost;
    static string _lastRegister;
    
    static string _connectionString;
    
    public static string ConnectionString
	{
		get
        {
            return @"Server=(local); Database=kingdom_world1; User ID=sa; Password=password123";
        }
	}
    
    public static string MainConnectionString
	{
		get
        {
            return @"Server=(local); Database=tapfantasy; User ID=sa; Password=password123;
        }
	}

	public static string LastChat
	{
		get
        {
            return _lastChat;
        }
        set
        {
            _lastChat = value;
        }
	}
	
	public static string LastPost
	{
		get
        {
            return _lastPost;
        }
        set
        {
            _lastPost = value;
        }
	}
	
	public static string LastRegister
	{
		get
        {
            return _lastRegister;
        }
        set
        {
            _lastRegister = value;
        }
	}
}