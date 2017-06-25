//
//  AllianceStats
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

#import "AllianceStats.h"
#import "Globals.h"

@interface AllianceStats ()

@end

@implementation AllianceStats

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Alliance", nil), @"r1_align": @"1", @"r1_color": @"2", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Founded", nil), @"c1": [Globals.i getTimeAgo:self.aAlliance.alliance_created], @"bkg": @"skin_cell1", @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
    NSDictionary *row103 = @{@"r1": NSLocalizedString(@"Level", nil), @"c1": self.aAlliance.alliance_level, @"bkg": @"skin_cell2", @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
    NSDictionary *row104 = @{@"r1": NSLocalizedString(@"Members", nil), @"c1": [NSString stringWithFormat:@"%@/%@0", self.aAlliance.total_members, self.aAlliance.alliance_level], @"bkg": @"skin_cell1", @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
    NSDictionary *row105 = @{@"r1": NSLocalizedString(@"Diamonds", nil), @"c1": [Globals.i numberFormat:self.aAlliance.alliance_currency_second], @"bkg": @"skin_cell2", @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
    NSDictionary *row106 = @{@"r1": NSLocalizedString(@"Power", nil), @"c1": [Globals.i numberFormat:self.aAlliance.power], @"bkg": @"skin_cell1", @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
    NSDictionary *row107 = @{@"r1": NSLocalizedString(@"Kills", nil), @"c1": [Globals.i numberFormat:self.aAlliance.kills], @"bkg": @"skin_cell2", @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
	NSMutableArray *rows1 = [@[row101, row102, row103, row104, row105, row106, row107] mutableCopy];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    [self.tableView reloadData];
    
    //Most Donations
    NSString *service_name = @"GetAllianceDonations";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       self.aAlliance.alliance_id];
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Most Donations", nil), @"r1_align": @"1", @"r1_color": @"2", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
                 NSMutableArray *rows2 = [@[row201] mutableCopy];
                 
                 NSInteger i = 0;
                 NSString *bkg_img = @"skin_cell1";
                 for (NSDictionary *dict in returnArray)
                 {
                     if (i % 2 == 0)
                     {
                         bkg_img = @"skin_cell2";
                     }
                     else
                     {
                         bkg_img = @"skin_cell1";
                     }
                     i++;
                     
                     NSString *profile_face = @"";
                     if (dict[@"profile_face"] != nil)
                     {
                         if ([dict[@"profile_face"] integerValue] > 0)
                         {
                             profile_face = [NSString stringWithFormat:@"face_%@", dict[@"profile_face"]];
                         }
                     }
                     
                     NSDictionary *row202 = @{@"i1": profile_face, @"i1_aspect": @"1", @"r1": dict[@"profile_name"], @"c1": [Globals.i numberFormat:dict[@"currency_second"]], @"bkg": bkg_img, @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
                     [rows2 addObject:row202];
                 }
                 
                 [self.ui_cells_array addObject:rows2];
                 [self.tableView reloadData];
             }
         }
     }];
    
    if (![self.aAlliance.alliance_id isEqualToString:Globals.i.selected_alliance_id])
    {
        [Globals.i GetAllianceMembers:self.aAlliance.alliance_id :^(BOOL success, NSData *data)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (success)
                 {
                     [self addPowerKillsRows];
                 }
             });
         }];
    }
    else
    {
        [self addPowerKillsRows];
    }
}

- (void)addPowerKillsRows
{
    //Most Power
    NSDictionary *row301 = @{@"r1": NSLocalizedString(@"Most Power", nil), @"r1_align": @"1", @"r1_color": @"2", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    NSMutableArray *rows3 = [@[row301] mutableCopy];
    
    NSInteger i = 0;
    NSString *bkg_img = @"skin_cell1";
    for (NSDictionary *dict in Globals.i.alliance_members)
    {
        if (i % 2 == 0)
        {
            bkg_img = @"skin_cell2";
        }
        else
        {
            bkg_img = @"skin_cell1";
        }
        i++;
        
        NSString *profile_face = @"";
        if (dict[@"profile_face"] != nil)
        {
            if ([dict[@"profile_face"] integerValue] > 0)
            {
                profile_face = [NSString stringWithFormat:@"face_%@", dict[@"profile_face"]];
            }
        }
        
        NSDictionary *row302 = @{@"i1": profile_face, @"i1_aspect": @"1", @"r1": dict[@"profile_name"], @"c1": [Globals.i numberFormat:dict[@"xp"]], @"bkg": bkg_img, @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
        [rows3 addObject:row302];
    }
    [self.ui_cells_array addObject:rows3];
    
    //Most Kills
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"kills.intValue" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [Globals.i.alliance_members sortedArrayUsingDescriptors:sortDescriptors];
    
    NSDictionary *row401 = @{@"r1": NSLocalizedString(@"Most Kills", nil), @"r1_align": @"1", @"r1_color": @"2", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    NSMutableArray *rows4 = [@[row401] mutableCopy];
    i = 0;
    for (NSDictionary *dict in sortedArray)
    {
        if (i % 2 == 0)
        {
            bkg_img = @"skin_cell2";
        }
        else
        {
            bkg_img = @"skin_cell1";
        }
        i++;
        
        NSString *profile_face = @"";
        if (dict[@"profile_face"] != nil)
        {
            if ([dict[@"profile_face"] integerValue] > 0)
            {
                profile_face = [NSString stringWithFormat:@"face_%@", dict[@"profile_face"]];
            }
        }
        
        NSDictionary *row402 = @{@"i1": profile_face, @"i1_aspect": @"1", @"r1": dict[@"profile_name"], @"c1": [Globals.i numberFormat:dict[@"kills"]], @"bkg": bkg_img, @"r1_border": @"1", @"r1_align": @"3", @"c1_ratio": @"2", @"c1_align": @"3", @"nofooter": @"1"};
        [rows4 addObject:row402];
    }
    [self.ui_cells_array addObject:rows4];
    
    [self.tableView reloadData];
}

@end
