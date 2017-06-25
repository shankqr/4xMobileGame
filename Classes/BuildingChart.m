//
//  BuildingChart.m
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

#import "BuildingChart.h"
#import "Globals.h"

@interface BuildingChart ()

@end

@implementation BuildingChart

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"nofooter": @"1", @"r1_align": @"1"};
    NSDictionary *row102 = @{@"r1": [NSString stringWithFormat:@"%@ Details", [Globals.i getBuildingDict:self.building_id][@"building_name"]], @"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE};
    
    NSDictionary *row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Hourly", nil), @"c1": NSLocalizedString(@"Capacity", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"r1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1", @"c1_align": @"1"};
    if ([self.building_id isEqualToString:@"101"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Castle Abilities", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"102"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Defense Bonus", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"6"] || [self.building_id isEqualToString:@"7"] || [self.building_id isEqualToString:@"8"] || [self.building_id isEqualToString:@"9"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Training Capacity", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"10"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Heal Capacity", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"11"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Resources Protected", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"12"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Resource Help Capacity", nil), @"c1": @"Tax", @"c1_align": @"1", @"bkg": @"skin_cell2", @"n1_border": @"1", @"r1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"13"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Reinforcement Capacity", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"14"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Watchtower Abilities", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"15"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Library Abilities", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"16"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Blacksmith Abilities", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    else if ([self.building_id isEqualToString:@"17"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"Spy Limit", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    if ([self.building_id isEqualToString:@"18"])
    {
        row201 = @{@"n1": NSLocalizedString(@"Level", nil), @"r1": NSLocalizedString(@"March Capacity", nil), @"bkg": @"skin_cell2", @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
    }
    NSMutableArray *rows2 = [[NSMutableArray alloc] initWithObjects:row201, nil];
    
    for (NSInteger i = 1; i < 23; i++)
    {
        NSString *bkg_img = @"skin_cell1";
        
        if (i % 2 == 0)
        {
            bkg_img = @"skin_cell2";
        }
        
        if (i == self.level)
        {
            bkg_img = @"skin_cell_marked1";
        }
        
        NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:i];
        NSString *production = [Globals.i numberFormat:buildingLevelDict[@"production"]];
        NSString *capacity = [Globals.i numberFormat:buildingLevelDict[@"capacity"]];
        
        NSDictionary *row = nil;
        if ([self.building_id isEqualToString:@"1"] || [self.building_id isEqualToString:@"2"] || [self.building_id isEqualToString:@"3"] || [self.building_id isEqualToString:@"4"] || [self.building_id isEqualToString:@"5"])
        {
            row = @{@"n1": [@(i) stringValue], @"r1": production, @"c1": capacity, @"c1_align": @"1", @"bkg": bkg_img, @"n1_border": @"1", @"r1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
        }
        else if ([self.building_id isEqualToString:@"6"] || [self.building_id isEqualToString:@"7"] || [self.building_id isEqualToString:@"8"] || [self.building_id isEqualToString:@"9"] || [self.building_id isEqualToString:@"10"] || [self.building_id isEqualToString:@"11"] || [self.building_id isEqualToString:@"13"] || [self.building_id isEqualToString:@"17"] || [self.building_id isEqualToString:@"18"])
        {
            row = @{@"n1": [@(i) stringValue], @"r1": capacity, @"bkg": bkg_img, @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
        }
        else if ([self.building_id isEqualToString:@"102"])
        {
            row = @{@"n1": [@(i) stringValue], @"r1": [NSString stringWithFormat:@"%@%%", production], @"bkg": bkg_img, @"n1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
        }
        else if ([self.building_id isEqualToString:@"12"])
        {
            row = @{@"n1": [@(i) stringValue], @"r1": capacity, @"c1": [NSString stringWithFormat:@"%@%%", production], @"c1_align": @"1", @"bkg": bkg_img, @"n1_border": @"1", @"r1_border": @"1", @"nofooter": @"1", @"n1_width": @"60.0", @"r1_align": @"1"};
        }
        else if ([self.building_id isEqualToString:@"15"]) //Library
        {
            const int numberOfLevels = 22;
            NSMutableArray *rowWt = [NSMutableArray array];
            for (int i = 1; i <= numberOfLevels; ++i)
            {
                NSString *str = [NSString stringWithFormat:NSLocalizedString(@"Can research Level %@ Technology.", nil), @(i).stringValue];
                [rowWt addObject:str];
            }
            
            row = @{@"n1": [@(i) stringValue], @"r1": rowWt[i-1], @"bkg": bkg_img, @"n1_border": @"1", @"n1_width": @"60.0", @"r1_align": @"1", @"nofooter": @"1"};
        }
        else if ([self.building_id isEqualToString:@"16"]) //Blacksmith
        {
            const int numberOfLevels = 22;
            NSMutableArray *rowWt = [NSMutableArray array];
            for (int i = 1; i <= numberOfLevels; ++i)
            {
                NSString *str = [NSString stringWithFormat:NSLocalizedString(@"Can research Level %@ Military and Combat.", nil), @(i).stringValue];
                [rowWt addObject:str];
            }
            
            row = @{@"n1": [@(i) stringValue], @"r1": rowWt[i-1], @"bkg": bkg_img, @"n1_border": @"1", @"n1_width": @"60.0", @"r1_align": @"1", @"nofooter": @"1"};
        }
        else if ([self.building_id isEqualToString:@"101"]) //Castle Abilities
        {
            const int numberOfLevels = 22;
            NSMutableArray *rowWt = [NSMutableArray array];
            for (int i = 1; i <= numberOfLevels; ++i)
            {
                NSString *str = [NSString stringWithFormat:NSLocalizedString(@"Can upgrade buildings to Level %@.", nil), @(i).stringValue];
                [rowWt addObject:str];
            }
            
            row = @{@"n1": [@(i) stringValue], @"r1": rowWt[i-1], @"bkg": bkg_img, @"n1_border": @"1", @"n1_width": @"60.0", @"r1_align": @"1", @"nofooter": @"1"};
        }
        
        if (row != nil)
        {
            [rows2 addObject:row];
        }
        
        if ([self.building_id isEqualToString:@"14"]) //Watchtower Abilities
        {
            bkg_img = @"skin_cell1";
            if (i % 4 == 1)
            {
                bkg_img = @"skin_cell2";
            }
            
            NSArray *rowWt = @[NSLocalizedString(@"Warns of an incoming Attack on your Cities.", nil),
                               @"",
                               NSLocalizedString(@"Shows you the Profile Picture of the player sending the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Tells you the Name of the player sending the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Tells you the City of the player sending the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Tells you the Coordinates of the player sending the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Tells you the Alliance Rank of the player sending the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Tells you if a Hero is leading the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Gives you an estimate of the total troops in the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Gives you an estimate for each troop types in the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Gives you specific names for each troop in the Attack.", nil),
                               @"",
                               NSLocalizedString(@"Tells you the exact number of troops in the Attack.", nil),
                               @""];
            if (i % 2 == 1)
            {
                if ((i == self.level) || (i == self.level-1))
                {
                    bkg_img = @"skin_cell_marked1";
                }
                
                row = @{@"n1": [@(i) stringValue], @"r1": rowWt[i-1], @"bkg": bkg_img, @"n1_border": @"1", @"n1_width": @"60.0", @"r1_align": @"1", @"nofooter": @"1"};
                [rows2 addObject:row];
            }
        }
    }
    
    NSArray *rows1 = @[row101, row102];
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    NSDictionary *rowEmpty = @{@"nofooter": @"1", @"r1": @" "};
    [rows2 addObject:rowEmpty];
    
    [self.ui_cells_array addObject:rows2];
    
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
