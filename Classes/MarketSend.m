//
//  MarketSend.m
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

#import "MarketSend.h"
#import "Globals.h"

@interface MarketSend ()

@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) NSString *to_base_id;
@property (nonatomic, assign) NSInteger from_base_x;
@property (nonatomic, assign) NSInteger from_base_y;
@property (nonatomic, assign) NSInteger to_base_x;
@property (nonatomic, assign) NSInteger to_base_y;
@property (nonatomic, assign) NSInteger travel_distance;
@property (nonatomic, assign) double march_time;
@property (nonatomic, assign) NSInteger max_capacity;
@property (nonatomic, assign) NSInteger tax_rate;
@property (nonatomic, assign) NSUInteger sel_value;
@property (nonatomic, assign) NSInteger int_sum;
@property (nonatomic, assign) NSInteger int_taxed;
@property (nonatomic, assign) NSInteger r1;
@property (nonatomic, assign) NSInteger r2;
@property (nonatomic, assign) NSInteger r3;
@property (nonatomic, assign) NSInteger r4;
@property (nonatomic, assign) NSInteger r5;

@end

@implementation MarketSend

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.building_id = @"12";
    
    self.sel_value = 0;
    self.int_sum = 0;
    self.int_taxed = 0;
    self.travel_distance = 0;
    self.march_time = 0;
    self.from_base_x = 0;
    self.from_base_y = 0;
    self.to_base_x = 0;
    self.to_base_y = 0;
    self.r1 = 0;
    self.r2 = 0;
    self.r3 = 0;
    self.r4 = 0;
    self.r5 = 0;
    
    if (self.base_r1  < 0)
    {
        self.base_r1 = 0;
    }
    
    if (self.base_r2 < 0)
    {
        self.base_r2 = 0;
    }
    
    if (self.base_r3 < 0)
    {
        self.base_r3 = 0;
    }
    
    if (self.base_r4 < 0)
    {
        self.base_r4 = 0;
    }
    
    if (self.base_r5 < 0)
    {
        self.base_r5 = 0;
    }
    
    NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:self.building_id level:self.level];
    self.tax_rate = [buildingLevelDict[@"production"] integerValue];
    self.max_capacity = [buildingLevelDict[@"capacity"] integerValue];
    
    self.from_base_x = [Globals.i.wsBaseDict[@"map_x"] integerValue];
    self.from_base_y = [Globals.i.wsBaseDict[@"map_y"] integerValue];
    
    self.to_base_id = self.row_target[@"b_id"];
    
    if ([self.row_target[@"b_id"] isEqualToString:@"0"])
    {
        [self getBaseMain:self.row_target[@"p_id"]];
    }
    else
    {
        self.to_base_x = [self.row_target[@"b_x"] integerValue];
        self.to_base_y = [self.row_target[@"b_y"] integerValue];
        
        self.travel_distance = [Globals.i distance2xy:self.from_base_x :self.from_base_y :self.to_base_x :self.to_base_y];
        
        [self redrawView];
    }
}

- (void)getBaseMain:(NSString *)profile_id
{
    [Globals.i getBaseMain:profile_id :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 if (returnArray.count > 0)
                 {
                     NSDictionary *mainBaseDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                     
                     self.to_base_id = mainBaseDict[@"base_id"];
                     self.to_base_x = [mainBaseDict[@"map_x"] integerValue];
                     self.to_base_y = [mainBaseDict[@"map_y"] integerValue];
                     
                     self.travel_distance = [Globals.i distance2xy:self.from_base_x :self.from_base_y :self.to_base_x :self.to_base_y];
                     
                     [self redrawView];
                 }
                 else //A message when no main base is present
                 {
                     NSDictionary *row0 = @{@"r1": @" ", @"nofooter": @"1"};
                     NSDictionary *row1 = @{@"r1": NSLocalizedString(@"This alliance member is no longer active, unable to conduct trade!", nil), @"r1_align": @"1", @"r1_color": @"1", @"nofooter": @"1"};
                     NSArray *rows1 = @[row0, row1];
                     
                     self.ui_cells_array = [@[rows1] mutableCopy];
                     
                     [self.tableView reloadData];
                 }
             }
         });
     }];
}

- (void)redrawView
{
    NSString *str_tax = [Globals.i intString:self.tax_rate];
    NSString *str_capacity = [Globals.i intString:self.max_capacity];
    
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    if ([self.row_target[@"b_id"] isEqualToString:@"0"])
    {
        NSDictionary *row101 = @{@"r2": [NSString stringWithFormat:NSLocalizedString(@"Capital City (%@,%@)", nil), [@(self.to_base_x) stringValue], [@(self.to_base_y) stringValue]], @"nofooter": @"1"};
        NSMutableDictionary *temp_target = [[NSMutableDictionary alloc] initWithDictionary:self.row_target copyItems:YES];
        [temp_target addEntriesFromDictionary:row101];
        
        [rows1 addObject:temp_target];
    }
    else
    {
        [rows1 addObject:self.row_target];
    }
    
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Transfer", nil), @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    [rows1 addObject:row102];
    
    NSMutableDictionary *row202 = [@{@"r1": Globals.i.r1, @"r2_slider": @"0", @"s1": @(self.r1), @"slider_max": @(self.base_r1), @"i1": @"icon_r1"} mutableCopy];
    [rows1 addObject:row202];
    
    NSMutableDictionary *row203 = [@{@"r1": Globals.i.r2, @"r2_slider": @"0", @"s1": @(self.r2), @"slider_max": @(self.base_r2), @"i1": @"icon_r2"} mutableCopy];
    [rows1 addObject:row203];
    
    NSMutableDictionary *row204 = [@{@"r1": Globals.i.r3, @"r2_slider": @"0", @"s1": @(self.r3), @"slider_max": @(self.base_r3), @"i1": @"icon_r3"} mutableCopy];
    [rows1 addObject:row204];
    
    NSMutableDictionary *row205 = [@{@"r1": Globals.i.r4, @"r2_slider": @"0", @"s1": @(self.r4), @"slider_max": @(self.base_r4), @"i1": @"icon_r4"} mutableCopy];
    [rows1 addObject:row205];
    
    NSMutableDictionary *row206 = [@{@"r1": Globals.i.r5, @"r2_slider": @"0", @"s1": @(self.r5), @"slider_max": @(self.base_r5), @"i1": @"icon_r5"} mutableCopy];
    [rows1 addObject:row206];
    
    self.int_sum = self.r1 + self.r2 + self.r3 + self.r4 + self.r5;
    self.int_taxed = (double)self.int_sum*(double)self.tax_rate/100;
    
    NSString *btn_send = @"2";
    NSString *c1_color = @"2";
    
    if (self.int_sum == 0)
    {
        btn_send = @"1";
    }
    else if (self.int_sum > self.max_capacity)
    {
        btn_send = @"1";
        c1_color = @"1";
    }
    
    NSDictionary *row104 = @{@"r1": NSLocalizedString(@"Capacity", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Tax %@%%", nil), str_tax], @"c1": [NSString stringWithFormat:@"%@/%@", [Globals.i intString:self.int_sum], str_capacity], @"c2": [NSString stringWithFormat:@"- %@", [Globals.i intString:self.int_taxed]], @"c1_bkg": @"bkg3", @"c1_color": c1_color, @"c2_color": @"1", @"c1_align": @"1", @"c2_bkg": @"bkg3", @"c2_align": @"1", @"c1_ratio": @"1.5", @"i1": @"icon_trade", @"nofooter": @"1"};
    [rows1 addObject:row104];
    
    NSDictionary *row105 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Distance: %@ Miles", nil), [@(self.travel_distance) stringValue]], @"r1_align": @"1", @"nofooter": @"1"};
    [rows1 addObject:row105];
    
    self.march_time = self.travel_distance * 10;

    float boost_t = ([Globals.i.wsBaseDict[@"boost_trade"] floatValue] / 100.0f) + 1.0f;
    self.march_time = (float)self.march_time / boost_t;
    
    NSString *str_time = [Globals.i getCountdownString:self.march_time];
    NSString *str_boost = [NSString stringWithFormat:NSLocalizedString(@"%@     Boost:+%@%%", nil), str_time, Globals.i.wsBaseDict[@"boost_trade"]];

    NSDictionary *row106 = @{@"r1": NSLocalizedString(@"Send Now", nil), @"r1_button": btn_send, @"r2": str_boost, @"r2_icon": @"icon_clock", @"r2_bkg": @"bkg3", @"nofooter": @"1"};
    [rows1 addObject:row106];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)slider1_change:(UISlider *)sender
{
    self.sel_value = ((DCFineTuneSlider *)sender).selectedValue;
    
    NSInteger row1 = sender.tag-102;
    
    if (row1 == 1)
    {
        self.r1 = self.sel_value;
    }
    else if (row1 == 2)
    {
        self.r2 = self.sel_value;
    }
    else if (row1 == 3)
    {
        self.r3 = self.sel_value;
    }
    else if (row1 == 4)
    {
        self.r4 = self.sel_value;
    }
    else if (row1 == 5)
    {
        self.r5 = self.sel_value;
    }
    
    [self redrawView];
}

- (void)sendResources
{
    NSInteger int_march_time = lround(self.march_time);
    
    NSString *service_name = @"SendResources";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@/%@",
                       Globals.i.world_url,
                       service_name,
                       Globals.i.wsWorldProfileDict[@"uid"],
                       Globals.i.wsBaseDict[@"base_id"],
                       self.row_target[@"p_id"],
                       self.to_base_id,
                       [@(self.r1) stringValue],
                       [@(self.r2) stringValue],
                       [@(self.r3) stringValue],
                       [@(self.r4) stringValue],
                       [@(self.r5) stringValue], [@(int_march_time) stringValue]];
    
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[[Globals.i session] dataTaskWithURL:[NSURL URLWithString:wsurl]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
        if (error || !response || !data)
        {
            [Globals.i showDialogFail];
        }
        else
        {
            [Globals.i trackEvent:service_name];
            
            //Always be prepared for return string 0 if spy fail
            NSMutableArray *returnArray = [Globals.i customParser:data];
            
            if (returnArray.count > 0)
            {
                NSMutableDictionary *return_row = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                
                NSString *profile2_x = return_row[@"profile2_x"];
                NSString *profile2_y = return_row[@"profile2_y"];
                
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     NSString *tv_title = [NSString stringWithFormat:NSLocalizedString(@"Trade to (%@,%@)", nil), profile2_x, profile2_y];
                     [Globals.i setTimerViewTitle:TV_TRADE :tv_title];
                     
                     [Globals.i setupTradeQueue:[Globals.i updateTime]];
                     
                     NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                     [userInfo setObject:Globals.i.wsBaseDict[@"base_id"] forKey:@"base_id"];
                     [userInfo setObject:@(TV_TRADE) forKey:@"tv_id"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMarketView"
                                                                         object:self
                                                                       userInfo:userInfo];
                     
                     [UIManager.i showToast:NSLocalizedString(@"The transfer has begun!", nil)
                              optionalTitle:@"TroopTransferBegan"
                              optionalImage:@"icon_check"];
                     
                     NSMutableDictionary *userInfo1 = [NSMutableDictionary dictionary];
                     [userInfo1 setObject:[@(TV_TRADE) stringValue] forKey:@"tv_id"];
                     [userInfo1 setObject:profile2_x forKey:@"to_x"];
                     [userInfo1 setObject:profile2_y forKey:@"to_y"];
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawMarchingLine"
                                                                         object:self
                                                                       userInfo:userInfo1];
                     
                     if ([self.exit_to_map isEqualToString:@"1"])
                     {
                         [UIManager.i closeTemplate];
                     }
                     else
                     {
                         [UIManager.i closeAllTemplate];
                     }
                 }];
                
            }
            else //return is a string
            {
                [Globals.i getRegions:^(BOOL success, NSData *data) {}];
                [UIManager.i showDialog:NSLocalizedString(@"Resource sending failed. Please try again.", nil) title:@"ResourceSendFailed"];
            }
        }
    });
    }] resume];
    
}

- (void)button1_tap:(id)sender //Send
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSInteger r1_button = [[self.ui_cells_array[section][row] objectForKey:@"r1_button"] integerValue];
    
    if (r1_button > 1)
    {
        [self sendResources];
    }
}

- (void)img1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSString *selected_profile_id = self.ui_cells_array[section][row][@"p_id"];
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
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [(UISlider *)dcell.cellview.rv_a.slider addTarget:self action:@selector(slider1_change:) forControlEvents:UIControlEventValueChanged];
    ((UISlider *)dcell.cellview.rv_a.slider).tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
