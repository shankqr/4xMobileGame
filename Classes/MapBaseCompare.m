//
//  MapBaseCompare.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 18/01/2016.
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

#import "MapBaseCompare.h"

@implementation MapBaseCompare

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    if (self)
    {
        self.dictionary = [[NSDictionary alloc] initWithDictionary:dict copyItems:YES];
    }
    
    return self;
}

- (BOOL)isEqual:(MapBaseCompare *)object
{
    return [self.dictionary[@"base_id"] isEqual: object.dictionary[@"base_id"]];
}

- (NSUInteger)hash
{
    return 0;//[self.dictionary[@"base_id"] unsignedIntegerValue];
}

- (NSString *)description
{
    return [self.dictionary description];
}

@end
