//
//  WallView.m
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

#import "WallView.h"
#import "Globals.h"

@interface WallView ()

@property (nonatomic, strong) NSString *building_id;

@end

@implementation WallView

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.building_id = @"102";
    
    NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:self.level];
    NSString *production = [Globals.i numberFormat:buildingLevelDict[@"production"]];
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": @" ", @"nofooter": @"1"};
    NSDictionary *row103 = @{@"r1": NSLocalizedString(@"Defense Bonus", nil), @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSDictionary *row104 = @{@"r1": [NSString stringWithFormat:@"%@%%", production], @"r1_font": CELL_FONT_SIZE, @"r1_bkg": @"bkg3", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row105 = @{@"r1": @" ", @"nofooter": @"1"};
    NSDictionary *row106 = @{@"r1": NSLocalizedString(@"More Information", nil), @"r1_button": @"2", @"nofooter": @"1"};
    NSArray *rows1 = @[row101, row102, row103, row104, row105, row106];
    
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
