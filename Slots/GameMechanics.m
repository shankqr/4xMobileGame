//
//  GameMechanics.m
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

#import "GameMechanics.h"

@implementation GameMechanics

@synthesize mainViewDelegate;

- (int) getCombination:(NSArray *)combination
{
    int ret = -1;
    
    NSArray *combinations = [mainViewDelegate.config objectForKey:@"combinations"];
    
    for (int i = 0; i < [combinations count]; i++)
    {
        NSArray *thisCombination = [[combinations objectAtIndex:i] objectForKey:@"combination"];
        
        BOOL match = YES;
        
        for (int j = 0; j < [combination count]; j++)
        {
            NSString *thisItem = [thisCombination objectAtIndex:j];
            NSString *inputItem = [combination objectAtIndex:j];
            
            if ((![thisItem isEqualToString:@"wildcard"]) && ![thisItem isEqualToString:inputItem])
            {
                match = NO;
                break;
            }
        }
        
        if (match)
        {
            ret = i;
            break;
        }
    }
    
    return ret;
}

- (int) getWins
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"wins"] intValue];
}

- (void) addWin:(int)win
{
    int currentWins = [self getWins];
    
    currentWins += win;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currentWins] forKey:@"wins"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (int) getCoinsUsed
{
    return currentCoins;
}

- (void) addCoinsUsed:(int)coins
{
    currentCoins += coins;
}

- (void) removeCoins
{
    currentCoins = 0;
}

- (int) getCredits
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:@"credits"] intValue];
}

- (void) setCredits:(int)credits
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:credits] forKey:@"credits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) addCredits:(int)credits
{
    int currentCredits = [self getCredits];
    
    currentCredits += credits;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currentCredits] forKey:@"credits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) decreaseCredits:(int)credits
{
    int currentCredits = [self getCredits];
    
    currentCredits -= credits;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currentCredits] forKey:@"credits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) increaseCredits:(int)credits
{
    int currentCredits = [self getCredits];
    
    currentCredits += credits;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:currentCredits] forKey:@"credits"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
