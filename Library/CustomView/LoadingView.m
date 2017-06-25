//
//  LoadingView.m
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

#import "LoadingView.h"
#import "SplashView.h"
#import "Globals.h"

@interface LoadingView ()

@property (nonatomic, strong) UIImageView *barImage;
@property (nonatomic, strong) UIImage *imgBar;
@property (nonatomic, strong) SplashView *splashView;

@end

@implementation LoadingView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    if (self.splashView == nil)
    {
        self.splashView = [[SplashView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        [self.view addSubview:self.splashView];
    }
    
    UIImage *imgBarBkg = [Globals.i imageNamedCustom:@"loading_bar_bkg"];
    UIImageView *barbkgImage = [[UIImageView alloc] initWithImage:imgBarBkg];
    barbkgImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBarBkg.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBarBkg.size.height*SCALE_IPAD/4), (imgBarBkg.size.width*SCALE_IPAD/2), (imgBarBkg.size.height*SCALE_IPAD/2));
    [self.view addSubview:barbkgImage];
    
    self.imgBar = [Globals.i imageNamedCustom:@"loading_bar"];
    self.barImage = [[UIImageView alloc] initWithImage:self.imgBar];
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(self.imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(self.imgBar.size.height*SCALE_IPAD/4), 0, (self.imgBar.size.height*SCALE_IPAD/2));
    [self.barImage setClipsToBounds:YES];
    self.barImage.contentMode = UIViewContentModeLeft;
    [self.view addSubview:self.barImage];
    
    self.lblStatus = [[UILabel alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBarBkg.size.width*SCALE_IPAD/4)-(60*SCALE_IPAD), (UIScreen.mainScreen.bounds.size.height*bar_y)-(imgBarBkg.size.height*SCALE_IPAD/4)-(30*SCALE_IPAD), (imgBarBkg.size.width*SCALE_IPAD/2)+(120*SCALE_IPAD), (imgBarBkg.size.height*SCALE_IPAD/2))];
    self.lblStatus.text = NSLocalizedString(@"Loading...", nil);
    self.lblStatus.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
	self.lblStatus.backgroundColor = [UIColor clearColor];
	self.lblStatus.textColor = [UIColor whiteColor];
	self.lblStatus.textAlignment = NSTextAlignmentCenter;
	self.lblStatus.numberOfLines = 1;
	self.lblStatus.adjustsFontSizeToFitWidth = YES;
	self.lblStatus.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.lblStatus];
    
    self.lblVersion = [[UILabel alloc] initWithFrame:CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(imgBarBkg.size.width*SCALE_IPAD/4)-(60*SCALE_IPAD), 0, (imgBarBkg.size.width*SCALE_IPAD/2)+(120*SCALE_IPAD), (imgBarBkg.size.height*SCALE_IPAD/2))];
    self.lblVersion.text = [NSString stringWithFormat:NSLocalizedString(@"Version %@", nil), GAME_VERSION];
    self.lblVersion.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
	self.lblVersion.backgroundColor = [UIColor clearColor];
    self.lblVersion.shadowColor = [UIColor darkGrayColor];
	self.lblVersion.shadowOffset = CGSizeMake(1,1);
	self.lblVersion.textColor = [UIColor whiteColor];
	self.lblVersion.textAlignment = NSTextAlignmentCenter;
	self.lblVersion.numberOfLines = 1;
	self.lblVersion.adjustsFontSizeToFitWidth = YES;
	self.lblVersion.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.lblVersion];
}

- (void)updateView
{
    [self notificationRegister];
    
    //start small again
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(self.imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(self.imgBar.size.height*SCALE_IPAD/4), 0, (self.imgBar.size.height*SCALE_IPAD/2));
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"LoadingStatus"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CloseTemplateBefore"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *view_title = [userInfo objectForKey:@"view_title"];
        
        if ([self.title isEqualToString:view_title])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    }
    else if ([[notification name] isEqualToString:@"LoadingStatus"])
    {
        NSDictionary* userInfo = notification.userInfo;
        NSString *status = [userInfo objectForKey:@"status"];
        NSNumber *percent = [userInfo objectForKey:@"percent"];
        
        //Update label
        self.lblStatus.text = status;
        
        //Update bar
        if (percent != nil)
        {
            [self updateBar:percent];
        }

        [self.view setNeedsDisplay];
        [CATransaction flush];
    }
}

- (void)updateBar:(NSNumber *)p
{
    float fullBar = (self.imgBar.size.width*SCALE_IPAD/2);
    float nowBar = fullBar * [p floatValue];
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(self.imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(self.imgBar.size.height*SCALE_IPAD/4), nowBar, (self.imgBar.size.height*SCALE_IPAD/2));
}

- (void)close
{
    [self.barImage removeFromSuperview];
    
    self.barImage = [[UIImageView alloc] initWithImage:self.imgBar];
    self.barImage.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-(self.imgBar.size.width*SCALE_IPAD/4), (UIScreen.mainScreen.bounds.size.height*bar_y)-(self.imgBar.size.height*SCALE_IPAD/4), 0, (self.imgBar.size.height*SCALE_IPAD/2));
    [self.barImage setClipsToBounds:YES];
    self.barImage.contentMode = UIViewContentModeLeft;
    [self.view addSubview:self.barImage];
    
    [self.view removeFromSuperview];
}

@end
