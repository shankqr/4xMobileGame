//
//  AllianceObject.m
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

#import "AllianceObject.h"

@implementation AllianceObject

- (id)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
	if (self)
	{
        self.alliance_id = [aDictionary valueForKey:@"alliance_id"];
        self.leader_id = [aDictionary valueForKey:@"leader_id"];
        self.leader_name = [aDictionary valueForKey:@"leader_name"];
		self.alliance_name = [aDictionary valueForKey:@"alliance_name"];
        self.alliance_tag = [aDictionary valueForKey:@"alliance_tag"];
        self.alliance_logo = [aDictionary valueForKey:@"alliance_logo"];
        self.alliance_language = [aDictionary valueForKey:@"alliance_language"];
        self.alliance_marquee = [aDictionary valueForKey:@"alliance_marquee"];
        self.alliance_description = [aDictionary valueForKey:@"alliance_description"];
        self.alliance_level = [aDictionary valueForKey:@"alliance_level"];
        self.alliance_currency_first = [aDictionary valueForKey:@"alliance_currency_first"];
        self.alliance_currency_second = [aDictionary valueForKey:@"alliance_currency_second"];
        self.alliance_created = [aDictionary valueForKey:@"alliance_created"];
        
		self.total_members = [aDictionary valueForKey:@"total_members"];
        self.power = [aDictionary valueForKey:@"power"];
        self.kills = [aDictionary valueForKey:@"kills"];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	AllianceObject *selfs = [[AllianceObject allocWithZone: zone] init];
    
    selfs.alliance_id = [self.alliance_id copy];
    selfs.leader_id = [self.leader_id copy];
    selfs.leader_name = [self.leader_name copy];
    selfs.alliance_name = [self.alliance_name copy];
    selfs.alliance_tag = [self.alliance_tag copy];
    selfs.alliance_logo = [self.alliance_logo copy];
    selfs.alliance_language = [self.alliance_language copy];
    selfs.alliance_marquee = [self.alliance_marquee copy];
    selfs.alliance_description = [self.alliance_description copy];
    selfs.alliance_level = [self.alliance_level copy];
    selfs.alliance_currency_first = [self.alliance_currency_first copy];
    selfs.alliance_currency_second = [self.alliance_currency_second copy];
    selfs.alliance_created = [self.alliance_created copy];
    
    selfs.total_members = [self.total_members copy];
    selfs.power = [self.power copy];
    selfs.kills = [self.kills copy];
    
	return selfs;
}

@end
