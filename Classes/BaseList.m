//
//  BaseList.m
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

#import "BaseList.h"
#import "Globals.h"

@interface BaseList ()

@property (nonatomic, strong) NSArray *baseArray;
@property (nonatomic, strong) NSTimer *gameTimer;

@end

@implementation BaseList

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    [self notificationRegister];
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChooseBase"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ProtectBase"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateBaseList"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"ChooseBase"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo!=nil)
        {
            NSNumber *base_index = [userInfo objectForKey:@"base_index"];
            //NSLog(@"section :%lu",(unsigned long)[self.ui_cells_array count]);
            //NSLog(@"rows section 1 :%lu",(unsigned long)[self.ui_cells_array[1] count]);
            
            //NSLog(@"base_index : %@",base_index);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[base_index intValue] inSection:1];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            //NSLog(@"customCellView BaseList : %@",customCellView);
            
            //NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_c.btn);

            [customCellView.cellview.rv_c.btn sendActionsForControlEvents:UIControlEventTouchUpInside];

        }
    }
    else if ([[notification name] isEqualToString:@"ProtectBase"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo!=nil)
        {
            NSNumber *base_index = [userInfo objectForKey:@"base_index"];
            //NSLog(@"section :%lu",(unsigned long)[self.ui_cells_array count]);
            //NSLog(@"rows section 1 :%lu",(unsigned long)[self.ui_cells_array[1] count]);
            
            //NSLog(@"base_index : %@",base_index);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[base_index intValue] inSection:1];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            //NSLog(@"customCellView BaseList : %@",customCellView);
            
            //NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_c.btn);
            
            [customCellView.cellview.rv_g.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            
        }
    }
    else if ([[notification name] isEqualToString:@"UpdateBaseList"])
    {
        NSLog(@"UpdateBaseList");
        [self updateView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    NSLog(@"updateView");
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSString *service_name = @"GetBaseAll";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsWorldProfileDict[@"profile_id"]];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSLog(@"GetBaseAll!");
             
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 Globals.i.wsBaseArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
             }
             else
             {
                 NSLog(@"WARNING: GetBaseAll return empty array!");
                 Globals.i.wsBaseArray = [[NSMutableArray alloc] init];
             }
             
             self.baseArray = Globals.i.wsBaseArray;
             
             NSDictionary *row0 = @{@"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1": NSLocalizedString(@"Capital city can be raided but can't be captured by your enemies!", nil)};
             NSArray *rows1 = @[row0];
             
             self.ui_cells_array = [@[rows1] mutableCopy];
             
             [self.ui_cells_array addObject:self.baseArray];
             
             [self.tableView reloadData];
             [self.tableView flashScrollIndicators];
         }
     }];
    
    if (!self.gameTimer.isValid)
    {
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)updateViewRefresh
{
    for (int index = 0; index < [self.ui_cells_array[1] count]; index++)
    {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }

}

- (void)onTimer
{
    if ((self.ui_cells_array != nil) && ([[UIManager.i currentViewTitle] isEqualToString:self.title]))
    {
        [self updateViewRefresh];
    }
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = (self.ui_cells_array)[indexPath.section][indexPath.row];
    
    if (indexPath.section == 1)
    {
        NSDictionary *row1 = self.baseArray[indexPath.row];
        
        NSString *r1 = [NSString stringWithFormat:@"%@ (%@,%@)", row1[@"base_name"], row1[@"map_x"], row1[@"map_y"]];
        
        NSString *c1;
        NSString *c1_button;
        NSString *d1;
        NSString *d1_button;
        NSString *g1;
        NSString *g1_button;
        NSString *r3 = @" ";
        
        if ([Globals.i.wsBaseDict[@"base_id"] isEqualToString:row1[@"base_id"]])
        {
            c1 = NSLocalizedString(@"View", nil);
            c1_button = @"1";
            d1 = NSLocalizedString(@"Reinforce", nil);
            d1_button = @"1";
            r3 = NSLocalizedString(@"You are here.", nil);
        }
        else
        {
            c1 = NSLocalizedString(@"View", nil);
            c1_button = @"2";
            d1 = NSLocalizedString(@"Reinforce", nil);
            d1_button = @"2";
        }
        
        NSString *r2;
        NSString *i1_over;
        NSString *i1;
        
        if ([row1[@"base_type"] isEqualToString:@"1"])
        {
            r2 = NSLocalizedString(@"Capital City", nil);
            i1_over = @"icon_capital_over";
            
            NSInteger b_lvl = [row1[@"building_level"] integerValue];
            if (b_lvl < 10)
            {
                i1 = @"t81";
            }
            else if (b_lvl < 17)
            {
                i1 = @"t82";
            }
            else
            {
                i1 = @"t83";
            }
        }
        else
        {
            r2 = NSLocalizedString(@"Village City", nil);
            i1_over = @"";
            
            NSInteger b_lvl = [row1[@"building_level"] integerValue];
            if (b_lvl < 10)
            {
                i1 = @"t71";
            }
            else if (b_lvl < 17)
            {
                i1 = @"t72";
            }
            else
            {
                i1 = @"t73";
            }
        }
        
        //NSLog(@"base %ld , under_protection :%ld",[row1[@"base_id"] integerValue],[row1[@"under_protection"] integerValue]);
        //NSLog(@"base %ld , under_protection :%@",[row1[@"base_id"] integerValue],row1[@"protection_ending"]);
        
        if ([row1[@"under_protection"] integerValue]==1)
        {
            g1 = NSLocalizedString(@"Protect", nil);
            g1_button = @"1";
            
            NSString *strDate = row1[@"protection_ending"];
            
            NSDate *queueDate = [Globals.i dateParser:strDate];
            NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
            CGFloat protection_time_left = queueTime - [Globals.i updateTime];
            CGFloat protection_time = [row1[@"protection_time"] floatValue];
            CGFloat protection_time_left_percentage=0;
            if(protection_time>0)
            {
                protection_time_left_percentage = protection_time_left/protection_time;
            }
            NSString *protection_string = [NSString stringWithFormat:NSLocalizedString(@"Protection for: %@", nil), [Globals.i getCountdownString:protection_time_left]];
            
            //NSLog(@"protection_time_left_percentage : %f",protection_time_left_percentage);
            //NSLog(@"protection_string : %@",protection_string);
            
            rowData = @{@"r1": r1, @"r2": r2, @"b1": r3, @"n1_width": @"60", @"i1": i1, @"i1_aspect": @"1", @"i1_over": i1_over, @"c1_ratio": @"2.5", @"c1": c1, @"c1_button": c1_button, @"d1": d1, @"d1_button": d1_button,@"p1": @(protection_time_left_percentage), @"p1_text": protection_string, @"p1_width_p": @"0.4",@"p1_x_p":@"1",@"p1_y":@"-0.5", @"i1":@"icon_capture",@"g1_ratio": @"1.5",@"g1": g1, @"g1_button": g1_button };
        }
        else
        {
            g1 = NSLocalizedString(@"Protect", nil);
            g1_button = @"2";
            
            rowData = @{@"r1": r1, @"r2": r2, @"b1": r3, @"n1_width": @"60", @"i1": i1, @"i1_aspect": @"1", @"i1_over": i1_over, @"c1_ratio": @"2.5", @"c1": c1, @"c1_button": c1_button, @"d1": d1, @"d1_button": d1_button,@"i1":@"icon_capture",@"g1_ratio": @"1.5",@"g1": g1, @"g1_button": g1_button };
        }
        
    }
    
    return rowData;
}

- (void)button1_tap:(id)sender //View City
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;

    NSDictionary *rowData = self.ui_cells_array[section][row];
    NSString *base_id = rowData[@"base_id"];
    
    if (![Globals.i.wsBaseDict[@"base_id"] isEqualToString:base_id])
    {
        [Globals.i settSelectedBaseId:base_id];
        [Globals.i updateBaseDict:^(BOOL success, NSData *data)
         {
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"BaseChanged"
              object:self];
             
             [UIManager.i closeTemplate];
         }];
    }
    else
    {
        [UIManager.i closeTemplate];
    }
}

- (void)button2_tap:(id)sender //Transfer
{
    NSInteger i = [sender tag];
    NSInteger row = (i % 100) - 1;
    
    [Globals.i doTransferTroops:self.baseArray[row]];
}

- (void)button3_tap:(id)sender //Protect
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSDictionary *rowData = self.ui_cells_array[section][row];
    NSString *base_id = rowData[@"base_id"];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"special" forKey:@"item_category1"];
    [userInfo setObject:@"protection" forKey:@"item_category2"];
    [userInfo setObject:base_id forKey:@"base_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_d.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_d.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_g.btn addTarget:self action:@selector(button3_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_g.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
