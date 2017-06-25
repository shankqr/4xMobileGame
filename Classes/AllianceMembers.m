//
//  AllianceMembers.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 10/23/13.
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

#import "AllianceMembers.h"
#import "Globals.h"

@interface AllianceMembers ()

@end

@implementation AllianceMembers

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    if (![self.aAlliance.alliance_id isEqualToString:Globals.i.selected_alliance_id])
    {
        [Globals.i GetAllianceMembers:self.aAlliance.alliance_id :^(BOOL success, NSData *data)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (success)
                 {
                     [self addMemberRows];
                 }
             });
         }];
    }
    else
    {
        [self addMemberRows];
    }
}

- (void)addMemberRows
{
    //Tips
    NSDictionary *row301 = @{@"r1": NSLocalizedString(@"Tap on the profile picture to view the member profile.", nil), @"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1"};
    NSArray *rows3 = @[row301];
    self.ui_cells_array = [@[rows3] mutableCopy];
    
    //Leader
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Leader", nil), @"r1_icon": @"rank_1", @"r1_align": @"1", @"r1_color": @"2", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    NSMutableArray *rows1 = [@[row101] mutableCopy];
    
    //Members
    NSDictionary *row201 = @{@"r1": NSLocalizedString(
@"Members", nil), @"r1_icon": @"rank_2", @"r1_align": @"1", @"r1_color": @"2", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    NSMutableArray *rows2 = [@[row201] mutableCopy];
    
    for (NSDictionary *row1 in Globals.i.alliance_members)
    {
        NSString *r1 = row1[@"profile_name"];
        NSString *i1 = [NSString stringWithFormat:@"face_%@", row1[@"profile_face"]];
        NSString *c1 = [Globals.i autoNumber:row1[@"xp"]];
        NSString *c1_icon = @"icon_power";
        NSString *c1_align = @"1";
        NSString *c1_ratio = @"4";
        
        NSString *e1 = self.button_title;
        NSString *e1_button = @"2";
        
        //TODO: Translation posible problems
        if (([row1[@"profile_id"] isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]]) || ([self.button_title isEqualToString:@"Members"])) //You or vanilla members
        {
            e1 = @"";
            e1_button = @"";
        }
        else if ([self.button_title isEqualToString:@"Transfer"])
        {
            e1 = NSLocalizedString(@"Make", nil);
        }
        else if ([self.button_title isEqualToString:@"Reinforce"])
        {
            e1 = NSLocalizedString(@"Help", nil);
        }
        
        if ([row1[@"profile_id"] isEqualToString:self.aAlliance.leader_id]) //Leader row
        {
            NSDictionary *row102 = @{@"p_id": row1[@"profile_id"], @"i1": i1, @"i1_h": @" ", @"i1_aspect": @"1", @"r1": r1, @"c1": c1, @"c1_align": c1_align, @"c1_icon": c1_icon, @"e1": e1, @"e1_button": e1_button, @"c1_ratio": c1_ratio};
            [rows1 addObject:row102];
        }
        else //Member rows
        {
            NSDictionary *row202 = @{@"p_id": row1[@"profile_id"], @"i1": i1, @"i1_h": @" ", @"i1_aspect": @"1", @"r1": r1, @"c1": c1, @"c1_align": c1_align, @"c1_icon": c1_icon, @"e1": e1, @"e1_button": e1_button, @"c1_ratio": c1_ratio};
            [rows2 addObject:row202];
        }
    }
    
    [self.ui_cells_array addObject:rows1];
    [self.ui_cells_array addObject:rows2];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)removeProfileRedraw:(NSString *)profile_id
{
    if ([Globals.i.alliance_members count] > 0)
    {
        for (NSInteger i = 0; i < [Globals.i.alliance_members count]; i++)
        {
            if ([Globals.i.alliance_members[i][@"profile_id"] isEqualToString:profile_id])
            {
                [Globals.i.alliance_members removeObjectAtIndex:i];
                i = i - 1;
            }
        }
        
        [self updateView];
    }
}

- (void)kickProfile:(NSString *)profile_id
{
    NSString *service_name = @"AllianceKick";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       self.aAlliance.alliance_id, Globals.i.UID, profile_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 [self removeProfileRedraw:profile_id];
                 
                 NSInteger totalmembers = [self.aAlliance.total_members integerValue] - 1;
                 self.aAlliance.total_members = [@(totalmembers) stringValue];
                 
                 [UIManager.i showToast:NSLocalizedString(@"Player Kicked!", nil)
                          optionalTitle:@"PlayerKicked"
                          optionalImage:@"icon_check"];
             }
         });
     }];
}

- (void)transferProfile:(NSString *)profile_id
{
    NSString *service_name = @"AllianceTransfer";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       self.aAlliance.alliance_id, Globals.i.UID, profile_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 //Force to fetch new alliance members from db
                 Globals.i.selected_alliance_id = @"0";
                 
                 Globals.i.wsWorldProfileDict[@"alliance_rank"] = @"2";
                 
                 self.aAlliance.leader_id = profile_id;
                 
                 [UIManager.i closeAllTemplate];
                 
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"ShowAlliance"
                  object:self];
                 
                 [UIManager.i showToast:NSLocalizedString(@"Player made as new Leader!", nil)
                          optionalTitle:@"NewLeader"
                          optionalImage:@"icon_check"];
             }
         });
     }];
}

- (void)img1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSString *selected_profile_id = self.ui_cells_array[section][row][@"p_id"];
    if (selected_profile_id != nil)
    {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:selected_profile_id forKey:@"profile_id"];
        [userInfo setObject:@"0" forKey:@"button_alliance"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"e1_button"] integerValue];
    
    if ((button > 1) && (i > 101)) //Depends on button_title
    {
        NSString *selected_profile_id = self.ui_cells_array[section][row][@"p_id"];
        if ((selected_profile_id != nil) && (![selected_profile_id isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]]))
        {
            if ([self.button_title isEqualToString:@"Kick"])
            {
                [UIManager.i showDialogBlock:NSLocalizedString(@"Are you sure you want to Kick this player out of this Alliance?", nil)
                                     title:@"KickAllianceConfirmation"
                                            type:2
                                            :^(NSInteger index, NSString *text)
                 {
                     if (index == 1) //YES
                     {
                         [self kickProfile:selected_profile_id];
                     }
                 }];
            }
            else if ([self.button_title isEqualToString:@"Transfer"])
            {
                [UIManager.i showDialogBlock:NSLocalizedString(@"Are you sure you want to make this player the Leader of this Alliance and you become a normal member?", nil)
                                     title:@"AppointDelegateLeaderConfirmation"
                                            type:2
                                            :^(NSInteger index, NSString *text)
                 {
                     if (index == 1) //YES
                     {
                         [self transferProfile:selected_profile_id];
                     }
                 }];
            }
            else if ([self.button_title isEqualToString:@"Reinforce"])
            {
                [Globals.i doReinforce:selected_profile_id];
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.img1 addTarget:self action:@selector(img1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.img1.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_e.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_e.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
