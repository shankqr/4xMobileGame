//
//  BoostChart.m
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

#import "BoostChart.h"
#import "Globals.h"

@implementation BoostChart

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSString *tips = NSLocalizedString(@"Below are the total boost for the city.", nil);
    NSDictionary *row101 = @{@"r1": tips, @"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1"};
    NSArray *rows1 = @[row101];
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    NSDictionary *row201 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": NSLocalizedString(@"Production Boost", nil)};
    NSDictionary *row202 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Food Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_r1"]]};
    NSDictionary *row203 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Wood Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_r2"]]};
    NSDictionary *row204 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Stone Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_r3"]]};
    NSDictionary *row205 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Ore Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_r4"]]};
    NSDictionary *row206 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Gold Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_r5"]]};
    
    NSDictionary *row207 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": NSLocalizedString(@"City Boost", nil)};
    NSDictionary *row208 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Construction Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_build"]]};
    NSDictionary *row209 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Research Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_research"]]};
    NSDictionary *row210 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Training Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_training"]]};
    NSDictionary *row211 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"March Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_march"]]};
    NSDictionary *row212 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Trade Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_trade"]]};
    NSDictionary *row213 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Craft Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", [Globals.i wsBaseDict][@"boost_craft"]]};
    NSDictionary *row214 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Healing Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", [Globals.i wsBaseDict][@"boost_heal"]]};
    NSMutableArray *rows2 = [[NSMutableArray alloc] initWithObjects:row201, row202, row203, row204, row205, row206, row207, row208, row209, row210, row211, row212, row213, row214, nil];
    [self.ui_cells_array addObject:rows2];
    
    NSDictionary *row301 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": NSLocalizedString(@"Attack Boost", nil)};
    NSDictionary *row302 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Infantry Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_a_attack"]]};
    NSDictionary *row303 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Cavalry Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_b_attack"]]};
    NSDictionary *row304 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Ranged Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_c_attack"]]};
    NSDictionary *row305 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Siege Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_d_attack"]]};
    NSMutableArray *rows3 = [[NSMutableArray alloc] initWithObjects:row301, row302, row303, row304, row305, nil];
    [self.ui_cells_array addObject:rows3];
    
    NSDictionary *row401 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": NSLocalizedString(@"Troop Boost", nil)};
    NSDictionary *row402 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_attack"]]};
    NSDictionary *row403 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Defense", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_defense"]]};
    NSDictionary *row404 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Life", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_life"]]};
    NSDictionary *row405 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Load", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"boost_load"]]};
    NSDictionary *row406 = @{@"nofooter": @"1", @"r1": @" "};
    NSMutableArray *rows4 = [[NSMutableArray alloc] initWithObjects:row401, row402, row403, row404, row405, row406, nil];
    [self.ui_cells_array addObject:rows4];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CHART_CELL_WIDTH];
    
    return dcell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CHART_CELL_WIDTH];
}

@end
