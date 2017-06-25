//
//  DialogVillage
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/10/09.
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

#import "DialogVillage.h"
#import "Globals.h"

@interface DialogVillage ()

@end

@implementation DialogVillage

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseMapDialogs"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"AttackVillage"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CaptureVillage"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CloseMapDialogs"])
    {
        if ([UIManager.i.currentViewTitle isEqualToString:@"Barbarian Tile"])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [UIManager.i closeTemplate];
        }
    }
    else if ([[notification name] isEqualToString:@"AttackVillage"])
    {
        NSLog(@"AttackVillage");
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"DynamicCell : %@ ",customCellView);
            NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_a.btn);
            
            [customCellView.cellview.rv_a.btn sendActionsForControlEvents:UIControlEventTouchUpInside];;

        }
    }
    else if ([[notification name] isEqualToString:@"CaptureVillage"])
    {
        NSLog(@"CaptureVillage");
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"DynamicCell : %@ ",customCellView);
            NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_a.btn);
            
            [customCellView.cellview.rv_a.btn sendActionsForControlEvents:UIControlEventTouchUpInside];;
            
        }
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    NSString *strCoordinates = [NSString stringWithFormat:NSLocalizedString(@"Coordinates: X:%@ Y:%@", nil), @(self.map_x), @(self.map_y)];
    
    NSDictionary *row101 = @{@"r1": self.title, @"r1_color": @"0", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Barbarian Village", nil), @"r1_align": @"1", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row103 = @{@"r1": strCoordinates, @"r1_align": @"1", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row104 = @{@"r1": @" ", @"nofooter": @"1", @"fit": @"1"};
    NSArray *rows1 = @[row101, row102, row103, row104];
    
    NSMutableArray *rows2 = [[NSMutableArray alloc] init];
    
    NSDictionary *row201 = @{@"r1_icon": @"icon_attack", @"r1": NSLocalizedString(@"Attack", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"button_bookmark", @"c1": NSLocalizedString(@"Bookmark", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
    [rows2 addObject:row201];
    
    NSDictionary *row202 = @{@"r1_icon": @"icon_r5", @"r1": NSLocalizedString(@"Capture", nil), @"r1_button": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    [rows2 addObject:row202];
    
    self.ui_cells_array = [@[rows1, rows2] mutableCopy];
    
	[self.tableView reloadData];
}

- (void)button1_tap:(id)sender
{
    [self closeDialog];
    
    NSString *tile_type = @"t71";
    NSInteger v_lvl = [self.village_dict[@"village_level"] integerValue]; //Max is 10
    if (v_lvl < 4)
    {
        tile_type = @"t71";
    }
    else if (v_lvl < 8)
    {
        tile_type = @"t72";
    }
    else
    {
        tile_type = @"t73";
    }
    
    [self.village_dict addEntriesFromDictionary:@{@"base_type": tile_type}];
    
    [self.village_dict addEntriesFromDictionary:@{@"profile_id": @"0"}];
    
    [self.village_dict addEntriesFromDictionary:@{@"base_id": self.village_dict[@"village_id"]}];
    
    NSInteger i = [sender tag];
    if (i == 201) //Attack
    {
        [Globals.i doAttack:self.village_dict];
    }
    else if (i == 202)
    {
        [Globals.i showConfirmCapture:self.village_dict];
    }
}

- (void)button2_tap:(id)sender
{
    [self closeDialog];
    
    NSInteger i = [sender tag];
    
    if (i == 201) //Bookmark
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.title forKey:@"default_title"];
        [userInfo setObject:@(self.map_x) forKey:@"x"];
        [userInfo setObject:@(self.map_y) forKey:@"y"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BookmarkTile"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)closeDialog
{
    [UIManager.i closeTemplate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitFullscreen" object:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:DIALOG_CELL_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
