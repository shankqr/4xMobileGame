//
//  OptionsView.m
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

#import "OptionsView.h"
#import "Globals.h"

@implementation OptionsView

- (void)updateView
{
    NSMutableDictionary *row101 = [@{@"r1": @" "} mutableCopy];
    NSMutableDictionary *row102 = [@{@"r1": NSLocalizedString(@"Sound FX", nil), @"r1_bold": @"1", @"r2": @"Enabled", @"r2_color": @"0", @"c1": @" ", @"c1_button": @"on", @"c1_ratio": @"4"} mutableCopy];
    NSMutableDictionary *row103 = [@{@"r1": NSLocalizedString(@"Intro Music", nil), @"r1_bold": @"1", @"r2": @"Enabled", @"r2_color": @"0", @"c1": @" ", @"c1_button": @"on", @"c1_ratio": @"4"} mutableCopy];
    NSMutableDictionary *row104 = [@{@"r1": NSLocalizedString(@"Background Music", nil), @"r1_bold": @"1", @"r2": @"Enabled", @"r2_color": @"0", @"c1": @" ", @"c1_button": @"on", @"c1_ratio": @"4"} mutableCopy];
    NSMutableDictionary *row105 = [@{@"r1": NSLocalizedString(@"Quest Reminder", nil), @"r1_bold": @"1", @"r2": @"Enabled", @"r2_color": @"0", @"c1": @" ", @"c1_button": @"on", @"c1_ratio": @"4"} mutableCopy];
    NSMutableArray *rows1 = [@[row101, row102, row103, row104, row105] mutableCopy];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    NSInteger row = 1;
    if ([Globals.i.sound_fx isEqualToString:@"0"])
    {
        [self.ui_cells_array[0][row] setValue:@"Disabled" forKey:@"r2"];
        [self.ui_cells_array[0][row] setValue:@"1" forKey:@"r2_color"];
        [self.ui_cells_array[0][row] setValue:@"off" forKey:@"c1_button"];
    }
    
    row = 2;
    if ([Globals.i.music_intro isEqualToString:@"0"])
    {
        [self.ui_cells_array[0][row] setValue:@"Disabled" forKey:@"r2"];
        [self.ui_cells_array[0][row] setValue:@"1" forKey:@"r2_color"];
        [self.ui_cells_array[0][row] setValue:@"off" forKey:@"c1_button"];
    }
    
    row = 3;
    if ([Globals.i.music_bg isEqualToString:@"0"])
    {
        [self.ui_cells_array[0][row] setValue:@"Disabled" forKey:@"r2"];
        [self.ui_cells_array[0][row] setValue:@"1" forKey:@"r2_color"];
        [self.ui_cells_array[0][row] setValue:@"off" forKey:@"c1_button"];
    }
    
    row = 4;
    if ([Globals.i.quest_reminder isEqualToString:@"0"])
    {
        [self.ui_cells_array[0][row] setValue:@"Disabled" forKey:@"r2"];
        [self.ui_cells_array[0][row] setValue:@"1" forKey:@"r2_color"];
        [self.ui_cells_array[0][row] setValue:@"off" forKey:@"c1_button"];
    }
    
    [self.tableView reloadData];
}

- (void)button1_tap:(id)sender
{
    [Globals.i play_button];
    
    NSInteger i = [sender tag];
    NSInteger row = 1;
    
    if (i == 102)
    {
        row = 1;
        if ([self.ui_cells_array[0][row][@"r2"] isEqualToString:@"Enabled"])
        {
            [Globals.i sound_fx_off];
        }
        else
        {
            [Globals.i sound_fx_on];
        }
    }
    else if (i == 103)
    {
        row = 2;
        if ([self.ui_cells_array[0][row][@"r2"] isEqualToString:@"Enabled"])
        {
            [Globals.i music_intro_off];
        }
        else
        {
            [Globals.i music_intro_on];
        }
    }
    else if (i == 104)
    {
        row = 3;
        if ([self.ui_cells_array[0][row][@"r2"] isEqualToString:@"Enabled"])
        {
            [Globals.i music_bg_off];
        }
        else
        {
            [Globals.i music_bg_on];
        }
    }
    else if (i == 105)
    {
        row = 4;
        if ([self.ui_cells_array[0][row][@"r2"] isEqualToString:@"Enabled"])
        {
            [Globals.i quest_reminder_off];
        }
        else
        {
            [Globals.i quest_reminder_on];
        }
    }
    
    [self updateView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
