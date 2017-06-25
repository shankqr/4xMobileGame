//
//  ProfileHeader.m
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

#import "ProfileHeader.h"
#import "Globals.h"
#import "BoostChart.h"

@interface ProfileHeader ()

@property (nonatomic, strong) UIImageView *backgroundImage;
@property (nonatomic, strong) BoostChart *boostChart;

@end

@implementation ProfileHeader

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.backgroundImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.backgroundImage.contentMode = UIViewContentModeScaleToFill;
    self.tableView.backgroundView = self.backgroundImage;
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
                                                 name:@"UpdateProfileHeader"
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
    else if ([[notification name] isEqualToString:@"UpdateProfileHeader"])
    {
        [self updateView];
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSString *profile_info = self.profileDict[@"profile_name"];
    NSString *alliance_info = NSLocalizedString(@"Alliance: None", nil);
    
    NSInteger hero_xp = [self.profileDict[@"hero_xp"] integerValue];
    NSInteger hero_level = [Globals.i levelFromXp:hero_xp];
    
    NSString *hero_info = [NSString stringWithFormat:NSLocalizedString(@"Hero: Level %@", nil), [@(hero_level) stringValue]];
    NSString *alliance_btn = @"1";
    NSString *mail_btn = NSLocalizedString(@"Mail", nil);
    
    if (![self.profileDict[@"alliance_id"] isEqualToString:@"0"]) //In Alliance
    {
        if ([self.profileDict[@"alliance_tag"] length] > 2)
        {
            profile_info = [NSString stringWithFormat:@"[%@]%@", self.profileDict[@"alliance_tag"], self.profileDict[@"profile_name"]];
        }
        else
        {
            profile_info = self.profileDict[@"profile_name"];
        }
        alliance_info = [NSString stringWithFormat:NSLocalizedString(@"Alliance: %@ (Rank %@)", nil), self.profileDict[@"alliance_name"], self.profileDict[@"alliance_rank"]];
        alliance_btn = @"2";
    }
    
    if ([self.profileDict[@"profile_id"] isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]]) //My Profile
    {
        mail_btn = NSLocalizedString(@"Rename", nil);
    }
    
	NSDictionary *row1 = @{@"i1": [NSString stringWithFormat:@"face_%@", self.profileDict[@"profile_face"]], @"i1_h": @" ", @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", self.profileDict[@"alliance_rank"]], @"r1": profile_info, @"r2": alliance_info, @"b1": hero_info, @"n1_width": @"60", @"nofooter": @"1", @"r1_color": @"0", @"r2_color": @"0", @"b1_color": @"0"};
	NSDictionary *row2 = @{@"r1": NSLocalizedString(@"Power", nil), @"c1": NSLocalizedString(@"Kills", nil), @"r1_align": @"1", @"c1_align": @"1", @"c1_ratio": @"2", @"nofooter": @"1", @"fit": @"1", @"r1_color": @"0", @"c1_color": @"0"};
    NSDictionary *row3 = @{@"r1_icon": @"icon_power", @"r1": [Globals.i autoNumber:self.profileDict[@"xp"]], @"c1_icon": @"icon_kills", @"c1": [Globals.i autoNumber:self.profileDict[@"kills"]], @"r1_bkg": @"bkg3", @"c1_bkg": @"bkg3", @"r1_color": @"2", @"c1_color": @"2", @"r1_align": @"1", @"c1_align": @"1", @"c1_ratio": @"2", @"nofooter": @"1", @"fit": @"1"};
    NSDictionary *row4 = @{@"r1": NSLocalizedString(@"Alliance", nil), @"c1": NSLocalizedString(@"Boosts", nil), @"e1": mail_btn, @"r1_button": alliance_btn, @"c1_button": @"2", @"e1_button": @"2", @"c1_ratio": @"3", @"nofooter": @"1"};
    
	NSArray *rows1 = @[row1, row2, row3, row4];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
	
	[self.tableView reloadData];
    
    CGRect table_rect = [self.tableView rectForSection:[self.tableView numberOfSections] - 1];
    CGFloat table_height = CGRectGetMaxY(table_rect);
    CGRect bkg_frame = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, table_height);
    UIImage *bkg_image = [UIManager.i dynamicImage:bkg_frame prefix:@"bkg5"];
    [self.backgroundImage setImage:bkg_image];
    [self.backgroundImage setFrame:bkg_frame];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.img1 addTarget:self action:@selector(img1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.img1.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_e.btn addTarget:self action:@selector(button3_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_e.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (void)img1_tap:(id)sender
{
    [Globals.i play_button];
    
    if ([self.profileDict[@"profile_id"] isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]]) //My Profile
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"profileface" forKey:@"item_category2"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                            object:self
                                                          userInfo:userInfo];
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"Were you trying to change this poor guy's profile picture? Seriously?", nil) title:@"ChangePictureFailed"];
    }
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"r1_button"] integerValue];
    
    if ((button > 1) && (i == 104))
    {
        if ([self.button_alliance isEqualToString:@"1"])
        {
            NSString *aid = self.profileDict[@"alliance_id"];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:aid forKey:@"alliance_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else
        {
            [UIManager.i closeTemplate];
        }
    }
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"c1_button"] integerValue];
    
    if ((button > 1) && (i == 104))
    {
        //Show boost
        if (self.boostChart == nil)
        {
            self.boostChart = [[BoostChart alloc] initWithStyle:UITableViewStylePlain];
        }
        self.boostChart.title = @"Boost";
        [self.boostChart updateView];
        
        [UIManager.i showTemplate:@[self.boostChart] :NSLocalizedString(@"Boost", nil) :3];
    }
}

- (void)button3_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"e1_button"] integerValue];
    
    if ((button > 1) && (i == 104))
    {
        if (![self.profileDict[@"profile_id"] isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]]) //Not My Profile - Mail
        {
            NSString *isAlli = @"0";
            NSString *toID = self.profileDict[@"profile_id"];
            NSString *toName = self.profileDict[@"profile_name"];
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:isAlli forKey:@"is_alli"];
            [userInfo setObject:toID forKey:@"to_id"];
            [userInfo setObject:toName forKey:@"to_name"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MailCompose"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else //Rename Profile Name
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"renameprofile" forKey:@"item_category2"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
}

@end
