//
//  BuildView.m
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

#import "BuildView.h"
#import "Globals.h"

@interface BuildView ()

@property (nonatomic, strong) NSTimer *gameTimer;

@end

@implementation BuildView

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ResourcesAdded"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    //?Used To Handle Building Buildings/Tap on Build, Not here but it BuildHeader.m
    if ([[notification name] isEqualToString:@"CloseTemplateBefore"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *view_title = [userInfo objectForKey:@"view_title"];
        
        NSLog(@" userInfo : %@",userInfo);
        NSLog(@" view_title : %@",view_title);
        
        if ([self.title isEqualToString:view_title])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    }
    else if ([[notification name] isEqualToString:@"ResourcesAdded"])
    {
        if (self.ui_cells_array != nil)
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
    
    NSDictionary *row101 = @{@"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1": [Globals.i getBuildingDict:self.building_id][@"info"]};
    NSArray *rows1 = @[row101];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:self.level];
    NSInteger r1 = [buildingLevelDict[@"r1"] integerValue];
    NSInteger r2 = [buildingLevelDict[@"r2"] integerValue];
    NSInteger r3 = [buildingLevelDict[@"r3"] integerValue];
    NSInteger r4 = [buildingLevelDict[@"r4"] integerValue];
    
    NSUInteger base_r1 = Globals.i.base_r1;
    NSUInteger base_r2 = Globals.i.base_r2;
    NSUInteger base_r3 = Globals.i.base_r3;
    NSUInteger base_r4 = Globals.i.base_r4;
    
    NSString *bq_icon = @"icon_build";
    NSString *bq_title = NSLocalizedString(@"Building Queue", nil);
    NSString *bq_color = @"";
    NSString *bq_timer = @"";
    NSString *bq_check = @"icon_check";
    
    if (Globals.i.buildQueue1 > 1)
    {
        bq_icon = @"icon_build_cancel";
        bq_title = NSLocalizedString(@"Building Queue Full", nil);
        bq_color = @"1";
        bq_timer = [NSString stringWithFormat:NSLocalizedString(@"Available In: %@", nil), [Globals.i getCountdownString:Globals.i.buildQueue1]];
        bq_check = @"icon_x";
    }
    
    BOOL r1_check = NO;
    BOOL r2_check = NO;
    BOOL r3_check = NO;
    BOOL r4_check = NO;

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
    
    NSDictionary *row201 = @{@"h1": NSLocalizedString(@"Requirements", nil), @"r1_align": @"1"};
    
    NSDictionary *row202 = @{@"r1": bq_title, @"r1_color": bq_color, @"r2": bq_timer, @"r2_color": bq_color, @"i1": bq_icon, @"i2": bq_check, @"footer_spacing": @"10"};
    
    NSDictionary *row203 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r1], [Globals.i intString:r1]], @"i1": @"icon_r1", @"i2": @"icon_check", @"footer_spacing": @"10"};
    if (!r1_check)
    {
        row203 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r1], [Globals.i intString:r1]], @"r1_color": @"1", @"i1": @"icon_r1", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"footer_spacing": @"10"};
    }
    
    NSDictionary *row204 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r2], [Globals.i intString:r2]], @"i1": @"icon_r2", @"i2": @"icon_check", @"footer_spacing": @"10", @"footer_spacing": @"10"};
    if (!r2_check)
    {
        row204 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r2], [Globals.i intString:r2]], @"r1_color": @"1", @"i1": @"icon_r2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"footer_spacing": @"10", @"footer_spacing": @"10"};
    }
    
    NSDictionary *row205 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r3], [Globals.i intString:r3]], @"i1": @"icon_r3", @"i2": @"icon_check", @"footer_spacing": @"10"};
    if (!r3_check)
    {
        row205 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r3], [Globals.i intString:r3]], @"r1_color": @"1", @"i1": @"icon_r3", @"c1_ratio": @"3", @"c1": @"Get More", @"c1_button": @"2", @"footer_spacing": @"10"};
    }
    
    NSDictionary *row206 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i intString:base_r4], [Globals.i intString:r4]], @"i1": @"icon_r4", @"i2": @"icon_check", @"footer_spacing": @"10"};
    if (!r4_check)
    {
        row206 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", [Globals.i uintString:base_r4], [Globals.i intString:r4]], @"r1_color": @"1", @"i1": @"icon_r4", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get More", nil), @"c1_button": @"2", @"footer_spacing": @"10"};
    }
    
    NSMutableArray *rows2 = [@[row201, row202, row203, row204, row205, row206] mutableCopy];
    
    if (!Globals.i.req1_b)
    {
        NSString *req1_b_id = buildingLevelDict[@"require1_building_id"];
        NSString *b1_name = [Globals.i getBuildingDict:req1_b_id][@"building_name"];
        NSInteger req1_b_lvl = [buildingLevelDict[@"require1_building_level"] integerValue];
        
        NSDictionary *row207 = @{@"r1": [NSString stringWithFormat:@"%@ Lv.%@", b1_name, [@(req1_b_lvl) stringValue]], @"i1": @"icon_building", @"i2": @"icon_x", @"footer_spacing": @"10"};
        [rows2 addObject:row207];
    }
    
    if (!Globals.i.req2_b)
    {
        NSString *req2_b_id = buildingLevelDict[@"require2_building_id"];
        NSInteger req2_b_lvl = [buildingLevelDict[@"require2_building_level"] integerValue];
        NSString *b2_name = [Globals.i getBuildingDict:req2_b_id][@"building_name"];
        
        NSDictionary *row208 = @{@"r1": [NSString stringWithFormat:@"%@ Lv.%@", b2_name, [@(req2_b_lvl) stringValue]], @"i1": @"icon_building", @"i2": @"icon_x", @"footer_spacing": @"10"};
        [rows2 addObject:row208];
    }
    
    NSDictionary *row299 = @{@"r1": @" ", @"nofooter": @"1"};
    [rows2 addObject:row299];
    
    [self.ui_cells_array addObject:rows2];
    
    NSString *title3 = NSLocalizedString(@"Upgrade Reward", nil);
    if (self.level == 1)
    {
        title3 = NSLocalizedString(@"Build Reward", nil);
    }
    
    NSInteger power = [buildingLevelDict[@"power"] integerValue];
    NSInteger hero_xp = [buildingLevelDict[@"hero_xp"] integerValue];
    
    NSDictionary *row301 = @{@"h1": title3, @"r1_align": @"1"};
    NSDictionary *row302 = @{@"r1": [NSString stringWithFormat:@"Hero XP: +%@", [Globals.i intString:hero_xp]], @"i1": @"icon_hero_xp", @"footer_spacing": @"10"};
    NSDictionary *row303 = @{@"r1": [NSString stringWithFormat:@"Power: +%@", [Globals.i intString:power]], @"i1": @"icon_power", @"footer_spacing": @"10"};
    NSMutableArray *rows3 = [@[row301, row302, row303] mutableCopy];
    
    NSDictionary *row399 = @{@"r1": @" ", @"nofooter": @"1"};
    [rows3 addObject:row399];
    
    [self.ui_cells_array addObject:rows3];
    
    NSDictionary *row401 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ Reward Info", nil), [Globals.i getBuildingDict:self.building_id][@"building_name"]], @"r1_button": @"2", @"nofooter": @"1"};
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
    
    if (i == 401) //More Information
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.building_id forKey:@"building_id"];
        [userInfo setObject:@(self.level) forKey:@"building_level"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildingChart"
                                                            object:self
                                                          userInfo:userInfo];
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
