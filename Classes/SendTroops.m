//
//  SendTroops.m
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

#import "SendTroops.h"
#import "Globals.h"

@interface SendTroops ()

@property (nonatomic, strong) NSMutableDictionary *sel_dict;
@property (nonatomic, assign) NSUInteger sel_value;

@end

@implementation SendTroops

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"QueueMax"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CloseTemplateBefore"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *view_title = [userInfo objectForKey:@"view_title"];
        
        if ([self.title isEqualToString:view_title])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    }
    else if ([[notification name] isEqualToString:@"QueueMax"])
    {
        NSInteger count = [self.ui_cells_array[0] count];
        NSUInteger totalTroops = 0;
        NSUInteger capacity =0;
        for (int i = 0; i < count-1; i++)
        {
            totalTroops+=[self.ui_cells_array[0][i][@"slider_max"] integerValue];
        }
        
        //NSLog(@"Total Troops : %lu",(unsigned long)totalTroops);
        
        //Temporary: may be a better way to grab the data
        for (NSDictionary *dict in Globals.i.wsBuildArray)
        {
            if ([dict[@"building_id"] isEqualToString:@"18"])
            {
                NSInteger lvl = [dict[@"building_level"] integerValue];
                NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:@"18" level:lvl];
                capacity = [buildingLevelDict[@"capacity"] integerValue];
            }
        }
        
        //NSLog(@"Limit Troops : %lu",(unsigned long)capacity);
        
        for (int i = 0; i < count-1; i++)
        {
            //NSLog(@"QueueMax :%d: %d",i,[self.ui_cells_array[0][i][@"slider_max"] integerValue]);
            CGFloat ratio_for_this_type =0;
            ratio_for_this_type = [self.ui_cells_array[0][i][@"slider_max"] floatValue]/(CGFloat)totalTroops;
            //NSLog(@"Ratio :%f",ratio_for_this_type);
            NSUInteger max_based_on_ratio = ratio_for_this_type*capacity;
            //NSLog(@"max_based_on_ration :%lu",(unsigned long)max_based_on_ration);
            NSUInteger available_troop = [self.ui_cells_array[0][i][@"slider_max"] integerValue];
            if(available_troop>max_based_on_ratio)
            {
                [self.ui_cells_array[0][i] setValue:@(max_based_on_ratio) forKey:@"s1"];
                
                [self.sel_dict setValue:@(max_based_on_ratio) forKey:self.ui_cells_array[0][i][@"type"]];
            }
            else
            {
                [self.ui_cells_array[0][i] setValue:@(available_troop) forKey:@"s1"];
                
                [self.sel_dict setValue:@(available_troop) forKey:self.ui_cells_array[0][i][@"type"]];
            }
        }
        
        [self updateSendHeader];
        
        [self.tableView reloadData];
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.sel_dict = [@{@"Spy": @"0", @"Hero": @"0", Globals.i.a1: @"0", Globals.i.a2: @"0", Globals.i.a3: @"0", Globals.i.b1: @"0", Globals.i.b2: @"0", Globals.i.b3: @"0", Globals.i.c1: @"0", Globals.i.c2: @"0", Globals.i.c3: @"0", Globals.i.d1: @"0", Globals.i.d2: @"0", Globals.i.d3: @"0"} mutableCopy];
    
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    NSDictionary *baseDict = Globals.i.wsBaseDict;
    
    if ([self.userInfo[@"action"] isEqualToString:@"Spy"])
    {
        NSMutableDictionary *row201 = [@{@"type": @"Spy", @"i1": @"icon_spy", @"r1": @"Spies", @"r2_slider": @"0", @"s1": @"0", @"slider_max": baseDict[@"spy"], @"nofooter": @"1"} mutableCopy];
        [rows1 addObject:row201];
    }
    else
    {
    /* //Dissable send Hero
    if ([self.userInfo[@"action"] isEqualToString:@"Attack"])
    {
        NSMutableDictionary *row201 = [@{@"type": @"Hero", @"i1": [NSString stringWithFormat:@"hero_face%@", Globals.i.wsWorldProfileDict[@"hero_type"]], @"r1": [NSString stringWithFormat:@"%@ (Hero)", Globals.i.wsWorldProfileDict[@"hero_name"]], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @"1"} mutableCopy];
        [rows1 addObject:row201];
    }
    */
    if (Globals.i.base_a1 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.a1, @"i1": @"icon_a1", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Infantry)", nil), Globals.i.a1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_a1)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_a2 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.a2, @"i1": @"icon_a2", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Infantry)", nil), Globals.i.a2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_a2)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_a3 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.a3, @"i1": @"icon_a3", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Infantry)", nil), Globals.i.a3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_a3)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_b1 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.b1, @"i1": @"icon_b1", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Ranged)", nil), Globals.i.b1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_b1)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_b2 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.b2, @"i1": @"icon_b2", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Ranged)", nil), Globals.i.b2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_b2)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_b3 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.b3, @"i1": @"icon_b3", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Ranged)", nil), Globals.i.b3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_b3)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_c1 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.c1, @"i1": @"icon_c1", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Cavalry)", nil), Globals.i.c1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_c1)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_c2 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.c2, @"i1": @"icon_c2", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Cavalry)", nil), Globals.i.c2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_c2)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_c3 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.c3, @"i1": @"icon_c3", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Cavalry)", nil), Globals.i.c3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_c3)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_d1 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.d1, @"i1": @"icon_d1", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Seige)", nil), Globals.i.d1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_d1)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_d2 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.d2, @"i1": @"icon_d2", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Siege)", nil), Globals.i.d2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_d2)} mutableCopy];
        [rows1 addObject:row201];
    }
    if (Globals.i.base_d3 > 0)
    {
        NSMutableDictionary *row201 = [@{@"type": Globals.i.d3, @"i1": @"icon_d3", @"r1": [NSString stringWithFormat:NSLocalizedString(@"%@ (Siege)", nil), Globals.i.d3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(Globals.i.base_d3)} mutableCopy];
        [rows1 addObject:row201];
    }
        
    }
    NSDictionary *row107 = @{@"r1": @" ", @"nofooter": @"1", @"fit": @"1"};
    [rows1 addObject:row107];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)slider1_change:(UISlider *)sender
{
    
    
    NSInteger row = sender.tag-101;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.ui_cells_array[0][row] copyItems:YES];
    self.sel_value = ((DCFineTuneSlider *)sender).selectedValue;
    
    [dict1 setValue:@(self.sel_value) forKey:@"s1"];
    
    [self.ui_cells_array[0] removeObjectAtIndex:row];
    [self.ui_cells_array[0] insertObject:dict1 atIndex:row];
    
    [self.sel_dict setValue:@(self.sel_value) forKey:dict1[@"type"]];
    
    [self updateSendHeader];
}

- (void)updateSendHeader
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.sel_dict forKey:@"sel_dict"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSendHeader"
                                                        object:self
                                                      userInfo:userInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [(UISlider *)dcell.cellview.rv_a.slider addTarget:self action:@selector(slider1_change:) forControlEvents:UIControlEventValueChanged];
    ((UISlider *)dcell.cellview.rv_a.slider).tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
