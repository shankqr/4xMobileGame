//
//  EmbassyView.m
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

#import "EmbassyView.h"
#import "Globals.h"

@interface EmbassyView ()

@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) NSMutableArray *r_troops;

@end

@implementation EmbassyView

- (void)updateView
{
    self.r_troops = [[NSMutableArray alloc] init];
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.building_id = @"13";
    
    NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:self.level];
    NSString *capacity = [Globals.i numberFormat:buildingLevelDict[@"capacity"]];

    NSString *service_name = @"GetReinforcementsAt";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsBaseDict[@"base_id"]];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 //Remove loading row
                 [self.ui_cells_array removeObjectAtIndex:0];
                 
                 if (returnArray.count > 0)
                 {
                     NSInteger total_a1 = 0;
                     NSInteger total_a2 = 0;
                     NSInteger total_a3 = 0;
                     NSInteger total_b1 = 0;
                     NSInteger total_b2 = 0;
                     NSInteger total_b3 = 0;
                     NSInteger total_c1 = 0;
                     NSInteger total_c2 = 0;
                     NSInteger total_c3 = 0;
                     NSInteger total_d1 = 0;
                     NSInteger total_d2 = 0;
                     NSInteger total_d3 = 0;
                     
                     NSInteger total_troops = 0;
                     
                     NSMutableArray *reinformentsProfiles = [[NSMutableArray alloc] init];
                     
                     NSInteger count = 0;
                     NSMutableArray *allProfiles = [[NSMutableArray alloc] init];
                     for (NSMutableDictionary *dict in returnArray)
                     {
                         NSInteger a1 = [dict[@"a1"] integerValue];
                         NSInteger a2 = [dict[@"a2"] integerValue];
                         NSInteger a3 = [dict[@"a3"] integerValue];
                         NSInteger b1 = [dict[@"b1"] integerValue];
                         NSInteger b2 = [dict[@"b2"] integerValue];
                         NSInteger b3 = [dict[@"b3"] integerValue];
                         NSInteger c1 = [dict[@"c1"] integerValue];
                         NSInteger c2 = [dict[@"c2"] integerValue];
                         NSInteger c3 = [dict[@"c3"] integerValue];
                         NSInteger d1 = [dict[@"d1"] integerValue];
                         NSInteger d2 = [dict[@"d2"] integerValue];
                         NSInteger d3 = [dict[@"d3"] integerValue];
                         
                         total_a1 = total_a1 + a1;
                         total_a2 = total_a2 + a2;
                         total_a3 = total_a3 + a3;
                         total_b1 = total_b1 + b1;
                         total_b2 = total_b2 + b2;
                         total_b3 = total_b3 + b3;
                         total_c1 = total_c1 + c1;
                         total_c2 = total_c2 + c2;
                         total_c3 = total_c3 + c3;
                         total_d1 = total_d1 + d1;
                         total_d2 = total_d2 + d2;
                         total_d3 = total_d3 + d3;
                         
                         NSInteger total_profile_troops = a1 + a2 + a3 + b1 + b2 + b3 + c1 + c2 + c3 + d1 + d2 + d3;
                         
                         NSMutableDictionary *row1 = [@{@"total_troops": @(total_profile_troops), @"i1": [NSString stringWithFormat:@"face_%@", dict[@"from_profile_face"]], @"i1_h": @" ", @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", dict[@"from_alliance_rank"]], @"r1": dict[@"from_profile_name"], @"n1_width": @"60", @"i2": @"arrow_right"} mutableCopy];
                         [row1 addEntriesFromDictionary:dict];
                         
                         [allProfiles addObject:row1];
                         
                         count = count + 1;
                     }
                     
                     //Get unique
                     NSMutableArray *uniqueProfiles = [[NSMutableArray alloc] init];
                     NSMutableSet *seenID = [NSMutableSet set];
                     for (NSDictionary *item in allProfiles)
                     {
                         //Extract the part of the dictionary that you want to be unique:
                         NSDictionary *idDict = [item dictionaryWithValuesForKeys:@[@"from_profile_id"]];
                         if ([seenID containsObject:idDict])
                         {
                             continue;
                         }
                         [seenID addObject:idDict];
                         [uniqueProfiles addObject:item];
                     }
                     
                     for (NSDictionary *dict in uniqueProfiles)
                     {
                         NSMutableArray *aProfile = [[NSMutableArray alloc] init];
                         for (NSDictionary *entry in allProfiles)
                         {
                             if ([entry[@"from_profile_id"] isEqualToString:dict[@"from_profile_id"]])
                             {
                                 [aProfile addObject:entry];
                             }
                         }
                         
                         NSMutableDictionary *mdict = [[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];

                         if (aProfile.count > 1)
                         {
                             NSNumber *sum_troops = [aProfile valueForKeyPath:@"@sum.total_troops"];
                             [mdict addEntriesFromDictionary:@{@"r2": [NSString stringWithFormat:@"Troops Sent:%@", [Globals.i numberString:sum_troops]]}];
                             
                             NSNumber *sum_a1 = [aProfile valueForKeyPath:@"@sum.a1"];
                             NSNumber *sum_a2 = [aProfile valueForKeyPath:@"@sum.a2"];
                             NSNumber *sum_a3 = [aProfile valueForKeyPath:@"@sum.a3"];
                             NSNumber *sum_b1 = [aProfile valueForKeyPath:@"@sum.b1"];
                             NSNumber *sum_b2 = [aProfile valueForKeyPath:@"@sum.b2"];
                             NSNumber *sum_b3 = [aProfile valueForKeyPath:@"@sum.b3"];
                             NSNumber *sum_c1 = [aProfile valueForKeyPath:@"@sum.c1"];
                             NSNumber *sum_c2 = [aProfile valueForKeyPath:@"@sum.c2"];
                             NSNumber *sum_c3 = [aProfile valueForKeyPath:@"@sum.c3"];
                             NSNumber *sum_d1 = [aProfile valueForKeyPath:@"@sum.d1"];
                             NSNumber *sum_d2 = [aProfile valueForKeyPath:@"@sum.d2"];
                             NSNumber *sum_d3 = [aProfile valueForKeyPath:@"@sum.d3"];
                             
                             [mdict setValue:sum_a1 forKey:@"a1"];
                             [mdict setValue:sum_a2 forKey:@"a2"];
                             [mdict setValue:sum_a3 forKey:@"a3"];
                             [mdict setValue:sum_b1 forKey:@"b1"];
                             [mdict setValue:sum_b2 forKey:@"b2"];
                             [mdict setValue:sum_b3 forKey:@"b3"];
                             [mdict setValue:sum_c1 forKey:@"c1"];
                             [mdict setValue:sum_c2 forKey:@"c2"];
                             [mdict setValue:sum_c3 forKey:@"c3"];
                             [mdict setValue:sum_d1 forKey:@"d1"];
                             [mdict setValue:sum_d2 forKey:@"d2"];
                             [mdict setValue:sum_d3 forKey:@"d3"];
                         }
                         else
                         {
                             [mdict addEntriesFromDictionary:@{@"r2": [NSString stringWithFormat:NSLocalizedString(@"Troops Sent:%@", nil), [Globals.i numberString:dict[@"total_troops"]]]}];
                         }
                         
                         //Generate troop list dialog box rows
                         NSMutableArray *troopArray = [Globals.i createTroopList:mdict];
                         [troopArray removeObjectAtIndex:troopArray.count-1];
                         [self.r_troops addObject:troopArray];
                         
                         [mdict removeObjectsForKeys:@[@"a1", @"a2", @"a3", @"b1", @"b2", @"b3", @"c1", @"c2", @"c3", @"d1", @"d2", @"d3"]];
                         
                         [reinformentsProfiles addObject:mdict];

                     }
                     
                     total_troops = total_a1 + total_a2 + total_a3 + total_b1 + total_b2 + total_b3 +
                                    total_c1 + total_c2 + total_c3 + total_d1 + total_d2 + total_d3;
                     
                     NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
                     NSDictionary *row102 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Capacity per Ally: %@", nil), capacity], @"r2": [NSString stringWithFormat:NSLocalizedString(@"Total Reinforcements: %@", nil), [Globals.i intString:total_troops]], @"i1": @"icon_reinforce", @"i2": @"arrow_right"};
                     NSDictionary *row103 = @{@"r1": NSLocalizedString(@"Troop Type", nil), @"c1": NSLocalizedString(@"Total", nil), @"c1_ratio": @"2.5", @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
                     
                     NSMutableArray *rows1 = [@[row101, row102, row103] mutableCopy];
                     
                     if (total_a1 > 0)
                     {
                         NSDictionary *row201 = @{@"i1": @"icon_a1", @"r1": Globals.i.a1, @"c1": [Globals.i intString:total_a1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row201];
                     }
                     if (total_a2 > 0)
                     {
                         NSDictionary *row202 = @{@"i1": @"icon_a2",@"r1": Globals.i.a2, @"c1": [Globals.i intString:total_a2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row202];
                     }
                     if (total_a3 > 0)
                     {
                         NSDictionary *row203 = @{@"i1": @"icon_a3", @"r1": Globals.i.a3, @"c1": [Globals.i intString:total_a3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row203];
                     }
                     
                     if (total_b1 > 0)
                     {
                         NSDictionary *row301 = @{@"i1": @"icon_b1", @"r1": Globals.i.b1, @"c1": [Globals.i intString:total_b1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row301];
                     }
                     if (total_b2 > 0)
                     {
                         NSDictionary *row302 = @{@"i1": @"icon_b2", @"r1": Globals.i.b2, @"c1": [Globals.i intString:total_b2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row302];
                     }
                     if (total_b3 > 0)
                     {
                         NSDictionary *row303 = @{@"i1": @"icon_b3", @"r1": Globals.i.b3, @"c1": [Globals.i intString:total_b3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row303];
                     }
                     
                     if (total_c1 > 0)
                     {
                         NSDictionary *row401 = @{@"i1": @"icon_c1", @"r1": Globals.i.c1, @"c1": [Globals.i intString:total_c1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row401];
                     }
                     if (total_c2 > 0)
                     {
                         NSDictionary *row402 = @{@"i1": @"icon_c2", @"r1": Globals.i.c2, @"c1": [Globals.i intString:total_c2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row402];
                     }
                     if (total_c3 > 0)
                     {
                         NSDictionary *row403 = @{@"i1": @"icon_c3", @"r1": Globals.i.c3, @"c1": [Globals.i intString:total_c3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row403];
                     }
                     
                     if (total_d1 > 0)
                     {
                         NSDictionary *row501 = @{@"i1": @"icon_d1", @"r1": Globals.i.d1, @"c1": [Globals.i intString:total_d1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row501];
                     }
                     if (total_d2 > 0)
                     {
                         NSDictionary *row502 = @{@"i1": @"icon_d2", @"r1": Globals.i.d2, @"c1": [Globals.i intString:total_d2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row502];
                     }
                     if (total_d3 > 0)
                     {
                         NSDictionary *row503 = @{@"i1": @"icon_d3", @"r1": Globals.i.d3, @"c1": [Globals.i intString:total_d3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
                         [rows1 addObject:row503];
                     }
                     
                     self.ui_cells_array = [@[rows1] mutableCopy];
                     
                     NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Reinforcements From", nil), @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"nofooter": @"1"};
                     NSMutableArray *rows2 = [@[row201] mutableCopy];
                     [rows2 addObjectsFromArray:reinformentsProfiles];
                     [self.ui_cells_array addObject:rows2];
                     
                     NSDictionary *row301 = @{@"r1": @" ", @"nofooter": @"1"};
                     NSMutableArray *rows3 = [@[row301] mutableCopy];
                     [self.ui_cells_array addObject:rows3];
                     
                     [self.tableView reloadData];
                 }
                 else
                 {
                     NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
                     NSDictionary *row102 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Capacity per Ally: %@", nil), capacity], @"r2": NSLocalizedString(@"Total Reinforcements: 0", nil), @"i1": @"icon_reinforce", @"i2": @"arrow_right"};
                     NSDictionary *row103 = @{@"r1": @" ", @"nofooter": @"1"};
                     NSDictionary *row104 = @{@"r1": NSLocalizedString(@"No Reinforcements", nil), @"r1_align": @"1", @"r1_color": @"1", @"nofooter": @"1"};
                     
                     NSArray *rows1 = @[row101, row102, row103, row104];
                     
                     [self.ui_cells_array insertObject:rows1 atIndex:0];
                     
                     [self.tableView reloadData];
                 }
             }
         });
     }];
    
    NSDictionary *row101 = @{@"r1": @" ", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Loading...", nil), @"r1_align": @"1", @"nofooter": @"1"};
    
    NSArray *rows1 = @[row101, row102];

    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)img1_tap:(id)sender
{
    [Globals.i play_button];
    
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSString *selected_profile_id = self.ui_cells_array[section][row][@"from_profile_id"];
    if (selected_profile_id != nil)
    {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:selected_profile_id forKey:@"profile_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.img1 addTarget:self action:@selector(img1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.img1.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 0) && (indexPath.row == 1))
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.building_id forKey:@"building_id"];
        [userInfo setObject:@(self.level) forKey:@"building_level"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildingChart"
                                                            object:self
                                                          userInfo:userInfo];
    }
    else if (indexPath.section == 1)
    {
        NSInteger row = indexPath.row - 1;
        
        if (self.r_troops[row] != nil)
        {
            NSMutableArray *dialogRows = [@[self.r_troops[row]] mutableCopy];
            [UIManager.i showDialogBlockRow:dialogRows title:@"EmbassyTroops" type:3
                                        :^(NSInteger index, NSString *text)
             { }];
        }
    }
    
    return nil;
}

@end
