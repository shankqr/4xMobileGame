//
//  TroopView.h
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 11/18/14.
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
#import "UIManager.h"

@interface TroopView : DynamicTVC

@property (nonatomic, strong) NSString *building_name;
@property (nonatomic, strong) NSString *unit_type;
@property (nonatomic, strong) NSString *unit_tier;

@property (nonatomic, assign) NSInteger buildings_output;
@property (nonatomic, assign) NSInteger highest_buildings_level;
@property (nonatomic, assign) NSUInteger sel_value;

- (void)clearView;

@end
