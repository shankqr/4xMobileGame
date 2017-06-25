//
//  TrainView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 10/20/13.
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

#import "TrainView.h"
#import "Globals.h"
#import "BuildingList.h"
#import "TroopView.h"

@interface TrainView ()

@property (nonatomic, strong) BuildingList *buildingList;
@property (nonatomic, strong) TroopView *troopView;
@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) TimerView *tv_view;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, assign) NSInteger buildings_output;
@property (nonatomic, assign) NSInteger highest_buildings_level;
@property (nonatomic, assign) NSInteger unit_index;

@end

@implementation TrainView


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
                                                 name:@"UpdateTrainView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChooseTroop"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CloseTemplateBefore"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *view_title = [userInfo objectForKey:@"view_title"];
        
        NSLog(@"CloseTemplateBefore self.title :%@ , notification.title: %@",self.title,view_title);
        
        if ([self.title isEqualToString:view_title])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    }
    else if ([[notification name] isEqualToString:@"TimerViewEnd"] || [[notification name] isEqualToString:@"UpdateTrainView"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *tv_id = [userInfo objectForKey:@"tv_id"];
            
            NSLog(@"TimerViewEnd self.unit_type :%@ , tv_id: %@",self.unit_type,tv_id);
            
            if (([self.unit_type isEqualToString:@"a"]) && ([tv_id integerValue] == TV_A))
            {
                [self performSelector:@selector(updateView) withObject:self afterDelay:0.5];
            }
            else if (([self.unit_type isEqualToString:@"b"]) && ([tv_id integerValue] == TV_B))
            {
                [self performSelector:@selector(updateView) withObject:self afterDelay:0.5];
            }
            else if (([self.unit_type isEqualToString:@"c"]) && ([tv_id integerValue] == TV_C))
            {
                [self performSelector:@selector(updateView) withObject:self afterDelay:0.5];
            }
            else if (([self.unit_type isEqualToString:@"d"]) && ([tv_id integerValue] == TV_D))
            {
                [self performSelector:@selector(updateView) withObject:self afterDelay:0.5];
            }

        }
    }
    else if ([[notification name] isEqualToString:@"ChooseTroop"])
    {
        NSLog(@"Choose this Troop");
        
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *troop_section = [userInfo objectForKey:@"troop_section"];
            NSNumber *troop_index = [userInfo objectForKey:@"troop_index"];
            
            NSLog(@"troop_section : %@",troop_section);
            NSLog(@"troop_index : %@",troop_index);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[troop_index intValue] inSection:[troop_section intValue]];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"customCellView TrainList : %@",customCellView);

            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView.delegate tableView:self.tableView willSelectRowAtIndexPath:indexPath];
            
            //NSLog(@"ChooseTroop Done");
            
        }

    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    if ([self.unit_type isEqualToString:@"a"])
    {
        self.building_id = @"6";
        self.tv_view = [Globals.i copyTvViewFromStack:TV_A];
    }
    else if ([self.unit_type isEqualToString:@"b"])
    {
        self.building_id = @"7";
        self.tv_view = [Globals.i copyTvViewFromStack:TV_B];
    }
    else if ([self.unit_type isEqualToString:@"c"])
    {
        self.building_id = @"8";
        self.tv_view = [Globals.i copyTvViewFromStack:TV_C];
    }
    else if ([self.unit_type isEqualToString:@"d"])
    {
        self.building_id = @"9";
        self.tv_view = [Globals.i copyTvViewFromStack:TV_D];
    }
    
    NSInteger count = 1;
    
    self.buildings_output = 0;
    self.highest_buildings_level = 1;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:self.building_id])
        {
            NSInteger lvl = [dict[@"building_level"] integerValue];
            
            if (lvl > self.highest_buildings_level)
            {
                self.highest_buildings_level = lvl;
            }
            
            NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:lvl];
            
            NSInteger capacity = [buildingLevelDict[@"capacity"] integerValue];
            
            self.buildings_output = self.buildings_output + capacity;
            
            count = count + 1;
        }
    }
    NSString *str_output = [Globals.i intString:self.buildings_output];
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Training Capacity", nil), @"r2": str_output, @"r2_bkg": @"bkg3", @"r2_color": @"2", @"c1": @" ", @"c1_ratio": @"4", @"i1": [NSString stringWithFormat:@"icon_train_%@", self.unit_type], @"i2": @"arrow_right"};
    
    NSMutableArray *rows1 = [@[row101, row102] mutableCopy];
    
    self.unit_index = 1;
    NSMutableArray *unit_array = [Globals.i getUnitArray:self.unit_type];
    for (NSMutableDictionary *unit_dict in unit_array)
    {
        NSString *type_tier = [NSString stringWithFormat:@"%@%@", self.unit_type, [@(self.unit_index) stringValue]];
        NSString *var_name = [NSString stringWithFormat:@"base_%@", type_tier];
        NSInteger own = [[Globals.i valueForKey:var_name] integerValue];
        NSString *owned = [Globals.i intString:own];
        
        NSString *n1 = @"";
        NSString *n1_color = @"1";
        
        if (self.unit_index > 1)
        {
            NSString *var_r = [NSString stringWithFormat:@"research_%@", type_tier];
            NSInteger thisrank = [Globals.i.wsBaseDict[var_r] integerValue];
            if (thisrank > 0)
            {
                n1 = @"";
                n1_color = @"6";
            }
            else
            {
                n1 = NSLocalizedString(@"LOCKED", nil);
                n1_color = @"1";
            }
        }
        
        NSMutableDictionary *row201 = [@{@"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": unit_dict[@"name"], @"b1": unit_dict[@"info"], @"i1": [NSString stringWithFormat:@"icon_%@", type_tier], @"c1": [NSString stringWithFormat:NSLocalizedString(@"Own:%@", nil), owned], @"r1_bold": @"1", @"c1_ratio": @"3", @"n1_width": @"64", @"i2": @"arrow_right"} mutableCopy];
        [rows1 addObject:row201];
        
        self.unit_index = self.unit_index + 1;
    }
    
    NSDictionary *row103 = @{@"r1": @" ", @"nofooter": @"1"};
    
    [rows1 addObject:row103];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    
    //Block it if its training
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
        else if ((indexPath.row > 1) && (indexPath.row < [self.ui_cells_array[0] count]))
        {
            NSString *n1 = [self.ui_cells_array[0][indexPath.row] objectForKey:@"n1"];
            if ([n1 isEqualToString:NSLocalizedString(@"LOCKED", nil)])
            {
                [UIManager.i showDialog:NSLocalizedString(@"Unlock this unit by researching it at the Library.", nil) title:@"UnitResearchRequired"];
            }
            else
            {
                //NSLog(@"TROOP CLICKED?");
                if (self.troopView == nil)
                {
                    self.troopView = [[TroopView alloc] initWithStyle:UITableViewStylePlain];
                }
                self.troopView.unit_type = self.unit_type;
                self.troopView.unit_tier = [@(indexPath.row-1) stringValue];
                self.troopView.buildings_output = self.buildings_output;
                self.troopView.highest_buildings_level = self.highest_buildings_level;
                self.troopView.building_name = [Globals.i getBuildingDict:self.building_id][@"building_name"];
                self.troopView.sel_value = 1;
                self.troopView.title = @"Train Troops";
                
                [UIManager.i showTemplate:@[self.troopView] :self.troopView.title];
                [self.troopView clearView];
                [self.troopView updateView];
            }
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
