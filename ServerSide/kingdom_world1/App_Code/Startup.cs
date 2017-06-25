using Microsoft.Owin;
using Owin;
using Hangfire;

[assembly: OwinStartup(typeof(Startup))]

public class Startup
{
    public void Configuration(IAppBuilder app)
    {
        // Any connection or hub wire up and configuration should go here
        app.MapSignalR();

        GlobalConfiguration.Configuration
                .UseSqlServerStorage(@"Server=(local); Database=Hangfire; User ID=sa; Password=Sp1d3rm@n12");

        app.UseHangfireDashboard();
        app.UseHangfireServer();
    }
}