//
//  SlotsView.h
//  Liberty Bell
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 5/24/13.
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

#import "General.h"
#import "GameMechanics.h"

@interface SlotsView : UIViewController <GameMechanicsDelegate>
{
    GameMechanics *gameMechanics;
    NSDictionary *config;
    NSDictionary *texts;
    NSArray *combinations;
    NSArray *reels;
    NSArray *reelViews;
    NSArray *bulbs;
    NSMutableArray *currentSpinCounts;
    NSMutableArray *currentSpinResults;
    NSDictionary *animations;
    NSMutableArray *cards;
    NSMutableArray *currentCards;
    int itemWidth;
    int itemHeight;
    int rowCount;
    int currentlyRotating;
    int currentWins;
    int noOfSpins;
    int winResult;
    int rand1;
    int rand2;
    int rand3;
    
    BOOL keepSpinning;
    
    IBOutlet UIView* reel1;
    IBOutlet UIView* reel2;
    IBOutlet UIView* reel3;
    IBOutlet UIButton *armButton;
    IBOutlet UILabel *winsLabel;
    IBOutlet UILabel *coinsLabel;
    IBOutlet UILabel *creditsLabel;
    IBOutlet UILabel *winsTitleLabel;
    IBOutlet UILabel *winsTitleLabel2;
    IBOutlet UILabel *coinsTitleLabel;
    IBOutlet UIView *machineView;
    IBOutlet UIView *winsContainer;
    IBOutlet UIView *coinsContainer;
    IBOutlet UIView *armButtonContainer;
    IBOutlet UIImageView *backgroundImage;
    IBOutlet UIButton *addCoinButton;
    IBOutlet UIButton *addMaxCoinButton;
    IBOutlet UIButton *productsButton;
    IBOutlet UIView *betContainer;
    IBOutlet UIView *maxBetContainer;
    IBOutlet UILabel *creditsTitleLabel;
    IBOutlet UIView *payoutsContainer;
    IBOutlet UIButton *payoutsButton;
    IBOutlet UIButton *payoutsCloseButton;
    IBOutlet UILabel *payoutsLabel;
    IBOutlet UIImageView *vegasLights;
    IBOutlet UIImageView *bulbImage1;
    IBOutlet UIImageView *bulbImage2;
    IBOutlet UIImageView *bulbImage3;
    IBOutlet UIImageView *bulbImage4;
    IBOutlet UIImageView *bulbImage5;
    IBOutlet UIImageView *bulbImage6;
    IBOutlet UIImageView *bulbImage7;
    IBOutlet UIImageView *bulbImage8;
}
- (IBAction) armButtonTapped:(id)sender;
- (IBAction) addCoinButtonTapped:(id)sender;
- (IBAction) addMaxCoinButtonTapped:(id)sender;
- (IBAction) productsButtonTapped:(id)sender;
- (IBAction) payoutsCloseButtonTapped:(id)sender;
- (IBAction) payoutsButtonTapped:(id)sender;
@end
