//
//  PictureList.m
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

#import "PictureList.h"
#import "Globals.h"

@interface PictureList ()

@end

@implementation PictureList

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    if ([self.type isEqualToString:@"profile"])
    {
        for (int i=1; i<472; i++)
        {
            NSString *img_face = [NSString stringWithFormat:@"face_%@", [@(i) stringValue]];
            NSDictionary *row101 = @{@"i1": img_face, @"i1_aspect": @"1", @"r1": @" ", @"r2": @" ", @"c1": NSLocalizedString(@"USE", nil), @"c2": NSLocalizedString(@"THIS", nil), @"c1_button": @"2", @"c1_ratio": @"2.5", @"n1_width": @"75"};
            [rows1 addObject:row101];
        }
    }
    else if ([self.type isEqualToString:@"hero"])
    {
        NSDictionary *row101 = @{@"i1": @"hero_face1", @"i1_aspect": @"1", @"r1": @" ", @"r2": @" ", @"c1": NSLocalizedString(@"USE", nil), @"c2": NSLocalizedString(@"THIS", nil), @"c1_button": @"2", @"c1_ratio": @"2.5", @"n1_width": @"75"};
        NSDictionary *row102 = @{@"i1": @"hero_face2", @"i1_aspect": @"1", @"r1": @" ", @"r2": @" ", @"c1": NSLocalizedString(@"USE", nil), @"c2": NSLocalizedString(@"THIS", nil), @"c1_button": @"2", @"c1_ratio": @"2.5", @"n1_width": @"75"};

        rows1 = [@[row101, row102] mutableCopy];
    }
    else if ([self.type isEqualToString:@"alliance"])
    {
        for (int i=1; i<366; i++)
        {
            NSString *img_logo = [NSString stringWithFormat:@"a_logo_%@", [@(i) stringValue]];
            NSDictionary *row101 = @{@"i1": img_logo, @"i1_aspect": @"1", @"r1": @" ", @"r2": @" ", @"c1": NSLocalizedString(@"USE", nil), @"c2": NSLocalizedString(@"THIS", nil), @"c1_button": @"2", @"c1_ratio": @"2.5", @"n1_width": @"75"};
            [rows1 addObject:row101];
        }
    }
    
    if ([rows1 count] > 0)
    {
        self.ui_cells_array = [@[rows1] mutableCopy];
        [self.tableView reloadData];
        [self.tableView flashScrollIndicators];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.row+1);
    
    return dcell;
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if ([self.type isEqualToString:@"profile"])
    {
        [self selectProfilePicture:[@(i) stringValue]];
    }
    else if ([self.type isEqualToString:@"hero"])
    {
        [self selectHero:[@(i) stringValue]];
    }
    else if ([self.type isEqualToString:@"alliance"])
    {
        [self selectLogo:[@(i) stringValue]];
    }
}

- (void)selectProfilePicture:(NSString *)type
{
    NSString *service_name = @"ProfileFace";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], type];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             Globals.i.wsWorldProfileDict[@"profile_face"] = type;
             
             [UIManager.i closeTemplate]; //closes the item view
             
             [UIManager.i showToast:NSLocalizedString(@"New Profile Picture Selected!", nil)
                      optionalTitle:@"ProfilePictureSelected"
                      optionalImage:@"icon_check"];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateProfileHeader"
              object:self];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateItems"
              object:self];
             
             [UIManager.i closeTemplate]; //closes the item view
         }
         else
         {
             [UIManager.i showDialog:NSLocalizedString(@"Oops! there was a network problem. Please try again.", nil) title:@""];
         }
     }];
}

- (void)selectHero:(NSString *)type
{
    NSString *service_name = @"HeroType";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], type];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             Globals.i.wsWorldProfileDict[@"hero_type"] = type;
             
             [UIManager.i closeTemplate];
             
             [UIManager.i showToast:NSLocalizedString(@"New Hero Selected!", nil)
                      optionalTitle:@"HeroSelected"
                      optionalImage:@"icon_check"];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateHeroType"
              object:self];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateItems"
              object:self];
             
             [UIManager.i closeTemplate]; //closes the item view
         }
     }];
}

- (void)selectLogo:(NSString *)type
{
    NSString *service_name = @"AllianceLogo";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], type];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             Globals.i.wsWorldProfileDict[@"alliance_logo"] = type;
             
             [UIManager.i closeTemplate];
             
             [UIManager.i showToast:NSLocalizedString(@"New Logo Selected!", nil)
                      optionalTitle:@"LogoSelected"
                      optionalImage:@"icon_check"];
             
             NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
             [userInfo setObject:type forKey:@"new_value"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateAllianceLogo"
                                                                 object:self
                                                               userInfo:userInfo];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateItems"
              object:self];
             
             [UIManager.i closeTemplate]; //closes the item view
         }
     }];
}

@end
