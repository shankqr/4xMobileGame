//
//  Resource1Detail.m
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

#import "Resource1Detail.h"
#import "Globals.h"

@interface Resource1Detail ()

@end

@implementation Resource1Detail

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSString *i1 = [NSString stringWithFormat:@"icon_%@", self.base_field];
    
    NSDictionary *row0 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ Production", nil), self.product_name], @"i1": i1, @"nofooter": @"1"};
    
    NSArray *rows0 = @[row0];
    
    NSDictionary *row10 = @{@"h1": [NSString stringWithFormat:@"%@s Owned", self.building_name]};
    NSDictionary *row11 = @{@"r1": NSLocalizedString(@"Building", nil), @"c1": @" ", @"e1": NSLocalizedString(@"Production / hr", nil), @"c1_ratio": @"2.5", @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"e1_align": @"2", @"nofooter": @"1"};
    
    NSMutableArray *buildings = [@[row10, row11] mutableCopy];
    
    NSInteger buildings_output = 0;
    
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:self.building_id])
        {
            NSInteger lvl = [dict[@"building_level"] integerValue];
            
            //Check if this building is under construction
            if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
            {
                lvl = lvl-1;
            }
            
            NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:lvl];
            NSInteger production = [buildingLevelDict[@"production"] integerValue];
            NSString *strProduction = [Globals.i intString:production];
            
            NSString *i1 = [NSString stringWithFormat:@"building%@_3", self.building_id];
            NSDictionary *row1 = @{@"i1": i1, @"r1": self.building_name, @"c1": [NSString stringWithFormat:@"Lv.%@", [@(lvl) stringValue]], @"e1": [NSString stringWithFormat:@"%@ / hr", strProduction], @"c1_ratio": @"2.5", @"e1_align": @"2"};
            [buildings addObject:row1];
        
            buildings_output = buildings_output + production;
        }
    }
    
    NSArray *rows2 = [self getOverallRows:buildings_output];
    
    self.ui_cells_array = [@[rows0, buildings, rows2] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (NSArray *)getOverallRows:(NSInteger)buildings_output
{
    NSDictionary *baseDict = [Globals.i wsBaseDict];
    
    NSString *p = [NSString stringWithFormat:@"%@_production", self.base_field];
    NSString *h = [NSString stringWithFormat:@"hero_boost_%@", self.base_field];
    NSString *i = [NSString stringWithFormat:@"item_boost_%@", self.base_field];
    NSString *r = [NSString stringWithFormat:@"research_%@", self.base_field];
    
    NSString *upkeep = [Globals.i numberFormat:baseDict[@"upkeep"]];
    
    double f_income = [baseDict[p] doubleValue];
    NSString *income = [Globals.i floatString:f_income];

    NSInteger h_b = [Globals.i.wsBaseDict[h] integerValue];
    double hero_boost = buildings_output * h_b/100.0f;
    NSString *boost_hero = [Globals.i floatString:hero_boost];
    
    NSInteger i_b = [Globals.i.wsBaseDict[i] integerValue];
    double item_boost = buildings_output * i_b/100.0f;
    NSString *boost_item = [Globals.i floatString:item_boost];
    
    NSInteger r_b = [Globals.i.wsBaseDict[r] integerValue];
    double research_boost = buildings_output * r_b/100.0f;
    NSString *boost_research = [Globals.i floatString:research_boost];
    
    NSDictionary *row20 = @{@"h1": [NSString stringWithFormat:NSLocalizedString(@"%@ Production", nil), self.product_name]};
    NSDictionary *row21 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ Output:", nil), self.building_name], @"c1": [NSString stringWithFormat:@"%@ / hr", [Globals.i intString:buildings_output]], @"c1_align": @"2", @"c1_ratio": @"2"};
    NSDictionary *row22 = @{@"r1": NSLocalizedString(@"Hero Boost:", nil), @"c1": [NSString stringWithFormat:@"+ %@ / hr", boost_hero], @"c1_align": @"2", @"c1_ratio": @"2"};
    NSDictionary *row23 = @{@"r1": NSLocalizedString(@"Items Boost:", nil), @"c1": [NSString stringWithFormat:@"+ %@ / hr", boost_item], @"c1_align": @"2", @"c1_ratio": @"2"};
    NSDictionary *row24 = @{@"r1": NSLocalizedString(@"Research Boost:", nil), @"c1": [NSString stringWithFormat:@"+ %@ / hr", boost_research], @"c1_align": @"2", @"c1_ratio": @"2"};
    NSMutableArray *rows = [@[row20, row21, row22, row23, row24] mutableCopy];
    
    if ([self.building_id isEqualToString:@"1"])
    {
        NSDictionary *row25 = @{@"r1": NSLocalizedString(@"Troop Upkeep:", nil), @"c1": [NSString stringWithFormat:@"- %@ / hr", upkeep], @"c1_align": @"2", @"c1_ratio": @"2", @"c1_color": @"1"};
        [rows addObject:row25];
    }
    NSString *c1_color = @"0";
    if (f_income < 0)
    {
        c1_color = @"1";
    }
    NSDictionary *row26 = @{@"r1": NSLocalizedString(@"Overall Income:", nil), @"c1": [NSString stringWithFormat:@"%@ / hr", income], @"c1_align": @"2", @"c1_ratio": @"2", @"c1_color": c1_color};
    [rows addObject:row26];
    NSDictionary *row27 = @{@"nofooter": @"1", @"r1": @" "};
    [rows addObject:row27];
    
    return rows;
}

@end
