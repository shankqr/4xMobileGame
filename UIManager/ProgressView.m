//
//  ProgressView.m
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

#import "ProgressView.h"
#import "UIManager.h"

@interface ProgressView ()

@property (nonatomic, strong) UIImage *barImage1;
@property (nonatomic, strong) UIImage *barImage2;

@property (nonatomic, strong) UIImage *barBkgImage1;

@end


@implementation ProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        CGFloat progress_w = self.frame.size.width;
        CGFloat progress_h = self.frame.size.height;
        CGRect bar_frame = CGRectMake(0, 0, progress_w, progress_h);
        
        self.bkgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bkgLabel setBackgroundColor:[UIColor blackColor]];
        [self.bkgLabel setFrame:bar_frame];
        [self addSubview:self.bkgLabel];
        
        self.barImage1 = [UIManager.i imageNamedCustom:@"progressbar_left"];
        self.barImage2 = [UIManager.i imageNamedCustom:@"progressbar_left_red"];
        
        self.barImageView1 = [[UIImageView alloc] initWithImage:self.barImage1];
        [self.barImageView1 setFrame:CGRectMake(0.0f, 0.0f, 0.0f, self.frame.size.height)];
        [self.barImageView1 setClipsToBounds:YES];
        self.barImageView1.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.barImageView1];
        
        self.barBkgImage1 = [UIManager.i dynamicImage:bar_frame prefix:@"progressbar"];
        self.barBkgImageView1 = [[UIImageView alloc] initWithImage:self.barBkgImage1];
        [self.barBkgImageView1 setFrame:bar_frame];
        [self addSubview:self.barBkgImageView1];
        
        self.barLabel1 = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.barLabel1 setNumberOfLines:1];
        [self.barLabel1 setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:8*SCALE_IPAD]];
        [self.barLabel1 setBackgroundColor:[UIColor clearColor]];
        [self.barLabel1 setTextColor:[UIColor whiteColor]];
        self.barLabel1.adjustsFontSizeToFitWidth = YES;
        self.barLabel1.minimumScaleFactor = 0.5;
        self.barLabel1.textAlignment = NSTextAlignmentCenter;
        [self.barLabel1 setFrame:bar_frame];
        [self addSubview:self.barLabel1];
        
        self.bar1 = 0.0f;
    }
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = NO;
    return pointInside;
}

- (void)barBlue
{
    [self.barImageView1 setImage:self.barImage1];
}

- (void)barRed
{
    [self.barImageView1 setImage:self.barImage2];
}

- (void)updateView
{
    self.bkgLabel.hidden = NO;
    self.barImageView1.hidden = NO;
    self.barBkgImageView1.hidden = NO;
    self.barLabel1.hidden = NO;
    
    if (self.bar1 > 1.0f)
    {
        [self.barImageView1 setFrame:CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height)];
    }
    else if (self.bar1 > 0.0f)
    {
        CGFloat bar = self.frame.size.width*self.bar1;
        [self.barImageView1 setFrame:CGRectMake(0.0f, 0.0f, bar, self.frame.size.height)];
    }
    else
    {
        [self.barImageView1 setFrame:CGRectMake(0.0f, 0.0f, 0.0f, self.frame.size.height)];
    }
    
    [self.barLabel1 setText:self.barText];
}

- (void)hideAll
{
    self.bkgLabel.hidden = YES;
    self.barImageView1.hidden = YES;
    self.barBkgImageView1.hidden = YES;
    self.barLabel1.hidden = YES;
}

@end
