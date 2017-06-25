using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for Global
/// </summary>
public static class Global
{
    static string _lastRegister;
	
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