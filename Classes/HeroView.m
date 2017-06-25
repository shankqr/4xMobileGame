//
//  HeroView.m
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

#import "HeroView.h"
#import "Globals.h"
#import "UIView+Glow.h"
#import "HeroChart.h"

@interface HeroView ()

@property (nonatomic, strong) HeroChart *heroChart;
@property (nonatomic, strong) ProgressView *pvHeroXp;
@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) UIButton *btnHeroImage;
@property (nonatomic, strong) UILabel *lblName;
@property (nonatomic, strong) UILabel *lblLevel;
@property (nonatomic, strong) UIButton *btnAddXp;
@property (nonatomic, strong) UIButton *button1;
@property (nonatomic, strong) UIButton *button2;
@property (nonatomic, strong) UIButton *button3;
@property (nonatomic, strong) UIButton *button4;
@property (nonatomic, strong) UIButton *button5;
@property (nonatomic, strong) UIButton *button6;
@property (nonatomic, strong) UIButton *btnBoost;
@property (nonatomic, strong) UIButton *btnSkillPoints;
@property (nonatomic, strong) UIButton *btnChange;
@property (nonatomic, strong) UIButton *btnRename;

@end

@implementation HeroView

- (void)viewDidLoad
{
    [super viewDidLoad];
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
                                                 name:@"UpdateHeroXP"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeroSkillPoints"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeroItems"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeroType"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeroName"
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
    else if ([[notification name] isEqualToString:@"UpdateHeroXP"])
    {
        [self updateHero];
    }
    else if ([[notification name] isEqualToString:@"UpdateHeroSkillPoints"])
    {
        [self updateHeroSkillPoints];
    }
    else if ([[notification name] isEqualToString:@"UpdateHeroItems"])
    {
        [self updateHeroItems];
    }
    else if ([[notification name] isEqualToString:@"UpdateHeroType"])
    {
        NSString *hero_outline = @"hero_outline_male";
        NSInteger i = [Globals.i.wsWorldProfileDict[@"hero_type"] integerValue];
        if (i % 2 == 0)
        {
            hero_outline = @"hero_outline_female";
        }
        else
        {
            hero_outline = @"hero_outline_male";
        }
        
        UIImage *iHero = [Globals.i imageNamedCustom:hero_outline];
        [self.btnHeroImage setBackgroundImage:iHero forState:UIControlStateNormal];
    }
    else if ([[notification name] isEqualToString:@"UpdateHeroName"])
    {
        self.lblName.text = Globals.i.wsWorldProfileDict[@"hero_name"];
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    if (self.backgroundImage == nil)
    {
        self.backgroundImage = [[UIImageView alloc] initWithFrame:self.view.frame];
        self.backgroundImage.contentMode = UIViewContentModeScaleToFill;
        [self.backgroundImage setImage:[Globals.i imageNamedCustom:@"hero_background"]];
        [self.view addSubview:self.backgroundImage];
    }
    
    NSString *hero_outline = @"hero_outline_male";
    NSInteger i = [Globals.i.wsWorldProfileDict[@"hero_type"] integerValue];
    if (i % 2 == 0)
    {
        hero_outline = @"hero_outline_female";
    }
    else
    {
        hero_outline = @"hero_outline_male";
    }
    
    UIImage *iHero = [Globals.i imageNamedCustom:hero_outline];
    CGFloat hero_width = iHero.size.width/2.0f * SCALE_IPAD;
    CGFloat hero_height = iHero.size.height/2.0f * SCALE_IPAD;
    CGFloat hero_x = (self.view.frame.size.width - hero_width) / 2;
    CGFloat hero_y = (self.view.frame.size.height - hero_height) / 2;
    
    if (self.btnHeroImage == nil)
    {
        self.btnHeroImage = [[UIButton alloc] initWithFrame:CGRectMake(hero_x, hero_y, hero_width, hero_height)];
        [self.btnHeroImage setBackgroundImage:iHero forState:UIControlStateNormal];
        [self.btnHeroImage addTarget:self action:@selector(btnHeroImage_tap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnHeroImage];
    }
    
    CGFloat lblName_height = 30.0f*SCALE_IPAD;
    if (self.lblName == nil)
    {
        self.lblName = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, lblName_height)];
        [self.lblName setNumberOfLines:1];
        self.lblName.textAlignment = NSTextAlignmentCenter;
        [self.lblName setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:BIG_FONT_SIZE]];
        [self.lblName setBackgroundColor:[UIColor clearColor]];
        [self.lblName setTextColor:[UIColor whiteColor]];
        self.lblName.minimumScaleFactor = 1.0;
        [self.view addSubview:self.lblName];
    }
    
    CGFloat pv_x = 60.0f*SCALE_IPAD;
    CGFloat pv_w = self.view.frame.size.width-pv_x*2;
    CGFloat pv_h = 20.0f*SCALE_IPAD;
    if (self.pvHeroXp == nil)
    {
        self.pvHeroXp = [[ProgressView alloc] initWithFrame:CGRectMake(pv_x, lblName_height, pv_w, pv_h)];
        [self.pvHeroXp.barLabel1 setFont:[UIFont fontWithName:DEFAULT_FONT size:SMALL_FONT_SIZE]];
        [self.view addSubview:self.pvHeroXp];
    }
    
    CGFloat lblLevel_width = 40.0f*SCALE_IPAD;
    CGFloat lblLevel_height = 30.0f*SCALE_IPAD;
    if (self.lblLevel == nil)
    {
        self.lblLevel = [[UILabel alloc] initWithFrame:CGRectMake(pv_x-lblLevel_width, pv_h, lblLevel_width, lblLevel_height)];
        [self.lblLevel setNumberOfLines:1];
        self.lblLevel.textAlignment = NSTextAlignmentCenter;
        [self.lblLevel setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:BIG_FONT_SIZE]];
        [self.lblLevel setBackgroundColor:[UIColor blackColor]];
        [self.lblLevel setTextColor:[UIColor whiteColor]];
        self.lblLevel.minimumScaleFactor = 0.1;
        [self.view addSubview:self.lblLevel];
    }
    
    CGFloat spacing = 10.0f*SCALE_IPAD;
    
    if(self.btnAddXp == nil)
    {
        self.btnAddXp = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"ADD", nil)
                                                     target:self
                                                   selector:@selector(btnAddXp_tap)
                                                      frame:CGRectMake(pv_x+pv_w+spacing, lblName_height-spacing, lblLevel_width, pv_h+spacing)
                                                       type:@"2"];
        
        [self.view addSubview:self.btnAddXp];
    }
    
    CGFloat btn_box_size = 70.0f*SCALE_IPAD;
    
    if (self.button1 == nil)
    {
        self.button1 = [[UIButton alloc] initWithFrame:CGRectMake(spacing, lblName_height+pv_h+spacing, btn_box_size, btn_box_size)];
        [self.button1 addTarget:self action:@selector(button1_tap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button1];
    }
    
    if (self.button2 == nil)
    {
        self.button2 = [[UIButton alloc] initWithFrame:CGRectMake(spacing, self.button1.frame.origin.y+btn_box_size+spacing, btn_box_size, btn_box_size)];
        [self.button2 addTarget:self action:@selector(button2_tap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button2];
    }
    
    if (self.button3 == nil)
    {
        self.button3 = [[UIButton alloc] initWithFrame:CGRectMake(spacing, self.button2.frame.origin.y+btn_box_size+spacing, btn_box_size, btn_box_size)];
        [self.button3 addTarget:self action:@selector(button3_tap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button3];
    }
    
    if (self.button4 == nil)
    {
        self.button4 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-btn_box_size-spacing, self.button1.frame.origin.y, btn_box_size, btn_box_size)];
        [self.button4 addTarget:self action:@selector(button4_tap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button4];
    }
    
    if (self.button5 == nil)
    {
        self.button5 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-btn_box_size-spacing, self.button2.frame.origin.y, btn_box_size, btn_box_size)];
        [self.button5 addTarget:self action:@selector(button5_tap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button5];
    }
    
    if (self.button6 == nil)
    {
        self.button6 = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width-btn_box_size-spacing, self.button3.frame.origin.y, btn_box_size, btn_box_size)];
        [self.button6 addTarget:self action:@selector(button6_tap) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.button6];
    }
    
    CGFloat menu_spacing = 0.0f;
    CGFloat button_width = (self.view.frame.size.width/2.0f) - menu_spacing*2;
    CGFloat button_height = 44.0f*SCALE_IPAD;
    CGFloat button_x = menu_spacing;
    CGFloat button_y = self.view.frame.size.height-button_height;
    
    if (self.btnBoost == nil)
    {
        self.btnBoost = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"Hero Boost", nil)
                                                     target:self
                                                   selector:@selector(btnBoost_tap)
                                                      frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                       type:@"2"];
        [self.view addSubview:self.btnBoost];
    }
    
    if (self.btnRename == nil)
    {
        self.btnRename = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"Rename Hero", nil)
                                                      target:self
                                                    selector:@selector(btnRename_tap)
                                                       frame:CGRectMake(button_x, button_y-button_height-menu_spacing, button_width, button_height)
                                                        type:@"2"];
        [self.view addSubview:self.btnRename];
    }
    
    NSInteger sp_balance = Globals.i.spBalance;
    NSString *btn_title = [NSString stringWithFormat:NSLocalizedString(@"Skill Points: %@", nil), [Globals.i intString:sp_balance]];
    button_x = self.view.frame.size.width-button_width-menu_spacing;
    
    if (self.btnSkillPoints == nil)
    {
        self.btnSkillPoints = [UIManager.i dynamicButtonWithTitle:btn_title
                                                           target:self
                                                         selector:@selector(btnSkillPoints_tap)
                                                            frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                             type:@"2"];
        [self.view addSubview:self.btnSkillPoints];
    }
    
    if (self.btnChange == nil)
    {
        self.btnChange = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"Change Hero", nil)
                                                      target:self
                                                    selector:@selector(btnChange_tap)
                                                       frame:CGRectMake(button_x, button_y-button_height-menu_spacing, button_width, button_height)
                                                        type:@"2"];
        [self.view addSubview:self.btnChange];
    }
    
    [self updateHero];
    [self updateHeroSkillPoints];
    [self updateHeroItems];
}

- (void)updateHero
{
    self.pvHeroXp.bar1 = [Globals.i getXpProgressBar];
    self.pvHeroXp.barText = [NSString stringWithFormat:@"%@/%@", [Globals.i intString:[Globals.i getXpBar]], [Globals.i intString:[Globals.i getXpBarFull]]];
    [self.pvHeroXp updateView];
    
    self.lblName.text = Globals.i.wsWorldProfileDict[@"hero_name"];
    self.lblLevel.text = [NSString stringWithFormat:@"%@", [Globals.i intString:[Globals.i getLevel]]];
}

- (void)updateHeroItems
{
    CGFloat btn_box_size = 70.0f*SCALE_IPAD;
    CGFloat item_size = 50.0f*SCALE_IPAD;
    CGFloat spacing = 10.0f*SCALE_IPAD;
    UIImage *imgLight = [Globals.i imageNamedCustom:@"fx_shine"];
    
    
    UIImage *img1 = [Globals.i imageNamedCustom:@"item_box_helmet"];
    UIImage *imgItem1 = [Globals.i imageNamedCustom:@"item_box_helmet"];
    if (![Globals.i.wsWorldProfileDict[@"hero_helmet"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_helmet"] isEqualToString:@""])
    {
        imgItem1 = [Globals.i imageNamedCustom:[Globals.i getItemImageName:Globals.i.wsWorldProfileDict[@"hero_helmet"]]];
        UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
        [img1 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
        [imgItem1 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
        img1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
    [img1 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    if (![Globals.i.wsWorldProfileDict[@"hero_helmet"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_helmet"] isEqualToString:@""])
    {
        [imgItem1 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
    }
    [imgLight drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    UIImage *imgLight1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	[self.button1 setBackgroundImage:img1 forState:UIControlStateNormal];
	[self.button1 setBackgroundImage:imgLight1 forState:UIControlStateHighlighted];
    
    
    UIImage *img2 = [Globals.i imageNamedCustom:@"item_box_armor"];
    UIImage *imgItem2 = [Globals.i imageNamedCustom:@"item_box_armor"];
    if (![Globals.i.wsWorldProfileDict[@"hero_armor"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_armor"] isEqualToString:@""])
    {
        imgItem2 = [Globals.i imageNamedCustom:[Globals.i getItemImageName:Globals.i.wsWorldProfileDict[@"hero_armor"]]];
        UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
        [img2 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
        [imgItem2 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
        img2 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
    [img2 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    if (![Globals.i.wsWorldProfileDict[@"hero_armor"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_armor"] isEqualToString:@""])
    {
        [imgItem2 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
    }
    [imgLight drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    UIImage *imgLight2 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	[self.button2 setBackgroundImage:img2 forState:UIControlStateNormal];
	[self.button2 setBackgroundImage:imgLight2 forState:UIControlStateHighlighted];
    
    
    UIImage *img3 = [Globals.i imageNamedCustom:@"item_box_foot"];
    UIImage *imgItem3 = [Globals.i imageNamedCustom:@"item_box_foot"];
    if (![Globals.i.wsWorldProfileDict[@"hero_boots"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_boots"] isEqualToString:@""])
    {
        imgItem3 = [Globals.i imageNamedCustom:[Globals.i getItemImageName:Globals.i.wsWorldProfileDict[@"hero_boots"]]];
        UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
        [img3 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
        [imgItem3 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
        img3 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
    [img3 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    if (![Globals.i.wsWorldProfileDict[@"hero_boots"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_boots"] isEqualToString:@""])
    {
        [imgItem3 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
    }
    [imgLight drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    UIImage *imgLight3 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	[self.button3 setBackgroundImage:img3 forState:UIControlStateNormal];
	[self.button3 setBackgroundImage:imgLight3 forState:UIControlStateHighlighted];
    
    
    UIImage *img4 = [Globals.i imageNamedCustom:@"item_box_weapon"];
    UIImage *imgItem4 = [Globals.i imageNamedCustom:@"item_box_weapon"];
    if (![Globals.i.wsWorldProfileDict[@"hero_weapon"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_weapon"] isEqualToString:@""])
    {
        imgItem4 = [Globals.i imageNamedCustom:[Globals.i getItemImageName:Globals.i.wsWorldProfileDict[@"hero_weapon"]]];
        UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
        [img4 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
        [imgItem4 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
        img4 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
    [img4 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    if (![Globals.i.wsWorldProfileDict[@"hero_weapon"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_weapon"] isEqualToString:@""])
    {
        [imgItem4 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
    }
    [imgLight drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    UIImage *imgLight4 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	[self.button4 setBackgroundImage:img4 forState:UIControlStateNormal];
	[self.button4 setBackgroundImage:imgLight4 forState:UIControlStateHighlighted];
    
    
    UIImage *img5 = [Globals.i imageNamedCustom:@"item_box_accessory"];
    UIImage *imgItem5 = [Globals.i imageNamedCustom:@"item_box_accessory"];
    if (![Globals.i.wsWorldProfileDict[@"hero_accessory"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_accessory"] isEqualToString:@""])
    {
        imgItem5 = [Globals.i imageNamedCustom:[Globals.i getItemImageName:Globals.i.wsWorldProfileDict[@"hero_accessory"]]];
        UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
        [img5 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
        [imgItem5 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
        img5 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
    [img5 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    if (![Globals.i.wsWorldProfileDict[@"hero_accessory"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_accessory"] isEqualToString:@""])
    {
        [imgItem5 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
    }
    [imgLight drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    UIImage *imgLight5 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	[self.button5 setBackgroundImage:img5 forState:UIControlStateNormal];
	[self.button5 setBackgroundImage:imgLight5 forState:UIControlStateHighlighted];
    
    
    UIImage *img6 = [Globals.i imageNamedCustom:@"item_box_shield"];
    UIImage *imgItem6 = [Globals.i imageNamedCustom:@"item_box_shield"];
    if (![Globals.i.wsWorldProfileDict[@"hero_gloves"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_gloves"] isEqualToString:@""])
    {
        imgItem6 = [Globals.i imageNamedCustom:[Globals.i getItemImageName:Globals.i.wsWorldProfileDict[@"hero_gloves"]]];
        UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
        [img6 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
        [imgItem6 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
        img6 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    UIGraphicsBeginImageContext(CGSizeMake(btn_box_size, btn_box_size));
    [img6 drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    if (![Globals.i.wsWorldProfileDict[@"hero_gloves"] isEqualToString:@"0"] && ![Globals.i.wsWorldProfileDict[@"hero_gloves"] isEqualToString:@""])
    {
        [imgItem6 drawInRect:CGRectMake(spacing, spacing, item_size, item_size)];
    }
    [imgLight drawInRect:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
    UIImage *imgLight6 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	[self.button6 setBackgroundImage:img6 forState:UIControlStateNormal];
	[self.button6 setBackgroundImage:imgLight6 forState:UIControlStateHighlighted];
}

- (void)updateHeroSkillPoints
{
    NSInteger sp_balance = Globals.i.spBalance;
    NSString *btn_title = [NSString stringWithFormat:NSLocalizedString(@"Skill Points: %@", nil), [Globals.i intString:sp_balance]];
    
    [self.btnSkillPoints setTitle:btn_title forState:UIControlStateNormal];
    
    if (sp_balance > 0)
    {
        [self.btnSkillPoints startGlowingWithColor:[UIColor yellowColor] intensity:0.3];
    }
    else
    {
        [self.btnSkillPoints stopGlowing];
    }
}

- (void)change_herotype
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"herotype" forKey:@"item_category2"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)btnHeroImage_tap
{
    [self change_herotype];
}

- (void)btnAddXp_tap
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"heroxp" forKey:@"item_category2"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)btnBoost_tap
{
    if (self.heroChart == nil)
    {
        self.heroChart = [[HeroChart alloc] initWithStyle:UITableViewStylePlain];
    }
    self.heroChart.title = NSLocalizedString(@"Hero Boost", nil);
    [self.heroChart updateView];
    
    [UIManager.i showTemplate:@[self.heroChart] :self.heroChart.title :3];
}

- (void)btnSkillPoints_tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHeroSkills"
                                                        object:self
                                                      userInfo:nil];
}

- (void)btnChange_tap
{
    [self change_herotype];
}

- (void)btnRename_tap
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@"renamehero" forKey:@"item_category2"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)showItemDialog:(NSString *)item_id c2:(NSString *)category2
{
    NSDictionary *row1 = [Globals.i getItemDict:item_id];
    
    if (row1 != nil)
    {
        NSDictionary *row10 = @{@"r1": row1[@"item_name"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
        NSDictionary *row11 = @{@"r1": @" ", @"nofooter": @"1"};
        NSDictionary *row12 = @{@"i1": row1[@"item_image"], @"i1_over": @"item_frame", @"r1": row1[@"item_details"], @"r2": @" ", @"n1_width": @"60", @"nofooter": @"1"};
        NSDictionary *row13 = @{@"r1": @" ", @"nofooter": @"1"};
        NSArray *rows1 = @[row10, row11, row12, row13];
        NSMutableArray *rows = [@[rows1] mutableCopy];
        
        NSDictionary *row21 = @{@"nofooter": @"1", @"r1": NSLocalizedString(@"Change", nil), @"r1_button": @"2", @"c1": NSLocalizedString(@"Unequip", nil), @"c1_button": @"2",};
        NSArray *rows2 = @[row21];
        [rows addObject:rows2];
        
        [UIManager.i showDialogBlockRow:rows title:@"ItemAction" type:6
         
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //Show Items
             {
                 [Globals.i showItems:category2];
             }
             if(index == 2) //Unequip
             {
                 NSString *hf = [NSString stringWithFormat:@"hero_%@", category2];
                 [Globals.i heroEquip:@"0" hero_field:hf];
             }
         }];
    }
    else //item id not found so show item selecter
    {
        [Globals.i showItems:category2];
    }
}

- (void)button1_tap
{
    if([Globals.i.wsWorldProfileDict[@"hero_helmet"] isEqualToString:@"0"])
    {
        [Globals.i showItems:@"helmet"];
    }
    else
    {
        [self showItemDialog:Globals.i.wsWorldProfileDict[@"hero_helmet"] c2:@"helmet"];
    }
}

- (void)button2_tap
{
    if([Globals.i.wsWorldProfileDict[@"hero_armor"] isEqualToString:@"0"])
    {
        [Globals.i showItems:@"armor"];
    }
    else
    {
        [self showItemDialog:Globals.i.wsWorldProfileDict[@"hero_armor"] c2:@"armor"];
    }
}

- (void)button3_tap
{
    if([Globals.i.wsWorldProfileDict[@"hero_boots"] isEqualToString:@"0"])
    {
        [Globals.i showItems:@"boots"];
    }
    else
    {
        [self showItemDialog:Globals.i.wsWorldProfileDict[@"hero_boots"] c2:@"boots"];
    }
}

- (void)button4_tap
{
    if([Globals.i.wsWorldProfileDict[@"hero_weapon"] isEqualToString:@"0"])
    {
        [Globals.i showItems:@"weapon"];
    }
    else
    {
        [self showItemDialog:Globals.i.wsWorldProfileDict[@"hero_weapon"] c2:@"weapon"];
    }
}

- (void)button5_tap
{
    if([Globals.i.wsWorldProfileDict[@"hero_accessory"] isEqualToString:@"0"])
    {
        [Globals.i showItems:@"accessory"];
    }
    else
    {
        [self showItemDialog:Globals.i.wsWorldProfileDict[@"hero_accessory"] c2:@"accessory"];
    }
}

- (void)button6_tap
{
    if([Globals.i.wsWorldProfileDict[@"hero_gloves"] isEqualToString:@"0"])
    {
        [Globals.i showItems:@"gloves"];
    }
    else
    {
        [self showItemDialog:Globals.i.wsWorldProfileDict[@"hero_gloves"] c2:@"gloves"];
    }
}

@end
