//
//  BuildList.m
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

#import "BuildList.h"
#import "Globals.h"

@interface BuildList ()
 // *consider calling this sections?
@property (nonatomic, strong) NSMutableArray *rowsInside; //section 1
@property (nonatomic, strong) NSMutableArray *rowsOutside; //section 2

@end

@implementation BuildList

- (void)viewDidLoad
{
	[super viewDidLoad];

    [self notificationRegister];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChooseBuilding"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"ChooseBuilding"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *building_section = [userInfo objectForKey:@"building_section"];
            NSNumber *building_index = [userInfo objectForKey:@"building_index"];
            
            NSLog(@"building_section : %@",building_section);
            NSLog(@"building_index : %@",building_index);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[building_index intValue] inSection:[building_section intValue]];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"customCellView BuildList : %@",customCellView);

            
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView.delegate tableView:self.tableView willSelectRowAtIndexPath:indexPath];
            
            //NSLog(@"ChooseBuilding Done");
        }
    }
}

- (void)generateRowsInside:(BOOL)is_village
{
    self.rowsInside = [[NSMutableArray alloc] init];
    
    BOOL has11 = NO;
    BOOL has12 = NO;
    BOOL has13 = NO;
    BOOL has14 = NO;
    BOOL has15 = NO;
    BOOL has16 = NO;
    BOOL has17 = NO;
    BOOL has18 = NO;
    
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] integerValue] == 11)
        {
            has11 = YES;
        }
        else if ([dict[@"building_id"] integerValue] == 12)
        {
            has12 = YES;
        }
        else if ([dict[@"building_id"] integerValue] == 13)
        {
            has13 = YES;
        }
        else if ([dict[@"building_id"] integerValue] == 14)
        {
            has14 = YES;
        }
        else if ([dict[@"building_id"] integerValue] == 15)
        {
            has15 = YES;
        }
        else if ([dict[@"building_id"] integerValue] == 16)
        {
            has16 = YES;
        }
        else if ([dict[@"building_id"] integerValue] == 17)
        {
            has17 = YES;
        }
        else if ([dict[@"building_id"] integerValue] == 18)
        {
            has18 = YES;
        }
    }
    
    if (!has18)
    {
        NSDictionary *row1 = @{@"building_id": @"18", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"18"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"18"][@"info"], @"i1": @"building18_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
        [self.rowsInside addObject:row1];
    }
    if (!has15)
    {
        NSDictionary *row1 = @{@"building_id": @"15", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"15"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"15"][@"info"], @"i1": @"building15_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
        [self.rowsInside addObject:row1];
    }
    
    
    NSDictionary *row20 = @{@"building_id": @"5", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"5"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"5"][@"info"], @"i1": @"building5_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    NSDictionary *row21 = @{@"building_id": @"6", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"6"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"6"][@"info"], @"i1": @"building6_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    NSDictionary *row22 = @{@"building_id": @"7", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"7"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"7"][@"info"], @"i1": @"building7_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    NSDictionary *row23 = @{@"building_id": @"8", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"8"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"8"][@"info"], @"i1": @"building8_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    NSDictionary *row24 = @{@"building_id": @"9", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"9"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"9"][@"info"], @"i1": @"building9_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    NSDictionary *row25 = @{@"building_id": @"10", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"10"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"10"][@"info"], @"i1": @"building10_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    
    [self.rowsInside addObject:row20];
    [self.rowsInside addObject:row21];
    [self.rowsInside addObject:row22];
    [self.rowsInside addObject:row23];
    [self.rowsInside addObject:row24];
    [self.rowsInside addObject:row25];

    if (!has11)
    {
        NSDictionary *row1 = @{@"building_id": @"11", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"11"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"11"][@"info"], @"i1": @"building11_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
        [self.rowsInside addObject:row1];
    }
    
    if (!has12)
    {
        NSDictionary *row1 = @{@"building_id": @"12", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"12"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"12"][@"info"], @"i1": @"building12_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
        [self.rowsInside addObject:row1];
    }
    
    if (!has13 && !is_village) //Dont add embassy if it is village city
    {
        NSDictionary *row1 = @{@"building_id": @"13", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"13"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"13"][@"info"], @"i1": @"building13_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
        [self.rowsInside addObject:row1];
    }
    
    if (!has14)
    {
        NSDictionary *row1 = @{@"building_id": @"14", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"14"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"14"][@"info"], @"i1": @"building14_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
        [self.rowsInside addObject:row1];
    }
    
    
    if (!has16)
    {
        NSDictionary *row1 = @{@"building_id": @"16", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"16"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"16"][@"info"], @"i1": @"building16_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
        [self.rowsInside addObject:row1];
    }
    if (!has17)
    {
        NSDictionary *row1 = @{@"building_id": @"17", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"17"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"17"][@"info"], @"i1": @"building17_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
        [self.rowsInside addObject:row1];
    }

}

- (void)generateRowsOutside
{
    NSDictionary *row20 = @{@"building_id": @"1", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"1"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"1"][@"info"], @"i1": @"building1_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    NSDictionary *row21 = @{@"building_id": @"2", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"2"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"2"][@"info"], @"i1": @"building2_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    NSDictionary *row22 = @{@"building_id": @"3", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"3"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"3"][@"info"], @"i1": @"building3_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    NSDictionary *row23 = @{@"building_id": @"4", @"n1_width": @"60", @"r1": [Globals.i getBuildingDict:@"4"][@"building_name"], @"r2": [Globals.i getBuildingDict:@"4"][@"info"], @"i1": @"building4_3", @"i1_aspect": @"1", @"i2": @"arrow_right"};
    self.rowsOutside = [@[row20, row21, row22, row23] mutableCopy];
}

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    if (self.inside_outside_both == 1)
    {
        NSDictionary *row0 = @{@"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1": NSLocalizedString(@"Listed below are urban buildings. Each have their own ability and function.", nil)};
        NSArray *rows1 = @[row0];
        
        self.ui_cells_array = [@[rows1] mutableCopy];
        
        [self generateRowsInside:NO];

        [self.ui_cells_array addObject:self.rowsInside];
    }
    else if (self.inside_outside_both == 2)
    {
        NSDictionary *row0 = @{@"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1": NSLocalizedString(@"Listed below are rural buildings. These buildings can generate valuable resources for your city.", nil)};
        NSArray *rows1 = @[row0];
        
        self.ui_cells_array = [@[rows1] mutableCopy];
        
        [self generateRowsOutside];
        
        [self.ui_cells_array addObject:self.rowsOutside];
    }
    else if (self.inside_outside_both == 3)
    {
        NSDictionary *row0 = @{@"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1": NSLocalizedString(@"Listed below are all the buildings you can build in your village city.", nil)};
        NSArray *rows1 = @[row0];
        
        self.ui_cells_array = [@[rows1] mutableCopy];
        
        [self generateRowsInside:YES];
        [self generateRowsOutside];
        
        [self.ui_cells_array addObject:self.rowsInside];
        [self.ui_cells_array addObject:self.rowsOutside];
    }
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 || indexPath.section == 2)
    {
        NSDictionary *rowData = self.ui_cells_array[indexPath.section][indexPath.row];
        NSString *b_id = rowData[@"building_id"];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:b_id forKey:@"building_id"];
        [userInfo setObject:@"0" forKey:@"building_level"];
        [userInfo setObject:@(self.location) forKey:@"building_location"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildUpgrade"
                                                            object:self
                                                          userInfo:userInfo];
    }
    
	return nil;
}

@end
