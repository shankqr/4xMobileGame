//
//  MailDetail.m
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

#import "MailDetail.h"
#import "MailReply.h"
#import "Globals.h"

@interface MailDetail ()

@property (nonatomic, strong) MailReply *mailReply;

@end

@implementation MailDetail

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateMailDetail"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CloseTemplateBefore"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *view_title = [userInfo objectForKey:@"view_title"];
        
        if ([self.title isEqualToString:view_title])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    }
    else if ([[notification name] isEqualToString:@"UpdateMailDetail"])
    {
        [self updateView];
    }
}

- (void)scrollUp
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)updateView
{
    [self notificationRegister];
    
    NSString *bold = @"";
    NSString *r1_font = @"11.0";
    NSString *r2_font = @"10.0";
    NSString *b1_font = @"9.0";
    NSString *i1 = @"";

    NSArray *rows1 = @[self.mailRow];
    
    if ([self.updateReplies isEqualToString:@"1"])
    {
        [Globals.i updateMailReply:self.mailData[@"mail_id"]];
        self.updateReplies = @"0";
    }
    
    NSArray *rows2 = [Globals.i findMailReply:self.mailData[@"mail_id"]];
    NSDictionary *rowData;
    NSMutableArray *rowTemp = [[NSMutableArray alloc] init];
    NSDictionary *rowHeader2 = @{@"h1": NSLocalizedString(@"Replies", nil)};
    [rowTemp addObject:rowHeader2];
    for (NSUInteger i = 0; i < [rows2 count]; i++)
    {
        i1 = @"";
        if (rows2[i][@"profile_face"] != nil)
        {
            if ([rows2[i][@"profile_face"] integerValue] > 0)
            {
                i1 = [NSString stringWithFormat:@"face_%@", rows2[i][@"profile_face"]];
            }
        }
        
        rowData = @{@"i1": i1, @"i1_aspect": @"1", @"r1": rows2[i][@"profile_name"], @"r2": rows2[i][@"message"], @"b1": [Globals.i getTimeAgo:rows2[i][@"date_posted"]], @"r1_bold": @"1", @"r1_font": r1_font, @"r2_bold": bold, @"r2_font": r2_font, @"b1_bold": bold, @"b1_color": @"5", @"b1_font": b1_font};
        [rowTemp addObject:rowData];
    }
    
    NSDictionary *rowHeader = @{@"h1": NSLocalizedString(@"Options", nil)};
    NSDictionary *rowReply = @{@"r1": NSLocalizedString(@"Reply", nil),  @"r1_align": @"1", @"i2": @"arrow_right"};
    NSDictionary *rowDelete = @{@"r1": @"Delete", @"r1_align": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowHeader, rowReply, rowDelete];
    
    if (![self.mailData[@"profile_id"] isEqualToString:@"0"] && ![self.mailData[@"profile_id"] isEqualToString:@""])
    {
        NSDictionary *rowProfile = @{@"r1": NSLocalizedString(@"View Sender's Profile", nil),  @"r1_align": @"1", @"i2": @"arrow_right"};
        rows3 = @[rowHeader, rowReply, rowDelete, rowProfile];
    }
    
    if ([rowTemp count] > 1)
    {
        self.ui_cells_array = [@[rows1, (NSArray *)rowTemp, rows3] mutableCopy];
    }
    else
    {
        self.ui_cells_array = [@[rows1, rows3] mutableCopy];
    }
    
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)deleteMail
{
    NSString *service_name = @"DeleteMail";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       self.mailData[@"mail_id"], Globals.i.wsWorldProfileDict[@"profile_id"]];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i deleteLocalMail:self.mailData[@"mail_id"]];
             
             [UIManager.i closeTemplate];
             
             [UIManager.i showToast:NSLocalizedString(@"Mail Deleted!", nil)
                      optionalTitle:@"MailDeleted"
                      optionalImage:@"icon_check"];
         }
     }];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.ui_cells_array count]-1)
    {
        if (indexPath.row == 1)
        {
            self.mailReply = [[MailReply alloc] initWithStyle:UITableViewStylePlain];
            self.mailReply.mailData = self.mailData;
            self.mailReply.title = NSLocalizedString(@"Reply", nil);
            [self.mailReply updateView];

            [UIManager.i showTemplate:@[self.mailReply] :self.mailReply.title];
        }
        else if (indexPath.row == 2) //Delete
        {
            [UIManager.i showDialogBlock:NSLocalizedString(@"Are you sure you want to delete this mail?", nil)
                                      title:@"DeleteMailConfirmation"
                                        type:2
                                        :^(NSInteger index, NSString *text)
             {
                 if (index == 1) //YES
                 {
                     [self deleteMail];
                 }
             }];
        }
        else if (indexPath.row == 3) //View senders profile
        {
            NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.mailData[@"profile_id"] forKey:@"profile_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    
	return nil;
}

@end
