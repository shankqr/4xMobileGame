//
//  XyBox.m
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

#import "XyBox.h"
#import "Globals.h"

@interface XyBox ()

@property (nonatomic, strong) UITableViewCell *inputCell1;
@property (nonatomic, strong) UITableViewCell *inputCell2;
@property (nonatomic, strong) UITextField *xText;
@property (nonatomic, strong) UITextField *yText;

@end

@implementation XyBox

- (void)updateView
{
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Search", nil), @"r1_color": @"0", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"X Coordinate:", nil), @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row103 = @{@"t1": NSLocalizedString(@"Enter X here...", nil), @"t1_keyboard": @"5", @"nofooter": @"1"};
    NSDictionary *row104 = @{@"r1": NSLocalizedString(@"Y Coordinate:", nil), @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row105 = @{@"t1": NSLocalizedString(@"Enter Y here...", nil), @"t1_keyboard": @"5", @"nofooter": @"1"};
    NSArray *rows1 = @[row101, row102, row103, row104, row105];
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Go To", nil), @"r1_button": @"2", @"nofooter": @"1"};
    NSArray *rows2 = @[row201];
    
    self.ui_cells_array = [@[rows1, rows2] mutableCopy];
    
	[self.tableView reloadData];
}

- (void)gotoMap
{
    self.inputCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    self.xText = (UITextField *)[self.inputCell1 viewWithTag:6];
    NSString *str_x = self.xText.text;
    
    self.inputCell2 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    self.yText = (UITextField *)[self.inputCell2 viewWithTag:6];
    NSString *str_y = self.yText.text;
    
    if ([self isStringNumeric:str_x] && [self isStringNumeric:str_y])
    {
        [UIManager.i closeTemplate];
        
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:str_x forKey:@"x"];
        [userInfo setObject:str_y forKey:@"y"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoTile"
                                                            object:self
                                                          userInfo:userInfo];
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"Only numbers for coordinates please!", nil) title:@"NumbersForCoordinates"];
    }
}

- (BOOL)isStringNumeric:(NSString *)text
{
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    return [alphaNums isSupersetOfSet:inStringSet];
}

- (void)button1_tap:(id)sender
{
    [Globals.i play_button];
    
    NSInteger i = [sender tag];
    
    if (i == 201)
    {
        [self gotoMap];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:DIALOG_CELL_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
