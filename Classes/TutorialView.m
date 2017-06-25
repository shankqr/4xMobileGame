//
//  TutorialView
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

#import "TutorialView.h"
#import "Globals.h"

@interface TutorialView ()

@property (nonatomic, strong) NSMutableArray *tutorial_array;
@property (nonatomic, strong) NSDictionary *current_tutorial;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImageView *iv_bg;
@property (nonatomic, strong) UIImageView *iv_char;
@property (nonatomic, strong) UIImageView *iv_arrow;
@property (nonatomic, strong) UIImageView *iv_arrow_g;
@property (nonatomic, strong) UILabel *lbl_text;
@property (nonatomic, strong) UIButton *btn_next;

@property (nonatomic, assign) CGFloat hole_x;
@property (nonatomic, assign) CGFloat hole_y;
@property (nonatomic, assign) CGFloat hole_w;
@property (nonatomic, assign) CGFloat hole_h;
@property (nonatomic, assign) CGFloat screen_height;
@property (nonatomic, assign) CGFloat screen_width;
@property (nonatomic, assign) CGRect hole_rect;
@property (nonatomic, assign) NSInteger dialogPosition;
@property (nonatomic, assign) NSInteger arrowPosition;
@property (nonatomic, assign) BOOL isDialogBoxClickable;//boolean to represent if the dialog box is clickable
@property (nonatomic, assign) BOOL hasClickedInCurrentTutorialStep;
@property (nonatomic, assign) BOOL is_iphone;

@property (nonatomic, assign) NSInteger delayTutorialDisplayStep;
@property (nonatomic, assign) CGFloat delayTutorialDisplayTime;
@property (nonatomic, assign) NSInteger delayTutorialInputActiveStep;
@property (nonatomic, assign) CGFloat delayTutorialInputActiveTime;
@property (nonatomic, assign) NSInteger skipToTutorialStep;
@property (nonatomic, strong) UIButton *btnQuitTutorial;

@end

@implementation TutorialView

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHighlightedArea"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TutorialStepCompleted"
                                               object:nil];

    //Can only handle 1 step at a time
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"DelayTutorialDisplay"
                                               object:nil];
    
    //Can only handle 1 step at a time
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"DelayTutorialInputActive"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ContinueTutorial"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"UpdateHighlightedArea"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            NSNumber *tutorial_step = [userInfo objectForKey:@"tutorial_step"];
            
            CGFloat hole_x = [[userInfo objectForKey:@"hole_x"] floatValue];
            CGFloat hole_y = [[userInfo objectForKey:@"hole_y"] floatValue];
            CGFloat hole_w = [[userInfo objectForKey:@"hole_w"] floatValue];
            CGFloat hole_h = [[userInfo objectForKey:@"hole_h"] floatValue];
            NSLog(@"UpdateHighlightedArea x:%f,y:%f,w:%f,h:%f",hole_x,hole_y,hole_w,hole_h);
            
            self.hole_x = hole_x;
            self.hole_y = hole_y;
            self.hole_w = hole_w;
            self.hole_h = hole_h;
            
            NSLog(@"Before x:%f,y:%f,w:%f,h:%f",[self.current_tutorial[@"hole_x"] floatValue],[self.current_tutorial[@"hole_y"] floatValue],[self.current_tutorial[@"hole_w"] floatValue],[self.current_tutorial[@"hole_h"] floatValue]);
            
            NSMutableDictionary *newCurrentTutorial = [self.tutorial_array[[tutorial_step integerValue]] mutableCopy];
            [newCurrentTutorial setObject:@(hole_x)  forKey:@"hole_x"];
            [newCurrentTutorial setObject:@(hole_y)  forKey:@"hole_y"];
            [newCurrentTutorial setObject:@(hole_w)  forKey:@"hole_w"];
            [newCurrentTutorial setObject:@(hole_h)  forKey:@"hole_h"];
            
            //self.current_tutorial = newCurrentTutorial;
            
            [self.tutorial_array replaceObjectAtIndex:[tutorial_step integerValue] withObject:[NSDictionary dictionaryWithDictionary: newCurrentTutorial]];
            
            NSLog(@"After x:%f,y:%f,w:%f,h:%f",[self.current_tutorial[@"hole_x"] floatValue],[self.current_tutorial[@"hole_y"] floatValue],[self.current_tutorial[@"hole_w"] floatValue],[self.current_tutorial[@"hole_h"] floatValue]);
            
            [self clearView];
            
            [self drawView];
        }
    }
    else if ([[notification name] isEqualToString:@"TutorialStepCompleted"])
    {
        NSDictionary *userInfo = notification.userInfo;
        int step_advance = 1;
        
        if (userInfo != nil)
        {
            if ([userInfo objectForKey:@"skip_step"] != nil)
            {
                int skip_step = [[userInfo objectForKey:@"skip_step"] intValue];
                NSLog(@"Skipping tutorial step : %d", skip_step);
                step_advance = step_advance+skip_step;
            }
        }
        
        [self tutorial_next:step_advance];
    }
    else if ([[notification name] isEqualToString:@"DelayTutorialDisplay"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo != nil)
        {
            self.delayTutorialDisplayStep = [[userInfo objectForKey:@"tutorial_step"] intValue];
            self.delayTutorialDisplayTime = [[userInfo objectForKey:@"delay_time"] floatValue];
        }
    }
    else if ([[notification name] isEqualToString:@"DelayTutorialInputActive"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            self.delayTutorialInputActiveStep = [[userInfo objectForKey:@"tutorial_step"] intValue];
            self.delayTutorialInputActiveTime = [[userInfo objectForKey:@"delay_time"] floatValue];
        }
    }
    else if ([[notification name] isEqualToString:@"ContinueTutorial"])
    {
        NSLog(@"ContinueTutorial");
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            NSInteger last_completed_tutorial_step = [[userInfo objectForKey:@"last_completed_tutorial_step"] integerValue];
            NSLog(@"current_tutorial_step : %ld",(long)[self get_current_tutorial_step]);
            NSLog(@"last_completed_tutorial_step : %ld",(long)last_completed_tutorial_step);
            
            if (last_completed_tutorial_step < 4)
            {
                //Nothing significant
                [self tutorial_step_set:0];
            }
            else if (last_completed_tutorial_step < 8)
            {
                //Farm built
                [self tutorial_step_set:7];
            }
            else if (last_completed_tutorial_step < 12)
            {
                //First reward claimed
                [self tutorial_step_set:9];
            }
            else if (last_completed_tutorial_step < 21)
            {
                //Barracks built
                [self tutorial_step_set:15];
            }
            else if (last_completed_tutorial_step < 27)
            {
                //3 Troops trained
                [self tutorial_step_set:25];
            }
            else if (last_completed_tutorial_step < 35)
            {
                //Rally point built
                [self tutorial_step_set:30];
            }
            else if (last_completed_tutorial_step < 40)
            {
                //Attack sent
                [self tutorial_step_set:38];
            }
            else if (last_completed_tutorial_step < 44)
            {
                //Report seen
                [self tutorial_step_set:42];
            }
            else if (last_completed_tutorial_step < 52)
            {
                //Library built
                [self tutorial_step_set:47];
            }
            else if (last_completed_tutorial_step < 62)
            {
                //Food researched
                [self tutorial_step_set:56];
            }
            else if (last_completed_tutorial_step < 67)
            {
                //Capture sent
                [self tutorial_step_set:66];
            }
            else if (last_completed_tutorial_step < 69)
            {
                //2nd base viewed
                [self tutorial_step_set:68];
            }
            else if (last_completed_tutorial_step < 72)
            {
                //alliance viewed
                [self tutorial_step_set:69];
            }
            else
            {
                [self tutorial_step_set:73];
                [Globals.i tutorial_off];
            }
            
            NSLog(@"current_tutorial_zoom: %@",self.current_tutorial[@"zoom"]);
            if (self.current_tutorial[@"zoom"] != nil)
            {
                NSLog(@"zooom");
                [self zoomBaseView];
            }
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    NSLog(@"TutorialView initWithFrame");
    
    [self notificationRegister];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    [self addGestureRecognizer:tapGesture];
    
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [[UIColor alloc] initWithRed:0./255 green:0./255 blue:0./255 alpha:0.6];
        
        self.hole_x = 0.0f;
        self.hole_y = 0.0f;
        self.hole_w = 0.0f;
        self.hole_h = 0.0f;
        self.arrowPosition = 2;
        self.hasClickedInCurrentTutorialStep = false;
        self.delayTutorialDisplayTime = 0;
        self.delayTutorialDisplayStep = 0;
        self.delayTutorialInputActiveTime = 0;
        self.delayTutorialInputActiveStep = 0;
        
        self.screen_height = UIScreen.mainScreen.bounds.size.height;
        self.screen_width = UIScreen.mainScreen.bounds.size.width;
        if (self.screen_height==480 && self.screen_width==320)
        {
            self.is_iphone=TRUE;
        }
        
        [self tutorial_step_set:0];
        
        if (self.btnQuitTutorial == nil)
        {
            self.btnQuitTutorial = [[UIButton alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-32.0f*SCALE_IPAD, (UIScreen.mainScreen.bounds.size.height - 84.0f*SCALE_IPAD), 32.0f*SCALE_IPAD, 32.0f*SCALE_IPAD)];
            [self.btnQuitTutorial setBackgroundImage:[Globals.i imageNamedCustom:@"button_skip"] forState:UIControlStateNormal];
            [self.btnQuitTutorial addTarget:self action:@selector(quit_tutorial:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:self.btnQuitTutorial];
        }
    }
    
    return self;
}

- (void)updateTutorial
{
    NSString *service_name = @"UpdatePlayerTutorial";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"profile_id"], @([Globals.i is_tutorial_on]), @([self get_current_tutorial_step])];
    
    [Globals.i getSp:service_name :wsurl :^(BOOL success, NSData *data){}];
}

- (NSInteger)get_current_tutorial_step
{
    NSInteger tutorial_step = [[NSUserDefaults standardUserDefaults] integerForKey:@"tutorial_step"];
    
    if (tutorial_step < 0)
    {
        tutorial_step = 0;
    }
    
    //NSLog(@"GET_CURRENT_TUTORIAL : %ld",(long)tutorial_step);
    
    return tutorial_step;
}

-(void)quit_tutorial:(id)sender
{
    NSLog(@"Quit Tutorial");
    [UIManager.i showDialogBlock:NSLocalizedString(@"Are you sure you want to quit the tutorial and forfeit the rewards which includes another village?", nil)
    title:@"QuitTutorialConfirmation"
    type:2
        :^(NSInteger index, NSString *text)
        {
            if (index == 1) //YES
            {
                [Globals.i tutorial_off];
            }
        }];
}

- (void)tutorial_step_set:(int)step
{
    [[NSUserDefaults standardUserDefaults] setInteger:step forKey:@"tutorial_step"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSLog(@"Tutorial step set to :%ld",(long)step);
}

- (void)tutorial_next:(int)step_to_advance
{
    NSLog(@"step_to_advance :%ld", (long)step_to_advance);
    [self updateTutorial];

    int int_step = (int)[self get_current_tutorial_step] + step_to_advance;
    
    NSLog(@"tutorial next :%ld", (long)int_step);
    
    [self tutorial_step_set:int_step];
    
    /*
    //For Testing
    if (int_step==2)
    {
        [self tutorial_step_set:66];
    }
    */
    
    NSString *event = [NSString stringWithFormat:@"TutorialStep %ld", (long)int_step];
    
    NSLog(@"tutorial Now : %ld", (long)int_step);
    
    [Globals.i trackEvent:@"Tutorial" action:event label:Globals.i.wsWorldProfileDict[@"uid"]];
    
    //TEMPORARY SOLUTION as there is no state management/easy way to continue after tutorial step is done. This using delays
    double delayInSeconds = 0.5;
    if (self.delayTutorialDisplayStep > 0)
    {
        delayInSeconds = (double)self.delayTutorialDisplayTime;
        self.delayTutorialDisplayStep = 0;
        self.delayTutorialDisplayTime = 0;
    }
    dispatch_time_t nextTutorialTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(nextTutorialTime, dispatch_get_main_queue(), ^(void)
    {
        [self removeFromSuperview];
        [[UIManager.i firstViewControllerStack].view addSubview:self];
        
        NSLog(@"Tutorial Next UpdateView");
        [self updateView];
        
        double delayInSeconds = 0.5;
        if (self.delayTutorialInputActiveStep > 0)
        {
            delayInSeconds = (double)self.delayTutorialInputActiveTime;
            self.delayTutorialInputActiveStep = 0;
            self.delayTutorialInputActiveTime = 0;
        }
        
        dispatch_time_t nextTutorialTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(nextTutorialTime, dispatch_get_main_queue(), ^(void)
        {
            NSLog(@"Tutorial Next Now Clickable");
            self.hasClickedInCurrentTutorialStep = false;
        });
    });
}

- (NSDictionary *)get_current_tutorial
{
    //ARROW POSITION 1=showingdown , 2=showingright , 3=showingup
    if (self.tutorial_array == nil)
    {
        NSLog(@"SETUP tutorial_dict");
        
        NSString *hole_x = @"0";
        NSString *hole_y = @"0";
        NSString *hole_w = @"0";
        NSString *hole_h = @"0";
        NSString *zoom_x = @"0";
        NSString *zoom_y = @"0";
        NSString *zoom_scale = @"0";
        
        //If the tutorial runs out of focus, please close and re-open the app.
        NSDictionary *tutorial_step_0 = @{@"r1": NSLocalizedString(@"Welcome Sire! I am Panglima Garang. I'll be showing you how to make your kingdom grow and prosper.Hopefully by the end of this lesson the people will show their appreciation by showering you with gems", nil), @"dialogPosition":@"3"};
        
        NSDictionary *tutorial_step_1 = @{@"r1": NSLocalizedString(@"Firstly I would like to show you how to build a Farm. Food is important to feed your Troops.", nil)};
        
        if (iPad)
        {
            hole_x = @"50";
            hole_y = @"100";
            hole_w = @"150";
            zoom_x = @"1185";
            zoom_y = @"450";
            zoom_scale = @"1";
        }
        else
        {
            if(self.is_iphone)
            {
                hole_x = @"100";
                hole_y = @"100";
                hole_w = @"125";
                zoom_x = @"500";
                zoom_y = @"200";
                zoom_scale = @"1";
            }
            else
            {
                hole_x = @"100";
                hole_y = @"100";
                hole_w = @"150";
                zoom_x = @"615";
                zoom_y = @"265";
                zoom_scale = @"1";
            }
        }
        //location = 201
        NSDictionary *tutorial_step_2 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"zoom": @"yes",@"zoom_scale": zoom_scale,@"zoom_x":zoom_x,@"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"60";
            hole_w = @"1000";
            hole_h = @"120";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"60";
                hole_w = @"1000";
                hole_h = @"110";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"60";
                hole_w = @"1000";
                hole_h = @"110";
            }
        }
        //select farm
        NSDictionary *tutorial_step_3 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"250";
            hole_y = @"45";
            hole_w = @"110";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"205";
                hole_y = @"45";
                hole_w = @"110";
            }
            else
            {
                hole_x = @"205";
                hole_y = @"45";
                hole_w = @"110";
            }
        }
        
        //click build
        NSDictionary *tutorial_step_4 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"dialogPosition": @"3"};
       
        if (iPad)
        {
            hole_x = @"185";
            hole_y = @"55";
            hole_w = @"70";
            zoom_x = @"-1185";
            zoom_y = @"-450";
            zoom_scale = @"0";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"185";
                hole_y = @"55";
                hole_w = @"70";
                zoom_x = @"-500";
                zoom_y = @"-400";
                zoom_scale = @"0";
            }
            else
            {
                hole_x = @"185";
                hole_y = @"55";
                hole_w = @"70";
                zoom_x = @"-615";
                zoom_y = @"-265";
                zoom_scale = @"0";
            }
        }
        //click on speedup
        NSDictionary *tutorial_step_5 = @{@"r1": NSLocalizedString(@"Time is a luxury we don't have, so boost activities when you can.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"zoom": @"yes",@"zoom_scale":zoom_scale,@"zoom_x":zoom_x,@"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"-10";
            hole_y = @"100";
            hole_w = @"70";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-10";
                hole_y = @"100";
                hole_w = @"70";
            }
            else
            {
                hole_x = @"-10";
                hole_y = @"100";
                hole_w = @"70";
            }
        }
        
        //click on use on speedup item
        NSDictionary *tutorial_step_6 = @{@"r1": NSLocalizedString(@"Consume speedup items to help with the boost.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"arrowPosition": @"3",@"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"55";
            hole_y = @"470";
            hole_w = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"55";
                hole_y = @"430";
                hole_w = @"50";
            }
            else
            {
                hole_x = @"55";
                hole_y = @"530";
                hole_w = @"50";
            }
        }
        //click on quest
        NSDictionary *tutorial_step_7 = @{@"r1": NSLocalizedString(@"Perfect! Now lets have a look at the Quests.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"1",@"dialogPosition": @"2"};
        
        if (iPad)
        {
            hole_x = @"315";
            hole_y = @"125";
            hole_h = @"50";
            hole_w = @"100";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"255";
                hole_y = @"130";
                hole_h = @"30";
                hole_w = @"60";
            }
            else
            {
                hole_x = @"255";
                hole_y = @"120";
                hole_h = @"50";
                hole_w = @"100";
            }
        }
        //click claim
        NSDictionary *tutorial_step_8 = @{@"r1": NSLocalizedString(@"It looks like you have just completed your first Quest to build a Farm. Now go ahead and claim your reward.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        
        NSDictionary *tutorial_step_9 = @{@"r1": NSLocalizedString(@"You deserved that for your hard work! Now lets build a Barrack. Barrack lets you train troops.", nil)};
        
        if (iPad)
        {
            hole_x = @"40";
            hole_y = @"70";
            hole_w = @"150";
            zoom_x = @"0";
            zoom_y = @"1200";
            zoom_scale = @"1";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"40";
                hole_y = @"150";
                hole_w = @"125";
                zoom_x = @"0";
                zoom_y = @"240";
                zoom_scale = @"1";
            }
            else
            {
                hole_x = @"40";
                hole_y = @"150";
                hole_w = @"150";
                zoom_x = @"0";
                zoom_y = @"900";
                zoom_scale = @"1";
            }
        }
        //click on location = 302
        NSDictionary *tutorial_step_10 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"zoom": @"yes", @"zoom_scale": zoom_scale, @"zoom_x":zoom_x, @"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"10";
            hole_y = @"250";
            hole_w = @"1000";
            hole_h = @"135";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"270";
                hole_w = @"1000";
                hole_h = @"110";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"270";
                hole_w = @"1000";
                hole_h = @"110";
            }
        }
        //click on barrack
        NSDictionary *tutorial_step_11 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"250";
            hole_y = @"45";
            hole_w = @"110";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"205";
                hole_y = @"45";
                hole_w = @"110";
            }
            else
            {
                hole_x = @"205";
                hole_y = @"45";
                hole_w = @"110";
            }
        }
        //click build
        NSDictionary *tutorial_step_12 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"185";
            hole_y = @"55";
            hole_w = @"70";
            zoom_x = @"0";
            zoom_y = @"-1200";
            zoom_scale = @"0";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"185";
                hole_y = @"55";
                hole_w = @"70";
                zoom_x = @"0";
                zoom_y = @"-240";
                zoom_scale = @"0";
            }
            else
            {
                hole_x = @"185";
                hole_y = @"55";
                hole_w = @"70";
                zoom_x = @"0";
                zoom_y = @"-900";
                zoom_scale = @"0";
            }
        }
        //click speedup
        NSDictionary *tutorial_step_13 = @{@"r1": NSLocalizedString(@"Time is a luxury we don't have, so boost activities when you can.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"zoom": @"yes", @"zoom_scale": zoom_scale, @"zoom_x":zoom_x, @"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"-10";
            hole_y = @"210";
            hole_w = @"70";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-10";
                hole_y = @"210";
                hole_w = @"70";
            }
            else
            {
                hole_x = @"-10";
                hole_y = @"210";
                hole_w = @"70";
            }
        }
        //click on use on speedup item 2
        NSDictionary *tutorial_step_14 = @{@"r1": NSLocalizedString(@"Consume speedup items to help with the boost.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        NSDictionary *tutorial_step_15 = @{@"r1": NSLocalizedString(@"Now lets train some troops. Troops are important to defend the city.", nil)};
        
        if (iPad)
        {
            hole_x = @"50";
            hole_y = @"100";
            hole_w = @"150";
            zoom_x = @"0";
            zoom_y = @"1200";
            zoom_scale = @"1";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"40";
                hole_y = @"150";
                hole_w = @"125";
                zoom_x = @"0";
                zoom_y = @"240";
                zoom_scale = @"1";
            }
            else
            {
                hole_x = @"40";
                hole_y = @"150";
                hole_w = @"150";
                zoom_x = @"0";
                zoom_y = @"900";
                zoom_scale = @"1";
            }
        }
        //click on barrack (302)
        NSDictionary *tutorial_step_16 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"zoom": @"yes", @"zoom_scale": zoom_scale, @"zoom_x":zoom_x, @"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"240";
            hole_w = @"1000";
            hole_h = @"100";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"260";
                hole_w = @"1000";
                hole_h = @"90";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"260";
                hole_w = @"1000";
                hole_h = @"90";
            }
        }
        // click on spearman
        NSDictionary *tutorial_step_17 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3"};
        
        NSDictionary *tutorial_step_18 = @{@"r1": NSLocalizedString(@"Add Spearmen.", nil), @"dialogPosition": @"1"};
        
        if (iPad)
        {
            hole_x = @"305";
            hole_y = @"370";
            hole_w = @"25";
            hole_h = @"25";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"245";
                hole_y = @"370";
                hole_w = @"25";
                hole_h = @"25";
            }
            else
            {
                hole_x = @"245";
                hole_y = @"370";
                hole_w = @"25";
                hole_h = @"25";
            }
        }
        // click on + 1st
        NSDictionary *tutorial_step_19 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"1"};
        
        if (iPad)
        {
            hole_x = @"305";
            hole_y = @"370";
            hole_w = @"25";
            hole_h = @"25";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"245";
                hole_y = @"370";
                hole_w = @"25";
                hole_h = @"25";
            }
            else
            {
                hole_x = @"245";
                hole_y = @"370";
                hole_w = @"25";
                hole_h = @"25";
            }
        }
        // click on + 2nd
        NSDictionary *tutorial_step_20 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"1"};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"380";
            hole_w = @"900";
            hole_h = @"80";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"300";
                hole_w = @"900";
                hole_h = @"80";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"380";
                hole_w = @"900";
                hole_h = @"80";
            }
        }
        // click on Train
        NSDictionary *tutorial_step_21 = @{@"r1": NSLocalizedString(@"Train 3 Spearmen.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"1"};
        
        if (iPad)
        {
            hole_x = @"325";
            hole_y = @"150";
            hole_w = @"70";
            zoom_x = @"0";
            zoom_y = @"-1200";
            zoom_scale = @"0";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"250";
                hole_y = @"150";
                hole_w = @"70";
                zoom_x = @"0";
                zoom_y = @"-240";
                zoom_scale = @"0";
            }
            else
            {
                hole_x = @"250";
                hole_y = @"150";
                hole_w = @"70";
                zoom_x = @"0";
                zoom_y = @"-900";
                zoom_scale = @"0";
            }
        }
        //click speedup
        NSDictionary *tutorial_step_22 = @{@"r1": NSLocalizedString(@"Time is a luxury we don't have, so boost activities when you can.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"dialogPosition": @"3", @"zoom": @"yes", @"zoom_scale": zoom_scale, @"zoom_x":zoom_x, @"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"-10";
            hole_y = @"85";
            hole_w = @"70";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-10";
                hole_y = @"100";
                hole_w = @"70";
            }
            else
            {
                hole_x = @"-10";
                hole_y = @"100";
                hole_w = @"70";
            }
        }
        //click on use on speedup item
        NSDictionary *tutorial_step_23 = @{@"r1": NSLocalizedString(@"Consume speedup items to help with the boost.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        //click on back button
        NSDictionary *tutorial_step_24 = @{@"r1": NSLocalizedString(@"Now lets build a Rally Point. Its time to rally so that they can march out of the city.", nil)};
        
        if (iPad)
        {
            hole_x = @"125";
            hole_y = @"100";
            hole_w = @"150";
            zoom_x = @"50";
            zoom_y = @"550";
            zoom_scale = @"1";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"125";
                hole_y = @"100";
                hole_w = @"125";
                zoom_x = @"50";
                zoom_y = @"240";
                zoom_scale = @"1";
            }
            else
            {
                hole_x = @"125";
                hole_y = @"100";
                hole_w = @"150";
                zoom_x = @"50";
                zoom_y = @"550";
                zoom_scale = @"1";
            }
        }
        //location = 303
        NSDictionary *tutorial_step_25 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"zoom": @"yes", @"zoom_scale": zoom_scale, @"zoom_x":zoom_x, @"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"60";
            hole_w = @"1000";
            hole_h = @"120";
        }
        else
        {
            if(self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"60";
                hole_w = @"1000";
                hole_h = @"110";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"60";
                hole_w = @"1000";
                hole_h = @"110";
            }
        }
        //rally point
        NSDictionary *tutorial_step_26 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"250";
            hole_y = @"45";
            hole_w = @"110";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"205";
                hole_y = @"45";
                hole_w = @"110";
            }
            else
            {
                hole_x = @"205";
                hole_y = @"45";
                hole_w = @"110";
            }
        }
        //highlight build button
        NSDictionary *tutorial_step_27 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"185";
            hole_y = @"55";
            hole_w = @"70";
            zoom_x = @"-50";
            zoom_y = @"-550";
            zoom_scale = @"0";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"185";
                hole_y = @"60";
                hole_w = @"70";
                zoom_x = @"-50";
                zoom_y = @"-240";
                zoom_scale = @"0";
            }
            else
            {
                hole_x = @"185";
                hole_y = @"60";
                hole_w = @"70";
                zoom_x = @"-50";
                zoom_y = @"-550";
                zoom_scale = @"0";
            }
        }
        //highlight speedup
        NSDictionary *tutorial_step_28 = @{@"r1": NSLocalizedString(@"Time is a luxury we don't have, so boost activities when you can.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"dialogPosition": @"3", @"zoom": @"yes", @"zoom_scale":zoom_scale, @"zoom_x":zoom_x, @"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"-10";
            hole_y = @"200";
            hole_w = @"70";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-10";
                hole_y = @"210";
                hole_w = @"70";
            }
            else
            {
                hole_x = @"-10";
                hole_y = @"210";
                hole_w = @"70";
            }
        }
        //click on use on speedup item 2
        NSDictionary *tutorial_step_29 = @{@"r1": NSLocalizedString(@"Consume speedup items to help with the boost.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"470";
            hole_w = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"430";
                hole_w = @"50";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"520";
                hole_w = @"50";
            }
        }
        //click on city icon
        NSDictionary *tutorial_step_30 = @{@"r1": NSLocalizedString(@"Perfect! Now lets have a look at the World.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"1", @"dialogPosition": @"2"};
        
        //click on nearest village location highlighted is by default on player's city, highlighted location will be adjusted once the location of nearest village obtained
        NSDictionary *tutorial_step_31 = @{@"r1": NSLocalizedString(@"Now lets try to find a nearby barbarian village,", nil), @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"100";
            hole_y = @"150";
            hole_w = @"150";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"90";
                hole_y = @"150";
                hole_w = @"150";
            }
            else
            {
                hole_x = @"90";
                hole_y = @"150";
                hole_w = @"150";
            }
        }
        //click on nearest village location highlighted is by default on player's city, highlighted location will be adjusted once the location of nearest village obtained
        NSDictionary *tutorial_step_32 = @{@"r1": NSLocalizedString(@"Now lets try to attack a this barbarian village, if we win we get loot, if not experience :)", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"20";
            hole_y = @"150";
            hole_w = @"170";
            hole_h = @"80";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"20";
                hole_y = @"150";
                hole_w = @"170";
                hole_h = @"80";
            }
            else
            {
                hole_x = @"20";
                hole_y = @"150";
                hole_w = @"170";
                hole_h = @"80";
            }
        }
        //click attack
        NSDictionary *tutorial_step_33 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"90";
            hole_w = @"200";
            hole_h = @"80";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-50";
                hole_y = @"90";
                hole_w = @"200";
                hole_h = @"80";
            }
            else
            {
                hole_x = @"-50";
                hole_y = @"90";
                hole_w = @"200";
                hole_h = @"80";
            }
        }
        //click Queue Max
        NSDictionary *tutorial_step_34 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};

        if (iPad)
        {
            hole_x = @"190";
            hole_y = @"90";
            hole_w = @"200";
            hole_h = @"80";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"160";
                hole_y = @"90";
                hole_w = @"200";
                hole_h = @"80";
            }
            else
            {
                hole_x = @"160";
                hole_y = @"90";
                hole_w = @"200";
                hole_h = @"80";
            }
        }
        //click Send Now
        NSDictionary *tutorial_step_35 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        
        hole_x = @"0";
        hole_y = @"0";
        hole_w = @"0";
        hole_h = @"0";
        //wait
        NSDictionary *tutorial_step_36 = @{@"r1": NSLocalizedString(@"Attacks take time, lets wait until the army returns or until the battle has concluded", nil), @"dialogPosition": @"3", @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"220";
            hole_w = @"600";
            hole_h = @"75";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"210";
                hole_w = @"600";
                hole_h = @"75";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"260";
                hole_w = @"600";
                hole_h = @"75";
            }
        }
        //click on ok on notification
        NSDictionary *tutorial_step_37 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"265";
            hole_y = @"470";
            hole_w = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"210";
                hole_y = @"430";
                hole_w = @"50";
            }
            else
            {
                hole_x = @"210";
                hole_y = @"520";
                hole_w = @"50";
            }
        }
        //click on report icon button *Mail icon for non ipad
        NSDictionary *tutorial_step_38 = @{@"r1": NSLocalizedString(@"Now that the troops have returned, lets take a look at the report", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"1"};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"20";
            hole_w = @"700";
            hole_h = @"100";
        }
        else
        {
            if(self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"20";
                hole_w = @"700";
                hole_h = @"100";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"20";
                hole_w = @"700";
                hole_h = @"100";
            }
        }
        //click on the top report
        NSDictionary *tutorial_step_39 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"175";
            hole_y = @"400";
            hole_w = @"0";
        }
        else
        {
            if(self.is_iphone)
            {
                hole_x = @"165";
                hole_y = @"390";
                hole_w = @"0";
            }
            else
            {
                hole_x = @"165";
                hole_y = @"390";
                hole_w = @"0";
            }
        }
        //scroll down to the bottom
        NSDictionary *tutorial_step_40 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"5";
            hole_y = @"470";
            hole_w = @"50";
        }
        else
        {
            if(self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"440";
                hole_w = @"50";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"530";
                hole_w = @"50";
            }
        }
        //click on map icon button
        NSDictionary *tutorial_step_41 = @{@"r1": NSLocalizedString(@"Looks like all went well, now lets see how knowledge can help grow your kingdom by building a library", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"1"};
        
        if (iPad)
        {
            hole_x = @"150";
            hole_y = @"200";
            hole_w = @"150";
            zoom_x = @"250";
            zoom_y = @"400";
            zoom_scale = @"1";
        }
        else
        {
            if(self.is_iphone)
            {
                hole_x = @"150";
                hole_y = @"200";
                hole_w = @"125";
                zoom_x = @"110";
                zoom_y = @"175";
                zoom_scale = @"1";
            }
            else
            {
                hole_x = @"150";
                hole_y = @"200";
                hole_w = @"150";
                zoom_x = @"125";
                zoom_y = @"225";
                zoom_scale = @"1";
            }
        }
        //click on location = 303
        NSDictionary *tutorial_step_42 =  @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"zoom": @"yes", @"zoom_scale": zoom_scale, @"zoom_x":zoom_x, @"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"10";
            hole_y = @"50";
            hole_w = @"1000";
            hole_h = @"135";
        }
        else
        {
            if(self.is_iphone)
            {
                hole_x = @"10";
                hole_y = @"50";
                hole_w = @"1000";
                hole_h = @"135";
            }
            else
            {
                hole_x = @"10";
                hole_y = @"50";
                hole_w = @"1000";
                hole_h = @"135";
            }
        }
        //click on library
        NSDictionary *tutorial_step_43 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"250";
            hole_y = @"45";
            hole_w = @"110";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"205";
                hole_y = @"45";
                hole_w = @"110";
            }
            else
            {
                hole_x = @"205";
                hole_y = @"45";
                hole_w = @"110";
            }
        }
        //click build
        NSDictionary *tutorial_step_44 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"185";
            hole_y = @"55";
            hole_w = @"70";
            zoom_x = @"-250";
            zoom_y = @"-400";
            zoom_scale = @"0";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"185";
                hole_y = @"60";
                hole_w = @"70";
                zoom_x = @"-110";
                zoom_y = @"-175";
                zoom_scale = @"0";
            }
            else
            {
                hole_x = @"185";
                hole_y = @"60";
                hole_w = @"70";
                zoom_x = @"-125";
                zoom_y = @"-225";
                zoom_scale = @"0";
            }
        }
        //click speedup
        NSDictionary *tutorial_step_45 = @{@"r1": NSLocalizedString(@"Time is a luxury we don't have, so boost activities when you can.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3", @"zoom": @"yes", @"zoom_scale": zoom_scale, @"zoom_x":zoom_x, @"zoom_y":zoom_y};
        
        if (iPad)
        {
            hole_x = @"-10";
            hole_y = @"200";
            hole_w = @"70";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-10";
                hole_y = @"210";
                hole_w = @"70";
            }
            else
            {
                hole_x = @"-10";
                hole_y = @"210";
                hole_w = @"70";
            }
        }
        //click on use on speedup item 2
        NSDictionary *tutorial_step_46 = @{@"r1": NSLocalizedString(@"Consume speedup items to help with the boost.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"320";
            hole_y = @"470";
            hole_w = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"270";
                hole_y = @"435";
                hole_w = @"40";
            }
            else
            {
                hole_x = @"260";
                hole_y = @"515";
                hole_w = @"50";
            }
        }
        //click on more icon
        NSDictionary *tutorial_step_47 = @{@"r1": NSLocalizedString(@"Now that you have books and researchers, you can start doing research better food production", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"1", @"dialogPosition": @"1"};
        
        if (iPad)
        {
            hole_x = @"105";
            hole_y = @"170";
            hole_w = @"75";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"80";
                hole_y = @"185";
                hole_w = @"75";
            }
            else
            {
                hole_x = @"85";
                hole_y = @"190";
                hole_w = @"75";
            }
        }
        //click on research icon
        NSDictionary *tutorial_step_48 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"2"};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"230";
            hole_w = @"700";
            hole_h = @"100";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"250";
                hole_w = @"700";
                hole_h = @"100";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"250";
                hole_w = @"700";
                hole_h = @"100";
            }

        }
        //click on economic tech
        NSDictionary *tutorial_step_49 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"80";
            hole_w = @"700";
            hole_h = @"100";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"80";
                hole_w = @"700";
                hole_h = @"100";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"80";
                hole_w = @"700";
                hole_h = @"100";
            }
            
        }
        //click on food icon
        NSDictionary *tutorial_step_50 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"175";
            hole_y = @"400";
            hole_w = @"0";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"175";
                hole_y = @"400";
                hole_w = @"0";
            }
            else
            {
                hole_x = @"175";
                hole_y = @"400";
                hole_w = @"0";
            }
        }
        //scroll to research button
        NSDictionary *tutorial_step_51 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"320";
            hole_w = @"700";
            hole_h = @"100";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"300";
                hole_w = @"700";
                hole_h = @"100";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"390";
                hole_w = @"700";
                hole_h = @"100";
            }
            
        }
        //click on research button
        NSDictionary *tutorial_step_52 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"1"};
        
        //click back
        NSDictionary *tutorial_step_53 = @{@"r1": NSLocalizedString(@"After this our workers can produce more food, more food means a bigger army :)", nil), @"arrowPosition": @"2"};
        
        if (iPad)
        {
            hole_x = @"185";
            hole_y = @"55";
            hole_w = @"70";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"185";
                hole_y = @"60";
                hole_w = @"70";
            }
            else
            {
                hole_x = @"185";
                hole_y = @"60";
                hole_w = @"70";
            }
        }
        //click speedup
        NSDictionary *tutorial_step_54 = @{@"r1": NSLocalizedString(@"Most activities can be sped up, lets do the same for this research", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"-10";
            hole_y = @"200";
            hole_w = @"70";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-10";
                hole_y = @"210";
                hole_w = @"70";
            }
            else
            {
                hole_x = @"-10";
                hole_y = @"210";
                hole_w = @"70";
            }
        }
        //click on use on speedup item 2
        NSDictionary *tutorial_step_55 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"arrowPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"470";
            hole_w = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"430";
                hole_w = @"50";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"520";
                hole_w = @"50";
            }
        }
        //click on use on city icon
        NSDictionary *tutorial_step_56 = @{@"r1": NSLocalizedString(@"Now that you have extra food, lets get another village under your control", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"1", @"dialogPosition": @"2"};
        
        //click on nearest village location highlighted is by default on player's city, highlighted location will be adjusted once the location of nearest village obtained
        NSDictionary *tutorial_step_57 = @{@"r1": NSLocalizedString(@"Now lets try to find a nearby barbarian village,", nil), @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"100";
            hole_y = @"150";
            hole_w = @"150";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"90";
                hole_y = @"150";
                hole_w = @"150";
            }
            else
            {
                hole_x = @"90";
                hole_y = @"150";
                hole_w = @"150";
            }
        }
        //click on nearest village location highlighted is by default on player's city, highlighted location will be adjusted once the location of nearest village obtained
        NSDictionary *tutorial_step_58 = @{@"r1": NSLocalizedString(@"Lets see if we can capture this village", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"25";
            hole_y = @"200";
            hole_w = @"400";
            hole_h = @"80";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"200";
                hole_w = @"400";
                hole_h = @"80";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"200";
                hole_w = @"400";
                hole_h = @"80";
            }
        }
        //click capture
        NSDictionary *tutorial_step_59 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"200";
            hole_y = @"270";
            hole_w = @"180";
            hole_h = @"75";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"150";
                hole_y = @"250";
                hole_w = @"180";
                hole_h = @"75";
            }
            else
            {
                hole_x = @"150";
                hole_y = @"300";
                hole_w = @"180";
                hole_h = @"75";
            }
        }
        //click Proceed
        NSDictionary *tutorial_step_60 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"90";
            hole_w = @"200";
            hole_h = @"80";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-50";
                hole_y = @"90";
                hole_w = @"200";
                hole_h = @"80";
            }
            else
            {
                hole_x = @"-50";
                hole_y = @"90";
                hole_w = @"200";
                hole_h = @"80";
            }
        }
        //click Queue Max
        NSDictionary *tutorial_step_61 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"190";
            hole_y = @"90";
            hole_w = @"200";
            hole_h = @"80";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"160";
                hole_y = @"90";
                hole_w = @"200";
                hole_h = @"80";
            }
            else
            {
                hole_x = @"160";
                hole_y = @"90";
                hole_w = @"200";
                hole_h = @"80";
            }
        }
        //click Send Now
        NSDictionary *tutorial_step_62 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        hole_x = @"0";
        hole_y = @"0";
        hole_w = @"0";
        hole_h = @"0";
        //wait
        NSDictionary *tutorial_step_63 = @{@"r1": NSLocalizedString(@"As usual Attacks take time, but for captures, the army wont be returning back", nil), @"dialogPosition": @"3", @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h};
        
        if (iPad)
        {
            hole_x = @"0";
            hole_y = @"220";
            hole_w = @"600";
            hole_h = @"75";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"210";
                hole_w = @"600";
                hole_h = @"75";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"260";
                hole_w = @"600";
                hole_h = @"75";
            }
        }
        //click ok on z
        NSDictionary *tutorial_step_64 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"5";
            hole_y = @"470";
            hole_w = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"0";
                hole_y = @"430";
                hole_w = @"50";
            }
            else
            {
                hole_x = @"0";
                hole_y = @"520";
                hole_w = @"50";
            }
        }
        //click map icon
        NSDictionary *tutorial_step_65 = @{@"r1": NSLocalizedString(@"Now that you have another village, lets visit it", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"1", @"dialogPosition": @"2"};
        
        if (iPad)
        {
            hole_x = @"175";
            hole_y = @"0";
            hole_w = @"100";
            hole_h = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"125";
                hole_y = @"0";
                hole_w = @"100";
                hole_h = @"50";
            }
            else
            {
                hole_x = @"125";
                hole_y = @"0";
                hole_w = @"100";
                hole_h = @"50";
            }
        }
        //click on citiList icon
        NSDictionary *tutorial_step_66 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w,@"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"260";
            hole_y = @"240";
            hole_w = @"140";
            hole_h = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"220";
                hole_y = @"240";
                hole_w = @"140";
                hole_h = @"50";
            }
            else
            {
                hole_x = @"220";
                hole_y = @"240";
                hole_w = @"140";
                hole_h = @"50";
            }
        }
        //click on view village
        NSDictionary *tutorial_step_67 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"105";
            hole_y = @"470";
            hole_w = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"105";
                hole_y = @"430";
                hole_w = @"50";
            }
            else
            {
                hole_x = @"105";
                hole_y = @"520";
                hole_w = @"50";
            }
        }
        //click on alliance icon
        NSDictionary *tutorial_step_68 = @{@"r1": NSLocalizedString(@"Having another village increases your power but in preparing you for the big world, I recommend you look at alliances to help you grow.", nil), @"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"arrowPosition": @"1", @"dialogPosition": @"2"};
        
        
        //close tab
        //NSDictionary *tutorial_step_69 = @{@"r1": @"As alliances involves politics, you might want to ponder about which alliance you want to join and look at it later",@"dialogPosition": @"2"};
        NSDictionary *tutorial_step_69 = @{@"r1": NSLocalizedString(@"Before I leave you there is one important thing to show you, lets cast a protection spell on our capital city", nil), @"dialogPosition": @"2"};
        
        if (iPad)
        {
            hole_x = @"175";
            hole_y = @"0";
            hole_w = @"100";
            hole_h = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"125";
                hole_y = @"0";
                hole_w = @"100";
                hole_h = @"50";
            }
            else
            {
                hole_x = @"125";
                hole_y = @"0";
                hole_w = @"100";
                hole_h = @"50";
            }
        }
        //click on citiList icon
        NSDictionary *tutorial_step_70 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w,@"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"260";
            hole_y = @"150";
            hole_w = @"140";
            hole_h = @"50";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"220";
                hole_y = @"150";
                hole_w = @"140";
                hole_h = @"50";
            }
            else
            {
                hole_x = @"220";
                hole_y = @"150";
                hole_w = @"140";
                hole_h = @"50";
            }
        }
        //click on protect captial city
        NSDictionary *tutorial_step_71 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"hole_w": hole_w, @"hole_h": hole_h, @"arrowPosition": @"3", @"dialogPosition": @"3"};
        
        if (iPad)
        {
            hole_x = @"-10";
            hole_y = @"100";
            hole_w = @"70";
        }
        else
        {
            if (self.is_iphone)
            {
                hole_x = @"-10";
                hole_y = @"110";
                hole_w = @"70";
            }
            else
            {
                hole_x = @"-10";
                hole_y = @"110";
                hole_w = @"70";
            }
        }
        //click on use on speedup item 1
        NSDictionary *tutorial_step_72 = @{@"hole_x": hole_x, @"hole_y": hole_y, @"arrowPosition": @"3"};

        NSDictionary *tutorial_step_last = @{@"r1": NSLocalizedString(@"Its always great to be able to serve you Sire, however I have other urgent matters to attend for now. The people need you, fulfill their needs and your empire will grow. I wish you all the best!", nil)};
        
        self.tutorial_array = [@[tutorial_step_0,tutorial_step_1, tutorial_step_2, tutorial_step_3, tutorial_step_4, tutorial_step_5, tutorial_step_6, tutorial_step_7, tutorial_step_8,tutorial_step_9,tutorial_step_10,tutorial_step_11,tutorial_step_12,tutorial_step_13,tutorial_step_14, tutorial_step_15,tutorial_step_16,tutorial_step_17,tutorial_step_18, tutorial_step_19, tutorial_step_20, tutorial_step_21,tutorial_step_22,tutorial_step_23, tutorial_step_24,tutorial_step_25,tutorial_step_26,tutorial_step_27,tutorial_step_28,tutorial_step_29, tutorial_step_30,tutorial_step_31,tutorial_step_32,tutorial_step_33,tutorial_step_34,tutorial_step_35,tutorial_step_36,tutorial_step_37,tutorial_step_38,tutorial_step_39,tutorial_step_40,tutorial_step_41,tutorial_step_42,tutorial_step_43,tutorial_step_44,tutorial_step_45,tutorial_step_46,tutorial_step_47,tutorial_step_48,tutorial_step_49,tutorial_step_50,tutorial_step_51,tutorial_step_52,tutorial_step_53,tutorial_step_54,tutorial_step_55,tutorial_step_56,tutorial_step_57,tutorial_step_58,tutorial_step_59,tutorial_step_60,tutorial_step_61,tutorial_step_62,tutorial_step_63,tutorial_step_64,tutorial_step_65,tutorial_step_66,tutorial_step_67,tutorial_step_68, tutorial_step_69,tutorial_step_70,tutorial_step_71,tutorial_step_72,tutorial_step_last] mutableCopy];
        
        //[self tutorial_step_set:0];
    }
    
    NSInteger int_step = [self get_current_tutorial_step];
    
    NSDictionary *current_tutorial_dictionary = nil;
    
    if (int_step < self.tutorial_array.count)
    {
        current_tutorial_dictionary = self.tutorial_array[int_step];
    }
    
    return current_tutorial_dictionary;
}

//The event handling method
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    if (![UIManager.i is_loading])
    {
        CGPoint location = [recognizer locationInView:[recognizer.view superview]];
        
        NSLog(@"handleTap in Tutorial at : %@", NSStringFromCGPoint(location));
        
        if (self.isDialogBoxClickable)
        {
            [self dialogBoxClicked:recognizer];
        }
        else
        {
            [self tutorialClicked:recognizer];
        }
    }
    else
    {
        NSLog(@"tutorial tap ignored");
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    NSLog(@"Event :%@",event);

    return YES;
}

- (void)drawRect:(CGRect)rect
{
    [self.backgroundColor setFill];
    UIRectFill(rect);
    
    self.hole_rect = CGRectMake(self.hole_x, self.hole_y, self.hole_w, self.hole_h);
    CGRect holeRectIntersection = CGRectIntersection( self.hole_rect, rect );
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ( CGRectIntersectsRect( holeRectIntersection, rect ) )
    {
        CGContextAddEllipseInRect(context, holeRectIntersection);
        CGContextClip(context);
        CGContextClearRect(context, holeRectIntersection);
        CGContextSetFillColorWithColor( context, [UIColor clearColor].CGColor );
        CGContextFillRect( context, holeRectIntersection);
    }
}

- (void)updateView
{
    self.current_tutorial = [self get_current_tutorial];
    
    if (self.current_tutorial != nil)
    {
        [self clearView];
        
        [self drawView];
        
        if (self.current_tutorial[@"zoom"] != nil)
        {
            [self zoomBaseView];
        }
    }
    else
    {
        [Globals.i tutorial_off];
        
        [Globals.i trackEvent:@"Tutorial" action:@"CompletedTutorial" label:Globals.i.wsWorldProfileDict[@"uid"]];
        
        [self removeFromSuperview];
    }
}

- (void)clearView
{
    [self.iv_arrow removeFromSuperview];
    [self.iv_arrow_g removeFromSuperview];
    [self.iv_bg removeFromSuperview];
    [self.iv_char removeFromSuperview];
    [self.btn_next removeFromSuperview];
    [self.lbl_text removeFromSuperview];
}

- (void)drawView
{
    CGFloat spacing = 5.0f*SCALE_IPAD;
    CGFloat spacing2 = spacing*2;
    
    //draw hole if hole coordinate is available
    if (self.current_tutorial[@"hole_x"] != nil)
    {
        self.isDialogBoxClickable = NO;
        
        self.hole_x = [self.current_tutorial[@"hole_x"] floatValue]*SCALE_IPAD;
        self.hole_y = [self.current_tutorial[@"hole_y"] floatValue]*SCALE_IPAD;
        
        if (self.current_tutorial[@"hole_w"] != nil)
        {
            self.hole_w = [self.current_tutorial[@"hole_w"] floatValue]*SCALE_IPAD;
        }
        else
        {
            self.hole_w = 90.0f*SCALE_IPAD;
        }
        
        if (self.hole_w > UIScreen.mainScreen.bounds.size.width)
        {
            self.hole_w = UIScreen.mainScreen.bounds.size.width;
        }
        
        self.hole_h = self.hole_w;
        
        if (self.current_tutorial[@"hole_h"] != nil)
        {
            self.hole_h = [self.current_tutorial[@"hole_h"] floatValue]*SCALE_IPAD;
        }
        
        if (self.hole_h > UIScreen.mainScreen.bounds.size.height)
        {
            self.hole_h = UIScreen.mainScreen.bounds.size.height;
        }
    }
    else
    {
        self.isDialogBoxClickable = YES;
        
        self.hole_x = 0.0f;
        self.hole_y = 0.0f;
        self.hole_w = 0.0f;
        self.hole_h = 0.0f;
    }
    
    [self setNeedsDisplay];
    
    CGFloat dialog_width = UIScreen.mainScreen.bounds.size.width;
    CGFloat dialog_height = 200.0f*SCALE_IPAD;
    CGFloat dialog_x = 0.0f;
    CGFloat dialog_y = 0.0f;
    
    if (self.current_tutorial[@"dialogPosition"] != nil)
    {
        self.dialogPosition = [self.current_tutorial[@"dialogPosition"] integerValue];
    }
    else
    {
        self.dialogPosition = 4;
    }
    
    if (self.dialogPosition == 1)
    {
        //TOP
        dialog_y = 0.0f;
    }
    else if (self.dialogPosition == 2)
    {
        //Middle
        dialog_y = (UIScreen.mainScreen.bounds.size.height - dialog_height) / 2;
    }
    else if (self.dialogPosition == 3)
    {
        //Botton
        dialog_y = (UIScreen.mainScreen.bounds.size.height - dialog_height);
    }
    else
    {
        dialog_y = (UIScreen.mainScreen.bounds.size.height - dialog_height) / 2;
    }
    
    NSString *arrow_image_name = @"tut_arrow_up";
    CGFloat arrow_size = 80.0f*SCALE_IPAD;
    CGFloat arrow_x = self.hole_x - arrow_size/2;
    CGFloat arrow_y = self.hole_y - arrow_size/2;
    
    if (self.current_tutorial[@"arrowPosition"] != nil)
    {
        self.arrowPosition = [self.current_tutorial[@"arrowPosition"] integerValue];
    }
    else
    {
        self.arrowPosition = 4;
    }
    
    if (self.arrowPosition == 1)
    {
        arrow_image_name = @"tut_arrow_down";
        arrow_x = self.hole_x + ((self.hole_w - arrow_size)/2);
        arrow_y = self.hole_y - arrow_size;
    }
    else if (self.arrowPosition == 2)
    {
        arrow_image_name = @"tut_arrow_right";
        arrow_x = self.hole_x - arrow_size;
        arrow_y = self.hole_y + ((self.hole_h - arrow_size)/2);
    }
    else if (self.arrowPosition == 3)
    {
        arrow_image_name = @"tut_arrow_up";
        arrow_x = self.hole_x + ((self.hole_w - arrow_size)/2);
        arrow_y = self.hole_y + self.hole_h;
    }
    else
    {
        //No arrow
    }
    
    //Show arrow in highlighted area
    if (!self.isDialogBoxClickable && (self.arrowPosition <= 3))
    {
        self.iv_arrow_g = [[UIImageView alloc] initWithFrame:CGRectMake(arrow_x, arrow_y, arrow_size, arrow_size)];
        
        NSMutableArray *images = [[NSMutableArray alloc] init];
        [images addObject:[Globals.i imageNamedCustom:[NSString stringWithFormat:@"%@_g", arrow_image_name]]];
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
        UIImage *blank = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [images addObject:blank];
        
        self.iv_arrow_g.animationImages = images;
        self.iv_arrow_g.animationDuration = 1;
        [self addSubview:self.iv_arrow_g];
        [self.iv_arrow_g startAnimating];
        
        self.iv_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(arrow_x, arrow_y, arrow_size, arrow_size)];
        [self.iv_arrow setImage:[UIManager.i colorImage:arrow_image_name :[UIColor greenColor]]];
        [self addSubview:self.iv_arrow];
    }
    
    if (self.current_tutorial[@"r1"] != nil)
    {
        self.text = self.current_tutorial[@"r1"];
        
        CGFloat bg_width = dialog_width;
        CGFloat bg_height = 100.0f*SCALE_IPAD;
        CGFloat bg_y = dialog_y + 14.0f*SCALE_IPAD;
        CGFloat bg_x = dialog_x;
        
        CGRect bkg_frame = CGRectMake(bg_x, bg_y, bg_width, bg_height);
        UIImage *bkg_image = [UIManager.i dynamicImage:bkg_frame prefix:@"bkg5"];
        self.iv_bg = [[UIImageView alloc] initWithFrame:bkg_frame];
        [self.iv_bg setImage:bkg_image];
        [self addSubview:self.iv_bg];
        
        CGFloat char_width = 98.0f*SCALE_IPAD;
        CGFloat char_height = 114.0f*SCALE_IPAD;
        
        self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(dialog_x, dialog_y, char_width, char_height)];
        [self.iv_char setImage:[Globals.i imageNamedCustom:@"char_dialog"]];
        [self addSubview:self.iv_char];
        
        CGFloat lbl_height = bg_height;
        CGFloat lbl_width = bg_width-char_width-spacing;
        CGFloat lbl_y = bg_y+spacing2;
        
        if (self.isDialogBoxClickable)
        {
            CGFloat btn_width = 100.0f*SCALE_IPAD;
            CGFloat btn_height = 30.0f*SCALE_IPAD;
            
            lbl_height = bg_height - btn_height;
            
            CGRect btn_frame = CGRectMake(bg_width-btn_width, bg_y+lbl_height, btn_width, btn_height);
            
            self.btn_next = [[UIButton alloc] init];
            [self.btn_next setFrame:btn_frame];
            self.btn_next.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
            [self.btn_next setTitle:@"CONTINUE" forState:UIControlStateNormal];
            [self.btn_next addTarget:self action:@selector(dialogBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
            //[self.btn_next addTarget:self action:@selector(dialogBoxClicked:) forControlEvents:UIControlEventAllTouchEvents];
            [self addSubview:self.btn_next];
        }
        
        
        CGRect lbl_frame = CGRectMake(char_width, lbl_y, lbl_width, lbl_height-spacing);
        self.lbl_text = [[UILabel alloc] initWithFrame:lbl_frame];
        [self.lbl_text setFont:[UIFont fontWithName:DEFAULT_FONT size:SMALL_FONT_SIZE]];
        [self.lbl_text setTextColor:[UIColor blackColor]];
        [self.lbl_text setMinimumScaleFactor:0.5f];
        [self addSubview:self.lbl_text];
        
        [self.lbl_text setText:self.text];
        [self.lbl_text setNumberOfLines:0];
        [self.lbl_text sizeToFit];
    }
}

- (void)zoomBaseView
{
    //[[NSNotificationCenter defaultCenter] postNotificationName:self.current_tutorial[@"not"] object:self];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:[NSNumber numberWithInteger:[self get_current_tutorial_step]]  forKey:@"tutorial_step"];
    if (self.current_tutorial[@"zoom_x"]!=nil && self.current_tutorial[@"zoom_y"]!=nil && self.current_tutorial[@"zoom_scale"]!=nil)
    {
        [userInfo setObject:self.current_tutorial[@"zoom_x"]  forKey:@"zoom_x"];
        [userInfo setObject:self.current_tutorial[@"zoom_y"]  forKey:@"zoom_y"];
        [userInfo setObject:self.current_tutorial[@"zoom_scale"]  forKey:@"zoom_scale"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Zoom_BaseView"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)dialogBoxClicked:(id)sender
{
    NSLog(@"dialogBoxClicked");
    if (!self.hasClickedInCurrentTutorialStep)
    {
        [Globals.i play_button];
        self.hasClickedInCurrentTutorialStep = true;
        
        NSLog(@"dialogBoxClicked2");
        NSInteger step = [self get_current_tutorial_step];
        if (step == 24)
        {
            //click on back button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:24]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseAllTemplate"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 31)
        {
            //get nearest village
            [Globals.i getNearestVillage:[Globals.i.wsBaseDict[@"map_x"] integerValue]:[Globals.i.wsBaseDict[@"map_y"] integerValue]:^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     NSMutableArray *returnArray = [Globals.i customParser:data];
                     
                     if (returnArray.count > 0)
                     {
                         //NSLog(@"CenterOnTile Village map x : %ld",[villageData[0][@"map_x"] integerValue]);
                         //NSLog(@"CenterOnTile Village map x : %ld",[villageData[0][@"map_y"] integerValue]);
                         //center on neareset village
                         NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                         [userInfo setObject:[NSNumber numberWithInteger:31]  forKey:@"tutorial_step"];
                         [userInfo setObject:[NSNumber numberWithInteger:[returnArray[0][@"map_x"] integerValue]]  forKey:@"coordinate_x"];
                         [userInfo setObject:[NSNumber numberWithInteger:[returnArray[0][@"map_y"] integerValue]]  forKey:@"coordinate_y"];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"CenterOnTile"
                                                                             object:self
                                                                           userInfo:userInfo];
                         
                         userInfo = [[NSMutableDictionary alloc] init];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                             object:self
                                                                           userInfo:userInfo];
                     }
                     else
                     {
                         NSLog(@"WARNING: GetNearestVillage return empty array!");
                     }
                     
                 }
             }];
            
        }
        else if (step == 53)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:53]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseAllTemplate"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 57)
        {
            //get nearest village
            [Globals.i getNearestVillage:[Globals.i.wsBaseDict[@"map_x"] integerValue]:[Globals.i.wsBaseDict[@"map_y"] integerValue]:^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     NSMutableArray *returnArray = [Globals.i customParser:data];
                     
                     if (returnArray.count > 0)
                     {
                         //NSLog(@"CenterOnTile Village map x : %ld",[villageData[0][@"map_x"] integerValue]);
                         //NSLog(@"CenterOnTile Village map x : %ld",[villageData[0][@"map_y"] integerValue]);
                         //center on neareset village
                         NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                         [userInfo setObject:[NSNumber numberWithInteger:57]  forKey:@"tutorial_step"];
                         [userInfo setObject:[NSNumber numberWithInteger:[returnArray[0][@"map_x"] integerValue]]  forKey:@"coordinate_x"];
                         [userInfo setObject:[NSNumber numberWithInteger:[returnArray[0][@"map_y"] integerValue]]  forKey:@"coordinate_y"];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"CenterOnTile"
                                                                             object:self
                                                                           userInfo:userInfo];
                         
                         userInfo = [[NSMutableDictionary alloc] init];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                             object:self
                                                                           userInfo:userInfo];
                     }
                     else
                     {
                         NSLog(@"WARNING: GetNearestVillage return empty array!");
                     }
                     
                 }
             }];
            
        }
        else if (step == 69)
        {
            double delayInSeconds = 3;
            dispatch_time_t nextTutorialTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(nextTutorialTime, dispatch_get_main_queue(), ^(void){
                //click on back button
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:[NSNumber numberWithInteger:69]  forKey:@"tutorial_step"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseAllTemplate"
                                                                    object:self
                                                                  userInfo:userInfo];
                
                userInfo = [[NSMutableDictionary alloc] init];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                    object:self
                                                                  userInfo:userInfo];
            });
            
            
        }
        else
        {
            double delayInSeconds = 1;
            dispatch_time_t nextTutorialTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(nextTutorialTime, dispatch_get_main_queue(), ^(void){
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                    object:self
                                                                  userInfo:userInfo];
            });
        }
    }
}

- (void)tutorialClicked:(id)sender
{
    //NO need to call tutorialStepCompleted here (assume if there is no action, its a dialog box
    NSLog(@"tutorialClicked 1");
    //[Globals.i play_button];
    if (!self.hasClickedInCurrentTutorialStep)
    {
        self.hasClickedInCurrentTutorialStep = true;
        
        NSLog(@"tutorialClicked 2");
        
        NSInteger step = [self get_current_tutorial_step];
        if (step == 0)
        {
            
        }
        else if (step == 1)
        {
            
        }
        else if (step == 2)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:2] forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:201] forKey:@"building_location"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildList"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 3)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:3]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"building_section"];
            [userInfo setObject:[NSNumber numberWithInteger:0] forKey:@"building_index"];//Assume its Farm
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseBuilding"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 4)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:4] forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BuildBuilding"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 5)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:5]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PressSpeedUpButtonForBuild"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 6)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:0] forKey:@"item_row"];
            [userInfo setObject:[NSNumber numberWithInteger:6]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UseItem"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 7)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:7]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowQuestButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 8)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:8]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClaimFirstReward"
                                                                object:self
                                                              userInfo:userInfo];
            
            
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 9)
        {

        }
        else if (step == 10)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:10]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:302] forKey:@"building_location"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildList"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 11)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:11]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"building_section"];
            [userInfo setObject:[NSNumber numberWithInteger:3] forKey:@"building_index"];//Assume its Barrack
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseBuilding"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 12)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:12]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BuildBuilding"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 13)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:13]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PressSpeedUpButtonForBuild"
                                                                object:self
                                                              userInfo:userInfo];
            
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 14)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:14]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"item_row"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UseItem"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 15)
        {

        }
        else if (step == 16)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:16]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:302] forKey:@"building_location"];//assume barrack
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildList"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 17)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:17]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:0] forKey:@"troop_section"];
            [userInfo setObject:[NSNumber numberWithInteger:2] forKey:@"troop_index"];//Assume its spearman Point
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseTroop"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 18)
        {
           
        }
        else if (step == 19)
        {
            //Click + button
            
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:19]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddTroop"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 20)
        {
            //Click + button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:20]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AddTroop"
                                                                object:self
                                                              userInfo:userInfo];
            
            if (self.is_iphone)
            {
                //scroll to train button
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:[NSNumber numberWithInteger:20]  forKey:@"tutorial_step"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToTrainButton"
                                                                    object:self
                                                                  userInfo:userInfo];
            }
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 21)
        {
            //Click Trainbutton
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:21]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TrainTroop"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 22)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:22]  forKey:@"tutorial_step"]; 
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PressSpeedUpButtonForTrainA"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 23)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:23]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:0] forKey:@"item_row"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UseItem"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 24)
        {

        }
        else if (step == 25)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:25]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:303] forKey:@"building_location"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildList"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 26)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:26]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"building_section"];
            [userInfo setObject:[NSNumber numberWithInteger:0] forKey:@"building_index"];//Assume its Rally Point
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseBuilding"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 27)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:27]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BuildBuilding"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 28)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:28]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PressSpeedUpButtonForBuild"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 29)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:29]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"item_row"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UseItem"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 30)
        {
            //click on city icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:30]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowMapButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 31)
        {

        }
        else if (step == 32)
        {
            [Globals.i getNearestVillage:[Globals.i.wsBaseDict[@"map_x"] integerValue]:[Globals.i.wsBaseDict[@"map_y"] integerValue]:^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     NSMutableArray *returnArray = [Globals.i customParser:data];
                     
                     if (returnArray.count > 0)
                     {
                         //NSLog(@"SelectTile Village map x : %ld",[villageData[0][@"map_x"] integerValue]);
                         //NSLog(@"SelectTile Village map x : %ld",[villageData[0][@"map_y"] integerValue]);
                         //click on neareset village
                         
                         /*
                          //NOT used, comments on "SelectTile" on TileView.m
                         NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                         [userInfo setObject:[NSNumber numberWithInteger:32]  forKey:@"tutorial_step"];
                         [userInfo setObject:[NSNumber numberWithInteger:[villageData[0][@"map_x"] integerValue]]  forKey:@"coordinate_x"];
                         [userInfo setObject:[NSNumber numberWithInteger:[villageData[0][@"map_y"] integerValue]]  forKey:@"coordinate_y"];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectTile"
                                                                             object:self
                                                                           userInfo:userInfo];
                         */
                         
                         //DONT KNOW WHY, raising notification TileSelected results in a long delay until the actual dialog is shown, this way it shows following the specified delay
                         double delayInSeconds = 1;
                         dispatch_time_t nextTutorialTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(nextTutorialTime, dispatch_get_main_queue(), ^(void){
                             NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                             [userInfo setObject:[NSNumber numberWithInteger:32]  forKey:@"tutorial_step"];
                             [userInfo setObject:[NSNumber numberWithInteger:[returnArray[0][@"map_x"] integerValue]]forKey:@"tile_x"];
                             [userInfo setObject:[NSNumber numberWithInteger:[returnArray[0][@"map_y"] integerValue]] forKey:@"tile_y"];
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"TileSelected"
                                                                                 object:self
                                                                               userInfo:userInfo];
                             
                             
                             userInfo = [[NSMutableDictionary alloc] init];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                                 object:self
                                                                               userInfo:userInfo];
                         });
                     }
                     else
                     {
                         NSLog(@"WARNING: GetNearestVillage return empty array!");
                     }
                     
                 }
             }];
        }
        else if (step == 33)
        {
            //click on attack button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:33]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AttackVillage"
                                                                object:self
                                                              userInfo:userInfo];

            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 34)
        {
            //click on queue max button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:34]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QueueMaxForAttack"
                                                                object:self
                                                              userInfo:userInfo];
            
             userInfo = [[NSMutableDictionary alloc] init];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
             object:self
             userInfo:userInfo];
        }
        else if (step == 35)
        {
            //click on send now button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:35]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendAttackNow"
                                                                object:self
                                                              userInfo:userInfo];
            
             userInfo = [[NSMutableDictionary alloc] init];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
             object:self
             userInfo:userInfo];
            
        }
        else if(step == 36)
        {
            
        }
        else if (step == 37)
        {
            //click ok
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:37]  forKey:@"tutorial_step"];
            [userInfo setObject:@"TroopsReturned"  forKey:@"template_title"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickCloseTemplateButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 38)
        {
            //IPAD has a different UI design/flow
            if (iPad)
            {
                //click on report icon
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:[NSNumber numberWithInteger:38]  forKey:@"tutorial_step"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowReportButton"
                                                                    object:self
                                                                  userInfo:userInfo];
                
                userInfo = [[NSMutableDictionary alloc] init];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                    object:self
                                                                  userInfo:userInfo];
            }
            else
            {
                //click on mail icon
                NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
                [userInfo setObject:[NSNumber numberWithInteger:38]  forKey:@"tutorial_step"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowMailButtonThenReportTab"
                                                                    object:self
                                                                  userInfo:userInfo];
                
                userInfo = [[NSMutableDictionary alloc] init];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                    object:self
                                                                  userInfo:userInfo];
            }
        }
        else if (step == 39)
        {
            //click on top report
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:39]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:0]  forKey:@"report_index"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseReport"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 40)
        {
            //scroll to bottom
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:40]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToBottom"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 41)
        {
            //click on map icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:41]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowCityButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 42)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:42]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:304] forKey:@"building_location"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildList"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 43)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:43]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"building_section"];
            [userInfo setObject:[NSNumber numberWithInteger:0] forKey:@"building_index"];//Assume its Library
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseBuilding"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 44)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:44]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BuildBuilding"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 45)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:45]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PressSpeedUpButtonForBuild"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 46)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:46]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"item_row"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UseItem"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 47)
        {
            //click on city icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:47]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowMoreButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 48)
        {
            //click on research icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:48]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickResearchButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 49)
        {
            //click on economic
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:49]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"tech_area"];//starts at 0
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseTechArea"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 50)
        {
            //click on food
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:50]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"tech_area"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"tech"];//starts at 1
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseTech"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 51)
        {
            //scroll to research button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:51]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollToResearchTech"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 52)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:52]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ResearchTech"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 53)
        {

        }
        else if (step == 54)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:54]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PressSpeedUpButtonForResearch"
                                                                object:self
                                                              userInfo:userInfo];
            
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 55)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:5]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"item_row"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UseItem"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 56)
        {
            //click on city icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:56]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowMapButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 57)
        {

        }
        else if (step == 58)
        {
            [Globals.i getNearestVillage:[Globals.i.wsBaseDict[@"map_x"] integerValue]:[Globals.i.wsBaseDict[@"map_y"] integerValue]:^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     NSMutableArray *returnArray = [Globals.i customParser:data];
                     
                     if (returnArray.count > 0)
                     {
                         //DONT KNOW WHY, raising notification TileSelected results in a long delay until the actual dialog is shown, this way it shows following the specified delay
                         double delayInSeconds = 0.1;
                         dispatch_time_t nextTutorialTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                         dispatch_after(nextTutorialTime, dispatch_get_main_queue(), ^(void){
                             NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                             [userInfo setObject:[NSNumber numberWithInteger:58]  forKey:@"tutorial_step"];
                             [userInfo setObject:[NSNumber numberWithInteger:[returnArray[0][@"map_x"] integerValue]]forKey:@"tile_x"];
                             [userInfo setObject:[NSNumber numberWithInteger:[returnArray[0][@"map_y"] integerValue]] forKey:@"tile_y"];
                             
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"TileSelected"
                                                                                 object:self
                                                                               userInfo:userInfo];
                             
                             
                             userInfo = [[NSMutableDictionary alloc] init];
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                                 object:self
                                                                               userInfo:userInfo];
                         });
                     }
                     else
                     {
                         NSLog(@"WARNING: GetNearestVillage return empty array!");
                     }
                     
                 }
             }];
        }
        else if (step == 59)
        {
            //click on attack button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:59]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CaptureVillage"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 60)
        {
            //click on attack button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:60]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PressOkOnDialogBoxView"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 61)
        {
            //click on queue max button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:61]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QueueMaxForAttack"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 62)
        {
            //click on send now button
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:62]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendCaptureNow"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 63)
        {

        }
        else if (step == 64)
        {
            //click ok
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:64]  forKey:@"tutorial_step"];
            [userInfo setObject:@"TroopsReturned"  forKey:@"template_title"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickCloseTemplateButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 65)
        {
            //click on map icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:65]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowCityButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 66)
        {
            //click on citylist icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:66]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowBaseListButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 67)
        {
            //click view on village
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:67]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:1]  forKey:@"base_index"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseBase"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 68)
        {
            //click on alliance icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:68]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowAllianceButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (step == 70)
        {
            //click on citylist icon
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:70]  forKey:@"tutorial_step"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ClickShowBaseListButton"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
            
        }
        else if (step == 71)
        {
            //click protect on capital
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:71]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:0]  forKey:@"base_index"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ProtectBase"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
            
        }
        else if (step == 72)
        {
            //use protect item row 1
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:[NSNumber numberWithInteger:72]  forKey:@"tutorial_step"];
            [userInfo setObject:[NSNumber numberWithInteger:0] forKey:@"item_row"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UseItem"
                                                                object:self
                                                              userInfo:userInfo];
            
            userInfo = [[NSMutableDictionary alloc] init];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TutorialStepCompleted"
                                                                object:self
                                                              userInfo:userInfo];
        }

    }
}

@end
