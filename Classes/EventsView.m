//
//  EventsView.m
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

#import "EventsView.h"
#import "Globals.h"

@interface EventsView ()

@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, assign) NSTimeInterval b1s;

@end

@implementation EventsView

- (void)updateView
{
    NSString *wsurl = @"";
    
    [Globals.i getServerLoading:self.serviceNameDetail :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 NSDictionary *row0 = @{@"h1": (returnArray)[0][@"event_row1"]};
                 
                 NSDictionary *row1 = @{@"r1": (returnArray)[0][@"event_row2"], @"r2": (returnArray)[0][@"event_row3"]};
                 
                 //Update time left in seconds for event to end
                 NSTimeInterval serverTimeInterval = [Globals.i updateTime];
                 NSString *strDate = (returnArray)[0][@"event_ending"];
                 
                 NSDate *endDate = [Globals.i dateParser:strDate];
                 NSTimeInterval endTime = [endDate timeIntervalSince1970];
                 self.b1s = endTime - serverTimeInterval;
                 
                 NSDictionary *row2;
                 NSDictionary *row3;
                 
                 if (self.b1s > 0)
                 {
                     NSString *xp_gain = Globals.i.wsWorldProfileDict[@"xp_gain"];
                     
                     row2 = @{@"r1_color": @"1", @"r1": [NSString stringWithFormat:NSLocalizedString(@"Ending in %@", nil), [Globals.i getCountdownString:self.b1s]]};
                     row3 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Your Score: %@ (Power Gain)", nil), [Globals.i numberFormat:xp_gain]]};
                 }
                 else
                 {
                     row2 = @{@"r1_color": @"1", @"r1": NSLocalizedString(@"This tournament has ended. Congratulations to all winner listed BELOW. Prepare yourselves, as a new tournament will begin soon!", nil)};
                     if ([Globals.i.wsWorldProfileDict[@"xp_history"] isEqualToString:@"0"])
                     {
                         row3 = @{@"r1": NSLocalizedString(@"Thank you for playing.", nil)};
                     }
                     else
                     {
                         NSString *xp_history = Globals.i.wsWorldProfileDict[@"xp_history"];
                         
                         row3 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Your Score was %@ (Power Gain)", nil), [Globals.i numberFormat:xp_history]]};
                     }
                 }
                 
                 if ([self.isAlliance isEqualToString:@"1"])
                 {
                     row3 = @{@"r1": NSLocalizedString(@"Make sure you are a member of an Alliance to participate and win prizes.", nil)};
                 }
                 
                 NSMutableArray *rowArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                 
                 [rowArray insertObject:row0 atIndex:0];
                 [rowArray addObject:row1];
                 [rowArray addObject:row2];
                 [rowArray addObject:row3];
                 
                 self.ui_cells_array = [@[rowArray] mutableCopy];
                 
                 //Add loading header
                 NSMutableArray *rowLoading = [@[@{@"h1": NSLocalizedString(@"Loading...", nil)}] mutableCopy];
                 [self.ui_cells_array addObject:rowLoading];
                 
                 [self.tableView reloadData];
                 
                 [self updateList:(rowArray)[0][@"event_id"]];
             }
         }
     }];
}

- (void)updateList:(NSString *)event_id
{
    NSString *service_name;
    NSString *wsurl;
    
    if (self.b1s > 0)
    {
        service_name = self.serviceNameList;
        wsurl = @"";
    }
    else
    {
        service_name = self.serviceNameResult;
        wsurl = [NSString stringWithFormat:@"/%@", event_id];
    }
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 NSDictionary *row0 = @{@"n1": NSLocalizedString(@"Rank", nil), @"n1_width": @"50", @"h1": NSLocalizedString(@"Player", nil), @"c1": NSLocalizedString(@"Power+", nil), @"c1_ratio": @"4"};
                 if ([self.isAlliance isEqualToString:@"1"])
                 {
                     row0 = @{@"n1": NSLocalizedString(@"Rank", nil), @"n1_width": @"50", @"h1": NSLocalizedString(@"Alliance", nil), @"c1": NSLocalizedString(@"Power+", nil), @"c1_ratio": @"4"};
                 }
                 
                 NSMutableArray *rowArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                 [rowArray insertObject:row0 atIndex:0];
                 
                 //Remove loading row
                 [self.ui_cells_array removeObjectAtIndex:1];
                 
                 [self.ui_cells_array addObject:rowArray];
                 
                 if (self.b1s > 0)
                 {
                     if (!self.gameTimer.isValid)
                     {
                         self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
                         [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
                     }
                 }
                 else
                 {
                     if (self.gameTimer.isValid)
                     {
                         [self.gameTimer invalidate];
                         self.gameTimer = nil;
                     }
                 }
                 
                 [self.tableView reloadData];
             }
         }
         });
     }];
}

- (void)onTimer
{
    if ((self.ui_cells_array != nil) && ([[UIManager.i currentViewTitle] isEqualToString:self.title]))
    {
        self.b1s = self.b1s-1;
        
        [self redrawView];
    }
}

- (void)redrawView
{
    self.ui_cells_array[0][3] = @{@"r1_color": @"1", @"r1": [NSString stringWithFormat:NSLocalizedString(@"Ending in %@", nil), [Globals.i getCountdownString:self.b1s]]};
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *returnRow;
    NSDictionary *row1 = (self.ui_cells_array)[indexPath.section][indexPath.row];
    
    if (indexPath.row == 0) //Header row
    {
        returnRow = row1;
	}
    else
    {
        if (indexPath.section == 0) //Details row
        {
            returnRow = row1;
        }
        else
        {
            NSString *xp_gain = [Globals.i numberFormat:row1[@"xp_gain"]];
            
            if ([self.isAlliance isEqualToString:@"1"])
            {
                returnRow = @{@"n1": [@(indexPath.row) stringValue], @"r1": row1[@"alliance_name"], @"c1": xp_gain, @"c1_ratio": @"4"};
            }
            else
            {
                NSString *r1 = row1[@"profile_name"];
                if ([row1[@"alliance_tag"] length] > 2)
                {
                    r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
                }
        
                returnRow = @{@"n1": [@(indexPath.row) stringValue], @"r1": r1, @"c1": xp_gain, @"c1_ratio": @"4"};
            }
        }
    }
    
    return returnRow;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section > 0) && (indexPath.row > 0)) //Not Details and Header row
    {
        NSDictionary *rowData = self.ui_cells_array[indexPath.section][indexPath.row];
        
        if ([self.isAlliance isEqualToString:@"1"])
        {
            NSString *aid = rowData[@"alliance_id"];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:aid forKey:@"alliance_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (![rowData[@"profile_id"] isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]])
        {
            NSString *selected_profileid = [[NSString alloc] initWithString:rowData[@"profile_id"]];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:selected_profileid forKey:@"profile_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    
	return nil;
}

@end
