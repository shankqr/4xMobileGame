//
//  MarchingLine
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

#import "MarchingLine.h"
#import "TimerView.h"
#import "Globals.h"
#import "UIImage+Sprite.h"

#define troops_w 35.0f*SCALE_IPAD
#define troops_h 35.0f*SCALE_IPAD

#define refresh_rate 1.0

@interface MarchingLine ()

@property (nonatomic, strong) UIImageView *iv_arrow;
@property (nonatomic, strong) UIImageView *iv_troops;
@property (nonatomic, strong) UIImageView *iv_cargo;
@property (nonatomic, strong) NSTimer *jobTimer;

@property (nonatomic, strong) CALayer *arrowLayer;
@property (nonatomic, strong) CABasicAnimation *arrowLayerAnimation;

@property (nonatomic, assign) CGFloat troops_y;
@property (nonatomic, assign) CGFloat frame_width;
@property (nonatomic, assign) double timer1;

@property (nonatomic, assign) BOOL has_return;

@end

@implementation MarchingLine

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.iv_arrow = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        [self addSubview:self.iv_arrow];
        
        self.timer1 = 0.0;
        self.troops_y = -15.0f*SCALE_IPAD;
        self.frame_width = (frame.size.width - (troops_w/2));
        
        self.has_return = NO;
    }
    
    [self notificationRegister];
    return self;
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"RefreshMap"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"endMarchingLine"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    /*
    if ([[notification name] isEqualToString:@"RefreshMap"])
    {
        NSLog(@"RefreshMap MarchingLine");
        [self addSubview:self.iv_arrow];
        [self updateView];
    }
     */
    
    if ([[notification name] isEqualToString:@"endMarchingLine"])
    {
        NSLog(@"endMarchingLine notification");
        [self endMarchingLine];
    }
}



- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = NO;
    return pointInside;
}

- (void)arrowScroll
{
    UIImage *arrowsImage = [Globals.i imageNamedCustom:@"march_feet"];
    arrowsImage = [self imageWithImage:arrowsImage scaledToSize:CGSizeMake(24.0f*SCALE_IPAD, 24.0f*SCALE_IPAD)];

    UIColor *arrowPattern = [UIColor colorWithPatternImage:arrowsImage];
    
    self.arrowLayer = [CALayer layer];
    self.arrowLayer.backgroundColor = arrowPattern.CGColor;
    
    self.arrowLayer.transform = CATransform3DMakeScale(1, -1, 1);
    
    self.arrowLayer.anchorPoint = CGPointMake(0, 1);
    
    CGSize viewSize = self.iv_arrow.bounds.size;
    self.arrowLayer.frame = CGRectMake(0, 0, viewSize.width-arrowsImage.size.width, viewSize.height);
    
    [self.iv_arrow.layer addSublayer:self.arrowLayer];
    
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(arrowsImage.size.height, 0);
    self.arrowLayerAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    self.arrowLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    self.arrowLayerAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    self.arrowLayerAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    self.arrowLayerAnimation.repeatCount = HUGE_VALF;
    self.arrowLayerAnimation.duration = 1.0;
    
    [self addArrowAnimation];
}

- (void)addArrowAnimation
{
    [self.arrowLayer addAnimation:self.arrowLayerAnimation forKey:@"position"];
}

- (void)setupTroopsAnimation
{
    self.iv_troops = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, self.troops_y, troops_w, troops_h)];
    [self.iv_troops setClipsToBounds:YES];
    self.iv_troops.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.iv_troops];
    
    UIImage *spriteSheet = [Globals.i imageNamedCustom:@"troops_sprite"];
    
    if ((self.angle > -1.6f) && (self.angle < 1.6f))
    {
        self.iv_troops.transform = CGAffineTransformMakeScale(-1, 1); //Vertical Flip
    }
    else //Horizontal and Vertical Flipped
    {
        self.troops_y = 5.0f*SCALE_IPAD;
        
        [self.iv_troops setFrame:CGRectMake(0.0f, self.troops_y, troops_w, troops_h)];
        self.iv_troops.transform = CGAffineTransformMakeScale(-1, -1);
    }
    
    NSArray *arrayWithSprites = [spriteSheet spritesWithSpriteSheetImage:spriteSheet
                                                              spriteSize:CGSizeMake(70, 70)];
    
    [self.iv_troops setAnimationImages:arrayWithSprites];
    float animationDuration = [self.iv_troops.animationImages count] * 0.2; // 100ms per frame
    [self.iv_troops setAnimationRepeatCount:0];
    [self.iv_troops setAnimationDuration:animationDuration];
    [self.iv_troops startAnimating];
}

- (void)updateView
{
    NSLog(@"updateView Marching Line , jobTimer valid : %@  , timer1 : %f",self.jobTimer.isValid ? @"Yes" : @"No",self.timerView.timer1);
    
    if ((!self.jobTimer.isValid) && (self.timerView.timer1 > 0))
    {
        NSLog(@"refresh_rate :%f",refresh_rate);
        self.jobTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:refresh_rate] interval:refresh_rate target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        
        NSLog(@"self.jobTimer : %@",self.jobTimer);
        [[NSRunLoop currentRunLoop] addTimer:self.jobTimer forMode:NSRunLoopCommonModes];
        
        self.timer1 = self.timerView.timer1;
        
        [self arrowScroll];
    }
    else
    {
        NSLog(@"updateView Marching Line Not Valid");
    }
}

//ON TIMER NOT CALLED WHY?
- (void)onTimer
{
    NSLog(@"OnTImer self.timerView:%@  , self.timerView.TotalTimer : %f",self.timerView,self.timerView.TotalTimer);
    if(self.timerView!= nil && self.timerView.TotalTimer >0)
    {
        if (self.iv_troops == nil)
        {
            [self setupTroopsAnimation];
        }
        
        /*
        NSLog(@"MarchingLine.timerView.base_id : %@",self.timerView.base_id);
        NSLog(@"MarchingLine.timerView.timer1 : %f",self.timerView.timer1);
        NSLog(@"MarchingLine.timerView.TotalTimer : %f",self.timerView.TotalTimer);
        */
        if ((self.timerView.timer1 > 0.0f) && (self.timerView.TotalTimer > 0.0f))
        {
            [self addArrowAnimation];
            
            self.timer1 = self.timerView.timer1;
            
            CGFloat t1 = self.timer1;
            CGFloat t2 = self.timerView.TotalTimer;
            CGFloat t3 = t1 / t2;
            
            CGFloat bar1 = 1.0f - t3;
            
            /*
            NSLog(@"MarchingLine.timerView.is_return : %@",self.timerView.is_return ? @"Yes" : @"No");
            NSLog(@"MarchingLine.timerView.is_action : %@",self.timerView.is_action ? @"Yes" : @"No");
            NSLog(@"MarchingLine.timerView.is_action.has_return : %@",self.has_return ? @"Yes" : @"No");
            */
            if (self.timerView.is_return)
            {
                if (self.timerView.is_action)
                {
                    bar1 = 1.0f;
                }
                else
                {
                    bar1 = t3;
                    
                    if (!self.has_return)
                    {
                        self.has_return = YES;
                        self.timer1 = self.timerView.timer1;
                        
                        self.iv_arrow.transform = CGAffineTransformMakeScale(-1, 1); //Vertical Flip Arrow
                        
                        if ((self.angle > -1.6f) && (self.angle < 1.6f))//Vertical Flipped
                        {
                            self.iv_troops.transform = CGAffineTransformMakeScale(1, 1);
                        }
                        else //Horizontal and Vertical Flipped
                        {
                            self.iv_troops.transform = CGAffineTransformMakeScale(1, -1);
                        }
                        
                        [self.iv_troops setFrame:CGRectMake(self.frame_width, self.troops_y, troops_w, troops_h)];
                    }
                }
            }
            
            CGFloat bar = self.frame_width * bar1;
            
            [UIView animateWithDuration:1.0
                                  delay:0.0
                                options: UIViewAnimationOptionCurveEaseOut
                             animations:^
             {
                 [self.iv_troops setFrame:CGRectMake(bar, self.troops_y, troops_w, troops_h)];
             }
                             completion:^(BOOL finished){}];
        }
    }
    else
    {
        NSLog(@"invalidate");
        [self endMarchingLine];
    }
    
    
}

- (void)endMarchingLine
{
    [self.jobTimer invalidate];
    
    self.timer1 = 0.0;
    
    [self.iv_troops setFrame:CGRectMake(0.0f, self.troops_y, troops_w, troops_h)];
    
    [self removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
