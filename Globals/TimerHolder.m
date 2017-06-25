//
//  TimerHolder
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

#import "TimerHolder.h"
#import "TimerView.h"
#import "Globals.h"

#define TimerHolder_y (35.0f*SCALE_IPAD)

@interface TimerHolder ()

@property (nonatomic, strong) UIButton *btn_minmax;

@property (nonatomic, assign) CGFloat frame_height;
@property (nonatomic, assign) BOOL is_minimized;

@end

@implementation TimerHolder

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        self.is_minimized = NO;
    }
    
    return self;
}

- (void)updateView
{
    self.frame_height = 0.0f;
    
    for (UIView *sub in self.subviews)
    {
        if ([sub isKindOfClass:[TimerView class]])
        {
            [sub removeFromSuperview];
        }
    }
    
    CGFloat btn_width = tvWidth/3;
    CGFloat btn_height = tvHeight/1.5;
    
    if (self.btn_minmax == nil)
    {
        self.btn_minmax = [[UIButton alloc] init];
        self.btn_minmax.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [self.btn_minmax setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn_minmax.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:DEFAULT_FONT_SIZE];
        [self.btn_minmax addTarget:self action:@selector(button1_tap) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self.btn_minmax removeFromSuperview];
    
    NSUInteger tv_count = [Globals.i.tvStack count];
    
    if (tv_count > 2)
    {
        if (self.is_minimized)
        {
            NSUInteger int_more = tv_count - 2;
            NSString *btn_title = [NSString stringWithFormat:NSLocalizedString(@"%@ More", nil), [@(int_more) stringValue]];
            [self.btn_minmax setTitle:btn_title forState:UIControlStateNormal];
            
            self.frame_height = tvHeight*2;
            
            TimerView *tv1 = Globals.i.tvStack[0];
            TimerView *tv2 = Globals.i.tvStack[1];
            
            [self addSubview:tv1];
            [self addSubview:tv2];
        }
        else
        {
            [self.btn_minmax setTitle:NSLocalizedString(@"Minimize", nil) forState:UIControlStateNormal];
            
            [self addAllTv];
        }
        
        CGRect btn_rect = CGRectMake(0.0f, self.frame_height, btn_width, btn_height);
        [self.btn_minmax setFrame:btn_rect];
        [self addSubview:self.btn_minmax];
        
        self.frame_height = self.frame_height + btn_height;
    }
    else
    {
        [self.btn_minmax removeFromSuperview];
        
        self.is_minimized = NO;
        
        [self addAllTv];
    }
    
    [self setFrame:CGRectMake(0.0f, TimerHolder_y, tvWidth, self.frame_height)];
}

- (void)addAllTv
{
    for (TimerView *tv in Globals.i.tvStack)
    {
        [self addSubview:tv];
        self.frame_height = self.frame_height + tvHeight;
    }
}

- (void)button1_tap
{
    if (self.is_minimized)
    {
        self.is_minimized = NO;
    }
    else
    {
        self.is_minimized = YES;
    }
    
    [self updateView];
}

@end
