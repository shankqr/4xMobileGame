//
//  MarchesView.m
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

#import "MarchesView.h"
#import "Globals.h"

@interface MarchesView ()

@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) NSMutableArray *a_rows;
@property (nonatomic, strong) NSMutableArray *r_rows;
@property (nonatomic, strong) NSMutableArray *a_troops;
@property (nonatomic, strong) NSMutableArray *r_troops;
@property (nonatomic, assign) NSInteger attack_time_total;

@end

@implementation MarchesView

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SpeedUpPercent"
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
    else if ([[notification name] isEqualToString:@"SpeedUpPercent"])
    {
        [self clearView];
        [self updateView];
    }
}

- (void)clearView
{
    self.r_rows = nil;
    self.a_rows = nil;
    self.r_troops = [[NSMutableArray alloc] init];
    self.a_troops = [[NSMutableArray alloc] init];

    self.ui_cells_array = nil;
    [self.tableView reloadData];
}

- (void)updateView
{
    [self notificationRegister];
    
    self.building_id = @"18";
    
    self.attack_time_total = 0;
    
    NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:self.level];
    NSString *capacity = [Globals.i numberFormat:buildingLevelDict[@"capacity"]];
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"March Capacity", nil) , @"r2": capacity, @"r2_bkg": @"bkg3", @"r2_color": @"2", @"c1": @" ", @"c1_ratio": @"4", @"i1": @"icon_march_capacity", @"i2": @"arrow_right"};
    NSMutableArray *rows1 = [@[row101, row102] mutableCopy];
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self setTitleLoading:1];
    [self setTitleLoading:2];
    
    [self.tableView reloadData];
    
    NSTimeInterval serverTimeInterval = [Globals.i updateTime];
    [self attacksFromHere:serverTimeInterval];
    [self reinforcementsFromHere:serverTimeInterval];
    
    if (!self.gameTimer.isValid)
    {
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)onTimer
{
    if ((self.ui_cells_array != nil) && ([[UIManager.i currentViewTitle] isEqualToString:self.title]))
    {
        if (self.a_rows != nil)
        {
            [self decreaseTimerAttack];
        }
        
        if (self.r_rows != nil)
        {
            [self decreaseTimerReinforce];
        }
    }
}

- (void)decreaseTimerAttack
{
    for (int i = 1; i < self.a_rows.count; i++)
    {
        NSInteger march_time_left = [self.a_rows[i][@"march_time_left"] integerValue] - 1;
        NSInteger march_time = [self.a_rows[i][@"march_time"] integerValue];
        
        if (march_time_left > 1)
        {
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.a_rows[i] copyItems:YES];
            NSString *is_return = self.a_rows[i][@"is_return"];
            
            float p1 = 1.0f - ((float)march_time_left/(float)march_time);
            if ([is_return isEqualToString:@"1"])
            {
                is_return = NSLocalizedString(@"Returning", nil);
            }
            else
            {
                is_return = NSLocalizedString(@"Reaching", nil);
            }
            NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"%@ in: %@", nil), is_return, [Globals.i getCountdownString:march_time_left]];
            
            NSString *p1_color = @"0";
            
            if (march_time_left > march_time)
            {
                NSInteger attack_time_left = march_time_left - march_time;
                if (self.attack_time_total == 0)
                {
                    self.attack_time_total = attack_time_left;
                }
                
                p1_text = [NSString stringWithFormat:NSLocalizedString(@"Attacking: %@", nil), [Globals.i getCountdownString:attack_time_left]];
                p1 = 1.0f - ((float)attack_time_left/(float)self.attack_time_total);
                p1_color = @"1";
            }
            else
            {
                self.attack_time_total = 0;
            }
            
            [dict1 setValue:@(march_time_left) forKey:@"march_time_left"];
            [dict1 setValue:@(p1) forKey:@"p1"];
            [dict1 setValue:p1_text forKey:@"p1_text"];
            [dict1 setValue:p1_color forKey:@"p1_color"];
            
            if (self.ui_cells_array[1] != nil)
            {
                [self.ui_cells_array[1] removeObjectAtIndex:i];
                [self.ui_cells_array[1] insertObject:dict1 atIndex:i];
            }
        }
        else if (march_time_left < 2) //TODO: See if < 2 is ok or else change back to == 1
        {
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.a_rows[i] copyItems:YES];
            NSString *is_return = self.a_rows[i][@"is_return"];
            
            if ([is_return isEqualToString:@"1"])
            {
                if (self.ui_cells_array[1] != nil)
                {
                    [self.ui_cells_array[1] removeObjectAtIndex:i];
                    [self.ui_cells_array[1] removeObjectAtIndex:i];
                    
                    NSInteger t_index = i-1;
                    if (self.a_troops.count > t_index)
                    {
                        [self.a_troops removeObjectAtIndex:t_index];
                    }
                    
                    if (self.a_troops.count < 1)
                    {
                        NSDictionary *row202 = @{@"r1": NSLocalizedString(@"None", nil), @"r1_align": @"1", @"nofooter": @"1"};
                        [self.ui_cells_array[1] addObject:row202];
                    }
                }
            }
            else if ([is_return isEqualToString:@"0"])
            {
                NSInteger job_time = [self.a_rows[i][@"job_time"] integerValue];
                
                NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Returning in: %@", nil), [Globals.i getCountdownString:march_time_left]];
                NSInteger march_time_left = march_time + job_time;
                
                [dict1 setValue:p1_text forKey:@"p1_text"];
                [dict1 setValue:@"1" forKey:@"is_return"];
                [dict1 setValue:@(march_time_left) forKey:@"march_time_left"];
                [dict1 setValue:@"icon_march_returning" forKey:@"r2_icon"];
                [dict1 addEntriesFromDictionary:@{@"fit": @"1"}];
                
                NSDictionary *rowButtons = @{@"r1": @" ", @"fit": @"1"};
                
                if (self.ui_cells_array[1] != nil)
                {
                    [self.ui_cells_array[1] removeObjectAtIndex:i];
                    [self.ui_cells_array[1] removeObjectAtIndex:i];
                    [self.ui_cells_array[1] insertObject:rowButtons atIndex:i];
                    [self.ui_cells_array[1] insertObject:dict1 atIndex:i];
                }
            }
        }
    }
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)decreaseTimerReinforce
{
    for (int i = 1; i < self.r_rows.count; i++)
    {
        NSInteger march_time_left = [self.r_rows[i][@"march_time_left"] integerValue] - 1;
        if (march_time_left > 1)
        {
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.r_rows[i] copyItems:YES];
            NSString *is_return = self.r_rows[i][@"is_return"];

            NSInteger march_time = [self.r_rows[i][@"march_time"] integerValue];
            float p1 = 1.0f - ((float)march_time_left/(float)march_time);
            if ([is_return isEqualToString:@"1"])
            {
                is_return = NSLocalizedString(@"Returning", nil);
            }
            else
            {
                is_return = NSLocalizedString(@"Reaching", nil);
            }
            NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"%@ in: %@", nil), is_return, [Globals.i getCountdownString:march_time_left]];
            
            [dict1 setValue:@(march_time_left) forKey:@"march_time_left"];
            [dict1 setValue:@(p1) forKey:@"p1"];
            [dict1 setValue:p1_text forKey:@"p1_text"];
            
            if (self.ui_cells_array[2] != nil)
            {
                [self.ui_cells_array[2] removeObjectAtIndex:i];
                [self.ui_cells_array[2] insertObject:dict1 atIndex:i];
            }
        }
        else if (march_time_left < 2)
        {
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.r_rows[i] copyItems:YES];
            NSString *is_return = self.r_rows[i][@"is_return"];

            if ([is_return isEqualToString:@"1"])
            {
                if (self.ui_cells_array[2] != nil)
                {
                    [self.ui_cells_array[2] removeObjectAtIndex:i];
                    [self.ui_cells_array[2] removeObjectAtIndex:i];
                    
                    NSInteger t_index = i-1;
                    if (self.r_troops.count > t_index)
                    {
                        [self.r_troops removeObjectAtIndex:t_index];
                    }
                    
                    if (self.r_troops.count < 1)
                    {
                        NSDictionary *row202 = @{@"r1": NSLocalizedString(@"None", nil), @"r1_align": @"1", @"nofooter": @"1"};
                        [self.ui_cells_array[2] addObject:row202];
                    }
                }
            }
            else if ([is_return isEqualToString:@"0"])
            {
                [dict1 setValue:@(0) forKey:@"march_time_left"];
                [dict1 setValue:@"icon_reinforce" forKey:@"r2_icon"];
                [dict1 removeObjectsForKeys:@[@"p1", @"p1_text"]];
                
                NSMutableDictionary *dict2 = [[NSMutableDictionary alloc] initWithDictionary:self.r_rows[i+1] copyItems:YES];
                [dict2 setValue:@"Bring Home" forKey:@"r1"];
                [dict2 setValue:@"3" forKey:@"r1_button"];
                [dict2 setValue:@"1" forKey:@"e1_button"];
                
                if (self.ui_cells_array[2] != nil)
                {
                    [self.ui_cells_array[2] removeObjectAtIndex:i];
                    [self.ui_cells_array[2] removeObjectAtIndex:i];
                    [self.ui_cells_array[2] insertObject:dict2 atIndex:i];
                    [self.ui_cells_array[2] insertObject:dict1 atIndex:i];
                }
            }
        }
    }
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)attacksFromHere:(NSTimeInterval)serverTimeInterval
{
    NSString *title = NSLocalizedString(@"Attacks", nil);
    NSString *r1_icon = @"icon_attack";
    NSString *row_id = @"attack_id";
    
    NSString *r1_button = @"0";
    NSString *r1_title = @" "; //@"Recall" TODO: Disable recall attacks for now
    
    [Globals.i GetAttacksOut:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *allProfiles = [[NSMutableArray alloc] init];
                 
                 for (NSDictionary *dict in Globals.i.attacks_out)
                 {
                     NSInteger total_troops = 0;
                     
                     NSMutableArray *troopArray = [Globals.i createTroopList:dict];
                     
                     total_troops = [troopArray[troopArray.count-1] integerValue];
                     
                     [troopArray removeObjectAtIndex:troopArray.count-1];
                     
                     [self.a_troops addObject:troopArray];
                     
                     NSString *strDate = dict[@"date_arrive"];
                     
                     NSDate *queueDate = [Globals.i dateParser:strDate];
                     NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
                     NSInteger march_time_left = queueTime - serverTimeInterval;
                     
                     if (march_time_left > 1)
                     {
                         NSInteger march_time = [dict[@"march_time"] integerValue];
                         float p1 = 1.0f - ((float)march_time_left/(float)march_time);
                         NSString *r2_icon = @"icon_march_reaching";
                         NSString *r2 = [NSString stringWithFormat:@"%@(%@,%@)", dict[@"to_base_name"], dict[@"to_map_x"], dict[@"to_map_y"]];
                         NSString *b1 = [NSString stringWithFormat:NSLocalizedString(@"Troops Sent: %@", nil), [Globals.i intString:total_troops]];
                         
                         NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Reaching in: %@", nil), [Globals.i getCountdownString:march_time_left]];
                         
                         NSDictionary *row1 = @{row_id: dict[row_id], @"p_id": dict[@"to_profile_id"], @"is_return": @"0", @"job_time": dict[@"job_time"], @"march_time": @(march_time), @"march_time_left": @(march_time_left), @"p1": @(p1), @"p1_text": p1_text, @"p1_color": @"0", @"p1_width_p": @"1", @"i1": [NSString stringWithFormat:@"face_%@", dict[@"to_profile_face"]], @"i1_h": @" ", @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", dict[@"to_alliance_rank"]], @"r1": dict[@"to_profile_name"], @"n1_width": @"60", @"r2": r2, @"r2_icon": r2_icon, @"b1": b1, @"nofooter": @"1", @"extra_cell_height":@"0"};
                         [allProfiles addObject:row1];
                         
                         NSDictionary *rowButtons = @{@"r1": r1_title, @"c1": NSLocalizedString(@"Troops", nil), @"e1": NSLocalizedString(@"Speed Up", nil), @"r1_button": r1_button, @"c1_button": @"2", @"e1_button": @"1", @"c1_ratio": @"3"};
                         [allProfiles addObject:rowButtons];
                     }
                     else
                     {
                         NSString *strDate = dict[@"date_return"];
                         
                         NSDate *queueDate = [Globals.i dateParser:strDate];
                         NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
                         NSInteger march_time_left = queueTime - serverTimeInterval;
                         
                         //NSInteger job_time = [dict[@"job_time"] integerValue];
                         
                         if (march_time_left > 1) //RETURNING
                         {
                             //march_time_left = march_time_left - job_time;

                             NSInteger march_time = [dict[@"march_time"] integerValue];
                             //march_time = march_time - job_time;
                             
                             float p1 = 1.0f - ((float)march_time_left/(float)march_time);
                             NSString *r2_icon = @"icon_march_returning";
                             NSString *r2 = [NSString stringWithFormat:@"%@(%@,%@)", dict[@"to_base_name"], dict[@"to_map_x"], dict[@"to_map_y"]];
                             NSString *b1 = [NSString stringWithFormat:NSLocalizedString(@"Troops Sent: %@", nil), [Globals.i intString:total_troops]];
                             
                             NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Returning in: %@", nil), [Globals.i getCountdownString:march_time_left]];
                             
                             NSDictionary *row1 = @{@"fit": @"1", row_id: dict[row_id], @"p_id": dict[@"to_profile_id"], @"is_return": @"1", @"march_time": @(march_time), @"march_time_left": @(march_time_left), @"p1": @(p1), @"p1_text": p1_text, @"p1_color": @"0", @"p1_width_p": @"1", @"i1": [NSString stringWithFormat:@"face_%@", dict[@"to_profile_face"]], @"i1_h": @" ", @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", dict[@"to_alliance_rank"]], @"r1": dict[@"to_profile_name"], @"n1_width": @"60", @"r2": r2, @"r2_icon": r2_icon, @"b1": b1, @"nofooter": @"1", @"extra_cell_height":@"0"};
                             [allProfiles addObject:row1];
                             
                             NSDictionary *rowButtons = @{@"r1": @" ", @"fit": @"1"};
                             [allProfiles addObject:rowButtons];
                         }
                     }
                 }
                 
                 if (allProfiles.count > 0)
                 {
                     if ([self.ui_cells_array[1] count] == 2)
                     {
                         [self.ui_cells_array removeObjectAtIndex:1];
                     }
                     
                     NSDictionary *row201 = @{@"r1": title, @"r1_icon": r1_icon, @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"nofooter": @"1"};
                     self.a_rows = [@[row201] mutableCopy];
                     [self.a_rows addObjectsFromArray:allProfiles];
                     [self.ui_cells_array insertObject:self.a_rows atIndex:1];
                 }
                 else
                 {
                     [self setTitleNone:1];
                 }
             }
             else
             {
                 [self setTitleNone:1];
             }
         });
     }];
}

- (void)reinforcementsFromHere:(NSTimeInterval)serverTimeInterval
{
    NSString *title = NSLocalizedString(@"Reinforcing", nil);
    NSString *r1_icon = @"icon_reinforce";
    NSString *row_id = @"reinforce_id";
    NSString *r1_title = NSLocalizedString(@"Bring Home", nil);
    
    [Globals.i GetReinforcesOut:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *allProfiles = [[NSMutableArray alloc] init];
                 for (NSDictionary *dict in Globals.i.reinforces_out)
                 {
                     NSInteger total_troops = 0;
                     
                     NSMutableArray *troopArray = [Globals.i createTroopList:dict];
                     
                     total_troops = [troopArray[troopArray.count-1] integerValue];
                     
                     [troopArray removeObjectAtIndex:troopArray.count-1];
                     
                     [self.r_troops addObject:troopArray];
                     
                     NSString *strDate = dict[@"date_arrive"];
                     
                     NSDate *queueDate = [Globals.i dateParser:strDate];
                     NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
                     NSInteger march_time_left = queueTime - serverTimeInterval;
                     
                     if (march_time_left > 1)
                     {
                         NSInteger march_time = [dict[@"march_time"] integerValue];
                         float p1 = 1.0f - ((float)march_time_left/(float)march_time);
                         NSString *is_return;
                         NSString *r2_icon;
                         NSString *r2 = [NSString stringWithFormat:@"%@(%@,%@)", dict[@"to_base_name"], dict[@"to_map_x"], dict[@"to_map_y"]];
                         NSString *b1;
                         NSString *r1_button = @"1";
                         
                         if ([dict[@"is_return"] isEqualToString:@"1"])
                         {
                             is_return = NSLocalizedString(@"Returning", nil);
                             r2_icon = @"icon_march_returning";
                             b1 = [NSString stringWithFormat:NSLocalizedString(@"Troops Returning: %@", nil), [Globals.i intString:total_troops]];
                         }
                         else
                         {
                             is_return = NSLocalizedString(@"Reaching", nil);
                             r2_icon = @"icon_march_reaching";
                             b1 = [NSString stringWithFormat:NSLocalizedString(@"Troops Sent: %@", nil), [Globals.i intString:total_troops]];
                         }
                         
                         NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"%@ in: %@", nil), is_return, [Globals.i getCountdownString:march_time_left]];

                         NSDictionary *row1 = @{row_id: dict[row_id], @"p_id": dict[@"to_profile_id"], @"is_return": dict[@"is_return"], @"march_time": @(march_time), @"march_time_left": @(march_time_left), @"p1": @(p1), @"p1_text": p1_text, @"p1_width_p": @"1", @"i1": [NSString stringWithFormat:@"face_%@", dict[@"to_profile_face"]], @"i1_h": @" ", @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", dict[@"to_alliance_rank"]], @"r1": dict[@"to_profile_name"], @"n1_width": @"60", @"r2": r2, @"r2_icon": r2_icon, @"b1": b1, @"nofooter": @"1", @"extra_cell_height":@"0"};
                         [allProfiles addObject:row1];
                         
                         NSDictionary *rowButtons = @{@"r1": r1_title, @"c1": NSLocalizedString(@"Troops", nil), @"e1": NSLocalizedString(@"Speed Up", nil), @"r1_button": r1_button, @"c1_button": @"2", @"e1_button": @"2", @"c1_ratio": @"3"};
                         [allProfiles addObject:rowButtons];
                     }
                     else
                     {
                         if (![dict[@"is_return"] isEqualToString:@"1"])
                         {
                             NSDictionary *row1 = @{row_id: dict[row_id], @"to_map_x": dict[@"to_map_x"], @"to_map_y": dict[@"to_map_y"], @"p_id": dict[@"to_profile_id"], @"march_time_left": @(0), @"i1": [NSString stringWithFormat:@"face_%@", dict[@"to_profile_face"]], @"i1_h": @" ", @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", dict[@"to_alliance_rank"]], @"r1": dict[@"to_profile_name"], @"n1_width": @"60", @"r2": [NSString stringWithFormat:@"%@(%@,%@)", dict[@"to_base_name"], dict[@"to_map_x"], dict[@"to_map_y"]], @"r2_icon": @"icon_reinforce", @"b1": [NSString stringWithFormat:NSLocalizedString(@"Troops Sent: %@", nil), [Globals.i intString:total_troops]], @"nofooter": @"1", @"extra_cell_height":@"0"};
                             [allProfiles addObject:row1];
                             
                             NSDictionary *rowButtons = @{@"r1": NSLocalizedString(@"Bring Home", nil), @"c1": NSLocalizedString(@"Troops", nil), @"e1": NSLocalizedString(@"Speed Up", nil), @"r1_button": @"2", @"c1_button": @"2", @"e1_button": @"1", @"c1_ratio": @"3"};
                             [allProfiles addObject:rowButtons];
                         }
                     }
                 }
                 
                 if (allProfiles.count > 0)
                 {
                     if ([self.ui_cells_array[2] count] == 2)
                     {
                         [self.ui_cells_array removeObjectAtIndex:2];
                     }
                     
                     NSDictionary *row201 = @{@"r1": title, @"r1_icon": r1_icon, @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"nofooter": @"1"};
                     self.r_rows = [@[row201] mutableCopy];
                     [self.r_rows addObjectsFromArray:allProfiles];
                     [self.ui_cells_array insertObject:self.r_rows atIndex:2];
                 }
                 else
                 {
                     [self setTitleNone:2];
                 }
             }
             else
             {
                 [self setTitleNone:2];
             }
         });
     }];
}

- (void)setTitleLoading:(NSInteger)type
{
    NSString *title = NSLocalizedString(@"Attacks", nil);
    NSString *r1_icon = @"icon_attack";
    
    if (type == 2)
    {
        title = NSLocalizedString(@"Reinforcing", nil);
        r1_icon = @"icon_reinforce";
    }
    
    NSDictionary *row201 = @{@"r1": title, @"r1_icon": r1_icon, @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"nofooter": @"1"};
    NSDictionary *row202 = @{@"r1": NSLocalizedString(@"Loading...", nil), @"r1_align": @"1", @"nofooter": @"1"};
    NSMutableArray *rows2 = [@[row201, row202] mutableCopy];
    [self.ui_cells_array insertObject:rows2 atIndex:type];
    
    [self.tableView reloadData];
}

- (void)setTitleNone:(NSInteger)type
{
    if ([self.ui_cells_array[type] count] == 2)
    {
        [self.ui_cells_array removeObjectAtIndex:type];
    }
    
    NSString *title = NSLocalizedString(@"Attacks", nil);
    NSString *r1_icon = @"icon_attack";
    
    if (type == 1)
    {
        self.a_rows = nil;
    }
    else if (type == 2)
    {
        self.r_rows = nil;
        title = NSLocalizedString(@"Reinforcing", nil);
        r1_icon = @"icon_reinforce";
    }
    
    NSDictionary *row201 = @{@"r1": title, @"r1_icon": r1_icon, @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"nofooter": @"1"};
    NSDictionary *row202 = @{@"r1": @"None", @"r1_align": @"1", @"nofooter": @"1"};
    NSMutableArray *rows2 = [@[row201, row202] mutableCopy];
    [self.ui_cells_array insertObject:rows2 atIndex:type];
    
    [self.tableView reloadData];
}

- (void)reinforceGoHome:(NSString *)reinforce_id :(NSString *)p_id :(NSString *)to_map_x :(NSString *)to_map_y
{
    NSString *service_name = @"ReinforcementsReturn";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], Globals.i.wsBaseDict[@"base_id"], reinforce_id, p_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i updateBaseDict:^(BOOL success, NSData *data)
              {
                  NSString *tv_title = [NSString stringWithFormat:@"Returning from (%@,%@)", to_map_x, to_map_y];
                  [Globals.i setTimerViewTitle:TV_REINFORCE :tv_title];
                  
                  [Globals.i setupReinforceQueue:[Globals.i updateTime]];
                  
                  [self clearView];
                  [self updateView]; //updates reinforce_out
                  
                  NSMutableDictionary *userInfo1 = [NSMutableDictionary dictionary];
                  [userInfo1 setObject:to_map_x forKey:@"to_x"];
                  [userInfo1 setObject:to_map_y forKey:@"to_y"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMap"
                                                                      object:self
                                                                    userInfo:userInfo1];
                  
                  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                  [userInfo setObject:[@(TV_REINFORCE) stringValue] forKey:@"tv_id"];
                  [userInfo setObject:to_map_x forKey:@"to_x"];
                  [userInfo setObject:to_map_y forKey:@"to_y"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawMarchingLine"
                                                                      object:self
                                                                    userInfo:userInfo];
                  
                  [UIManager.i showToast:NSLocalizedString(@"Reinforcements pulled back!", nil)
                           optionalTitle:@"ReinforcementPulled"
                           optionalImage:@"icon_check"];
              }];
         }
     }];
}

- (void)img1_tap:(id)sender
{
    [Globals.i play_button];
    
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSMutableDictionary *rowTarget = self.ui_cells_array[section][row];
    
    NSString *selected_profile_id = rowTarget[@"p_id"];
    if (selected_profile_id != nil)
    {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:selected_profile_id forKey:@"profile_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)button1_tap:(id)sender //Recall or bring home
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"r1_button"] integerValue];
    
    if (button > 1)
    {
        row = row - 1; //Because the button is always a row bellow
        NSMutableDictionary *rowTarget = self.ui_cells_array[section][row];
        
        if (section == 1) //Attacking recall
        {
            NSString *row_id = rowTarget[@"attack_id"];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"recallattack" forKey:@"item_category2"];
            [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
            [userInfo setObject:[@(TV_ATTACK) stringValue] forKey:@"item_type"];
            [userInfo setObject:row_id forKey:@"row_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (section == 2) //Reinforcing bring home
        {
            [UIManager.i showDialogBlock:[NSString stringWithFormat:NSLocalizedString(@"Pull back troops from %@ ?", nil), rowTarget[@"r2"]]
                                      title:@"PullbackReinforcementConfirmation"
                                        type:2
                                        :^(NSInteger index, NSString *text)
             {
                 if (index == 1) //YES
                 {
                     if ([Globals.i isTvViewFromStack:TV_REINFORCE] || [Globals.i isTvViewFromStack:TV_TRANSFER])
                     {
                         [UIManager.i showDialog:NSLocalizedString(@"You can only bring one set of Troops home any one time. You could speedup the march, or wait for them to reach their destination. Please try again.", nil) title:@"OneReinforceReturnRestriction"];
                     }
                     else
                     {
                         [self reinforceGoHome:rowTarget[@"reinforce_id"] :rowTarget[@"p_id"] :rowTarget[@"to_map_x"] :rowTarget[@"to_map_y"]];
                     }
                 }
             }];
        }
    }
}

- (void)button2_tap:(id)sender //Troops
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"c1_button"] integerValue];
    
    if (button > 1)
    {
        NSInteger i = ((row+1)/2)-1;
        NSMutableArray *troopArray;
        
        if ((section == 1) && (self.a_troops.count > 0)) //Attacking
        {
            troopArray = self.a_troops[i];
        }
        else if ((section == 2) && (self.r_troops.count > 0)) //Reinforcing
        {
            troopArray = self.r_troops[i];
        }
        else
        {
            troopArray = [[NSMutableArray alloc] init];
        }
        
        NSMutableArray *dialogRows = [@[troopArray] mutableCopy];
        
        [UIManager.i showDialogBlockRow:dialogRows title:@"MarchType" type:3
                                    :^(NSInteger index, NSString *text)
         { }];
    }
}

- (void)button3_tap:(id)sender //Speed Up
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"e1_button"] integerValue];
    
    if (button > 1)
    {
        NSInteger tv_id = 99;
        NSString *row_id;
        
        row = row - 1; //Because the button is always a row bellow
        NSMutableDictionary *rowTarget = self.ui_cells_array[section][row];
        
        if (section == 1) //Attacking
        {
            tv_id = TV_ATTACK;
            row_id = rowTarget[@"attack_id"];
        }
        else if (section == 2) //Reinforcing
        {
            tv_id = TV_REINFORCE;
            row_id = rowTarget[@"reinforce_id"];
        }
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"march" forKey:@"item_category2"];
        [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
        [userInfo setObject:[@(tv_id) stringValue] forKey:@"item_type"];
        if (row_id != nil)
        {
            [userInfo setObject:row_id forKey:@"row_id"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.img1 addTarget:self action:@selector(img1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.img1.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_e.btn addTarget:self action:@selector(button3_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_e.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.building_id forKey:@"building_id"];
            [userInfo setObject:@(self.level) forKey:@"building_level"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildingChart"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    
    return nil;
}

@end
