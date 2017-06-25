//
//  LoginView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/10/09.
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

@import GameKit;

#import "LoginView.h"
#import "SplashView.h"
#import "Globals.h"
#import "LoginBox.h"

@interface LoginView ()

@property (nonatomic, strong) UIButton *btnPlay;
@property (nonatomic, strong) NSString *str_player_id;
@property (nonatomic, strong) NSString *str_display_name;
@property (nonatomic, strong) UIViewController *authenticationViewController;
@property (nonatomic, strong) SplashView *splashView;
@property (nonatomic, strong) LoginBox *loginBox;

@property (nonatomic, assign) NSInteger game_center_retries;

@end

@implementation LoginView

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"LoginPasswordSuccess"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"LoginPasswordSuccess"])
    {
        [self updateView];
    }
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    if (self.splashView == nil)
    {
        self.splashView = [[SplashView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        [self.view addSubview:self.splashView];
    }
    
    [self.splashView updateText:@""];
    
    CGFloat menu_spacing = 10.0f;
    CGFloat button_width = (self.view.frame.size.width/2.0f) - menu_spacing*2;
    CGFloat button_height = 44.0f*SCALE_IPAD;
    CGFloat button_x = (self.view.frame.size.width/2.0f) - (button_width/2.0f);
    CGFloat button_y = self.view.frame.size.height - button_height - menu_spacing;
    
    if (self.btnPlay == nil)
    {
        self.btnPlay = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"Play", nil)
                                                     target:self
                                                   selector:@selector(btnPlay_tap:)
                                                      frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                       type:@"2"];
        
        [self.view addSubview:self.btnPlay];
    }
    
    [self notificationRegister];
}

- (void)authenticateLocalPlayer
{
    self.game_center_retries = [[NSUserDefaults standardUserDefaults] integerForKey:@"game_center_retries"];
    

    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    __unsafe_unretained GKLocalPlayer *weak_localPlayer = localPlayer;
    
    [self.splashView updateText:NSLocalizedString(@"Authenticating GameCenter, please wait..", nil)];
    
    localPlayer.authenticateHandler  =
    ^(UIViewController *viewController, NSError *error)
    {
        [self.splashView updateText:@""];
        
        NSString *errorString = [error localizedDescription];
        if (error != nil)
        {
            if ([errorString length]>0)
            {
                NSLog(@"GameKitHelper ERROR: %@", [[error userInfo] description]);
                [Globals.i trackEvent:[[error userInfo] description]];
            }
        }
        
        if (viewController != nil)
        {
            _authenticationViewController = viewController;
            [self presentViewController:viewController animated:YES completion:nil];
        
            [self.btnPlay setHidden:NO];
        }
        else if ([GKLocalPlayer localPlayer].isAuthenticated)
        {
            self.str_player_id = weak_localPlayer.playerID;
            self.str_player_id = [self.str_player_id stringByReplacingOccurrencesOfString:@":" withString:@""];
            
            self.str_display_name = weak_localPlayer.displayName;
            
            [Globals.i set_signin_name:self.str_display_name];
            
            [self.splashView updateText:NSLocalizedString(@"Logging in Server, please wait..", nil)];
            
            [Globals.i loginGameCenter:self.str_player_id :^(BOOL success, NSData *data)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [self.splashView updateText:@""];
                     
                     if (success)
                     {
                         [Globals.i setUID:self.str_player_id];
                         
                         [Globals.i trackEvent:@"Tutorial" action:@"RegistrationSuccessful" label:self.str_player_id];
                         
                         if (self.str_player_id != nil && [self.str_player_id length] > 1) //Dont show play button
                         {
                             [self.btnPlay setHidden:YES];
                         }
                         else
                         {
                             [self.btnPlay setHidden:NO];
                         }
                         
                         [self updateView];
                     }
                     else
                     {
                         [UIManager.i showDialog:@"FAILED: LoginGameCenter" title:@"LoginGameCenterERROR"];
                         
                         [Globals.i trackEvent:@"FAILED: LoginGameCenter"];
                         
                         [self.btnPlay setHidden:NO];
                     }
                 });
             }];
        }
        else
        {
            if ([errorString length]>0)
            {
                if ([errorString isEqualToString:@"The requested operation has been canceled or disabled by the user."])
                {
                    // Possible reasons for error:
                    // 1. User cancelled (The requested operation has been canceled or disabled by the user)
                    // 2. Game Center disabled (The requested operation has been canceled or disabled by the user)
                    // 3. User credentials invalid

                    [UIManager.i showDialog:NSLocalizedString(@"Game Center recommended. Login to Game Center under Settings->Game Center. Ensure credentials are correct. Then relaunch this game Or press Play button to play using an email", nil) title:@"GameCenterRecommendation"];
                }
                else
                {
                    // Possible reasons for error:
                    // 1. Communications problem
                    //   a)IP+MAC_ADDRESS Blocked
                    //   b)Internet Problem
                    //   c)Apple Game Center server down
                    
                    [UIManager.i showDialog:NSLocalizedString(@"Internet connection is required to Play. Ensure credentials are valid. Then relaunch this game.", nil) title:@""];
                }
            }

            self.game_center_retries = self.game_center_retries + 1;
            [[NSUserDefaults standardUserDefaults] setInteger:self.game_center_retries forKey:@"game_center_retries"];
            
            [self.btnPlay setHidden:NO];
        }
    };
}

- (BOOL)updateView
{
    NSString *uid = [Globals.i UID];
    if (uid != nil && [uid length] > 1) //AutoLogin
    {
        [self LoadMainView];
    }
    else
    {
        BOOL password_login = [[NSUserDefaults standardUserDefaults] boolForKey:@"password_login"];
        
        if (password_login)
        {
            [self.btnPlay setHidden:NO];
        }
        else
        {
            [self authenticateLocalPlayer];
        }
        
        return NO;
    }
    
    return YES;
}

- (void)LoadMainView
{
    [UIManager.i closeTemplate];
    
    if (self.loginBlock != nil)
    {
        self.loginBlock(1);
    }
}

- (void)btnPlay_tap:(id)sender
{
    [Globals.i play_button];
    
    //skipping authenticateLocalPlayer because apparently it can only work the 1st time after app onApplicationLoad
    [self showLoginBox];
}

- (void)showLoginBox
{
    self.loginBox = [[LoginBox alloc] initWithStyle:UITableViewStylePlain];
    [self.loginBox updateView];
    self.loginBox.title = @"Login";
    [UIManager.i showTemplate:@[self.loginBox] :self.loginBox.title :8];
}

@end
