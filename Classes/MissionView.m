//
//  MissionView.m
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

#import "MissionView.h"
#import "Globals.h"

@interface MissionView ()

@property (nonatomic, strong) NSTimer *gameTimer;

@end

@implementation MissionView

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
                                                 name:@"TabMission"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"TabMission"])
    {
        [self updateView];
    }
}

- (void)clearView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
}

- (void)updateView
{
    [self clearView];
    
    NSString *service_name = @"GetMissions";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsWorldProfileDict[@"profile_id"]];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             //Header Timer
             NSMutableArray *rowsMissionHeader = [[NSMutableArray alloc] init];
             /*
             NSString *missionDailyNextUpdatedDateString = Globals.i.wsSettingsDict[@"daily_mission_next_updated_time"];
             
             NSLog(@"missionDailyNextUpdatedDateString : %@", missionDailyNextUpdatedDateString);
             
             NSDate *missionDailyNextUpdatedDate = [Globals.i dateParser:missionDailyNextUpdatedDateString];
             */
             
             NSCalendar *cal = [NSCalendar currentCalendar];
             NSDate *missionDailyNextUpdatedDate = [cal dateByAddingUnit:NSCalendarUnitDay
                                                value:1
                                               toDate:[NSDate date]
                                              options:0];
             NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
             [calendar setLocale:[NSLocale currentLocale]];
             [calendar setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
             NSDateComponents *nowComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:missionDailyNextUpdatedDate];
             missionDailyNextUpdatedDate = [calendar dateFromComponents:nowComponents];
             
             NSTimeInterval missionDailyNextUpdatedTime = [missionDailyNextUpdatedDate timeIntervalSince1970];
             //Hardcoded to 86400 (1 day)
             CGFloat dailyResetDuration = 86400;
             CGFloat missionDailyEndTimeLeft = missionDailyNextUpdatedTime - [Globals.i updateTime];
             
             NSLog(@"missionDailyEndTimeLeft : %f", missionDailyEndTimeLeft);
             
             CGFloat mission_daily_time_left_percentage = 1;
             if (dailyResetDuration > 0)
             {
                 mission_daily_time_left_percentage = 1 - (double)missionDailyEndTimeLeft/(double)dailyResetDuration;
             }
             NSString *missionHeaderText = [NSString stringWithFormat:NSLocalizedString(@"Remaining time until daily mission reset : %@", nil),[Globals.i getCountdownString:missionDailyEndTimeLeft]];
             NSDictionary *rowMissionHeader = @{@"p1": @(mission_daily_time_left_percentage), @"p1_text": missionHeaderText, @"p1_width_p": @"0.75", @"p1_y_p_cell":@"0.25", @"p1_x_p_cell":@"0.15", @"mission_daily_duration":@(dailyResetDuration), @"mission_daily_end_time":@(missionDailyNextUpdatedTime), @"extra_cell_height":@"30"};
             NSMutableDictionary *rowMissionHeaderMutable = [NSMutableDictionary dictionaryWithDictionary:rowMissionHeader];
             [rowsMissionHeader addObject:rowMissionHeaderMutable];
             
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 Globals.i.wsMissionArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
             }
             else
             {
                 NSLog(@"WARNING: GetMission return empty array!");
                 Globals.i.wsMissionArray = [[NSMutableArray alloc] init];
             }
             
             NSLog(@"Total Missions : %lu", (unsigned long)returnArray.count);
             
             NSMutableArray *rowsMission = [[NSMutableArray alloc] init];
             
             for (NSDictionary *mission in Globals.i.wsMissionArray)
             {
                 NSLog(@"mission name : %@", mission[@"name"]);
                 
                 int extraLines = 0;
                 
                 NSMutableString *missionDetailText = [NSMutableString stringWithString:mission[@"description"]];
                 [missionDetailText appendString:@"\nMission Duration : "];
                 [missionDetailText appendString:mission[@"mission_duration"]];
                 [missionDetailText appendString:@" Seconds"];
                 extraLines++;
                 
                 int totalRequirements = 0;
                 int totalRequirementsMet = 0;
                 BOOL requirementsMet = false;
                 NSString *missionRequirementTextFontColor = @"1";
                 
                 NSMutableString *missionRequirementText = [NSMutableString stringWithString:@"Mission Requirements : "];
                 
                 if ([mission[@"requirement_value_1"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Alliance Level :"];
                     [missionRequirementText appendString:mission[@"requirement_value_1"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if ([Globals.i.wsWorldProfileDict[@"alliance_id"] integerValue] >= [mission[@"requirement_value_1"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_2"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Hero Level :"];
                     [missionRequirementText appendString:mission[@"requirement_value_2"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if ([Globals.i getLevel] >= [mission[@"requirement_value_2"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_3"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Food :"];
                     [missionRequirementText appendString:mission[@"requirement_value_3"]];
                     extraLines++;
                     
                     totalRequirements++;
                     //currently based on current base
                     if (Globals.i.base_r1>=[mission[@"requirement_value_3"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_4"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Wood :"];
                     [missionRequirementText appendString:mission[@"requirement_value_4"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if (Globals.i.base_r2>=[mission[@"requirement_value_4"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_5"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Stone :"];
                     [missionRequirementText appendString:mission[@"requirement_value_5"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if (Globals.i.base_r3>=[mission[@"requirement_value_5"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_6"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Ore :"];
                     [missionRequirementText appendString:mission[@"requirement_value_6"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if(Globals.i.base_r4>=[mission[@"requirement_value_6"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_7"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Gold :"];
                     [missionRequirementText appendString:mission[@"requirement_value_7"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if (Globals.i.base_r5>=[mission[@"requirement_value_7"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_8"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Total Infantry :"];
                     [missionRequirementText appendString:mission[@"requirement_value_8"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if ((Globals.i.base_a1+Globals.i.base_a2+Globals.i.base_a3)>=[mission[@"requirement_value_8"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_9"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Total Ranged :"];
                     [missionRequirementText appendString:mission[@"requirement_value_9"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if ((Globals.i.base_b1+Globals.i.base_b2+Globals.i.base_b3)>=[mission[@"requirement_value_9"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_10"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Total Cavalry :"];
                     [missionRequirementText appendString:mission[@"requirement_value_10"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if ((Globals.i.base_c1+Globals.i.base_c2+Globals.i.base_c3)>=[mission[@"requirement_value_10"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_11"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Total Siege :"];
                     [missionRequirementText appendString:mission[@"requirement_value_11"]];
                     extraLines++;
                     
                     totalRequirements++;
                     if ((Globals.i.base_d1+Globals.i.base_d2+Globals.i.base_d3)>=[mission[@"requirement_value_11"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_12"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Blacksmith Level :"];
                     [missionRequirementText appendString:mission[@"requirement_value_12"]];
                     extraLines++;
                     
                     totalRequirements++;
                     
                     int blacksmith_level = 0;
                     
                     for (NSDictionary *dict in Globals.i.wsBuildArray)
                     {
                         if ([dict[@"building_id"] isEqualToString:@"16"])
                         {
                             blacksmith_level= (int)[dict[@"building_level"] integerValue];
                             
                             //Check if this building is under construction
                             if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
                             {
                                 blacksmith_level--;
                             }
                         }
                     }
                     
                     if (blacksmith_level>=[mission[@"requirement_value_12"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_13"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Library Level :"];
                     [missionRequirementText appendString:mission[@"requirement_value_13"]];
                     extraLines++;
                     
                     totalRequirements++;
                     
                     int library_level = 0;
                     
                     for (NSDictionary *dict in Globals.i.wsBuildArray)
                     {
                         if ([dict[@"building_id"] isEqualToString:@"15"])
                         {
                             library_level = (int)[dict[@"building_level"] integerValue];
                             
                             //Check if this building is under construction
                             if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
                             {
                                 library_level--;
                             }
                         }
                     }
                     
                     if (library_level>=[mission[@"requirement_value_13"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 if ([mission[@"requirement_value_14"] integerValue] > 0)
                 {
                     [missionRequirementText appendString:@"\n Castle Level :"];
                     [missionRequirementText appendString:mission[@"requirement_value_14"]];
                     extraLines++;
                     
                     totalRequirements++;
                     
                     int castle_level = 0;
                     
                     for (NSDictionary *dict in Globals.i.wsBuildArray)
                     {
                         if ([dict[@"building_id"] isEqualToString:@"101"])
                         {
                             castle_level= (int)[dict[@"building_level"] integerValue];
                             
                             //Check if this building is under construction
                             if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
                             {
                                 castle_level--;
                             }
                         }
                     }
                     
                     if (castle_level >= [mission[@"requirement_value_14"] integerValue])
                     {
                         totalRequirementsMet++;
                     }
                 }
                 
                 //NSLog(@"totalRequirementsMet : %d",totalRequirementsMet);
                 //NSLog(@"totalRequirements : %d",totalRequirements);
                 
                 if (totalRequirementsMet == totalRequirements)
                 {
                     requirementsMet = true;
                 }
                 
                 if (requirementsMet)
                 {
                     missionRequirementTextFontColor = @"0";
                 }
                 
                 NSMutableString *missionRewardText = [NSMutableString stringWithString:NSLocalizedString(@"Mission Reward : ", nil)];
                 if ([mission[@"reward_value_1"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Diamond :"];
                     [missionRewardText appendString:mission[@"reward_value_1"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_2"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Food :"];
                     [missionRewardText appendString:mission[@"reward_value_2"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_3"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Wood :"];
                     [missionRewardText appendString:mission[@"reward_value_3"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_4"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Stone :"];
                     [missionRewardText appendString:mission[@"reward_value_4"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_5"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Ore :"];
                     [missionRewardText appendString:mission[@"reward_value_5"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_6"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Gold :"];
                     [missionRewardText appendString:mission[@"reward_value_6"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_7"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Spearmen :"];
                     [missionRewardText appendString:mission[@"reward_value_7"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_8"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Swordsmen :"];
                     [missionRewardText appendString:mission[@"reward_value_8"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_9"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Halberdiers :"];
                     [missionRewardText appendString:mission[@"reward_value_9"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_10"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Archers :"];
                     [missionRewardText appendString:mission[@"reward_value_10"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_11"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Longbowmen :"];
                     [missionRewardText appendString:mission[@"reward_value_11"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_12"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Marksmen :"];
                     [missionRewardText appendString:mission[@"reward_value_12"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_13"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Light Cavalry :"];
                     [missionRewardText appendString:mission[@"reward_value_13"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_14"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Heavy Cavalry :"];
                     [missionRewardText appendString:mission[@"reward_value_14"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_15"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Knight :"];
                     [missionRewardText appendString:mission[@"reward_value_15"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_16"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Battering Ram :"];
                     [missionRewardText appendString:mission[@"reward_value_16"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_17"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Ballista :"];
                     [missionRewardText appendString:mission[@"reward_value_17"]];
                     extraLines++;
                 }
                 if ([mission[@"reward_value_18"] integerValue] > 0)
                 {
                     [missionRewardText appendString:@"\n Catapult :"];
                     [missionRewardText appendString:mission[@"reward_value_18"]];
                     extraLines++;
                 }
                 
                 //started
                 if ([mission[@"started"] isEqualToString:@"1"])
                 {
                     NSString *missionEndDateString = mission[@"date_ending"];
                     NSDate *missionEndDate = [Globals.i dateParser:missionEndDateString];
                     NSTimeInterval missionEndTime = [missionEndDate timeIntervalSince1970];
                     CGFloat missionEndTimeLeft = missionEndTime - [Globals.i updateTime];
                     
                     //finished
                     if (missionEndTimeLeft < 0)
                     {
                         //finished but not claimed
                         if ([mission[@"claimed"] isEqualToString:@"0"])
                         {
                             NSDictionary *rowMission = @{@"r1": mission[@"name"], @"r1_extra_line":@(extraLines), @"r1_bold": @"1", @"r2":missionDetailText, @"r3":missionRequirementText, @"r3_color":missionRequirementTextFontColor, @"r4":missionRewardText , @"r4_color":@"0", @"c1": NSLocalizedString(@"Claim", nil), @"c1_button": @"2", @"c1_ratio": @"5", @"mission_id": mission[@"mission_id"], @"mission_type_id": mission[@"mission_type_id"], @"diamond_reward":mission[@"reward_value_1"]};
                             
                             NSMutableDictionary *rowMissionMutable = [NSMutableDictionary dictionaryWithDictionary:rowMission];
                             
                             [rowsMission addObject:rowMissionMutable];
                         }
                         else
                         {

                         }
                     }
                     else
                     {
                         CGFloat mission_duration = [mission[@"mission_duration"] doubleValue];
                         CGFloat mission_percentage_remaining = 1;
                         NSString *mission_progress_string = @"";
                         
                         if (missionEndTime>0 && mission_duration>0)
                         {
                             mission_percentage_remaining = 1 - missionEndTimeLeft/mission_duration;
                             mission_progress_string = [NSString stringWithFormat:NSLocalizedString(@"Mission Completed In : %@", nil), [Globals.i getCountdownString:missionEndTimeLeft]];
                         }
                         
                         NSDictionary *rowMission = @{@"r1": mission[@"name"], @"r1_extra_line":@(extraLines), @"r1_bold": @"1", @"r2":missionDetailText, @"r3":missionRequirementText, @"r3_color":missionRequirementTextFontColor, @"r4":missionRewardText, @"r4_color":@"0", @"c1": NSLocalizedString(@"Claim", nil), @"c1_button": @"1", @"c1_ratio": @"5", @"mission_id": mission[@"mission_id"], @"mission_type_id": mission[@"mission_type_id"], @"claimed":mission[@"claimed"], @"started":mission[@"started"], @"mission_time_left":@(missionEndTimeLeft), @"mission_end_time":@(missionEndTime), @"mission_duration":@(mission_duration), @"p1": @(mission_percentage_remaining), @"p1_text": mission_progress_string, @"p1_color": @"0", @"p1_width_p": @"0.75", @"p1_x_p_cell":@"0.15", @"p1_y_p_cell":@"0.8"};
                         
                         NSMutableDictionary *rowMissionMutable = [NSMutableDictionary dictionaryWithDictionary:rowMission];
                         
                         [rowsMission addObject:rowMissionMutable];
                     }
                 }
                 else
                 {
                     //able to start
                     if (requirementsMet)
                     {
                         NSString *currentMissionEndDateString = Globals.i.wsWorldProfileDict[@"mission_date_ending"];
                         
                         NSLog(@"missionEnding: %@", currentMissionEndDateString);
                         
                         NSDate *currentMissionEndDate = [Globals.i dateParser:currentMissionEndDateString];
                         NSTimeInterval currentMissionEndTime = [currentMissionEndDate timeIntervalSince1970];
                         
                         NSLog(@"currentMissionEndTime : %f", currentMissionEndTime);
                         
                         CGFloat currentMissionEndTimeLeft = currentMissionEndTime - [Globals.i updateTime];
                         
                         NSLog(@"currentMissionEndTimeLeft : %f", currentMissionEndTimeLeft);
                         
                         NSString *d1_button = @"2";
                         //if no current mission
                         if (currentMissionEndTimeLeft > 0)
                         {
                             d1_button = @"1";
                         }
                         
                         NSDictionary *rowMission = @{@"r1": mission[@"name"], @"r1_extra_line":@(extraLines), @"r1_bold": @"1", @"r2":missionDetailText, @"r3":missionRequirementText, @"r3_color":missionRequirementTextFontColor, @"r4":missionRewardText, @"r4_color":@"0", @"d1": NSLocalizedString(@"Start", nil), @"d1_button": d1_button, @"c1_ratio": @"5", @"mission_id": mission[@"mission_id"], @"mission_duration": mission[@"mission_duration"]};
                         
                         NSMutableDictionary *rowMissionMutable = [NSMutableDictionary dictionaryWithDictionary:rowMission];
                         
                         [rowsMission addObject:rowMissionMutable];
                     }
                     else
                     {
                         NSDictionary *rowMission = @{@"r1": mission[@"name"], @"r1_extra_line":@(extraLines), @"r1_bold": @"1", @"r2":missionDetailText , @"r3":missionRequirementText, @"r3_color":missionRequirementTextFontColor, @"r4":missionRewardText, @"r4_color":@"0", @"d1": NSLocalizedString(@"Start", nil), @"d1_button": @"1", @"c1_ratio": @"5", @"mission_id": mission[@"mission_id"], @"mission_duration": mission[@"mission_duration"]};
                         
                         NSMutableDictionary *rowMissionMutable = [NSMutableDictionary dictionaryWithDictionary:rowMission];
                         
                         [rowsMission addObject:rowMissionMutable];
                     }
                 }
             }
             
             if (self.ui_cells_array == nil)
             {
                 self.ui_cells_array = [[NSMutableArray alloc] init];
             }
             
             [self.ui_cells_array addObject:rowsMissionHeader];
             
             [self.ui_cells_array addObject:rowsMission];
             
             [self.tableView reloadData];
             
             if (!self.gameTimer.isValid)
             {
                 self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
                 [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
             }
         }
     }];
}

- (void)onTimer
{
    if ((self.ui_cells_array != nil) && ([[UIManager.i currentViewTitle] isEqualToString:@"Quest"]))
    {
        [self updateViewRefresh];
    }
}

- (void)updateViewRefresh
{
    //Update Mission Header Timer
    for (int index = 0; index < [self.ui_cells_array[0] count]; index++)
    {
        NSLog(@"mission_time_left : %@", self.ui_cells_array[0][index][@"mission_time_left"]);
        
        CGFloat mission_daily_duration = [self.ui_cells_array[0][index][@"mission_daily_duration"] doubleValue];
        CGFloat mission_daily_end_time_left = [self.ui_cells_array[0][index][@"mission_daily_end_time"] doubleValue] - [Globals.i updateTime];
        
        NSLog(@" mission_daily_end_time_left : %f", mission_daily_end_time_left);
        
        CGFloat mission_daily_percentage_remaining = 1;
        NSString *mission_daily_progress_string = @"";
        
        if (mission_daily_end_time_left > 0)
        {
            if (mission_daily_end_time_left > 0 && mission_daily_duration > 0)
            {
                mission_daily_percentage_remaining = 1 - mission_daily_end_time_left/mission_daily_duration;
                mission_daily_progress_string = [NSString stringWithFormat:NSLocalizedString(@"Remaining time until daily mission reset: %@", nil), [Globals.i getCountdownString:mission_daily_end_time_left]];
            }
            self.ui_cells_array[0][index][@"p1"] = @(mission_daily_percentage_remaining);
            self.ui_cells_array[0][index][@"p1_text"] = mission_daily_progress_string;
            
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }

    //Update Mission Timer
    for (int index = 0; index < [self.ui_cells_array[1] count]; index++)
    {
        if ([self.ui_cells_array[1][index][@"started"] isEqualToString:@"1"])
        {
            CGFloat mission_time_left = [self.ui_cells_array[1][index][@"mission_end_time"] doubleValue] - [Globals.i updateTime];
            CGFloat mission_duration = [self.ui_cells_array[1][index][@"mission_duration"] doubleValue];
            CGFloat mission_percentage_remaining = 0;
            NSString *mission_progress_string = @"";
            
            if (mission_time_left > 0)
            {
                if (mission_time_left > 0 && mission_duration > 0)
                {
                    mission_percentage_remaining = 1 - mission_time_left/mission_duration;
                    mission_progress_string = [NSString stringWithFormat:@"Mission Completed In: %@", [Globals.i getCountdownString:mission_time_left]];
                }
                self.ui_cells_array[1][index][@"mission_time_left"] = @(mission_time_left);
                self.ui_cells_array[1][index][@"p1"] = @(mission_percentage_remaining);
                self.ui_cells_array[1][index][@"p1_text"] = mission_progress_string;
                
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSMutableDictionary *rowData = self.ui_cells_array[section][row];
    
    NSString *profile_id = Globals.i.wsWorldProfileDict[@"profile_id"];
    NSString *mission_id = rowData[@"mission_id"];
    NSString *mission_type_id = rowData[@"mission_type_id"];
    
    NSLog(@"mission_id : %@", mission_id);
    NSLog(@"mission_type_id : %@", mission_type_id);
    
    NSString *service_name = @"ClaimMission";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       profile_id, mission_id, mission_type_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i updateBaseDict:^(BOOL success, NSData *data)
             {
                 NSLog(@"MISSION CLAIMED");
                 [self updateView];
                 
                 NSInteger currency_second = [Globals.i.wsWorldProfileDict[@"currency_second"] integerValue];
                 NSInteger new_cs = currency_second + [rowData[@"diamond_reward"] integerValue];
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(new_cs) stringValue];
                 
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"UpdateWorldProfileData"
                  object:self];
                 
                 [UIManager.i showToast:NSLocalizedString(@"Mission Claimed", nil)
                        optionalTitle:@"Mission Claimed"
                        optionalImage:@"icon_check"];
             }];

         }
     }];
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSMutableDictionary *rowData = self.ui_cells_array[section][row];

    NSString *profile_id = Globals.i.wsWorldProfileDict[@"profile_id"];
    NSString *mission_id = rowData[@"mission_id"];
    NSString *mission_duration = rowData[@"mission_duration"];
    
    NSLog(@"mission_id : %@", mission_id);
    NSLog(@"mission_duration : %@", mission_duration);
    
    NSString *service_name = @"StartMission";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       profile_id, mission_id, mission_duration];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSLog(@"MISSION STARTED");
             
             NSDate *newMissionEndDate = [Globals.i getServerDateTime];

             newMissionEndDate = [newMissionEndDate dateByAddingTimeInterval:[mission_duration integerValue]];

             Globals.i.wsWorldProfileDict[@"mission_date_ending"] = [[Globals.i getDateFormat] stringFromDate:newMissionEndDate];

             [self updateView];
             
             [UIManager.i showToast:NSLocalizedString(@"Mission Started", nil)
                    optionalTitle:@"Mission Started"
                    optionalImage:@"icon_check"];
         }
     }];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_d.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_d.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
