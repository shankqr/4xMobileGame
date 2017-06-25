//
//  MailView.m
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

#import "MailView.h"
#import "MailDetail.h"
#import "Globals.h"

@interface MailView ()

@property (nonatomic, strong) NSMutableArray *mailArray;
@property (nonatomic, strong) MailDetail *mailDetail;

@end

@implementation MailView

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateMailView"
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
        else if ([view_title isEqualToString:@"Mail"]) //Mail Detail is closing
        {
            [self refreshTable];
        }
    }
    else if ([[notification name] isEqualToString:@"UpdateMailView"])
    {
        //TODO: Check if currentview b4 refreshTable
        [self refreshTable];
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    [self refreshTable];
}

- (void)refreshTable
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.mailArray = [Globals.i gettLocalMailData];
    
    if (self.mailArray.count > 0)
    {
        self.ui_cells_array = [@[self.mailArray] mutableCopy];
    }
    else
    {
        NSDictionary *row0 = @{@"r1": NSLocalizedString(@"No mails received yet.", nil), @"r1_align": @"1", @"r1_color": @"1", @"nofooter": @"1"};
        NSArray *rows1 = @[row0];
        self.ui_cells_array = [@[rows1] mutableCopy];
    }
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = nil;
    
    if ((indexPath.section == 0) && (self.mailArray.count > 0)) //Mail List
    {
        NSDictionary *row1 = (self.ui_cells_array)[indexPath.section][indexPath.row];

        NSString *title = row1[@"title"];
        
        NSString *content;
        if ([title isEqualToString:@""] || title == nil)
        {
            content = row1[@"message"];
            
            NSInteger MINLENGTH = 30;
            content = ([content length]>MINLENGTH ? [content substringToIndex:MINLENGTH] : content);
        }
        else
        {
            content = title;
        }
        
        NSString *bkg;
        NSString *i0;
        NSString *i1 = @"face_999";
        NSString *bold;
        NSString *r1_font;
        NSString *r2_font;
        NSString *b1_font;
        if ([row1[@"open_read"] isEqualToString:@"1"])
        {
            bkg = @"bkg3";
            i0 = @"mail_read";
            bold = @"";
            r1_font = @"11.0";
            r2_font = @"10.0";
            b1_font = @"9.0";
        }
        else
        {
            bkg = @"";
            i0 = @"mail_unread";
            bold = @"1";
            r1_font = @"12.0";
            r2_font = @"11.0";
            b1_font = @"10.0";
        }
        
        if (row1[@"profile_face"] != nil)
        {
            if ([row1[@"profile_face"] integerValue] > 0)
            {
                i1 = [NSString stringWithFormat:@"face_%@", row1[@"profile_face"]];
            }
        }
        
        NSString *profile_name = row1[@"profile_name"];
        NSString *time_ago = [Globals.i getTimeAgo:row1[@"date_posted"]];
        
        if (content == nil)
        {
            content = @" ";
        }
        
        if (profile_name == nil || [profile_name isEqualToString:@""] )
        {
            profile_name = NSLocalizedString(@"Julia Ross", nil);
        }
        
        if (time_ago == nil)
        {
            time_ago = @" ";
        }
        
        rowData = @{@"bkg_prefix": bkg, @"i0": i0, @"i1": i1, @"i1_aspect": @"1", @"i2": @"arrow_right", @"r1": profile_name, @"r1_bold": bold, @"r1_font": r1_font, @"r2": content, @"r2_bold": bold, @"r2_font": r2_font, @"b1": time_ago, @"b1_bold": bold, @"b1_color": @"5", @"b1_font": b1_font, @"message": row1[@"message"]};
    }
    else if (indexPath.section == 0)
    {
        rowData = (self.ui_cells_array)[indexPath.section][indexPath.row];
    }
    
    return rowData;
}

- (void)button1_tap:(id)sender
{
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Delete Mails:", nil), @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSArray *rows1 = @[row101];
    NSMutableArray *rows = [@[rows1] mutableCopy];
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"All Read Only", nil), @"r1_button": @"2", @"c1": NSLocalizedString(@"Everything", nil), @"c1_button": @"2", @"nofooter": @"1"};
    NSArray *rows2 = @[row201];
    [rows addObject:rows2];
    
    [UIManager.i showDialogBlockRow:rows title:@"DeleteMailType" type:8
                              :^(NSInteger index, NSString *text)
     {
         if (index == 1)
         {
             [self deleteAllRead];
         }
         else if (index == 2)
         {
             [self deleteAll];
         }
     }];
}

- (void)deleteAllRead
{
    for (NSMutableDictionary *rowData in self.mailArray)
    {
        if ([rowData[@"open_read"] isEqualToString:@"1"])
        {
            [Globals.i deleteLocalMail:rowData[@"mail_id"]];
        }
    }
    
    [self refreshTable];
    
    [UIManager.i showToast:NSLocalizedString(@"Deleted all Read!", nil)
             optionalTitle:@"AllReadMailDeleted"
             optionalImage:@"icon_check"];
}

- (void)deleteAll
{
    for (NSMutableDictionary *rowData in self.mailArray)
    {
        [Globals.i deleteLocalMail:rowData[@"mail_id"]];
    }
    
    [self refreshTable];
    
    [UIManager.i showToast:NSLocalizedString(@"Deleted all Mails", nil)
           optionalTitle:@"AllMailDeleted"
           optionalImage:@"icon_check"];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (self.mailArray.count > 0))
    {
        if (self.mailDetail == nil)
        {
            self.mailDetail = [[MailDetail alloc] initWithStyle:UITableViewStylePlain];
        }
        
        NSMutableDictionary *rd = [[self getRowData:indexPath] mutableCopy];
        [rd removeObjectsForKeys:@[@"bkg_prefix", @"i2"]];
        rd[@"r2"] = rd[@"message"]; //Show full message instead of title or shorten message
        
        self.mailDetail.mailRow = rd;
        self.mailDetail.mailData = (self.mailArray)[indexPath.row];
        
        if ([(self.mailArray)[indexPath.row][@"open_read"] isEqualToString:@"0"])
        {
            (self.mailArray)[indexPath.row][@"open_read"] = @"1";
            [Globals.i settLocalMailData:self.mailArray];
            [self.tableView reloadData];
            
            self.mailDetail.updateReplies = @"1";
        }
        else
        {
            self.mailDetail.updateReplies = @"0";
        }
        
        self.mailDetail.title = @"Mail";
        [UIManager.i showTemplate:@[self.mailDetail] :@"Mail"];
        [self.mailDetail updateView];
        
        [self.mailDetail scrollUp];
    }
    
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.mailArray.count > 0)
    {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, TABLE_HEADER_VIEW_HEIGHT)];
        [headerView setBackgroundColor:[UIColor blackColor]];
        
        CGFloat button_width = 280.0f*SCALE_IPAD;
        CGFloat button_height = 44.0f*SCALE_IPAD;
        CGFloat button_x = (UIScreen.mainScreen.bounds.size.width - button_width)/2;
        CGFloat button_y = (TABLE_HEADER_VIEW_HEIGHT - button_height);
        
        UIButton *button1 = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"Delete Mails", nil)
                                                         target:self
                                                       selector:@selector(button1_tap:)
                                                          frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                           type:@"2"];
        
        [headerView addSubview:button1];
        
        return headerView;
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.mailArray.count > 0)
    {
        return TABLE_FOOTER_VIEW_HEIGHT;
    }
    else
    {
        return 0.0f;
    }
}

@end
