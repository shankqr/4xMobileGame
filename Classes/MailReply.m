//
//  MailReply.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 3/24/09.
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

#import "MailReply.h"
#import "Globals.h"

@interface MailReply ()

@property (nonatomic, strong) UITableViewCell *inputCell;

@end

@implementation MailReply

- (void)updateView
{
    NSDictionary *rowHeader2 = @{@"h1": NSLocalizedString(@"Message", nil)};
    NSDictionary *row20 = @{@"t1": NSLocalizedString(@"Enter text here...", nil), @"t1_height": @"84"};
    NSArray *rows2 = @[rowHeader2, row20];
    
    //NSDictionary *rowHeader3 = @{@"h1": @"Options"};
    NSDictionary *rowDone = @{@"r1": NSLocalizedString(@"Send", nil), @"r1_align": @"1"};
    NSDictionary *rowCancel = @{@"r1": NSLocalizedString(@"Cancel", nil), @"r1_align": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowDone, rowCancel];
    
    self.ui_cells_array = [@[rows2, rows3] mutableCopy];
    
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)replyMail:(UITextView *)textview
{
    NSString *is_alliance = self.mailData[@"is_alliance"];
    
    if (is_alliance == nil) //its from db
    {
        NSString *alliance_id = self.mailData[@"alliance_id"];
        if ([alliance_id isEqualToString:@"-1"])
        {
            is_alliance = @"0";
        }
        else
        {
            is_alliance = @"1";
        }
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          Globals.i.wsWorldProfileDict[@"profile_id"],
                          @"profile_id",
                          Globals.i.wsWorldProfileDict[@"profile_name"],
                          @"profile_name",
                          Globals.i.wsWorldProfileDict[@"profile_face"],
                          @"profile_face",
                          self.mailData[@"mail_id"],
                          @"mail_id",
                          self.mailData[@"profile_id"],
                          @"from_id",
                          self.mailData[@"reply_counter"],
                          @"reply_counter",
                          textview.text,
                          @"message",
                          self.mailData[@"to_id"],
                          @"to_id",
                          is_alliance,
                          @"is_alliance",
                          nil];
    
    NSString *service_name = @"PostMailReply";
    [Globals.i postServerLoading:dict :service_name :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread
             
             if (success)
             {
                 NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 if ([returnValue isEqualToString:@"1"]) //Stored Proc Success
                 {
                     [Globals.i replyCounterPlus:self.mailData[@"mail_id"]]; //Since we r the one that reply, no need to show red dot
                     [Globals.i updateMailReply:self.mailData[@"mail_id"]]; //To show our reply and fetch latest reply from server
                     [UIManager.i closeTemplate];
                     textview.text = @"";
                     
                     [UIManager.i showToast:NSLocalizedString(@"Message Sent!", nil)
                              optionalTitle:@"MessageSent"
                              optionalImage:@"icon_check"];
                 }
                 else if ([returnValue isEqualToString:@"-1"]) //Stored Proc Failed
                 {
                     [Globals.i showDialogFail];
                     [Globals.i trackEvent:@"SP Failed" action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
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
         });
     }];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.ui_cells_array count]-1)
    {
        self.inputCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextView *inputTV = (UITextView *)[self.inputCell viewWithTag:7];
        
        if (indexPath.row == 0) //Send Reply
        {
            [Globals.i play_messages];
            
            if ([inputTV.text length] > 0)
            {
                [inputTV resignFirstResponder];
                
                [self replyMail:inputTV];
            }
        }
        else if (indexPath.row == 1) //Cancel
        {
            [UIManager.i closeTemplate];
            
            inputTV.text = @"";
        }
    }
    
	return nil;
}

@end
