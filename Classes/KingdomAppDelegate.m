//
//  4x MMO Mobile Strategy GameAppDelegate.mm
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/26/09.
/*
 Copyright © 2017 SHANKAR NATHAN (shankqr@gmail.com). All rights reserved.
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#import "KingdomAppDelegate.h"
#import "MainView.h"
#import "Globals.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <GameAnalytics/GameAnalytics.h>

@implementation KingdomAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Fabric with:@[[Crashlytics class]]];
    [Fabric with:@[[GameAnalytics class]]];
    
    Globals.i.launchFirstTime = @"1"; //Called one time only
    
    // GA
    NSString *game_version = [NSString stringWithFormat:@"release %@", GAME_VERSION];
    [GameAnalytics configureBuild:game_version];
    [GameAnalytics configureAvailableResourceCurrencies:@[@"gems", @"gold"]];
    [GameAnalytics initializeWithGameKey:@"92a07217526763ef42c50a8b66c07908" gameSecret:@"a9acb3c367a4ec80ac0c903371aa87f39d353854"];
    
    // Helpshift
    [HelpshiftCore initializeWithProvider:[HelpshiftSupport sharedInstance]];
    [HelpshiftCore installForApiKey:@"eac10f2aefeea8228aad0e0aa4fa4cbc"
                         domainName:@"yourdomain.helpshift.com"
                              appID:@"yourdomain_platform_20150224160258236-6388f7c7df3efd3"];
    
    self.beenSleeping = NO;

    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    application.applicationIconBadgeNumber = 0;
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainView = [[MainView alloc] init];
    [self.window setRootViewController:self.mainView];
	[self.window makeKeyAndVisible];
    
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (launchOptions != nil) //Handle PushNotification when app is opened
    {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo != nil && [[userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"])
        {
            [HelpshiftCore handleRemoteNotification:userInfo withController:self.mainView];
        }
    }
    
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self.mainView updateView];
    
    [Globals.i cancelAllLocalNotification];
    [Globals.i resetLoginReminderNotification];
    
    if (self.beenSleeping)
    {
        self.beenSleeping = NO;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.beenSleeping = YES;
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification
{
    if ([[notification.userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"])
    {
        [HelpshiftCore handleLocalNotification:notification withController:[[UIApplication sharedApplication] keyWindow].rootViewController];
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if ([[userInfo objectForKey:@"origin"] isEqualToString:@"helpshift"])
    {
        [HelpshiftCore handleRemoteNotification:userInfo withController:self.mainView];
    }
}

- (void)application:(UIApplication*)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString *s1 = [deviceToken description];
    NSString *s2 = [s1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< >"]];
    NSString *s3 = [s2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    [Globals.i setDtoken:s3];

    [HelpshiftCore registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication*)application
didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    //NSLog(@"Failed to get token, error: %@", error);
}

@end
