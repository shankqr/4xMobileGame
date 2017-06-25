//
//  ProfileView.m
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

#import "ProfileView.h"
#import "Globals.h"

@interface ProfileView ()

@end

@implementation ProfileView

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSInteger village_count = [self.profileDict[@"base_count"] integerValue] - 1;
    
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Profile Stats", nil), @"r1_align": @"1", @"r1_color": @"2", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"n1": NSLocalizedString(@"Stats", nil), @"r1": NSLocalizedString(@"Score", nil), @"c1": NSLocalizedString(@"Rank", nil), @"n1_border": @"1", @"r1_border": @"1", @"n1_width": @"130", @"bkg": @"skin_cell1", @"nofooter": @"1", @"n1_align": @"1", @"r1_align": @"1", @"c1_align": @"1"};
    NSDictionary *row103 = @{@"n1": NSLocalizedString(@"Power", nil), @"bkg": @"skin_cell2", @"r1": [Globals.i autoNumber:self.profileDict[@"xp"]], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_xp"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row104 = @{@"n1": NSLocalizedString(@"Total Villages", nil), @"bkg": @"skin_cell1", @"r1": [Globals.i uintString:village_count], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_base_count"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row105 = @{@"n1": NSLocalizedString(@"Troop Kills", nil), @"bkg": @"skin_cell2", @"r1": [Globals.i autoNumber:self.profileDict[@"kills"]], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_kills"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row106 = @{@"n1": NSLocalizedString(@"Troop Lost", nil), @"bkg": @"skin_cell1", @"r1": [Globals.i autoNumber:self.profileDict[@"troop_lost"]], @"c1": @"-", @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row107 = @{@"n1": NSLocalizedString(@"Troop Kills/Lost", nil), @"bkg": @"skin_cell2", @"r1": [Globals.i autoNumber:self.profileDict[@"kills_lost"]], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_kills_lost"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row108 = @{@"n1": NSLocalizedString(@"Battles Won", nil), @"bkg": @"skin_cell1", @"r1": [Globals.i autoNumber:self.profileDict[@"battles_won"]], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_battles_won"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row109 = @{@"n1": NSLocalizedString(@"Battles Lost", nil), @"bkg": @"skin_cell2", @"r1": [Globals.i autoNumber:self.profileDict[@"battles_lost"]], @"c1": @"-", @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row110 = @{@"n1": NSLocalizedString(@"Attacks Won", nil), @"bkg": @"skin_cell1", @"r1": [Globals.i autoNumber:self.profileDict[@"attacks_won"]], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_attacks_won"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row111 = @{@"n1": NSLocalizedString(@"Attacks Lost", nil), @"bkg": @"skin_cell2", @"r1": [Globals.i autoNumber:self.profileDict[@"attacks_lost"]], @"c1": @"-", @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row112 = @{@"n1": NSLocalizedString(@"Defenses Won", nil), @"bkg": @"skin_cell1", @"r1": [Globals.i autoNumber:self.profileDict[@"defenses_won"]], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_defenses_won"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row113 = @{@"n1": NSLocalizedString(@"Defenses Lost", nil), @"bkg": @"skin_cell2", @"r1": [Globals.i autoNumber:self.profileDict[@"defenses_lost"]], @"c1": @"-", @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row114 = @{@"n1": NSLocalizedString(@"Win/Loss Ratio", nil), @"bkg": @"skin_cell1", @"r1": [Globals.i autoNumber:self.profileDict[@"won_lost"]], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_won_lost"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row115 = @{@"n1": NSLocalizedString(@"Players Spied", nil), @"bkg": @"skin_cell2", @"r1": [Globals.i autoNumber:self.profileDict[@"players_scouted"]], @"c1": [Globals.i numberFormat:self.profileRank[@"rank_players_scouted"]], @"n1_width": @"130", @"n1_border": @"1", @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"nofooter": @"1"};

	NSArray *rows1 = @[row101, row102, row103, row104, row105, row106, row107, row108, row109, row110, row111, row112, row113, row114, row115];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
	
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

@end
