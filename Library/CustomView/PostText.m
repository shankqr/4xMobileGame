//
//  PostText.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 3/24/09.
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

#import "PostText.h"
#import "Globals.h"

@implementation PostText


- (void)updateView
{
    NSString *h1 = NSLocalizedString(@"New Name", nil);
    
    if ([self.serviceName isEqualToString:@"PostAllianceTag"])
    {
        h1 = NSLocalizedString(@"New Tag", nil);
    }
    else if ([self.serviceName isEqualToString:@"PostAllianceMarquee"])
    {
        h1 = NSLocalizedString(@"New Marquee", nil);
    }
    else if ([self.serviceName isEqualToString:@"PostAllianceDescription"])
    {
        h1 = NSLocalizedString(@"New Description", nil);
    }
    
    NSDictionary *rowHeader2 = @{@"h1": h1};
    NSDictionary *row20 = @{@"t1": NSLocalizedString(@"Enter text here...", nil), @"t1_height": @"60"};
    NSArray *rows2 = @[rowHeader2, row20];
    
    NSDictionary *rowDone = @{@"r1": NSLocalizedString(@"OK", nil), @"r1_align": @"1"};
    NSDictionary *rowCancel = @{@"r1": NSLocalizedString(@"Cancel", nil), @"r1_align": @"1", @"r1_color": @"1"};
    NSArray *rows3 = @[rowDone, rowCancel];
    
    self.ui_cells_array = [@[rows2, rows3] mutableCopy];
    
	[self.tableView reloadData];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == [self.ui_cells_array count]-1)
    {
        self.inputCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextView *inputTV = (UITextView *)[self.inputCell viewWithTag:7];
        
        if(indexPath.row == 0) //Send
        {
            if([inputTV.text length] > 0)
            {
                [inputTV resignFirstResponder];
                
                [self postText:inputTV];
            }
        }
        else if(indexPath.row == 1) //Cancel
        {
            [UIManager.i closeTemplate];
            
            inputTV.text = @"";
        }
    }
    
	return nil;
}

- (void)postText:(UITextView *)textview
{
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          Globals.i.wsWorldProfileDict[@"uid"],
                          @"profile_uid",
                          Globals.i.wsBaseDict[@"base_id"],
                          @"base_id",
                          Globals.i.wsWorldProfileDict[@"alliance_id"],
                          @"alliance_id",
                          textview.text,
                          @"text",
                          nil];
    
    [Globals.i postServerLoading:dict :self.serviceName :^(BOOL success, NSData *data)
    {
        dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread

            if (success)
            {
                NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if ([returnValue isEqualToString:@"1"]) //Stored Proc Success
                {
                    if ([self.serviceName isEqualToString:@"PostRenameBase"])
                    {
                        [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                        {
                            [UIManager.i showToast:NSLocalizedString(@"City Renamed Successfully!", nil)
                                     optionalTitle:@"CityRenamed"
                                     optionalImage:@"icon_check"];
                            
                            [UIManager.i closeTemplate]; //closes the item view
                            
                            [[NSNotificationCenter defaultCenter]
                             postNotificationName:@"UpdateBaseName"
                             object:self];
                        }];
                    }
                    else if ([self.serviceName isEqualToString:@"PostRenameProfile"])
                    {
                        Globals.i.wsWorldProfileDict[@"profile_name"] = textview.text;
                        
                        //NSString *uid = [Globals.i UID];
                        //[[Mixpanel sharedInstance] identify:uid];
                        //[[Mixpanel sharedInstance].people set:@{@"Profile Name": textview.text}];
                        
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"UpdateProfileHeader"
                         object:self];
                        
                        [UIManager.i showToast:NSLocalizedString(@"Profile Renamed Successfully!", nil)
                                 optionalTitle:@"ProfileRenamed"
                                 optionalImage:@"icon_check"];
                        
                        [UIManager.i closeTemplate]; //closes the item view
                    }
                    else if ([self.serviceName isEqualToString:@"PostRenameHero"])
                    {
                        Globals.i.wsWorldProfileDict[@"hero_name"] = textview.text;
                        
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"UpdateHeroName"
                         object:self];
                        
                        [UIManager.i showToast:NSLocalizedString(@"Hero Renamed Successfully!", nil)
                                 optionalTitle:@"HeroRenamed"
                                 optionalImage:@"icon_check"];
                        
                        [UIManager.i closeTemplate]; //closes the item view
                    }
                    else if ([self.serviceName isEqualToString:@"PostAllianceName"])
                    {
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        [userInfo setObject:textview.text forKey:@"new_value"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAllianceName"
                                                                            object:self
                                                                          userInfo:userInfo];
                        
                        [UIManager.i showToast:NSLocalizedString(@"Alliance Renamed Successfully!", nil)
                                 optionalTitle:nil
                                 optionalImage:@"icon_check"];
                        
                        [UIManager.i closeTemplate]; //closes the item view
                    }
                    else if ([self.serviceName isEqualToString:@"PostAllianceTag"])
                    {
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        [userInfo setObject:textview.text forKey:@"new_value"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAllianceTag"
                                                                            object:self
                                                                          userInfo:userInfo];
                        
                        [UIManager.i showToast:NSLocalizedString(@"Alliance Tag Changed Successfully!", nil)
                                 optionalTitle:@"AllianceTagChanged"
                                 optionalImage:@"icon_check"];
                        
                        [UIManager.i closeTemplate]; //closes the item view
                    }
                    else if ([self.serviceName isEqualToString:@"PostAllianceMarquee"])
                    {
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        [userInfo setObject:textview.text forKey:@"new_value"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAllianceMarquee"
                                                                            object:self
                                                                          userInfo:userInfo];
                        
                        [UIManager.i showToast:NSLocalizedString(@"Alliance Intro Changed Successfully!", nil)
                                 optionalTitle:@"AllianceIntroChanged"
                                 optionalImage:@"icon_check"];
                    }
                    else if ([self.serviceName isEqualToString:@"PostAllianceDescription"])
                    {
                        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                        [userInfo setObject:textview.text forKey:@"new_value"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAllianceDescription"
                                                                            object:self
                                                                          userInfo:userInfo];
                        
                        [UIManager.i showToast:NSLocalizedString(@"Alliance Description Changed Successfully!", nil)
                                 optionalTitle:@"AllianceDescriptionChanged"
                                 optionalImage:@"icon_check"];
                    }
                    
                    textview.text = @"";
                    
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"UpdateItems"
                     object:self];
                    
                    [UIManager.i closeTemplate];
                    
                    if ([self.serviceName isEqualToString:@"PostRenameHero"])
                    {
                        [UIManager.i closeAllTemplate];
                        
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"ShowHero"
                         object:self];
                    }
                }
                else if ([returnValue isEqualToString:@"-1"]) //Stored Proc Failed
                {
                    [Globals.i showDialogFail];
                    [Globals.i trackEvent:@"SP Failed" action:self.serviceName label:Globals.i.wsWorldProfileDict[@"uid"]];
                }
                else //Web Service Return 0
                {
                    if (returnValue != nil)
                    {
                        if (DEBUG)
                        {
                            [UIManager.i showIIS_error:returnValue];
                        }
                        else
                        {
                            [Globals.i showDialogFail];
                        }
                        [Globals.i trackEvent:returnValue action:self.serviceName label:Globals.i.wsWorldProfileDict[@"uid"]];
                    }
                    else
                    {
                        [Globals.i showDialogError];
                        [Globals.i trackEvent:@"WS Return 0" action:self.serviceName label:Globals.i.wsWorldProfileDict[@"uid"]];
                    }
                }
                
            }
            else
            {
                [Globals.i showDialogError];
            }
        });
    }];
}

@end
