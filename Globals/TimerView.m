//
//  TimerView.m
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

#import "TimerView.h"
#import "Globals.h"

@interface TimerView ()

@property (nonatomic, strong) UIImageView *ivBackground;
@property (nonatomic, strong) UIImageView *ivIcon;
@property (nonatomic, strong) UILabel *lblJob;
@property (nonatomic, strong) UILabel *lblTimer;
@property (nonatomic, strong) UIButton *btnSpeedUp;
@property (nonatomic, strong) ProgressView *pvJob;
@property (nonatomic, strong) NSTimer *jobTimer;
@property (nonatomic, strong) NSString *str_image;

//Persistent data tied to timer for marches
@property (nonatomic) NSTimeInterval queueTimeArrive;
@property (nonatomic) NSTimeInterval queueTimeAttackEnd;
@property (nonatomic) NSTimeInterval queueTimeReturn;
@property (nonatomic, assign) double battleTime;
@property (nonatomic, assign) double marchTime;
@end

@implementation TimerView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    //NSLog(@"TimerView initWithFrame base_id : %@, tv_id :%d", self.base_id, self.tv_id);
    
    [self notificationRegister];
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.tv_id = 0;
        self.base_id = @"0";
        self.timer1 = 0;
        self.TotalTimer = 0;
        //self.action_time = 0;
        self.is_return = NO;
        self.is_action = NO;
        self.will_return = NO;
        self.is_clone = NO;
        
        self.queueTimeArrive = 0;
        self.queueTimeAttackEnd = 0;
        self.queueTimeReturn = 0;
        self.battleTime = 0;
        self.marchTime = 0;
    }
    
    return self;
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateTimer"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PressSpeedUpButtonForBuild"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PressSpeedUpButtonForTrainA"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PressSpeedUpButtonForAttack"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PressSpeedUpButtonForResearch"
                                               object:nil];
}

- (void)updateView
{
    CGFloat view_w = self.frame.size.width;
    CGFloat view_h = self.frame.size.height;
    CGRect view_frame = CGRectMake(0.0f, 0.0f, view_w, view_h);
    
    CGFloat spacing = 5.0f*SCALE_IPAD;
    CGFloat icon_size = view_h;
    CGFloat button_size = 60.0f*SCALE_IPAD;
    CGFloat pv_w = view_w-icon_size-button_size;
    CGFloat job_h = view_h-spacing*2;
    
    if (self.ivBackground == nil)
    {
        self.ivBackground = [[UIImageView alloc] initWithFrame:view_frame];
        UIImage *bkg_image = [UIManager.i dynamicImage:view_frame prefix:@"bkg3"];
        [self.ivBackground setImage:bkg_image];
        [self addSubview:self.ivBackground];
    }
    
    if (self.ivIcon == nil)
    {
        self.ivIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, icon_size, icon_size)];
        [self addSubview:self.ivIcon];
    }
    
    if (self.btnSpeedUp == nil)
    {
        self.btnSpeedUp = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"Speed Up", nil)
                                                     target:self
                                                   selector:@selector(btnSpeedup_tap)
                                                      frame:CGRectMake(icon_size+pv_w, 0.0f, button_size, view_h)
                                                       type:@"2"];
    }
    
    //NSLog(@"self.tv_id :%ld",(long)self.tv_id);
    if (self.tv_id == TV_BUILD)
    {
        self.str_image = @"icon_build";
        self.timer1 = Globals.i.buildQueue1;
    }
    else if (self.tv_id == TV_HEAL)
    {
        self.str_image = @"icon_heal";
        self.timer1 = Globals.i.hospitalQueue1;
    }
    else if (self.tv_id == TV_RESEARCH)
    {
        self.str_image = @"icon_research";
        self.timer1 = Globals.i.researchQueue1;
    }
    else if (self.tv_id == TV_ATTACK)
    {
        self.str_image = @"icon_attack";
        self.timer1 = Globals.i.attackQueue1;
        
        self.btnSpeedUp.enabled = YES;
    }
    else if (self.tv_id == TV_TRADE)
    {
        self.str_image = @"icon_trade";
        self.timer1 = Globals.i.tradeQueue1;
    }
    else if (self.tv_id == TV_REINFORCE)
    {
        self.str_image = @"icon_reinforce";
        self.timer1 = Globals.i.reinforceQueue1;
    }
    else if (self.tv_id == TV_TRANSFER)
    {
        self.str_image = @"icon_reinforce";
        self.timer1 = Globals.i.transferQueue1;
    }
    else if (self.tv_id == TV_A)
    {
        self.str_image = @"icon_train_a";
        self.timer1 = Globals.i.aQueue1;
    }
    else if (self.tv_id == TV_B)
    {
        self.str_image = @"icon_train_b";
        self.timer1 = Globals.i.bQueue1;
    }
    else if (self.tv_id == TV_C)
    {
        self.str_image = @"icon_train_c";
        self.timer1 = Globals.i.cQueue1;
    }
    else if (self.tv_id == TV_D)
    {
        self.str_image = @"icon_train_d";
        self.timer1 = Globals.i.dQueue1;
    }
    else if (self.tv_id == TV_SPY)
    {
        self.str_image = @"icon_spy";
        self.timer1 = Globals.i.spyQueue1;
    }
    else if (self.tv_id == TV_BOOST_R1)
    {
        self.str_image = @"icon_r1";
        self.timer1 = Globals.i.boostR1Queue1;
        self.btnSpeedUp = nil;
    }
    else if (self.tv_id == TV_BOOST_R2)
    {
        self.str_image = @"icon_r2";
        self.timer1 = Globals.i.boostR2Queue1;
        self.btnSpeedUp = nil;
    }
    else if (self.tv_id == TV_BOOST_R3)
    {
        self.str_image = @"icon_r3";
        self.timer1 = Globals.i.boostR3Queue1;
        self.btnSpeedUp = nil;
    }
    else if (self.tv_id == TV_BOOST_R4)
    {
        self.str_image = @"icon_r4";
        self.timer1 = Globals.i.boostR4Queue1;
        self.btnSpeedUp = nil;
    }
    else if (self.tv_id == TV_BOOST_R5)
    {
        self.str_image = @"icon_r5";
        self.timer1 = Globals.i.boostR5Queue1;
        self.btnSpeedUp = nil;
    }
    else if (self.tv_id == TV_BOOST_ATT)
    {
        self.str_image = @"icon_attack";
        self.timer1 = Globals.i.boostAttackQueue1;
        self.btnSpeedUp = nil;
    }
    else if (self.tv_id == TV_BOOST_DEF)
    {
        self.str_image = @"icon_reinforce";
        self.timer1 = Globals.i.boostDefendQueue1;
        self.btnSpeedUp = nil;
    }
    
    UIImage *imgItem1 = [UIManager.i imageNamedCustom:self.str_image];
    
    if (self.btnSpeedUp != nil)
    {
        [self addSubview:self.btnSpeedUp];
    }
    else
    {
        view_w = self.frame.size.width-100;
        view_frame = CGRectMake(0.0f, 0.0f, view_w, view_h);
    }
    
    [self.ivIcon setImage:imgItem1];
    
    if (self.pvJob == nil)
    {
        self.pvJob = [[ProgressView alloc] initWithFrame:CGRectMake(icon_size, spacing, pv_w, job_h)];
        [self.pvJob.barLabel1 setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
        [self addSubview:self.pvJob];
    }
    
    if (self.lblJob == nil)
    {
        CGRect lblJob_frame = CGRectMake(icon_size+SCALE_IPAD, spacing-SCALE_IPAD, pv_w-SCALE_IPAD, job_h);
        self.lblJob = [[UILabel alloc] initWithFrame:lblJob_frame];
        [self.lblJob setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
        [self.lblJob setTextColor:[UIColor whiteColor]];
        [self.lblJob setMinimumScaleFactor:0.5f];
        [self addSubview:self.lblJob];
    }
    [self.lblJob setText:self.strJob];
    
    if (self.lblTimer == nil)
    {
        CGRect lblTimer_frame = CGRectMake(icon_size+pv_w/2.0f, spacing-SCALE_IPAD, pv_w/2.0f - SCALE_IPAD, job_h);
        self.lblTimer = [[UILabel alloc] initWithFrame:lblTimer_frame];
        [self.lblTimer setFont:[UIFont fontWithName:DEFAULT_FONT size:DEFAULT_FONT_SIZE]];
        [self.lblTimer setTextAlignment:NSTextAlignmentRight];
        [self.lblTimer setTextColor:[UIColor whiteColor]];
        [self.lblTimer setMinimumScaleFactor:0.5f];
        [self addSubview:self.lblTimer];
    }
    
    if (!self.is_clone && (self.timer1 > 0))
    {
        NSString *notification_id = [NSString stringWithFormat:@"%@:%@", Globals.i.wsBaseDict[@"base_id"], self.strJob];

        BOOL hasNotification = [Globals.i cancelLocalNotification:notification_id];
        if (hasNotification)
        {
            NSLog(@"Notification canceled: %@", notification_id);
        }
        
        NSString *alert_body = [NSString stringWithFormat:NSLocalizedString(@"%@ complete!", nil), self.strJob];
        [Globals.i scheduleNotificationForDate:[NSDate dateWithTimeIntervalSinceNow:self.timer1] AlertBody:alert_body NotificationID:notification_id];
    }
    
    if ((!self.jobTimer.isValid) && (self.timer1 > 0))
    {
        self.jobTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:1.0] interval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.jobTimer forMode:NSRunLoopCommonModes];
    }
    
    if (self.is_clone)
    {
        NSLog(@"New Clone: %@", [@(self.timer1) stringValue]);
        [self updateTimerData];
    }
    else
    {
        NSLog(@"New Master: %@", [@(self.timer1) stringValue]);
    }
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SetClonesIsReturn"
                                               object:nil];
     */
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"UpdateTimer"])
    {
        //NSLog(@"UpdateTimer received on clone :%hhd , baseid :%@",self.is_clone,self.base_id);
        
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSInteger tv_id_needs_update = [[userInfo objectForKey:@"tv_id"] integerValue];
            NSString *base_id_needs_update = [userInfo objectForKey:@"base_id"];
        
            //NSLog(@"self.tv_id :%ld",(long)self.tv_id);
            //NSLog(@"tv_id_needs_update :%ld",(long)tv_id_needs_update);

            if (self.tv_id == tv_id_needs_update)
            {
                NSLog(@"self.base_id :%@", self.base_id);
                NSLog(@"base_id_needs_update :%@", base_id_needs_update);
                
                if ([self.base_id isEqualToString:base_id_needs_update])
                {
                    [self updateTimerData];
                }
            }
        }

        /*
        NSString *type = [notification.userInfo objectForKey:@"item_type"];
        if ([type integerValue] == self.tv_id && self.is_clone)
        {
            [self updateTimerData];
        }
        */
    }
    else if ([[notification name] isEqualToString:@"PressSpeedUpButtonForBuild"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            if (self.tv_id == TV_BUILD)
            {
                if (!self.is_clone)
                {
                    //[self btnSpeedup_tap];
                    [self.btnSpeedUp sendActionsForControlEvents:UIControlEventTouchUpInside];
                    NSLog(@"PressSpeedUpButtonForBuild");
                }
            }
        }
    }
    else if ([[notification name] isEqualToString:@"PressSpeedUpButtonForTrainA"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            if (self.tv_id == TV_A)
            {
                if (!self.is_clone)
                {
                    //[self btnSpeedup_tap];
                    [self.btnSpeedUp sendActionsForControlEvents:UIControlEventTouchUpInside];
                    NSLog(@"PressSpeedUpButtonForTrainA");
                }
            }
        }
    }
    else if ([[notification name] isEqualToString:@"PressSpeedUpButtonForAttack"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            if (self.tv_id == TV_ATTACK)
            {
                if (!self.is_clone)
                {
                    //[self btnSpeedup_tap];
                    [self.btnSpeedUp sendActionsForControlEvents:UIControlEventTouchUpInside];
                    NSLog(@"PressSpeedUpButtonForAttack");
                }
            }
        }
    }
    else if ([[notification name] isEqualToString:@"PressSpeedUpButtonForResearch"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            if (self.tv_id == TV_RESEARCH)
            {
                if (!self.is_clone)
                {
                    //[self btnSpeedup_tap];
                    [self.btnSpeedUp sendActionsForControlEvents:UIControlEventTouchUpInside];
                    NSLog(@"PressSpeedUpButtonForResearch");
                }
            }
        }
    }
}

//NOT using notification to update
- (void)updateNotifications:(NSInteger)speedup_time
{
    NSString *notification_id = [NSString stringWithFormat:@"%@:%@", Globals.i.wsBaseDict[@"base_id"], self.strJob];
    
    NSInteger time_left = self.timer1 - speedup_time;
    NSLog(@"Notification update for %@  TimeLeft: %@", notification_id, [@(time_left) stringValue]);
    
    BOOL hasNotification = [Globals.i cancelLocalNotification:notification_id];
    if (hasNotification)
    {
        if (time_left > 5) //Only re-schedule when there is more then 5 seconds left
        {
            NSString *alert_body = [NSString stringWithFormat:NSLocalizedString(@"%@ complete!", nil), self.strJob];
            [Globals.i scheduleNotificationForDate:[NSDate dateWithTimeIntervalSinceNow:time_left] AlertBody:alert_body NotificationID:notification_id];
        }
    }
}

- (void)setProgress
{
    double t1 = self.timer1;
    double t2 = self.TotalTimer;
    
    //NSLog(@"self.timer1 :%f",self.timer1);
    //NSLog(@"self.TotalTimer :%f",self.TotalTimer);
    
    [self.lblJob setText:self.strJob];
    
    float t3 = t1 / t2;
    
    //NSLog(@"t3 :%f",t3);
    
    self.pvJob.bar1 = 1.0f - t3;
    
    [self.lblTimer setText:[Globals.i getCountdownString:self.timer1]];
    
    [self.pvJob updateView];

    /*
    if (self.is_clone)
    {
        double t1 = self.timer1;
        double t2 = self.TotalTimer;
        
        
        NSLog(@"is_clone setProgress t1: %f",t1);
        NSLog(@"is_clone setProgress t2: %f",t2);
        NSLog(@"is_clone isAction: %hhd",self.is_action);
        NSLog(@"is_clone isReturn: %hhd",self.is_return);
        
        [self.lblJob setText:self.strJob];
        
        float t3 = t1 / t2;
        self.pvJob.bar1 = 1.0f - t3;
        
        [self.lblTimer setText:[Globals.i getCountdownString:self.timer1]];
        
        [self.pvJob updateView];
    }
    else
    {
        double t1 = self.timer1;
        double t2 = self.TotalTimer;
        
        NSLog(@"setProgress t1: %f",t1);
        NSLog(@"setProgress t2: %f",t2);
        NSLog(@"isAction: %hhd",self.is_action);
        NSLog(@"isReturn: %hhd",self.is_return);
        
        [self.lblJob setText:self.strJob];
        
        float t3 = t1 / t2;
        self.pvJob.bar1 = 1.0f - t3;
        
        [self.lblTimer setText:[Globals.i getCountdownString:self.timer1]];
        
        [self.pvJob updateView];
    }
     */
}

- (void)shutdownTimer
{
    self.base_id = @"0";
    self.timer1 = 0;
    self.TotalTimer = 0;
    //self.action_time = 0;
    
    self.will_return = NO;
    self.is_return = NO;
    self.is_action = NO;
    
    [self.lblTimer setText:@""];
    [self.lblJob setText:@""];
    
    self.pvJob.bar1 = 0.0f;
    [self.pvJob barBlue];
    [self.pvJob updateView];
    
    [self.jobTimer invalidate];
    
    
    [Globals.i setTimerViewParameter:TV_ATTACK :@"to_map_x" :@""];
    [Globals.i setTimerViewParameter:TV_ATTACK :@"to_map_y" :@""];
    
    if (!self.is_clone)
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.base_id forKey:@"base_id"];
        [userInfo setObject:@(self.tv_id) forKey:@"tv_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TimerViewEnd"
                                                            object:self
                                                          userInfo:userInfo];
        
        [UIManager.i showToast:[NSString stringWithFormat:NSLocalizedString(@"%@ complete!", nil), self.strJob]
               optionalTitle:NSLocalizedString(@"Complete", nil)
               optionalImage:self.str_image];
        
        if (self.tv_id == TV_ATTACK)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBaseList"
                                                                object:self];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"endMarchingLine"
                                                                object:self];
            
        }
        else if (self.tv_id == TV_TRADE)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
        }
        else if (self.tv_id == TV_REINFORCE)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
        }
        else if (self.tv_id == TV_TRANSFER)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [self removeFromSuperview];
    }
}

- (void)onTimer
{
    //NSLog(@"ONTIMER :%ld", (long)self.tv_id);
    if (self.timer1 > 0)
    {
        [self setProgress];
    }
    else
    {
        if (self.tv_id == TV_ATTACK)
        {
            //NSLog(@"TIMER OVER is_Clone :%hhd", self.is_clone);
            [self updateTimerData];
        }
        else
        {
            
            [self shutdownTimer];
        }
        
    }
    
    //Only run if current base_id is this base_id
    if ([Globals.i.wsBaseDict[@"base_id"] isEqualToString:self.base_id])
    {
        if (self.tv_id == TV_BUILD)
        {
            self.timer1 = Globals.i.buildQueue1;
        }
        else if (self.tv_id == TV_RESEARCH)
        {
            self.timer1 = Globals.i.researchQueue1;
        }
        else if (self.tv_id == TV_ATTACK)
        {
            self.timer1 = Globals.i.attackQueue1;
            
            self.btnSpeedUp.enabled = YES; //TODO: For now can't speedup attack
        }
        else if (self.tv_id == TV_TRADE)
        {
            self.timer1 = Globals.i.tradeQueue1;
        }
        else if (self.tv_id == TV_REINFORCE)
        {
            self.timer1 = Globals.i.reinforceQueue1;
        }
        else if (self.tv_id == TV_TRANSFER)
        {
            self.timer1 = Globals.i.transferQueue1;
        }
        else if (self.tv_id == TV_HEAL)
        {
            self.timer1 = Globals.i.hospitalQueue1;
        }
        else if (self.tv_id == TV_A)
        {
            self.timer1 = Globals.i.aQueue1;
        }
        else if (self.tv_id == TV_B)
        {
            self.timer1 = Globals.i.bQueue1;
        }
        else if (self.tv_id == TV_C)
        {
            self.timer1 = Globals.i.cQueue1;
        }
        else if (self.tv_id == TV_D)
        {
            self.timer1 = Globals.i.dQueue1;
        }
        else if (self.tv_id == TV_SPY)
        {
            self.timer1 = Globals.i.spyQueue1;
        }
        else if (self.tv_id == TV_BOOST_R1)
        {
            self.timer1 = Globals.i.boostR1Queue1;
        }
        else if (self.tv_id == TV_BOOST_R2)
        {
            self.timer1 = Globals.i.boostR2Queue1;
        }
        else if (self.tv_id == TV_BOOST_R3)
        {
            self.timer1 = Globals.i.boostR3Queue1;
        }
        else if (self.tv_id == TV_BOOST_R4)
        {
            self.timer1 = Globals.i.boostR4Queue1;
        }
        else if (self.tv_id == TV_BOOST_R5)
        {
            self.timer1 = Globals.i.boostR5Queue1;
        }
        else if (self.tv_id == TV_BOOST_ATT)
        {
            self.timer1 = Globals.i.boostAttackQueue1;
        }
        else if (self.tv_id == TV_BOOST_DEF)
        {
            self.timer1 = Globals.i.boostDefendQueue1;
        }

    }
    else //Changed to another city but still requires marchingLine to work
    {
        if ((self.is_clone) && ((self.tv_id == TV_ATTACK) || (self.tv_id == TV_TRADE) || (self.tv_id == TV_REINFORCE) || (self.tv_id == TV_TRANSFER)))
        {
            //do not update timer from global , manualy minus 1
            self.timer1 = self.timer1 - 1;
        }
    }
    
}

- (void)updateTimerData
{
    NSLog(@"UPDATETIMERDATA base_id : %@",self.base_id);
    if (self.tv_id == TV_BUILD)
    {

    }
    else if (self.tv_id == TV_RESEARCH)
    {

    }
    else if (self.tv_id == TV_ATTACK)
    {
         NSTimeInterval serverTimeInterval = [Globals.i updateTime];
        
        if ([Globals.i.wsBaseDict[@"base_id"] isEqualToString:self.base_id])
        {
            NSString *strDate_AttackArrival = Globals.i.wsBaseDict[@"attack_queue"];
            NSDate *queueDate_arrive = [Globals.i dateParser:strDate_AttackArrival];
            self.queueTimeArrive = [queueDate_arrive timeIntervalSince1970];
            //NSLog(@"queueDate_arrive : %@",queueDate_arrive);
            
            NSString *strDate_AttackEnd = Globals.i.wsBaseDict[@"attack_queue"];
            NSDate *queueDate_attackEnd = [Globals.i dateParser:strDate_AttackEnd];
            queueDate_attackEnd = [queueDate_attackEnd dateByAddingTimeInterval:[Globals.i.wsBaseDict[@"attack_job_time"] integerValue]];
            self.queueTimeAttackEnd = [queueDate_attackEnd timeIntervalSince1970];
            //NSLog(@"queueDate_attackEnd : %@",queueDate_attackEnd);
            
            NSString *strDate_AttackReturn = Globals.i.wsBaseDict[@"attack_return"];
            NSDate *queueDate_return = [Globals.i dateParser:strDate_AttackReturn];
            self.queueTimeReturn = [queueDate_return timeIntervalSince1970];
            //NSLog(@"queueDate_return : %@",queueDate_return);
            
            self.marchTime = [Globals.i.wsBaseDict[@"attack_time"] integerValue];
            self.battleTime = [Globals.i.wsBaseDict[@"attack_job_time"] integerValue];
            
            NSString *title = [Globals.i fetchTimerViewTitle:TV_ATTACK];
            
            //NSLog(@"BASE queueTimeArrive  :%f",(self.queueTimeArrive));
            //NSLog(@"BASE queueTimeAttackEnd  :%f",(self.queueTimeAttackEnd ));
            //NSLog(@"BASE queueTimeReturn  :%f",(self.queueTimeReturn));
            if (self.queueTimeArrive - serverTimeInterval > 0)
            {
                NSLog(@"ATTACKING STATE");
                if ([Globals.i.wsBaseDict[@"base_id"] isEqualToString:self.base_id])
                {
                    Globals.i.attackUntil = self.queueTimeArrive;
                    Globals.i.attackQueue1 = Globals.i.attackUntil - serverTimeInterval;
                    //self.action_time = Globals.i.attackQueue1;
                    self.timer1 = Globals.i.attackQueue1;
                    self.TotalTimer = self.marchTime;
                    
                    title = [NSString stringWithFormat:NSLocalizedString(@"Attacking %@ ", nil), title];
                    self.strJob = title;
                    [self.lblJob setText:self.strJob];
                    [self.pvJob barBlue];
                }
                
            }
            //before queueDate_attackEnd
            else if(self.queueTimeAttackEnd - serverTimeInterval > 0)//attacking
            {
                //NSLog(@"BATTLING STATE");
                Globals.i.attackUntil = self.queueTimeAttackEnd;
                Globals.i.attackQueue1 = Globals.i.attackUntil - serverTimeInterval;
                
                self.timer1 = Globals.i.attackQueue1;
                self.TotalTimer = self.battleTime;
                
                title = [NSString stringWithFormat:NSLocalizedString(@"Battling at %@ ", nil), title];
                //self.action_time = Globals.i.attackQueue1;
                self.strJob = title;
                [self.lblJob setText:self.strJob];
                [self.pvJob barRed];
                
                self.is_action = YES;
                self.is_return = YES;
                
            }
            else if (self.queueTimeReturn - serverTimeInterval > 0)//returning
            {
                //NSLog(@"RETURNING STATE");
                Globals.i.attackUntil = self.queueTimeReturn;
                Globals.i.attackQueue1 = Globals.i.attackUntil - serverTimeInterval;
                
                self.timer1 = Globals.i.attackQueue1;
                self.TotalTimer = self.marchTime;
                
                title = [NSString stringWithFormat:NSLocalizedString(@"Returning from %@ ", nil), title];
                //self.action_time = Globals.i.attackQueue1;
                self.strJob = title;
                [self.lblJob setText:self.strJob];
                [self.pvJob barBlue];
                
                self.is_action = NO;
                self.is_return = YES;
            }
            else
            {
                if (!self.is_clone)
                {
                    /*
                    //add troops, add resources
                    [Globals.i updateBaseDict:^(BOOL success, NSData *data){
                        [UIManager.i showDialog:@"Your troops have returned from an Attack! Check your report for more details." title:@"TroopsReturned"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
                    }];
                     */
                }
                [self shutdownTimer];
            }
        }
        //Other Marching Line
        else
        {
            //NSLog(@"ML queueTimeArrive  :%f",(self.queueTimeArrive));
            //NSLog(@"ML queueTimeAttackEnd  :%f",(self.queueTimeAttackEnd ));
            //NSLog(@"ML queueTimeReturn  :%f",(self.queueTimeReturn));
            
            if (self.queueTimeArrive - serverTimeInterval > 0)
            {
                //NSLog(@"ML ATTACKING STATE");
                self.timer1 = self.queueTimeArrive - serverTimeInterval;
                self.TotalTimer = self.marchTime;
                
            }
            //before queueDate_attackEnd
            else if(self.queueTimeAttackEnd - serverTimeInterval > 0)//attacking
            {
                //NSLog(@"ML BATTLING STATE");
                self.timer1 = self.queueTimeAttackEnd - serverTimeInterval;
                self.TotalTimer = self.battleTime;
                self.is_action = YES;
                self.is_return = YES;
            }
            else if (self.queueTimeReturn - serverTimeInterval > 0)//returning
            {
                //NSLog(@"ML RETURNING STATE");
                self.timer1 = self.queueTimeReturn - serverTimeInterval;
                self.TotalTimer = self.marchTime;
                self.is_action = NO;
                self.is_return = YES;
            }
            else
            {
                if (!self.is_clone)
                {
                    /*
                    //add troops, add resources
                    [Globals.i updateBaseDict:^(BOOL success, NSData *data){
                        [UIManager.i showDialog:@"Your troops have returned from an Attack! Check your report for more details." title:@"TroopsReturned"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
                    }];
                     */
                }
                [self shutdownTimer];
            }
        }

    }
    else if (self.tv_id == TV_TRADE)
    {
        NSTimeInterval serverTimeInterval = [Globals.i updateTime];
        
        NSString *strDate_TradeArrival = Globals.i.wsBaseDict[@"trade_queue"];
        NSDate *queueDate_arrive = [Globals.i dateParser:strDate_TradeArrival];
        //NSTimeInterval queueTimeArrive = [queueDate_arrive timeIntervalSince1970];
        //NSLog(@"queueDate_arrive : %@",queueDate_arrive);
        
        Globals.i.tradeUntil = [queueDate_arrive timeIntervalSince1970];
        Globals.i.tradeQueue1 = Globals.i.tradeUntil - serverTimeInterval;
        self.TotalTimer = [Globals.i.wsBaseDict[@"trade_time"] integerValue];
        
        if (Globals.i.tradeQueue1 <= 0)
        {
            if (!self.is_clone)
            {
                //add troops, add resources
                [Globals.i updateBaseDict:^(BOOL success, NSData *data){
                    [UIManager.i showDialog:NSLocalizedString(@"Your trade caravan have arrived designated city.", nil) title:@"TradeArrived"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
                }];
            }
            [self shutdownTimer];
        }

    }
    else if (self.tv_id == TV_REINFORCE)
    {
        NSTimeInterval serverTimeInterval = [Globals.i updateTime];
        
        NSString *strDate_ReinforceArrival = Globals.i.wsBaseDict[@"reinforce_queue"];
        NSDate *queueDate_arrive = [Globals.i dateParser:strDate_ReinforceArrival];
        //NSTimeInterval queueTimeArrive = [queueDate_arrive timeIntervalSince1970];
        //NSLog(@"queueDate_arrive : %@",queueDate_arrive);
        
        Globals.i.reinforceUntil = [queueDate_arrive timeIntervalSince1970];
        Globals.i.reinforceQueue1 = Globals.i.reinforceUntil - serverTimeInterval;
        self.TotalTimer=[Globals.i.wsBaseDict[@"reinforce_time"] integerValue];
        
        if (Globals.i.reinforceQueue1  <= 0)
        {
            if (!self.is_clone)
            {
                NSInteger reinforce_action = [Globals.i.wsBaseDict[@"reinforce_action"] integerValue];
                if (reinforce_action == 2) //pulling back reinforcements
                {
                    /*
                    //add troops, add resources
                    [Globals.i updateBaseDict:^(BOOL success, NSData *data){
                        [UIManager.i showDialog:@"Your reinforcements have returned." title:@"ReinforcementReturned"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
                    }];
                     */
                }
                else
                {
                    /*
                    //add troops, add resources
                    [Globals.i updateBaseDict:^(BOOL success, NSData *data){
                        [UIManager.i showDialog:@"Your troops have reinforced designated city." title:@"ReinforcementArrived"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
                    }];
                     */
                }

                
            }
            [self shutdownTimer];
        }
    }
    else if (self.tv_id == TV_TRANSFER)
    {
        NSTimeInterval serverTimeInterval = [Globals.i updateTime];
        
        NSString *strDate_TransferArrival = Globals.i.wsBaseDict[@"transfer_queue"];
        NSDate *queueDate_arrive = [Globals.i dateParser:strDate_TransferArrival];
        //NSTimeInterval queueTimeArrive = [queueDate_arrive timeIntervalSince1970];
        //NSLog(@"queueDate_arrive : %@",queueDate_arrive);
        
        Globals.i.transferUntil = [queueDate_arrive timeIntervalSince1970];
        Globals.i.transferQueue1 = Globals.i.transferUntil - serverTimeInterval;
        
        NSLog(@"total transfer time : %@", Globals.i.wsBaseDict[@"transfer_time"]);
        
        self.TotalTimer = [Globals.i.wsBaseDict[@"transfer_time"] integerValue];
        
        if (Globals.i.transferQueue1 <= 0)
        {
            if (!self.is_clone)
            {
                //add troops, add resources
                [Globals.i updateBaseDict:^(BOOL success, NSData *data){
                    [UIManager.i showDialog:NSLocalizedString(@"Your troops have arrived in designated city.", nil) title:@"TroopTransferArrived"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
                }];
            }
            [self shutdownTimer];
        }
    }
    else if (self.tv_id == TV_HEAL)
    {

    }
    else if (self.tv_id == TV_A)
    {

    }
    else if (self.tv_id == TV_B)
    {

    }
    else if (self.tv_id == TV_C)
    {

    }
    else if (self.tv_id == TV_D)
    {

    }
    else if (self.tv_id == TV_SPY)
    {

    }
}

- (void)btnSpeedup_tap
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    NSString *cat2 = @"speedups";
    if (self.tv_id == TV_ATTACK)
    {
        cat2 = @"march";
        [userInfo setObject:Globals.i.wsBaseDict[@"attack_id"] forKey:@"row_id"];
    }
    else if (self.tv_id == TV_TRADE)
    {
        cat2 = @"march";
        [userInfo setObject:Globals.i.wsBaseDict[@"trade_id"] forKey:@"row_id"];
    }
    else if (self.tv_id == TV_REINFORCE)
    {
        cat2 = @"march";
        [userInfo setObject:Globals.i.wsBaseDict[@"reinforce_id"] forKey:@"row_id"];
    }
    else if (self.tv_id == TV_TRANSFER)
    {
        cat2 = @"march";
        [userInfo setObject:Globals.i.wsBaseDict[@"transfer_id"] forKey:@"row_id"];
    }
    
    NSLog(@"Showing Items");
    [userInfo setObject:cat2 forKey:@"item_category2"];
    [userInfo setObject:self.base_id forKey:@"base_id"];
    [userInfo setObject:[@(self.tv_id) stringValue] forKey:@"item_type"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

@end
