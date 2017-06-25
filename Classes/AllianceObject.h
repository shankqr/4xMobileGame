//
//  AllianceObject.h
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

@interface AllianceObject : NSObject <NSCopying>

@property (nonatomic, strong) NSString *alliance_id;
@property (nonatomic, strong) NSString *leader_id;
@property (nonatomic, strong) NSString *leader_name;
@property (nonatomic, strong) NSString *alliance_name;
@property (nonatomic, strong) NSString *alliance_tag;
@property (nonatomic, strong) NSString *alliance_logo;
@property (nonatomic, strong) NSString *alliance_language;
@property (nonatomic, strong) NSString *alliance_marquee;
@property (nonatomic, strong) NSString *alliance_description;
@property (nonatomic, strong) NSString *alliance_level;
@property (nonatomic, strong) NSString *alliance_currency_first;
@property (nonatomic, strong) NSString *alliance_currency_second;
@property (nonatomic, strong) NSString *alliance_created;

@property (nonatomic, strong) NSString *total_members;
@property (nonatomic, strong) NSString *power;
@property (nonatomic, strong) NSString *kills;

- (id)initWithDictionary:(NSDictionary *)aDictionary;

@end
