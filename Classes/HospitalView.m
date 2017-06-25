//
//  HospitalView.m
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

#import "HospitalView.h"
#import "Globals.h"
#import "BuildingList.h"

@interface HospitalView ()

@property (nonatomic, strong) BuildingList *buildingList;
@property (nonatomic, strong) NSMutableDictionary *sel_dict;
@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) TimerView *tv_view;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, assign) NSInteger buildings_output;
@property (nonatomic, assign) NSUInteger sel_value;
@property (nonatomic, assign) NSInteger int_sum;

@end

@implementation HospitalView

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
    else if ([[notification name] isEqualToString:@"TimerViewEnd"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *tv_id = [userInfo objectForKey:@"tv_id"];
            
            if ([tv_id integerValue] == TV_HEAL)
            {
                [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(updateView) userInfo:nil repeats:NO];
            }
        }
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.building_id = @"10";
    
    self.sel_value = 0;
    self.int_sum = 0;
    
    self.sel_dict = [@{Globals.i.a1: @"0", Globals.i.a2: @"0", Globals.i.a3: @"0", Globals.i.b1: @"0", Globals.i.b2: @"0", Globals.i.b3: @"0", Globals.i.c1: @"0", Globals.i.c2: @"0", Globals.i.c3: @"0"} mutableCopy];

    self.tv_view = [Globals.i copyTvViewFromStack:TV_HEAL];
    
    NSInteger count = 1;
    
    self.buildings_output = 0;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:self.building_id])
        {
            NSInteger lvl = [dict[@"building_level"] integerValue];
            NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:lvl];
            
            NSInteger capacity = [buildingLevelDict[@"capacity"] integerValue];
            
            self.buildings_output = self.buildings_output + capacity;
            
            count = count + 1;
        }
    }
    NSString *str_output = [Globals.i intString:self.buildings_output];
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Capacity:", nil), @"r2": NSLocalizedString(@"Time:", nil), @"c1": [NSString stringWithFormat:@"%@/%@", @"0", str_output], @"c2": @"00:00", @"c2_icon": @"icon_clock", @"c1_bkg": @"bkg3", @"c1_color": @"2", @"c2_color": @"2", @"c1_align": @"1", @"c2_bkg": @"bkg3", @"c2_align": @"1", @"c1_ratio": @"1.4", @"i1": @"icon_heal", @"i2": @"arrow_right", @"nofooter": @"1"};
    NSDictionary *row103 = @{@"r1": NSLocalizedString(@"Queue", nil), @"r1_button": @"2", @"r2": NSLocalizedString(@"All", nil), @"c1": NSLocalizedString(@"Heal Now", nil), @"c1_button": @"1", @"c2": @"0", @"c2_icon": @"icon_r5", @"c2_bkg": @"bkg3", @"fit": @"1"};
    NSMutableArray *rows1 = [@[row101, row102, row103] mutableCopy];
    
    if (Globals.i.i_a1 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.a1, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_a1), @"i1": @"icon_a1"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    if (Globals.i.i_a2 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.a2, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_a2), @"i1": @"icon_a2"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    if (Globals.i.i_a3 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.a3, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_a3), @"i1": @"icon_a3"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    if (Globals.i.i_b1 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.b1, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_b1), @"i1": @"icon_b1"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    if (Globals.i.i_b2 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.b2, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_b2), @"i1": @"icon_b2"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    if (Globals.i.i_b3 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.b3, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_b3), @"i1": @"icon_b3"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    if (Globals.i.i_c1 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.c1, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_c1), @"i1": @"icon_c1"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    if (Globals.i.i_c2 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.c2, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_c2), @"i1": @"icon_c2"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    if (Globals.i.i_c3 > 0)
    {
        NSMutableDictionary *row201 = [@{@"r1": Globals.i.c3, @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.i_c3), @"i1": @"icon_c3"} mutableCopy];
        [rows1 addObject:row201];
    }
    
    NSDictionary *row107 = @{@"r1": @" ", @"nofooter": @"1"};

    [rows1 addObject:row107];

    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    
    //Block it if its healing
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

- (void)getTimeAndCost
{
    [self.ui_cells_array[0] removeObjectAtIndex:1];
    [self.ui_cells_array[0] removeObjectAtIndex:1]; //Not to calculate button title in sum
    
    NSNumber *sum = [self.ui_cells_array[0] valueForKeyPath:@"@sum.s1"];
    self.int_sum = [sum integerValue];
    
    float boost_h = ([Globals.i.wsBaseDict[@"boost_heal"] floatValue] / 100.0f) + 1.0f;
    NSInteger time = (float)self.int_sum / boost_h;
    
    NSString *str_time = [Globals.i getCountdownString:time];
    NSString *str_boost = [NSString stringWithFormat:NSLocalizedString(@"%@  Boost:+%@%%", nil), str_time, Globals.i.wsBaseDict[@"boost_heal"]];

    NSString *str_sum = [Globals.i intString:self.int_sum];
    
    NSString *c1_color = @"2";
    NSString *c1_button = @"2";
    
    if (self.int_sum > self.buildings_output)
    {
        c1_color = @"1"; //Red
        c1_button = @"1"; //Disabled
    }
    
    if (self.int_sum == 0)
    {
        c1_button = @"1"; //Disabled
    }
    
    NSString *str_output = [Globals.i intString:self.buildings_output];
    
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Capacity:", nil), @"r2": NSLocalizedString(@"Time:", nil), @"c1": [NSString stringWithFormat:@"%@/%@", str_sum, str_output], @"c2": str_boost, @"c2_icon": @"icon_clock", @"c1_bkg": @"bkg3", @"c1_color": c1_color, @"c2_color": @"2", @"c1_align": @"1", @"c2_bkg": @"bkg3", @"c2_align": @"1", @"c1_ratio": @"1.4", @"i1": @"icon_heal", @"i2": @"arrow_right", @"nofooter": @"1"};
    [self.ui_cells_array[0] insertObject:row102 atIndex:1];
    
    NSDictionary *row103 = @{@"r1": NSLocalizedString(@"Queue", nil), @"r1_button": @"2", @"r2": NSLocalizedString(@"All", nil), @"c1": NSLocalizedString(@"Heal Now", nil), @"c1_button": c1_button, @"c2": str_sum, @"c2_icon": @"icon_r5", @"c2_bkg": @"bkg3", @"fit": @"1"};
    [self.ui_cells_array[0] insertObject:row103 atIndex:2];
}

- (void)slider1_change:(UISlider *)sender
{
    NSInteger row = sender.tag-101;
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.ui_cells_array[0][row] copyItems:YES];
    self.sel_value = ((DCFineTuneSlider *)sender).selectedValue;
    
    [dict1 setValue:@(self.sel_value) forKey:@"s1"];
    
    [self.sel_dict setValue:[@(self.sel_value) stringValue] forKey:dict1[@"r1"]];
    
    [self.ui_cells_array[0] removeObjectAtIndex:row];
    [self.ui_cells_array[0] insertObject:dict1 atIndex:row];
    
    [self getTimeAndCost];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)healTroops
{
    NSString *service_name = @"HealTroops";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], Globals.i.wsBaseDict[@"base_id"],
                       self.sel_dict[Globals.i.a1],
                       self.sel_dict[Globals.i.b1],
                       self.sel_dict[Globals.i.c1],
                       @"0",
                       self.sel_dict[Globals.i.a2],
                       self.sel_dict[Globals.i.b2],
                       self.sel_dict[Globals.i.c2],
                       @"0",
                       self.sel_dict[Globals.i.a3],
                       self.sel_dict[Globals.i.b3],
                       self.sel_dict[Globals.i.c3],
                       @"0"];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i updateBaseDict:^(BOOL success, NSData *data)
              {
                  NSString *str_sum = [Globals.i intString:self.int_sum];
                  NSString *tv_title = [NSString stringWithFormat:NSLocalizedString(@"Healing %@ troops", nil), str_sum];
                  [Globals.i setTimerViewTitle:TV_HEAL :tv_title];
                  
                  [Globals.i setupHospitalQueue:[Globals.i updateTime]];
                  
                  [self updateView];
                  
                  [UIManager.i showToast:NSLocalizedString(@"The healing has begun!", nil)
                           optionalTitle:@"HealingStarted"
                           optionalImage:@"icon_check"];
              }];
         }
     }];
}

- (void)button1_tap:(id)sender //Queue all
{
    NSInteger count = [self.ui_cells_array[0] count];
    
    for (int i = 3; i < count-1; i++)
    {
        [self.ui_cells_array[0][i] setValue:self.ui_cells_array[0][i][@"slider_max"] forKey:@"s1"];
        [self.sel_dict setValue:self.ui_cells_array[0][i][@"slider_max"] forKey:self.ui_cells_array[0][i][@"r1"]];
    }
    
    [self getTimeAndCost];
    
    [self.tableView reloadData];
}

- (void)button2_tap:(id)sender //Heal now
{
    NSInteger c1_button = [[self.ui_cells_array[0][2] objectForKey:@"c1_button"] integerValue];
    
    if (c1_button > 1)
    {
        [self healTroops];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [(UISlider *)dcell.cellview.rv_a.slider addTarget:self action:@selector(slider1_change:) forControlEvents:UIControlEventValueChanged];
    ((UISlider *)dcell.cellview.rv_a.slider).tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            if (self.buildingList == nil)
            {
                self.buildingList = [[BuildingList alloc] initWithStyle:UITableViewStylePlain];
            }
            self.buildingList.building_id = self.building_id;
            self.buildingList.location = self.location;
            self.buildingList.level = self.level;
            self.buildingList.title = [Globals.i getBuildingDict:self.building_id][@"building_name"];
            
            [UIManager.i showTemplate:@[self.buildingList] :self.buildingList.title];
        }
    }
    
    return nil;
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
