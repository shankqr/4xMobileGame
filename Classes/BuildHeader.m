//
//  BuildHeader.m
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

#import "BuildHeader.h"
#import "Globals.h"

@interface BuildHeader ()

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, assign) NSInteger buildtime;
@property (nonatomic, assign) NSInteger village_max_building_level;
@property (nonatomic, assign) NSInteger max_building_level;

@end

@implementation BuildHeader

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.backgroundImage.contentMode = UIViewContentModeScaleToFill;
    self.tableView.backgroundView = self.backgroundImage;
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
                                                 name:@"ResourcesAdded"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BuildBuilding"
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
    else if ([[notification name] isEqualToString:@"ResourcesAdded"])
    {
        if (self.ui_cells_array != nil)
        {
            [self updateView];
        }
    }
    else if ([[notification name] isEqualToString:@"BuildBuilding"])
    {
        NSLog(NSLocalizedString(@"Build this buiding", nil));
        
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            //NSInteger tutorial_step = [[userInfo objectForKey:@"tutorial_step"] integerValue];
            NSIndexPath *indexPath= [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            
            //[self button2_tap:indexPath.row];
            //NSLog(@"Cell BuildHeader : %@",[self.tableView cellForRowAtIndexPath:indexPath]);
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            NSLog(@"DynamicCell : %@ ",customCellView);
            NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_d.btn);
            
            //[self button2_tap:customCellView.cellview.rv_d.btn];
            [customCellView.cellview.rv_d.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            //NSLog(@"Next tutorial step :%ld",tutorial_step+1);
            
            /*
            NSMutableDictionary *userInfo2 = [[NSMutableDictionary alloc] init];
            [userInfo2 setObject:[NSNumber numberWithInteger:tutorial_step+1]  forKey:@"tutorial_step"];
            [userInfo2 setObject:[NSNumber numberWithDouble:3]  forKey:@"delay_time"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DelayTutorialDisplay"
                                                                object:self
                                                              userInfo:userInfo2];
             */
        }
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    if ([Globals.i.wsBaseDict[@"base_type"] isEqualToString:@"1"])
    {
        self.i_am_village = NO;
    }
    else
    {
        self.i_am_village = YES;
    }
    
    self.village_max_building_level = [Globals.i.wsSettingsDict[@"village_max_building_level"] integerValue];
    if (self.i_am_village)
    {
        self.max_building_level = self.village_max_building_level;
    }
    else
    {
        self.max_building_level = 22;
    }
    
    NSString *b_image = [NSString stringWithFormat:@"building%@_3", self.building_id];
    NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:self.level];
    
    float boost_c = ([Globals.i.wsBaseDict[@"boost_build"] floatValue] / 100.0f) + 1.0f;
    self.buildtime = [buildingLevelDict[@"time"] floatValue] / boost_c;
    NSString *build_time = [Globals.i getCountdownString:self.buildtime];
    NSString *str_boost = [NSString stringWithFormat:@"%@(+%@%%)", build_time, Globals.i.wsBaseDict[@"boost_build"]];
    
    NSString *ori_time = [Globals.i getCountdownString:[buildingLevelDict[@"time"] integerValue]];
    NSString *max_per_base = [Globals.i getBuildingDict:self.building_id][@"max_per_base"];
    
    float bar1 = (float)self.level/self.max_building_level;
    
    NSString *d1_button = @"1";
    if ([self checkReq])
    {
        d1_button = @"2";
    }
    
    NSString *button_title = NSLocalizedString(@"Build", nil);
    NSString *p1_text = [NSString stringWithFormat:@"1/%@", [@(self.max_building_level) stringValue]];
    if (self.level > 1)
    {
        button_title = NSLocalizedString(@"Upgrade", nil);
        p1_text = [NSString stringWithFormat:@"%@/%@", [@(self.level) stringValue], [@(self.max_building_level) stringValue]];
    }
    
    NSString *building_name = [Globals.i getBuildingDict:self.building_id][@"building_name"];
    NSString *building_level = [NSString stringWithFormat:@"(Level %@)", [@(self.level) stringValue]];

	NSDictionary *row101 = @{@"n1_width": @"60", @"i1": b_image, @"i1_aspect": @"1", @"p1": @(bar1), @"p1_text": p1_text, @"r1_align": @"1", @"r1": @"Time Required:", @"r2_align": @"1", @"r2": ori_time, @"c1_align": @"1", @"c1": @"Time Boost:", @"c2_align": @"1", @"c2": str_boost, @"d1": button_title, @"d1_button": d1_button, @"r1_color": @"0", @"r2_color": @"0", @"c1_color": @"0", @"c2_color": @"0", @"nofooter": @"1",@"extra_cell_height":@"10"};
	
    NSString *b1 = NSLocalizedString(@"Deconstruct", nil);
    NSString *b1_button = @"2";
    NSString *d1 = NSLocalizedString(@"Upgrade", nil);
    NSString *d1_button_upgrade = @"2";
    
    if (([self.is_upgrading isEqualToString:@"1"]))// && (Globals.i.buildQueue1 > 1))
    {
        b1 = @" ";
        b1_button = @"0";
        d1 = NSLocalizedString(@"Upgrading", nil);
        d1_button_upgrade = @"1";
    }
    
    if (![max_per_base isEqualToString:@"0"]) //Unlimited so can be demolished
    {
        b1 = @" ";
        b1_button = @"0";
    }
    
    if (self.firstStep)
    {
        row101 = @{@"n1_width": @"60", @"i1": b_image, @"i1_aspect": @"1", @"p1": @(bar1), @"p1_text": p1_text, @"r1_align": @"2", @"r1": building_name, @"r2_align": @"1", @"r2": @" ", @"c2": @" ", @"c1": building_level, @"b1": b1, @"b1_button": b1_button, @"d1": d1, @"d1_button": d1_button_upgrade, @"r1_color": @"0", @"r2_color": @"0", @"c1_color": @"0", @"c2_color": @"0", @"nofooter": @"1",@"extra_cell_height":@"10"};
    }
    
    NSArray *rows1 = @[row101];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
	
	[self.tableView reloadData];
    
    CGRect table_rect = [self.tableView rectForSection:[self.tableView numberOfSections] - 1];
    CGFloat table_height = CGRectGetMaxY(table_rect);
    CGRect bkg_frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, table_height);
    UIImage *bkg_image = [UIManager.i dynamicImage:bkg_frame prefix:@"bkg5"];
    [self.backgroundImage setImage:bkg_image];
    [self.backgroundImage setFrame:bkg_frame];
}

- (BOOL)checkReq
{
    BOOL req_met = NO;
    Globals.i.req1_b = NO;
    Globals.i.req2_b = NO;
    
    NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:self.level];
    NSInteger r1 = [buildingLevelDict[@"r1"] integerValue];
    NSInteger r2 = [buildingLevelDict[@"r2"] integerValue];
    NSInteger r3 = [buildingLevelDict[@"r3"] integerValue];
    NSInteger r4 = [buildingLevelDict[@"r4"] integerValue];
    
    NSUInteger base_r1 = Globals.i.base_r1;
    NSUInteger base_r2 = Globals.i.base_r2;
    NSUInteger base_r3 = Globals.i.base_r3;
    NSUInteger base_r4 = Globals.i.base_r4;
    
    NSString *req1_b_id = buildingLevelDict[@"require1_building_id"];
    NSInteger req1_b_lvl = [buildingLevelDict[@"require1_building_level"] integerValue];
    
    if ([req1_b_id isEqualToString:@"13"] && self.i_am_village)
    {
        //Village can't build embassy, so any requirements for embassy is removed
        Globals.i.req1_b = YES;
    }
    else if (![req1_b_id isEqualToString:@"0"] && req1_b_lvl > 0)
    {
        for (NSDictionary *dict in Globals.i.wsBuildArray)
        {
            if ([dict[@"building_id"] isEqualToString:req1_b_id])
            {
                NSInteger lvl = [dict[@"building_level"] integerValue];
                if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
                {
                    lvl = lvl-1;
                }
                
                if (req1_b_lvl <= lvl)
                {
                    Globals.i.req1_b = YES;
                }
            }
        }
    }
    else
    {
        Globals.i.req1_b = YES;
    }
    
    NSString *req2_b_id = buildingLevelDict[@"require2_building_id"];
    NSInteger req2_b_lvl = [buildingLevelDict[@"require2_building_level"] integerValue];
    if ([req2_b_id isEqualToString:@"13"] && self.i_am_village)
    {
        //Village can't build embassy, so any requirements for embassy is removed
        Globals.i.req2_b = YES;
    }
    else if (![req2_b_id isEqualToString:@"0"] && req2_b_lvl > 0)
    {
        for (NSDictionary *dict in Globals.i.wsBuildArray)
        {
            if ([dict[@"building_id"] isEqualToString:req2_b_id])
            {
                NSInteger lvl = [dict[@"building_level"] integerValue];
                if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
                {
                    lvl = lvl-1;
                }
                
                if (req2_b_lvl <= lvl)
                {
                    Globals.i.req2_b = YES;
                }
            }
        }
    }
    else
    {
        Globals.i.req2_b = YES;
    }
    
    if ((base_r1 >= r1) && (base_r2 >= r2) && (base_r3 >= r3) && (base_r4 >= r4)
        && (Globals.i.buildQueue1 < 1) && Globals.i.req1_b && Globals.i.req2_b
        && self.level < self.max_building_level+1)
    {
        req_met = YES;
    }
    
    return req_met;
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    NSInteger b1_button = [[self.ui_cells_array[0][0] objectForKey:@"b1_button"] integerValue];
    
    if ((b1_button > 1) && (i == 101))
    {
        NSString *max_per_base = [Globals.i getBuildingDict:self.building_id][@"max_per_base"];
        if ([max_per_base isEqualToString:@"0"]) //Unlimited so can be demolished
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"destroybuilding" forKey:@"item_category2"];
            [userInfo setObject:self.building_id forKey:@"building_id"];
            [userInfo setObject:@(self.location) forKey:@"building_location"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
}

- (void)button2_tap:(id)sender
{
    //NSLog(@"sender : %@ : ",sender);
    NSInteger i = [sender tag];
    
    NSInteger d1_button = [[self.ui_cells_array[0][0] objectForKey:@"d1_button"] integerValue];

    //NSLog(@"i : %ld : ",(long)i);
    //NSLog(@"d1_button : %ld : ",(long)d1_button);
    
    if ((d1_button > 1) && (i == 101))
    {
        if (!self.firstStep)
        {
            if ([self checkReq])
            {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:self.building_id forKey:@"building_id"];
                [userInfo setObject:@(self.level) forKey:@"building_level"];
                [userInfo setObject:@(self.location) forKey:@"building_location"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"BuildingBuild"
                                                                    object:self
                                                                  userInfo:userInfo];
                
                [UIManager.i closeAllTemplate];
            }
        }
        else
        {
            if (self.level < self.max_building_level)
            {
                //Show 2nd Step
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:self.building_id forKey:@"building_id"];
                [userInfo setObject:@(self.level) forKey:@"building_level"];
                [userInfo setObject:@(self.location) forKey:@"building_location"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildUpgrade"
                                                                    object:self
                                                                  userInfo:userInfo];
            }
            else
            {
                [UIManager.i showDialog:NSLocalizedString(@"You have reached the maximum level for this building!", nil) title:@"MaximumBuildingLevelReached"];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_b.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_b.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_d.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_d.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
