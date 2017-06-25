//
//  MailCompose.m
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

#import "MailCompose.h"
#import "Globals.h"

@interface MailCompose ()

@property (nonatomic, strong) UITableViewCell *inputCell1;
@property (nonatomic, strong) UITableViewCell *inputCell2;

@end

@implementation MailCompose

- (void)updateView
{
    NSDictionary *rowHeader1 = @{@"h1": NSLocalizedString(@"To", nil)};
    NSDictionary *row10 = @{@"t1": NSLocalizedString(@"Enter name here...", nil)};
    NSArray *rows1 = @[rowHeader1, row10];
    
    NSDictionary *rowHeader2 = @{@"h1": NSLocalizedString(@"Message", nil)};
    NSDictionary *row20 = @{@"t1": NSLocalizedString(@"Enter text here...", nil), @"t1_height": @"84"};
    NSArray *rows2 = @[rowHeader2, row20];
    
    NSDictionary *rowDone = @{@"r1": NSLocalizedString(@"Send", nil), @"r1_align": @"1"};
    NSDictionary *rowCancel = @{@"r1": NSLocalizedString(@"Cancel", nil), @"r1_align": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowDone, rowCancel];
    
    self.ui_cells_array = [@[rows1, rows2, rows3] mutableCopy];
    
	[self.tableView reloadData];
    
    [self updateInputs];
}

- (void)updateInputs
{
    self.inputCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    self.inputCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    UITextField *tvName = (UITextField *)[self.inputCell1 viewWithTag:6];
    
    if ([self.isAlliance isEqualToString:@"1"])
    {
        [tvName setEnabled:NO];
    }
    else if ([self.toName isEqualToString:@""])
    {
        [tvName setEnabled:YES];
    }
    else
    {
        [tvName setEnabled:NO];
    }
    
    [tvName setText:self.toName];
}

- (void)sendMail:(UITextView *)textview
{
    [Globals.i play_messages];
    
    NSString *alliance_id = @"-1";
    if ([self.isAlliance isEqualToString:@"1"])
    {
        alliance_id = self.toID;
    }
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          Globals.i.wsWorldProfileDict[@"profile_id"],
                          @"profile_id",
                          Globals.i.wsWorldProfileDict[@"profile_name"],
                          @"profile_name",
                          Globals.i.wsWorldProfileDict[@"profile_face"],
                          @"profile_face",
                          self.isAlliance,
                          @"is_alliance",
                          alliance_id,
                          @"alliance_id",
                          self.toID,
                          @"to_id",
                          self.toName,
                          @"to_name",
                          textview.text,
                          @"message",
                          nil];
    
    NSString *service_name = @"PostMailCompose";
    [Globals.i postServerLoading:dict :service_name :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread
             
             if (success)
             {
                 NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 if([returnValue integerValue] > 0) //Stored Proc Success for mailcompose return mail_id
                 {
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
        UITextField *tvName = (UITextField *)[self.inputCell1 viewWithTag:6];
        UITextView *tvMessage = (UITextView *)[self.inputCell2 viewWithTag:7];
        
        if (indexPath.row == 0) //Send Mail
        {
            if ([tvMessage.text length] > 0)
            {
                [tvMessage resignFirstResponder];
                
                [self sendMail:tvMessage];
                
                tvName.text = @"";
                tvMessage.text = @"";
            }
        }
        else if (indexPath.row == 1) //Cancel
        {
            [UIManager.i closeTemplate];
            
            tvName.text = @"";
            tvMessage.text = @"";
        }
    }
    
	return nil;
}

@end
