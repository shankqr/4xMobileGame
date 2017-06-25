//
//  MarketView.m
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

#import "MarketView.h"
#import "Globals.h"
#import "MarketSend.h"

@interface MarketView ()

@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) MarketSend *marketSend;
@property (nonatomic, strong) TimerView *tv_view;
@property (nonatomic, strong) UIView *blockView;

@end

@implementation MarketView

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TimerViewEnd"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateMarketView"
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
    else if ([[notification name] isEqualToString:@"TimerViewEnd"] || [[notification name] isEqualToString:@"UpdateMarketView"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *tv_id = [userInfo objectForKey:@"tv_id"];
            
            if ([tv_id integerValue] == TV_TRADE)
            {
                [self updateView];
            }
        }
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.building_id = @"12";
    
    self.tv_view = [Globals.i copyTvViewFromStack:TV_TRADE];
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    NSMutableArray *rows1 = [@[row101] mutableCopy];
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    NSString *service_name = @"GetBaseAll";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsWorldProfileDict[@"profile_id"]];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 Globals.i.wsBaseArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
             }
             else
             {
                 NSLog(@"WARNING: GetBaseAll return empty array!");
                 Globals.i.wsBaseArray = [[NSMutableArray alloc] init];
             }
             
             BOOL newRowAdded = NO;
             
             for (NSDictionary *row1 in Globals.i.wsBaseArray)
             {
                 if (![Globals.i.wsBaseDict[@"base_id"] isEqualToString:row1[@"base_id"]])
                 {
                     NSString *r2;
                     NSString *i1_over;
                     NSString *i1;
                     
                     if ([row1[@"base_type"] isEqualToString:@"1"])
                     {
                         r2 = NSLocalizedString(@"Capital City", nil);
                         i1_over = @"icon_capital_over";
                         
                         NSInteger b_lvl = [row1[@"building_level"] integerValue];
                         if (b_lvl < 10)
                         {
                             i1 = @"t81";
                         }
                         else if (b_lvl < 17)
                         {
                             i1 = @"t82";
                         }
                         else
                         {
                             i1 = @"t83";
                         }
                     }
                     else
                     {
                         r2 = NSLocalizedString(@"Village", nil);
                         i1_over = @"";
                         
                         NSInteger b_lvl = [row1[@"building_level"] integerValue];
                         if (b_lvl < 10)
                         {
                             i1 = @"t71";
                         }
                         else if (b_lvl < 17)
                         {
                             i1 = @"t72";
                         }
                         else
                         {
                             i1 = @"t73";
                         }
                     }
                     
                     NSDictionary *row103 = @{@"p_id": row1[@"profile_id"], @"b_id": row1[@"base_id"], @"b_x": row1[@"map_x"], @"b_y": row1[@"map_y"], @"r1": row1[@"base_name"], @"r2": [NSString stringWithFormat:@"%@ (%@,%@)", r2, row1[@"map_x"], row1[@"map_y"]], @"n1_width": @"30", @"i1": i1, @"i1_over": i1_over, @"c1": @"Send", @"c1_button": @"2", @"c1_ratio": @"5"};
                     
                     [rows1 addObject:row103];
                     newRowAdded = YES;
                 }
             }
             
             if (newRowAdded)
             {
                 NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Your Cities", nil), @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
                 
                 [rows1 insertObject:row102 atIndex:1];
                 
                 [self.ui_cells_array removeObjectAtIndex:0];
                 [self.ui_cells_array insertObject:rows1 atIndex:0];
                 [self.tableView reloadData];
             }
         }
     }];
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Your Alliance Members", nil), @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    
    if([Globals.i.wsWorldProfileDict[@"alliance_id"] isEqualToString:@"0"]) //Not in any alliance
    {
        NSDictionary *row202 = @{@"r1": NSLocalizedString(@"Join an Alliance to send resources to your friends capital city.", nil), @"r1_align": @"1", @"r1_color": @"1", @"nofooter": @"1"};
        NSDictionary *row203 = @{@"r1": @" ", @"nofooter": @"1"};
        NSDictionary *row204 = @{@"r1": NSLocalizedString(@"More Information", nil), @"r1_button": @"2", @"nofooter": @"1"};
        
        NSArray *rows2 = @[row201, row202, row203, row204];
        
        [self.ui_cells_array addObject:rows2];
        
        [self.tableView reloadData];
    }
    else
    {
        NSDictionary *row202 = @{@"r1": @" ", @"nofooter": @"1"};
        NSDictionary *row203 = @{@"r1": NSLocalizedString(@"Loading...", nil), @"r1_align": @"1", @"nofooter": @"1"};
        
        NSArray *rows2 = @[row201, row202, row203];
        
        [self.ui_cells_array addObject:rows2];
        
        [self.tableView reloadData];
        
        if (![Globals.i.wsWorldProfileDict[@"alliance_id"] isEqualToString:Globals.i.selected_alliance_id])
        {
            [Globals.i GetAllianceMembers:Globals.i.wsWorldProfileDict[@"alliance_id"] :^(BOOL success, NSData *data)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     if (success)
                     {
                         [self addMemberRows];
                     }
                 });
             }];
        }
        else
        {
            [self addMemberRows];
        }
    }
    
    //Block it if its trading
    if (self.tv_view != nil)
    {
        if (self.blockView == nil)
        {
            self.blockView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, TABLE_HEADER_VIEW_HEIGHT, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
            [self.blockView setBackgroundColor:[UIColor blackColor]];
            [self.blockView setAlpha:0.75f];
        }
        else
        {
            [self.blockView removeFromSuperview];
        }
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView setScrollEnabled:NO];
        [self.tableView addSubview:self.blockView];
    }
    else
    {
        if (self.blockView != nil)
        {
            [self.blockView removeFromSuperview];
        }
        
        [self.tableView setScrollEnabled:YES];
    }
}

- (void)addMemberRows
{
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Your Alliance Members", nil), @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSMutableArray *rows2 = [@[row201] mutableCopy];
    
    BOOL newRowAdded = NO;
    
    if ([Globals.i.alliance_members count] > 0)
    {
        for (NSDictionary *row1 in Globals.i.alliance_members)
        {
            if (![Globals.i.wsWorldProfileDict[@"profile_id"] isEqualToString:row1[@"profile_id"]])
            {
                NSString *r1 = row1[@"profile_name"];
                if ([row1[@"alliance_tag"] length] > 2)
                {
                    r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
                }
                NSDictionary *row202 = @{@"p_id": row1[@"profile_id"], @"b_id": @"0", @"r1": r1, @"i1": [NSString stringWithFormat:@"face_%@", row1[@"profile_face"]], @"i1_h": @" ", @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", row1[@"alliance_rank"]], @"c1": NSLocalizedString(@"Send", nil), @"c1_button": @"2", @"c1_ratio": @"5"};
                
                [rows2 addObject:row202];
                
                newRowAdded = YES;
            }
        }
    }
    
    if (!newRowAdded) //A message when no data is present
    {
        NSDictionary *row202 = @{@"r1": @" ", @"nofooter": @"1"};
        NSDictionary *row203 = @{@"r1": NSLocalizedString(@"This Alliance is new and has no other Members yet!", nil), @"r1_align": @"1", @"r1_color": @"1", @"nofooter": @"1"};
        [rows2 addObject:row202];
        [rows2 addObject:row203];
    }
    
    NSDictionary *row204 = @{@"r1": @" ", @"nofooter": @"1"};
    NSDictionary *row205 = @{@"r1": NSLocalizedString(@"More Information", nil), @"r1_button": @"2", @"nofooter": @"1"};
    [rows2 addObject:row204];
    [rows2 addObject:row205];
    
    [self.ui_cells_array removeObjectAtIndex:1];
    [self.ui_cells_array insertObject:rows2 atIndex:1];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)img1_tap:(id)sender
{
    [Globals.i play_button];
    
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSString *selected_profile_id = self.ui_cells_array[section][row][@"p_id"];
    if (selected_profile_id != nil)
    {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:selected_profile_id forKey:@"profile_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)button1_tap:(id)sender
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.building_id forKey:@"building_id"];
    [userInfo setObject:@(self.level) forKey:@"building_level"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildingChart"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSMutableDictionary *rowTarget = self.ui_cells_array[section][row];
    
    if (self.marketSend == nil)
    {
        self.marketSend = [[MarketSend alloc] initWithStyle:UITableViewStylePlain];
    }
    self.marketSend.level = self.level;
    
    NSMutableDictionary *rtarget = [[NSMutableDictionary alloc] initWithDictionary:rowTarget copyItems:YES];
    [rtarget removeObjectsForKeys:@[@"c1", @"c1_button", @"c1_ratio"]];
    self.marketSend.row_target = rtarget;
    self.marketSend.base_r1 = Globals.i.base_r1;
    self.marketSend.base_r2 = Globals.i.base_r2;
    self.marketSend.base_r3 = Globals.i.base_r3;
    self.marketSend.base_r4 = Globals.i.base_r4;
    self.marketSend.base_r5 = Globals.i.base_r5;
    self.marketSend.title = NSLocalizedString(@"Send Resources", nil);
    
    self.marketSend.exit_to_map = @"0";
    
    [UIManager.i showTemplate:@[self.marketSend] :self.marketSend.title];
    [self.marketSend updateView];
}


#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.img1 addTarget:self action:@selector(img1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.img1.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    if (self.tv_view != nil && section == 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, TABLE_HEADER_VIEW_HEIGHT)];
        [headerView setBackgroundColor:[UIColor blackColor]];
        [headerView addSubview:(UIView *)self.tv_view];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tv_view != nil && section == 0)
    {
        return TABLE_HEADER_VIEW_HEIGHT;
    }
    else
    {
        return 0;
    }
}

@end
