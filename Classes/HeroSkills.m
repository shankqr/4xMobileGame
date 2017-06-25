//
//  HeroSkills.m
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

#import "HeroSkills.h"
#import "Globals.h"

@implementation HeroSkills

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeroSkillPoints"
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
            
            if (Globals.i.skill_point_spent)
            {
                //Updates boost stats for hero and profile
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.skill_point_spent = NO;
                 }];
            }
        }
    }
    else if ([[notification name] isEqualToString:@"UpdateHeroSkillPoints"])
    {
        [self updateView];
    }
}

- (void)updateView
{
    [self notificationRegister];
    
    NSDictionary *row101 = @{@"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1": NSLocalizedString(@"Spend your skill points.", nil)};
    NSDictionary *row102 = @{@"nofooter": @"1", @"r1_align": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": [NSString stringWithFormat:NSLocalizedString(@"Skill Points: %@", nil), [Globals.i intString:[Globals.i spBalance]]]};
    NSArray *rows1 = @[row101, row102];
    
    NSString *c1_button_type = @"1";
    if ([Globals.i spBalance] > 0)
    {
        c1_button_type = @"2";
    }
    
    NSInteger thisrank = 0;
    
    NSDictionary *row201 = @{@"h1": NSLocalizedString(@"Production Skills", nil)};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_r1"] integerValue];
    NSDictionary *row202 = @{@"i1": @"skill_r1", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Food Production", nil), @"b1": NSLocalizedString(@"Increases Food production in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_r2"] integerValue];
    NSDictionary *row203 = @{@"i1": @"skill_r2", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Wood Production", nil), @"b1": NSLocalizedString(@"Increases Wood production in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_r3"] integerValue];
    NSDictionary *row204 = @{@"i1": @"skill_r3", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Stone Production", nil), @"b1": NSLocalizedString(@"Increases Stone production in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_r4"] integerValue];
    NSDictionary *row205 = @{@"i1": @"skill_r4", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Ore Production", nil), @"b1": NSLocalizedString(@"Increases Ore production in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_r5"] integerValue];
    NSDictionary *row206 = @{@"i1": @"skill_r5", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Gold Production", nil), @"b1": NSLocalizedString(@"Increases Gold production in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    NSArray *rows2 = @[row201, row202, row203, row204, row205, row206];

    NSDictionary *row301 = @{@"h1": NSLocalizedString(@"City Skills", nil)};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_build"] integerValue];
    NSDictionary *row302 = @{@"i1": @"skill_build", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Construction", nil), @"b1": NSLocalizedString(@"Increases build speed in your current City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_research"] integerValue];
    NSDictionary *row303 = @{@"i1": @"skill_research", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Research", nil), @"b1": NSLocalizedString(@"Increases research speed in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_march"] integerValue];
    NSDictionary *row304 = @{@"i1": @"skill_march", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"March", nil), @"b1": NSLocalizedString(@"Increases marching speed in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_trade"] integerValue];
    NSDictionary *row305 = @{@"i1": @"skill_trade", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Trading", nil), @"b1": NSLocalizedString(@"Increases trading speed in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_craft"] integerValue];
    NSDictionary *row306 = @{@"i1": @"skill_craft", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Crafting", nil), @"b1": NSLocalizedString(@"Increases crafting speed in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_heal"] integerValue];
    NSDictionary *row307 = @{@"i1": @"skill_heal", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Healing", nil), @"b1": NSLocalizedString(@"Increases healing speed in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_training"] integerValue];
    NSDictionary *row308 = @{@"i1": @"skill_training", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Training", nil), @"b1": NSLocalizedString(@"Increases training speed in your City.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    NSArray *rows3 = @[row301, row302, row303, row304, row305, row306, row307, row308];
    
    NSDictionary *row401 = @{@"h1": NSLocalizedString(@"Troop Skills", nil)};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_attack"] integerValue];
    NSDictionary *row402 = @{@"i1": @"skill_attack", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Troop Attack", nil), @"b1": NSLocalizedString(@"Increases overall troop attack.", nil), @"r2": [NSString stringWithFormat:@"Now: +%@%%, After: +%@%%", [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_defense"] integerValue];
    NSDictionary *row403 = @{@"i1": @"skill_defense", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Troop Defense", nil), @"b1": NSLocalizedString(@"Increases overall troop defense.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_life"] integerValue];
    NSDictionary *row404 = @{@"i1": @"skill_life", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Troop Life", nil), @"b1": NSLocalizedString(@"Increases overall troop life.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_load"] integerValue];
    NSDictionary *row405 = @{@"i1": @"skill_load", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Troop Load", nil), @"b1": NSLocalizedString(@"Increases overall troop load.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    NSArray *rows4 = @[row401, row402, row403, row404, row405];

    NSDictionary *row501 = @{@"h1": NSLocalizedString(@"Attack Skills", nil)};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_a_attack"] integerValue];
    NSDictionary *row502 = @{@"i1": @"skill_a_attack", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Infantry Attack", nil), @"b1": NSLocalizedString(@"Increases infantry units attack.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_b_attack"] integerValue];
    NSDictionary *row503 = @{@"i1": @"skill_b_attack", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Ranged Attack", nil), @"b1": NSLocalizedString(@"Increases ranged units attack.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_c_attack"] integerValue];
    NSDictionary *row504 = @{@"i1": @"skill_c_attack", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Cavalry Attack", nil), @"b1": NSLocalizedString(@"Increases cavalry units attack.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsWorldProfileDict[@"hero_d_attack"] integerValue];
    NSDictionary *row505 = @{@"i1": @"skill_d_attack", @"p1": @(thisrank/100.0f), @"p1_text": [NSString stringWithFormat:@"%@/100", [@(thisrank) stringValue]], @"r1": NSLocalizedString(@"Siege Attack", nil), @"b1": NSLocalizedString(@"Increases siege units attack.", nil), @"r2": [NSString stringWithFormat:NSLocalizedString(@"Now: +%@%%, After: +%@%%", nil), [Globals.i intString:thisrank], [Globals.i intString:thisrank+1]], @"c1": NSLocalizedString(@"Spend Point", nil), @"c1_button": c1_button_type, @"r1_bold": @"1", @"n1_width": @"64"};
    NSArray *rows5 = @[row501, row502, row503, row504, row505];
    
    self.ui_cells_array = [@[rows1, rows2, rows3, rows4, rows5] mutableCopy];
	
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (void)button1_tap:(id)sender
{
    [Globals.i play_button];
    
    NSInteger i = [sender tag];
    
    if (i == 202)
    {
        [self spendPoint:@"hero_r1"];
    }
    else if (i == 203)
    {
        [self spendPoint:@"hero_r2"];
    }
    else if (i == 204)
    {
        [self spendPoint:@"hero_r3"];
    }
    else if (i == 205)
    {
        [self spendPoint:@"hero_r4"];
    }
    else if (i == 206)
    {
        [self spendPoint:@"hero_r5"];
    }
    else if (i == 302)
    {
        [self spendPoint:@"hero_build"];
    }
    else if (i == 303)
    {
        [self spendPoint:@"hero_research"];
    }
    else if (i == 304)
    {
        [self spendPoint:@"hero_march"];
    }
    else if (i == 305)
    {
        [self spendPoint:@"hero_trade"];
    }
    else if (i == 306)
    {
        [self spendPoint:@"hero_craft"];
    }
    else if (i == 307)
    {
        [self spendPoint:@"hero_heal"];
    }
    else if (i == 308)
    {
        [self spendPoint:@"hero_training"];
    }
    else if (i == 402)
    {
        [self spendPoint:@"hero_attack"];
    }
    else if (i == 403)
    {
        [self spendPoint:@"hero_defense"];
    }
    else if (i == 404)
    {
        [self spendPoint:@"hero_life"];
    }
    else if (i == 405)
    {
        [self spendPoint:@"hero_load"];
    }
    else if (i == 502)
    {
        [self spendPoint:@"hero_a_attack"];
    }
    else if (i == 503)
    {
        [self spendPoint:@"hero_b_attack"];
    }
    else if (i == 504)
    {
        [self spendPoint:@"hero_c_attack"];
    }
    else if (i == 505)
    {
        [self spendPoint:@"hero_d_attack"];
    }
}

- (void)spendPoint:(NSString *)type
{
    if (([Globals.i spBalance] > 0) && ([Globals.i.wsWorldProfileDict[type] integerValue] < 100))
    {
        NSString *service_name = @"SpendPoint";
        NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                           Globals.i.wsWorldProfileDict[@"uid"], type];
        
        [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 // + 1 to hero skills
                 NSInteger new_hero_points = [Globals.i.wsWorldProfileDict[type] integerValue] + 1;
                 Globals.i.wsWorldProfileDict[type] = [@(new_hero_points) stringValue];
                 
                 Globals.i.skill_point_spent = YES;
                 
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHeroSkillPoints"
                                                                     object:self
                                                                   userInfo:nil];
                 
                 [UIManager.i showToast:NSLocalizedString(@"Skill Points updated!", nil)
                          optionalTitle:@"SkillPointsUpdated"
                          optionalImage:@"icon_check"];
                 
             }
         }];
        
    }
}

@end
