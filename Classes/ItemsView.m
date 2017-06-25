//
//  ItemsView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 10/20/13.
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

#import "ItemsView.h"
#import "Globals.h"
#import "PostText.h"
#import "PictureList.h"

@interface ItemsView ()

@property (nonatomic, strong) NSMutableArray *finalFilterArray;
@property (nonatomic, strong) TabView *categoryTabView;
@property (nonatomic, strong) PostText *postText;
@property (nonatomic, strong) PictureList *profilePictureList;
@property (nonatomic, strong) PictureList *heroList;
@property (nonatomic, strong) PictureList *logoList;
@property (nonatomic, strong) NSString *my_items;
@property (nonatomic, strong) NSString *i_category1;
@property (nonatomic, strong) NSString *i_category2;
@property (nonatomic, strong) NSString *item_image_choosed;

@end

@implementation ItemsView

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.my_items = @"0";
    self.i_category1 = @"special";
    self.i_category2 = @"0";
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
                                                 name:@"TabSelected"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateItems"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UseItem"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TimerViewEnd"
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
    else if ([[notification name] isEqualToString:@"TabSelected"])
    {
        NSDictionary *tab_userInfo = notification.userInfo;
        NSString *tab_title = [tab_userInfo objectForKey:@"tab_title"];
        
        if ([tab_title isEqualToString:NSLocalizedString(@"My Items", nil)])
        {
            self.my_items = @"1";
        }
        else if ([tab_title isEqualToString:NSLocalizedString(@"Store", nil)])
        {
            self.my_items = @"0";
        }
        else
        {
            NSString *filter = [[tab_title lowercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
            self.i_category1 = filter;
            
            self.i_category2 = @"0";
        }
        
        [self updateView];
        
    }
    else if ([[notification name] isEqualToString:@"UpdateItems"])
    {
        [self fetchItemArray];
    }
    else if ([[notification name] isEqualToString:@"UseItem"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            
            NSNumber *row_index = [userInfo objectForKey:@"item_row"];
            
            //NSLog(@"row_index : %d",[row_index integerValue]);
            
                  
            NSIndexPath* indexPath= [NSIndexPath indexPathForRow:[row_index integerValue] inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            
            self.my_items = @"1";
            
            //NSLog(@"Cell ItemsView : %@",[self.tableView cellForRowAtIndexPath:indexPath]);
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            
            //NSLog(@"DynamicCell : %@ ",customCellView);
            //NSLog(@"Button customCellView : %@ ",customCellView.cellview.rv_c.btn);
            
            //[self button2_tap:customCellView.cellview.rv_c.btn];
            [customCellView.cellview.rv_c.btn sendActionsForControlEvents:UIControlEventTouchUpInside];
        }

    }
    else if ([[notification name] isEqualToString:@"TimerViewEnd"])
    {
        if ([self.i_category2 isEqualToString:@"speedups"])
        {
            [UIManager.i closeTemplate];
        }
    }
}

- (void)clearView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
}

- (void)createCategoryTabs
{
    if (self.categoryTabView == nil)
    {
        self.categoryTabView = [[TabView alloc] init];
        self.categoryTabView.tabArray = @[NSLocalizedString(@"Special", nil), NSLocalizedString(@"Resources", nil), NSLocalizedString(@"Speed Ups", nil), NSLocalizedString(@"Hero", nil), NSLocalizedString(@"Boosts", nil)];
        self.categoryTabView.tabStyle = NO;
        [self.categoryTabView updateView];
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    [self clearView];
    
    if ([UIManager.i.tabViewTitle isEqualToString:NSLocalizedString(@"My Items", nil)])
    {
        self.my_items = @"1";
    }
    else if ([UIManager.i.tabViewTitle isEqualToString:NSLocalizedString(@"Store", nil)])
    {
        self.my_items = @"0";
    }
    
    if (self.itemInfo != nil)
    {
        self.i_category2 = [self.itemInfo objectForKey:@"item_category2"];
        self.my_items = @"0";
    }
    else
    {
        self.i_category2 = @"0";
    }

    if (Globals.i.wsItemArray == nil)
    {
        [self fetchItemArray];
    }
    else
    {
        [self filterItemArray];
    }
}

- (void)fetchItemArray
{
    NSString *service_name = @"GetItems";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsWorldProfileDict[@"profile_id"]];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 Globals.i.wsItemArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
             
                 [self filterItemArray];
             }
             else
             {
                 NSLog(@"WARNING: GetItems return empty array!");
                 Globals.i.wsItemArray = [[NSMutableArray alloc] init];
             }
         }
     }];
}

- (void)filterItemArray
{
    NSMutableArray *firstFilterArray = nil;
    NSMutableArray *secondFilterArray = nil;
    
    if ([self.my_items isEqualToString:@"1"])
    {
        NSMutableArray *myItemsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in Globals.i.wsItemArray)
        {
            if (![obj[@"quantity"] isEqualToString:@"0"] && ![obj[@"quantity"] isEqualToString:@""])
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
                [myItemsArray addObject:dic];
            }
        }
        
        firstFilterArray = myItemsArray;
    }
    else
    {
        NSMutableArray *saleItemsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in Globals.i.wsItemArray)
        {
            if ([obj[@"item_forsale"] isEqualToString:@"1"] && ([obj[@"item_cost"] integerValue] > 0))
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
                [saleItemsArray addObject:dic];
            }
        }
        
        firstFilterArray = saleItemsArray;
    }
    
    if (![self.i_category1 isEqualToString:@"0"] && ![self.i_category1 isEqualToString:@""])
    {
        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in firstFilterArray)
        {
            if ([obj[@"item_category1"] isEqualToString:self.i_category1])
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
                [itemsArray addObject:dic];
            }
        }
        
        secondFilterArray = itemsArray;
    }
    else
    {
        secondFilterArray = firstFilterArray;
    }
    
    //Filter from outside user UI, through code
    if (![self.i_category2 isEqualToString:@"0"] && ![self.i_category2 isEqualToString:@""])
    {
        NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *obj in Globals.i.wsItemArray)
        {
            if ([obj[@"item_category2"] isEqualToString:self.i_category2])
            {
                if ((![obj[@"item_forsale"] isEqualToString:@"0"] &&
                    ![obj[@"item_forsale"] isEqualToString:@""] &&
                    [obj[@"item_cost"] integerValue] > 0) ||
                    (![obj[@"quantity"] isEqualToString:@"0"] &&
                    ![obj[@"quantity"] isEqualToString:@""]))
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
                    [itemsArray addObject:dic];
                }
                //DONT ADD because it's not for sale and you have none OR the item price is 0. if you have the item but it's not for sale it should add

            }
        }
        
        secondFilterArray = itemsArray;
    }
    
    self.finalFilterArray = secondFilterArray;
    
    if (self.finalFilterArray.count > 0)
    {
        self.ui_cells_array = [@[self.finalFilterArray] mutableCopy];
    }
    else
    {
        NSDictionary *row0 = @{@"r1": NSLocalizedString(@"You do not have any items available for this category at the moment.", nil), @"r1_align": @"1", @"r1_color": @"1"};
        NSArray *rows1 = @[row0];
        self.ui_cells_array = [@[rows1] mutableCopy];
    }
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)button1_tap:(id)sender //USE button on Store
{
    NSInteger i = [sender tag];
    NSDictionary *item_row = (self.finalFilterArray)[i];
    [self useItem:item_row];
}

- (void)button2_tap:(id)sender //USE button on My Items or GET button on Store
{
    NSInteger i = [sender tag];
    NSDictionary *item_row = (self.finalFilterArray)[i];
    
    NSLog(@"ITEM tag: %ld",(long)i );
    NSLog(@"ITEM my_items: %@",self.my_items );
    
    if ([self.my_items isEqualToString:@"1"]) //USE ITEM
    {
        [self useItem:item_row];
    }
    else //BUY ITEM
    {
        [self buyItem:item_row];
    }
}

- (void)buyItem:(NSDictionary *)item_row
{
    NSString *item_id = item_row[@"item_id"];
    NSString *item_image = item_row[@"item_image"];
    NSString *item_name = item_row[@"item_name"];
    NSInteger item_cost = [item_row[@"item_cost"] integerValue];
    NSInteger currency_second = [Globals.i.wsWorldProfileDict[@"currency_second"] integerValue];

    if (currency_second >= item_cost)
    {
        NSString *service_name = @"BuyItem";
        NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                           Globals.i.wsWorldProfileDict[@"uid"], item_id];
        
        [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 NSInteger new_cs = currency_second - item_cost;
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(new_cs) stringValue];
                 
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"UpdateWorldProfileData"
                  object:self];
                 
                 [self fetchItemArray];
                 
                 [UIManager.i showToast:NSLocalizedString(@"Item is purchased Successfully!", nil)
                          optionalTitle:@"ItemPurchased"
                          optionalImage:item_image];
                 
                 [Globals.i trackEvent:@"Spend Diamond" action:item_id];
                 [Globals.i trackSpend:@(item_cost) itemName:item_name itemId:item_id];
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

- (void)useItem:(NSDictionary *)item_row
{
    NSString *item_category1 = item_row[@"item_category1"];
    NSString *item_category2 = item_row[@"item_category2"];
    NSString *item_id = item_row[@"item_id"];
    self.item_image_choosed = item_row[@"item_image"];
    
    if ([item_category2 isEqualToString:@"helmet"] ||
        [item_category2 isEqualToString:@"armor"] ||
        [item_category2 isEqualToString:@"boots"] ||
        [item_category2 isEqualToString:@"weapon"] ||
        [item_category2 isEqualToString:@"accessory"] ||
        [item_category2 isEqualToString:@"gloves"])
    {
        NSString *hf = [NSString stringWithFormat:@"hero_%@", item_category2];
        
        if(![Globals.i.wsWorldProfileDict[hf] isEqualToString:item_id])
        {
            [Globals.i heroEquip:item_id hero_field:hf];
        }
        else
        {
            [UIManager.i showToast:NSLocalizedString(@"Item is equiped Successfully!", nil)
                     optionalTitle:@"ItemEquiped"
                     optionalImage:self.item_image_choosed];
        }
    }
    else if ([item_category1 isEqualToString:@"resources"])
    {
        NSString *item_value = item_row[@"item_value"];
        
        [self useItemResources:item_id :item_value :Globals.i.wsBaseDict[@"base_id"] :item_category2];
    }
    else if ([item_category1 isEqualToString:@"boosts"])
    {
        NSLog(@"boosts : %@",item_category2);
        
        NSString *item_id = item_row[@"item_id"];
        NSString *item_value = item_row[@"item_value"];
        NSString *base_id = Globals.i.wsBaseDict[@"base_id"];
        NSString *type = @"";
        
        if ([item_category2 isEqualToString:@"food"])
        {
            type = [@(TV_BOOST_R1) stringValue];
        }
        else if ([item_category2 isEqualToString:@"wood"])
        {
            type = [@(TV_BOOST_R2) stringValue];
        }
        else if ([item_category2 isEqualToString:@"stone"])
        {
            type = [@(TV_BOOST_R3) stringValue];
        }
        else if ([item_category2 isEqualToString:@"ore"])
        {
            type = [@(TV_BOOST_R4) stringValue];
        }
        else if ([item_category2 isEqualToString:@"gold"])
        {
            type = [@(TV_BOOST_R5) stringValue];
        }
        else if ([item_category2 isEqualToString:@"attack"])
        {
            type = [@(TV_BOOST_ATT) stringValue];
        }
        else if ([item_category2 isEqualToString:@"defense"])
        {
            type = [@(TV_BOOST_DEF) stringValue];
        }
        
        if (base_id != nil)
        {
            [self applyBoost:base_id :item_id :item_value :type];
        }

    }
    else if ([item_category2 isEqualToString:@"alliance_name"])
    {
        self.postText = [[PostText alloc] initWithStyle:UITableViewStylePlain];
        self.postText.serviceName = @"PostAllianceName";
        self.postText.title = NSLocalizedString(@"Rename Alliance", nil);
        [self.postText updateView];
        [UIManager.i showTemplate:@[self.postText] :self.postText.title];
    }
    else if ([item_category2 isEqualToString:@"alliance_tag"])
    {
        self.postText = [[PostText alloc] initWithStyle:UITableViewStylePlain];
        self.postText.serviceName = @"PostAllianceTag";
        self.postText.title = NSLocalizedString(@"Set Tag", nil);
        [self.postText updateView];
        [UIManager.i showTemplate:@[self.postText] :self.postText.title];
    }
    else if ([item_category2 isEqualToString:@"renameprofile"])
    {
        self.postText = [[PostText alloc] initWithStyle:UITableViewStylePlain];
        self.postText.serviceName = @"PostRenameProfile";
        self.postText.title = NSLocalizedString(@"Rename Profile", nil);
        [self.postText updateView];
        [UIManager.i showTemplate:@[self.postText] :self.postText.title];
    }
    else if ([item_category2 isEqualToString:@"renamebase"])
    {
        self.postText = [[PostText alloc] initWithStyle:UITableViewStylePlain];
        self.postText.serviceName = @"PostRenameBase";
        self.postText.title = NSLocalizedString(@"Rename City", nil);
        [self.postText updateView];
        [UIManager.i showTemplate:@[self.postText] :self.postText.title];
    }
    else if ([item_category2 isEqualToString:@"renamehero"])
    {
        self.postText = [[PostText alloc] initWithStyle:UITableViewStylePlain];
        self.postText.serviceName = @"PostRenameHero";
        self.postText.title = NSLocalizedString(@"Rename Hero", nil);
        [self.postText updateView];
        [UIManager.i showTemplate:@[self.postText] :self.postText.title];
    }
    else if ([item_category2 isEqualToString:@"alliance_logo"])
    {
        self.logoList = [[PictureList alloc] initWithStyle:UITableViewStylePlain];
        self.logoList.type = @"alliance";
        self.logoList.title = NSLocalizedString(@"Set Logo", nil);
        [self.logoList updateView];
        [UIManager.i showTemplate:@[self.logoList] :self.logoList.title];
    }
    else if ([item_category2 isEqualToString:@"profileface"])
    {
        self.profilePictureList = [[PictureList alloc] initWithStyle:UITableViewStylePlain];
        self.profilePictureList.type = @"profile";
        self.profilePictureList.title = NSLocalizedString(@"Profile Picture", nil);
        [self.profilePictureList updateView];
        [UIManager.i showTemplate:@[self.profilePictureList] :self.profilePictureList.title];
    }
    else if ([item_category2 isEqualToString:@"herotype"])
    {
        self.heroList = [[PictureList alloc] initWithStyle:UITableViewStylePlain];
        self.heroList.type = @"hero";
        self.heroList.title = NSLocalizedString(@"Select Hero", nil);
        [self.heroList updateView];
        [UIManager.i showTemplate:@[self.heroList] :self.heroList.title];
    }
    else if ([item_category2 isEqualToString:@"heroxp"])
    {
        NSString *item_value = item_row[@"item_value"];
        
        [self useItemHeroxp:item_id :item_value];
    }
    else if ([item_category2 isEqualToString:@"destroybuilding"])
    {
        if (self.itemInfo != nil)
        {
            NSNumber *b_location = [self.itemInfo objectForKey:@"building_location"];
            
            if (b_location != nil)
            {
                [self destroyBuilding:b_location];
            }
        }
    }
    else if ([item_category2 isEqualToString:@"speedups"])
    {
        if (self.itemInfo != nil)
        {
            NSString *item_id = item_row[@"item_id"];
            NSString *item_value = item_row[@"item_value"];
            NSString *base_id = [self.itemInfo objectForKey:@"base_id"];
            NSString *type = [self.itemInfo objectForKey:@"item_type"];
            
            
            if (base_id != nil)
            {
                [self speedUp:base_id :item_id :item_value :type];
            }
        }
    }
    else if ([item_category2 isEqualToString:@"march"])
    {
        if (self.itemInfo != nil)
        {
            NSString *item_id = item_row[@"item_id"];
            NSString *item_value = item_row[@"item_value"];
            NSString *base_id = [self.itemInfo objectForKey:@"base_id"];
            NSString *type = [self.itemInfo objectForKey:@"item_type"];
            NSString *row_id = [self.itemInfo objectForKey:@"row_id"];
            
            if (base_id != nil)
            {
                [self speedUpPercent:base_id :item_id :item_value :type :row_id];
            }
        }
    }
    else if ([item_category2 isEqualToString:@"teleport"])
    {
        if (self.itemInfo != nil)
        {
            NSString *map_x = [self.itemInfo objectForKey:@"map_x"];
            NSString *map_y = [self.itemInfo objectForKey:@"map_y"];
            
            if ((map_x != nil) && (map_y != nil))
            {
                [self teleportTo:map_x :map_y];
            }
        }
    }
    else if ([item_category2 isEqualToString:@"protection"])
    {
        NSString *item_id = item_row[@"item_id"];
        NSString *base_id = @"";
        if (self.itemInfo != nil)
        {
            base_id = [self.itemInfo objectForKey:@"base_id"];
        }
        else
        {
            base_id = Globals.i.wsBaseDict[@"base_id"];
        }
        
        [self applyProtection:base_id :item_id];
        
    }
}

- (void)teleportTo:(NSString *)map_x :(NSString *)map_y
{
    NSString *service_name = @"TeleportTo";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], Globals.i.wsBaseDict[@"base_id"], map_x, map_y];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [self fetchItemArray];
             
             [UIManager.i closeAllTemplate];
             
             Globals.i.wsBaseDict[@"map_x"] = map_x;
             Globals.i.wsBaseDict[@"map_y"] = map_y;
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMap"
                                                                 object:self];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMap"
                                                                 object:self];
             
             [UIManager.i showToast:NSLocalizedString(@"Teleported!", nil)
                      optionalTitle:@"CityTeleported"
                      optionalImage:self.item_image_choosed];
         }
     }];
}

- (void)recallAttack:(NSString *)base_id :(NSString *)item_id :(NSString *)item_value :(NSString *)type
{
    NSString *service_name = @"RecallAttack";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], base_id, item_id, type];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i play_speedup];
             
             NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
             [userInfo setObject:base_id forKey:@"base_id"];
             [userInfo setObject:item_value forKey:@"item_value"];
             [userInfo setObject:type forKey:@"item_type"];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"RecallAttack"
              object:self userInfo:userInfo];
             
             [self fetchItemArray];
             
             [UIManager.i closeTemplate];
             
             [UIManager.i showToast:NSLocalizedString(@"Attack Recalled", nil)
                    optionalTitle:@"AttackRecalled"
                    optionalImage:self.item_image_choosed];
             
         }
     }];
}

- (void)speedUp:(NSString *)base_id :(NSString *)item_id :(NSString *)item_value :(NSString *)type
{
    NSString *service_name = @"SpeedUp";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], base_id, item_id, type];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i play_speedup];

                 NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                 [userInfo setObject:base_id forKey:@"base_id"];
                 [userInfo setObject:item_value forKey:@"item_value"];
                 [userInfo setObject:type forKey:@"item_type"];
                 
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"SpeedUp"
                  object:self userInfo:userInfo];
                 
                 [self fetchItemArray];
                 
                 if ([type integerValue] == TV_BUILD)
                 {
                     [UIManager.i closeAllTemplate];
                 }
                 else
                 {
                     [UIManager.i closeTemplate];
                 }
                 
                 [UIManager.i showToast:NSLocalizedString(@"Speed Up Applied.", nil)
                          optionalTitle:@"SpeedUpApplied"
                          optionalImage:self.item_image_choosed];
         }
     }];
}

- (void)speedUpPercent:(NSString *)base_id :(NSString *)item_id :(NSString *)item_value :(NSString *)type :(NSString *)row_id
{
    NSString *service_name = @"SpeedUp";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], base_id, item_id, type];
    NSLog(@"speedUpPercent wsurl: %@",wsurl);
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i play_speedup];
             
                 NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                 [userInfo setObject:base_id forKey:@"base_id"];
                 [userInfo setObject:item_value forKey:@"item_value"];
                 [userInfo setObject:type forKey:@"item_type"];
                 
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"SpeedUpPercent"
                  object:self userInfo:userInfo];
                 
                 [self fetchItemArray];
                 
                 [UIManager.i closeTemplate];
                 
                 [UIManager.i showToast:NSLocalizedString(@"Speed Up Percent Applied.", nil)
                          optionalTitle:@"SpeedUpPercentApplied"
                          optionalImage:self.item_image_choosed];
         }
     }];
}

- (void)applyBoost:(NSString *)base_id :(NSString *)item_id :(NSString *)item_value :(NSString *)type
{
    NSString *service_name = @"ApplyBoost";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], base_id, item_id, type];
    
    NSLog(@"applyBoost type: %@",type);
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i play_speedup];
             
             [Globals.i updateBaseDict:^(BOOL success, NSData *data)
              {
                  NSString *tv_title = @"";
                  
                  NSLog(@"updateBaseDict after ApplyBoost");
                  switch ([type integerValue])
                  {
                      case 12:
                          tv_title = NSLocalizedString(@"Food Boost", nil);
                          [Globals.i setTimerViewTitle:TV_BOOST_R1 :tv_title];
                          [Globals.i setupBoostR1Queue:[Globals.i updateTime]];
                          break;
                      case 13:
                          tv_title = NSLocalizedString(@"Wood Boost", nil);
                          [Globals.i setTimerViewTitle:TV_BOOST_R2 :tv_title];
                          [Globals.i setupBoostR2Queue:[Globals.i updateTime]];
                          break;
                      case 14:
                          tv_title = NSLocalizedString(@"Stone Boost", nil);
                          [Globals.i setTimerViewTitle:TV_BOOST_R3 :tv_title];
                          [Globals.i setupBoostR3Queue:[Globals.i updateTime]];
                          break;
                      case 15:
                          tv_title = NSLocalizedString(@"Ore Boost", nil);
                          [Globals.i setTimerViewTitle:TV_BOOST_R4 :tv_title];
                          [Globals.i setupBoostR4Queue:[Globals.i updateTime]];
                          break;
                      case 16:
                          tv_title = NSLocalizedString(@"Gold Boost", nil);
                          [Globals.i setTimerViewTitle:TV_BOOST_R5 :tv_title];
                          [Globals.i setupBoostR5Queue:[Globals.i updateTime]];
                          break;
                      case 17:
                          tv_title = NSLocalizedString(@"Attack Boost", nil);
                          [Globals.i setTimerViewTitle:TV_BOOST_ATT :tv_title];
                          [Globals.i setupBoostAttackQueue:[Globals.i updateTime]];
                          break;
                      case 18:
                          tv_title = NSLocalizedString(@"Defense Boost", nil);
                          [Globals.i setTimerViewTitle:TV_BOOST_DEF :tv_title];
                          [Globals.i setupBoostDefendQueue:[Globals.i updateTime]];
                          break;
                      default:
                          break;
                  }
                  
                  //Item count will minus
                  [self fetchItemArray];
                  
                  [UIManager.i closeTemplate];
                  
                  [UIManager.i showToast:NSLocalizedString(@"Boost Applied.", nil)
                         optionalTitle:@"BoostApplied"
                         optionalImage:self.item_image_choosed];
              }];
         }
     }];
}

- (void)applyProtection:(NSString *)base_id :(NSString *)item_id
{
    NSString *service_name = @"ApplyProtection";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], base_id, item_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i play_speedup];
             
             [self fetchItemArray];
             
             [UIManager.i closeTemplate];
             
             [UIManager.i showToast:NSLocalizedString(@"Protection Applied.", nil)
                    optionalTitle:@"protectionApplied"
                    optionalImage:self.item_image_choosed];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateBaseList"
                                                                 object:self];

         }
     }];
}

- (void)destroyBuilding:(NSNumber *)building_location
{
    NSString *service_name = @"DestroyBuilding";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], Globals.i.wsBaseDict[@"base_id"], [building_location stringValue]];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i play_destroy];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"BuildingDestroy"
              object:self
              userInfo:self.itemInfo];
             
             [self fetchItemArray];
             
             [UIManager.i closeAllTemplate];
             
             //This updates balance resources, resource productions, build location and build que
             [Globals.i updateBaseDict:^(BOOL success, NSData *data)
              {
                  [UIManager.i showToast:NSLocalizedString(@"Building Destroyed Successfully!", nil)
                         optionalTitle:@"BuildingDestroyed"
                         optionalImage:self.item_image_choosed];
              }];
         }
     }];
}

- (void)useItemHeroxp:(NSString *)item_id :(NSString *)item_value
{
    NSString *service_name = @"UseItemHeroxp";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], item_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i updateHeroXP:[item_value integerValue]];
             
             [self fetchItemArray];
             
             [UIManager.i showToast:NSLocalizedString(@"Hero XP Increased Successfully!", nil)
                      optionalTitle:@"HeroXPItemIncrease"
                      optionalImage:self.item_image_choosed];
         }
     }];
}

- (void)useItemResources:(NSString *)item_id :(NSString *)item_value :(NSString *)base_id :(NSString *)resource_type
{
    NSString *service_name = @"UseItemResources";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], resource_type, base_id, item_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             double r = [Globals.i.wsBaseDict[resource_type] doubleValue] + [item_value doubleValue];
             Globals.i.wsBaseDict[resource_type] = [@(r) stringValue];
             
             Globals.i.base_r1 = [Globals.i.wsBaseDict[@"r1"] doubleValue];
             Globals.i.base_r2 = [Globals.i.wsBaseDict[@"r2"] doubleValue];
             Globals.i.base_r3 = [Globals.i.wsBaseDict[@"r3"] doubleValue];
             Globals.i.base_r4 = [Globals.i.wsBaseDict[@"r4"] doubleValue];
             Globals.i.base_r5 = [Globals.i.wsBaseDict[@"r5"] doubleValue];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"ResourcesAdded"
              object:self];
             
             [self fetchItemArray];
             
             [UIManager.i showToast:NSLocalizedString(@"Resources added Successfully!", nil)
                      optionalTitle:@"ResourceAdded"
                      optionalImage:self.item_image_choosed];
         }
     }];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = (self.ui_cells_array)[indexPath.section][indexPath.row];
    
    if (indexPath.section == 0 && self.finalFilterArray.count > 0)
    {
        NSDictionary *row1 = (self.finalFilterArray)[[indexPath row]];
        
        NSString *item_quantity = row1[@"quantity"];
        if ([item_quantity isEqualToString:@""])
        {
            item_quantity = @"0";
        }
        
        NSString *i1 = row1[@"item_image"];
        NSString *r1 = row1[@"item_name"];
        NSString *r2 = row1[@"item_details"];
        NSString *n1 = [NSString stringWithFormat:NSLocalizedString(@"Own:%@", nil), item_quantity];
        NSString *n1_button = @"";
        NSString *n2 = @"";
        NSString *c1 = @"";
        NSString *c1_button = @"";
        NSString *c2 = @"";
        NSString *c2_icon = @"";
        NSString *c2_bkg = @"";
        NSString *d1 = @"";
        
        //NSLog(@"%@: %@", r1, item_quantity);
        
        if ([self.my_items isEqualToString:@"1"])
        {
            if ([row1[@"item_use"] isEqualToString:@"1"])
            {
                c1 = NSLocalizedString(@"Use", nil);
                c1_button = @"2";
                c2 = @" ";
            }
            else
            {
                c1 = @"";
                c1_button = @"";
                c2 = @"";
            }
        }
        else
        {
            if ([row1[@"item_forsale"] isEqualToString:@"0"] || ([row1[@"item_cost"] integerValue] < 1))
            {
                c1 = @"";
                c1_button = @"";
                c2 = @"";
                c2_bkg = @"";
                c2_icon = @"";
            }
            else
            {
                c1 = @"Get";
                c1_button = @"2";
                c2 = row1[@"item_cost"];
                c2_bkg = @"bkg3";
                c2_icon = @"icon_currency2";
            }
            
            if ([row1[@"item_use"] isEqualToString:@"1"] || ![self.i_category2 isEqualToString:@"0"])
            {
                if ([row1[@"quantity"] integerValue] > 0)
                {
                    n2 = @"Use";
                    n1_button = @"2";
                }
                else
                {
                    n2 = @"";
                    n1_button = @"";
                }
            }
        }
        
        rowData = @{@"i1": i1, @"i1_over": @"item_frame", @"n1": n1, @"n2": n2, @"r1": r1, @"r1_bold": @"1", @"r2": r2, @"c1_ratio": @"3", @"c1": c1, @"c1_button": c1_button, @"c2": c2, @"c2_icon": c2_icon, @"c2_bkg": c2_bkg, @"d1": d1, @"n1_align": @"1", @"n1_width": @"60", @"n1_button": n1_button};
    }
    
    return rowData;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_n.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_n.btn.tag = indexPath.row;
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = indexPath.row;
    
    return dcell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ((section == 0) && (self.itemInfo == nil))
    {
        [self createCategoryTabs];
        
        return self.categoryTabView.view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ((section == 0) && (self.itemInfo == nil))
    {
        return 40.0f*SCALE_IPAD;
    }
    
    return 0.0f;
}

@end
