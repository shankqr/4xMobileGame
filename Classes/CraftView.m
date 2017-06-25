//
//  CraftView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 10/20/13.
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

#import "CraftView.h"
#import "Globals.h"

@interface CraftView ()

@property (nonatomic, strong) NSString *building_id;

@end

@implementation CraftView

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.building_id = @"16";
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    NSMutableArray *rows1 = [[NSMutableArray alloc] initWithObjects:row101, nil];
    
    const int numberOfLevels = 22;
    NSMutableArray *rowNx = [NSMutableArray array];
    for (int i = 1; i <= numberOfLevels; ++i)
    {
        NSString *str = [NSString stringWithFormat:NSLocalizedString(@"Can research Level %@ Military and Combat.", nil), @(i).stringValue];
        [rowNx addObject:str];
    }

    if (self.level < 23)
    {
        if (![rowNx[self.level-1] isEqualToString:@""])
        {
            //NSDictionary *row102 = @{@"r1": @" ", @"nofooter": @"1"};
            NSDictionary *row103 = @{@"r1": NSLocalizedString(@"This Level", nil), @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
            NSDictionary *row104 = @{@"r1": rowNx[self.level-1], @"r1_bkg": @"bkg3", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};

            NSDictionary *row107 = @{@"r1": @" ", @"nofooter": @"1"};
            NSDictionary *row108 = @{@"r1": NSLocalizedString(@"More Information", nil), @"r1_button": @"2", @"nofooter": @"1"};
            
            //[rows1 addObject:row102];
            [rows1 addObject:row103];
            [rows1 addObject:row104];
            
            if (self.level < 22)
            {
                NSDictionary *row105 = @{@"r1": NSLocalizedString(@"Next Level", nil), @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
                NSDictionary *row106 = @{@"r1": rowNx[self.level], @"r1_bkg": @"bkg3", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
                [rows1 addObject:row105];
                [rows1 addObject:row106];
            }
            
            [rows1 addObject:row107];
            [rows1 addObject:row108];
        }
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
