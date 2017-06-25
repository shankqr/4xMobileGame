//
//  TroopView.m
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

#import "TroopView.h"
#import "Globals.h"

@interface TroopView ()

@property (nonatomic, strong) NSString *b1_check;
@property (nonatomic, strong) NSString *unit_name;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, assign) NSUInteger r1;
@property (nonatomic, assign) NSUInteger r2;
@property (nonatomic, assign) NSUInteger r3;
@property (nonatomic, assign) NSUInteger r4;
@property (nonatomic, assign) NSUInteger r5;
@property (nonatomic, assign) NSUInteger power;
@property (nonatomic, assign) NSUInteger time;

@end

@implementation TroopView

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.sel_value = 1;
    [self notificationRegister];
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"AddTroop"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TrainTroop"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ScrollToTrainButton"
                                               object:nil];
    
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"AddTroop"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSIndexPath* indexPath= [NSIndexPath indexPathForRow:0 inSection:3];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            
            //[self button2_tap:indexPath.row];
            //NSLog(@"Cell Troop : %@",[self.tableView cellForRowAtIndexPath:indexPath]);
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            //NSLog(@"DynamicCell : %@ ",customCellView);
            //NSLog(@"DynamicCell.cellview : %@ ",customCellView.cellview);
            //NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_a.slider);
            
            //[self slider1_change:customCellView.cellview.rv_a.slider];
            [customCellView.cellview.rv_a.slider.increaseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        }

    }
    else if ([[notification name] isEqualToString:@"TrainTroop"])
    {
        NSLog(@"TRAIN TROOP");
        
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSIndexPath* indexPath= [NSIndexPath indexPathForRow:1 inSection:3];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            
            //[self button2_tap:indexPath.row];
            //NSLog(@"Cell Troop : %@",[self.tableView cellForRowAtIndexPath:indexPath]);
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            //NSLog(@"DynamicCell : %@ ",customCellView);
            //NSLog(@"DynamicCell.cellview : %@ ",customCellView.cellview);
            NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_a.btn);
            
            //[self slider1_change:customCellView.cellview.rv_a.slider];
            [customCellView.cellview.rv_a.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        }

    }
    else if ([[notification name] isEqualToString:@"ScrollToTrainButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSLog(@"ScrollToTrainButton");
            
            NSIndexPath* indexPath= [NSIndexPath indexPathForRow:1 inSection:3];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSLog(@"indexPath : %@ ",indexPath);
            
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
            
        }
    }
    
}

- (void)clearView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
}

- (void)updateView
{
    NSDictionary *unit_dict = [Globals.i getUnitDict:self.unit_type tier:self.unit_tier];
    
    NSString *type_tier = [NSString stringWithFormat:@"%@%@", self.unit_type, self.unit_tier];
    NSString *var_name = [NSString stringWithFormat:@"base_%@", type_tier];
    NSInteger own = [[Globals.i valueForKey:var_name] integerValue];
    NSString *owned = [Globals.i intString:own];
    self.unit_name = unit_dict[@"name"];
    NSMutableDictionary *row101 = [@{@"r1": self.unit_name, @"b1": [NSString stringWithFormat:NSLocalizedString(@"%@. Type: %@, Strong vs %@, Weak vs %@", nil), unit_dict[@"info"], unit_dict[@"type_name"], unit_dict[@"strongvs"], unit_dict[@"weakvs"]], @"i1": [NSString stringWithFormat:@"icon_%@", type_tier], @"c1": [NSString stringWithFormat:NSLocalizedString(@"Own: %@", nil), owned], @"r1_bold": @"1", @"c1_ratio": @"3", @"n1_width": @"64", @"nofooter": @"1"} mutableCopy];
    NSMutableDictionary *row102 = [@{@"r1_icon": @"unit_life", @"r1": [NSString stringWithFormat:NSLocalizedString(@"Life: %@", nil), unit_dict[@"life"]], @"c1_icon": @"unit_attack", @"c1": [NSString stringWithFormat:NSLocalizedString(@"Attack: %@", nil), unit_dict[@"attack"]], @"e1_icon": @"unit_defense", @"e1": [NSString stringWithFormat:NSLocalizedString(@"Defense: %@", nil), unit_dict[@"defense"]], @"r1_bkg": @"bkg3", @"c1_bkg": @"bkg3", @"e1_bkg": @"bkg3", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"r1_align": @"3", @"c1_align": @"3", @"e1_align": @"3", @"c1_ratio": @"3", @"nofooter": @"1", @"fit": @"1"} mutableCopy];
    NSMutableDictionary *row103 = [@{@"r1_icon": @"unit_speed", @"r1": [NSString stringWithFormat:NSLocalizedString(@"Speed: %@", nil), unit_dict[@"speed"]], @"c1_icon": @"unit_load", @"c1": [NSString stringWithFormat:NSLocalizedString(@"Load: %@", nil), unit_dict[@"unit_load"]], @"e1_icon": @"unit_upkeep", @"e1": [NSString stringWithFormat:NSLocalizedString(@"Upkeep: %@", nil), unit_dict[@"upkeep"]], @"r1_bkg": @"bkg3", @"c1_bkg": @"bkg3", @"e1_bkg": @"bkg3", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"r1_align": @"3", @"c1_align": @"3", @"e1_align": @"3", @"c1_ratio": @"3", @"nofooter": @"1"} mutableCopy];

    NSMutableArray *rows1 = [@[row101, row102, row103] mutableCopy];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    self.r1 = [unit_dict[@"r1"] integerValue]*self.sel_value;
    self.r2 = [unit_dict[@"r2"] integerValue]*self.sel_value;
    self.r3 = [unit_dict[@"r3"] integerValue]*self.sel_value;
    self.r4 = [unit_dict[@"r4"] integerValue]*self.sel_value;
    self.r5 = [unit_dict[@"r5"] integerValue]*self.sel_value;
    
    self.power = [unit_dict[@"power"] integerValue]*self.sel_value;
    self.time = [unit_dict[@"time"] integerValue]*self.sel_value;
    
    NSUInteger base_r1 = Globals.i.base_r1;
    NSUInteger base_r2 = Globals.i.base_r2;
    NSUInteger base_r3 = Globals.i.base_r3;
    NSUInteger base_r4 = Globals.i.base_r4;
    NSUInteger base_r5 = Globals.i.base_r5;
    
    BOOL r1_check = NO;
    BOOL r2_check = NO;
    BOOL r3_check = NO;
    BOOL r4_check = NO;
    BOOL r5_check = NO;
    
    NSString *r1_color = @"1";
    NSString *r2_color = @"1";
    NSString *r3_color = @"1";
    NSString *r4_color = @"1";
    NSString *r5_color = @"1";

    if (base_r1 >= self.r1)
    {
        r1_check = YES;
        r1_color = @"0";
    }
    if (base_r2 >= self.r2)
    {
        r2_check = YES;
        r2_color = @"0";
    }
    if (base_r3 >= self.r3)
    {
        r3_check = YES;
        r3_color = @"0";
    }
    if (base_r4 >= self.r4)
    {
        r4_check = YES;
        r4_color = @"0";
    }
    if (base_r5 >= self.r5)
    {
        r5_check = YES;
        r5_color = @"0";
    }
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Requirements", nil), @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    
    NSDictionary *row202 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r1], [Globals.i uintString:self.r1]], @"r1_color": r1_color, @"r1_icon": @"icon_r1", @"r1_align": @"3",
                             @"c1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r2], [Globals.i uintString:self.r2]], @"c1_color": r2_color, @"c1_icon": @"icon_r2", @"c1_align": @"3", @"nofooter": @"1"};

    NSDictionary *row203 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r3], [Globals.i uintString:self.r3]], @"r1_color": r3_color, @"r1_icon": @"icon_r3", @"r1_align": @"3",
                             @"c1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r4], [Globals.i uintString:self.r4]], @"c1_color": r4_color, @"c1_icon": @"icon_r4", @"c1_align": @"3", @"nofooter": @"1"};
    
    self.b1_check = @"1";
    NSInteger req1_b_lvl = [unit_dict[@"require1_building_level"] integerValue];
    if (self.highest_buildings_level >= req1_b_lvl)
    {
        self.b1_check = @"0";
    }
    
    NSDictionary *row204 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r5], [Globals.i uintString:self.r5]], @"r1_color": r5_color, @"r1_icon": @"icon_r5", @"r1_align": @"3",
                             @"c1": [NSString stringWithFormat:@"Lv.%@ %@", [@(req1_b_lvl) stringValue], self.building_name], @"c1_color": self.b1_check, @"c1_icon": @"icon_building", @"c1_align": @"3", @"nofooter": @"1"};

    NSMutableArray *rows2 = [@[row201, row202, row203, row204] mutableCopy];
    
    [self.ui_cells_array addObject:rows2];
    
    NSDictionary *row301 = @{@"r1": NSLocalizedString(@"Rewards", nil), @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSDictionary *row302 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Power: +%@", nil), [Globals.i uintString:self.power]], @"r1_icon": @"icon_power", @"r1_align": @"3", @"nofooter": @"1", @"fit": @"1"};

    NSMutableArray *rows3 = [@[row301, row302] mutableCopy];
    
    [self.ui_cells_array addObject:rows3];
    
    if (self.highest_buildings_level >= req1_b_lvl)
    {
        float boost_t = ([Globals.i.wsBaseDict[@"boost_training"] floatValue] / 100.0f) + 1.0f;
        self.time = (float)self.time / boost_t;
        
        NSString *str_time = [Globals.i getCountdownString:self.time];
        NSString *str_boost = [NSString stringWithFormat:NSLocalizedString(@"%@     Boost:+%@%%", nil), str_time, Globals.i.wsBaseDict[@"boost_training"]];

        NSString *train_btn = @"1";
        
        if (r1_check && r2_check && r3_check && r4_check && r5_check)
        {
            train_btn = @"2";
        }
        
        NSMutableDictionary *row401 = [@{@"r1": @" ", @"r2_slider": @"0", @"s1": @(self.sel_value), @"slider_max": @(self.buildings_output), @"nofooter": @"1"} mutableCopy];
        NSMutableDictionary *row402 = [@{@"r1": NSLocalizedString(@"Train", nil), @"r1_button": train_btn, @"r2": str_boost, @"r2_icon": @"icon_clock", @"r2_bkg": @"bkg3", @"fit": @"1", @"nofooter": @"1"} mutableCopy];
        NSMutableArray *rows4 = [@[row401, row402] mutableCopy];
        [self.ui_cells_array addObject:rows4];
    }
    else
    {
        NSMutableDictionary *row401 = [@{@"r1": @" ", @"nofooter": @"1"} mutableCopy];
        NSMutableDictionary *row402 = [@{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Lv.%@ %@ required to train this unit.", nil), [@(req1_b_lvl) stringValue], self.building_name], @"r1_align": @"1", @"r1_color": @"1", @"r1_bold": @"1", @"nofooter": @"1"} mutableCopy];
        NSMutableArray *rows4 = [@[row401, row402] mutableCopy];
        [self.ui_cells_array addObject:rows4];
    }
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    
    if (!self.gameTimer.isValid)
    {
        //self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
}

- (void)onTimer
{
    if ((self.ui_cells_array != nil) && ([[UIManager.i currentViewTitle] isEqualToString:self.title]))
    {
        [self updateView];
    }
}

- (void)slider1_change:(UISlider *)sender
{
    self.sel_value = ((DCFineTuneSlider *)sender).selectedValue;
    
    if (self.sel_value < 1)
    {
        self.sel_value = 1;
    }
    
    [self updateView];
}

- (void)trainTroops
{
    NSString *service_name = @"TrainTroops";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], Globals.i.wsBaseDict[@"base_id"],
                       self.unit_type,
                       self.unit_tier,
                       [@(self.sel_value) stringValue]];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i updateBaseDict:^(BOOL success, NSData *data)
              {
                  NSInteger tv_id = TV_A;
                  
                  NSString *str_sum = [Globals.i intString:self.sel_value];
                  NSString *tv_title = [NSString stringWithFormat:NSLocalizedString(@"Training %@ %@", nil), str_sum, self.unit_name];
                  
                  if ([self.unit_type isEqualToString:@"a"])
                  {
                      tv_id = TV_A;
                      [Globals.i setTimerViewTitle:tv_id :tv_title];
                      [Globals.i setupAQueue:[Globals.i updateTime]];
                  }
                  else if ([self.unit_type isEqualToString:@"b"])
                  {
                      tv_id = TV_B;
                      [Globals.i setTimerViewTitle:tv_id :tv_title];
                      [Globals.i setupBQueue:[Globals.i updateTime]];
                  }
                  else if ([self.unit_type isEqualToString:@"c"])
                  {
                      tv_id = TV_C;
                      [Globals.i setTimerViewTitle:tv_id :tv_title];
                      [Globals.i setupCQueue:[Globals.i updateTime]];
                  }
                  else if ([self.unit_type isEqualToString:@"d"])
                  {
                      tv_id = TV_D;
                      [Globals.i setTimerViewTitle:tv_id :tv_title];
                      [Globals.i setupDQueue:[Globals.i updateTime]];
                  }
                  
                  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                  [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
                  [userInfo setObject:@(tv_id) forKey:@"tv_id"];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTrainView"
                                                                      object:self
                                                                    userInfo:userInfo];
                  
                  [UIManager.i closeTemplate];
                  
                  [Globals.i updateProfilePower:self.power];
              }];
         }
     }];
}

- (void)button1_tap:(id)sender
{
    [Globals.i play_training];
    
    NSInteger r1_button = [[self.ui_cells_array[3][1] objectForKey:@"r1_button"] integerValue];
    
    if (r1_button > 1)
    {
        [self trainTroops];
    }
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
    
    [(UISlider *)dcell.cellview.rv_a.slider addTarget:self action:@selector(slider1_change:) forControlEvents:UIControlEventValueChanged];
    ((UISlider *)dcell.cellview.rv_a.slider).tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
