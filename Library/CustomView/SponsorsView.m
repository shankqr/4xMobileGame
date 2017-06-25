//
//  SponsorsView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 11/25/13.
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

#import "SponsorsView.h"
#import "Globals.h"

@interface SponsorsView ()

@property (nonatomic, strong) UILabel *lbl_text;
@property (nonatomic, strong) UIImageView *iv_sponsor1;
@property (nonatomic, strong) UIImageView *iv_sponsor2;

@end

@implementation SponsorsView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Text on header
    CGFloat lbl_width = UIScreen.mainScreen.bounds.size.width;
    CGFloat lbl_height = 36.0f*SCALE_IPAD;
    CGFloat lbl_y = 10.0f*SCALE_IPAD; //(UIScreen.mainScreen.bounds.size.height/2) - (lbl_height*2);
    
    CGRect lbl_frame = CGRectMake(0.0f, lbl_y, lbl_width, lbl_height);
    self.lbl_text = [[UILabel alloc] initWithFrame:lbl_frame];
    [self.lbl_text setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:BIG_FONT_SIZE]];
    [self.lbl_text setTextColor:[UIColor blackColor]];
    [self.lbl_text setMinimumScaleFactor:0.5f];
    [self.lbl_text setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.lbl_text];
    
    [self.lbl_text setText:@"In Support of"];
    [self.lbl_text setNumberOfLines:0];
    [self.lbl_text setAlpha:1.0f];
    
    
    CGFloat sponsor1_width = 276.0f*SCALE_IPAD;
    CGFloat sponsor1_height = 215.0f*SCALE_IPAD;
    CGFloat sponsor1_x = (UIScreen.mainScreen.bounds.size.width/2) - (sponsor1_width/2);
    CGFloat sponsor1_y = lbl_y + lbl_height + 30.0f*SCALE_IPAD;

    self.iv_sponsor1 = [[UIImageView alloc] initWithFrame:CGRectMake(sponsor1_x, sponsor1_y, sponsor1_width, sponsor1_height)];
    
    CGFloat sponsor2_width = 281.0f*SCALE_IPAD;
    CGFloat sponsor2_height = 198.0f*SCALE_IPAD;
    CGFloat sponsor2_x = (UIScreen.mainScreen.bounds.size.width/2) - (sponsor2_width/2);
    CGFloat sponsor2_y = sponsor1_y + sponsor1_height + 30.0f*SCALE_IPAD;
    
    self.iv_sponsor2 = [[UIImageView alloc] initWithFrame:CGRectMake(sponsor2_x, sponsor2_y, sponsor2_width, sponsor2_height)]; //842,595
    
    [self.iv_sponsor1 setImage:[UIImage imageNamed:@"Lambang_Malaysia.png"]];
    [self.view addSubview:self.iv_sponsor1];
    
    [self.iv_sponsor2 setImage:[UIImage imageNamed:@"MDeC_logo.jpg"]];
    [self.view addSubview:self.iv_sponsor2];
}

@end
