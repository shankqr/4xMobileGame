//
//  BaseDetail.m
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

#import "BaseDetail.h"
#import "Globals.h"
#import "Resource1Detail.h"

@interface BaseDetail ()

@property (nonatomic, strong) Resource1Detail *resource1Detail;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, assign) NSInteger s1;

@end

@implementation BaseDetail

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.s1 = 0;
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BaseUpdated"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateBaseName"
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
    else if ([[notification name] isEqualToString:@"BaseUpdated"])
    {
        if ([[UIManager.i currentViewTitle] isEqualToString:self.title])
        {
            [self updateView];
        }
    }
    
    if ([[notification name] isEqualToString:@"UpdateBaseName"])
    {
        if ([[UIManager.i currentViewTitle] isEqualToString:self.title])
        {
            [self updateView];
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
    [self notificationRegister];
    
    NSDictionary *baseDict = Globals.i.wsBaseDict;
    
    NSDictionary *row0 = @{@"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1": NSLocalizedString(@"Upgrade Resource buildings to increase production of resources.", nil)};
    NSDictionary *row1 = @{@"nofooter": @"1", @"r1_align": @"1", @"r1_font": CELL_FONT_SIZE, @"r2_align": @"1", @"r2_font": CELL_FONT_SIZE, @"r1": Globals.i.wsBaseDict[@"base_name"], @"r2": [NSString stringWithFormat:@"at (X:%@ Y:%@)", baseDict[@"map_x"], baseDict[@"map_y"]]};
    NSArray *rows0 = @[row0, row1];
    
    NSInteger a1 = Globals.i.base_a1;
    NSInteger a2 = Globals.i.base_a2;
    NSInteger a3 = Globals.i.base_a3;
    NSInteger b1 = Globals.i.base_b1;
    NSInteger b2 = Globals.i.base_b2;
    NSInteger b3 = Globals.i.base_b3;
    NSInteger c1 = Globals.i.base_c1;
    NSInteger c2 = Globals.i.base_c2;
    NSInteger c3 = Globals.i.base_c3;
    NSInteger d1 = Globals.i.base_d1;
    NSInteger d2 = Globals.i.base_d2;
    NSInteger d3 = Globals.i.base_d3;
    NSInteger total_troops = a1 + a2 + a3 + b1 + b2 + b3 + c1 + c2 + c3 + d1 + d2 + d3;
    
    NSDictionary *row100 = @{@"h1": [NSString stringWithFormat:NSLocalizedString(@"Available Troops: %@", nil), [Globals.i intString:total_troops]]};
    NSMutableArray *rows1 = [@[row100] mutableCopy];
    
    if (a1 > 0)
    {
        NSDictionary *row201 = @{@"i1": @"icon_a1", @"r1": Globals.i.a1, @"c1": [Globals.i intString:a1], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row201];
    }
    if (a2 > 0)
    {
        NSDictionary *row202 = @{@"i1": @"icon_a2", @"r1": Globals.i.a2, @"c1": [Globals.i intString:a2], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row202];
    }
    if (a3 > 0)
    {
        NSDictionary *row203 = @{@"i1": @"icon_a3", @"r1": Globals.i.a3, @"c1": [Globals.i intString:a3], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row203];
    }
    
    if (b1 > 0)
    {
        NSDictionary *row301 = @{@"i1": @"icon_b1", @"r1": Globals.i.b1, @"c1": [Globals.i intString:b1], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row301];
    }
    if (b2 > 0)
    {
        NSDictionary *row302 = @{@"i1": @"icon_b2", @"r1": Globals.i.b2, @"c1": [Globals.i intString:b2], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row302];
    }
    if (b3 > 0)
    {
        NSDictionary *row303 = @{@"i1": @"icon_b3", @"r1": Globals.i.b3, @"c1": [Globals.i intString:b3], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row303];
    }
    
    if (c1 > 0)
    {
        NSDictionary *row401 = @{@"i1": @"icon_c1", @"r1": Globals.i.c1, @"c1": [Globals.i intString:c1], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row401];
    }
    if (c2 > 0)
    {
        NSDictionary *row402 = @{@"i1": @"icon_c2", @"r1": Globals.i.c2, @"c1": [Globals.i intString:c2], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row402];
    }
    if (c3 > 0)
    {
        NSDictionary *row403 = @{@"i1": @"icon_c3", @"r1": Globals.i.c3, @"c1": [Globals.i intString:c3], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row403];
    }
    
    if (d1 > 0)
    {
        NSDictionary *row501 = @{@"i1": @"icon_d1", @"r1": Globals.i.d1, @"c1": [Globals.i intString:d1], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row501];
    }
    if (d2 > 0)
    {
        NSDictionary *row502 = @{@"i1": @"icon_d2", @"r1": Globals.i.d2, @"c1": [Globals.i intString:d2], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row502];
    }
    if (d3 > 0)
    {
        NSDictionary *row503 = @{@"i1": @"icon_d3", @"r1": Globals.i.d3, @"c1": [Globals.i intString:d3], @"c1_ratio": @"3", @"c1_align": @"2"};
        [rows1 addObject:row503];
    }
    
    NSDictionary *row201 = @{@"h1": NSLocalizedString(@"Troop Breakdown", nil)};
    NSMutableArray *rows2 = [@[row201] mutableCopy];
    
    NSDictionary *row202 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Injured Troops: %@", nil), [Globals.i intString:[Globals.i troopCount:@"i"]]], @"r2": @" ", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"View", nil), @"c1_button": @"2"};
    [rows2 addObject:row202];
    
    NSDictionary *row203 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Reinforcing Troops: %@", nil), [Globals.i intString:[Globals.i troopCount:@"r"]]], @"r2": @" ", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"View", nil), @"c1_button": @"2"};
    [rows2 addObject:row203];
    
    NSString *upkeep = [Globals.i numberFormat:baseDict[@"upkeep"]];
    
    NSDictionary *row207 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Total Troops: %@", nil), upkeep]};
    [rows2 addObject:row207];
    
    NSDictionary *row208 = @{@"r1": [NSString stringWithFormat:@"Upkeep: - %@ / hour", upkeep], @"r2": NSLocalizedString(@"Each troop consume 1 Food per hour.", nil)};
    [rows2 addObject:row208];
    
    NSDictionary *row209 = @{@"r1": @" ", @"fit": @"1", @"nofooter": @"1"};
    [rows2 addObject:row209];
    
    NSDictionary *row210 = @{@"r1": NSLocalizedString(@"Rename", nil), @"r1_button": @"2", @"c1": NSLocalizedString(@"Show On Map", nil), @"c1_button": @"2", @"nofooter": @"1"};
    [rows2 addObject:row210];
    
    self.ui_cells_array = [@[rows0, [self resourcesSection], [self troopPowerSection], rows1, rows2] mutableCopy];
	
	[self.tableView reloadData];
    
    [self.tableView flashScrollIndicators];
    
    if (!self.gameTimer.isValid)
    {
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
    }
}

- (NSArray *)troopPowerSection
{
    NSDictionary *baseDict = Globals.i.wsBaseDict;
    
    NSDictionary *row301 = @{@"h1": NSLocalizedString(@"Troop Power", nil)};
    NSDictionary *row302;
    NSDictionary *row303;
    //NSDictionary *row304;
    //NSDictionary *row305;
    
    NSInteger a1 = Globals.i.base_a1;
    NSInteger a2 = Globals.i.base_a2;
    NSInteger a3 = Globals.i.base_a3;
    NSInteger b1 = Globals.i.base_b1;
    NSInteger b2 = Globals.i.base_b2;
    NSInteger b3 = Globals.i.base_b3;
    NSInteger c1 = Globals.i.base_c1;
    NSInteger c2 = Globals.i.base_c2;
    NSInteger c3 = Globals.i.base_c3;
    NSInteger d1 = Globals.i.base_d1;
    NSInteger d2 = Globals.i.base_d2;
    NSInteger d3 = Globals.i.base_d3;
    
    //HARDCODED
    CGFloat a1_attack_value = a1*30;
    CGFloat a2_attack_value = a2*50;
    CGFloat a3_attack_value = a3*70;
    CGFloat b1_attack_value = b1*30;
    CGFloat b2_attack_value = b2*50;
    CGFloat b3_attack_value = b3*70;
    CGFloat c1_attack_value = c1*30;
    CGFloat c2_attack_value = c2*50;
    CGFloat c3_attack_value = c3*70;
    CGFloat d1_attack_value = d1*30;
    CGFloat d2_attack_value = d2*50;
    CGFloat d3_attack_value = d3*70;
    
    CGFloat base_attack_value = a1_attack_value+a2_attack_value+a3_attack_value+b1_attack_value+b2_attack_value+b3_attack_value+c1_attack_value+c2_attack_value+c3_attack_value+d1_attack_value+d2_attack_value+d3_attack_value;
    
    CGFloat boost_a_attack = [baseDict[@"boost_a_attack"] doubleValue];
    CGFloat boost_b_attack = [baseDict[@"boost_b_attack"] doubleValue];
    CGFloat boost_c_attack = [baseDict[@"boost_c_attack"] doubleValue];
    CGFloat boost_d_attack = [baseDict[@"boost_d_attack"] doubleValue];
    
    CGFloat unit_attack_value_from_unit_specific_boost = ((a1_attack_value*boost_a_attack)+(a2_attack_value*boost_a_attack)+(a3_attack_value*boost_a_attack)+(b1_attack_value*boost_b_attack)+(b2_attack_value*boost_b_attack)+(b3_attack_value*boost_b_attack)+(c1_attack_value*boost_c_attack)+(c2_attack_value*boost_c_attack)+(c3_attack_value*boost_c_attack)+(d1_attack_value*boost_d_attack)+(d2_attack_value*boost_d_attack)+(d3_attack_value*boost_d_attack))*0.01;
    
    CGFloat attack_boost = ([baseDict[@"boost_life"] doubleValue]*0.3)+[baseDict[@"boost_attack"] doubleValue];
    CGFloat attack_value_from_boost = base_attack_value*attack_boost*0.01;
    
    CGFloat final_attack_value = base_attack_value+unit_attack_value_from_unit_specific_boost+attack_value_from_boost;
    
    CGFloat a1_defense_a_value = a1*40;
    CGFloat a2_defense_a_value = a2*50;
    CGFloat a3_defense_a_value = a3*60;
    CGFloat b1_defense_a_value = b1*50;
    CGFloat b2_defense_a_value = b2*60;
    CGFloat b3_defense_a_value = b3*70;
    CGFloat c1_defense_a_value = c1*20;
    CGFloat c2_defense_a_value = c2*30;
    CGFloat c3_defense_a_value = c3*40;
    CGFloat d1_defense_a_value = d1*5;
    CGFloat d2_defense_a_value = d2*20;
    CGFloat d3_defense_a_value = d3*25;
    
    CGFloat a1_defense_b_value = a1*20;
    CGFloat a2_defense_b_value = a2*30;
    CGFloat a3_defense_b_value = a3*40;
    CGFloat b1_defense_b_value = b1*40;
    CGFloat b2_defense_b_value = b2*50;
    CGFloat b3_defense_b_value = b3*60;
    CGFloat c1_defense_b_value = c1*50;
    CGFloat c2_defense_b_value = c2*60;
    CGFloat c3_defense_b_value = c3*70;
    CGFloat d1_defense_b_value = d1*5;
    CGFloat d2_defense_b_value = d2*20;
    CGFloat d3_defense_b_value = d3*25;
    
    CGFloat a1_defense_c_value = a1*50;
    CGFloat a2_defense_c_value = a2*60;
    CGFloat a3_defense_c_value = a2*70;
    CGFloat b1_defense_c_value = b1*20;
    CGFloat b2_defense_c_value = b2*30;
    CGFloat b3_defense_c_value = b3*40;
    CGFloat c1_defense_c_value = c1*40;
    CGFloat c2_defense_c_value = c2*50;
    CGFloat c3_defense_c_value = c3*60;
    CGFloat d1_defense_c_value = d1*5;
    CGFloat d2_defense_c_value = d2*20;
    CGFloat d3_defense_c_value = d3*25;
    
    CGFloat base_defense_a_value =a1_defense_a_value+a2_defense_a_value+a3_defense_a_value+b1_defense_a_value+b2_defense_a_value+b3_defense_a_value+c1_defense_a_value+c2_defense_a_value+c3_defense_a_value+d1_defense_a_value+d2_defense_a_value+d3_defense_a_value;
    CGFloat base_defense_b_value =a1_defense_b_value+a2_defense_b_value+a3_defense_b_value+b1_defense_b_value+b2_defense_b_value+b3_defense_b_value+c1_defense_b_value+c2_defense_b_value+c3_defense_b_value+d1_defense_b_value+d2_defense_b_value+d3_defense_b_value;
    CGFloat base_defense_c_value =a1_defense_c_value+a2_defense_c_value+a3_defense_c_value+b1_defense_c_value+b2_defense_c_value+b3_defense_c_value+c1_defense_c_value+c2_defense_c_value+c3_defense_c_value+d1_defense_c_value+d2_defense_c_value+d3_defense_c_value;
    
    CGFloat defense_boost = ([baseDict[@"boost_life"] doubleValue]*0.3)+[baseDict[@"boost_defense"] doubleValue];
    CGFloat defense_a_value_from_boost = base_defense_a_value*defense_boost*0.01;
    CGFloat defense_b_value_from_boost = base_defense_b_value*defense_boost*0.01;
    CGFloat defense_c_value_from_boost = base_defense_c_value*defense_boost*0.01;
    
    
    CGFloat final_defense_a_value = base_defense_a_value+defense_a_value_from_boost;
    CGFloat final_defense_b_value = base_defense_b_value+defense_b_value_from_boost;
    CGFloat final_defense_c_value = base_defense_c_value+defense_c_value_from_boost;
    
    NSString *final_attack_value_string = [Globals.i floatString:final_attack_value];
    
    CGFloat attack_boost_time = [baseDict[@"item_attack"] doubleValue];
    CGFloat attack_boost_time_remaining = Globals.i.boostAttackQueue1;
    CGFloat attack_percentage_remaining_boost = 0;
    NSString *attack_boost_string = @"";
    
    NSString *final_defense_a_value_string = [Globals.i floatString:final_defense_a_value];
    NSString *final_defense_b_value_string = [Globals.i floatString:final_defense_b_value];
    NSString *final_defense_c_value_string = [Globals.i floatString:final_defense_c_value];
    
    CGFloat defense_boost_time = [baseDict[@"item_defense"] doubleValue];
    CGFloat defense_boost_time_remaining = Globals.i.boostDefendQueue1;
    CGFloat defense_percentage_remaining_boost = 0;
    NSString *defense_boost_string = @"";
    
    if(attack_boost_time_remaining>0&&attack_boost_time>0)
    {
        attack_percentage_remaining_boost = attack_boost_time_remaining/attack_boost_time;
        attack_boost_string = [NSString stringWithFormat:NSLocalizedString(@"Attack +%@%% for: %@", nil), baseDict[@"attack_boost_value"], [Globals.i getCountdownString:attack_boost_time_remaining]];
        
        row302 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@" Attack Power: %@", nil), final_attack_value_string], @"i1": @"icon_r1", @"r2_color": @"0", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Boost", nil), @"c1_button": @"1", @"p1": @(attack_percentage_remaining_boost), @"p1_text": attack_boost_string,@"p1_color": @"0", @"p1_width_p": @"0.60", @"p1_height_p": @"1.5",@"p1_x":@"0", @"p1_y":@"200",@"extra_cell_height":@"30"};
    }
    else
    {
        row302 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@" Attack Power: %@", nil), final_attack_value_string], @"i1": @"icon_attack", @"r2_color":  @"0", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Boost", nil), @"c1_button": @"2"};
    }
    
    //NSLog(@"defense_boost_time_remaining %f",defense_boost_time_remaining);
    //NSLog(@"defense_boost_time %f",defense_boost_time);
    
    if (defense_boost_time_remaining>0 && defense_boost_time>0)
    {

        defense_percentage_remaining_boost = defense_boost_time_remaining/defense_boost_time;
        defense_boost_string = [NSString stringWithFormat:NSLocalizedString(@"Defense +%@%% for: %@", nil), baseDict[@"defense_boost_value"], [Globals.i getCountdownString:defense_boost_time_remaining]];
        
        /*
        row303 = @{@"r1": [NSString stringWithFormat:@" Defense vs Infantry: %@", final_defense_a_value_string], @"i1": @"icon_train_a", @"r2_color":  @"0", @"c1_ratio": @"3", @"c1": @"Boost", @"c1_button": @"1"};
        
        row304 = @{@"r1": [NSString stringWithFormat:@" Defense vs Ranged: %@", final_defense_b_value_string], @"i1": @"icon_train_b", @"r2_color":  @"0", @"c1_ratio": @"3", @"c1": @"Boost", @"c1_button": @"1"};
        
        row305 = @{@"r1": [NSString stringWithFormat:@" Defense vs Cavalry : %@", final_defense_c_value_string], @"i1": @"icon_train_c" , @"r2_color": @"0", @"p1": @(defense_percentage_remaining_boost), @"p1_text": defense_boost_string,@"p1_color": @"0", @"p1_width_p": @"0.65", @"p1_height_p": @"1.5",@"p1_x":@"0", @"p1_y":@"100",@"c1_ratio": @"3",@"c1": @"Boost", @"c1_button": @"1"};
        */
        
        row303 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@" Defense vs Infantry: %@ \n Defense vs Ranged: %@ \n Defense vs Cavalry: %@", nil), final_defense_a_value_string,final_defense_b_value_string,final_defense_c_value_string], @"r1_extra_line":@"4",@"i1": @"icon_x", @"r2_color": @"0", @"p1": @(defense_percentage_remaining_boost), @"p1_text": defense_boost_string,@"p1_color": @"0", @"p1_width_p": @"0.60", @"p1_height_p": @"1.5",@"p1_x":@"0", @"p1_y":@"300",@"c1_ratio": @"3",@"c1": NSLocalizedString(@"Boost", nil), @"c1_button": @"1", @"extra_cell_height":@"30"};
    }
    else
    {
        /*
        row303 = @{@"r1": [NSString stringWithFormat:@" Defense vs Infantry: %@", final_defense_a_value_string], @"i1": @"icon_train_a", @"r2_color":  @"0", @"c1_ratio": @"3", @"c1": @"Boost", @"c1_button": @"2"};
        
        row302 = @{@"r1": [NSString stringWithFormat:@" Defense vs Ranged: %@", final_defense_b_value_string], @"i1": @"icon_train_b", @"r2_color":  @"0", @"c1_ratio": @"3", @"c1": @"Boost", @"c1_button": @"2"};
        
        row305 = @{@"r1": [NSString stringWithFormat:@" Defense vs Cavalry: %@", final_defense_c_value_string], @"i1": @"icon_train_c", @"r2_color":  @"0", @"c1_ratio": @"3", @"c1": @"Boost", @"c1_button": @"2"};
         */
        
        row303 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@" Defense vs Infantry: %@ \n Defense vs Ranged: %@ \n Defense vs Cavalry: %@", nil), final_defense_a_value_string,final_defense_b_value_string,final_defense_c_value_string], @"r1_extra_line":@"4",@"i1": @"icon_x", @"r2_color": @"0",@"c1_ratio": @"3",@"c1": NSLocalizedString(@"Boost", nil), @"c1_button": @"2"};
    }
    
    //NSArray *armyrow = @[row301,row302,row303,row304,row305];
    NSArray *armyrow = @[row301,row302,row303];

    return armyrow;
}

- (NSArray *)resourcesSection
{
    NSDictionary *baseDict = Globals.i.wsBaseDict;
    
    NSString *r1 = [Globals.i floatString:Globals.i.base_r1];
    NSString *r2 = [Globals.i floatString:Globals.i.base_r2];
    NSString *r3 = [Globals.i floatString:Globals.i.base_r3];
    NSString *r4 = [Globals.i floatString:Globals.i.base_r4];
    NSString *r5 = [Globals.i floatString:Globals.i.base_r5];
    
    double f_r1_p = [baseDict[@"r1_production"] doubleValue];
    NSString *r1_production = [Globals.i floatString:f_r1_p];
    NSString *r1_capacity = [Globals.i numberFormat:baseDict[@"r1_capacity"]];
    
    CGFloat r1_boost_time = [baseDict[@"item_r1"] doubleValue];
    CGFloat r1_boost_time_remaining = Globals.i.boostR1Queue1;
    CGFloat r1_percentage_remaining_boost = 0;
    NSString *r1_boost_string = @"";

    NSString *r2_color = @"0";
    if (f_r1_p < 0)
    {
        r2_color = @"1";
    }
    
    double f_r2_p = [baseDict[@"r2_production"] doubleValue];
    NSString *r2_production = [Globals.i floatString:f_r2_p];
    NSString *r2_capacity = [Globals.i numberFormat:baseDict[@"r2_capacity"]];
    
    CGFloat r2_boost_time = [baseDict[@"item_r2"] doubleValue];
    CGFloat r2_boost_time_remaining = Globals.i.boostR2Queue1;
    CGFloat r2_percentage_remaining_boost = 0;
    NSString *r2_boost_string = @"";
    
    double f_r3_p = [baseDict[@"r3_production"] doubleValue];
    NSString *r3_production = [Globals.i floatString:f_r3_p];
    NSString *r3_capacity = [Globals.i numberFormat:baseDict[@"r3_capacity"]];
    
    CGFloat r3_boost_time = [baseDict[@"item_r3"] doubleValue];
    CGFloat r3_boost_time_remaining = Globals.i.boostR3Queue1;
    CGFloat r3_percentage_remaining_boost = 0;
    NSString *r3_boost_string = @"";
    
    double f_r4_p = [baseDict[@"r4_production"] doubleValue];
    NSString *r4_production = [Globals.i floatString:f_r4_p];
    NSString *r4_capacity = [Globals.i numberFormat:baseDict[@"r4_capacity"]];
    
    CGFloat r4_boost_time = [baseDict[@"item_r4"] doubleValue];
    CGFloat r4_boost_time_remaining = Globals.i.boostR4Queue1;
    CGFloat r4_percentage_remaining_boost = 0;
    NSString *r4_boost_string = @"";
    
    double f_r5_p = [baseDict[@"r5_production"] doubleValue];
    NSString *r5_production = [Globals.i floatString:f_r5_p];
    NSString *r5_capacity = [Globals.i numberFormat:baseDict[@"r5_capacity"]];
    
    CGFloat r5_boost_time = [baseDict[@"item_r5"] doubleValue];
    CGFloat r5_boost_time_remaining = Globals.i.boostR5Queue1;
    CGFloat r5_percentage_remaining_boost = 0;
    NSString *r5_boost_string = @"";
    
    NSDictionary *row201 = @{@"h1": NSLocalizedString(@"Resources", nil)};
    NSDictionary *row202;
    NSDictionary *row203;
    NSDictionary *row204;
    NSDictionary *row205;
    NSDictionary *row206;
    
    if(r1_boost_time_remaining>0&&r1_boost_time>0)
    {
        r1_percentage_remaining_boost = r1_boost_time_remaining/r1_boost_time;
        r1_boost_string = [NSString stringWithFormat:NSLocalizedString(@"Food Production +%@%% for: %@", nil), baseDict[@"r1_boost_value"], [Globals.i getCountdownString:r1_boost_time_remaining]];
        row202 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r1, r1], @"r2": [NSString stringWithFormat:@"Hourly: %@", r1_production], @"b1": [NSString stringWithFormat:NSLocalizedString(@"Capacity: %@", nil), r1_capacity], @"i1": @"icon_r1", @"r2_color": r2_color, @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"p1": @(r1_percentage_remaining_boost), @"p1_text": r1_boost_string, @"p1_color": @"0", @"p1_width_p": @"0.6", @"p1_height_p": @"1.5", @"p1_x":@"0", @"p1_y":@"80", @"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"1",@"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"1"};

    }
    else
    {
        row202 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r1, r1], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r1_production], @"b1": [NSString stringWithFormat:NSLocalizedString(
@"Capacity: %@", nil), r1_capacity], @"i1": @"icon_r1", @"r2_color": r2_color, @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"2"};
    }
    
    if (r2_boost_time_remaining>0&&r2_boost_time>0)
    {
        r2_percentage_remaining_boost = r2_boost_time_remaining/r2_boost_time;
        r2_boost_string = [NSString stringWithFormat:NSLocalizedString(@"Wood Production +%@%% for: %@", nil), baseDict[@"r2_boost_value"], [Globals.i getCountdownString:r2_boost_time_remaining]];
        row203 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r2, r2], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r2_production], @"b1": [NSString stringWithFormat:NSLocalizedString(@"Capacity: %@", nil), r2_capacity], @"i1": @"icon_r2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"p1": @(r2_percentage_remaining_boost), @"p1_text": r2_boost_string,@"p1_color": @"0", @"p1_width_p": @"0.6", @"p1_height_p": @"1.5",@"p1_x":@"0", @"p1_y":@"80",@"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"1"};
    }
    else
    {
        row203 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r2, r2], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r2_production], @"b1": [NSString stringWithFormat:NSLocalizedString(@"Capacity: %@", nil), r2_capacity], @"i1": @"icon_r2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": @"Info", @"d1_button": @"2", @"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"2",@"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"2"};
    }
    
    if (r3_boost_time_remaining>0&&r3_boost_time>0)
    {
        r3_percentage_remaining_boost = r3_boost_time_remaining/r3_boost_time;
        r3_boost_string = [NSString stringWithFormat:NSLocalizedString(@"Stone Production +%@%% for: %@", nil), baseDict[@"r3_boost_value"], [Globals.i getCountdownString:r3_boost_time_remaining]];
        row204 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r3, r3], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r3_production], @"b1": [NSString stringWithFormat:NSLocalizedString(@"Capacity: %@", nil), r3_capacity], @"i1": @"icon_r3", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"p1": @(r3_percentage_remaining_boost), @"p1_text": r3_boost_string,@"p1_color": @"0", @"p1_width_p": @"0.6", @"p1_height_p": @"1.5",@"p1_x":@"0", @"p1_y":@"80",@"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"1"};
    }
    else
    {
        row204 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r3, r3], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r3_production], @"b1": [NSString stringWithFormat:NSLocalizedString(@"Capacity: %@", nil), r3_capacity], @"i1": @"icon_r3", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"2"};

    }
    
    if (r4_boost_time_remaining>0&&r4_boost_time>0)
    {
        r4_percentage_remaining_boost = r4_boost_time_remaining/r4_boost_time;
        r4_boost_string = [NSString stringWithFormat:NSLocalizedString(@"Ore Production +%@%% for: %@", nil), baseDict[@"r4_boost_value"], [Globals.i getCountdownString:r4_boost_time_remaining]];
        row205 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r4, r4], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r4_production], @"b1": [NSString stringWithFormat:NSLocalizedString(@"Capacity: %@", nil), r4_capacity], @"i1": @"icon_r4", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"p1": @(r4_percentage_remaining_boost), @"p1_text": r4_boost_string,@"p1_color": @"0", @"p1_width_p": @"0.6", @"p1_height_p": @"1.5",@"p1_x":@"0", @"p1_y":@"80",@"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"1"};
    }
    else
    {
        row205 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r4, r4], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r4_production], @"b1": [NSString stringWithFormat:@"Capacity: %@", r4_capacity], @"i1": @"icon_r4", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"2"};

    }
    
    if (r5_boost_time_remaining>0&&r5_boost_time>0)
    {
        r5_percentage_remaining_boost = r5_boost_time_remaining/r5_boost_time;
        r5_boost_string = [NSString stringWithFormat:NSLocalizedString(@"Gold Production +%@%% for: %@", nil), baseDict[@"r5_boost_value"], [Globals.i getCountdownString:r5_boost_time_remaining]];        row206 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r5, r5], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r5_production], @"b1": [NSString stringWithFormat:NSLocalizedString(@"Capacity: %@", nil), r5_capacity], @"i1": @"icon_r5", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"p1": @(r5_percentage_remaining_boost), @"p1_text": r5_boost_string, @"p1_color": @"0", @"p1_width_p": @"0.6", @"p1_height_p": @"1.5",@"p1_x":@"0", @"p1_y":@"100",@"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"2"};
    }
    else
    {
        row206 = @{@"r1": [NSString stringWithFormat:@"%@: %@", Globals.i.r5, r5], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Hourly: %@", nil), r5_production], @"b1": [NSString stringWithFormat:NSLocalizedString(@"Capacity: %@", nil), r5_capacity], @"i1": @"icon_r5", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"d1": NSLocalizedString(@"Info", nil), @"d1_button": @"2", @"g1": NSLocalizedString(@"Boost", nil), @"g1_button": @"2"};
    }
    
    NSArray *rows2 = @[row201, row202, row203, row204, row205, row206];
    
    return rows2;
}

- (void)onTimer
{
    if ((self.ui_cells_array != nil) && ([[UIManager.i currentViewTitle] isEqualToString:self.title]))
    {
        [self updateView];
    }
}

- (void)button1_tap:(id)sender
{
    //Rename City Name
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"renamebase" forKey:@"item_category2"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)button2_tap:(id)sender
{
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSInteger i = [sender tag];
    
    NSLog(@"button2_tap : %ld",(long)i);
    
    if (i == 202) //Get More r1
    {
        [userInfo setObject:@"r1" forKey:@"item_category2"];
    }
    else if (i == 203) //Get More r2
    {
        [userInfo setObject:@"r2" forKey:@"item_category2"];
    }
    else if (i == 204) //Get More r3
    {
        [userInfo setObject:@"r3" forKey:@"item_category2"];
    }
    else if (i == 205) //Get More r4
    {
        [userInfo setObject:@"r4" forKey:@"item_category2"];
    }
    else if (i == 206) //Get More r5
    {
        [userInfo setObject:@"r5" forKey:@"item_category2"];
    }
    else if (i == 302) //Boost Attack
    {
        [userInfo setObject:@"boosts" forKey:@"item_category1"];
        [userInfo setObject:@"attack" forKey:@"item_category2"];
        [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
        [userInfo setObject:@(TV_BOOST_ATT) forKey:@"item_type"];
    }
    else if (i == 303) //Boost Defense
    {
        [userInfo setObject:@"boosts" forKey:@"item_category1"];
        [userInfo setObject:@"defense" forKey:@"item_category2"];
        [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
        [userInfo setObject:@(TV_BOOST_DEF) forKey:@"item_type"];

    }
    else if (i == 304) //Boost Defense
    {
        [userInfo setObject:@"boosts" forKey:@"item_category1"];
        [userInfo setObject:@"defense" forKey:@"item_category2"];
        [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
        [userInfo setObject:@(TV_BOOST_DEF) forKey:@"item_type"];

    }
    else if (i == 305) //Boost Defense
    {
        [userInfo setObject:@"boosts" forKey:@"item_category1"];
        [userInfo setObject:@"defense" forKey:@"item_category2"];
        [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
        [userInfo setObject:@(TV_BOOST_DEF) forKey:@"item_type"];

    }
    else if (i == 502)
    {
        [Globals.i showTroopList:@"i"];
    }
    else if (i == 503)
    {
        [Globals.i showTroopList:@"r"];
    }
    else if (i ==507)
    {
        [UIManager.i closeTemplate];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMap"
                                                            object:self];
    }
    
    if (userInfo.count > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)button3_tap:(id)sender
{
    NSInteger i = [sender tag];

    if (self.resource1Detail == nil)
    {
        self.resource1Detail = [[Resource1Detail alloc] initWithStyle:UITableViewStylePlain];
    }
    
    if (i == 202) //Info r1
    {
        self.resource1Detail.building_id = @"1";
        self.resource1Detail.building_name = NSLocalizedString(@"Farm", nil);
        self.resource1Detail.base_field = @"r1";
        self.resource1Detail.product_name = Globals.i.r1;
        self.resource1Detail.title = Globals.i.r1;
        [UIManager.i showTemplate:@[self.resource1Detail] :self.resource1Detail.title];
    }
    else if (i == 203) //Info r2
    {
        self.resource1Detail.building_id = @"2";
        self.resource1Detail.building_name = NSLocalizedString(@"Sawmill", nil);
        self.resource1Detail.base_field = @"r2";
        self.resource1Detail.product_name = Globals.i.r2;
        self.resource1Detail.title = Globals.i.r2;
        [UIManager.i showTemplate:@[self.resource1Detail] :self.resource1Detail.title];
    }
    else if (i == 204) //Info r3
    {
        self.resource1Detail.building_id = @"3";
        self.resource1Detail.building_name = NSLocalizedString(@"Quarry", nil);
        self.resource1Detail.base_field = @"r3";
        self.resource1Detail.product_name = Globals.i.r3;
        self.resource1Detail.title = Globals.i.r3;
        [UIManager.i showTemplate:@[self.resource1Detail] :self.resource1Detail.title];
    }
    else if (i == 205) //Info r4
    {
        self.resource1Detail.building_id = @"4";
        self.resource1Detail.building_name = NSLocalizedString(@"Mine", nil);
        self.resource1Detail.base_field = @"r4";
        self.resource1Detail.product_name = Globals.i.r4;
        self.resource1Detail.title = Globals.i.r4;
        [UIManager.i showTemplate:@[self.resource1Detail] :self.resource1Detail.title];
    }
    else if (i == 206) //Info r5
    {
        self.resource1Detail.building_id = @"5";
        self.resource1Detail.building_name = NSLocalizedString(@"House", nil);
        self.resource1Detail.base_field = @"r5";
        self.resource1Detail.product_name = Globals.i.r5;
        self.resource1Detail.title = Globals.i.r5;
        [UIManager.i showTemplate:@[self.resource1Detail] :self.resource1Detail.title];
    }
}

- (void)button4_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSLog(NSLocalizedString(@"Showing Items : %ld", nil),(long)i);
    
    NSString *boost_type = @"";
    NSString *item_category2 = @"";
    switch (i) {
        case 202:
            boost_type=[@(TV_BOOST_R1) stringValue];
            item_category2=@"food";
            break;
        case 203:
            boost_type=[@(TV_BOOST_R2) stringValue];
            item_category2=@"wood";
            break;
        case 204:
            boost_type=[@(TV_BOOST_R3) stringValue];
            item_category2=@"stone";
            break;
        case 205:
            boost_type=[@(TV_BOOST_R4) stringValue];
            item_category2=@"ore";
            break;
        case 206:
            boost_type=[@(TV_BOOST_R5) stringValue];
            item_category2=@"gold";
            break;
        default:
            break;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"boosts" forKey:@"item_category1"];
    [userInfo setObject:item_category2 forKey:@"item_category2"];
    [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
    [userInfo setObject:boost_type forKey:@"item_type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_d.btn addTarget:self action:@selector(button3_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_d.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_g.btn addTarget:self action:@selector(button4_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_g.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
