//
//  LoginBox.m
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

#import "LoginBox.h"
#import "Globals.h"
#import "NSString+HMAC.h"
#import "RegisterView.h"

@interface LoginBox ()

@property (nonatomic, strong) UITableViewCell *inputCell1;
@property (nonatomic, strong) UITableViewCell *inputCell2;
@property (nonatomic, strong) UITextField *emailText;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) RegisterView *registerView;

@end

@implementation LoginBox

- (void)updateView
{
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Login", nil), @"r1_color": @"0", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Email", nil), @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row103 = @{@"t1": NSLocalizedString(@"Enter Email here...", nil), @"t1_keyboard": @"4", @"nofooter": @"1"};
    NSDictionary *row104 = @{@"r1": NSLocalizedString(@"Password", nil), @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row105 = @{@"t1": NSLocalizedString(@"Enter Password here...", nil), @"t1_keyboard": @"3", @"nofooter": @"1"};
    NSArray *rows1 = @[row101, row102, row103, row104, row105];
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Forgot Password", nil), @"r1_button": @"2", @"c1": NSLocalizedString(@"Login", nil), @"c1_button": @"2", @"nofooter": @"1"};
    NSDictionary *row202 = @{@"r1": NSLocalizedString(@"Register Account", nil), @"r1_button": @"2", @"nofooter": @"1"};
    NSArray *rows2 = @[row201, row202];
    
    self.ui_cells_array = [@[rows1, rows2] mutableCopy];
    
	[self.tableView reloadData];
}

- (void)loginEmail
{
    self.inputCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    self.emailText = (UITextField *)[self.inputCell1 viewWithTag:6];
    NSString *str_email = self.emailText.text;
    
    self.inputCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    self.passwordText = (UITextField *)[self.inputCell2 viewWithTag:6];
    NSString *str_password = self.passwordText.text;
    
    if ([Globals.i NSStringIsValidEmail:str_email])
    {
        if (str_password.length > 3 && str_password.length < 13)
        {
            [self tryLogin];
        }
        else
        {
            [UIManager.i showDialog:NSLocalizedString(@"Invalid Password. Password should be at least 4 to 12 characters.", nil) title:@"InvalidPassword"];
        }
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)", nil) title:@"InvalidEmail"];
    }
}

- (void)passwordReset
{
    [UIManager.i showDialogBlock:NSLocalizedString(@"Please enter your login Email", nil)
                               title:@"PasswordReset"
                                type:4
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             if([Globals.i NSStringIsValidEmail:text])
             {
                 [UIManager.i showLoadingAlert];
                 
                 text = [text lowercaseString];
                 NSString *hexHmac = [text HMACWithSecret:kSecret];
                 NSString *uid = [[Globals.i GameId] stringByAppendingString:hexHmac];
                 
                 NSString *service_name = @"PasswordRequest";
                 NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                                    [Globals.i GameId], uid, text];

                 [Globals.i getMainServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
                  {
                      if (success)
                      {
                          NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                          
                          if ([returnValue isEqualToString:@"1"])
                          {
                              [UIManager.i showDialog:NSLocalizedString(@"Please check the Email address you signed up with. We have sent an email to you with a link to your password. If you can't find it, it might be in your Spam folder.", nil) title:@"PasswordLinkSent"];
                          }
                          else if ([returnValue isEqualToString:@"-1"])
                          {
                              [UIManager.i showDialog:NSLocalizedString(@"Please contact " SUPPORT_EMAIL @" using this email address to retrieve your password.", nil) title:@"EmailForSupport"];
                          }
                          else
                          {
                              [UIManager.i showDialog:NSLocalizedString(@"Sorry, the Email you entered does not have an account with us.", nil) title:@"EmailNotFound"];
                          }
                      }
                      [UIManager.i removeLoadingAlert];
                  }];
             }
             else
             {
                 [UIManager.i showDialog:NSLocalizedString(@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)", nil) title:@"InvalidEmail"];
                 
                 return;
             }
         }
     }];
}

- (void)tryLogin
{
    [UIManager.i showLoadingAlert];
    
    NSString *fid = [self.emailText.text lowercaseString];
    NSString *hexHmac = [fid HMACWithSecret:kSecret];
    NSString *uid = [[Globals.i GameId] stringByAppendingString:hexHmac];
    NSString *email = self.emailText.text;
    NSString *hexPassword = [Globals.i stringToHex:self.passwordText.text];
    
    NSString *service_name = @"LoginEmail";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",
                       uid, email, hexPassword, [Globals.i getLat], [Globals.i getLongi], [Globals.i getDtoken]];
    
    [Globals.i getMainServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSInteger retval = [returnValue intValue];
             
             if (retval > 0) //Has an active email id registered
             {
                 [Globals.i set_signin_name:email]; //This must be b4 setUID
                 [Globals.i setUID:uid];
                 
                 //[UIManager.i closeTemplate];
                 
                 //From now on use password login as default (no more GameCenter logins)
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"password_login"];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginPasswordSuccess"
                                                                     object:self
                                                                   userInfo:nil];
             }
             else if ([returnValue isEqualToString:@"-1"])
             {
                 [UIManager.i showDialog:NSLocalizedString(@"Invalid Email or Password. If this is your first time, please Register Account.", nil) title:@"InvalidEmailPassword"];
                 
                 [Globals.i trackEvent:@"SP Failed" action:service_name label:email];
             }
             else
             {
                 [Globals.i showDialogError];
                 
                 [Globals.i trackEvent:@"WS Return 0" action:service_name label:email];
             }
         }
         [UIManager.i removeLoadingAlert];
     }];
}

- (void)showRegisterView
{
    self.registerView = [[RegisterView alloc] initWithStyle:UITableViewStylePlain];
    [self.registerView updateView];
    self.registerView.title = NSLocalizedString(@"Register", nil);
    [UIManager.i showTemplate:@[self.registerView] :self.registerView.title :8];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 201)
    {
        [self passwordReset];
    }
    else if (i == 202)
    {
        [self showRegisterView];
    }
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 201)
    {
        [self loginEmail];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:DIALOG_CELL_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
