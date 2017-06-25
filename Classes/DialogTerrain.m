//
//  DialogTerrain
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

#import "DialogTerrain.h"
#import "Globals.h"

@interface DialogTerrain ()

@end

@implementation DialogTerrain

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseMapDialogs"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CloseMapDialogs"])
    {
        if ([UIManager.i.currentViewTitle isEqualToString:@"Terrain Tile"])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [UIManager.i closeTemplate];
        }
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    NSString *r1 = [NSString stringWithFormat:NSLocalizedString(@"Coordinates: X:%@ Y:%@", nil), @(self.map_x), @(self.map_y)];
    
    NSDictionary *row101 = @{@"r1": self.title, @"r1_color": @"0", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": r1, @"r1_color": @"0", @"r1_align": @"1", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row103 = @{@"r1": @" ", @"nofooter": @"1"};
    NSArray *rows1 = @[row101, row102, row103];
    
    NSDictionary *row201 = @{@"r1_icon": @"icon_occupy", @"r1": NSLocalizedString(@"Teleport", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"button_bookmark", @"c1": NSLocalizedString(@"Bookmark", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
    NSArray *rows2 = @[row201];
    
    self.ui_cells_array = [@[rows1, rows2] mutableCopy];
    
	[self.tableView reloadData];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 201) //Teleport
    {
        BOOL village_teleport = NO;
        if (Globals.i.wsSettingsDict != nil)
        {
            NSString *v_teleport = Globals.i.wsSettingsDict[@"village_teleport"];
            
            if ([v_teleport isEqualToString:@"1"])
            {
                village_teleport = YES;
            }
        }
        
        BOOL i_am_village = NO;
        if ([Globals.i.wsBaseDict[@"base_type"] isEqualToString:@"1"])
        {
            i_am_village = NO;
        }
        else
        {
            i_am_village = YES;
        }
        
        if (i_am_village)
        {
            if (village_teleport)
            {
                [self ShowItemsTeleport];
            }
            else
            {
                [UIManager.i showDialog:NSLocalizedString(@"Unable to teleport Village's, you are only allowed to teleport your City.", nil) title:@"VillageTeleportFailed"];
            }
        }
        else
        {
            [self ShowItemsTeleport];
        }
    }
}

- (void)ShowItemsTeleport
{
    [self closeDialog];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"teleport" forKey:@"item_category2"];
    [userInfo setObject:[@(self.map_x) stringValue] forKey:@"map_x"];
    [userInfo setObject:[@(self.map_y) stringValue] forKey:@"map_y"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 201) //Bookmark
    {
        [self closeDialog];
        
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
