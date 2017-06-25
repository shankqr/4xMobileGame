//
//  SendHeader
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 4/14/14.
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

#import "SendHeader.h"
#import "Globals.h"

@interface SendHeader ()

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) NSMutableDictionary *sel_dict;
@property (nonatomic, strong) NSMutableDictionary *base_dict;
@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) NSString *to_profile_id;
@property (nonatomic, strong) NSString *to_base_id;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) NSInteger int_sum;
@property (nonatomic, assign) NSInteger int_load;
@property (nonatomic, assign) NSInteger int_upkeep;
@property (nonatomic, assign) NSInteger int_speed;
@property (nonatomic, assign) NSInteger int_attack;
@property (nonatomic, assign) NSInteger int_defense;
@property (nonatomic, assign) NSInteger boost_load;
@property (nonatomic, assign) NSInteger boost_speed;
@property (nonatomic, assign) NSInteger boost_attack;
@property (nonatomic, assign) NSInteger boost_defense;
@property (nonatomic, assign) NSInteger from_base_x;
@property (nonatomic, assign) NSInteger from_base_y;
@property (nonatomic, assign) NSInteger to_base_x;
@property (nonatomic, assign) NSInteger to_base_y;
@property (nonatomic, assign) NSInteger travel_distance;
@property (nonatomic, assign) double march_time;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger building_level;
@property (nonatomic, assign) NSInteger buildings_output;
@property (nonatomic, assign) NSInteger tutorial_step;

@end

@implementation SendHeader

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateSendHeader"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"QueueMaxForAttack"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SendAttackNow"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SendCaptureNow"
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
    else if ([[notification name] isEqualToString:@"UpdateSendHeader"])
    {
        NSDictionary *userInfo = notification.userInfo;
        self.sel_dict = [[userInfo objectForKey:@"sel_dict"] mutableCopy];
        
        [self updateUnitStats];
    }
    else if ([[notification name] isEqualToString:@"QueueMaxForAttack"])
    {
        NSLog(@"QueueMaxForAttack");
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo!=nil)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"DynamicCell : %@ ",customCellView);
            NSLog(@"Button customCellView rv_a: %@ ",customCellView.cellview.rv_a.btn);
            NSLog(@"Button customCellView rv_c: %@ ",customCellView.cellview.rv_c.btn);
            [customCellView.cellview.rv_a.btn sendActionsForControlEvents:UIControlEventTouchUpInside];;

        }
        
    }
    else if ([[notification name] isEqualToString:@"SendAttackNow"])
    {
        NSLog(@"SendAttackNow");
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo!=nil)
        {
            self.tutorial_step = [[userInfo objectForKey:@"tutorial_step"] integerValue];
            if(self.tutorial_step>0)
            {
                self.march_time=5;
                
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:[NSNumber numberWithInteger:self.tutorial_step+1]  forKey:@"tutorial_step"];
                [userInfo setObject:[NSNumber numberWithDouble:(self.march_time*2+5)]  forKey:@"delay_time"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DelayTutorialInputActive"
                                                                    object:self
                                                                  userInfo:userInfo];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                
                DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                NSLog(@"DynamicCell : %@ ",customCellView);
                NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_c.btn);
                
                NSLog(@"tutorial_Step before:%ld",(long)self.tutorial_step);
                [customCellView.cellview.rv_c.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.tutorial_step = 0;
                NSLog(@"tutorial_Step after:%ld",(long)self.tutorial_step);
                
                double delayInSeconds = self.march_time*2+5;
                NSLog(@"delayInSeconds for auto tutorial step : %f",delayInSeconds);
                dispatch_time_t nextTutorialTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(nextTutorialTime, dispatch_get_main_queue(), ^(void){
                    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                    [userInfo setObject:[NSNumber numberWithInteger:1]  forKey:@"skip_step"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                        object:self
                                                                      userInfo:userInfo];
                });


            }
        }
    }
    else if ([[notification name] isEqualToString:@"SendCaptureNow"])
    {
        NSLog(@"SendCaptureNow");
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo!=nil)
        {
            self.tutorial_step = [[userInfo objectForKey:@"tutorial_step"] integerValue];
            if(self.tutorial_step>0)
            {
                self.march_time=5;
                
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:[NSNumber numberWithInteger:self.tutorial_step+1]  forKey:@"tutorial_step"];
                [userInfo setObject:[NSNumber numberWithDouble:(self.march_time+5)]  forKey:@"delay_time"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DelayTutorialInputActive"
                                                                    object:self
                                                                  userInfo:userInfo];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                
                DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
                NSLog(@"DynamicCell : %@ ",customCellView);
                NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_c.btn);
                
                NSLog(@"tutorial_Step before:%ld",(long)self.tutorial_step);
                [customCellView.cellview.rv_c.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
                self.tutorial_step = 0;
                NSLog(@"tutorial_Step after:%ld",(long)self.tutorial_step);
                
                double delayInSeconds = self.march_time+5;
                NSLog(@"delayInSeconds for auto tutorial step : %f",delayInSeconds);
                dispatch_time_t nextTutorialTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(nextTutorialTime, dispatch_get_main_queue(), ^(void){
                    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                    [userInfo setObject:[NSNumber numberWithInteger:1]  forKey:@"skip_step"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                        object:self
                                                                      userInfo:userInfo];
                });
            }
        }
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.base_dict = [[self.userInfo objectForKey:@"base_dict"] mutableCopy];
    self.action = [self.userInfo objectForKey:@"action"];
    self.limit = [self.userInfo[@"limit"] integerValue];
    
    self.building_id = @"18";
    
    self.to_base_id = self.base_dict[@"base_id"];
    self.to_profile_id = self.base_dict[@"profile_id"];
    
    self.from_base_x = [Globals.i.wsBaseDict[@"map_x"] integerValue];
    self.from_base_y = [Globals.i.wsBaseDict[@"map_y"] integerValue];
    self.to_base_x = [self.base_dict[@"map_x"] integerValue];
    self.to_base_y = [self.base_dict[@"map_y"] integerValue];
    
    self.building_level = 0;
    self.buildings_output = 0;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:self.building_id])
        {
            NSInteger lvl = [dict[@"building_level"] integerValue];
            NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:lvl];
            NSInteger capacity = [buildingLevelDict[@"capacity"] integerValue];
            
            self.building_level = lvl;
            self.buildings_output = capacity;
        }
    }
    
    if (self.limit > self.buildings_output)
    {
        self.limit = self.buildings_output;
    }
    else if (self.limit < 1)
    {
        self.limit = self.buildings_output;
    }
    
    self.travel_distance = [Globals.i distance2xy:self.from_base_x :self.from_base_y :self.to_base_x :self.to_base_y];
    self.march_time = self.travel_distance*10; //Simple formula travel time is the travel distance x10 in seconds
    
    //Add boost if hero is selected in Attack
    self.boost_load = [Globals.i.wsBaseDict[@"boost_load"] integerValue];
    self.boost_speed = [Globals.i.wsBaseDict[@"boost_march"] integerValue];
    self.boost_attack = [Globals.i.wsBaseDict[@"boost_attack"] integerValue];
    self.boost_defense = [Globals.i.wsBaseDict[@"boost_defense"] integerValue];
    
    self.int_sum = 0;
    self.int_load = 0;
    self.int_upkeep = 0;
    self.int_speed = 0;
    self.int_attack = 0;
    self.int_defense = 0;
    
    self.tutorial_step = 0;
    [self redrawView];
}

- (void)redrawView
{
    NSString *i1;
    NSString *i1_over;
    
    if ([self.base_dict[@"base_type"] isEqualToString:@"1"])
    {
        i1 = @"t82";
        i1_over = @"icon_capital_over";
    }
    else //Enemy Village or Barbarian Village
    {
        i1 = @"t72";
        i1_over = @"";
    }
    
    NSString *r2 = [NSString stringWithFormat:@"(x: %@, y: %@)", [@(self.to_base_x) stringValue], [@(self.to_base_y) stringValue]];
    NSString *r1_icon;
    NSString *r1;
    NSString *r1_color;
    NSString *c1_icon;
    NSString *c1;
    
    if ([self.action isEqualToString:@"Reinforce"] || [self.action isEqualToString:@"Transfer"])
    {
        r1_icon = @"unit_upkeep";
        r1_color = @"1";
        r1 = [NSString stringWithFormat:NSLocalizedString(@"- %@ Hourly", nil), [Globals.i intString:self.int_upkeep]];
        c1_icon = @"unit_defense";
        c1 = [Globals.i intString:self.int_defense];
    }
    else
    {
        r1_icon = @"unit_load";
        r1_color = @"0";
        r1 = [Globals.i intString:self.int_load];
        c1_icon = @"unit_attack";
        c1 = [Globals.i intString:self.int_attack];
    }
    
    NSString *limit_color = @"0";
    NSString *button_send = @"2";
    if (self.int_sum > self.limit)
    {
        limit_color = @"1";
        button_send = @"1";
    }
    else if (self.int_sum == 0)
    {
        button_send = @"1";
    }
    
    self.march_time = self.travel_distance*10; //Must be set or march_time will get lesser n lesser
    
    //Every speed is 5% boost faster
    float fasterPercent = (((self.int_speed-1) * 5) / 100.0f) + 1.0f;
    self.march_time = (float)self.march_time / fasterPercent;
    
    float boost_m = ([Globals.i.wsBaseDict[@"boost_march"] floatValue] / 100.0f) + 1.0f;
    self.march_time = (float)self.march_time / boost_m;

    NSString *str_time = [Globals.i getCountdownString:self.march_time];
    NSString *str_boost = [NSString stringWithFormat:NSLocalizedString(@"%@     Boost:+%@%%", nil), str_time, Globals.i.wsBaseDict[@"boost_march"]];
    
    NSString *base_name = NSLocalizedString(@"Village", nil);
    if (self.base_dict[@"base_name"] != nil)
    {
        base_name = self.base_dict[@"base_name"];
    }
    
    NSMutableDictionary *row101 = [@{@"i1": i1, @"i1_over": i1_over, @"i1_aspect": @"1", @"r1": base_name, @"r2": r2, @"r1_bold": @"1", @"fit": @"1", @"nofooter": @"1"} mutableCopy];
    NSMutableArray *rows1 = [@[row101] mutableCopy];
    
    if (![self.action isEqualToString:@"Spy"])
    {
        NSMutableDictionary *row102 = [@{@"r1_icon": r1_icon, @"r1_color": r1_color, @"r1": r1, @"c1_icon": c1_icon, @"c1": c1, @"r1_align": @"3", @"c1_align": @"3", @"fit": @"1", @"nofooter": @"1"} mutableCopy];
        [rows1 addObject:row102];
    }
    
    NSMutableDictionary *row103 = [@{@"r1_icon": @"st_limit", @"r1_color": limit_color, @"r1": [NSString stringWithFormat:@"%@/%@", [Globals.i intString:self.int_sum], [Globals.i intString:self.limit]], @"c1_icon": @"st_time", @"c1": str_boost, @"r1_align": @"3", @"c1_align": @"3", @"fit": @"1", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row103];
    
    NSMutableDictionary *row104 = [@{@"r1": NSLocalizedString(@"Queue Max", nil), @"r1_button": @"2", @"c1": NSLocalizedString(@"Send Now", nil), @"c1_button": button_send, @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row104];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    
    if (self.backgroundImage == nil)
    {
        self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.backgroundImage.contentMode = UIViewContentModeScaleToFill;
        CGRect table_rect = [self.tableView rectForSection:[self.tableView numberOfSections] - 1];
        CGFloat table_height = CGRectGetMaxY(table_rect);
        CGRect bkg_frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, table_height);
        UIImage *bkg_image = [UIManager.i dynamicImage:bkg_frame prefix:@"bkg5"];
        [self.backgroundImage setImage:bkg_image];
        [self.backgroundImage setFrame:bkg_frame];
        self.tableView.backgroundView = self.backgroundImage;
    }
}

- (void)updateUnitStats
{
    if ([self.action isEqualToString:@"Spy"])
    {
        self.int_sum = [self.sel_dict[@"Spy"] integerValue];
        self.int_speed = 0;
    }
    else
    {
        NSInteger a1 = [self.sel_dict[Globals.i.a1] integerValue];
        NSInteger a2 = [self.sel_dict[Globals.i.a2] integerValue];
        NSInteger a3 = [self.sel_dict[Globals.i.a3] integerValue];
        NSInteger b1 = [self.sel_dict[Globals.i.b1] integerValue];
        NSInteger b2 = [self.sel_dict[Globals.i.b2] integerValue];
        NSInteger b3 = [self.sel_dict[Globals.i.b3] integerValue];
        NSInteger c1 = [self.sel_dict[Globals.i.c1] integerValue];
        NSInteger c2 = [self.sel_dict[Globals.i.c2] integerValue];
        NSInteger c3 = [self.sel_dict[Globals.i.c3] integerValue];
        NSInteger d1 = [self.sel_dict[Globals.i.d1] integerValue];
        NSInteger d2 = [self.sel_dict[Globals.i.d2] integerValue];
        NSInteger d3 = [self.sel_dict[Globals.i.d3] integerValue];
        self.int_sum = a1 + a2 + a3 + b1 + b2 + b3 + c1 + c2 + c3 + d1 + d2 + d3;
        
        if ([self.action isEqualToString:@"Reinforce"] || [self.action isEqualToString:@"Transfer"])
        {
            NSInteger a1_defense = [[Globals.i getUnitDict:@"a" tier:@"1"][@"defense"] integerValue]*a1;
            NSInteger a2_defense = [[Globals.i getUnitDict:@"a" tier:@"2"][@"defense"] integerValue]*a2;
            NSInteger a3_defense = [[Globals.i getUnitDict:@"a" tier:@"3"][@"defense"] integerValue]*a3;
            NSInteger b1_defense = [[Globals.i getUnitDict:@"b" tier:@"1"][@"defense"] integerValue]*b1;
            NSInteger b2_defense = [[Globals.i getUnitDict:@"b" tier:@"2"][@"defense"] integerValue]*b2;
            NSInteger b3_defense = [[Globals.i getUnitDict:@"b" tier:@"3"][@"defense"] integerValue]*b3;
            NSInteger c1_defense = [[Globals.i getUnitDict:@"c" tier:@"1"][@"defense"] integerValue]*c1;
            NSInteger c2_defense = [[Globals.i getUnitDict:@"c" tier:@"2"][@"defense"] integerValue]*c2;
            NSInteger c3_defense = [[Globals.i getUnitDict:@"c" tier:@"3"][@"defense"] integerValue]*c3;
            NSInteger d1_defense = [[Globals.i getUnitDict:@"d" tier:@"1"][@"defense"] integerValue]*d1;
            NSInteger d2_defense = [[Globals.i getUnitDict:@"d" tier:@"2"][@"defense"] integerValue]*d2;
            NSInteger d3_defense = [[Globals.i getUnitDict:@"d" tier:@"3"][@"defense"] integerValue]*d3;
            self.int_defense = a1_defense + a2_defense + a3_defense + b1_defense + b2_defense + b3_defense + c1_defense + c2_defense + c3_defense + d1_defense + d2_defense + d3_defense;
            
            NSInteger a1_upkeep = [[Globals.i getUnitDict:@"a" tier:@"1"][@"upkeep"] integerValue]*a1;
            NSInteger a2_upkeep = [[Globals.i getUnitDict:@"a" tier:@"2"][@"upkeep"] integerValue]*a2;
            NSInteger a3_upkeep = [[Globals.i getUnitDict:@"a" tier:@"3"][@"upkeep"] integerValue]*a3;
            NSInteger b1_upkeep = [[Globals.i getUnitDict:@"b" tier:@"1"][@"upkeep"] integerValue]*b1;
            NSInteger b2_upkeep = [[Globals.i getUnitDict:@"b" tier:@"2"][@"upkeep"] integerValue]*b2;
            NSInteger b3_upkeep = [[Globals.i getUnitDict:@"b" tier:@"3"][@"upkeep"] integerValue]*b3;
            NSInteger c1_upkeep = [[Globals.i getUnitDict:@"c" tier:@"1"][@"upkeep"] integerValue]*c1;
            NSInteger c2_upkeep = [[Globals.i getUnitDict:@"c" tier:@"2"][@"upkeep"] integerValue]*c2;
            NSInteger c3_upkeep = [[Globals.i getUnitDict:@"c" tier:@"3"][@"upkeep"] integerValue]*c3;
            NSInteger d1_upkeep = [[Globals.i getUnitDict:@"d" tier:@"1"][@"upkeep"] integerValue]*d1;
            NSInteger d2_upkeep = [[Globals.i getUnitDict:@"d" tier:@"2"][@"upkeep"] integerValue]*d2;
            NSInteger d3_upkeep = [[Globals.i getUnitDict:@"d" tier:@"3"][@"upkeep"] integerValue]*d3;
            self.int_upkeep = a1_upkeep + a2_upkeep + a3_upkeep + b1_upkeep + b2_upkeep + b3_upkeep + c1_upkeep + c2_upkeep + c3_upkeep + d1_upkeep + d2_upkeep + d3_upkeep;
        }
        else if ([self.action isEqualToString:@"Attack"])
        {
            //NSInteger hero = [self.sel_dict[@"Hero"] integerValue];
            
            NSInteger a1_attack = [[Globals.i getUnitDict:@"a" tier:@"1"][@"attack"] integerValue]*a1;
            NSInteger a2_attack = [[Globals.i getUnitDict:@"a" tier:@"2"][@"attack"] integerValue]*a2;
            NSInteger a3_attack = [[Globals.i getUnitDict:@"a" tier:@"3"][@"attack"] integerValue]*a3;
            NSInteger b1_attack = [[Globals.i getUnitDict:@"b" tier:@"1"][@"attack"] integerValue]*b1;
            NSInteger b2_attack = [[Globals.i getUnitDict:@"b" tier:@"2"][@"attack"] integerValue]*b2;
            NSInteger b3_attack = [[Globals.i getUnitDict:@"b" tier:@"3"][@"attack"] integerValue]*b3;
            NSInteger c1_attack = [[Globals.i getUnitDict:@"c" tier:@"1"][@"attack"] integerValue]*c1;
            NSInteger c2_attack = [[Globals.i getUnitDict:@"c" tier:@"2"][@"attack"] integerValue]*c2;
            NSInteger c3_attack = [[Globals.i getUnitDict:@"c" tier:@"3"][@"attack"] integerValue]*c3;
            NSInteger d1_attack = [[Globals.i getUnitDict:@"d" tier:@"1"][@"attack"] integerValue]*d1;
            NSInteger d2_attack = [[Globals.i getUnitDict:@"d" tier:@"2"][@"attack"] integerValue]*d2;
            NSInteger d3_attack = [[Globals.i getUnitDict:@"d" tier:@"3"][@"attack"] integerValue]*d3;
            self.int_attack = a1_attack + a2_attack + a3_attack + b1_attack + b2_attack + b3_attack + c1_attack + c2_attack + c3_attack + d1_attack + d2_attack + d3_attack;
            
            NSInteger a1_load = [[Globals.i getUnitDict:@"a" tier:@"1"][@"unit_load"] integerValue]*a1;
            NSInteger a2_load = [[Globals.i getUnitDict:@"a" tier:@"2"][@"unit_load"] integerValue]*a2;
            NSInteger a3_load = [[Globals.i getUnitDict:@"a" tier:@"3"][@"unit_load"] integerValue]*a3;
            NSInteger b1_load = [[Globals.i getUnitDict:@"b" tier:@"1"][@"unit_load"] integerValue]*b1;
            NSInteger b2_load = [[Globals.i getUnitDict:@"b" tier:@"2"][@"unit_load"] integerValue]*b2;
            NSInteger b3_load = [[Globals.i getUnitDict:@"b" tier:@"3"][@"unit_load"] integerValue]*b3;
            NSInteger c1_load = [[Globals.i getUnitDict:@"c" tier:@"1"][@"unit_load"] integerValue]*c1;
            NSInteger c2_load = [[Globals.i getUnitDict:@"c" tier:@"2"][@"unit_load"] integerValue]*c2;
            NSInteger c3_load = [[Globals.i getUnitDict:@"c" tier:@"3"][@"unit_load"] integerValue]*c3;
            NSInteger d1_load = [[Globals.i getUnitDict:@"d" tier:@"1"][@"unit_load"] integerValue]*d1;
            NSInteger d2_load = [[Globals.i getUnitDict:@"d" tier:@"2"][@"unit_load"] integerValue]*d2;
            NSInteger d3_load = [[Globals.i getUnitDict:@"d" tier:@"3"][@"unit_load"] integerValue]*d3;
            self.int_load = a1_load + a2_load + a3_load + b1_load + b2_load + b3_load + c1_load + c2_load + c3_load + d1_load + d2_load + d3_load;
        }
        
        NSInteger slowest_speed = 12;
        if (a1 > 0)
        {
            NSInteger a1_speed = [[Globals.i getUnitDict:@"a" tier:@"1"][@"speed"] integerValue];
            if (slowest_speed > a1_speed)
            {
                slowest_speed = a1_speed;
            }
        }
        if (a2 > 0)
        {
            NSInteger a2_speed = [[Globals.i getUnitDict:@"a" tier:@"2"][@"speed"] integerValue];
            if (slowest_speed > a2_speed)
            {
                slowest_speed = a2_speed;
            }
        }
        if (a3 > 0)
        {
            NSInteger a3_speed = [[Globals.i getUnitDict:@"a" tier:@"3"][@"speed"] integerValue];
            if (slowest_speed > a3_speed)
            {
                slowest_speed = a3_speed;
            }
        }
        if (b1 > 0)
        {
            NSInteger b1_speed = [[Globals.i getUnitDict:@"b" tier:@"1"][@"speed"] integerValue];
            if (slowest_speed > b1_speed)
            {
                slowest_speed = b1_speed;
            }
        }
        if (b2 > 0)
        {
            NSInteger b2_speed = [[Globals.i getUnitDict:@"b" tier:@"2"][@"speed"] integerValue];
            if (slowest_speed > b2_speed)
            {
                slowest_speed = b2_speed;
            }
        }
        if (b3 > 0)
        {
            NSInteger b3_speed = [[Globals.i getUnitDict:@"b" tier:@"3"][@"speed"] integerValue];
            if (slowest_speed > b3_speed)
            {
                slowest_speed = b3_speed;
            }
        }
        if (c1 > 0)
        {
            NSInteger c1_speed = [[Globals.i getUnitDict:@"c" tier:@"1"][@"speed"] integerValue];
            if (slowest_speed > c1_speed)
            {
                slowest_speed = c1_speed;
            }
        }
        if (c2 > 0)
        {
            NSInteger c2_speed = [[Globals.i getUnitDict:@"c" tier:@"2"][@"speed"] integerValue];
            if (slowest_speed > c2_speed)
            {
                slowest_speed = c2_speed;
            }
        }
        if (c3 > 0)
        {
            NSInteger c3_speed = [[Globals.i getUnitDict:@"c" tier:@"3"][@"speed"] integerValue];
            if (slowest_speed > c3_speed)
            {
                slowest_speed = c3_speed;
            }
        }
        if (d1 > 0)
        {
            NSInteger d1_speed = [[Globals.i getUnitDict:@"d" tier:@"1"][@"speed"] integerValue];
            if (slowest_speed > d1_speed)
            {
                slowest_speed = d1_speed;
            }
        }
        if (d2 > 0)
        {
            NSInteger d2_speed = [[Globals.i getUnitDict:@"d" tier:@"2"][@"speed"] integerValue];
            if (slowest_speed > d2_speed)
            {
                slowest_speed = d2_speed;
            }
        }
        if (d3 > 0)
        {
            NSInteger d3_speed = [[Globals.i getUnitDict:@"d" tier:@"3"][@"speed"] integerValue];
            if (slowest_speed > d3_speed)
            {
                slowest_speed = d3_speed;
            }
        }
        
        if (slowest_speed == 12)
        {
            self.int_speed = 1;
        }
        else
        {
            self.int_speed = slowest_speed;
        }
    }
    
    [self redrawView];
}

//NOTE :Better to Wrap around sendAttack
- (void)sendTutorialAttack:(BOOL)is_capture tutorialStep:(NSInteger)tutorial_step
{
    NSInteger int_march_time = lround(self.march_time);
    
    NSString *usp = @"usp_SendAttack";
    
    if (is_capture)
    {
        usp = @"usp_SendCapture";
    }
    
    NSLog(@"int_march_time %ld",(long)int_march_time);
    
    NSString *service_name = @"SendTroopsExtended";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                       Globals.i.world_url,
                       service_name,
                       Globals.i.wsWorldProfileDict[@"uid"],
                       Globals.i.wsBaseDict[@"base_id"],
                       self.to_profile_id,
                       self.to_base_id,
                       usp,
                       self.sel_dict[@"Hero"],
                       self.sel_dict[Globals.i.a1],
                       self.sel_dict[Globals.i.b1],
                       self.sel_dict[Globals.i.c1],
                       self.sel_dict[Globals.i.d1],
                       self.sel_dict[Globals.i.a2],
                       self.sel_dict[Globals.i.b2],
                       self.sel_dict[Globals.i.c2],
                       self.sel_dict[Globals.i.d2],
                       self.sel_dict[Globals.i.a3],
                       self.sel_dict[Globals.i.b3],
                       self.sel_dict[Globals.i.c3],
                       self.sel_dict[Globals.i.d3],
                       [@(int_march_time) stringValue],
                       [@(tutorial_step) stringValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[[Globals.i session] dataTaskWithURL:[NSURL URLWithString:wsurl]
                        completionHandler:^(NSData *data,
                                            NSURLResponse *response,
                                            NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
              if (error || !response || !data)
              {
                  [Globals.i showDialogFail];
              }
              else
              {
                  [Globals.i trackEvent:service_name];
                  
                  //Always be prepared for return string 0 if attack fail
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      NSMutableDictionary *return_row = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                      
                      NSString *profile2_x = return_row[@"profile2_x"];
                      NSString *profile2_y = return_row[@"profile2_y"];
                      
                      [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                       {
                           NSString *tv_title = [NSString stringWithFormat:@"(%@,%@)", profile2_x, profile2_y];
                           [Globals.i setTimerViewTitle:TV_ATTACK :tv_title];
                           
                           [Globals.i setupAttackQueue:[Globals.i updateTime]];
                           
                           [self updateView];
                           
                           NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                           [userInfo setObject:[@(TV_ATTACK) stringValue] forKey:@"tv_id"];
                           [userInfo setObject:profile2_x forKey:@"to_x"];
                           [userInfo setObject:profile2_y forKey:@"to_y"];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawMarchingLine"
                                                                               object:self
                                                                             userInfo:userInfo];
                           
                           [UIManager.i showToast:NSLocalizedString(@"Troops have begin marching to destination!", nil)
                                  optionalTitle:@"AttackTroopsBeginMarching"
                                  optionalImage:@"icon_check"];
                       }];
                  }
                  else //return is a string
                  {
                      [UIManager.i showDialog:NSLocalizedString(@"Attack failed. Please try again.", nil) title:@"AttackFailed"];
                  }
              }
          });
      }] resume];
}

- (void)sendAttack:(BOOL)is_capture
{
    NSInteger int_march_time = lround(self.march_time);
    
    NSString *usp = @"usp_SendAttack";
    
    if (is_capture)
    {
        usp = @"usp_SendCapture";
    }
    
    NSString *service_name = @"SendTroops";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                       Globals.i.world_url,
                       service_name,
                       Globals.i.wsWorldProfileDict[@"uid"],
                       Globals.i.wsBaseDict[@"base_id"],
                       self.to_profile_id,
                       self.to_base_id,
                       usp,
                       self.sel_dict[@"Hero"],
                       self.sel_dict[Globals.i.a1],
                       self.sel_dict[Globals.i.b1],
                       self.sel_dict[Globals.i.c1],
                       self.sel_dict[Globals.i.d1],
                       self.sel_dict[Globals.i.a2],
                       self.sel_dict[Globals.i.b2],
                       self.sel_dict[Globals.i.c2],
                       self.sel_dict[Globals.i.d2],
                       self.sel_dict[Globals.i.a3],
                       self.sel_dict[Globals.i.b3],
                       self.sel_dict[Globals.i.c3],
                       self.sel_dict[Globals.i.d3], [@(int_march_time) stringValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[[Globals.i session] dataTaskWithURL:[NSURL URLWithString:wsurl]
                          completionHandler:^(NSData *data,
                                              NSURLResponse *response,
                                              NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
        if (error || !response || !data)
        {
            [Globals.i showDialogFail];
        }
        else
        {
            [Globals.i trackEvent:service_name];
            
            //Always be prepared for return string 0 if attack fail
            NSMutableArray *returnArray = [Globals.i customParser:data];
            
            if (returnArray.count > 0)
            {
                NSMutableDictionary *return_row = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                
                NSString *profile2_x = return_row[@"profile2_x"];
                NSString *profile2_y = return_row[@"profile2_y"];
                
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     NSLog(@"profile2_x : %@",profile2_x);
                     NSLog(@"profile2_y : %@",profile2_y);
                     
                     NSString *tv_title = [NSString stringWithFormat:@"(%@,%@)", profile2_x, profile2_y];
                     [Globals.i setTimerViewTitle:TV_ATTACK :tv_title];
                     
                     [Globals.i setupAttackQueue:[Globals.i updateTime]];
                     
                     [self updateView];
                     
                     [Globals.i setTimerViewParameter:TV_ATTACK :@"to_map_x" :profile2_x];
                     [Globals.i setTimerViewParameter:TV_ATTACK :@"to_map_y" :profile2_y];
                     
                     NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                     [userInfo setObject:[@(TV_ATTACK) stringValue] forKey:@"tv_id"];
                     [userInfo setObject:profile2_x forKey:@"to_x"];
                     [userInfo setObject:profile2_y forKey:@"to_y"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawMarchingLine"
                                                                         object:self
                                                                       userInfo:userInfo];
                     
                     [UIManager.i showToast:NSLocalizedString(@"Troops have begin marching to destination!", nil)
                              optionalTitle:@"AttackTroopsBeginMarching"
                              optionalImage:@"icon_check"];
                 }];
            }
            else //return is a string
            {
                [Globals.i getRegions:^(BOOL success, NSData *data) {}];
                [UIManager.i showDialog:NSLocalizedString(@"Attack failed. Map might have refreshed, please try again.", nil) title:@"AttackFailed"];
            }
        }
    });
    }] resume];
}

- (void)sendReinforce
{
    NSInteger int_march_time = lround(self.march_time);
    
    NSString *usp = @"usp_SendReinforcements";
    NSString *service_name = @"SendTroops";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                       Globals.i.world_url,
                       service_name,
                       Globals.i.wsWorldProfileDict[@"uid"],
                       Globals.i.wsBaseDict[@"base_id"],
                       self.to_profile_id,
                       self.to_base_id,
                       usp,
                       self.sel_dict[@"Hero"],
                       self.sel_dict[Globals.i.a1],
                       self.sel_dict[Globals.i.b1],
                       self.sel_dict[Globals.i.c1],
                       self.sel_dict[Globals.i.d1],
                       self.sel_dict[Globals.i.a2],
                       self.sel_dict[Globals.i.b2],
                       self.sel_dict[Globals.i.c2],
                       self.sel_dict[Globals.i.d2],
                       self.sel_dict[Globals.i.a3],
                       self.sel_dict[Globals.i.b3],
                       self.sel_dict[Globals.i.c3],
                       self.sel_dict[Globals.i.d3], [@(int_march_time) stringValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[[Globals.i session] dataTaskWithURL:[NSURL URLWithString:wsurl]
                          completionHandler:^(NSData *data,
                                              NSURLResponse *response,
                                              NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
        if (error || !response || !data)
        {
            [Globals.i showDialogFail];
        }
        else
        {
            [Globals.i trackEvent:service_name];
            
            //Always be prepared for return string 0 if spy fail
            NSMutableArray *returnArray = [Globals.i customParser:data];
            
            if (returnArray.count > 0)
            {
                NSMutableDictionary *return_row = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                
                NSString *profile2_x = return_row[@"profile2_x"];
                NSString *profile2_y = return_row[@"profile2_y"];
                
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     NSString *tv_title = [NSString stringWithFormat:NSLocalizedString(@"Reinforcing (%@,%@)", nil), profile2_x, profile2_y];
                     [Globals.i setTimerViewTitle:TV_REINFORCE :tv_title];
                     
                     [Globals.i setupReinforceQueue:[Globals.i updateTime]];
                     
                     [self updateView];
                     
                     NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                     [userInfo setObject:[@(TV_REINFORCE) stringValue] forKey:@"tv_id"];
                     [userInfo setObject:profile2_x forKey:@"to_x"];
                     [userInfo setObject:profile2_y forKey:@"to_y"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawMarchingLine"
                                                                         object:self
                                                                       userInfo:userInfo];
                     
                     Globals.i.reinforces_out = [[NSMutableArray alloc] init]; //Cached r out not valid anymore
                     
                     [UIManager.i showToast:NSLocalizedString(@"Reinforcements have begin marching to destination!", nil)
                              optionalTitle:@"ReinforcementBeginMarching"
                              optionalImage:@"icon_check"];
                 }];
            }
            else //return is a string
            {
                [Globals.i getRegions:^(BOOL success, NSData *data) {}];
                [UIManager.i showDialog:NSLocalizedString(@"Reinforcements failed. Please try again.", nil) title:@"ReinforcementFailed"];
            }
        }
    });
    }] resume];
    
}

- (void)sendTransfer
{
    NSInteger int_march_time = lround(self.march_time);
    
    NSString *usp = @"usp_SendTransfer";
    NSString *service_name = @"SendTroops";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                       Globals.i.world_url,
                       service_name,
                       Globals.i.wsWorldProfileDict[@"uid"],
                       Globals.i.wsBaseDict[@"base_id"],
                       self.to_profile_id,
                       self.to_base_id,
                       usp,
                       self.sel_dict[@"Hero"],
                       self.sel_dict[Globals.i.a1],
                       self.sel_dict[Globals.i.b1],
                       self.sel_dict[Globals.i.c1],
                       self.sel_dict[Globals.i.d1],
                       self.sel_dict[Globals.i.a2],
                       self.sel_dict[Globals.i.b2],
                       self.sel_dict[Globals.i.c2],
                       self.sel_dict[Globals.i.d2],
                       self.sel_dict[Globals.i.a3],
                       self.sel_dict[Globals.i.b3],
                       self.sel_dict[Globals.i.c3],
                       self.sel_dict[Globals.i.d3], [@(int_march_time) stringValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[[Globals.i session] dataTaskWithURL:[NSURL URLWithString:wsurl]
                          completionHandler:^(NSData *data,
                                              NSURLResponse *response,
                                              NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
        if (error || !response || !data)
        {
            [Globals.i showDialogFail];
        }
        else
        {
            [Globals.i trackEvent:service_name];
            
            //Always be prepared for return string 0 if spy fail
            NSMutableArray *returnArray = [Globals.i customParser:data];
            
            if (returnArray.count > 0)
            {
                NSMutableDictionary *return_row = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                
                NSString *profile2_x = return_row[@"profile2_x"];
                NSString *profile2_y = return_row[@"profile2_y"];
                
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     NSString *tv_title = [NSString stringWithFormat:NSLocalizedString(@"Transfering to (%@,%@)", nil), profile2_x, profile2_y];
                     [Globals.i setTimerViewTitle:TV_TRANSFER :tv_title];
                     
                     [Globals.i setupTransferQueue:[Globals.i updateTime]];
                     
                     NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Transfered Troops have arrived from %@.", nil), Globals.i.wsBaseDict[@"base_name"]];
                     [Globals.i addTo:TO_TRANSFER time:int_march_time base_id:self.to_base_id title:title img:@"report_reinforce" dict:self.sel_dict];
                     
                     [self updateView];
                     
                     NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                     [userInfo setObject:[@(TV_TRANSFER) stringValue] forKey:@"tv_id"];
                     [userInfo setObject:profile2_x forKey:@"to_x"];
                     [userInfo setObject:profile2_y forKey:@"to_y"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawMarchingLine"
                                                                         object:self
                                                                       userInfo:userInfo];
                     
                     [UIManager.i showToast:NSLocalizedString(@"Transfered troops have begin marching to your assigned City!", nil)
                              optionalTitle:@"TroopTransferBeginMarching"
                              optionalImage:@"icon_check"];
                 }];
            }
            else //return is a string
            {
                [Globals.i getRegions:^(BOOL success, NSData *data) {}];
                [UIManager.i showDialog:NSLocalizedString(@"Troop transfer failed. Please try again.", nil) title:@"TroopTransferFailed"];
            }
        }
    });
    }] resume];

}

- (void)sendSpy
{
    NSInteger int_march_time = lround(self.march_time);
    
    NSString *service_name = @"SendSpies";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@",
                       Globals.i.world_url,
                       service_name,
                       Globals.i.wsWorldProfileDict[@"uid"],
                       Globals.i.wsBaseDict[@"base_id"],
                       self.to_profile_id,
                       self.to_base_id,
                       self.sel_dict[@"Spy"], [@(int_march_time) stringValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[[Globals.i session] dataTaskWithURL:[NSURL URLWithString:wsurl]
                          completionHandler:^(NSData *data,
                                              NSURLResponse *response,
                                              NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
        if (error || !response || !data)
        {
            [Globals.i showDialogFail];
        }
        else
        {
            [Globals.i trackEvent:service_name];
            
            //Always be prepared for return string 0 if spy fail
            NSMutableArray *returnArray = [Globals.i customParser:data];
            
            if (returnArray.count > 0)
            {
                NSMutableDictionary *return_row = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                
                NSString *bold = @"1";
                NSString *r1_font = @"11.0";
                NSString *r2_font = @"10.0";
                NSString *profile_face = [NSString stringWithFormat:@"face_%@", return_row[@"profile2_face"]];
                NSString *profile_name = return_row[@"profile2_name"];
                NSString *profile_city = return_row[@"profile2_base_name"];
                NSString *profile_location = [NSString stringWithFormat:@"at (X:%@ Y:%@)", return_row[@"profile2_x"], return_row[@"profile2_y"]];
                NSString *i1 = profile_face;
                NSString *r2 = profile_location;
                NSString *i0 = @"";
                NSString *r1 = @"";
                if ([return_row[@"victory"] isEqualToString:@"1"])
                {
                    i0 = @"report_spy_victory";
                    r1 = [NSString stringWithFormat:NSLocalizedString(@"You have spied upon %@'s city %@", nil), profile_name, profile_city];
                }
                else
                {
                    i0 = @"report_spy_defeat";
                    r1 = [NSString stringWithFormat:NSLocalizedString(@"You failed to spy upon %@'s city %@", nil), profile_name, profile_city];
                }
                
                NSDictionary *rowHeader = @{@"i0": i0, @"i1": i1, @"i1_aspect": @"1", @"r1": r1, @"r2": r2, @"r1_bold": bold, @"r1_font": r1_font, @"r2_bold": bold, @"r2_font": r2_font, @"r2_color": @"5"};
                
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:rowHeader forKey:@"report_header"];
                [userInfo setObject:return_row forKey:@"report_data"];
                [userInfo setObject:@"Spy Report" forKey:@"report_title"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowReportDialog"
                                                                    object:self
                                                                  userInfo:userInfo];
                
                double total_spy = [Globals.i.wsBaseDict[@"spy"] doubleValue];
                double captured_spy = [return_row[@"profile1_spy_captured"] doubleValue];
                double new_total_spy = total_spy - captured_spy;
                Globals.i.wsBaseDict[@"spy"] = [@(new_total_spy) stringValue];
            }
            else //return is a string
            {
                [Globals.i getRegions:^(BOOL success, NSData *data) {}];
                [UIManager.i showDialog:NSLocalizedString(@"Your spy has failed you! Send more spies to increase chances of success next time.", nil) title:@"SpyFailed"];
            }
        }
    });
    }] resume];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"r1_button"] integerValue];
    
    if (button > 1) //Queue Max
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QueueMax"
                                                            object:self
                                                          userInfo:nil];
    }
}

- (void)button2_tap:(id)sender
{
    [Globals.i play_march];
    
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"c1_button"] integerValue];
    
    if ((button > 1) && self.int_sum > 0) //March
    {
        if ([self.action isEqualToString:@"Reinforce"])
        {
            [self sendReinforce];
        }
        else if ([self.action isEqualToString:@"Transfer"])
        {
            [self sendTransfer];
        }
        else if ([self.action isEqualToString:@"Spy"])
        {
            [self sendSpy];
        }
        else if ([self.action isEqualToString:@"Attack"])
        {
            if(self.tutorial_step>0)
            {
                [self sendTutorialAttack:NO tutorialStep:self.tutorial_step];
            }
            else
            {
                [self sendAttack:NO];
            }
        }
        else if ([self.action isEqualToString:@"Capture"])
        {
            if(self.tutorial_step>0)
            {
                [self sendTutorialAttack:YES tutorialStep:self.tutorial_step];
            }
            else
            {
                [self sendAttack:YES];
            }
        }
        
        [UIManager.i closeTemplate];
    }
}


#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
