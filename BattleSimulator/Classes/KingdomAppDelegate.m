//
//  AppDelegate.mm
//  Battle Simulator
//
//  Created by Shankar on 6/26/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "KingdomAppDelegate.h"
#import "MainView.h"
#import "Globals.h"

@implementation KingdomAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.beenSleeping = NO;
    
	// launchOptions has the incoming notification if we're being launched after the user tapped "view"
	NSLog( @"didFinishLaunchingWithOptions:%@", launchOptions );
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    application.applicationIconBadgeNumber = 0;
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.mainView = [[MainView alloc] init];
    [self.window setRootViewController:self.mainView];
	[self.window makeKeyAndVisible];
    
    [self.mainView startUp]; //Called one time only
    
    [launchOptions valueForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|
                                                       UIUserNotificationTypeSound categories:nil]];
    }
    
	return YES;
}

- (void)application:(UIApplication *)app
didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    NSLog(@"Failed to register, error: %@", err);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if (self.beenSleeping)
    {
        self.beenSleeping = NO;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.beenSleeping = YES;
}

@end
