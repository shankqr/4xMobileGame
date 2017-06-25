//
//  BaseView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/3/09.
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

#import "BaseView.h"
#import "Globals.h"
#import "UIView+Glow.h"
#import "BuildList.h"
#import "OBShapedButton.h"
#import "TimerHolder.h"

@interface BaseView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btnBaseDetail;
@property (nonatomic, strong) UIImageView *ivBuildAnimation;
@property (nonatomic, strong) UIImageView *ivBuildOverlay;
@property (nonatomic, strong) UIImageView *ivCastleOverlay;
@property (nonatomic, strong) UIImageView *ivWallCityOverlay;
@property (nonatomic, strong) UIImageView *ivWallVillageOverlay;
@property (nonatomic, strong) UIImageView *ivResource1;
@property (nonatomic, strong) UIImageView *ivResource2;
@property (nonatomic, strong) UIImageView *ivResource3;
@property (nonatomic, strong) UIImageView *ivResource4;
@property (nonatomic, strong) UIImageView *ivResource5;
@property (nonatomic, strong) UILabel *lblResource1;
@property (nonatomic, strong) UILabel *lblResource2;
@property (nonatomic, strong) UILabel *lblResource3;
@property (nonatomic, strong) UILabel *lblResource4;
@property (nonatomic, strong) UILabel *lblResource5;
@property (nonatomic, strong) NSTimer *gameTimer;

@property (nonatomic, strong) UIButton *buttonSale;
@property (nonatomic, strong) UILabel *labelSale;
@property (nonatomic, strong) UIButton *buttonEventSolo;
@property (nonatomic, strong) UILabel *labelEventSolo1;
@property (nonatomic, strong) UILabel *labelEventSolo2;
@property (nonatomic, strong) UIButton *buttonEventAlliance;
@property (nonatomic, strong) UILabel *labelEventAlliance1;
@property (nonatomic, strong) UILabel *labelEventAlliance2;

@property (nonatomic, strong) UIButton *btnCastle;
@property (nonatomic, strong) OBShapedButton *btnWall;
//@property (nonatomic, strong) UIButton *btnWall;

@property (nonatomic, strong) NSMutableArray *arrayBtnResource;
@property (nonatomic, strong) NSArray *arrayPtResource;
@property (nonatomic, strong) UIButton *btnResource1;
@property (nonatomic, strong) UIButton *btnResource2;
@property (nonatomic, strong) UIButton *btnResource3;
@property (nonatomic, strong) UIButton *btnResource4;
@property (nonatomic, strong) UIButton *btnResource5;
@property (nonatomic, strong) UIButton *btnResource6;
@property (nonatomic, strong) UIButton *btnResource7;
@property (nonatomic, strong) UIButton *btnResource8;
@property (nonatomic, strong) UIButton *btnResource9;
@property (nonatomic, strong) UIButton *btnResource10;
@property (nonatomic, strong) UIButton *btnResource11;
@property (nonatomic, strong) UIButton *btnResource12;
@property (nonatomic, strong) UIButton *btnResource13;
@property (nonatomic, strong) UIButton *btnResource14;
@property (nonatomic, strong) UIButton *btnResource15;
@property (nonatomic, strong) UIButton *btnResource16;
@property (nonatomic, strong) UIButton *btnResource17;
@property (nonatomic, strong) UIButton *btnResource18;
@property (nonatomic, strong) UIButton *btnResource19;
@property (nonatomic, strong) UIButton *btnResource20;

@property (nonatomic, strong) NSMutableArray *arrayBtnInside;
@property (nonatomic, strong) NSArray *arrayPtInside;
@property (nonatomic, strong) UIButton *btnInside1;
@property (nonatomic, strong) UIButton *btnInside2;
@property (nonatomic, strong) UIButton *btnInside3;
@property (nonatomic, strong) UIButton *btnInside4;
@property (nonatomic, strong) UIButton *btnInside5;
@property (nonatomic, strong) UIButton *btnInside6;
@property (nonatomic, strong) UIButton *btnInside7;
@property (nonatomic, strong) UIButton *btnInside8;
@property (nonatomic, strong) UIButton *btnInside9;
@property (nonatomic, strong) UIButton *btnInside10;
@property (nonatomic, strong) UIButton *btnInside11;
@property (nonatomic, strong) UIButton *btnInside12;
@property (nonatomic, strong) UIButton *btnInside13;
@property (nonatomic, strong) UIButton *btnInside14;
@property (nonatomic, strong) UIButton *btnInside15;
@property (nonatomic, strong) UIButton *btnInside16;
@property (nonatomic, strong) UIButton *btnInside17;
@property (nonatomic, strong) UIButton *btnInside18;
@property (nonatomic, strong) UIButton *btnInside19;
@property (nonatomic, strong) UIButton *btnInside20;
@property (nonatomic, strong) UIButton *btnInside21;
@property (nonatomic, strong) UIButton *btnInside22;
@property (nonatomic, strong) UIButton *btnInside23;
@property (nonatomic, strong) UIButton *btnInside24;
@property (nonatomic, strong) UIButton *btnInside25;

@property (nonatomic, strong) NSArray *arrayPtVillage; //Village building coordinates

@property (nonatomic, strong) BuildList *buildList;

@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, assign) NSInteger s1;
@property (nonatomic, assign) NSInteger b1s;
@property (nonatomic, assign) NSInteger b2s;
@property (nonatomic, assign) NSInteger b3s;
@property (nonatomic, assign) BOOL timerIsShowing;
@property (nonatomic, assign) BOOL buildingTapped;
@property (nonatomic, assign) BOOL i_am_village;

@end

@implementation BaseView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.s1 = 0;
    self.b1s = 0;
    self.b2s = 0;
    self.b3s = 0;
    self.buildingTapped = NO;
    self.i_am_village = NO;
    
    NSInteger offset1_x = 40;
    NSInteger offset1_y = -40;
    self.arrayPtInside = @[@{@"x": @(790+offset1_x), @"y": @(425+offset1_y)},
                           @{@"x": @(85+offset1_x), @"y": @(1061+offset1_y)},
                           @{@"x": @(257+offset1_x), @"y": @(959+offset1_y)},
                           @{@"x": @(432+offset1_x), @"y": @(860+offset1_y)},
                           @{@"x": @(257+offset1_x), @"y": @(1164+offset1_y)},
                           @{@"x": @(432+offset1_x), @"y": @(1061+offset1_y)},
                           @{@"x": @(606+offset1_x), @"y": @(959+offset1_y)},
                           @{@"x": @(432+offset1_x), @"y": @(1262+offset1_y)},
                           @{@"x": @(606+offset1_x), @"y": @(1164+offset1_y)},
                           @{@"x": @(790+offset1_x), @"y": @(1061+offset1_y)},
                           @{@"x": @(606+offset1_x), @"y": @(1363+offset1_y)},
                           @{@"x": @(779+offset1_x), @"y": @(1262+offset1_y)},
                           @{@"x": @(956+offset1_x), @"y": @(1162+offset1_y)},
                           @{@"x": @(711+offset1_x), @"y": @(689+offset1_y)},
                           @{@"x": @(883+offset1_x), @"y": @(596+offset1_y)},
                           @{@"x": @(1058+offset1_x), @"y": @(495+offset1_y)},
                           @{@"x": @(883+offset1_x), @"y": @(799+offset1_y)},
                           @{@"x": @(1058+offset1_x), @"y": @(698+offset1_y)},
                           @{@"x": @(1232+offset1_x), @"y": @(596+offset1_y)},
                           @{@"x": @(1058+offset1_x), @"y": @(899+offset1_y)},
                           @{@"x": @(1232+offset1_x), @"y": @(799+offset1_y)},
                           @{@"x": @(1405+offset1_x), @"y": @(698+offset1_y)},
                           @{@"x": @(1232+offset1_x), @"y": @(1000+offset1_y)},
                           @{@"x": @(1405+offset1_x), @"y": @(899+offset1_y)},
                           @{@"x": @(1582+offset1_x), @"y": @(799+offset1_y)}];
    
    NSInteger offset2_x = 0;
    NSInteger offset2_y = 0;
    self.arrayPtResource = @[@{@"x": @(2133+offset2_x), @"y": @(752+offset2_y)},
                             @{@"x": @(2225+offset2_x), @"y": @(295+offset2_y)},
                             @{@"x": @(1656+offset2_x), @"y": @(1227+offset2_y)},
                             @{@"x": @(1887+offset2_x), @"y": @(1364+offset2_y)},
                             @{@"x": @(1828+offset2_x), @"y": @(1125+offset2_y)},
                             @{@"x": @(2064+offset2_x), @"y": @(1262+offset2_y)},
                             @{@"x": @(2290+offset2_x), @"y": @(1396+offset2_y)},
                             @{@"x": @(2003+offset2_x), @"y": @(1024+offset2_y)},
                             @{@"x": @(2234+offset2_x), @"y": @(1161+offset2_y)},
                             @{@"x": @(2471+offset2_x), @"y": @(1294+offset2_y)},
                             @{@"x": @(2182+offset2_x), @"y": @(928+offset2_y)},
                             @{@"x": @(2407+offset2_x), @"y": @(1059+offset2_y)},
                             @{@"x": @(2654+offset2_x), @"y": @(1192+offset2_y)},
                             @{@"x": @(1458+offset2_x), @"y": @(1329+offset2_y)},
                             @{@"x": @(1933+offset2_x), @"y": @(600+offset2_y)},
                             @{@"x": @(2340+offset2_x), @"y": @(463+offset2_y)},
                             @{@"x": @(2430+offset2_x), @"y": @(152+offset2_y)},
                             @{@"x": @(2573+offset2_x), @"y": @(357+offset2_y)},
                             @{@"x": @(2644+offset2_x), @"y": @(520+offset2_y)},
                             @{@"x": @(2650+offset2_x), @"y": @(720+offset2_y)}];
    
    NSInteger offset3_x = 0;
    NSInteger offset3_y = 0;
    self.arrayPtVillage = @[@{@"x": @(585+offset3_x), @"y": @(761+offset3_y)},
                           @{@"x": @(757+offset3_x), @"y": @(659+offset3_y)},
                           @{@"x": @(932+offset3_x), @"y": @(560+offset3_y)},
                           @{@"x": @(757+offset3_x), @"y": @(864+offset3_y)},
                           @{@"x": @(932+offset3_x), @"y": @(761+offset3_y)},
                           @{@"x": @(932+offset3_x), @"y": @(962+offset3_y)},
                           @{@"x": @(2067+offset3_x), @"y": @(695+offset3_y)},
                           @{@"x": @(1106+offset3_x), @"y": @(1063+offset3_y)},
                           @{@"x": @(1433+offset3_x), @"y": @(1070+offset3_y)},
                           @{@"x": @(1211+offset3_x), @"y": @(389+offset3_y)},
                           @{@"x": @(1383+offset3_x), @"y": @(296+offset3_y)},
                           @{@"x": @(1574+offset3_x), @"y": @(1163+offset3_y)},
                           @{@"x": @(1260+offset3_x), @"y": @(1170+offset3_y)},
                           @{@"x": @(1574+offset3_x), @"y": @(399+offset3_y)},
                           @{@"x": @(1732+offset3_x), @"y": @(499+offset3_y)},
                           @{@"x": @(1410+offset3_x), @"y": @(1270+offset3_y)},
                           @{@"x": @(1905+offset3_x), @"y": @(599+offset3_y)},
                           @{@"x": @(1892+offset3_x), @"y": @(795+offset3_y)}];
    
    self.btnResource1 = [[UIButton alloc] init];
    self.btnResource2 = [[UIButton alloc] init];
    self.btnResource3 = [[UIButton alloc] init];
    self.btnResource4 = [[UIButton alloc] init];
    self.btnResource5 = [[UIButton alloc] init];
    self.btnResource6 = [[UIButton alloc] init];
    self.btnResource7 = [[UIButton alloc] init];
    self.btnResource8 = [[UIButton alloc] init];
    self.btnResource9 = [[UIButton alloc] init];
    self.btnResource10 = [[UIButton alloc] init];
    self.btnResource11 = [[UIButton alloc] init];
    self.btnResource12 = [[UIButton alloc] init];
    self.btnResource13 = [[UIButton alloc] init];
    self.btnResource14 = [[UIButton alloc] init];
    self.btnResource15 = [[UIButton alloc] init];
    self.btnResource16 = [[UIButton alloc] init];
    self.btnResource17 = [[UIButton alloc] init];
    self.btnResource18 = [[UIButton alloc] init];
    self.btnResource19 = [[UIButton alloc] init];
    self.btnResource20 = [[UIButton alloc] init];
    
    self.btnInside1 = [[UIButton alloc] init];
    self.btnInside2 = [[UIButton alloc] init];
    self.btnInside3 = [[UIButton alloc] init];
    self.btnInside4 = [[UIButton alloc] init];
    self.btnInside5 = [[UIButton alloc] init];
    self.btnInside6 = [[UIButton alloc] init];
    self.btnInside7 = [[UIButton alloc] init];
    self.btnInside8 = [[UIButton alloc] init];
    self.btnInside9 = [[UIButton alloc] init];
    self.btnInside10 = [[UIButton alloc] init];
    self.btnInside11 = [[UIButton alloc] init];
    self.btnInside12 = [[UIButton alloc] init];
    self.btnInside13 = [[UIButton alloc] init];
    self.btnInside14 = [[UIButton alloc] init];
    self.btnInside15 = [[UIButton alloc] init];
    self.btnInside16 = [[UIButton alloc] init];
    self.btnInside17 = [[UIButton alloc] init];
    self.btnInside18 = [[UIButton alloc] init];
    self.btnInside19 = [[UIButton alloc] init];
    self.btnInside20 = [[UIButton alloc] init];
    self.btnInside21 = [[UIButton alloc] init];
    self.btnInside22 = [[UIButton alloc] init];
    self.btnInside23 = [[UIButton alloc] init];
    self.btnInside24 = [[UIButton alloc] init];
    self.btnInside25 = [[UIButton alloc] init];
    
    //ScrollView Setup
    [self setupScrollView];
    
    //Show events button
    [self updateEventSoloButton];
    [self updateEventAllianceButton];
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
                                                 name:@"BaseChanged"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BaseUpdated"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BuildingBuild"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BuildingDestroy"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TimerViewEnd"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"Zoom_BaseView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowBuildList"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    NSLog(@"Notification Name From BASEVIEW: %@",[notification name]);
    
    if ([[notification name] isEqualToString:@"BaseChanged"])
    {
        [self startFade];
        
        [self updateView];
        
        [self drawHeader];
    }
    else if ([[notification name] isEqualToString:@"BaseUpdated"])
    {
        [self drawHeader];
    }
    else if ([[notification name] isEqualToString:@"BuildingBuild"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSString *b_id = [userInfo objectForKey:@"building_id"];
            NSNumber *b_level = [userInfo objectForKey:@"building_level"];
            NSNumber *b_location = [userInfo objectForKey:@"building_location"];
            
            [self buildBuilding:b_id :b_level :b_location];
        }
    }
    else if ([[notification name] isEqualToString:@"BuildingDestroy"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *b_location = [userInfo objectForKey:@"building_location"];
            
            for (int i = 0; i < [Globals.i.wsBuildArray count]; i++)
            {
                if ([Globals.i.wsBuildArray[i][@"location"] integerValue] == [b_location integerValue])
                {
                    [Globals.i.wsBuildArray removeObjectAtIndex:i];
                }
            }
            
            [self redrawBuilding:b_location];
        }
    }
    else if ([[notification name] isEqualToString:@"TimerViewEnd"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *tv_id = [userInfo objectForKey:@"tv_id"];
            
            if ([tv_id integerValue] == TV_BUILD)
            {
                [self.ivBuildAnimation removeFromSuperview];
                [self.ivBuildOverlay removeFromSuperview];
                [self.ivCastleOverlay removeFromSuperview];
                [self.ivWallCityOverlay removeFromSuperview];
                [self.ivWallVillageOverlay removeFromSuperview];
            }
        }
    }
    else if ([[notification name] isEqualToString:@"Zoom_BaseView"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSLog(@"Zoom_BaseView");
        if (userInfo != nil)
        {
            NSInteger zoom_x = [[userInfo objectForKey:@"zoom_x"] integerValue];
            NSInteger zoom_y = [[userInfo objectForKey:@"zoom_y"] integerValue];
            NSInteger zoom_scale = [[userInfo objectForKey:@"zoom_scale"] integerValue];
            
            NSLog(@"zoom_x : %ld",(long)zoom_x);
            NSLog(@"zoom_y : %ld",(long)zoom_y);
            NSLog(@"zoom_scale : %ld",(long)zoom_scale);
            
            [self zoomToPoint:CGPointMake(zoom_x, zoom_y) withScale:zoom_scale animated:YES];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowBuildList"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *building_location = [userInfo objectForKey:@"building_location"];
            
            //UIButton *btn = (UIButton*)[self.imageView viewWithTag:[building_location integerValue]];
            //[btn startGlowingWithColor:[UIColor yellowColor] intensity:0.7];
            //[self performSelector:@selector(showBuilding:) withObject:building_location afterDelay:0.1];
            
            if ([building_location intValue] > 300)
            {
                NSInteger i = [building_location integerValue] - 301;
                
                UIButton *buildingButton = (UIButton*)self.arrayBtnInside[i];
                NSLog(@"buildingButton BuildList inside: %@",buildingButton);
                [buildingButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
                NSInteger i = [building_location integerValue] - 201;
                
                UIButton *buildingButton = (UIButton*)self.arrayBtnResource[i];
                NSLog(@"buildingButton BuildList outside: %@", buildingButton);
                [buildingButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }

        }
    }
    
}

- (void)startFade
{
    if ([Globals.i.wsBaseDict[@"base_type"] isEqualToString:@"1"])
    {
        self.i_am_village = NO;
    }
    else
    {
        self.i_am_village = YES;
    }
    
    //zoom out
    [self.scrollView setZoomScale:self.scrollView.minimumZoomScale];
    
    if (self.i_am_village)
    {
        CGFloat center_x = self.scrollView.contentSize.width/2.0f - self.scrollView.frame.size.width/2.0f;
        
        [self.scrollView setContentOffset:CGPointMake(center_x, 0) animated:YES];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    
    CGFloat lbl_width = UIScreen.mainScreen.bounds.size.width;
    CGFloat lbl_height = 36.0f*SCALE_IPAD;
    CGFloat lbl_y = (UIScreen.mainScreen.bounds.size.height/2) - (lbl_height*2);
    
    CGRect lbl_frame = CGRectMake(0.0f, lbl_y, lbl_width, lbl_height);
    UILabel *lbl_text = [[UILabel alloc] initWithFrame:lbl_frame];
    [lbl_text setFont:[UIFont fontWithName:CITY_NAME_FONT size:HUGE_FONT_SIZE]];
    [lbl_text setTextColor:[UIColor whiteColor]];
    [lbl_text setMinimumScaleFactor:0.5f];
    [lbl_text setTextAlignment:NSTextAlignmentCenter];
    [self.view.superview addSubview:lbl_text];
    
    [lbl_text setText:Globals.i.wsBaseDict[@"base_name"]];
    [lbl_text setNumberOfLines:0];
    [lbl_text setAlpha:1.0f];
    
    [self.view setAlpha:0.0f];
    
    //fade in
    [UIView animateWithDuration:2.0f animations:^{
        
        [self.view setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0f animations:^{
            
            [lbl_text setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            
            [lbl_text removeFromSuperview];
            
        }];
        
    }];
}

- (void)zoomToPoint:(CGPoint)zoomPoint withScale:(CGFloat)scale animated:(BOOL)animated
{
    //Ensure scale is clamped to the scroll view's allowed zooming range
    scale = MIN(scale, self.scrollView.maximumZoomScale);
    scale = MAX(scale, self.scrollView.minimumZoomScale);
    
    
    NSLog(@"SCALE : %f :",scale);
    NSLog(@"zoomPoint x : %f :",zoomPoint.x);
    NSLog(@"zoomPoint y : %f :",zoomPoint.y);
    //`zoomToRect` works on the assumption that the input frame is in relation
    //to the content view when zoomScale is 1.0
    
    //Work out in the current zoomScale, where on the contentView we are zooming
    CGPoint translatedZoomPoint = CGPointZero;
    translatedZoomPoint.x = zoomPoint.x + self.scrollView.contentOffset.x;
    translatedZoomPoint.y = zoomPoint.y + self.scrollView.contentOffset.y;
    
    NSLog(@"self.scrollView.maximumZoomScale : %f :",self.scrollView.maximumZoomScale);
    NSLog(@"self.scrollView.minimumZoomScale : %f :",self.scrollView.minimumZoomScale);
    NSLog(@"self.scrollView.contentScaleFactor : %f :",self.scrollView.contentScaleFactor);
    NSLog(@"self.scrollView.zoomScale : %f :",self.scrollView.zoomScale);
    
    //Figure out what zoom scale we need to get back to default 1.0f
    //NOTE : default is NOT 1.0f on all devices
    CGFloat zoomFactor = 1.0f / self.scrollView.zoomScale;
    
    //By multiplying by the zoom factor, we get where we're zooming to, at scale 1.0f;
    translatedZoomPoint.x *= zoomFactor;
    translatedZoomPoint.y *= zoomFactor;
    
    NSLog(@"translatedZoomPoint x : %f :",translatedZoomPoint.x);
    NSLog(@"translatedZoomPoint y : %f :",translatedZoomPoint.y);
    
    //work out the size of the rect to zoom to, and place it with the zoom point in the middle
    CGRect destinationRect = CGRectZero;
    destinationRect.size.width = CGRectGetWidth(self.scrollView.frame) / scale;
    destinationRect.size.height = CGRectGetHeight(self.scrollView.frame) / scale;
    destinationRect.origin.x = translatedZoomPoint.x - (CGRectGetWidth(destinationRect) * 0.5f);
    destinationRect.origin.y = translatedZoomPoint.y - (CGRectGetHeight(destinationRect) * 0.5f);
    
    if (animated)
    {
        [UIView animateWithDuration:3.0f delay:0.5f usingSpringWithDamping:1.0f initialSpringVelocity:0.6f options:0 animations:^{
            [self.scrollView zoomToRect:destinationRect animated:NO];
        } completion:nil];
    }
    else
    {
        [self.scrollView zoomToRect:destinationRect animated:NO];
    }
}

- (void)redrawBuilding:(NSNumber *)b_location
{
    if ([b_location integerValue] == 101) //Castle
    {
        [self createCastle:YES];
    }
    else if ([b_location integerValue] == 102) //Wall
    {
        [self createWall:YES];
    }
    else if ([b_location integerValue] > 400) //Village Buildings
    {
        NSInteger i = [b_location integerValue] - 401;
        [self drawBuilding:self.arrayBtnInside[i] :[b_location integerValue] :self.arrayPtVillage[i]: YES];
    }
    else if ([b_location integerValue] > 300) //Inside Buildings
    {
        NSInteger i = [b_location integerValue] - 301;
        [self drawBuilding:self.arrayBtnInside[i] :[b_location integerValue] :self.arrayPtInside[i]: YES];
    }
    else if ([b_location integerValue] > 200) //Outside Buildings
    {
        NSInteger i = [b_location integerValue] - 201;
        [self drawBuilding:self.arrayBtnResource[i] :[b_location integerValue] :self.arrayPtResource[i]: YES];
    }
}

- (void)buildBuilding:(NSString *)b_id :(NSNumber *)b_level :(NSNumber *)b_location
{
    NSString *service_name = @"BuildBuilding";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], Globals.i.wsBaseDict[@"base_id"], b_id, [b_level stringValue], [b_location stringValue]];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             //This updates balance resources, resource productions, build location and build que
             [Globals.i updateBaseDict:^(BOOL success, NSData *data)
              {
                  //Draw the build building
                  if ([b_level integerValue] > 1)
                  {
                      //Special for castle and wall only
                      if (([b_level integerValue] == 2) && (([b_id integerValue] == 101) || ([b_id integerValue] == 102)))
                      {
                          NSMutableDictionary *row10 = [@{@"build_id": @"1", @"base_id": Globals.i.wsBaseDict[@"base_id"], @"location": [b_location stringValue], @"building_id": b_id, @"building_level": [b_level stringValue]} mutableCopy];
                          [Globals.i.wsBuildArray addObject:row10];
                      }
                      else
                      {
                          for (int i = 0; i < [Globals.i.wsBuildArray count]; i++)
                          {
                              if ([Globals.i.wsBuildArray[i][@"location"] integerValue] == [b_location integerValue])
                              {
                                  Globals.i.wsBuildArray[i][@"building_level"] = [b_level stringValue];
                              }
                          }
                      }
                  }
                  else
                  {
                      NSMutableDictionary *row10 = [@{@"build_id": @"1", @"base_id": Globals.i.wsBaseDict[@"base_id"], @"location": [b_location stringValue], @"building_id": b_id, @"building_level": [b_level stringValue]} mutableCopy];
                      [Globals.i.wsBuildArray addObject:row10];
                  }
                  
                  [Globals.i play_build];
                  
                  [Globals.i setupBuildQueue:[Globals.i updateTime]]; //Must to make timer and build animations work
                  
                  [self redrawBuilding:b_location];
                  
                  //This updates xp, hero_xp, solo event and alliance event points
                  NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:b_id level:[b_level integerValue]];
                  NSInteger power = [buildingLevelDict[@"power"] integerValue];
                  NSInteger hero_xp = [buildingLevelDict[@"hero_xp"] integerValue];
                  [Globals.i updateProfilePower:power];
                  [Globals.i updateHeroXP:hero_xp];
                  
                  //[UIManager.i showToast:@"Construction has begun Successfully!" optionalTitle:nil optionalImage:@"icon_check"];
              }];
             
         }
     }];
}

- (void)basedetail_tap:(id)sender
{
    [Globals.i play_button];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBaseDetail" object:self];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = YES;
    
    if (CGRectContainsPoint(self.view.frame, point))
    {
        pointInside = NO;
    }
    
    return pointInside;
}

- (void)addbackTimerHolder
{
    [self.view addSubview:Globals.i.timerHolder];
    [Globals.i updateTimerHolder];
}

- (void)updateView
{
    [self notificationRegister];
    
    if ([Globals.i.wsBaseDict[@"base_type"] isEqualToString:@"1"])
    {
        self.i_am_village = NO;
    }
    else
    {
        self.i_am_village = YES;
    }
    
    if (!self.gameTimer.isValid)
    {
        self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
    }
    
    [Globals.i setupAllQueue];
    [self addbackTimerHolder];
    
	[self drawHeader];
    
    UIImage *image;
    if (self.i_am_village)
    {
        image = [Globals.i imageNamedCustom:@"building_map2"];
    }
    else
    {
        image = [Globals.i imageNamedCustom:@"building_map1"];
    }
    [self.imageView setImage:image];
    
    [self drawBuildings];
}

- (void)drawHeader
{
    self.lblResource1.text = [Globals.i shortNumberDouble:Globals.i.base_r1];
    if (Globals.i.base_r1 < 1)
    {
        self.lblResource1.textColor = [UIColor redColor];
    }
    else
    {
        self.lblResource1.textColor = [UIColor whiteColor];
    }
    
    self.lblResource2.text = [Globals.i shortNumberDouble:Globals.i.base_r2];
    if (Globals.i.base_r2 < 1)
    {
        self.lblResource2.textColor = [UIColor redColor];
    }
    else
    {
        self.lblResource2.textColor = [UIColor whiteColor];
    }
    
    self.lblResource3.text = [Globals.i shortNumberDouble:Globals.i.base_r3];
    if (Globals.i.base_r3 < 1)
    {
        self.lblResource3.textColor = [UIColor redColor];
    }
    else
    {
        self.lblResource3.textColor = [UIColor whiteColor];
    }
    
    self.lblResource4.text = [Globals.i shortNumberDouble:Globals.i.base_r4];
    if (Globals.i.base_r4 < 1)
    {
        self.lblResource4.textColor = [UIColor redColor];
    }
    else
    {
        self.lblResource4.textColor = [UIColor whiteColor];
    }
    
    self.lblResource5.text = [Globals.i shortNumberDouble:Globals.i.base_r5];
    if (Globals.i.base_r5 < 1)
    {
        self.lblResource5.textColor = [UIColor redColor];
    }
    else
    {
        self.lblResource5.textColor = [UIColor whiteColor];
    }
}

- (void)drawBuildings
{
    [self clearAllBuildings];
    
    [self updateBuildArray];
}

#pragma mark - ScrollView

- (void)setupScrollView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.scrollsToTop = NO;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.scrollView setShowsVerticalScrollIndicator:NO];
    [self.scrollView setBounces:NO];
    [self.scrollView setBouncesZoom:NO];
    self.scrollView.delaysContentTouches = YES;
    self.scrollView.delegate = self;
    [self.scrollView setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, PLUGIN_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    self.btnBaseDetail = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, btnBaseDetail_h)];
	[self.btnBaseDetail setBackgroundImage:[Globals.i imageNamedCustom:@"btn_resources"] forState:UIControlStateNormal];
	[self.btnBaseDetail setBackgroundImage:[Globals.i imageNamedCustom:@"btn_resources_h"] forState:UIControlStateHighlighted];
	[self.btnBaseDetail addTarget:self action:@selector(basedetail_tap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.btnBaseDetail];
    
    CGFloat icon_size = 20.0f*SCALE_IPAD;
    CGFloat icon_y = 8.0f*SCALE_IPAD;
    CGFloat lbl_width = 40.0f;
    if (iPad)
    {
        lbl_width = 105.0f;
    }
    CGFloat icon_start_x = 10.0f*SCALE_IPAD;
    CGFloat icon_start_x_offset = icon_start_x;
    
    //Build icon animation
    NSArray *imageNames = @[@"h1", @"h2", @"h3", @"h4", @"h5", @"h6"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++)
    {
        [images addObject:[Globals.i imageNamedCustom:[imageNames objectAtIndex:i]]];
    }
    self.ivBuildAnimation = [[UIImageView alloc] init];
    self.ivBuildAnimation.animationImages = images;
    self.ivBuildAnimation.userInteractionEnabled = YES;
    self.ivBuildAnimation.contentMode = UIViewContentModeCenter;
    self.ivBuildAnimation.animationDuration = 0.5;
    
    self.ivBuildOverlay = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"building_upgrading"]];
    self.ivCastleOverlay = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"castle_upgrading"]];
    self.ivWallCityOverlay = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"walls_city_upgrade"]];
    self.ivWallVillageOverlay = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"walls_village_upgrade"]];
    
    self.ivResource1 = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"icon_r1"]];
    [self.ivResource1 setFrame:CGRectMake(icon_start_x_offset, icon_y, icon_size, icon_size)];
    [self.view addSubview:self.ivResource1];
    self.lblResource1 = [[UILabel alloc] initWithFrame:CGRectMake(icon_start_x_offset+icon_size, icon_y, lbl_width, icon_size)];
    self.lblResource1.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
    self.lblResource1.backgroundColor = [UIColor clearColor];
    self.lblResource1.textColor = [UIColor whiteColor];
    self.lblResource1.textAlignment = NSTextAlignmentLeft;
    self.lblResource1.numberOfLines = 1;
    self.lblResource1.adjustsFontSizeToFitWidth = YES;
    self.lblResource1.minimumScaleFactor = 0.1f;
    [self.view addSubview:self.lblResource1];
    
    icon_start_x_offset = icon_start_x_offset+icon_size+lbl_width;
    self.ivResource2 = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"icon_r2"]];
    [self.ivResource2 setFrame:CGRectMake(icon_start_x_offset, icon_y, icon_size, icon_size)];
    [self.view addSubview:self.ivResource2];
    self.lblResource2 = [[UILabel alloc] initWithFrame:CGRectMake(icon_start_x_offset+icon_size, icon_y, lbl_width, icon_size)];
    self.lblResource2.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
    self.lblResource2.backgroundColor = [UIColor clearColor];
    self.lblResource2.textColor = [UIColor whiteColor];
    self.lblResource2.textAlignment = NSTextAlignmentLeft;
    self.lblResource2.numberOfLines = 1;
    self.lblResource2.adjustsFontSizeToFitWidth = YES;
    self.lblResource2.minimumScaleFactor = 0.1f;
    [self.view addSubview:self.lblResource2];
    
    icon_start_x_offset = icon_start_x_offset+icon_size+lbl_width;
    self.ivResource3 = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"icon_r3"]];
    [self.ivResource3 setFrame:CGRectMake(icon_start_x_offset, icon_y, icon_size, icon_size)];
    [self.view addSubview:self.ivResource3];
    self.lblResource3 = [[UILabel alloc] initWithFrame:CGRectMake(icon_start_x_offset+icon_size, icon_y, lbl_width, icon_size)];
    self.lblResource3.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
    self.lblResource3.backgroundColor = [UIColor clearColor];
    self.lblResource3.textColor = [UIColor whiteColor];
    self.lblResource3.textAlignment = NSTextAlignmentLeft;
    self.lblResource3.numberOfLines = 1;
    self.lblResource3.adjustsFontSizeToFitWidth = YES;
    self.lblResource3.minimumScaleFactor = 0.1f;
    [self.view addSubview:self.lblResource3];
    
    icon_start_x_offset = icon_start_x_offset+icon_size+lbl_width;
    self.ivResource4 = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"icon_r4"]];
    [self.ivResource4 setFrame:CGRectMake(icon_start_x_offset, icon_y, icon_size, icon_size)];
    [self.view addSubview:self.ivResource4];
    self.lblResource4 = [[UILabel alloc] initWithFrame:CGRectMake(icon_start_x_offset+icon_size, icon_y, lbl_width, icon_size)];
    self.lblResource4.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
    self.lblResource4.backgroundColor = [UIColor clearColor];
    self.lblResource4.textColor = [UIColor whiteColor];
    self.lblResource4.textAlignment = NSTextAlignmentLeft;
    self.lblResource4.numberOfLines = 1;
    self.lblResource4.adjustsFontSizeToFitWidth = YES;
    self.lblResource4.minimumScaleFactor = 0.1f;
    [self.view addSubview:self.lblResource4];
    
    icon_start_x_offset = icon_start_x_offset+icon_size+lbl_width;
    self.ivResource5 = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"icon_r5"]];
    [self.ivResource5 setFrame:CGRectMake(icon_start_x_offset, icon_y, icon_size, icon_size)];
    [self.view addSubview:self.ivResource5];
    self.lblResource5 = [[UILabel alloc] initWithFrame:CGRectMake(icon_start_x_offset+icon_size, icon_y, lbl_width, icon_size)];
    self.lblResource5.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
    self.lblResource5.backgroundColor = [UIColor clearColor];
    self.lblResource5.textColor = [UIColor whiteColor];
    self.lblResource5.textAlignment = NSTextAlignmentLeft;
    self.lblResource5.numberOfLines = 1;
    self.lblResource5.adjustsFontSizeToFitWidth = YES;
    self.lblResource5.minimumScaleFactor = 0.1f;
    [self.view addSubview:self.lblResource5];
    
    UIImage *image = [Globals.i imageNamedCustom:@"building_map1"];
    self.imageView = [[UIImageView alloc] initWithImage:image];
    self.imageView.frame = (CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    [self.imageView setUserInteractionEnabled:YES];
    [self.scrollView insertSubview:self.imageView atIndex:0];
    self.scrollView.contentSize = image.size;
    
    UITapGestureRecognizer *doubleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewDoubleTapped:)];
    doubleTapRecognizer.numberOfTapsRequired = 2;
    doubleTapRecognizer.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:doubleTapRecognizer];
    
    UITapGestureRecognizer *twoFingerTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewTwoFingerTapped:)];
    twoFingerTapRecognizer.numberOfTapsRequired = 1;
    twoFingerTapRecognizer.numberOfTouchesRequired = 2;
    [self.scrollView addGestureRecognizer:twoFingerTapRecognizer];
    
    //TESTING
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    //NOTE: SOMETHING IS HARDCODED HERE
    if (UIScreen.mainScreen.bounds.size.height == 568)
    {
        self.scrollView.minimumZoomScale = 0.28f;
        self.scrollView.maximumZoomScale = 0.5f;
        self.scrollView.zoomScale = 0.28f;
    }
    else if (UIScreen.mainScreen.bounds.size.height == 480)
    {
        self.scrollView.minimumZoomScale = 0.225f;
        self.scrollView.maximumZoomScale = 0.5f;
        self.scrollView.zoomScale = 0.225f;
    }
    else
    {
        self.scrollView.minimumZoomScale = 0.5f;
        self.scrollView.maximumZoomScale = 1.0f;
        self.scrollView.zoomScale = 0.5f;
    }
    
    [self centerScrollViewContents];
}

- (void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.imageView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else
    {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else
    {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.imageView.frame = contentsFrame;
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer
{
    CGPoint pointInView = [recognizer locationInView:self.imageView];
    
    CGFloat newZoomScale = self.scrollView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    [self.scrollView zoomToRect:rectToZoomTo animated:YES];
}

- (void)scrollViewTwoFingerTapped:(UITapGestureRecognizer*)recognizer
{
    // Zoom out slightly, capping at the minimum zoom scale specified by the scroll view
    CGFloat newZoomScale = self.scrollView.zoomScale / 1.5f;
    newZoomScale = MAX(newZoomScale, self.scrollView.minimumZoomScale);
    [self.scrollView setZoomScale:newZoomScale animated:YES];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Return the view that you want to zoom
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale >= scrollView.maximumZoomScale)
    {
        [self.scrollView setBouncesZoom:YES];
    }
    else
    {
        [self.scrollView setBouncesZoom:NO];
    }
    
    // The scroll view has zoomed, so you need to re-center the contents
    [self centerScrollViewContents];
}

#pragma mark - Buildings

- (void)clearAllBuildings
{
    [self.btnCastle removeFromSuperview];
    [self.btnWall removeFromSuperview];
    
    [self.btnResource1 removeFromSuperview];
    [self.btnResource2 removeFromSuperview];
    [self.btnResource3 removeFromSuperview];
    [self.btnResource4 removeFromSuperview];
    [self.btnResource5 removeFromSuperview];
    [self.btnResource6 removeFromSuperview];
    [self.btnResource7 removeFromSuperview];
    [self.btnResource8 removeFromSuperview];
    [self.btnResource9 removeFromSuperview];
    [self.btnResource10 removeFromSuperview];
    [self.btnResource11 removeFromSuperview];
    [self.btnResource12 removeFromSuperview];
    [self.btnResource13 removeFromSuperview];
    [self.btnResource14 removeFromSuperview];
    [self.btnResource15 removeFromSuperview];
    [self.btnResource16 removeFromSuperview];
    [self.btnResource17 removeFromSuperview];
    [self.btnResource18 removeFromSuperview];
    [self.btnResource19 removeFromSuperview];
    [self.btnResource20 removeFromSuperview];
    
    [self.btnInside1 removeFromSuperview];
    [self.btnInside2 removeFromSuperview];
    [self.btnInside3 removeFromSuperview];
    [self.btnInside4 removeFromSuperview];
    [self.btnInside5 removeFromSuperview];
    [self.btnInside6 removeFromSuperview];
    [self.btnInside7 removeFromSuperview];
    [self.btnInside8 removeFromSuperview];
    [self.btnInside9 removeFromSuperview];
    [self.btnInside10 removeFromSuperview];
    [self.btnInside11 removeFromSuperview];
    [self.btnInside12 removeFromSuperview];
    [self.btnInside13 removeFromSuperview];
    [self.btnInside14 removeFromSuperview];
    [self.btnInside15 removeFromSuperview];
    [self.btnInside16 removeFromSuperview];
    [self.btnInside17 removeFromSuperview];
    [self.btnInside18 removeFromSuperview];
    [self.btnInside19 removeFromSuperview];
    [self.btnInside20 removeFromSuperview];
    [self.btnInside21 removeFromSuperview];
    [self.btnInside22 removeFromSuperview];
    [self.btnInside23 removeFromSuperview];
    [self.btnInside24 removeFromSuperview];
    [self.btnInside25 removeFromSuperview];
    
    [self.ivBuildOverlay removeFromSuperview];
    [self.ivCastleOverlay removeFromSuperview];
    [self.ivWallCityOverlay removeFromSuperview];
    [self.ivWallVillageOverlay removeFromSuperview];
    [self.ivBuildAnimation removeFromSuperview];
}

- (void)updateBuildArray
{
    NSDictionary *baseDict = Globals.i.wsBaseDict;
    
    NSString *service_name = @"GetBuildAll";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       baseDict[@"base_id"]];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 Globals.i.wsBuildArray = [[NSMutableArray alloc] init];
                 
                 if (returnArray.count > 0)
                 {
                     for (NSMutableDictionary *dict in returnArray)
                     {
                         NSMutableDictionary *buildDict = [[NSMutableDictionary alloc] initWithDictionary:dict copyItems:YES];
                         
                         [Globals.i.wsBuildArray addObject:buildDict];
                     }
                 }
                 
                 [self createWall:NO];
                 
                 [self createCastle:NO];
                 
                 if (self.i_am_village)
                 {
                     [self setupVillageBuildings];
                 }
                 else
                 {
                     [self setupResourceBuildings];
                 
                     [self setupInsideBuildings];
                 }
             }
         });
     }];
}

- (void)setupResourceBuildings
{
    [self createBuilding:self.btnResource1 :201 :self.arrayPtResource[0]];
    [self createBuilding:self.btnResource2 :202 :self.arrayPtResource[1]];
    [self createBuilding:self.btnResource3 :203 :self.arrayPtResource[2]];
    [self createBuilding:self.btnResource4 :204 :self.arrayPtResource[3]];
    [self createBuilding:self.btnResource5 :205 :self.arrayPtResource[4]];
    [self createBuilding:self.btnResource6 :206 :self.arrayPtResource[5]];
    [self createBuilding:self.btnResource7 :207 :self.arrayPtResource[6]];
    [self createBuilding:self.btnResource8 :208 :self.arrayPtResource[7]];
    [self createBuilding:self.btnResource9 :209 :self.arrayPtResource[8]];
    [self createBuilding:self.btnResource10 :210 :self.arrayPtResource[9]];
    [self createBuilding:self.btnResource11 :211 :self.arrayPtResource[10]];
    [self createBuilding:self.btnResource12 :212 :self.arrayPtResource[11]];
    [self createBuilding:self.btnResource13 :213 :self.arrayPtResource[12]];
    [self createBuilding:self.btnResource14 :214 :self.arrayPtResource[13]];
    [self createBuilding:self.btnResource15 :215 :self.arrayPtResource[14]];
    [self createBuilding:self.btnResource16 :216 :self.arrayPtResource[15]];
    [self createBuilding:self.btnResource17 :217 :self.arrayPtResource[16]];
    [self createBuilding:self.btnResource18 :218 :self.arrayPtResource[17]];
    [self createBuilding:self.btnResource19 :219 :self.arrayPtResource[18]];
    [self createBuilding:self.btnResource20 :220 :self.arrayPtResource[19]];
    
    self.arrayBtnResource = [@[self.btnResource1,
                              self.btnResource2,
                              self.btnResource3,
                              self.btnResource4,
                              self.btnResource5,
                              self.btnResource6,
                              self.btnResource7,
                              self.btnResource8,
                              self.btnResource9,
                              self.btnResource10,
                              self.btnResource11,
                              self.btnResource12,
                              self.btnResource13,
                              self.btnResource14,
                              self.btnResource15,
                              self.btnResource16,
                              self.btnResource17,
                              self.btnResource18,
                              self.btnResource19,
                              self.btnResource20] mutableCopy];
}

- (void)setupInsideBuildings
{
    //1st row right to the right vertical
    [self createBuilding:self.btnInside1 :301 :self.arrayPtInside[0]];
    [self createBuilding:self.btnInside2 :302 :self.arrayPtInside[1]];
    [self createBuilding:self.btnInside3 :303 :self.arrayPtInside[2]];
    [self createBuilding:self.btnInside4 :304 :self.arrayPtInside[3]];
    
    [self createBuilding:self.btnInside5 :305 :self.arrayPtInside[4]];
    [self createBuilding:self.btnInside6 :306 :self.arrayPtInside[5]];
    [self createBuilding:self.btnInside7 :307 :self.arrayPtInside[6]];
    [self createBuilding:self.btnInside8 :308 :self.arrayPtInside[7]];
    
    [self createBuilding:self.btnInside9 :309 :self.arrayPtInside[8]];
    [self createBuilding:self.btnInside10 :310 :self.arrayPtInside[9]];
    [self createBuilding:self.btnInside11 :311 :self.arrayPtInside[10]];
    [self createBuilding:self.btnInside12 :312 :self.arrayPtInside[11]];
    
    [self createBuilding:self.btnInside13 :313 :self.arrayPtInside[12]];
    [self createBuilding:self.btnInside14 :314 :self.arrayPtInside[13]];
    [self createBuilding:self.btnInside15 :315 :self.arrayPtInside[14]];
    [self createBuilding:self.btnInside16 :316 :self.arrayPtInside[15]];
    
    [self createBuilding:self.btnInside17 :317 :self.arrayPtInside[16]];
    [self createBuilding:self.btnInside18 :318 :self.arrayPtInside[17]];
    [self createBuilding:self.btnInside19 :319 :self.arrayPtInside[18]];
    [self createBuilding:self.btnInside20 :320 :self.arrayPtInside[19]];
    
    [self createBuilding:self.btnInside21 :321 :self.arrayPtInside[20]];
    [self createBuilding:self.btnInside22 :322 :self.arrayPtInside[21]];
    [self createBuilding:self.btnInside23 :323 :self.arrayPtInside[22]];
    [self createBuilding:self.btnInside24 :324 :self.arrayPtInside[23]];
    [self createBuilding:self.btnInside25 :325 :self.arrayPtInside[24]];
    
    self.arrayBtnInside = [@[self.btnInside1,
                            self.btnInside2,
                            self.btnInside3,
                            self.btnInside4,
                            self.btnInside5,
                            self.btnInside6,
                            self.btnInside7,
                            self.btnInside8,
                            self.btnInside9,
                            self.btnInside10,
                            self.btnInside11,
                            self.btnInside12,
                            self.btnInside13,
                            self.btnInside14,
                            self.btnInside15,
                            self.btnInside16,
                            self.btnInside17,
                            self.btnInside18,
                            self.btnInside19,
                            self.btnInside20,
                            self.btnInside21,
                            self.btnInside22,
                            self.btnInside23,
                            self.btnInside24,
                            self.btnInside25] mutableCopy];
}

- (void)setupVillageBuildings
{
    //1st row right to the right vertical
    [self createBuilding:self.btnInside1 :401 :self.arrayPtVillage[0]];
    [self createBuilding:self.btnInside2 :402 :self.arrayPtVillage[1]];
    [self createBuilding:self.btnInside3 :403 :self.arrayPtVillage[2]];
    [self createBuilding:self.btnInside4 :404 :self.arrayPtVillage[3]];
    
    [self createBuilding:self.btnInside5 :405 :self.arrayPtVillage[4]];
    [self createBuilding:self.btnInside6 :406 :self.arrayPtVillage[5]];
    [self createBuilding:self.btnInside7 :407 :self.arrayPtVillage[6]];
    [self createBuilding:self.btnInside8 :408 :self.arrayPtVillage[7]];
    
    [self createBuilding:self.btnInside9 :409 :self.arrayPtVillage[8]];
    [self createBuilding:self.btnInside10 :410 :self.arrayPtVillage[9]];
    [self createBuilding:self.btnInside11 :411 :self.arrayPtVillage[10]];
    [self createBuilding:self.btnInside12 :412 :self.arrayPtVillage[11]];
    
    [self createBuilding:self.btnInside13 :413 :self.arrayPtVillage[12]];
    [self createBuilding:self.btnInside14 :414 :self.arrayPtVillage[13]];
    [self createBuilding:self.btnInside15 :415 :self.arrayPtVillage[14]];
    [self createBuilding:self.btnInside16 :416 :self.arrayPtVillage[15]];
    
    [self createBuilding:self.btnInside17 :417 :self.arrayPtVillage[16]];
    [self createBuilding:self.btnInside18 :418 :self.arrayPtVillage[17]];
    
    self.arrayBtnInside = [@[self.btnInside1,
                             self.btnInside2,
                             self.btnInside3,
                             self.btnInside4,
                             self.btnInside5,
                             self.btnInside6,
                             self.btnInside7,
                             self.btnInside8,
                             self.btnInside9,
                             self.btnInside10,
                             self.btnInside11,
                             self.btnInside12,
                             self.btnInside13,
                             self.btnInside14,
                             self.btnInside15,
                             self.btnInside16,
                             self.btnInside17,
                             self.btnInside18,
                             self.btnInside19,
                             self.btnInside20,
                             self.btnInside21,
                             self.btnInside22,
                             self.btnInside23,
                             self.btnInside24,
                             self.btnInside25] mutableCopy];
}

- (UIImage *)getBuildingImage:(NSString *)building_id level:(NSString *)level
{
    NSInteger b_lvl = [level integerValue];
    NSString *b_stage = @"1";
    
    if (b_lvl < 8)
    {
        b_stage = @"1";
    }
    else if (b_lvl < 16)
    {
        b_stage = @"2";
    }
    else
    {
        b_stage = @"3";
    }
    
    NSString *b_image = [NSString stringWithFormat:@"building%@_%@", building_id, b_stage];
    
    return [Globals.i imageNamedCustom:b_image];
}

- (UIImage *)getCastleImage:(NSString *)level
{
    if (self.i_am_village)
    {
        return [self getBuildingImage:@"103" level:level];
    }
    else
    {
        return [self getBuildingImage:@"101" level:level];
    }
}

- (CGPoint)twoDToIso:(CGPoint)pt
{
    CGPoint tempPt = CGPointMake(0.0f, 0.0f);
    tempPt.x = pt.x - pt.y;
    tempPt.y = (pt.x + pt.y) / 2;
    
    NSLog(@"%f , %f", tempPt.x, tempPt.y);
    
    return(tempPt);
}

- (void)createBuilding:(UIButton *)btnBuilding :(NSInteger)location :(NSDictionary *)pt
{
    [self drawBuilding:btnBuilding :location :pt :NO];
}

- (void)drawBuilding:(UIButton *)btnBuilding :(NSInteger)location :(NSDictionary *)pt :(BOOL)redraw
{
    UIImage *imgD = nil;
    NSString *building_level = nil;
    NSString *building_id = nil;
    
    UIImage *img_platform = [Globals.i imageNamedCustom:@"platform1"];
    NSInteger platform_sizex = (img_platform.size.width*SCALE_BUILDINGS);
    NSInteger platform_sizey = (img_platform.size.height*SCALE_BUILDINGS);
    
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"location"] integerValue] == location)
        {
            building_level = dict[@"building_level"];
            building_id = dict[@"building_id"];
            
            imgD = [self getBuildingImage:building_id level:building_level];
            NSInteger sizex = 204;//(imgD.size.width*SCALE_BUILDINGS);
            NSInteger sizey = 250;//(imgD.size.height*SCALE_BUILDINGS);
            
            NSInteger offsety = sizey - platform_sizey;
            
            float start_x = [[pt objectForKey:@"x"] floatValue];
            float start_y = [[pt objectForKey:@"y"] floatValue] - offsety;
            
            if (btnBuilding == nil)
            {
                btnBuilding = [[UIButton alloc] init];
            }
            
            if (!redraw)
            {
                [btnBuilding removeFromSuperview];
                [self.imageView addSubview:btnBuilding];
            }
            
            [btnBuilding setFrame:CGRectMake(start_x, start_y, sizex, sizey)];
            
            if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:dict[@"location"]] && (Globals.i.buildQueue1 > 1))
            {
                [self.ivBuildOverlay removeFromSuperview];
                [self.ivBuildOverlay setFrame:CGRectMake(0.0f, 0.0f, btnBuilding.frame.size.width, btnBuilding.frame.size.height)];
                [btnBuilding addSubview:self.ivBuildOverlay];
                
                [self.ivBuildAnimation setFrame:CGRectMake(0.0f, 0.0f, 70.0f*SCALE_IPAD, 70.0f*SCALE_IPAD)];
                [btnBuilding addSubview:self.ivBuildAnimation];
                [self.ivBuildAnimation startAnimating];
                
                NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:dict[@"building_id"] level:[dict[@"building_level"] integerValue]];
                
                float boost_c = ([Globals.i.wsBaseDict[@"boost_build"] floatValue] / 100.0f) + 1.0f;
                NSInteger time = [buildingLevelDict[@"time"] floatValue] / boost_c;

                NSString *title = [NSString stringWithFormat:@"%@ Lv.%@", [Globals.i getBuildingDict:dict[@"building_id"]][@"building_name"], dict[@"building_level"]];
                
                [Globals.i updateTv:TV_BUILD time:time title:title];
            }
            
            [self addLevelLabel:btnBuilding label:building_level];
        }
    }
    
    if (building_id == nil)
    {
        float start_x = [[pt objectForKey:@"x"] floatValue];
        float start_y = [[pt objectForKey:@"y"] floatValue];
        
        if (btnBuilding == nil)
        {
            btnBuilding = [[UIButton alloc] init];
        }
        
        [btnBuilding removeFromSuperview];
        
        [btnBuilding setFrame:CGRectMake(start_x, start_y, platform_sizex, platform_sizey)];
        
        for (UIView *subview in btnBuilding.subviews)
        {
            if (subview.tag == 99) //remove only num labels
            {
                [subview removeFromSuperview];
            }
        }
        
        [self.imageView addSubview:btnBuilding];
        
        [btnBuilding setBackgroundImage:img_platform forState:UIControlStateNormal];
        [btnBuilding setBackgroundImage:img_platform forState:UIControlStateHighlighted];
    }
    else
    {
        [btnBuilding setBackgroundImage:imgD forState:UIControlStateNormal];
        [btnBuilding setBackgroundImage:imgD forState:UIControlStateHighlighted];
    }
    
    [btnBuilding addTarget:self action:@selector(buildingButton_tap:) forControlEvents:UIControlEventTouchUpInside];
    btnBuilding.tag = location;
}

- (void)addLevelLabel:(UIButton *)button label:(NSString *)lbl
{
    UIImage *image = [Globals.i imageNamedCustom:[NSString stringWithFormat:@"level_overlay_%@", lbl]];
    UIImageView *myImage = [[UIImageView alloc] initWithImage:image];
    
    NSInteger sizex = (image.size.width*1.2f); //TODO: test the right ratio
    NSInteger sizey = (image.size.height*1.2f);
    
    myImage.frame = CGRectMake(button.frame.size.width-(sizex*1.5f), button.frame.size.height-sizey, sizex, sizey);
    myImage.tag = 99;
    
    for (UIView *subview in button.subviews)
    {
        if (subview.tag == 99) //remove only num labels
        {
            [subview removeFromSuperview];
        }
    }
    
    [button addSubview:myImage];
}

- (void)addLevelLabelforCastle:(UIButton *)button label:(NSString *)lbl
{
    UIImage *image = [Globals.i imageNamedCustom:[NSString stringWithFormat:@"level_overlay_%@", lbl]];
    UIImageView *myImage = [[UIImageView alloc] initWithImage:image];
    
    NSInteger sizex = (image.size.width*1.2f); //TODO: test the right ratio
    NSInteger sizey = (image.size.height*1.2f);
    
    NSInteger offset_x = button.frame.size.width * 0.2f;
    NSInteger offset_y = button.frame.size.height * 0.075f;
    
    myImage.frame = CGRectMake(button.frame.size.width-offset_x-(sizex*1.5f), button.frame.size.height-offset_y-sizey, sizex, sizey);
    myImage.tag = 99;
    
    for (UIView *subview in button.subviews)
    {
        if (subview.tag == 99) //remove only num labels
        {
            [subview removeFromSuperview];
        }
    }
    
    [button addSubview:myImage];
}

- (void)addLevelLabelforWall:(UIButton *)button label:(NSString *)lbl
{
    UIImage *image = [Globals.i imageNamedCustom:[NSString stringWithFormat:@"level_overlay_%@", lbl]];
    UIImageView *myImage = [[UIImageView alloc] initWithImage:image];
    
    NSInteger sizex = (image.size.width*1.2f); //TODO: test the right ratio
    NSInteger sizey = (image.size.height*1.2f);
    
    CGFloat pos_x = 1300.0f;
    CGFloat pos_y = 1230.0f;
    
    if (self.i_am_village)
    {
        pos_x = 2075.0f;
        pos_y = 1200.0f;
    }
    
    myImage.frame = CGRectMake(pos_x, pos_y, sizex, sizey);
    myImage.tag = 99;
    
    for (UIView *subview in button.subviews)
    {
        if (subview.tag == 99) //remove only num labels
        {
            [subview removeFromSuperview];
        }
    }
    
    [button addSubview:myImage];
}

- (void)createCastle:(BOOL)redraw
{
    NSString *building_level = @"1";
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"location"] integerValue] == 101)
        {
            building_level = dict[@"building_level"];
        }
    }
    
    if (building_level != nil)
    {
        CGPoint pt = CGPointMake(250.0f, 150.0f);
        
        UIImage *imgD = [self getCastleImage:building_level];
        
        if (self.i_am_village)
        {
            pt = CGPointMake(1250.0f, 350.0f);
        }
        
        NSInteger sizex = 510;//(imgD.size.width*SCALE_CASLTE);
        NSInteger sizey = 600;//(imgD.size.height*SCALE_CASLTE);
        
        if (self.btnCastle == nil)
        {
            self.btnCastle = [[UIButton alloc] init];
            [self.btnCastle addTarget:self action:@selector(buildingButton_tap:) forControlEvents:UIControlEventTouchUpInside];
            self.btnCastle.tag = 101;
        }
        
        if (!redraw)
        {
            [self.btnCastle removeFromSuperview];
            
            [self.btnCastle setFrame:CGRectMake(pt.x, pt.y, sizex, sizey)];
            
            [self.btnCastle setBackgroundImage:imgD forState:UIControlStateNormal];
            [self.btnCastle setBackgroundImage:imgD forState:UIControlStateHighlighted];
            
            [self.imageView addSubview:self.btnCastle];
        }
        
        if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:@"101"] && (Globals.i.buildQueue1 > 1))
        {
            [self.ivCastleOverlay removeFromSuperview];
            [self.ivCastleOverlay setFrame:CGRectMake(0.0f, 0.0f, self.btnCastle.frame.size.width, self.btnCastle.frame.size.height)];
            [self.btnCastle addSubview:self.ivCastleOverlay];
            
            CGFloat ba_x = sizex / 2.0f;
            CGFloat ba_y = sizey / 5.0f;
            
            [self.ivBuildAnimation setFrame:CGRectMake(ba_x, ba_y, 70.0f*SCALE_IPAD, 70.0f*SCALE_IPAD)];
            [self.btnCastle addSubview:self.ivBuildAnimation];
            [self.ivBuildAnimation startAnimating];
            
            NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:@"101" level:[building_level integerValue]];
            
            float boost_c = ([Globals.i.wsBaseDict[@"boost_build"] floatValue] / 100.0f) + 1.0f;
            NSInteger time = [buildingLevelDict[@"time"] floatValue] / boost_c;
            
            NSString *title = [NSString stringWithFormat:@"%@ Lv.%@", [Globals.i getBuildingDict:@"101"][@"building_name"], building_level];
            
            [Globals.i updateTv:TV_BUILD time:time title:title];
        }
        
        [self addLevelLabelforCastle:self.btnCastle label:building_level];
    }
}

- (void)createWall:(BOOL)redraw
{
    NSString *building_level = @"1";
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"location"] integerValue] == 102)
        {
            building_level = dict[@"building_level"];
        }
    }
    
    if (building_level != nil)
    {
        CGPoint pt = CGPointMake(0, 0);
        UIImage *imgD = [Globals.i imageNamedCustom:@"walls_city_1"];
        
        NSInteger sizex = (imgD.size.width*1);
        NSInteger sizey = (imgD.size.height*1);
        
        if (self.i_am_village)
        {
            pt = CGPointMake(0, 0);
            imgD = [Globals.i imageNamedCustom:@"walls_village_1"];
            
            sizex = (imgD.size.width*1);
            sizey = (imgD.size.height*1);
        }
        
        if (self.btnWall == nil)
        {
            //self.btnWall = [[UIButton alloc] init];
            self.btnWall = [[OBShapedButton alloc] init];
            [self.btnWall addTarget:self action:@selector(buildingButton_tap:) forControlEvents:UIControlEventTouchUpInside];
            self.btnWall.tag = 102;
        }
        
        if (!redraw)
        {
            [self.btnWall removeFromSuperview];
            [self.imageView addSubview:self.btnWall];
        }
        
        [self.btnWall setFrame:CGRectMake(pt.x, pt.y, sizex, sizey)];

        [self.btnWall setBackgroundImage:imgD forState:UIControlStateNormal];
        [self.btnWall setBackgroundImage:imgD forState:UIControlStateHighlighted];
        
        if ([Globals.i.wsBaseDict[@"build_location"] isEqualToString:@"102"] && (Globals.i.buildQueue1 > 1))
        {
            if (self.i_am_village)
            {
                [self.ivWallVillageOverlay removeFromSuperview];
                [self.ivWallVillageOverlay setFrame:CGRectMake(0.0f, 0.0f, self.btnWall.frame.size.width, self.btnWall.frame.size.height)];
                [self.btnWall addSubview:self.ivWallVillageOverlay];
            }
            else
            {
                [self.ivWallCityOverlay removeFromSuperview];
                [self.ivWallCityOverlay setFrame:CGRectMake(0.0f, 0.0f, self.btnWall.frame.size.width, self.btnWall.frame.size.height)];
                [self.btnWall addSubview:self.ivWallCityOverlay];
            }
            
            CGFloat ba_x = 1300.0f;
            CGFloat ba_y = 1130.0f;
            if (self.i_am_village)
            {
                ba_x = 2075.0f;
                ba_y = 1100.0f;
            }
            [self.ivBuildAnimation setFrame:CGRectMake(ba_x, ba_y, 70.0f*SCALE_IPAD, 70.0f*SCALE_IPAD)];
            [self.btnWall addSubview:self.ivBuildAnimation];
            [self.ivBuildAnimation startAnimating];
            
            NSDictionary *buildingLevelDict = [Globals.i getBuildingLevel:@"102" level:[building_level integerValue]];
            
            float boost_c = ([Globals.i.wsBaseDict[@"boost_build"] floatValue] / 100.0f) + 1.0f;
            NSInteger time = [buildingLevelDict[@"time"] floatValue] / boost_c;
            
            NSString *title = [NSString stringWithFormat:@"%@ Lv.%@", [Globals.i getBuildingDict:@"102"][@"building_name"], building_level];

            [Globals.i updateTv:TV_BUILD time:time title:title];
        }
        
        [self addLevelLabelforWall:self.btnWall label:building_level];
    }
}

- (void)buildingButton_tap:(id)sender
{
    if (!self.buildingTapped)
    {
        self.buildingTapped = YES;
        
        NSInteger tag = [sender tag];
        
        NSLog(@"Building location: %ld",(long)tag);
        
        UIButton *btn = (UIButton*)[self.imageView viewWithTag:tag];
        
        [self performSelector:@selector(stopGlowingButton:) withObject:btn afterDelay:1.0];
        
        if (tag == 101) //Castle
        {
            [btn startGlowingWithColor:[UIColor yellowColor] intensity:0.7];
            [self performSelector:@selector(showCastle) withObject:nil afterDelay:0.5];
        }
        else if (tag == 102) //Wall
        {
            // NOTE: Bug, for the 1st time this is called on wall, this will freeze the game
            //[btn startGlowingWithColor:[UIColor yellowColor] intensity:0.7];
            /*
            for (UIView *btnWall in [self.imageView subviews])
            {
                if (btnWall.tag == 102)
                {
                    [btnWall startGlowingWithColor:[UIColor yellowColor] intensity:0.7];
                }
            }
             */
            
            //[self performSelector:@selector(stopGlowingWall) withObject:nil afterDelay:0.4];
            
            [self performSelector:@selector(showWall) withObject:nil afterDelay:0.5];
        }
        else if (tag > 200 && tag < 500) //Buildings
        {
            [btn startGlowingWithColor:[UIColor yellowColor] intensity:0.7];
            [self performSelector:@selector(showBuilding:) withObject:[NSNumber numberWithInteger:tag] afterDelay:0.5];
        }
        else //Test Buildings
        {
            [btn startGlowingWithColor:[UIColor yellowColor] intensity:0.7];
            [self performSelector:@selector(testBuilding:) withObject:[NSNumber numberWithInteger:tag] afterDelay:0.0];
        }
    }
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    //Manual setup building coor
    /*
    CGPoint pt = [gesture locationInView:self.imageView];
    
    float offset_x = 0.0f;
    float offset_y = 0.0f;
    
    UIImage *imgD = [Globals.i imageNamedCustom:@"platform1"];
    NSInteger sizex = (imgD.size.width*SCALE_BUILDINGS);
    NSInteger sizey = (imgD.size.height*SCALE_BUILDINGS);
    
    float start_x = (pt.x - sizex/2.0f) + offset_x;
    float start_y = (pt.y - sizey/2.0f) + offset_y;
    
    NSInteger tag_pos = start_x*1000 + start_y;
    
    NSLog(@"Pos at (%@, %@)", [@(start_x) stringValue], [@(start_y) stringValue]);
    
    NSDictionary *dict = @{@"x": @(start_x), @"y": @(start_y)};
    
    [self createBuilding:self.btnInside1 :tag_pos :dict];
    */
}

- (void)testBuilding:(NSNumber *)tag
{
    UIButton *btn = (UIButton*)[self.imageView viewWithTag:[tag integerValue]];
    //[btn removeFromSuperview];
    
    float pt_x = btn.frame.origin.x;
    float pt_y = btn.frame.origin.y;
    
    UIImage *imgD = [Globals.i imageNamedCustom:@"platform1"];
    //NSInteger sizex = (imgD.size.width*SCALE_BUILDINGS);
    NSInteger platform_sizey = (imgD.size.height*SCALE_BUILDINGS);
    
    NSInteger offsety = btn.frame.size.height - platform_sizey;
    
    float start_y = pt_y + offsety;
    
    NSLog(@"Pos at (%@, %@)", [@(pt_x) stringValue], [@(start_y) stringValue]);
}

- (void)stopGlowingButton:(UIView *)v
{
    [v stopGlowing];
    
    self.buildingTapped = NO;
}

- (void)stopGlowingWall
{
    /*
    for (UIView *btnWall in [self.imageView subviews])
    {
        if (btnWall.tag == 102)
        {
            [btnWall stopGlowing];
        }
    }
     
    
    self.buildingTapped = NO;
    */
}

- (void)showCastle
{
    [Globals.i play_castle];
    
    NSString *building_level = @"1";
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"location"] integerValue] == 101)
        {
            building_level = dict[@"building_level"];
        }
    }
    
    NSString *upgrading = @"0";
    //Check if this building is under construction
    if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:@"101"] && (Globals.i.buildQueue1 > 1))
    {
        NSInteger blvl = [building_level integerValue];
        blvl = blvl-1;
        building_level = [@(blvl) stringValue];
        upgrading = @"1";
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"101" forKey:@"building_id"];
    [userInfo setObject:building_level forKey:@"building_level"];
    [userInfo setObject:@"101" forKey:@"building_location"];
    [userInfo setObject:upgrading forKey:@"upgrading"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowCastle"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)showWall
{
    [Globals.i play_wall];
    
    
    NSString *building_level = @"1";
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"location"] integerValue] == 102)
        {
            building_level = dict[@"building_level"];
        }
    }
    
    NSString *upgrading = @"0";
    //Check if this building is under construction
    if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:@"102"] && (Globals.i.buildQueue1 > 1))
    {
        NSInteger blvl = [building_level integerValue];
        blvl = blvl-1;
        building_level = [@(blvl) stringValue];
        upgrading = @"1";
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"102" forKey:@"building_id"];
    [userInfo setObject:building_level forKey:@"building_level"];
    [userInfo setObject:@"102" forKey:@"building_location"];
    [userInfo setObject:upgrading forKey:@"upgrading"];
     
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowWall"
                                                        object:self
                                                      userInfo:userInfo];
    
     
}

- (void)showBuilding:(NSNumber *)tag
{
    NSString *building_id = nil;
    NSString *building_level = nil;
    
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"location"] integerValue] == [tag integerValue])
        {
            building_id = dict[@"building_id"];
            building_level = dict[@"building_level"];
        }
    }
    
    if (building_id == nil)
    {
        [Globals.i play_placement];
        
        if (self.buildList == nil)
        {
            self.buildList = [[BuildList alloc] initWithStyle:UITableViewStylePlain];
        }
        
        self.buildList.location = [tag integerValue];
        
        if (self.buildList.location > 200 && self.buildList.location < 300)
        {
            self.buildList.inside_outside_both = 2;
            self.buildList.title = NSLocalizedString(@"Rural Buildings", nil);
        }
        else if (self.buildList.location > 300 && self.buildList.location < 400) //Inside Buildings
        {
            self.buildList.inside_outside_both = 1;
            self.buildList.title = NSLocalizedString(@"Urban Buildings", nil);
        }
        else if (self.buildList.location > 400 && self.buildList.location < 500) //Village Buildings
        {
            self.buildList.inside_outside_both = 3;
            self.buildList.title = NSLocalizedString(@"Village Buildings", nil);
        }
        
        [self.buildList updateView];
        
        [UIManager.i showTemplate:@[self.buildList] :self.buildList.title];
    }
    else
    {
        NSString *notName = @"0";
        
        if ([building_id isEqualToString:@"1"])
        {
            notName = @"ShowResourcesView";
            [Globals.i play_farm];
        }
        else if ([building_id isEqualToString:@"2"])
        {
            notName = @"ShowResourcesView";
            [Globals.i play_sawmill];
        }
        else if ([building_id isEqualToString:@"3"])
        {
            notName = @"ShowResourcesView";
            [Globals.i play_quarry];
        }
        else if ([building_id isEqualToString:@"4"])
        {
            notName = @"ShowResourcesView";
            [Globals.i play_mine];
        }
        else if ([building_id isEqualToString:@"5"])
        {
            notName = @"ShowResourcesView";
            [Globals.i play_house];
        }
        else if ([building_id isEqualToString:@"6"])
        {
            notName = @"ShowTrain";
            [Globals.i play_barracks];
        }
        else if ([building_id isEqualToString:@"7"])
        {
            notName = @"ShowArchery";
            [Globals.i play_archery];
        }
        else if ([building_id isEqualToString:@"8"])
        {
            notName = @"ShowStable";
            [Globals.i play_stable];
        }
        else if ([building_id isEqualToString:@"9"])
        {
            notName = @"ShowWorkshop";
            [Globals.i play_siege];
        }
        else if ([building_id isEqualToString:@"10"])
        {
            notName = @"ShowHospital";
            [Globals.i play_hospital];
        }
        else if ([building_id isEqualToString:@"11"])
        {
            notName = @"ShowStorehouse";
            [Globals.i play_storehouse];
        }
        else if ([building_id isEqualToString:@"12"])
        {
            notName = @"ShowMarket";
            [Globals.i play_market];
        }
        else if ([building_id isEqualToString:@"13"])
        {
            notName = @"ShowEmbassy";
            [Globals.i play_embassy];
        }
        else if ([building_id isEqualToString:@"14"])
        {
            notName = @"ShowWatchtower";
            [Globals.i play_watchtower];
        }
        else if ([building_id isEqualToString:@"15"])
        {
            notName = @"ShowResearch";
            [Globals.i play_library];
        }
        else if ([building_id isEqualToString:@"16"])
        {
            notName = @"ShowCraft";
            [Globals.i play_blacksmith];
        }
        else if ([building_id isEqualToString:@"17"])
        {
            notName = @"ShowTavern";
            [Globals.i play_tavern];
        }
        else if ([building_id isEqualToString:@"18"])
        {
            notName = @"ShowMarches";
            [Globals.i play_rallypoint];
        }
        
        if (![notName isEqualToString:@"0"])
        {
            NSString *upgrading = @"0";
            //Check if this building is under construction
            if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:[tag stringValue]] && (Globals.i.buildQueue1 > 1))
            {
                NSInteger blvl = [building_level integerValue];
                blvl = blvl-1;
                building_level = [@(blvl) stringValue];
                upgrading = @"1";
            }
            
            if (![building_level isEqualToString:@"0"] && ![building_level isEqualToString:@""])
            {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:building_id forKey:@"building_id"];
                [userInfo setObject:building_level forKey:@"building_level"];
                [userInfo setObject:@([tag integerValue]) forKey:@"building_location"];
                [userInfo setObject:upgrading forKey:@"upgrading"];
                [[NSNotificationCenter defaultCenter] postNotificationName:notName
                                                                    object:self
                                                                  userInfo:userInfo];
            }
        }
    }
}

- (void)updateSalesButton
{
    [self.buttonSale removeFromSuperview];
    [self.labelSale removeFromSuperview];
    
    if (Globals.i.wsSalesDict != nil)
    {
        //Update time left in seconds for sale to end
        NSTimeInterval serverTimeInterval = [Globals.i updateTime];
        NSString *strDate = Globals.i.wsSalesDict[@"sale_ending"];
        
        NSDate *saleEndDate = [Globals.i dateParser:strDate];
        NSTimeInterval saleEndTime = [saleEndDate timeIntervalSince1970];
        self.b1s = saleEndTime - serverTimeInterval;
        
        if (self.b1s > 0)
        {
            [self addSaleButton:@"Sale!" imageDefault:@"icon_sale1"];
        }
    }
}

- (void)updateEventSoloButton
{
    [self.buttonEventSolo removeFromSuperview];
    [self.labelEventSolo1 removeFromSuperview];
    [self.labelEventSolo2 removeFromSuperview];
    
    [Globals.i updateEventSolo];
    
    NSDictionary *wsData = Globals.i.wsEventSoloDict;
    if (wsData != nil)
    {
        //Update time left in seconds for event to end
        NSTimeInterval serverTimeInterval = [Globals.i updateTime];
        NSString *strDate = wsData[@"event_ending"];
        
        NSDate *endDate = [Globals.i dateParser:strDate];
        NSTimeInterval endTime = [endDate timeIntervalSince1970];
        self.b2s = endTime - serverTimeInterval;
        
        [self addEventSoloButton];
    }
    else
    {
        self.b2s = 0;
    }
}

- (void)updateEventAllianceButton
{
    [self.buttonEventAlliance removeFromSuperview];
    [self.labelEventAlliance1 removeFromSuperview];
    [self.labelEventAlliance2 removeFromSuperview];
    
    [Globals.i updateEventAlliance];
    
    NSDictionary *wsData = Globals.i.wsEventAllianceDict;
    if (wsData != nil)
    {
        //Update time left in seconds for event to end
        NSTimeInterval serverTimeInterval = [Globals.i updateTime];
        NSString *strDate = wsData[@"event_ending"];
        
        NSDate *endDate = [Globals.i dateParser:strDate];
        NSTimeInterval endTime = [endDate timeIntervalSince1970];
        self.b3s = endTime - serverTimeInterval;
        
        [self addEventAllianceButton];
    }
    else
    {
        self.b3s = 0;
    }
}

- (void)addSaleButton:(NSString *)label imageDefault:(NSString *)imageDefault
{
    UIImage *imgD = [Globals.i imageNamedCustom:imageDefault];
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger posx = UIScreen.mainScreen.bounds.size.width - sizex;
    NSInteger posy = 40.0f*SCALE_IPAD;
    
	self.buttonSale = [UIManager.i buttonWithTitle:@""
                                            target:self
                                          selector:@selector(saleButton_tap:)
                                             frame:CGRectMake(posx, posy, sizex, sizey)
                                       imageNormal:nil
                                  imageHighlighted:nil
                                     imageCentered:NO
                                     darkTextColor:YES];
    
    [self.buttonSale setBackgroundImage:[UIImage animatedImageNamed:@"icon_sale" duration:1.0]
                               forState:UIControlStateNormal];
    
	[self.view addSubview:self.buttonSale];
	
	self.labelSale = [[UILabel alloc] initWithFrame:CGRectMake(posx, posy+sizey-menu_label_height, sizex, menu_label_height)];
	self.labelSale.text = label;
    self.labelSale.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
	self.labelSale.backgroundColor = [UIColor clearColor];
	self.labelSale.textColor = [UIColor whiteColor];
	self.labelSale.textAlignment = NSTextAlignmentCenter;
	self.labelSale.numberOfLines = 1;
	self.labelSale.adjustsFontSizeToFitWidth = YES;
	self.labelSale.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.labelSale];
}

- (void)saleButton_tap:(id)sender
{
    [Globals.i play_gold];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSales" object:self];
}

- (void)addEventSoloButton
{
    UIImage *imgD = [Globals.i imageNamedCustom:@"icon_green_normal"];
    UIImage *imgH = [Globals.i imageNamedCustom:@"icon_green_highlight"];
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger column_start_x = 10.0f*SCALE_IPAD;
    
    NSInteger posx = UIScreen.mainScreen.bounds.size.width - sizex;
    NSInteger posy = 110.0f*SCALE_IPAD;
    
	self.buttonEventSolo = [UIManager.i buttonWithTitle:@""
                                                 target:self
                                               selector:@selector(eventSoloButton_tap:)
                                                  frame:CGRectMake(posx, posy, sizex, sizey)
                                            imageNormal:imgD
                                       imageHighlighted:imgH
                                          imageCentered:NO
                                          darkTextColor:YES];
    
	[self.view addSubview:self.buttonEventSolo];
	
	self.labelEventSolo1 = [[UILabel alloc] initWithFrame:CGRectMake(posx+(2*column_start_x), posy, sizex-(2*column_start_x), menu_label_height)];
    self.labelEventSolo1.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
	self.labelEventSolo1.backgroundColor = [UIColor clearColor];
	self.labelEventSolo1.textColor = [UIColor blackColor];
	self.labelEventSolo1.textAlignment = NSTextAlignmentCenter;
	self.labelEventSolo1.numberOfLines = 1;
	self.labelEventSolo1.adjustsFontSizeToFitWidth = YES;
	self.labelEventSolo1.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.labelEventSolo1];
    
    self.labelEventSolo2 = [[UILabel alloc] initWithFrame:CGRectMake(posx+(2*column_start_x), posy+menu_label_height-DEFAULT_CONTENT_SPACING, sizex-(2*column_start_x), menu_label_height)];
    self.labelEventSolo2.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
	self.labelEventSolo2.backgroundColor = [UIColor clearColor];
	self.labelEventSolo2.textColor = [UIColor blackColor];
	self.labelEventSolo2.textAlignment = NSTextAlignmentCenter;
	self.labelEventSolo2.numberOfLines = 1;
	self.labelEventSolo2.adjustsFontSizeToFitWidth = YES;
	self.labelEventSolo2.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.labelEventSolo2];
}

- (void)eventSoloButton_tap:(id)sender
{
    [Globals.i play_button];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EventSolo" object:self];
}

- (void)addEventAllianceButton
{
    UIImage *imgD = [Globals.i imageNamedCustom:@"icon_yellow_normal"];
    UIImage *imgH = [Globals.i imageNamedCustom:@"icon_yellow_highlight"];
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger column_start_x = 10.0f*SCALE_IPAD;
    
    NSInteger posx = UIScreen.mainScreen.bounds.size.width - sizex;
    NSInteger posy = 155.0f*SCALE_IPAD;
    
	self.buttonEventAlliance = [UIManager.i buttonWithTitle:@""
                                                     target:self
                                                   selector:@selector(eventAllianceButton_tap:)
                                                      frame:CGRectMake(posx, posy, sizex, sizey)
                                                imageNormal:imgD
                                           imageHighlighted:imgH
                                              imageCentered:NO
                                              darkTextColor:YES];
    
	[self.view addSubview:self.buttonEventAlliance];
	
	self.labelEventAlliance1 = [[UILabel alloc] initWithFrame:CGRectMake(posx+(2*column_start_x), posy, sizex-(2*column_start_x), menu_label_height)];
    self.labelEventAlliance1.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
	self.labelEventAlliance1.backgroundColor = [UIColor clearColor];
	self.labelEventAlliance1.textColor = [UIColor blackColor];
	self.labelEventAlliance1.textAlignment = NSTextAlignmentCenter;
	self.labelEventAlliance1.numberOfLines = 1;
	self.labelEventAlliance1.adjustsFontSizeToFitWidth = YES;
	self.labelEventAlliance1.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.labelEventAlliance1];
    
    self.labelEventAlliance2 = [[UILabel alloc] initWithFrame:CGRectMake(posx+(2*column_start_x), posy+menu_label_height-DEFAULT_CONTENT_SPACING, sizex-(2*column_start_x), menu_label_height)];
    self.labelEventAlliance2.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
	self.labelEventAlliance2.backgroundColor = [UIColor clearColor];
	self.labelEventAlliance2.textColor = [UIColor blackColor];
	self.labelEventAlliance2.textAlignment = NSTextAlignmentCenter;
	self.labelEventAlliance2.numberOfLines = 1;
	self.labelEventAlliance2.adjustsFontSizeToFitWidth = YES;
	self.labelEventAlliance2.minimumScaleFactor = 0.5f;
	[self.view addSubview:self.labelEventAlliance2];
}

- (void)eventAllianceButton_tap:(id)sender
{
    [Globals.i play_button];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:@"EventAlliance" object:self];
}

- (void)onTimer
{
    if ([[UIManager.i currentViewTitle] isEqualToString:@"MainView"])
    {
        [self drawHeader];
        
        self.s1 = self.s1+1;
        
        if (self.s1%6 == 0) //Toggle animated buttons label every 5 sec
        {
            if (self.timerIsShowing == NO)
            {
                self.timerIsShowing = YES;
            }
            else
            {
                self.timerIsShowing = NO;
            }
        }
        
        if (self.b1s > 0)
        {
            self.b1s = self.b1s-1;
            
            if (self.timerIsShowing == YES)
            {
                NSString *labelString = [Globals.i getCountdownString:self.b1s];
                self.labelSale.text = labelString;
            }
            else
            {
                self.labelSale.text = NSLocalizedString(@"SALE!", nil);
                
                [self.buttonSale setBackgroundImage:[UIImage animatedImageNamed:@"icon_sale" duration:1.0]
                                           forState:UIControlStateNormal];
            }
            
            if (self.b1s == 1)
            {
                [self.buttonSale removeFromSuperview];
                [self.labelSale removeFromSuperview];
            }
        }
        
        if (self.b2s > 0)
        {
            self.b2s = self.b2s-1;
            
            if (self.timerIsShowing == YES)
            {
                self.labelEventSolo1.text = NSLocalizedString(@"Ending in", nil);
                
                NSString *labelString = [Globals.i getCountdownString:self.b2s];
                self.labelEventSolo2.text = labelString;
            }
            else
            {
                self.labelEventSolo1.text = NSLocalizedString(@"Solo", nil);
                self.labelEventSolo2.text = NSLocalizedString(@"Tournament", nil);
            }
        }
        else
        {
            if (self.timerIsShowing == YES)
            {
                self.labelEventSolo1.text = NSLocalizedString(@"View", nil);
                self.labelEventSolo2.text = NSLocalizedString(@"Results", nil);
            }
            else
            {
                self.labelEventSolo1.text = NSLocalizedString(@"Solo", nil);
                self.labelEventSolo2.text = NSLocalizedString(@"Tournament", nil);
            }
        }
        
        if (self.b3s > 0)
        {
            self.b3s = self.b3s-1;
            
            if (self.timerIsShowing == YES)
            {
                self.labelEventAlliance1.text = NSLocalizedString(@"Ending in", nil);
                
                NSString *labelString = [Globals.i getCountdownString:self.b3s];
                self.labelEventAlliance2.text = labelString;
            }
            else
            {
                self.labelEventAlliance1.text = NSLocalizedString(@"Alliance", nil);
                self.labelEventAlliance2.text = NSLocalizedString(@"Tournament", nil);
            }
        }
        else
        {
            if (self.timerIsShowing == YES)
            {
                self.labelEventAlliance1.text = NSLocalizedString(@"View", nil);
                self.labelEventAlliance2.text = NSLocalizedString(@"Results", nil);
            }
            else
            {
                self.labelEventAlliance1.text = NSLocalizedString(@"Alliance", nil);
                self.labelEventAlliance2.text = NSLocalizedString(@"Tournament", nil);
            }
        }
    }
}

@end
