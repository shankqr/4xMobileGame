//
//  DialogCity
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

#import "DialogCity.h"
#import "Globals.h"

@interface DialogCity ()

@property (nonatomic, assign) BOOL i_am_village;
@property (nonatomic, assign) BOOL city_main;
@property (nonatomic, assign) BOOL city_village;
@property (nonatomic, assign) BOOL city_alliance_member;
@property (nonatomic, assign) BOOL city_alliance_village;
@property (nonatomic, assign) BOOL city_enemy;
@property (nonatomic, assign) BOOL city_enemy_village;
@property (nonatomic, strong) NSTimer *gameTimer;

@end

@implementation DialogCity

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
        if ([UIManager.i.currentViewTitle isEqualToString:self.title])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [UIManager.i closeTemplate];
        }
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.i_am_village = NO;
    self.city_main = NO;
    self.city_village = NO;
    self.city_alliance_member = NO;
    self.city_alliance_village = NO;
    self.city_enemy = NO;
    self.city_enemy_village = NO;
    
    
    if ([Globals.i.wsBaseDict[@"base_type"] isEqualToString:@"1"])
    {
        self.i_am_village = NO;
    }
    else
    {
        self.i_am_village = YES;
    }
    
    if ([Globals.i.wsWorldProfileDict[@"profile_id"] isEqualToString:self.city_dict[@"profile_id"]])
    {
        if ([Globals.i.wsBaseDict[@"base_id"] isEqualToString:self.city_dict[@"base_id"]])
        {
            self.city_main = YES;
        }
        else
        {
            self.city_village = YES;
        }
    }
    else if ([self.city_dict[@"alliance_id"] isEqualToString:@"0"])
    {
        if ([self.city_dict[@"base_type"] isEqualToString:@"1"])
        {
            self.city_enemy = YES;
        }
        else
        {
            self.city_enemy_village = YES;
        }
    }
    else if ([Globals.i.wsWorldProfileDict[@"alliance_id"] isEqualToString:self.city_dict[@"alliance_id"]])
    {
        if ([self.city_dict[@"base_type"] isEqualToString:@"1"])
        {
            self.city_alliance_member = YES;
        }
        else
        {
            self.city_alliance_village = YES;
        }
    }
    else
    {
        if ([self.city_dict[@"base_type"] isEqualToString:@"1"])
        {
            self.city_enemy = YES;
        }
        else
        {
            self.city_enemy_village = YES;
        }
    }
    
    NSString *strAllianceTag = @"";
    if (![self.city_dict[@"alliance_tag"] isEqualToString:@""])
    {
        strAllianceTag = [NSString stringWithFormat:@"(%@)", self.city_dict[@"alliance_tag"]];
    }
    
    NSString *strAllianceRank = @"";
    if (![self.city_dict[@"alliance_rank"] isEqualToString:@""] && ![self.city_dict[@"alliance_rank"] isEqualToString:@"0"])
    {
        strAllianceRank = [NSString stringWithFormat:@"rank_%@", self.city_dict[@"alliance_rank"]];
    }
    
    NSString *strOwner = NSLocalizedString(@"Unknown", nil);
    if (![self.city_dict[@"profile_name"] isEqualToString:@""])
    {
        strOwner = [NSString stringWithFormat:@"%@%@", strAllianceTag, self.city_dict[@"profile_name"]];
    }
    
    NSString *strOwnerPic = @"";
    if (![self.city_dict[@"profile_face"] isEqualToString:@""] && ![self.city_dict[@"profile_face"] isEqualToString:@"0"])
    {
        strOwnerPic = [NSString stringWithFormat:@"face_%@", self.city_dict[@"profile_face"]];
    }
    
    NSString *strPower = NSLocalizedString(@"Power:0", nil);
    if (![self.city_dict[@"xp"] isEqualToString:@""])
    {
        strPower = [NSString stringWithFormat:NSLocalizedString(@"Power:%@", nil), [Globals.i numberFormat:self.city_dict[@"xp"]]];
    }
    
    NSString *strKills = NSLocalizedString(@"Kills:0", nil);
    if (![self.city_dict[@"kills"] isEqualToString:@""])
    {
        strKills = [NSString stringWithFormat:NSLocalizedString(@"Kills:%@", nil), [Globals.i numberFormat:self.city_dict[@"kills"]]];
    }
    
    NSString *strAlliance = NSLocalizedString(@"Alliance: None", nil);
    if (![self.city_dict[@"alliance_name"] isEqualToString:@""])
    {
        strAlliance = [NSString stringWithFormat:NSLocalizedString(@"Alliance: %@%@", nil), strAllianceTag, self.city_dict[@"alliance_name"]];
    }
    
    NSString *strAllianceLogo = @"";
    if (![self.city_dict[@"alliance_logo"] isEqualToString:@""] && ![self.city_dict[@"alliance_logo"] isEqualToString:@"0"])
    {
        strAllianceLogo = [NSString stringWithFormat:@"a_logo_%@", self.city_dict[@"alliance_logo"]];
    }
    
    NSString *strCoordinates = [NSString stringWithFormat:NSLocalizedString(@"Coordinates: X:%@ Y:%@", nil), @(self.map_x), @(self.map_y)];
    
    NSDictionary *row101 = @{@"r1": self.title, @"r1_color": @"0", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"i1": strOwnerPic, @"i1_h": @" ", @"i1_aspect": @"1", @"r1_icon": strAllianceRank, @"r1": strOwner, @"r2_icon": @"icon_power", @"r2": strPower, @"b1_icon": @"icon_kills", @"b1": strKills, @"n1_width": @"60", @"nofooter": @"1"};
    NSDictionary *row103 = @{@"r1_icon": strAllianceLogo, @"r1": strAlliance, @"r1_align": @"1", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row104 = @{@"r1": strCoordinates, @"r1_align": @"1", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row105 = @{@"r1": @" ", @"nofooter": @"1", @"fit": @"1"};
    NSArray *rows1 = @[row101, row102, row103, row104, row105];
    
    NSMutableArray *rows2 = [[NSMutableArray alloc] init];
    
    if (self.city_main)
    {
        NSDictionary *row201 = @{@"r1_icon": @"icon_building", @"r1": NSLocalizedString(@"Enter City", nil), @"r1_button": @"2", @"r1_align": @"1", @"nofooter": @"1"};
        [rows2 addObject:row201];
        
        if([self.city_dict[@"under_protection"] integerValue]==1)
        {
            NSString *strDate = self.city_dict[@"protection_ending"];
            
            NSDate *queueDate = [Globals.i dateParser:strDate];
            NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
            NSInteger protection_time_left = queueTime - [Globals.i updateTime];
            NSInteger protection_time = [self.city_dict[@"protection_time"] integerValue];
            float protection_time_left_percentage=0;
            if(protection_time>0)
            {
                protection_time_left_percentage = (double)protection_time_left/(double)protection_time;
            }
            NSString *protection_string = [NSString stringWithFormat:NSLocalizedString(@"Protection for: %@", nil), [Globals.i getCountdownString:protection_time_left]];
            
            //NSLog(@"protection_time_left_percentage : %f",protection_time_left_percentage);
            //NSLog(@"protection_string : %@",protection_string);
            
            NSDictionary *row203 = @{@"i1": @"pi_peace_boost",@"i1_align":@"left",@"i1_x":@"35",@"i1_width":@"16",@"i1_height":@"16",@"p1": @(protection_time_left_percentage), @"p1_text": protection_string, @"p1_width_p": @"0.75",@"p1_y_p":@"1",@"p1_x_p":@"1", @"nofooter": @"1"};
            [rows2 addObject:row203];
        }

    }
    else if (self.city_village)
    {
        NSDictionary *row201 = @{@"r1_icon": @"icon_building", @"r1": NSLocalizedString(@"Enter City", nil), @"r1_button": @"2", @"r1_align": @"1", @"nofooter": @"1"};
        [rows2 addObject:row201];
        
        NSDictionary *row202 = @{@"r1_icon": @"icon_reinforce", @"r1": NSLocalizedString(@"Reinforce", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"icon_trade", @"c1": NSLocalizedString(@"Trade", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
        [rows2 addObject:row202];
        
        if([self.city_dict[@"under_protection"] integerValue]==1)
        {
            NSString *strDate = self.city_dict[@"protection_ending"];
            
            NSDate *queueDate = [Globals.i dateParser:strDate];
            NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
            NSInteger protection_time_left = queueTime - [Globals.i updateTime];
            NSInteger protection_time = [self.city_dict[@"protection_time"] integerValue];
            float protection_time_left_percentage=0;
            if(protection_time>0)
            {
                protection_time_left_percentage = (double)protection_time_left/(double)protection_time;
            }
            NSString *protection_string = [NSString stringWithFormat:NSLocalizedString(@"Protection for: %@", nil), [Globals.i getCountdownString:protection_time_left]];
            
            NSDictionary *row203 = @{@"i1": @"pi_peace_boost",@"i1_align":@"left",@"i1_x":@"35",@"i1_width":@"16",@"i1_height":@"16",@"p1": @(protection_time_left_percentage), @"p1_text": protection_string, @"p1_width_p": @"0.75",@"p1_y_p":@"1",@"p1_x_p":@"1", @"nofooter": @"1"};
            [rows2 addObject:row203];
        }
        
    }
    else if (self.city_alliance_member)
    {
        NSDictionary *row201 = @{@"r1_icon": @"icon_alliance_profile", @"r1": NSLocalizedString(@"Profile", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"button_bookmark", @"c1": NSLocalizedString(@"Bookmark", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
        [rows2 addObject:row201];
        
        if (self.i_am_village) //only allowed to trade
        {
            NSDictionary *row202 = @{@"r1_icon": @"icon_trade", @"r1": NSLocalizedString(@"Trade", nil), @"r1_button": @"2", @"r1_align": @"1", @"nofooter": @"1"};
            [rows2 addObject:row202];
        }
        else
        {
            NSDictionary *row202 = @{@"r1_icon": @"icon_reinforce", @"r1": NSLocalizedString(@"Reinforce", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"icon_trade", @"c1": NSLocalizedString(@"Trade", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
            [rows2 addObject:row202];
        }
    }
    else if (self.city_alliance_village)
    {
        NSDictionary *row201 = @{@"r1_icon": @"icon_alliance_profile", @"r1":NSLocalizedString(@"Profile", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"button_bookmark", @"c1": NSLocalizedString(@"Bookmark", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
        [rows2 addObject:row201];
        
        NSDictionary *row202 = @{@"r1_icon": @"icon_trade", @"r1": NSLocalizedString(@"Trade", nil), @"r1_button": @"2", @"r1_align": @"1", @"nofooter": @"1"};
        [rows2 addObject:row202];
    }
    else if (self.city_enemy)
    {
        NSDictionary *row201 = @{@"r1_icon": @"icon_alliance_profile", @"r1": NSLocalizedString(@"Profile", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"button_bookmark", @"c1": NSLocalizedString(@"Bookmark", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
        [rows2 addObject:row201];
        
        if([self.city_dict[@"under_protection"] integerValue]==0)
        {
            NSDictionary *row202 = @{@"r1_icon": @"icon_attack", @"r1": NSLocalizedString(@"Attack", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"icon_scout", @"c1": NSLocalizedString(@"Spy", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
            [rows2 addObject:row202];
        }
        else
        {
            NSDictionary *row202 = @{@"r1_icon": @"icon_attack", @"r1": NSLocalizedString(@"Attack", nil), @"r1_button": @"1", @"r1_align": @"1", @"c1_icon": @"icon_scout", @"c1": NSLocalizedString(@"Spy", nil), @"c1_button": @"1", @"c1_align": @"1", @"nofooter": @"1"};
            [rows2 addObject:row202];
            
            NSString *strDate = self.city_dict[@"protection_ending"];
            
            NSDate *queueDate = [Globals.i dateParser:strDate];
            NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
            NSInteger protection_time_left = queueTime - [Globals.i updateTime];
            NSInteger protection_time = [self.city_dict[@"protection_time"] integerValue];
            float protection_time_left_percentage=0;
            if(protection_time>0)
            {
                protection_time_left_percentage = (double)protection_time_left/(double)protection_time;
            }
            NSString *protection_string = [NSString stringWithFormat:NSLocalizedString(@"Protection for: %@", nil), [Globals.i getCountdownString:protection_time_left]];
            
            NSDictionary *row203 =  @{@"i1": @"pi_peace_boost",@"i1_align":@"left",@"i1_x":@"35",@"i1_width":@"16",@"i1_height":@"16",@"p1": @(protection_time_left_percentage), @"p1_text": protection_string, @"p1_width_p": @"0.75",@"p1_y_p":@"1",@"p1_x_p":@"1", @"nofooter": @"1"};
        
            [rows2 addObject:row203];

        }
        
    }
    else if (self.city_enemy_village)
    {
        NSDictionary *row201 = @{@"r1_icon": @"icon_alliance_profile", @"r1": NSLocalizedString(@"Profile", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"button_bookmark", @"c1": NSLocalizedString(@"Bookmark", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
        [rows2 addObject:row201];
        
        if([self.city_dict[@"under_protection"] integerValue]==0)
        {
            
            NSDictionary *row202 = @{@"r1_icon": @"icon_attack", @"r1": NSLocalizedString(@"Attack", nil), @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"icon_scout", @"c1": NSLocalizedString(@"Spy", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
            [rows2 addObject:row202];
            
            NSDictionary *row203 = @{@"r1_icon": @"icon_capture", @"r1": NSLocalizedString(@"Capture", nil), @"r1_button": @"2", @"r1_align": @"1", @"nofooter": @"1"};
            [rows2 addObject:row203];
        }
        else
        {
            //NSLog(@"Previous Owner : %@",self.city_dict[@"previous_profile_id"]);
            //NSLog(@"This Player : %@",Globals.i.wsWorldProfileDict[@"profile_id"]);
            Boolean attackable = false;
            
            if([self.city_dict[@"previous_profile_id"] integerValue]==[Globals.i.wsWorldProfileDict[@"profile_id"] integerValue])
            {
                //NSLog(@"Previous Owner");
                
                NSInteger base_conversion_time = [Globals.i.wsSettingsDict[@"base_loyalty_conversion_time"] integerValue];
                //NSInteger base_conversion_time = 10368000;
                
                NSString *strDate = self.city_dict[@"last_captured"];
                
                NSDate *last_captured_date = [Globals.i dateParser:strDate];
                NSTimeInterval captured_time = [last_captured_date timeIntervalSince1970];
                
                //NSLog(@"base_conversion_time : %ld",(long)base_conversion_time);
                //NSLog(@"captured_time : %ld",(long)captured_time);
                //NSLog(@"time_now : %ld",(long)[Globals.i updateTime]);
                
                NSInteger recapture_time_left = (captured_time+base_conversion_time) - [Globals.i updateTime];
                //NSLog(@"recapture_time_left : %ld",(long)recapture_time_left);
                
                float recapture_time_left_percentage=0;
                if(base_conversion_time>0)
                {
                    recapture_time_left_percentage = (double)recapture_time_left/(double)base_conversion_time;
                }
                
                NSString *protection_string = [NSString stringWithFormat:NSLocalizedString(@"Recapture possible for: %@", nil), [Globals.i getCountdownString:recapture_time_left]];
                
                if(recapture_time_left>0)
                {
                    attackable = true;
                    
                    NSDictionary *row202 = @{@"p1": @(recapture_time_left_percentage), @"p1_text": protection_string, @"p1_width_p": @"1",@"p1_y":@"-0.5",@"r1":@"", @"i1":@"icon_capture",@"nofooter": @"1"};
                    [rows2 addObject:row202];
                }
                
                    NSDictionary *row203 = @{@"r1_icon": @"icon_capture", @"r1": @"Recapture", @"r1_button": @"2", @"r1_align": @"1", @"c1_icon": @"icon_scout", @"c1": NSLocalizedString(@"Spy", nil), @"c1_button": @"2", @"c1_align": @"1", @"nofooter": @"1"};
                    [rows2 addObject:row203];
                
            }

            if(!attackable)
            {
                NSString *strDate = self.city_dict[@"protection_ending"];
                
                NSDate *queueDate = [Globals.i dateParser:strDate];
                NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
                NSInteger protection_time_left = queueTime - [Globals.i updateTime];
                NSInteger protection_time = [self.city_dict[@"protection_time"] integerValue];
                float protection_time_left_percentage=0;
                if(protection_time>0)
                {
                    protection_time_left_percentage = (double)protection_time_left/(double)protection_time;
                }
                NSString *protection_string = [NSString stringWithFormat:NSLocalizedString(@"Protection for: %@", nil), [Globals.i getCountdownString:protection_time_left]];
                
                NSDictionary *row203 =  @{@"i1": @"pi_peace_boost",@"i1_align":@"left",@"i1_x":@"35",@"i1_width":@"16",@"i1_height":@"16",@"p1": @(protection_time_left_percentage), @"p1_text": protection_string, @"p1_width_p": @"0.75",@"p1_y_p":@"1",@"p1_x_p":@"1", @"nofooter": @"1"};

                
                [rows2 addObject:row203];
            }
            
        }
    }
    
    self.ui_cells_array = [@[rows1, rows2] mutableCopy];
    
	[self.tableView reloadData];
    
    if (!self.gameTimer.isValid)
    {
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)show_profile
{
    NSString *profile_id = self.city_dict[@"profile_id"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:profile_id forKey:@"profile_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)img1_tap:(id)sender
{
    [self closeDialog];
    
    if ((!self.city_main) && (!self.city_village))
    {
        [self show_profile];
    }
}

- (void)button1_tap:(id)sender
{
    [self closeDialog];
    
    NSInteger i = [sender tag];
    
    if (i == 201) //Enter City or Profile
    {
        if ((!self.city_main) && (!self.city_village))
        {
            [self show_profile];
        }
        else
        {
            NSString *base_id = self.city_dict[@"base_id"];
            if (![Globals.i.wsBaseDict[@"base_id"] isEqualToString:base_id])
            {
                [Globals.i settSelectedBaseId:base_id];
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:@"BaseChanged"
                      object:self];
                     
                     [UIManager.i closeAllTemplate];
                 }];
            }
            else
            {
                [UIManager.i closeAllTemplate];
            }
        }
    }
    else if (i == 202) //Attack or Reinforce or Trade(allliance village or i_am_village)
    {
        if (self.city_enemy || self.city_enemy_village)
        {
            [Globals.i doAttack:self.city_dict];
        }
        else if (self.city_village)
        {
            [Globals.i doTransferTroops:self.city_dict];
        }
        else if (self.city_alliance_village || self.i_am_village)
        {
            NSDictionary *dict = @{@"b_id": self.city_dict[@"base_id"], @"b_x": self.city_dict[@"map_x"], @"b_y": self.city_dict[@"map_y"]};
            [self.city_dict addEntriesFromDictionary:dict];
            
            [Globals.i doTrade:self.city_dict];
        }
        else if (self.city_alliance_member) //must be last or up wont run
        {
            [Globals.i doReinforce:self.city_dict[@"profile_id"]];
        }
    }
    else if (i == 203)
    {
        [Globals.i showConfirmCapture:self.city_dict];
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
    else if (i == 202) //Spy or Trade
    {
        if (self.city_enemy || self.city_enemy_village)
        {
            [Globals.i doSpy:self.city_dict];
        }
        else
        {
            NSDictionary *dict = @{@"b_id": self.city_dict[@"base_id"], @"b_x": self.city_dict[@"map_x"], @"b_y": self.city_dict[@"map_y"]};
            [self.city_dict addEntriesFromDictionary:dict];
            
            [Globals.i doTrade:self.city_dict];
        }
    }
    else if (i == 203) //Spy still loyal city
    {
        if (self.city_enemy_village)
        {
            [Globals.i doSpy:self.city_dict];
        }
    }
}

- (void)closeDialog
{
    [UIManager.i closeTemplate];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ExitFullscreen" object:self];
}

- (void)onTimer
{
    if ((self.ui_cells_array != nil) && ([[UIManager.i currentViewTitle] isEqualToString:self.title]))
    {
        [self updateView];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:DIALOG_CELL_WIDTH];
    
    [dcell.cellview.img1 addTarget:self action:@selector(img1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.img1.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
