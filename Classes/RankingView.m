//
//  RankingView.m
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

#import "RankingView.h"
#import "Globals.h"

@implementation RankingView

- (void)updateView
{
    NSDictionary *row101 = @{@"h1": NSLocalizedString(@"Top 1000", nil)};
    NSMutableArray *rows1 = [@[row101] mutableCopy];
    
    NSString *wsurl = @"";
    
    [Globals.i getServerLoading:self.serviceName :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 NSInteger count = 0;
                 
                 for (NSDictionary *row1 in returnArray)
                 {
                     count = count + 1;
                     
                     NSString *r1_icon;
                     if ([row1[@"alliance_rank"] integerValue] > 0)
                     {
                         r1_icon = [NSString stringWithFormat:@"rank_%@", row1[@"alliance_rank"]];
                     }
                     else
                     {
                         r1_icon = @"";
                     }
                     
                     NSString *r1 = row1[@"profile_name"];
                     if ([row1[@"alliance_tag"] length] > 2)
                     {
                         r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
                     }
                     
                     NSString *r2 = [NSString stringWithFormat:NSLocalizedString(@"Power:%@", nil), [Globals.i autoNumber:row1[@"xp"]]];
                     NSDictionary *row101 = @{@"profile_id": row1[@"profile_id"], @"c1": [@(count) stringValue], @"c1_ratio": @"6", @"r1": r1, @"r1_bold": @"1", @"r1_icon": r1_icon, @"r2": r2, @"i1": [NSString stringWithFormat:@"face_%@", row1[@"profile_face"]], @"i1_aspect": @"1", @"i2": @"arrow_right"};
                     
                     [rows1 addObject:row101];
                 }
             }
             
             self.ui_cells_array = [@[rows1] mutableCopy];
             
             [self.tableView reloadData];
             [self.tableView flashScrollIndicators];
         }
     }];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) //Not Header row
    {
        NSDictionary *rowData = self.ui_cells_array[indexPath.section][indexPath.row];
        
        NSString *selected_profileid = rowData[@"profile_id"];
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:selected_profileid forKey:@"profile_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
    
	return nil;
}

@end
