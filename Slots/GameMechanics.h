//
//  GameMechanics.h
//  Liberty Bell
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 5/25/13.
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

@protocol GameMechanicsDelegate <NSObject>

@property (nonatomic, retain) NSDictionary *config;

@end

@interface GameMechanics : NSObject
{
    id <GameMechanicsDelegate> mainViewDelegate;
    int currentCoins;
}

- (int) getCombination:(NSArray *)combination;
- (int) getWins;
- (void) addWin:(int)win;
- (int) getCoinsUsed;
- (void) addCoinsUsed:(int)coins;
- (void) removeCoins;
- (void) setCredits:(int)credits;
- (void) addCredits:(int)credits;
- (int) getCredits;
- (void) decreaseCredits:(int)credits;
- (void) increaseCredits:(int)credits;

@property (nonatomic, retain) id <GameMechanicsDelegate> mainViewDelegate;

@end
