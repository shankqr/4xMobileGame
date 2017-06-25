//
//  DialogBoxView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 11/19/09.
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

#import "DialogBoxView.h"
#import "UIManager.h"
#import "DynamicCell.h"
#import "CellView.h"
#import "RowView.h"

@interface DialogBoxView ()

@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UITableViewCell *inputCell;

@property (nonatomic, assign) NSInteger verticalOffset;
@property (nonatomic, assign) NSInteger keyboardType;

@end

@implementation DialogBoxView

- (void)updateView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delaysContentTouches = NO;
    for (id obj in self.tableView.subviews)
    {
        if ([obj respondsToSelector:@selector(setDelaysContentTouches:)])
        {
            [obj setDelaysContentTouches:NO];
        }
    }
    
    //NSLog(@"DialogType: %ld",(long)self.dialogType);
    
    if (self.dialogType == 0)
    {
        [self setup0];
    }
    else if (self.dialogType == 1)
    {
        [self setup1];
    }
    else if (self.dialogType == 2)
    {
        [self setup2];
    }
    else if ((self.dialogType == 4) || (self.dialogType == 5) || (self.dialogType == 6))
    {
        [self setupInput];
    }
    
    [self.tableView reloadData];
    [self notificationRegister];
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PressOkOnDialogBoxView"
                                               object:nil];
}

- (void)setup0 //NO BUTTONS! Used for dead ends or force waitings
{
    NSDictionary *row101 = @{@"nofooter": @"1", @"r1": @" ", @"r1_align": @"1"};
    NSDictionary *row102 = @{@"nofooter": @"1", @"r1": self.displayText, @"r1_align": @"1"};
    NSArray *rows1 = @[row101, row102];
    self.rows = [@[rows1] mutableCopy];
    
    NSDictionary *row201 = @{@"nofooter": @"1", @"r1": @" "};
    NSArray *rows2 = @[row201];
    [self.rows addObject:rows2];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"PressOkOnDialogBoxView"])
    {
        //NSLog(@"PressOkOnDialogBoxView self.dialogType :%ld",(long)self.dialogType);
        NSIndexPath* indexPath= [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

        DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
        
        //NSLog(@"DynamicCell : %@ ",customCellView);
        //NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_c.btn);
        
        [customCellView.cellview.rv_c.btn sendActionsForControlEvents:UIControlEventTouchUpInside];    }
}

- (void)setup1 //OK
{
    NSDictionary *row101 = @{@"nofooter": @"1", @"r1": @" ", @"r1_align": @"1"};
    NSDictionary *row102 = @{@"nofooter": @"1", @"r1": self.displayText, @"r1_align": @"1"};
    NSArray *rows1 = @[row101, row102];
    self.rows = [@[rows1] mutableCopy];
    
    NSDictionary *row201 = @{@"nofooter": @"1", @"r1": NSLocalizedString(@"OK", nil), @"r1_button": @"2"};
    NSArray *rows2 = @[row201];
    [self.rows addObject:rows2];
}

- (void)setup2 //YES NO
{
    NSDictionary *row101 = @{@"nofooter": @"1", @"r1": @" ", @"r1_align": @"1"};
    NSDictionary *row102 = @{@"nofooter": @"1", @"r1": self.displayText, @"r1_align": @"1"};
    NSArray *rows1 = @[row101, row102];
    self.rows = [@[rows1] mutableCopy];
    
    NSDictionary *row201 = @{@"nofooter": @"1", @"r1": NSLocalizedString(@"YES", nil), @"r1_button": @"2", @"c1": @"NO", @"c1_button": @"2",};
    NSArray *rows2 = @[row201];
    [self.rows addObject:rows2];
}

- (void)setupInput
{
    NSDictionary *row101 = @{@"nofooter": @"1", @"r1": @" ", @"r1_align": @"1"};
    NSDictionary *row102 = @{@"nofooter": @"1", @"r1": self.displayText};
    NSDictionary *row103 = @{@"nofooter": @"1", @"t1": @" ", @"t1_keyboard": [@(self.dialogType) stringValue]};
    NSArray *rows1 = @[row101, row102, row103];
    
    NSDictionary *row201 = @{@"nofooter": @"1", @"r1": NSLocalizedString(@"OK", nil), @"r1_button": @"2", @"c1": NSLocalizedString(@"CANCEL", nil), @"c1_button": @"2",};
    NSArray *rows2 = @[row201];
    
    self.rows = [@[rows1, rows2] mutableCopy];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 201)
    {
        [self done];
    }
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 201)
    {
        [UIManager.i closeTemplate];
        
        if (self.dialogBlock != nil)
        {
            self.dialogBlock(2, @"");
        }
    }
}

- (void)done
{
    if ((self.dialogType == 4) || (self.dialogType == 5) || (self.dialogType == 6))
    {
        self.inputCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITextField *inputText = (UITextField *)[self.inputCell viewWithTag:6];
        
        if([inputText.text length] > 0)
        {
            [inputText resignFirstResponder];
            
            [UIManager.i closeTemplate];
            
            if (self.dialogBlock != nil)
            {
                self.dialogBlock(1, inputText.text);
            }
        }
    }
    else
    {
        [UIManager.i closeTemplate];
        
        if (self.dialogBlock != nil)
        {
            self.dialogBlock(1, @"");
        }
    }
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = (self.rows)[indexPath.section][indexPath.row];
    
    return rowData;
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:DIALOG_CELL_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:DIALOG_CELL_WIDTH];
}

@end
