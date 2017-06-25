//
//  AllianceDetail.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 1/13/13.
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

#import "AllianceDetail.h"
#import "Globals.h"
#import "PostText.h"

@interface AllianceDetail ()

@property (nonatomic, strong) NSString *alliance_id;
@property (nonatomic, strong) PostText *postText;

@property (nonatomic, assign) BOOL isLeader;

@end

@implementation AllianceDetail

- (void)scrollToTop
{
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)updateView
{
    //Force to fetch new alliance members from db
    Globals.i.selected_alliance_id = @"0";
    
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Applicants", nil), @"i1": @"icon_alliance_applicant", @"i2": @"arrow_right"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Donate Diamonds", nil), @"i1": @"icon_alliance_donate", @"i2": @"arrow_right"};
    NSDictionary *row103 = @{@"r1": NSLocalizedString(@"Resource Help", nil), @"i1": @"icon_alliance_resource", @"i2": @"arrow_right"};
    NSDictionary *row104 = @{@"r1": NSLocalizedString(@"Reinforce", nil), @"i1": @"icon_alliance_reinforce", @"i2": @"arrow_right"};
    NSDictionary *row105 = @{@"r1": NSLocalizedString(@"Events", nil), @"i1": @"icon_alliance_events", @"i2": @"arrow_right"};
    NSDictionary *row106 = @{@"r1": NSLocalizedString(@"Mail Everyone", nil), @"i1": @"icon_alliance_mail", @"i2": @"arrow_right"};
    NSDictionary *row107 = @{@"r1": NSLocalizedString(@"View Public Profile", nil), @"i1": @"icon_alliance_profile", @"i2": @"arrow_right"};
    NSDictionary *row108 = @{@"r1": NSLocalizedString(@"Leave Alliance", nil), @"i1": @"icon_alliance_leave", @"i2": @"arrow_right"};
    NSArray *rows1 = @[row101, row102, row103, row104, row105, row106, row107, row108];
    
    if ([self.aAlliance.leader_id isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]]) //You are the leader
    {
        self.isLeader = YES;
    }
    else
    {
        self.isLeader = NO;
    }

    if (self.isLeader)
    {
        NSDictionary *row201 = @{@"h1": NSLocalizedString(@"Leader Options", nil)};
        NSDictionary *row202 = @{@"r1": NSLocalizedString(@"Set Alliance Name", nil), @"i1": @"icon_alliance_edit", @"i2": @"arrow_right"};
        NSDictionary *row203 = @{@"r1": NSLocalizedString(@"Set Intro Text", nil), @"i1": @"icon_alliance_edit", @"i2": @"arrow_right"};
        NSDictionary *row204 = @{@"r1": NSLocalizedString(@"Set Tag", nil), @"i1": @"icon_alliance_edit", @"i2": @"arrow_right"};
        NSDictionary *row205 = @{@"r1": NSLocalizedString(@"Set Logo", nil), @"i1": @"icon_alliance_edit", @"i2": @"arrow_right"};
        NSDictionary *row206 = @{@"r1": NSLocalizedString(@"Set Description", nil), @"i1": @"icon_alliance_edit", @"i2": @"arrow_right"};
        NSDictionary *row207 = @{@"r1": NSLocalizedString(@"Upgrade Alliance", nil), @"i1": @"icon_alliance_upgrade", @"i2": @"arrow_right"};
        NSDictionary *row208 = @{@"r1": NSLocalizedString(@"Kick Members", nil), @"i1": @"icon_alliance_kick", @"i2": @"arrow_right"};
        NSDictionary *row209 = @{@"r1": NSLocalizedString(@"Transfer Leader", nil), @"i1": @"icon_alliance_transfer", @"i2": @"arrow_right"};
        NSArray *rows2 = @[row201, row202, row203, row204, row205, row206, row207, row208, row209];
        
        self.ui_cells_array = [@[rows1, rows2] mutableCopy];
    }
    else
    {
        self.ui_cells_array = [@[rows1] mutableCopy];
    }
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)leaveButton_tap
{
    if (self.isLeader && ([self.aAlliance.total_members integerValue] > 2))
    {
        [UIManager.i showDialog:NSLocalizedString(@"You will have to Transfer Leader to another member before you can leave.", nil) title:@"NoLeaderRestriction"];
    }
    else
    {
        [UIManager.i showDialogBlock:NSLocalizedString(@"Are you sure you want to leave this Alliance?", nil)
                             title:@"LeaveAllianceConfirmation"
                                    type:2
                                    :^(NSInteger index, NSString *text)
         {
             if (index == 1) //YES
             {
                 [self leaveAlliance];
             }
         }];
    }
}

- (void)leaveAlliance
{
    NSString *a_id = self.aAlliance.alliance_id;
    NSString *profile_uid = Globals.i.UID;
    
    NSString *service_name = @"AllianceLeave";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       a_id, profile_uid];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [UIManager.i showDialogBlock:NSLocalizedString(@"You are out! Now you are free to choose other Alliances!", nil)
                                  title:@"LeftAllianceNotice"
                                         type:1
                                         :^(NSInteger index, NSString *text)
              {
                  if (index == 1) //OK
                  {
                      Globals.i.wsWorldProfileDict[@"alliance_id"] = @"0";
                      Globals.i.wsWorldProfileDict[@"alliance_rank"] = @"0";
                      
                      [UIManager.i closeTemplate];
                      
                      [[NSNotificationCenter defaultCenter]
                       postNotificationName:@"ShowAlliance"
                       object:self];
                  }
              }];
         }
     }];
}

- (void)donateDiamonds
{
    [UIManager.i showDialogBlock:NSLocalizedString(@"How many Diamonds would you like to donate?", nil)
                         title:@"DiamondDonationAmount"
                                type:5
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //OK button is clicked
         {
             NSInteger number = [text integerValue];
             NSInteger bal = [Globals.i.wsWorldProfileDict[@"currency_second"] integerValue];
             
             if ((number > 0) && (bal >= number))
             {
                 NSString *a_id = self.aAlliance.alliance_id;
                 NSString *profile_uid = Globals.i.UID;
                 
                 NSString *service_name = @"AllianceDonate";
                 NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                                    a_id, profile_uid, @(number)];
                 
                 [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
                  {
                      if (success)
                      {
                          //Diamonds - Donation
                          NSInteger new_cs = bal - number;
                          Globals.i.wsWorldProfileDict[@"currency_second"] = [@(new_cs) stringValue];
                          
                          NSInteger new_alliance_cs = [self.aAlliance.alliance_currency_second integerValue] + number;
                          self.aAlliance.alliance_currency_second = [@(new_alliance_cs) stringValue];
                          
                          [[NSNotificationCenter defaultCenter]
                           postNotificationName:@"UpdateWorldProfileData"
                           object:self];
                          
                          [UIManager.i showDialog:NSLocalizedString(@"Thanks. The Alliance members remembers your contribution.", nil) title:@"DiamondsDonatedtoAlliance"];
                      }
                  }];
             }
             else
             {
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"ShowBuy"
                  object:self];
             }
         }
     }];
}

- (void)upgradeButton_tap
{
    NSInteger nextLevel = self.aAlliance.alliance_level.integerValue + 1;
    
    [UIManager.i showDialogBlock:[NSString stringWithFormat:NSLocalizedString(@"Upgrade Alliance to Level %@ for %@ Diamonds? Diamonds will be deducted from Alliance account.", nil), [Globals.i intString:nextLevel], [Globals.i intString:nextLevel*100]]
                         title:@"UpgradeAllianceConfirmation:"
                                type:2
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //YES
         {
             [self upgradeAlliance];
         }
     }];
}

- (void)upgradeAlliance
{
    NSInteger reqDiamonds = (self.aAlliance.alliance_level.integerValue + 1)*100;
    
    if (self.aAlliance.alliance_currency_second.integerValue >= reqDiamonds)
    {
        NSString *service_name = @"AllianceUpgrade";
        NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                           self.aAlliance.alliance_id, Globals.i.UID];
        
        [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 NSInteger nextLevel = self.aAlliance.alliance_level.integerValue + 1;
                 self.aAlliance.alliance_level = [@(nextLevel) stringValue];
                 
                 NSInteger upgrade_cost = nextLevel*100;
                 NSInteger new_alliance_cs = [self.aAlliance.alliance_currency_second integerValue] - upgrade_cost;
                 self.aAlliance.alliance_currency_second = [@(new_alliance_cs) stringValue];
                 
                 NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                 [userInfo setObject:self.aAlliance.alliance_level forKey:@"new_value"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAllianceLevel"
                                                                     object:self
                                                                   userInfo:userInfo];
                 
                 [UIManager.i showDialog:NSLocalizedString(@"Upgrade Success! Your Alliance has Leveled UP. Now more members can join to increase the fun and ranking.", nil) title:@"AllianceLevelUp"];
             }
         }];
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"Insufficient Diamonds to upgrade. Please donate more Diamonds.", nil) title:@"InsufficentDiamondsForAllianceUpgrade"];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0) //Applicants
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceApplicants"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (indexPath.row == 1) //Donate Diamonds
        {
            [self donateDiamonds];
        }
        else if (indexPath.row == 2) //Resource Help
        {
            [[NSNotificationCenter defaultCenter]
             postNotificationName:@"ShowMarket"
             object:self];
        }
        else if (indexPath.row == 3) //Reinforce
        {
            BOOL hasBuildEmbassy = NO;
            BOOL hasBuildRallyPoint = NO;
            for (NSDictionary *dict in Globals.i.wsBuildArray)
            {
                if ([dict[@"building_id"] isEqualToString:@"13"])
                {
                    hasBuildEmbassy = YES;
                }
                
                if ([dict[@"building_id"] isEqualToString:@"18"])
                {
                    hasBuildRallyPoint = YES;
                }
            }
            
            if (hasBuildEmbassy && hasBuildRallyPoint)
            {
                NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
                [userInfo setObject:@"Reinforce" forKey:@"button_title"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceMembers"
                                                                    object:self
                                                                  userInfo:userInfo];
            }
            else
            {
                [UIManager.i showDialog:NSLocalizedString(@"You will need to build an Embassy and a Rally Point first to Reinforce your alliance members.", nil) title:@"EmbassyAndRallyPointNeededToSendReinforcement"];
            }
        }
        else if (indexPath.row == 4) //Events
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceEvents"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (indexPath.row == 5) //Mail
        {
            NSString *isAlli = @"1";
            NSString *toID = self.aAlliance.alliance_id;
            NSString *toName = self.aAlliance.alliance_name;
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:isAlli forKey:@"is_alli"];
            [userInfo setObject:toID forKey:@"to_id"];
            [userInfo setObject:toName forKey:@"to_name"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MailCompose"
                                                                object:self
                                                              userInfo:userInfo];
            
        }
        else if (indexPath.row == 6) //Profile
        {
            [UIManager.i closeAllTemplate];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (indexPath.row == 7) //Leave
        {
            [self leaveButton_tap];
        }
    }
    else if (indexPath.section == 1) //Leader Options
    {
        if (indexPath.row == 1) //Rename Alliance
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"alliance_name" forKey:@"item_category2"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (indexPath.row == 2) //Set Marquee
        {
            self.postText = [[PostText alloc] initWithStyle:UITableViewStylePlain];
            self.postText.serviceName = @"PostAllianceMarquee";
            self.postText.title = NSLocalizedString(@"Intro Text", nil);
            [self.postText updateView];
            [UIManager.i showTemplate:@[self.postText] :self.postText.title];
        }
        else if (indexPath.row == 3) //Set Tag
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"alliance_tag" forKey:@"item_category2"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (indexPath.row == 4) //Set Logo
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:@"alliance_logo" forKey:@"item_category2"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (indexPath.row == 5) //Set Description
        {
            self.postText = [[PostText alloc] initWithStyle:UITableViewStylePlain];
            self.postText.serviceName = @"PostAllianceDescription";
            self.postText.title = NSLocalizedString(@"Description", nil);
            [self.postText updateView];
            [UIManager.i showTemplate:@[self.postText] :self.postText.title];
        }
        else if (indexPath.row == 6) //Upgrade Alliance
        {
            [self upgradeButton_tap];
        }
        else if (indexPath.row == 7) //Kick Members
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
            [userInfo setObject:@"Kick" forKey:@"button_title"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceMembers"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else if (indexPath.row == 8) //Transfer Leader
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:self.aAlliance forKey:@"alliance_object"];
            [userInfo setObject:@"Transfer" forKey:@"button_title"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceMembers"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    
	return nil;
}

@end
