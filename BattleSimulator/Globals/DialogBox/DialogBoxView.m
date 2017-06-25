//
//  DialogBoxView.m
//  Battle Simulator
//
//  Created by Shankar on 11/19/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "DialogBoxView.h"
#import "Globals.h"

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
    
    if (self.dialogType == 1)
    {
        [self setup1];
    }
    
    if (self.dialogType == 2)
    {
        [self setup2];
    }
    
    if ((self.dialogType == 4) || (self.dialogType == 5) || (self.dialogType == 6))
    {
        [self setupInput];
    }
    
    [self.tableView reloadData];
}

- (void)setup1 //OK
{
    NSDictionary *row101 = @{@"nofooter": @"1", @"r1": @" ", @"r1_align": @"1"};
    NSDictionary *row102 = @{@"nofooter": @"1", @"r1": self.displayText, @"r1_align": @"1"};
    NSArray *rows1 = @[row101, row102];
    self.rows = [@[rows1] mutableCopy];
    
    NSDictionary *row201 = @{@"nofooter": @"1", @"r1": @"OK", @"r1_button": @"3"};
    NSArray *rows2 = @[row201];
    [self.rows addObject:rows2];
}

- (void)setup2 //YES NO
{
    NSDictionary *row101 = @{@"nofooter": @"1", @"r1": @" ", @"r1_align": @"1"};
    NSDictionary *row102 = @{@"nofooter": @"1", @"r1": self.displayText, @"r1_align": @"1"};
    NSArray *rows1 = @[row101, row102];
    self.rows = [@[rows1] mutableCopy];
    
    NSDictionary *row201 = @{@"nofooter": @"1", @"r1": @"YES", @"r1_button": @"3", @"c1": @"NO", @"c1_button": @"2",};
    NSArray *rows2 = @[row201];
    [self.rows addObject:rows2];
}

- (void)setupInput
{
    NSDictionary *row101 = @{@"nofooter": @"1", @"r1": @" ", @"r1_align": @"1"};
    NSDictionary *row102 = @{@"nofooter": @"1", @"r1": self.displayText};
    NSDictionary *row103 = @{@"nofooter": @"1", @"t1": @" ", @"t1_keyboard": [@(self.dialogType) stringValue]};
    NSArray *rows1 = @[row101, row102, row103];
    
    NSDictionary *row201 = @{@"nofooter": @"1", @"r1": @"OK", @"r1_button": @"3", @"c1": @"CANCEL", @"c1_button": @"2",};
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
        [[Globals i] closeTemplate];
        
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
            
            [[Globals i] closeTemplate];
            
            if (self.dialogBlock != nil)
            {
                self.dialogBlock(1, inputText.text);
            }
        }
    }
    else
    {
        [[Globals i] closeTemplate];
        
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
