//
//  AllianceApplicants.m
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

#import "AllianceApplicants.h"
#import "Globals.h"

@interface AllianceApplicants ()

@property (nonatomic, strong) NSMutableArray *array_applicant;

@end

@implementation AllianceApplicants

- (void)updateView
{
    NSString *service_name = @"GetAllianceApply";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       self.aAlliance.alliance_id];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 self.array_applicant = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                 [self drawTable:[returnArray mutableCopy]];
             }
             else
             {
                 NSMutableArray *rows1 = [[NSMutableArray alloc] init];
                 NSDictionary *row101 = @{@"profile_id": @"0", @"r1": NSLocalizedString(@"No Applicants at the Moment", nil), @"r1_align": @"1", @"nofooter": @"1"};
                 [rows1 addObject:row101];
                 
                 self.ui_cells_array = [@[rows1] mutableCopy];
                 [self.tableView reloadData];
             }
         }
        });
     }];
}

- (void)drawTable:(NSMutableArray *)ds
{
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    for (NSDictionary *row1 in ds)
    {
        NSString *r1_icon;
        if ([row1[@"alliance_rank"] integerValue] > 0)
        {
            r1_icon = [NSString stringWithFormat:@"rank_%@", row1[@"alliance_rank"]];
        }
        else
        {
            r1_icon = @"";
        }
        
        NSString *r1 = row1[@"profile_name"];
        if ([row1[@"alliance_tag"] length] > 2)
        {
            r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
        }
        
        NSString *r2 = [NSString stringWithFormat:@"%@  Kills:%@", [Globals.i autoNumber:row1[@"xp"]], [Globals.i autoNumber:row1[@"kills"]]];
        NSString *r2_icon = @"icon_power";
        NSDictionary *row101 = @{@"profile_id": row1[@"profile_id"], @"r1": r1, @"r1_bold": @"1", @"r1_icon": r1_icon, @"r2": r2, @"r2_icon": r2_icon, @"r2_align": @"1", @"i1": [NSString stringWithFormat:@"face_%@", row1[@"profile_face"]], @"i1_aspect": @"1", @"nofooter": @"1"};
        
        NSString *r1_button = @"2";
        NSString *c1_button = @"1";
        NSString *e1_button = @"1";
        
        if ([self.aAlliance.leader_id isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]]) //You are the leader
        {
            c1_button = @"2";
            e1_button = @"2";
        }
        
        NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Profile", nil), @"c1": NSLocalizedString(@"Approve", nil), @"e1": NSLocalizedString(@"Reject", nil), @"r1_button": r1_button, @"c1_button": c1_button, @"e1_button": e1_button, @"c1_ratio": @"3"};
        
        [rows1 addObject:row101];
        [rows1 addObject:row102];
    }
    self.ui_cells_array = [@[rows1] mutableCopy];
    [self.tableView reloadData];
    
    [self.tableView flashScrollIndicators];
}

- (void)removeProfileRedraw:(NSString *)profile_id
{
    if ([self.array_applicant count] > 0)
    {
        for (NSInteger i = 0; i < [self.array_applicant count]; i++)
        {
            if ([self.array_applicant[i][@"profile_id"] isEqualToString:profile_id])
            {
                [self.array_applicant removeObjectAtIndex:i];
                i = i - 1;
            }
        }
        
        [self drawTable:self.array_applicant];
    }
}

- (void)approveProfile:(NSString *)profile_id
{
    NSString *service_name = @"AllianceApprove";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       self.aAlliance.alliance_id, Globals.i.UID, profile_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         if (success)
         {
             [self removeProfileRedraw:profile_id];
             
             //Force to fetch new alliance members from db
             Globals.i.selected_alliance_id = @"0";
             
             NSInteger totalmembers = [self.aAlliance.total_members integerValue] + 1;
             self.aAlliance.total_members = [@(totalmembers) stringValue];
             
             [UIManager.i showToast:NSLocalizedString(@"Profile Approved!", nil)
                      optionalTitle:@"ProfileApproved"
                      optionalImage:@"icon_check"];
         }
        });
     }];
}

- (void)maxMemberWarning
{
    [UIManager.i showDialog:NSLocalizedString(@"Unable to Approve! Maximum members reached for this Level. Upgrade Alliance to increase member capacity.", nil) title:@"MaximumMembersReached"];
}

- (void)rejectProfile:(NSString *)profile_id
{
    NSString *service_name = @"AllianceReject";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       self.aAlliance.alliance_id, Globals.i.UID, profile_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         if (success)
         {
             [self removeProfileRedraw:profile_id];
             
             [UIManager.i showToast:NSLocalizedString(@"Profile Rejected!", nil)
                      optionalTitle:@"ProfileRejected"
                      optionalImage:@"icon_check"];
         }
         });
     }];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"r1_button"] integerValue];
    
    if ((button > 1) && (i > 101)) //Profile
    {
        NSString *selected_profile_id = self.ui_cells_array[section][row-1][@"profile_id"];
        if (selected_profile_id != nil)
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:selected_profile_id forKey:@"profile_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"c1_button"] integerValue];
    
    if ((button > 1) && (i > 101)) //Approve
    {
        NSString *selected_profile_id = self.ui_cells_array[section][row-1][@"profile_id"];
        if (selected_profile_id != nil)
        {
            NSInteger member_capacity = [self.aAlliance.alliance_level integerValue] * 10;
            if (member_capacity > [self.aAlliance.total_members integerValue])
            {
                [self approveProfile:selected_profile_id];
            }
            else
            {
                [self maxMemberWarning];
            }
        }
    }
}

- (void)button3_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"e1_button"] integerValue];
    
    if ((button > 1) && (i > 101)) //Reject
    {
        NSString *selected_profile_id = self.ui_cells_array[section][row-1][@"profile_id"];
        if (selected_profile_id != nil)
        {
            [self rejectProfile:selected_profile_id];
        }
    }
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

@end
