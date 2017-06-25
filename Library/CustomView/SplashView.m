//
//  SplashView
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

#import "SplashView.h"
#import "Globals.h"

@interface SplashView ()

@property (nonatomic, strong) UIImageView *iv_bg;
@property (nonatomic, strong) UIImageView *iv_char;
@property (nonatomic, strong) UILabel *lbl_text;

@end

@implementation SplashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        if (iPad)
        {
            CGFloat char_width = 577.0f;
            
            self.iv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
            
            //Center
            //self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(95.5f, 0.0f, char_width, UIScreen.mainScreen.bounds.size.height)];
            
            //Align Right
            self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-char_width, 0.0f, char_width, UIScreen.mainScreen.bounds.size.height)];
        }
        else if (UIScreen.mainScreen.bounds.size.height == 568)
        {
            self.iv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(-53.0f, 0.0f, 426.0f, UIScreen.mainScreen.bounds.size.height)];
            self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        }
        else if (UIScreen.mainScreen.bounds.size.height == 480)
        {
            CGFloat char_width = 270.0f;
            
            self.iv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(-20.0f, 0.0f, 360.0f, UIScreen.mainScreen.bounds.size.height)];
            
            //Center
            //self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(25.0f, 0.0f, char_width, UIScreen.mainScreen.bounds.size.height)];
            
            //Align Right
            self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-char_width, 0.0f, char_width, UIScreen.mainScreen.bounds.size.height)];
        }
        [self.iv_bg setImage:[Globals.i imageNamedCustom:@"login_bg"]];
        [self addSubview:self.iv_bg];
        [self.iv_char setImage:[Globals.i imageNamedCustom:@"login_char"]];
        [self addSubview:self.iv_char];
        
        //Text on SplashView
        CGFloat lbl_width = UIScreen.mainScreen.bounds.size.width;
        CGFloat lbl_height = 36.0f*SCALE_IPAD;
        CGFloat lbl_y = (UIScreen.mainScreen.bounds.size.height/2) - (lbl_height*2);
        
        CGRect lbl_frame = CGRectMake(0.0f, lbl_y, lbl_width, lbl_height);
        self.lbl_text = [[UILabel alloc] initWithFrame:lbl_frame];
        [self.lbl_text setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE]];
        [self.lbl_text setTextColor:[UIColor whiteColor]];
        [self.lbl_text setMinimumScaleFactor:0.5f];
        [self.lbl_text setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:self.lbl_text];
        
        [self.lbl_text setText:@""];
        [self.lbl_text setNumberOfLines:0];
        [self.lbl_text setAlpha:1.0f];
    }
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = NO;
    return pointInside;
}

- (void)updateText:(NSString *)text
{
    [self.lbl_text setText:text];
}

@end
