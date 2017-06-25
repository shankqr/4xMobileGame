//
//  WatchtowerView.m
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

#import "WatchtowerView.h"
#import "Globals.h"

@interface WatchtowerView ()

@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) NSMutableArray *a_rows;
@property (nonatomic, strong) NSMutableArray *r_rows;
@property (nonatomic, strong) NSMutableArray *t_rows;
@property (nonatomic, strong) NSMutableArray *a_troops;
@property (nonatomic, strong) NSMutableArray *r_troops;
@property (nonatomic, strong) NSMutableArray *t_res;
@property (nonatomic, assign) NSInteger march_time_longest;

@end

@implementation WatchtowerView

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateWatchtower"
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
    else if ([[notification name] isEqualToString:@"UpdateWatchtower"])
    {
        [self updateView];
    }
}

- (void)clearView
{
    self.a_rows = nil;
    self.r_rows = nil;
    self.t_rows = nil;
    
    self.a_troops = [[NSMutableArray alloc] init];
    self.r_troops = [[NSMutableArray alloc] init];
    self.t_res = [[NSMutableArray alloc] init];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
}

- (void)updateView
{
    [self notificationRegister];
    
    [self clearView];
    
    self.building_id = @"14";
    
    self.march_time_longest = 0;
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    NSArray *rows1 = @[row101];
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self setTitleLoading:1];
    [self setTitleLoading:2];
    [self setTitleLoading:3];
    
    NSDictionary *row501 = @{@"r1": @" ", @"nofooter": @"1"};
    NSDictionary *row502 = @{@"r1": NSLocalizedString(@"More Information", nil), @"r1_button": @"2", @"nofooter": @"1"};
    NSArray *rows5 = @[row501, row502];
    [self.ui_cells_array addObject:rows5];
    
    [self.tableView reloadData];
    
    NSTimeInterval serverTimeInterval = [Globals.i updateTime];
    [self attacksToHere:serverTimeInterval];
    [self reinforcementsToHere:serverTimeInterval];
    [self tradesToHere:serverTimeInterval];
    
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
        
        if (self.t_rows != nil)
        {
            [self decreaseTimerTrade];
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
            float p1 = 1.0f - ((float)march_time_left/(float)march_time);
            NSString *p1_text = [NSString stringWithFormat:@"Attack in: %@", [Globals.i getCountdownString:march_time_left]];
            
            NSString *p1_color = @"0";
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
        else if ((march_time_left < 2) && (self.ui_cells_array[1] != nil)) //TODO: See if < 2 is ok or else change back to == 1
        {
            NSInteger time_under_attack = 15;
            if (march_time_left > -time_under_attack)
            {
                NSInteger attack_time_left = march_time_left + time_under_attack;
                NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Under Attack: %@", nil), [Globals.i getCountdownString:attack_time_left]];
                float p1 = 1.0f - ((float)attack_time_left/time_under_attack);
                NSString *p1_color = @"1";
                
                NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.a_rows[i] copyItems:YES];
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
            else
            {
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
    }
    
    [self.tableView reloadData];
}

- (void)decreaseTimerReinforce
{
    for (int i = 1; i < self.r_rows.count; i++)
    {
        NSInteger march_time_left = [self.r_rows[i][@"march_time_left"] integerValue] - 1;
        NSInteger march_time = [self.r_rows[i][@"march_time"] integerValue];
        if (march_time_left > 1)
        {
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.r_rows[i] copyItems:YES];
            float p1 = 1.0f - ((float)march_time_left/(float)march_time);
            NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Arrive in: %@", nil), [Globals.i getCountdownString:march_time_left]];
            
            [dict1 setValue:@(march_time_left) forKey:@"march_time_left"];
            [dict1 setValue:@(p1) forKey:@"p1"];
            [dict1 setValue:p1_text forKey:@"p1_text"];
            
            if (self.ui_cells_array[2] != nil)
            {
                [self.ui_cells_array[2] removeObjectAtIndex:i];
                [self.ui_cells_array[2] insertObject:dict1 atIndex:i];
            }
        }
        else if ((march_time_left < 2) && (self.ui_cells_array[2] != nil))
        {
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
    
    [self.tableView reloadData];
}

- (void)decreaseTimerTrade
{
    for (int i = 1; i < self.t_rows.count; i++)
    {
        NSInteger march_time_left = [self.t_rows[i][@"march_time_left"] integerValue] - 1;
        NSInteger march_time = [self.t_rows[i][@"march_time"] integerValue];
        if (march_time_left > 1)
        {
            NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.t_rows[i] copyItems:YES];
            float p1 = 1.0f - ((float)march_time_left/(float)march_time);
            NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Arrive in: %@", nil), [Globals.i getCountdownString:march_time_left]];
            
            [dict1 setValue:@(march_time_left) forKey:@"march_time_left"];
            [dict1 setValue:@(p1) forKey:@"p1"];
            [dict1 setValue:p1_text forKey:@"p1_text"];
            
            if (self.ui_cells_array[3] != nil)
            {
                [self.ui_cells_array[3] removeObjectAtIndex:i];
                [self.ui_cells_array[3] insertObject:dict1 atIndex:i];
            }
        }
        else if ((march_time_left < 2) && (self.ui_cells_array[3] != nil))
        {
            [self.ui_cells_array[3] removeObjectAtIndex:i];
            
            NSInteger t_index = i-1;
            if (self.t_res.count > t_index)
            {
                [self.t_res removeObjectAtIndex:t_index];
            }
            
            if (self.t_res.count < 1)
            {
                NSDictionary *row202 = @{@"r1": NSLocalizedString(@"None", nil), @"r1_align": @"1", @"nofooter": @"1"};
                [self.ui_cells_array[3] addObject:row202];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)attacksToHere:(NSTimeInterval)serverTimeInterval
{
    NSString *title = NSLocalizedString(@"Incoming Attacks", nil);
    NSString *r1_icon = @"icon_attack";
    NSString *row_id = @"attack_id";
    
    [Globals.i GetAttacksIn:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *allProfiles = [[NSMutableArray alloc] init];
                 for (NSDictionary *dict in Globals.i.attacks_in)
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
                         
                         NSString *i1 = @"icon_attack";
                         if (self.level > 2)
                         {
                             i1 = [NSString stringWithFormat:@"face_%@", dict[@"from_profile_face"]];
                         }
                         
                         NSString *r1 = NSLocalizedString(@"An incoming attack!", nil);
                         if (self.level > 4)
                         {
                             r1 = dict[@"from_profile_name"];
                         }
                         
                         NSString *r2 = @"";
                         if (self.level > 8)
                         {
                             r2 = [NSString stringWithFormat:@"%@(%@,%@)", dict[@"from_base_name"], dict[@"from_map_x"], dict[@"from_map_y"]];
                         }
                         else if (self.level > 6)
                         {
                             r2 = dict[@"from_base_name"];
                         }
                         
                         NSString *r1_icon = @"";
                         if (self.level > 10)
                         {
                             r1_icon = [NSString stringWithFormat:@"rank_%@", dict[@"from_alliance_rank"]];
                         }
                         
                         NSString *b1 = @"";
                         if (self.level > 12)
                         {
                             b1 = [NSString stringWithFormat:NSLocalizedString(@"Estimated Troops: %@", nil), [Globals.i autoNumber:[@(total_troops) stringValue]]];
                         }
                         
                         NSString *i2 = @"";
                         if (self.level > 14)
                         {
                             i2 = @"arrow_right";
                         }
                         
                         NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Attack in: %@", nil), [Globals.i getCountdownString:march_time_left]];
                         
                         if (march_time_left > self.march_time_longest)
                         {
                             self.march_time_longest = march_time_left;
                         }
                         
                         NSDictionary *row1 = @{row_id: dict[row_id], @"march_time": @(march_time), @"march_time_left": @(march_time_left), @"p1": @(p1), @"p1_text": p1_text, @"p1_color": @"0", @"p1_width_p": @"1", @"i1": i1, @"i1_aspect": @"1", @"r1_icon": r1_icon, @"r1": r1, @"n1_width": @"60", @"r2": r2, @"b1": b1, @"i2": i2};
                         [allProfiles addObject:row1];
                     }
                 }
                 
                 if (allProfiles.count > 0)
                 {
                     if ([self.ui_cells_array[1] count] == 2) //Remove Loading...
                     {
                         [self.ui_cells_array removeObjectAtIndex:1];
                     }
                     
                     NSDictionary *row201 = @{@"r1": title, @"r1_icon": r1_icon, @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"nofooter": @"1"};
                     self.a_rows = [@[row201] mutableCopy];
                     [self.a_rows addObjectsFromArray:allProfiles];
                     [self.ui_cells_array insertObject:self.a_rows atIndex:1];
                     
                     //Glow the border for the longest duration
                     NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                     [userInfo setObject:[@(self.march_time_longest) stringValue] forKey:@"march_time"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"GlowBordersAttack"
                                                                         object:self
                                                                       userInfo:userInfo];
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

- (void)reinforcementsToHere:(NSTimeInterval)serverTimeInterval
{
    NSString *title = NSLocalizedString(@"Incoming Reinforcements", nil);
    NSString *r1_icon = @"icon_reinforce";
    NSString *row_id = @"reinforce_id";
    
    [Globals.i GetReinforcesIn:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *allProfiles = [[NSMutableArray alloc] init];
                 for (NSDictionary *dict in Globals.i.reinforces_in)
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
                         NSString *r2 = [NSString stringWithFormat:@"%@(%@,%@)", dict[@"from_base_name"], dict[@"from_map_x"], dict[@"from_map_y"]];
                         NSString *b1 = [NSString stringWithFormat:NSLocalizedString(@"Total Troops: %@", nil), [Globals.i autoNumber:[@(total_troops) stringValue]]];
                         
                         NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Arrive in: %@", nil), [Globals.i getCountdownString:march_time_left]];
                         
                         NSDictionary *row1 = @{row_id: dict[row_id], @"march_time": @(march_time), @"march_time_left": @(march_time_left), @"p1": @(p1), @"p1_text": p1_text, @"p1_width_p": @"1", @"i1": [NSString stringWithFormat:@"face_%@", dict[@"from_profile_face"]], @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", dict[@"from_alliance_rank"]], @"r1": dict[@"from_profile_name"], @"n1_width": @"60", @"r2": r2, @"b1": b1, @"i2": @"arrow_right"};
                         [allProfiles addObject:row1];
                     }
                 }
                 
                 if (allProfiles.count > 0)
                 {
                     if ([self.ui_cells_array[2] count] == 2) //Remove Loading...
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

- (void)tradesToHere:(NSTimeInterval)serverTimeInterval
{
    NSString *title = NSLocalizedString(@"Incoming Trades", nil);
    NSString *r1_icon = @"icon_trade";
    NSString *row_id = @"trade_id";
    
    [Globals.i GetTradesIn:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *allProfiles = [[NSMutableArray alloc] init];
                 for (NSDictionary *dict in Globals.i.trades_in)
                 {
                     NSInteger total_resources = [self createResourcesList:dict];
                     
                     NSString *strDate = dict[@"date_arrive"];
                     
                     NSDate *queueDate = [Globals.i dateParser:strDate];
                     NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
                     NSInteger march_time_left = queueTime - serverTimeInterval;
                     
                     if (march_time_left > 1)
                     {
                         NSInteger march_time = [dict[@"march_time"] integerValue];
                         float p1 = 1.0f - ((float)march_time_left/(float)march_time);
                         NSString *r2 = [NSString stringWithFormat:@"%@(%@,%@)", dict[@"from_base_name"], dict[@"from_map_x"], dict[@"from_map_y"]];

                         NSString *b1 = [NSString stringWithFormat:NSLocalizedString(@"Total Resources: %@", nil), [Globals.i autoNumber:[@(total_resources) stringValue]]];
                         
                         NSString *p1_text = [NSString stringWithFormat:NSLocalizedString(@"Arrive in: %@", nil), [Globals.i getCountdownString:march_time_left]];
                         
                         NSDictionary *row1 = @{row_id: dict[row_id], @"march_time": @(march_time), @"march_time_left": @(march_time_left), @"p1": @(p1), @"p1_text": p1_text, @"p1_width_p": @"1", @"i1": [NSString stringWithFormat:@"face_%@", dict[@"from_profile_face"]], @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", dict[@"from_alliance_rank"]], @"r1": dict[@"from_profile_name"], @"n1_width": @"60", @"r2": r2, @"b1": b1, @"i2": @"arrow_right"};
                         [allProfiles addObject:row1];
                     }
                 }
                 
                 if (allProfiles.count > 0)
                 {
                     if ([self.ui_cells_array[3] count] == 2) //Remove Loading...
                     {
                         [self.ui_cells_array removeObjectAtIndex:3];
                     }
                     
                     NSDictionary *row201 = @{@"r1": title, @"r1_icon": r1_icon, @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"nofooter": @"1"};
                     self.t_rows = [@[row201] mutableCopy];
                     [self.t_rows addObjectsFromArray:allProfiles];
                     [self.ui_cells_array insertObject:self.t_rows atIndex:3];
                 }
                 else
                 {
                     [self setTitleNone:3];
                 }
             }
             else
             {
                 [self setTitleNone:3];
             }
         });
     }];
}

- (NSInteger)createResourcesList:(NSDictionary *)dict
{
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    NSInteger r1 = [dict[@"r1"] integerValue];
    NSInteger r2 = [dict[@"r2"] integerValue];
    NSInteger r3 = [dict[@"r3"] integerValue];
    NSInteger r4 = [dict[@"r4"] integerValue];
    NSInteger r5 = [dict[@"r5"] integerValue];
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Resource", nil), @"c1": NSLocalizedString(@"Amount", nil), @"r1_color": @"2", @"c1_color": @"2", @"c1_ratio": @"2", @"c1_align": @"2", @"r1_border": @"1", @"r1_align": @"1", @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    [rows1 addObject:row201];
    
    if (r1 > 0)
    {
        NSDictionary *row201 = @{@"r1": Globals.i.r1, @"r1_border": @"1", @"c1": [Globals.i intString:r1], @"c1_ratio": @"2", @"c1_align": @"2"};
        [rows1 addObject:row201];
    }
    if (r2 > 0)
    {
        NSDictionary *row202 = @{@"r1": Globals.i.r2, @"r1_border": @"1", @"c1": [Globals.i intString:r2], @"c1_ratio": @"2", @"c1_align": @"2"};
        [rows1 addObject:row202];
    }
    if (r3 > 0)
    {
        NSDictionary *row203 = @{@"r1": Globals.i.r3, @"r1_border": @"1", @"c1": [Globals.i intString:r3], @"c1_ratio": @"2", @"c1_align": @"2"};
        [rows1 addObject:row203];
    }
    if (r4 > 0)
    {
        NSDictionary *row301 = @{@"r1": Globals.i.r4, @"r1_border": @"1", @"c1": [Globals.i intString:r4], @"c1_ratio": @"2", @"c1_align": @"2"};
        [rows1 addObject:row301];
    }
    if (r5 > 0)
    {
        NSDictionary *row302 = @{@"r1": Globals.i.r5, @"r1_border": @"1", @"c1": [Globals.i intString:r5], @"c1_ratio": @"2", @"c1_align": @"2"};
        [rows1 addObject:row302];
    }
    
    NSInteger total_resources = r1 + r2 + r3 + r4 + r5;
    
    NSDictionary *row203 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Total Resources: %@", nil), [Globals.i intString:total_resources]], @"nofooter": @"1"};
    [rows1 addObject:row203];
    
    [self.t_res addObject:rows1];
    
    return total_resources;
}

- (void)setTitleLoading:(NSInteger)type
{
    NSString *title = NSLocalizedString(@"Incomings", nil);
    NSString *r1_icon = @"icon_reinforce";
    
    if (type == 1)
    {
        title = NSLocalizedString(@"Incoming Attacks", nil);
        r1_icon = @"icon_attack";
    }
    else if (type == 2)
    {
        title = NSLocalizedString(@"Incoming Reinforcements", nil);
        r1_icon = @"icon_reinforce";
    }
    else if (type == 3)
    {
        title = NSLocalizedString(@"Incoming Trades", nil);
        r1_icon = @"icon_trade";
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
    
    NSString *title = NSLocalizedString(@"Incomings", nil);
    NSString *r1_icon = @"icon_reinforce";
    
    if (type == 1)
    {
        self.a_rows = nil;
        title = NSLocalizedString(@"Incoming Attacks", nil);
        r1_icon = @"icon_attack";
    }
    else if (type == 2)
    {
        self.r_rows = nil;
        title = NSLocalizedString(@"Incoming Reinforcements", nil);
        r1_icon = @"icon_reinforce";
    }
    else if (type == 3)
    {
        self.t_rows = nil;
        title = NSLocalizedString(@"Incoming Trades", nil);
        r1_icon = @"icon_trade";
    }
    
    NSDictionary *row201 = @{@"r1": title, @"r1_icon": r1_icon, @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"nofooter": @"1"};
    NSDictionary *row202 = @{@"r1": NSLocalizedString(@"None", nil), @"r1_align": @"1", @"nofooter": @"1"};
    NSMutableArray *rows2 = [@[row201, row202] mutableCopy];
    [self.ui_cells_array insertObject:rows2 atIndex:type];
    
    [self.tableView reloadData];
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
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];

    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1) && (indexPath.row > 0) && (self.a_troops.count > indexPath.row-1) && (self.level > 14)) //Attacks
    {
        NSMutableArray *troopArray = self.a_troops[indexPath.row-1];
        NSMutableArray *dialogRows = [@[troopArray] mutableCopy];
        [UIManager.i showDialogBlockRow:dialogRows title:@"IncomingAttack" type:3
                                    :^(NSInteger index, NSString *text)
         { }];
    }
    else if ((indexPath.section == 2) && (indexPath.row > 0) && (self.r_troops.count > indexPath.row-1)) //Reinforcements
    {
        NSMutableArray *troopArray = self.r_troops[indexPath.row-1];
        NSMutableArray *dialogRows = [@[troopArray] mutableCopy];
        [UIManager.i showDialogBlockRow:dialogRows title:@"IncomingReinforcement"  type:3
                                    :^(NSInteger index, NSString *text)
         { }];
    }
    else if ((indexPath.section == 3) && (indexPath.row > 0) && (self.t_res.count > indexPath.row-1)) //Trade
    {
        NSMutableArray *resArray = self.t_res[indexPath.row-1];
        NSMutableArray *dialogRows = [@[resArray] mutableCopy];
        [UIManager.i showDialogBlockRow:dialogRows title:@"IncomingTrade"  type:3
                                    :^(NSInteger index, NSString *text)
         { }];
    }
    
    return nil;
}

@end
