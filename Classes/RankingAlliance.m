//
//  RankingAlliance.m
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

#import "RankingAlliance.h"
#import "Globals.h"

@interface RankingAlliance ()

@property (nonatomic, strong) NSMutableArray *array_alliance_object;

@end

@implementation RankingAlliance

- (void)updateView
{
    NSDictionary *row101 = @{@"h1": NSLocalizedString(@"Top 1000", nil)};
    NSMutableArray *rows1 = [@[row101] mutableCopy];
    
    NSString *service_name = @"GetAllianceTopLevel";
    NSString *wsurl = @"";
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
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
                     
                     AllianceObject *aAlliance = [[AllianceObject alloc] initWithDictionary:row1];
                     if (self.array_alliance_object == nil)
                     {
                         self.array_alliance_object = [[NSMutableArray alloc] init];
                     }
                     [self.array_alliance_object addObject:aAlliance];
                     
                     NSString *r1_icon = @"";
                     if (([row1[@"alliance_language"] integerValue] > 0) && ([row1[@"alliance_language"] integerValue] < 263))
                     {
                         r1_icon = [NSString stringWithFormat:@"flag_%@", row1[@"alliance_language"]];
                     }
                     
                     NSString *r1 = row1[@"alliance_name"];
                     if ([row1[@"alliance_tag"] length] > 2)
                     {
                         r1 = [NSString stringWithFormat:@"%@[%@]", row1[@"alliance_name"], row1[@"alliance_tag"]];
                     }
                     
                     NSString *r2 = [NSString stringWithFormat:NSLocalizedString(@"Leader: %@", nil), row1[@"leader_name"]];
                     NSDictionary *row101 = @{@"alliance_id": row1[@"alliance_id"], @"c1": [@(count) stringValue], @"c1_ratio": @"6", @"r1": r1, @"r1_bold": @"1", @"r1_icon": r1_icon, @"r2": r2, @"i1": [NSString stringWithFormat:@"a_logo_%@", row1[@"alliance_logo"]], @"i1_aspect": @"1", @"i2": @"arrow_right", @"nofooter": @"1"};
                     NSDictionary *row102 = @{@"bkg_prefix": @"bkg3", @"r1_icon": @"icon_power", @"r1": [Globals.i autoNumber:row1[@"power"]], @"r1_color": @"2", @"r1_align": @"1", @"c1_icon": @"icon_kills", @"c1": [Globals.i autoNumber:row1[@"kills"]], @"c1_color": @"2", @"c1_align": @"1", @"c1_ratio": @"3", @"e1_icon": @"icon_members", @"e1": [NSString stringWithFormat:@"%@/%@0", row1[@"total_members"], row1[@"alliance_level"]], @"e1_color": @"2", @"e1_align": @"1"};
                     
                     [rows1 addObject:row101];
                     [rows1 addObject:row102];
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
    if ((indexPath.row > 0) && (indexPath.row % 2 == 1) && ([self.array_alliance_object count] > 0)) //Odd number rows
    {
        NSInteger index = indexPath.row / 2;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.array_alliance_object[index] forKey:@"alliance_object"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
    
	return nil;
}

@end
