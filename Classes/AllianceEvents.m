//
//  AllianceEvents.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 10/23/13.
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

#import "AllianceEvents.h"
#import "Globals.h"

@implementation AllianceEvents

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self emptyTable];
}

- (void)emptyTable
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
}

- (void)updateView
{
    NSString *service_name = @"GetAllianceEvents";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       self.aAlliance.alliance_id];

    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 NSDictionary *row0 = @{@"h1": NSLocalizedString(@"Events", nil)};
                 
                 NSMutableArray *rowArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                 [rowArray insertObject:row0 atIndex:0];
                 
                 self.ui_cells_array = [@[rowArray] mutableCopy];
             }
             else //A message when no data is present
             {
                 NSDictionary *row0 = @{@"r1": NSLocalizedString(@"No events yet.", nil), @"r1_align": @"1", @"r1_color": @"1"};
                 NSArray *rows1 = @[row0];
                 
                 self.ui_cells_array = [@[rows1] mutableCopy];
             }
             
             [self.tableView reloadData];
             [self.tableView flashScrollIndicators];
         }
     }];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = self.ui_cells_array[indexPath.section][indexPath.row];
    
    if (indexPath.row == 0) //Header row
    {
        return rowData;
	}
    else
    {
        NSString *i1 = @"";
        NSString *r1 = [Globals.i getTimeAgo:rowData[@"date_posted"]];
        NSString *r2 = rowData[@"message"];
        
        if (rowData[@"event_icon"] != nil)
        {
            i1 = rowData[@"event_icon"];
        }
        
        return @{@"i1": i1, @"i1_aspect": @"1", @"r1": r1, @"r2": r2};
    }
}

@end
