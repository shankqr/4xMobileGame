//
//  AllianceCreate.m
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

#import "AllianceCreate.h"
#import "Globals.h"

@interface AllianceCreate ()

@property (nonatomic, strong) UITableViewCell *inputCell1;
@property (nonatomic, strong) UITableViewCell *inputCell2;
@property (nonatomic, strong) UITableViewCell *inputCell3;

@end

@implementation AllianceCreate

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSDictionary *rowHeader1 = @{@"h1": NSLocalizedString(@"Alliance Name", nil)};
    NSDictionary *row10 = @{@"t1": NSLocalizedString(@"Alliance Name", nil)};
    NSArray *rows1 = @[rowHeader1, row10];
    
    NSDictionary *rowHeader2 = @{@"h1": NSLocalizedString(@"TAG (Must be 3 Characters)", nil)};
    NSDictionary *row20 = @{@"t1": NSLocalizedString(@"Alliance (TAG)", nil)};
    NSArray *rows2 = @[rowHeader2, row20];
    
    NSDictionary *rowHeader3 = @{@"h1": NSLocalizedString(@"Introduction Text", nil)};
    NSDictionary *row30 = @{@"t1": NSLocalizedString(@"Intro Text", nil), @"t1_height": @"84"};
    NSArray *rows3 = @[rowHeader3, row30];
    
    NSDictionary *rowHeader4 = @{@"h1": NSLocalizedString(@"Options", nil)};
    NSDictionary *rowDone = @{@"r1": NSLocalizedString(@"Create Alliance", nil), @"r1_align": @"1"};

    NSDictionary *rowCancel = @{@"r1": NSLocalizedString(@"Cancel", nil), @"r1_align": @"1", @"r1_color": @"1"};
    NSArray *rows4 = @[rowHeader4, rowDone, rowCancel];
    
    self.ui_cells_array = [@[rows1, rows2, rows3, rows4] mutableCopy];
    
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.ui_cells_array.count-1)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        
        self.inputCell1 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UITextField *tvName = (UITextField *)[self.inputCell1 viewWithTag:6];
        
        self.inputCell2 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        UITextView *tvTag = (UITextView *)[self.inputCell2 viewWithTag:6];
        
        self.inputCell3 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
        UITextView *tvMarquee = (UITextView *)[self.inputCell3 viewWithTag:7];
        
        if (indexPath.row == 1) //Save or Create
        {
            if (tvName.text.length < 4)
            {
                [UIManager.i showDialog:NSLocalizedString(@"Invalid Name! Name must be at least 4 characters long.", nil) title:@"InvalidName"];
            }
            else if (tvTag.text.length != 3)
            {
                [UIManager.i showDialog:NSLocalizedString(@"Invalid TAG! TAG must be 3 characters long.", nil) title:@"InvalidTag"];
            }
            else
            {
                [tvName resignFirstResponder];
                [tvTag resignFirstResponder];
                [tvMarquee resignFirstResponder];
                [self postAllianceCreate:tvName.text :tvTag.text :tvMarquee.text];
            }
        }
        else if(indexPath.row == 2) //Cancel
        {
            [UIManager.i closeTemplate];
            
            tvName.text = @"";
            tvTag.text = @"";
            tvMarquee.text = @"";
        }
    }
    
	return nil;
}

- (void)postAllianceCreate:(NSString *)tvName :(NSString *)tvTag :(NSString *)tvMarquee
{
    NSString *reqCurrency2 = Globals.i.wsSettingsDict[@"alliance_require_currency2"];
    
    [UIManager.i showDialogBlock:[NSString stringWithFormat:NSLocalizedString(@"Form a new Alliance for %@ Diamonds only.", nil), [Globals.i numberFormat:reqCurrency2]]
                                title:@"FormAllianceConfirmation"
                                type:2
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //YES
         {
             NSString *reqCurrency2 = Globals.i.wsSettingsDict[@"alliance_require_currency2"];
             
             NSInteger balDiamonds = [Globals.i.wsWorldProfileDict[@"currency_second"] integerValue];
             
             if (balDiamonds >= reqCurrency2.integerValue)
             {
                 NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                       Globals.i.UID,
                                       @"profile_uid",
                                       tvName,
                                       @"name",
                                       tvTag,
                                       @"tag",
                                       tvMarquee,
                                       @"marquee",
                                       nil];
                 
                 NSString *service_name = @"PostAllianceCreate";
                 [Globals.i postServerLoading:dict :service_name :^(BOOL success, NSData *data)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{ //Update the UI on the main thread
                          
                          if (success)
                          {
                              NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                              if([returnValue isEqualToString:@"1"]) //Stored Proc Success
                              {
                                  //Balance Diamonds will be updated, alliance_id and alliance_rank set
                                  [Globals.i getServerWorldProfileData:^(BOOL success, NSData *data)
                                   {
                                       dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
                                           if (success)
                                           {
                                               [UIManager.i closeAllTemplate];
                                               
                                               [UIManager.i showDialog:NSLocalizedString(@"Congratulations on creating an Alliance. Don't forget to invite as many kingdoms as posible. Good luck and have fun!", nil) title:@"AllianceCreated"];
                                               
                                               [UIManager.i showToast:NSLocalizedString(@"Alliance Created Successfully!", nil)
                                                        optionalTitle:@"AllianceCreatedSuccessfully"
                                                        optionalImage:@"icon_check"];
                                               
                                               [[NSNotificationCenter defaultCenter]
                                                postNotificationName:@"ShowAlliance"
                                                object:self];
                                           }
                                       });
                                   }];
                              }
                              else if ([returnValue isEqualToString:@"-1"]) //Stored Proc Failed
                              {
                                  [Globals.i showDialogFail];
                                  [Globals.i trackEvent:@"SP Failed" action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
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
                                      [Globals.i trackEvent:returnValue action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
                                  }
                                  else
                                  {
                                      [Globals.i showDialogError];
                                      [Globals.i trackEvent:@"WS Return 0" action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
                                  }
                              }

                          }
                      });
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

@end
