//
//  RegisterView.m
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

#import "RegisterView.h"
#import "Globals.h"
#import "NSString+HMAC.h"

@interface RegisterView ()

@property (nonatomic, strong) UITableViewCell *inputCell1;
@property (nonatomic, strong) UITableViewCell *inputCell2;
@property (nonatomic, strong) UITableViewCell *inputCell3;
@property (nonatomic, strong) UITextField *emailText;
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UITextField *retypeText;

@end

@implementation RegisterView

- (void)updateView
{
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"New Player", nil), @"r1_color": @"0", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Email", nil), @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row103 = @{@"t1": NSLocalizedString(@"Enter Email here...", nil), @"t1_keyboard": @"4", @"nofooter": @"1"};
    NSDictionary *row104 = @{@"r1": NSLocalizedString(@"Password", nil), @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row105 = @{@"t1": NSLocalizedString(@"Enter Password here...", nil), @"t1_keyboard": @"3", @"nofooter": @"1"};
    NSDictionary *row106 = @{@"r1": NSLocalizedString(@"Retype Password", nil), @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row107 = @{@"t1": NSLocalizedString(@"Retype Password here...", nil), @"t1_keyboard": @"3", @"nofooter": @"1"};
    NSArray *rows1 = @[row101, row102, row103, row104, row105, row106, row107];
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Register", nil), @"r1_button": @"2", @"nofooter": @"1"};
    NSArray *rows2 = @[row201];
    
    self.ui_cells_array = [@[rows1, rows2] mutableCopy];
    
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 201)
    {
        [self registerEmail];
    }
}

- (void)tryRegister
{
    [UIManager.i showLoadingAlert];
    
    NSString *fid = [self.emailText.text lowercaseString];
    NSString *hexHmac = [fid HMACWithSecret:kSecret];
    NSString *uid = [[Globals.i GameId] stringByAppendingString:hexHmac];
    NSString *email = self.emailText.text;
    NSString *hexPassword = [Globals.i stringToHex:self.passwordText.text];
    
    NSString *service_name = @"Register";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                          [Globals.i GameId], uid, hexPassword, email, [Globals.i getDtoken]];

    
    [Globals.i getMainServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             if([returnValue isEqualToString:@"1"]) //Register new uid success
             {
                 [Globals.i set_signin_name:email]; //This must be b4 setUID
                 [Globals.i setUID:uid];
                 
                 [UIManager.i closeTemplate];
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginPasswordSuccess"
                                                                     object:self
                                                                   userInfo:nil];
                 
                 [UIManager.i showToast:NSLocalizedString(@"Registration Successful!", nil)
                        optionalTitle:@"AccountRegistered"
                        optionalImage:@"icon_check"];
                 
                 [Globals.i trackEvent:@"Tutorial" action:@"RegistrationSuccessful" label:uid];

             }
             else if ([returnValue isEqualToString:@"-1"]) //email already exist
             {
                 [UIManager.i showDialog:NSLocalizedString(@"Invalid Email. Email is already registered. Please use another email to register.", nil) title:@"Email"];
                 [Globals.i trackEvent:@"Attempt to register with an existing email" action:service_name label:uid];
             }
             else if ([returnValue isEqualToString:@"-2"]) //Stored Proc Failed
             {
                 [Globals.i showDialogFail];
                 [Globals.i trackEvent:@"SP Failed" action:service_name label:uid];
             }
             else //Web Service Return 0
             {
                 if (returnValue != nil)
                 {
                     if (DEBUG)
                     {
                         [UIManager.i showIIS_error:returnValue];
                     }
                     else
                     {
                         [Globals.i showDialogFail];
                     }
                     [Globals.i trackEvent:returnValue action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
                 }
                 else
                 {
                     [Globals.i showDialogError];
                     [Globals.i trackEvent:@"WS Return 0" action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
                 }
             }
         }
         [UIManager.i removeLoadingAlert];
     }];
}

- (void)registerEmail
{
    self.inputCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    self.inputCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    self.inputCell3 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    self.emailText = (UITextField *)[self.inputCell1 viewWithTag:6];
    self.passwordText = (UITextField *)[self.inputCell2 viewWithTag:6];
    self.retypeText = (UITextField *)[self.inputCell3 viewWithTag:6];
    
    if ([Globals.i NSStringIsValidEmail:self.emailText.text])
    {
        if ([self.passwordText.text isEqualToString:self.retypeText.text])
        {
            if (self.passwordText.text.length > 3 && self.passwordText.text.length < 13)
            {
                [self tryRegister];
            }
            else
            {
                [UIManager.i showDialog:NSLocalizedString(@"Invalid Password. Password should be at least 4 to 12 characters.", nil) title:@"InvalidPassword"];
            }
        }
        else
        {
            [UIManager.i showDialog:NSLocalizedString(@"Password did not match retyped password.", nil) title:@"PasswordMismatch"];
        }
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"Invalid Email. Please enter a valid Email (Example: john@gmail.com)", nil) title:@"InvalidEmail"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:DIALOG_CELL_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
