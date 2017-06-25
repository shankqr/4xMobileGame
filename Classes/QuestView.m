//
//  QuestView.m
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

#import "QuestView.h"
#import "Globals.h"

@interface QuestView ()

@end

@implementation QuestView

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
                                                 name:@"ClaimFirstReward"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"ClaimFirstReward"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            NSLog(@"Cell ItemsView : %@", [self.tableView cellForRowAtIndexPath:indexPath]);
            
            DynamicCell *customCellView = (DynamicCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            NSLog(@"DynamicCell : %@ ", customCellView);
            NSLog(@"Button customCellView : %@ ", customCellView.cellview.rv_c.btn);
            
            if (customCellView.cellview.rv_c.btn != nil)
            {
                //[self button1_tap:customCellView.cellview.rv_c.btn];
                [customCellView.cellview.rv_c.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            
            //Bring the user back to main view
            [UIManager.i closeAllTemplate];
        }
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
    
    NSString *service_name = @"GetQuest";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsWorldProfileDict[@"profile_id"]];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 Globals.i.wsQuestArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
             }
             else
             {
                 NSLog(@"WARNING: GetQuest return empty array!");
                 Globals.i.wsQuestArray = [[NSMutableArray alloc] init];
             }
             
             NSMutableArray *rows1 = [[NSMutableArray alloc] init];
             NSMutableArray *groupArray = [[NSMutableArray alloc] init];
             
             BOOL newRowAdded = NO;
             
             for (NSDictionary *row1 in Globals.i.wsQuestArray)
             {
                 NSString *r2;
                 NSString *reward;
                 if (![row1[@"reward"] isEqualToString:@""])
                 {
                     r2 = [NSString stringWithFormat:NSLocalizedString(@"Reward: %@ Diamonds", nil), row1[@"reward"]];
                     reward = row1[@"reward"];
                 }
                 else
                 {
                     r2 = @"";
                     reward = @"0";
                 }
                 
                 NSString *i1;
                 if (![row1[@"image_url"] isEqualToString:@""])
                 {
                     i1 = row1[@"image_url"];
                 }
                 else
                 {
                     i1 = @"";
                 }
                 
                 NSString *i2;
                 NSString *tutorial;
                 if (![row1[@"tutorial"] isEqualToString:@""])
                 {
                     i2 = @"arrow_right";
                     tutorial = row1[@"tutorial"];
                 }
                 else
                 {
                     i2 = @"";
                     tutorial = @"";
                 }
                 
                 NSDictionary *row101 = @{@"r1": row1[@"name"], @"r1_bold": @"1", @"r2": r2, @"i2": i2, @"tutorial": tutorial, @"quest_group": row1[@"quest_group"]};
                 
                 if ([row1[@"claimed"] isEqualToString:@"0"] || [row1[@"claimed"] isEqualToString:@""])
                 {
                     if (![row1[@"profile_id"] isEqualToString:@""])
                     {
                         row101 = @{@"r1": row1[@"name"], @"r1_bold": @"1", @"r2": r2, @"c1": NSLocalizedString(@"Claim", nil), @"c1_button": @"2", @"c1_ratio": @"5", @"reward": reward, @"quest_id": row1[@"quest_id"], @"quest_type_id": row1[@"quest_type_id"], @"quest_group": row1[@"quest_group"]};
                     }
                     
                     [rows1 addObject:row101];
                     newRowAdded = YES;
                     
                     [groupArray addObject:row1[@"quest_group"]];
                 }
             }
             
             NSArray *uniqueGroups = [[NSOrderedSet orderedSetWithArray:groupArray] array];;
             
             for (NSString *quest_group in uniqueGroups)
             {
                 NSDictionary *rowHeader = @{@"r1": quest_group, @"bkg_prefix": @"bkg2", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"};
                 NSMutableArray *rowsQuest = [[NSMutableArray alloc] init];
                 
                 for (NSDictionary *row1 in rows1)
                 {
                     if ([row1[@"quest_group"] isEqualToString:quest_group])
                     {
                         [rowsQuest addObject:row1];
                     }
                 }
                 
                 if (rowsQuest.count > 0)
                 {
                     if (rowsQuest.count > 5)
                     {
                         NSRange r;
                         r.location = 5;
                         r.length = rowsQuest.count-5;
                         
                         NSArray *rowsRemoved = [rowsQuest subarrayWithRange:r];
                         [rowsQuest removeObjectsInRange:r];
                         
                         //Add back any completed quests
                         for (NSDictionary *row1 in rowsRemoved)
                         {
                             if ([row1[@"c1_button"] isEqualToString:@"3"])
                             {
                                 [rowsQuest addObject:row1];
                             }
                         }
                     }
                     
                     [rowsQuest insertObject:rowHeader atIndex:0];
                     
                     if (self.ui_cells_array == nil)
                     {
                         self.ui_cells_array = [[NSMutableArray alloc] init];
                     }
                     
                     [self.ui_cells_array addObject:rowsQuest];
                 }
             }
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateQuestBadge" object:self];
             
             if (newRowAdded)
             {
                 [self.tableView reloadData];
                 [self.tableView flashScrollIndicators];
             }
             
             //Update Advisor
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateAdvisor"
              object:self];
         }
     }];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSMutableDictionary *rowData = self.ui_cells_array[section][row];
    
    NSString *profile_id = Globals.i.wsWorldProfileDict[@"profile_id"];
    NSString *quest_id = rowData[@"quest_id"];
    NSString *quest_type_id = rowData[@"quest_type_id"];
    
    NSInteger reward = [rowData[@"reward"] integerValue];
    
    NSString *service_name = @"ClaimQuest";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       profile_id, quest_id, quest_type_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [self updateView];
             
             NSInteger currency_second = [Globals.i.wsWorldProfileDict[@"currency_second"] integerValue];
             NSInteger new_cs = currency_second + reward;
             Globals.i.wsWorldProfileDict[@"currency_second"] = [@(new_cs) stringValue];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateWorldProfileData"
              object:self];
             
             [UIManager.i showToast:[NSString stringWithFormat:NSLocalizedString(@"You have been rewarded +%@ Diamonds!!!", nil), [@(reward) stringValue]]
                      optionalTitle:@"DiamondsRewarded"
                      optionalImage:@"icon_currency2"];
         }
     }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = self.ui_cells_array[indexPath.section][indexPath.row];
    
    if (![rowData[@"tutorial"] isEqualToString:@""] && rowData[@"c1"] == nil)
    {
        NSString *tutorial = rowData[@"tutorial"];
        if (tutorial != nil)
        {
            [UIManager.i showDialog:tutorial title:@"tutorialDialog"];
        }
    }
    
	return nil;
}

@end
