//
//  TechList.m
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

#import "TechList.h"
#import "Globals.h"
#import "TechView.h"

@interface TechList ()

@property (nonatomic, strong) TechView *techView;

@end

@implementation TechList

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tech_type = 0;
    [self notificationRegister];
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChooseTech"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"ChooseTech"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *techArea_index = [userInfo objectForKey:@"tech_area"];
            NSNumber *tech_index = [userInfo objectForKey:@"tech"];
            
            NSLog(@"techArea_index : %@",techArea_index);
            NSLog(@"tech_index : %@",tech_index);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[tech_index intValue] inSection:0];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"customCellView Tech : %@",customCellView);
            
            
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView.delegate tableView:self.tableView willSelectRowAtIndexPath:indexPath];

        }
    }
}

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSInteger thisrank = 0;
    NSInteger production_level = 1; //TODO: Production is hard coded
    
    NSDictionary *row100 = @{@"h1": NSLocalizedString(@"City Tech", nil)};
    thisrank = [Globals.i.wsBaseDict[@"research_build"] integerValue]/production_level;
    NSDictionary *row101 = @{@"tech_id": @(101), @"tech_level": @(thisrank), @"i1": @"tech_build", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Construction", nil), @"r2": NSLocalizedString(@"Increases build speed in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_research"] integerValue]/production_level;
    NSDictionary *row102 = @{@"tech_id": @(102), @"tech_level": @(thisrank), @"i1": @"tech_research", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Research", nil), @"r2": NSLocalizedString(@"Increases research speed in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_march"] integerValue]/production_level;
    NSDictionary *row103 = @{@"tech_id": @(103), @"tech_level": @(thisrank), @"i1": @"tech_march", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"March", nil), @"r2": NSLocalizedString(@"Increases marching speed in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_trade"] integerValue]/production_level;
    NSDictionary *row104 = @{@"tech_id": @(104), @"tech_level": @(thisrank), @"i1": @"tech_trade", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Trading", nil), @"r2": NSLocalizedString(@"Increases trading speed in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_craft"] integerValue]/production_level;
    NSDictionary *row105 = @{@"tech_id": @(105), @"tech_level": @(thisrank), @"i1": @"tech_craft", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Crafting", nil), @"r2": NSLocalizedString(@"Increases crafting speed in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_heal"] integerValue]/production_level;
    NSDictionary *row106 = @{@"tech_id": @(106), @"tech_level": @(thisrank), @"i1": @"tech_heal", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Healing", nil), @"r2": NSLocalizedString(@"Increases healing speed in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_training"] integerValue]/production_level;
    NSDictionary *row107 = @{@"tech_id": @(107), @"tech_level": @(thisrank), @"i1": @"tech_training", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Training", nil), @"r2": NSLocalizedString(@"Increases training speed in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    NSArray *rows1 = @[row100, row101, row102, row103, row104, row105, row106, row107];
    
    NSDictionary *row200 = @{@"h1": NSLocalizedString(@"Economics Tech", nil)};
    thisrank = [Globals.i.wsBaseDict[@"research_r1"] integerValue]/production_level;
    NSDictionary *row201 = @{@"tech_id": @(201), @"tech_level": @(thisrank), @"i1": @"tech_r1", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Food Production", nil), @"r2": NSLocalizedString(@"Increases Food production in your City. Each upgrade increases production by 5%", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_r2"] integerValue]/production_level;
    NSDictionary *row202 = @{@"tech_id": @(202), @"tech_level": @(thisrank), @"i1": @"tech_r2", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Wood Production", nil), @"r2": NSLocalizedString(@"Increases Wood production in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_r3"] integerValue]/production_level;
    NSDictionary *row203 = @{@"tech_id": @(203), @"tech_level": @(thisrank), @"i1": @"tech_r3", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Stone Production", nil), @"r2": NSLocalizedString(@"Increases Stone production in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_r4"] integerValue]/production_level;
    NSDictionary *row204 = @{@"tech_id": @(204), @"tech_level": @(thisrank), @"i1": @"tech_r4", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Ore Production", nil), @"r2": NSLocalizedString(@"Increases Ore production in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_r5"] integerValue]/production_level;
    NSDictionary *row205 = @{@"tech_id": @(205), @"tech_level": @(thisrank), @"i1": @"tech_r5", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Gold Production", nil), @"b1": NSLocalizedString(@"Increases Gold production in your City.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    NSArray *rows2 = @[row200, row201, row202, row203, row204, row205];
    
    NSDictionary *row300 = @{@"h1": NSLocalizedString(@"Military Tech", nil)};
    thisrank = [Globals.i.wsBaseDict[@"research_attack"] integerValue]/production_level;
    NSDictionary *row301 = @{@"tech_id": @(301), @"tech_level": @(thisrank), @"i1": @"tech_attack", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Troop Attack", nil), @"r2": NSLocalizedString(@"Increases overall troop attack.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_defense"] integerValue]/production_level;
    NSDictionary *row302 = @{@"tech_id": @(302), @"tech_level": @(thisrank), @"i1": @"tech_defense", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Troop Defense", nil), @"r2": NSLocalizedString(@"Increases overall troop defense.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_life"] integerValue]/production_level;
    NSDictionary *row303 = @{@"tech_id": @(303), @"tech_level": @(thisrank), @"i1": @"tech_life", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Troop Life", nil), @"r2": NSLocalizedString(@"Increases overall troop life.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_load"] integerValue]/production_level;
    NSDictionary *row304 = @{@"tech_id": @(304), @"tech_level": @(thisrank), @"i1": @"tech_load", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Troop Load", nil), @"r2": NSLocalizedString(@"Increases overall troop load.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    NSArray *rows3 = @[row300, row301, row302, row303, row304];
    
    NSDictionary *row400 = @{@"h1": @"Combat Tech"};
    thisrank = [Globals.i.wsBaseDict[@"research_a_attack"] integerValue]/production_level;
    NSDictionary *row401 = @{@"tech_id": @(401), @"tech_level": @(thisrank), @"i1": @"tech_a_attack", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Infantry Attack", nil), @"r2": NSLocalizedString(@"Increases infantry units attack.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_b_attack"] integerValue]/production_level;
    NSDictionary *row402 = @{@"tech_id": @(402), @"tech_level": @(thisrank), @"i1": @"tech_b_attack", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Ranged Attack", nil), @"r2": NSLocalizedString(@"Increases ranged units attack.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_c_attack"] integerValue]/production_level;
    NSDictionary *row403 = @{@"tech_id": @(403), @"tech_level": @(thisrank), @"i1": @"tech_c_attack", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Cavalry Attack", nil), @"r2": NSLocalizedString(@"Increases cavalry units attack.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    thisrank = [Globals.i.wsBaseDict[@"research_d_attack"] integerValue]/production_level;
    NSDictionary *row404 = @{@"tech_id": @(404), @"tech_level": @(thisrank), @"i1": @"tech_d_attack", @"n1": [NSString stringWithFormat:@"Level %@", [@(thisrank) stringValue]], @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Siege Attack", nil), @"r2": NSLocalizedString(@"Increases siege units attack.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    NSArray *rows4 = @[row400, row401, row402, row403, row404];
    
    NSString *n1 = NSLocalizedString(@"LOCKED", nil);
    NSString *n1_color = @"1";
    BOOL a3_show = NO;
    BOOL b3_show = NO;
    BOOL c3_show = NO;
    BOOL d3_show = NO;
    NSDictionary *row500 = @{@"h1": NSLocalizedString(@"Troops Tech", nil)};
    
    thisrank = [Globals.i.wsBaseDict[@"research_a2"] integerValue];
    if (thisrank > 0)
    {
        n1 = NSLocalizedString(@"UNLOCKED", nil);
        n1_color = @"6";
        a3_show = YES;
    }
    else
    {
        n1 = NSLocalizedString(@"LOCKED", nil);
        n1_color = @"1";
    }
    NSDictionary *row501 = @{@"tech_id": @(1101), @"tech_level": @(thisrank), @"i1": @"icon_a2", @"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Swordsmen", nil), @"r2": NSLocalizedString(@"Unlocks Swordsmen infantry tier 2 unit to be trained in the Barracks.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    
    thisrank = [Globals.i.wsBaseDict[@"research_b2"] integerValue];
    if (thisrank > 0)
    {
        n1 = NSLocalizedString(@"UNLOCKED", nil);
        n1_color = @"6";
        b3_show = YES;
    }
    else
    {
        n1 = NSLocalizedString(@"LOCKED", nil);
        n1_color = @"1";
    }
    NSDictionary *row502 = @{@"tech_id": @(1201), @"tech_level": @(thisrank), @"i1": @"icon_b2", @"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Longbowmen", nil), @"r2": NSLocalizedString(@"Unlocks Longbowmen ranged tier 2 unit to be trained in the Archery Range.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    
    thisrank = [Globals.i.wsBaseDict[@"research_c2"] integerValue];
    if (thisrank > 0)
    {
        n1 = NSLocalizedString(@"UNLOCKED", nil);
        n1_color = @"6";
        c3_show = YES;
    }
    else
    {
        n1 = NSLocalizedString(@"LOCKED", nil);
        n1_color = @"1";
    }
    NSDictionary *row503 = @{@"tech_id": @(1301), @"tech_level": @(thisrank), @"i1": @"icon_c2", @"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Heavy Cavalry", nil), @"r2": NSLocalizedString(@"Unlocks Heavy Cavalry cavalry tier 2 unit to be trained in the Stables.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    
    thisrank = [Globals.i.wsBaseDict[@"research_d2"] integerValue];
    if (thisrank > 0)
    {
        n1 = NSLocalizedString(@"UNLOCKED", nil);
        n1_color = @"6";
        d3_show = YES;
    }
    else
    {
        n1 = NSLocalizedString(@"LOCKED", nil);
        n1_color = @"1";
    }
    NSDictionary *row504 = @{@"tech_id": @(1401), @"tech_level": @(thisrank), @"i1": @"icon_d2", @"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Ballista", nil), @"r2": NSLocalizedString(@"Unlocks Ballista siege tier 2 unit to be trained in the Workshop.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
    
    NSMutableArray *rows5 = [@[row500, row501, row502, row503, row504] mutableCopy];
    
    if (a3_show)
    {
        thisrank = [Globals.i.wsBaseDict[@"research_a3"] integerValue];
        if (thisrank > 0)
        {
            n1 = NSLocalizedString(@"UNLOCKED", nil);
            n1_color = @"6";
        }
        else
        {
            n1 = NSLocalizedString(@"LOCKED", nil);
            n1_color = @"1";
        }
        NSDictionary *row505 = @{@"tech_id": @(1102), @"tech_level": @(thisrank), @"i1": @"icon_a3", @"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Halberdier", nil), @"r2": NSLocalizedString(@"Unlocks Halberdier infantry tier 3 unit to be trained in the Barracks.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
        [rows5 addObject:row505];
    }
    
    if (b3_show)
    {
        thisrank = [Globals.i.wsBaseDict[@"research_b3"] integerValue];
        if (thisrank > 0)
        {
            n1 = NSLocalizedString(@"UNLOCKED", nil);
            n1_color = @"6";
        }
        else
        {
            n1 = NSLocalizedString(@"LOCKED", nil);
            n1_color = @"1";
        }
        NSDictionary *row505 = @{@"tech_id": @(1202), @"tech_level": @(thisrank), @"i1": @"icon_b3", @"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Marksmen", nil), @"r2": NSLocalizedString(@"Unlocks Marksmen ranged tier 3 unit to be trained in the Archery Range.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
        [rows5 addObject:row505];
    }
    
    if (c3_show)
    {
        thisrank = [Globals.i.wsBaseDict[@"research_c3"] integerValue];
        if (thisrank > 0)
        {
            n1 = NSLocalizedString(@"UNLOCKED", nil);
            n1_color = @"6";
        }
        else
        {
            n1 = NSLocalizedString(@"LOCKED", nil);
            n1_color = @"1";
        }
        NSDictionary *row505 = @{@"tech_id": @(1302), @"tech_level": @(thisrank), @"i1": @"icon_c3", @"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Knight", nil), @"r2": NSLocalizedString(@"Unlocks Knight cavalry tier 3 unit to be trained in the Stables.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
        [rows5 addObject:row505];
    }
    
    if (d3_show)
    {
        thisrank = [Globals.i.wsBaseDict[@"research_d3"] integerValue];
        if (thisrank > 0)
        {
            n1 = NSLocalizedString(@"UNLOCKED", nil);
            n1_color = @"6";
        }
        else
        {
            n1 = NSLocalizedString(@"LOCKED", nil);
            n1_color = @"1";
        }
        NSDictionary *row505 = @{@"tech_id": @(1402), @"tech_level": @(thisrank), @"i1": @"icon_d3", @"n1": n1, @"n1_color": n1_color, @"n1_bold": @"1", @"n1_align": @"1", @"r1": NSLocalizedString(@"Catapult", nil), @"r2": NSLocalizedString(@"Unlocks Catapult siege tier 3 unit to be trained in the Workshop.", nil), @"i2": @"arrow_right", @"r1_bold": @"1", @"n1_width": @"64"};
        [rows5 addObject:row505];
    }
    
    NSMutableArray *techTypeRows = [@[rows1, rows2, rows3, rows4, rows5] mutableCopy];
    
    self.ui_cells_array = [@[techTypeRows[self.tech_type]]mutableCopy];
	
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row > 0) && (indexPath.row < [self.ui_cells_array[0] count]))
    {
        NSString *n1 = [self.ui_cells_array[0][indexPath.row] objectForKey:@"n1"];
        if ([n1 isEqualToString:NSLocalizedString(@"UNLOCKED", nil)])
        {
            [UIManager.i showDialog:NSLocalizedString(@"Congratulations! this unit is Unlocked and do not require research.", nil) title:@"UnitUnlocked"];
        }
        else
        {
            NSMutableDictionary *rowTarget = self.ui_cells_array[0][indexPath.row];
            NSInteger tech_lvl = [rowTarget[@"tech_level"] integerValue];
            if (tech_lvl < 22)
            {
                if (self.techView == nil)
                {
                    self.techView = [[TechView alloc] initWithStyle:UITableViewStylePlain];
                }
                NSMutableDictionary *rtarget = [[NSMutableDictionary alloc] initWithDictionary:rowTarget copyItems:YES];
                [rtarget removeObjectsForKeys:@[@"i2", @"n1"]];
                
                self.techView.row_target = rtarget;
                self.techView.building_level = self.building_level;
                self.techView.tech_level = tech_lvl+1;
                self.techView.tech_id = [rowTarget[@"tech_id"] stringValue];
                self.techView.tech_name = rowTarget[@"r1"];
                self.techView.title = @"Research";
                
                [UIManager.i showTemplate:@[self.techView] :self.techView.title];
                [self.techView clearView];
                [self.techView updateView];
            }
            else
            {
                [UIManager.i showDialog:NSLocalizedString(@"You have reached the maximum level for this technology!", nil) title:@"MaximumLevelForTechReached"];
            }
        }
    }
    
	return nil;
}

@end
