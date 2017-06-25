//
//  TimerObject
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 4/14/14.
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

#import "TimerObject.h"
#import "Globals.h"

@interface TimerObject ()

@property (nonatomic, strong) NSDate *timerStartDate;
@property (nonatomic, strong) NSTimer *jobTimer;

@property (nonatomic, assign) NSTimeInterval startTimeInterval;

@end

@implementation TimerObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateView
{
    self.timerStartDate = [[NSDate alloc] init];
    self.startTimeInterval = self.timer1;
    
    if ((!self.jobTimer.isValid) && (self.timer1 > 0))
    {
        self.jobTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0] interval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.jobTimer forMode:NSRunLoopCommonModes];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SpeedUpPercent"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"SpeedUpPercent"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        NSString *from_base_id = [userInfo objectForKey:@"base_id"];
        NSString *item_value = [userInfo objectForKey:@"item_value"];
        NSString *type = [userInfo objectForKey:@"item_type"];
        
        if (![self.base_id isEqualToString:from_base_id])
        {
            NSInteger tv_id = [type integerValue];
            NSInteger iv = [item_value integerValue];
            
            if (tv_id == TV_TRANSFER)
            {
                double percentLeft = (double)iv/100.0;
                double reduced = Globals.i.transferQueue1 * percentLeft;
                self.startTimeInterval = self.startTimeInterval - reduced;
            }
        }
    }
}

- (void)destroy
{
    self.str_image = @"";
    self.str_title = @"";
    self.base_id = @"0";
    self.timer1 = 0;
    self.startTimeInterval = 0;
    self.dict = nil;
    self.timerStartDate = nil;
    if (self.jobTimer.isValid)
    {
        [self.jobTimer invalidate];
    }
}

- (void)onTimer
{
    if (self.timer1 > 0)
    {
        NSTimeInterval elapsed = [self.timerStartDate timeIntervalSinceNow];
        self.timer1 = self.startTimeInterval + elapsed;
        
        NSLog(@"Timer type:%@ base_id:%@ timer1:%@", [@(self.type) stringValue], self.base_id, [@(self.timer1) stringValue]);
    }
    else
    {
        if (self.type == TO_TRADE)
        {
            double r1 = [self.dict[@"r1"] doubleValue];
            double r2 = [self.dict[@"r2"] doubleValue];
            double r3 = [self.dict[@"r3"] doubleValue];
            double r4 = [self.dict[@"r4"] doubleValue];
            double r5 = [self.dict[@"r5"] doubleValue];
            
            [Globals.i addBaseResources:self.base_id :r1 :r2 :r3 :r4 :r5];
        }
        
        [UIManager.i showToast:self.str_title
                 optionalTitle:NSLocalizedString(@"Complete", nil)
                 optionalImage:self.str_image];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
        
        [self destroy];
    }
}

@end
