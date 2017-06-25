//
//  HeroChart.m
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

#import "HeroChart.h"
#import "Globals.h"

@implementation HeroChart

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSInteger pwr = [Globals.i powerFromLevel:[Globals.i getLevel]];
    
    NSString *tips = NSLocalizedString(@"Spend your Skill Points and Equip your Hero to boost up.", nil);
    NSDictionary *row0 = @{@"bkg_prefix": @"bkg1", @"r1": tips, @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSDictionary *row1 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Hero Power: %@", nil), [Globals.i intString:pwr]], @"r1_align": @"1", @"nofooter": @"1"};
    NSArray *rows1 = @[row0, row1];
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    NSDictionary *row20 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": NSLocalizedString(@"Production Boost", nil)};
    NSDictionary *row21 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Food Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_r1"]]};
    NSDictionary *row22 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Wood Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_r2"]]};
    NSDictionary *row23 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Stone Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_r3"]]};
    NSDictionary *row24 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Ore Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_r4"]]};
    NSDictionary *row25 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Gold Production", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_r5"]]};
    
    NSDictionary *row200 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": NSLocalizedString(@"City Boost", nil)};
    NSDictionary *row26 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Construction Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_build"]]};
    NSDictionary *row27 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Research Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_research"]]};
    NSDictionary *row28 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Training Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_training"]]};
    NSDictionary *row29 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"March Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_march"]]};
    NSDictionary *row210 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Trade Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_trade"]]};
    NSDictionary *row211 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Craft Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", [Globals.i wsBaseDict][@"hero_boost_craft"]]};
    NSDictionary *row212 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Healing Speed", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", [Globals.i wsBaseDict][@"hero_boost_heal"]]};
    NSMutableArray *rows2 = [[NSMutableArray alloc] initWithObjects:row20, row21, row22, row23, row24, row25, row200, row26, row27, row28, row29, row210, row211, row212, nil];
    [self.ui_cells_array addObject:rows2];
    
    NSDictionary *row30 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": NSLocalizedString(@"Attack Boost", nil)};
    NSDictionary *row31 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Infantry Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_a_attack"]]};
    NSDictionary *row32 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Cavalry Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_b_attack"]]};
    NSDictionary *row33 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Ranged Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_c_attack"]]};
    NSDictionary *row34 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Siege Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_d_attack"]]};
    NSMutableArray *rows3 = [[NSMutableArray alloc] initWithObjects:row30, row31, row32, row33, row34, nil];
    [self.ui_cells_array addObject:rows3];
    
    NSDictionary *row40 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": NSLocalizedString(@"Troop Boost", nil)};
    NSDictionary *row41 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Attack", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_attack"]]};
    NSDictionary *row42 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Defense", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_defense"]]};
    NSDictionary *row43 = @{@"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Life", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_life"]]};
    NSDictionary *row44 = @{@"bkg": @"skin_cell1", @"n1_border": @"1", @"nofooter": @"1", @"n1": NSLocalizedString(@"Load", nil), @"n1_width": @"150.0", @"r1_align": @"1", @"r1": [NSString stringWithFormat:@"+%@%%", Globals.i.wsBaseDict[@"hero_boost_load"]]};
    NSDictionary *row45 = @{@"nofooter": @"1", @"r1": @" "};
    NSMutableArray *rows4 = [[NSMutableArray alloc] initWithObjects:row40, row41, row42, row43, row44, row45, nil];
    [self.ui_cells_array addObject:rows4];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

@end
