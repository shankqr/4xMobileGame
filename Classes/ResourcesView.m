//
//  ResourcesView.m
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

#import "ResourcesView.h"
#import "Globals.h"

@interface ResourcesView ()

@end

@implementation ResourcesView

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSString *icon_resources = [NSString stringWithFormat:@"icon_r%@", self.building_id];
    
    NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:self.level];
    NSString *production = [Globals.i numberFormat:buildingLevelDict[@"production"]];
    NSString *capacity = [Globals.i numberFormat:buildingLevelDict[@"capacity"]];
    
    NSString *resourceName = Globals.i.r1;
    if ([self.building_id isEqualToString:@"1"])
    {
        resourceName = Globals.i.r1;
    }
    else if ([self.building_id isEqualToString:@"2"])
    {
        resourceName = Globals.i.r2;
    }
    else if ([self.building_id isEqualToString:@"3"])
    {
        resourceName = Globals.i.r3;
    }
    else if ([self.building_id isEqualToString:@"4"])
    {
        resourceName = Globals.i.r4;
    }
    else if ([self.building_id isEqualToString:@"5"])
    {
        resourceName = Globals.i.r5;
    }
    
    NSString *rtype = [NSString stringWithFormat:@"r%@", self.building_id];
    NSString *rproduction = [NSString stringWithFormat:@"%@_production", rtype];
    NSString *rcapacity = [NSString stringWithFormat:@"%@_capacity", rtype];
    NSString *city_production = [Globals.i floatNumber:Globals.i.wsBaseDict[rproduction]];
    
    NSString *base_city_cap = Globals.i.wsBaseDict[rcapacity];
    NSString *city_capacity = [Globals.i numberFormat:base_city_cap];
    
    NSLog(@"base_city_cap: %@", base_city_cap);
    NSLog(@"city_capacity: %@", city_capacity);
    
    NSString *val_font = @"15.0";
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Hourly Production", nil), @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSDictionary *row103 = @{@"r1_icon": icon_resources, @"r1": production, @"r1_font": val_font, @"r1_bkg": @"bkg3", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row104 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ Capacity", nil), resourceName], @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSDictionary *row105 = @{@"r1_icon": @"icon_capacity", @"r1": capacity, @"r1_font": val_font, @"r1_bkg": @"bkg3", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row106 = @{@"r1": NSLocalizedString(@"City Hourly Production", nil), @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSDictionary *row107 = @{@"r1_icon": icon_resources, @"r1": city_production, @"r1_font": val_font, @"r1_bkg": @"bkg3", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row108 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"City %@ Capacity", nil), resourceName], @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSDictionary *row109 = @{@"r1_icon": @"icon_capacity", @"r1": city_capacity, @"r1_font": val_font, @"r1_bkg": @"bkg3", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row110 = @{@"r1": @" ", @"nofooter": @"1"};
    NSDictionary *row111 = @{@"r1": NSLocalizedString(@"More Information", nil), @"r1_button": @"2", @"c1": [NSString stringWithFormat:@"Get %@", resourceName], @"c1_button": @"2", @"nofooter": @"1"};
    NSArray *rows1 = @[row101, row102, row103, row104, row105, row106, row107, row108, row109, row110, row111];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
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

- (void)button2_tap:(id)sender
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSString *resourceType = [NSString stringWithFormat:@"r%@", self.building_id];
    
    [userInfo setObject:resourceType forKey:@"item_category2"];
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
    
    return dcell;
}

@end
