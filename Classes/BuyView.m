//
//  BuyView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 1/15/12.
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

#import "BuyView.h"
#import "Globals.h"

@interface BuyView ()

@end

@implementation BuyView

- (void)updateView
{
    NSDictionary *row0 = @{@"h1": NSLocalizedString(@"Diamonds for Sale!", nil)};
    NSDictionary *row1 = @{@"1": @"fund1", @"2": @"fund1", @"3": @"6145148", @"4": @"750", @"r1": @"750 Diamonds", @"r2": @"USD $4.99", @"i1": @"icon_currency2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get", nil), @"c1_button": @"2"};
    NSDictionary *row2 = @{@"1": @"fund2", @"2": @"fund2", @"3": @"9425144", @"4": @"1500", @"r1": @"1500 Diamonds", @"r2": @"USD $9.99", @"i1": @"icon_currency2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get", nil), @"c1_button": @"2"};
    NSDictionary *row3 = @{@"1": @"fund3", @"2": @"fund3", @"3": @"1736703", @"4": @"3000", @"r1": @"3000 Diamonds", @"r2": @"USD $19.99", @"i1": @"icon_currency2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get", nil), @"c1_button": @"2"};
    NSDictionary *row4 = @{@"1": @"fund4", @"2": @"fund4", @"3": @"6597164", @"4": @"8650", @"r1": @"7500 Diamonds", @"r2": @"USD $49.99 (+1150 FREE)", @"b1": @"(Most Popular!)", @"i1": @"icon_currency2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get", nil), @"c1_button": @"2"};
    NSDictionary *row5 = @{@"1": @"fund5", @"2": @"fund5", @"3": @"2792559", @"4": @"18000", @"r1": @"15000 Diamonds", @"r2": @"USD $99.99 (+3000 FREE)", @"b1": @"(Best Value!)", @"i1": @"icon_currency2", @"c1_ratio": @"3", @"c1": NSLocalizedString(@"Get", nil), @"c1_button": @"2"};
    
    NSArray *rows1 = @[row0, row1, row2, row3, row4, row5];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)button1_tap:(id)sender
{
    [Globals.i play_gold];
    
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"c1_button"] integerValue];
    
    if (button > 1)
    {
        NSDictionary *rowData = (self.ui_cells_array)[section][row];
        [Globals.i settPurchasedProduct:rowData[@"3"]];
        [Globals.i settPurchasedGems:rowData[@"4"]];
        NSString *pi = Globals.i.wsIdentifierDict[rowData[@"1"]]; //refer to server, db kingdom, table indentifier
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:pi forKey:@"pi"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
