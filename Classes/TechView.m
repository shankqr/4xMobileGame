//
//  TechView.m
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

#import "TechView.h"
#import "Globals.h"

@interface TechView ()

@property (nonatomic, strong) NSDictionary *researchDict;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, assign) NSInteger blacksmith_level;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) double geo_p;

@end

@implementation TechView

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.researchDict = nil;
    self.blacksmith_level = 1;
    self.time = 60;
    [self notificationRegister];
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ScrollToResearchTech"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ResearchTech"
                                               object:nil];
    
    
    
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"ScrollToResearchTech"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSLog(@"ResearchTech");
            
            NSIndexPath* indexPath= [NSIndexPath indexPathForRow:0 inSection:3];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSLog(@"indexPath : %@ ",indexPath);
            
            [self.tableView scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionBottom
                                          animated:YES];
            
        }
    }
    else if ([[notification name] isEqualToString:@"ResearchTech"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSLog(@"ResearchTech");
            
            NSIndexPath *indexPath= [NSIndexPath indexPathForRow:0 inSection:3];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSLog(@"indexPath : %@ ",indexPath);
            
            //[self button2_tap:indexPath.row];
            //NSLog(@"Cell BuildHeader : %@",[self.tableView cellForRowAtIndexPath:indexPath]);
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            NSLog(@"DynamicCell : %@ ",customCellView);
            NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_a.btn);
            
            [customCellView.cellview.rv_a.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        }
    }

}

- (void)clearView
{
    self.ui_cells_array = nil;
    self.researchDict = nil;
    [self.tableView reloadData];
}

- (void)updateView
{
    if ([self.tech_id integerValue] < 500)
    {
        NSString *n1 = [NSString stringWithFormat:@"Level %@", [@(self.tech_level) stringValue]];
        [self.row_target addEntriesFromDictionary:@{@"n1": n1}];
    }
    
    NSMutableArray *rows1 = [@[self.row_target] mutableCopy];
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    if (self.researchDict == nil)
    {
        self.researchDict = [Globals.i getResearchDict:self.tech_id];
    }
    
    self.geo_p = pow(2, self.tech_level-1);
    
    NSInteger r1 = [self.researchDict[@"r1"] integerValue]*self.geo_p;
    NSInteger r2 = [self.researchDict[@"r2"] integerValue]*self.geo_p;
    NSInteger r3 = [self.researchDict[@"r3"] integerValue]*self.geo_p;
    NSInteger r4 = [self.researchDict[@"r4"] integerValue]*self.geo_p;
    NSInteger r5 = [self.researchDict[@"r5"] integerValue]*self.geo_p;
    
    NSInteger base_r1 = Globals.i.base_r1;
    NSInteger base_r2 = Globals.i.base_r2;
    NSInteger base_r3 = Globals.i.base_r3;
    NSInteger base_r4 = Globals.i.base_r4;
    NSInteger base_r5 = Globals.i.base_r5;
    
    NSString *bq_icon = @"icon_research";
    NSString *bq_title = NSLocalizedString(@"Research Queue", nil);
    NSString *bq_color = @"";
    NSString *bq_timer = @"";
    NSString *bq_check = @"icon_check";
    
    NSInteger library_level_required = 0;
    NSInteger blacksmith_level_required = 0;
    
    if (Globals.i.researchQueue1 > 1)
    {
        bq_title = NSLocalizedString(@"Research Queue Full", nil);
        bq_color = @"1";
        bq_timer = [NSString stringWithFormat:@"Available In: %@", [Globals.i getCountdownString:Globals.i.researchQueue1]];
        bq_check = @"icon_x";
    }
    
    BOOL r1_check = NO;
    BOOL r2_check = NO;
    BOOL r3_check = NO;
    BOOL r4_check = NO;
    BOOL r5_check = NO;

    if (base_r1 >= r1)
    {
        r1_check = YES;
    }
    if (base_r2 >= r2)
    {
        r2_check = YES;
    }
    if (base_r3 >= r3)
    {
        r3_check = YES;
    }
    if (base_r4 >= r4)
    {
        r4_check = YES;
    }
    if (base_r5 >= r5)
    {
        r5_check = YES;
    }
    
    NSDictionary *row201 = @{@"h1": NSLocalizedString(@"Requirements", nil), @"r1_align": @"1"};
    
    NSDictionary *row202 = @{@"r1": bq_title, @"r1_color": bq_color, @"r2": bq_timer, @"r2_color": bq_color, @"i1": bq_icon, @"i2": bq_check, @"footer_spacing": @"10"};
    
    NSDictionary *row203 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r1], [Globals.i intString:r1]], @"i1": @"icon_r1", @"i2": @"icon_check", @"footer_spacing": @"10"};
    if (!r1_check)
    {
        row203 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r1], [Globals.i intString:r1]], @"r1_color": @"1", @"i1": @"icon_r1", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"footer_spacing": @"10"};
    }
    
    NSDictionary *row204 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r2], [Globals.i intString:r2]], @"i1": @"icon_r2", @"i2": @"icon_check", @"footer_spacing": @"10", @"footer_spacing": @"10"};
    if (!r2_check)
    {
        row204 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r2], [Globals.i intString:r2]], @"r1_color": @"1", @"i1": @"icon_r2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"footer_spacing": @"10", @"footer_spacing": @"10"};
    }
    
    NSDictionary *row205 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r3], [Globals.i intString:r3]], @"i1": @"icon_r3", @"i2": @"icon_check", @"footer_spacing": @"10"};
    if (!r3_check)
    {
        row205 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r3], [Globals.i intString:r3]], @"r1_color": @"1", @"i1": @"icon_r3", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"footer_spacing": @"10"};
    }
    
    NSDictionary *row206 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r4], [Globals.i intString:r4]], @"i1": @"icon_r4", @"i2": @"icon_check", @"footer_spacing": @"10"};
    if (!r4_check)
    {
        row206 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r4], [Globals.i intString:r4]], @"r1_color": @"1", @"i1": @"icon_r4", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"footer_spacing": @"10"};
    }
    
    NSDictionary *row207 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r5], [Globals.i intString:r5]], @"i1": @"icon_r5", @"i2": @"icon_check", @"footer_spacing": @"10"};
    if (!r5_check)
    {
        row207 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r5], [Globals.i intString:r5]], @"r1_color": @"1", @"i1": @"icon_r5", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"footer_spacing": @"10"};
    }
    
    NSMutableArray *rows2 = [@[row201, row202, row203, row204, row205, row206, row207] mutableCopy];
    
    BOOL b1_lvl_check = NO;
    NSString *b1_check = @"icon_x";
    NSString *b1_name = @"Library";
    
    if([self.tech_id integerValue]>1000&&[self.tech_id integerValue]<2000)
    {
        int tech_requirement_determinant = [self.tech_id integerValue]%100;
        
        switch (tech_requirement_determinant) {
            case 1:
                library_level_required=5;
                break;
            case 2:
                library_level_required=15;
                break;
            default:
                break;
        }
        if (self.building_level >= library_level_required)
        {
            b1_check = @"icon_check";
            b1_lvl_check = YES;
        }
        else
        {
            b1_check = @"icon_x";
            b1_lvl_check = NO;
        }

    }
    else
    {
        library_level_required = self.tech_level;
        if (self.building_level >= self.tech_level)
        {
            b1_check = @"icon_check";
            b1_lvl_check = YES;
        }
    }
    
    NSDictionary *row208 = @{@"r1": [NSString stringWithFormat:@"%@ Lv.%@", b1_name, [@(library_level_required) stringValue]], @"i1": @"icon_building", @"i2": b1_check, @"footer_spacing": @"10"};
    [rows2 addObject:row208];
    
    BOOL b2_lvl_check = YES;
    NSString *b2_check = @"icon_check";
    NSString *b2_name = NSLocalizedString(@"Blacksmith", nil);
    if ([self.tech_id integerValue] > 300) //Blacksmith needed
    {
        for (NSDictionary *dict in Globals.i.wsBuildArray)
        {
            if ([dict[@"building_id"] isEqualToString:@"16"])
            {
                self.blacksmith_level = [dict[@"building_level"] integerValue];
                
                //Check if this building is under construction
                if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
                {
                    self.blacksmith_level = self.blacksmith_level-1;
                }
            }
        }
        
        if([self.tech_id integerValue]>1000&&[self.tech_id integerValue]<2000)
        {
            int tech_requirement_determinant = [self.tech_id integerValue]%100;
            
            switch (tech_requirement_determinant) {
                case 1:
                    blacksmith_level_required=5;
                    break;
                case 2:
                    blacksmith_level_required=15;
                    break;
                default:
                    break;
            }
            if (self.blacksmith_level >= blacksmith_level_required)
            {
                b2_check = @"icon_check";
                b2_lvl_check = YES;
            }
            else
            {
                b2_check = @"icon_x";
                b2_lvl_check = NO;
            }
        }
        else
        {
            if (self.blacksmith_level >= self.tech_level)
            {
                b2_check = @"icon_check";
                b2_lvl_check = YES;
            }
            else
            {
                b2_check = @"icon_x";
                b2_lvl_check = NO;
            }
        }
        
        NSDictionary *row209 = @{@"r1": [NSString stringWithFormat:@"%@ Lv.%@", b2_name, [@(blacksmith_level_required) stringValue]], @"i1": @"icon_building", @"i2": b2_check, @"footer_spacing": @"10"};
        [rows2 addObject:row209];
    }
    
    [self.ui_cells_array addObject:rows2];
    
    NSString *title3 = NSLocalizedString(@"Research Rewards", nil);
    
    NSInteger boost = [self.researchDict[@"production"] integerValue]*self.tech_level;
    NSInteger power = [self.researchDict[@"power"] integerValue]*self.geo_p;
    NSInteger hero_xp = [self.researchDict[@"hero_xp"] integerValue]*self.tech_level;
    
    NSString *boost_name = self.row_target[@"r1"];
    
    NSDictionary *row301 = @{@"h1": title3, @"r1_align": @"1"};
    NSDictionary *row302 = @{@"r1": [NSString stringWithFormat:@"Boost %@: +%@%%", boost_name, [Globals.i intString:boost]], @"i1": @"icon_increase", @"footer_spacing": @"10"};
    NSDictionary *row303 = @{@"r1": [NSString stringWithFormat:@"Hero XP: +%@", [Globals.i intString:hero_xp]], @"i1": @"icon_hero_xp", @"footer_spacing": @"10"};
    NSDictionary *row304 = @{@"r1": [NSString stringWithFormat:@"Power: +%@", [Globals.i intString:power]], @"i1": @"icon_power", @"footer_spacing": @"10", @"nofooter": @"1"};

    NSMutableArray *rows3 = [@[row301, row302, row303, row304] mutableCopy];
    
    if ([self.tech_id integerValue] > 500) //No boost row
    {
        [rows3 removeObjectAtIndex:1];
    }
    
    [self.ui_cells_array addObject:rows3];
    
    NSInteger research_time = [self.researchDict[@"time"] integerValue]*self.geo_p;
    
    float boost_r = ([Globals.i.wsBaseDict[@"boost_research"] floatValue] / 100.0f) + 1.0f;
    self.time = (float)research_time / boost_r;
    
    NSString *str_time = [Globals.i getCountdownString:self.time];
    NSString *str_boost = [NSString stringWithFormat:NSLocalizedString(@"%@     Boost:+%@%%", nil), str_time, Globals.i.wsBaseDict[@"boost_research"]];
    
    NSString *research_btn = @"1";
    
    if (r1_check && r2_check && r3_check && r4_check && r5_check && b1_lvl_check && b2_lvl_check)
    {
        research_btn = @"2";
    }
    
    NSMutableDictionary *row401 = [@{@"r1": NSLocalizedString(@"Research", nil), @"r1_button": research_btn, @"r2": str_boost, @"r2_icon": @"icon_clock", @"r2_bkg": @"bkg3", @"fit": @"1", @"nofooter": @"1"} mutableCopy];
    NSArray *rows4 = @[row401];
    [self.ui_cells_array addObject:rows4];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    
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
        [self updateView];
    }
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    NSInteger r1_button = [[self.ui_cells_array[3][0] objectForKey:@"r1_button"] integerValue];
    
    if ((i == 401) && (r1_button > 1) && (self.tech_level < 22)) //Start Research
    {
        NSString *service_name = @"ResearchTech";
        NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                           Globals.i.wsWorldProfileDict[@"uid"], Globals.i.wsBaseDict[@"base_id"], self.tech_id];
        
        [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                  {
                      NSString *tv_title = [NSString stringWithFormat:@"%@ Lv.%@", self.tech_name, [@(self.tech_level) stringValue]];
                      [Globals.i setTimerViewTitle:TV_RESEARCH :tv_title];
                      
                      [Globals.i setupResearchQueue:[Globals.i updateTime]];
                      
                      NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                      [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
                      [userInfo setObject:@(TV_RESEARCH) forKey:@"tv_id"];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateResearchView"
                                                                          object:self
                                                                        userInfo:userInfo];
                      
                      [UIManager.i closeTemplate];
                      
                      [UIManager.i closeTemplate];
                      
                      NSInteger power = [self.researchDict[@"power"] integerValue]*self.geo_p;
                      NSInteger hero_xp = [self.researchDict[@"hero_xp"] integerValue]*self.tech_level;
                      
                      [Globals.i updateProfilePower:power];
                      [Globals.i updateHeroXP:hero_xp];
                  }];
             }
         }];
    }
}

- (void)button2_tap:(id)sender
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    NSInteger i = [sender tag];
    
    if (i == 203) //Get More r1
    {
        [userInfo setObject:@"r1" forKey:@"item_category2"];
    }
    else if (i == 204) //Get More r2
    {
        [userInfo setObject:@"r2" forKey:@"item_category2"];
    }
    else if (i == 205) //Get More r3
    {
        [userInfo setObject:@"r3" forKey:@"item_category2"];
    }
    else if (i == 206) //Get More r4
    {
        [userInfo setObject:@"r4" forKey:@"item_category2"];
    }
    else if (i == 207) //Get More r5
    {
        [userInfo setObject:@"r5" forKey:@"item_category2"];
    }
    
    if (userInfo.count > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                            object:self
                                                          userInfo:userInfo];
    }
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

@end
