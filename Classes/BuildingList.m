//
//  BuildingList.m
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

#import "BuildingList.h"
#import "Globals.h"

@interface BuildingList ()

@end

@implementation BuildingList

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    NSString *building_name = [Globals.i getBuildingDict:self.building_id][@"building_name"];
    
    NSString *building_job = NSLocalizedString(@"Healing", nil);
    
    if ([self.building_id isEqualToString:@"6"] || [self.building_id isEqualToString:@"7"] || [self.building_id isEqualToString:@"8"] || [self.building_id isEqualToString:@"9"])
    {
        building_job = NSLocalizedString(@"Training", nil);
    }
    
    NSDictionary *row10 = @{@"h1": [NSString stringWithFormat:NSLocalizedString(@"%@ Built", nil), building_name]};
    NSDictionary *row11 = @{@"r1": NSLocalizedString(@"Building", nil), @"c1": @" ", @"e1": NSLocalizedString(@"Capacity", nil), @"c1_ratio": @"2.5", @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"e1_align": @"2", @"nofooter": @"1"};

    NSMutableArray *buildings = [@[row10, row11] mutableCopy];

    NSInteger buildings_output = 0;

    NSInteger count = 1;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:self.building_id])
        {
            NSInteger lvl = [dict[@"building_level"] integerValue];
            //Check if this building is under construction
            if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
            {
                lvl = lvl-1;
            }
            
            NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:lvl];
            
            NSInteger capacity = [buildingLevelDict[@"capacity"] integerValue];
            
            NSString *strcapacity = [Globals.i intString:capacity];
            
            NSString *bkg_img = @"";
            if ([dict[@"location"] integerValue] == self.location)
            {
                bkg_img = @"skin_cell_marked1";
            }

            NSString *i1 = [NSString stringWithFormat:@"building%@_3", self.building_id];
            NSDictionary *row1 = @{@"bkg": bkg_img, @"i1": i1, @"r1": [NSString stringWithFormat:@"%@ Lv.%@", building_name, [@(lvl) stringValue]], @"c1": [NSString stringWithFormat:NSLocalizedString(@"%@ Troops", nil), strcapacity], @"c1_ratio": @"2", @"c1_align": @"2"};
            [buildings addObject:row1];

            buildings_output = buildings_output + capacity;

            count = count + 1;
        }
    }

    NSDictionary *row20 = @{@"h1": @" "};
    NSDictionary *row21 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Total %@ Capacity", nil), building_job], @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSDictionary *row22 = @{@"r1": [Globals.i intString:buildings_output], @"r1_font": CELL_FONT_SIZE, @"r1_bkg": @"bkg3", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row23 = @{@"r1": @" ", @"nofooter": @"1"};
    NSDictionary *row24 = @{@"r1": NSLocalizedString(@"More Infomation", nil), @"r1_button": @"2", @"nofooter": @"1"};
    NSArray *rows2 = @[row20, row21, row22, row23, row24];

    self.ui_cells_array = [@[buildings, rows2] mutableCopy];

    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);

    return dcell;
}

@end
