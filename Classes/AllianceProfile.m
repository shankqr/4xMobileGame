//
//  AllianceProfile
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

#import "AllianceProfile.h"
#import "Globals.h"

@interface AllianceProfile ()

@property (nonatomic, strong) UIImageView *backgroundImage;

@end

@implementation AllianceProfile

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
                                                 name:@"UpdateAllianceLogo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateAllianceName"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateAllianceTag"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateAllianceMarquee"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateAllianceDescription"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateAllianceLevel"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    NSString *new_value = [userInfo objectForKey:@"new_value"];
    
    if ([[notification name] isEqualToString:@"CloseTemplateBefore"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *view_title = [userInfo objectForKey:@"view_title"];
        
        if ([self.title isEqualToString:view_title])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    }
    else if ([[notification name] isEqualToString:@"UpdateAllianceLogo"])
    {
        self.aAlliance.alliance_logo = new_value;
        [self updateView];
    }
    else if ([[notification name] isEqualToString:@"UpdateAllianceName"])
    {
        self.aAlliance.alliance_name = new_value;
        [self updateView];
    }
    else if ([[notification name] isEqualToString:@"UpdateAllianceTag"])
    {
        self.aAlliance.alliance_tag = new_value;
        [self updateView];
    }
    else if ([[notification name] isEqualToString:@"UpdateAllianceMarquee"])
    {
        self.aAlliance.alliance_marquee = new_value;
        [self updateView];
    }
    else if ([[notification name] isEqualToString:@"UpdateAllianceDescription"])
    {
        self.aAlliance.alliance_description = new_value;
        [self updateView];
    }
    else if ([[notification name] isEqualToString:@"UpdateAllianceLevel"])
    {
        self.aAlliance.alliance_level = new_value;
        [self updateView];
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];

    NSString *r1 = self.aAlliance.alliance_name;
    if ([self.aAlliance.alliance_tag length] > 2)
    {
        r1 = [NSString stringWithFormat:@"%@[%@]", self.aAlliance.alliance_name, self.aAlliance.alliance_tag];
    }
    NSString *r2 = [NSString stringWithFormat:@"Leader: %@", self.aAlliance.leader_name];
    NSString *b1 = self.aAlliance.alliance_marquee;
    NSString *b1_bkg = @"bkg3";
    NSString *b1_marquee = @"1";
    NSString *i1 = [NSString stringWithFormat:@"a_logo_%@", self.aAlliance.alliance_logo];
    NSString *r1_icon = @"";
    if (([self.aAlliance.alliance_language integerValue] > 0) && ([self.aAlliance.alliance_language integerValue] < 263))
    {
        r1_icon = [NSString stringWithFormat:@"flag_%@", self.aAlliance.alliance_language];
    }
    NSString *e1 = [NSString stringWithFormat:@"%@/%@0", self.aAlliance.total_members, self.aAlliance.alliance_level];

    NSDictionary *row101 = @{@"alliance_id": self.aAlliance.alliance_id, @"i1": i1, @"i1_aspect": @"1", @"r1": r1, @"r1_bold": @"1", @"r1_icon": r1_icon, @"r2": r2, @"b1": b1, @"b1_marquee": b1_marquee, @"b1_color": @"2", @"b1_bkg": b1_bkg, @"nofooter": @"1"};
    NSDictionary *row102 = @{@"bkg_prefix": @"bkg1", @"r1_icon": @"icon_power", @"r1": [Globals.i autoNumber:self.aAlliance.power], @"r1_color": @"2", @"r1_align": @"1", @"c1_icon": @"icon_kills", @"c1": [Globals.i autoNumber:self.aAlliance.kills], @"c1_color": @"2", @"c1_align": @"1", @"c1_ratio": @"3", @"e1_icon": @"icon_members", @"e1": e1, @"e1_color": @"2", @"e1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row103 = @{@"r1": NSLocalizedString(@"Comment", nil), @"c1": NSLocalizedString(@"Members", nil), @"e1": NSLocalizedString(@"Stats", nil), @"r1_button": @"2", @"c1_button": @"2", @"e1_button": @"2", @"c1_ratio": @"3", @"nofooter": @"1"};
    
	NSArray *rows1 = @[row101, row102, row103];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
	
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    
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
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_e.btn addTarget:self action:@selector(button3_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_e.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"r1_button"] integerValue];
    
    if ((button > 1) && (i == 103)) //Comment
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceWall"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"c1_button"] integerValue];
    
    if ((button > 1) && (i == 103)) //Members
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
        [userInfo setObject:@"Members" forKey:@"button_title"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceMembers"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)button3_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"e1_button"] integerValue];
    
    if ((button > 1) && (i == 103)) //Stats
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceStats"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

@end
