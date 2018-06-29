//
//  MainCell.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 8/18/12.
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

#import "MainCell.h"
#import "Globals.h"

#define buttons_per_row (iPad ? 4 : 4)
#define menu_start_y (iPad ? 40.0f : 20.0f)
#define menu_margin_y (iPad ? 20.0f : 10.0f)

@interface MainCell ()

@property (nonatomic, strong) NSMutableDictionary *buttons_dictionary;

@end

@implementation MainCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) 
    {
        // Initialization code
        [self setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, MOREVIEW_HEIGHT)];
        self.buttons_dictionary = [[NSMutableDictionary alloc] init];
        [self createButtons];
    }
    
    [self notificationRegister];
    
    return self;
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickResearchButton"
                                               object:nil];
    
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"ClickResearchButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            NSLog(@"ClickResearchButton");
            
            if (self.buttons_dictionary != nil)
            {
                NSInteger tag = 6;
                UIButton *thisButton = [self.buttons_dictionary objectForKey:@(tag)];
                NSLog(@"thisButton : %@",thisButton);
                
                [self posButton_tap:thisButton];
            }
            
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)createButtons
{
    [self addPosButton:NSLocalizedString(@"Profile", nil) tag:1 imageDefault:@"btn_profile"];
	[self addPosButton:NSLocalizedString(@"Hero", nil) tag:2 imageDefault:@"btn_hero"];
    [self addPosButton:NSLocalizedString(@"Research", nil) tag:3 imageDefault:@"btn_research"];
	[self addPosButton:NSLocalizedString(@"Marches", nil) tag:4 imageDefault:@"btn_march"];
    [self addPosButton:NSLocalizedString(@"Search", nil) tag:5 imageDefault:@"btn_search"];
    [self addPosButton:NSLocalizedString(@"Rankings", nil) tag:6 imageDefault:@"btn_rankings"];
    [self addPosButton:NSLocalizedString(@"Options", nil) tag:7 imageDefault:@"btn_options"];
    //[self addPosButton:NSLocalizedString(@"Help", nil) tag:8 imageDefault:@"btn_howto"];
    //[self addPosButton:NSLocalizedString(@"Feedback", nil) tag:9 imageDefault:@"btn_feedback"];
    //[self addPosButton:NSLocalizedString(@"Invite", nil) tag:10 imageDefault:@"btn_add_friend"];
    
    /*
    NSString *str_enable_slot = Globals.i.wsSettingsDict[@"enable_slot"];
    if ([str_enable_slot isEqualToString:@"1"])
    {
        [self addPosButton:NSLocalizedString(@"Slots", nil) tag:11 imageDefault:@"btn_slots"];
    }
    
    NSString *str_enable_football = Globals.i.wsSettingsDict[@"enable_football"];
    if ([str_enable_football isEqualToString:@"1"])
    {
        [self addPosButton:NSLocalizedString(@"Stadium", nil) tag:12 imageDefault:@"btn_events"];
    }
    
    NSString *str_enable_switch_server = Globals.i.wsProfileDict[@"enable_switch_server"];
    if ([str_enable_switch_server isEqualToString:@"1"])
    {
        [self addPosButton:NSLocalizedString(@"Servers", nil) tag:13 imageDefault:@"flag_117"];
    }
    
    NSString *str_enable_logout = Globals.i.wsProfileDict[@"enable_logout"];
    if ([str_enable_logout isEqualToString:@"1"])
    {
        [self addPosButton:NSLocalizedString(@"Logout", nil) tag:14 imageDefault:@"btn_logout"];
    }
    */
}

- (UIImage *)resizeImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (CGRect)getBadgeFrame:(NSInteger)tag
                  width:(NSInteger)width
                 height:(NSInteger)height
{
    UIImage *imgD = [Globals.i imageNamedCustom:@"button_mails"];
    
    NSInteger sizex = (imgD.size.width*SCALE_IPAD/2);
    NSInteger sizey = (imgD.size.height*SCALE_IPAD/2);
    
    NSInteger column_width = self.frame.size.width / buttons_per_row;
    NSInteger column_start_x = (column_width - sizex) / 2;
    NSInteger column_height = sizey + menu_label_height + menu_margin_y;
    
    NSInteger button_col = ((tag-1) % buttons_per_row);
    NSInteger posx = button_col * column_width + column_start_x;
    
    NSInteger button_row = ((tag-1) / buttons_per_row);
    NSInteger posy = button_row * column_height + menu_start_y;
    
    return CGRectMake(posx-DEFAULT_CONTENT_SPACING, posy-DEFAULT_CONTENT_SPACING, width, height);
}

- (void)addPosButton:(NSString *)label
				 tag:(NSInteger)tag
        imageDefault:(NSString *)imageDefault
{
    UIImage *img = [Globals.i imageNamedCustom:imageDefault];
    UIImage *imgH = [self resizeImage:img scaledToSize:CGSizeMake(80*SCALE_IPAD, 80*SCALE_IPAD)];
    UIImage *imgD = [self resizeImage:img scaledToSize:CGSizeMake(60*SCALE_IPAD, 60*SCALE_IPAD)];
    
    NSInteger sizex = (120*SCALE_IPAD/2);
    NSInteger sizey = (120*SCALE_IPAD/2);
    
    NSInteger column_width = self.frame.size.width / buttons_per_row;
    NSInteger column_start_x = (column_width - sizex) / 2;
    NSInteger column_height = sizey + menu_label_height + menu_margin_y;
    
    NSInteger button_col = ((tag-1) % buttons_per_row);
    NSInteger posx = button_col * column_width + column_start_x;
    
    NSInteger button_row = ((tag-1) / buttons_per_row);
    NSInteger posy = button_row * column_height + menu_start_y;
    
    UIImage *imgBtnBkg = [Globals.i imageNamedCustom:@"btn_bkg"];
    UIImageView *btnbkgImage = [[UIImageView alloc] initWithImage:imgBtnBkg];
    NSInteger BtnBkg_sizex = (50*SCALE_IPAD);
    NSInteger BtnBkg_sizey = (50*SCALE_IPAD);
    NSInteger BtnBkg_posx = posx + (sizex - BtnBkg_sizex)/2;
    NSInteger BtnBkg_posy = posy + (sizey - BtnBkg_sizey)/2;
    btnbkgImage.frame = CGRectMake(BtnBkg_posx, BtnBkg_posy, BtnBkg_sizex, BtnBkg_sizey);
    [self addSubview:btnbkgImage];
    
	UIButton *button = [UIManager.i buttonWithTitle:@""
                                             target:self
                                           selector:@selector(posButton_tap:)
                                              frame:CGRectMake(posx, posy, sizex, sizey)
                                        imageNormal:imgD
                                   imageHighlighted:imgH
                                      imageCentered:YES
                                      darkTextColor:YES];
    
	button.tag = tag;
	[self addSubview:button];
	
    [self.buttons_dictionary setObject:button  forKey:@(tag)];
    
	UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(posx-column_start_x, posy+sizey, column_width, menu_label_height)];
	myLabel.tag = tag;
	myLabel.text = label;
    myLabel.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
	myLabel.backgroundColor = [UIColor clearColor];
	myLabel.textColor = [UIColor blackColor];
	myLabel.textAlignment = NSTextAlignmentCenter;
	myLabel.numberOfLines = 1;
	myLabel.adjustsFontSizeToFitWidth = YES;
	myLabel.minimumScaleFactor = 0.5f;
	[self addSubview:myLabel];
}

- (void)posButton_tap:(id)sender
{
    [Globals.i play_button];
    
	NSInteger theTag = [sender tag];
	
    if (theTag == 1)
    {
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:Globals.i.wsWorldProfileDict[@"profile_id"] forKey:@"profile_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
    else if (theTag == 2)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowHero"
         object:self];
    }
    else if (theTag == 3)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowResearch"
         object:self];
    }
    else if (theTag == 4)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowMarches"
         object:self];
    }
    else if (theTag == 5)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowSearch"
         object:self];
    }
    else if (theTag == 6)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowRanking"
         object:self];
    }
    else if (theTag == 7)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowOptions"
         object:self];
    }
    else if (theTag == 8)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowHelp"
         object:self];
    }
    else if (theTag == 9)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowFeedback"
         object:self];
    }
    else if (theTag == 10)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowInvite"
         object:self];
    }
    else if (theTag == 11)
    {
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"ShowSlots" object:self];
    }
    else if (theTag == 12)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowSports"
         object:self];
    }
    else if (theTag == 13)
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"ShowSevers"
         object:self];
    }
    else if (theTag == 14)
    {
        [Globals.i changeUserLogout];
    }
}

@end
