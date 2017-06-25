//
//  SlotsView.m
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

#import "SlotsView.h"
#import "Globals.h"
#import "Audio.h"

@implementation SlotsView
@synthesize config;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIManager.i showLoadingAlert];
    
    [self initializeVariables];
    [self initializeReels];
    [self initializeViews];
    [self initializeFonts];
    
    [self updateBalanceCredits];
    
    [self refreshWins:[NSNumber numberWithBool:NO]];
    [self refreshCoins:[NSNumber numberWithBool:NO]];
    
    [self initializeBeforeAnimationPosition];
    
    float delay = [[[config objectForKey:@"variables"] objectForKey:@"initialDelay"] floatValue];
    
    [self performSelector:@selector(initializeStartingAnimation) withObject:nil afterDelay:delay];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeader"
                                               object:nil];
    
    [UIManager.i removeLoadingAlert];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"UpdateHeader"])
    {
        //Update balance credits
        [self updateBalanceCredits];
    }
}

- (void)updateBalanceCredits
{
    int diamonds_balance = [Globals.i.wsWorldProfileDict[@"currency_second"] intValue];
    [gameMechanics setCredits:diamonds_balance];
    [self refreshCredits:[NSNumber numberWithBool:NO]];
}

- (void)initializeBeforeAnimationPosition
{
    CGRect frame;
    
    [payoutsContainer setAlpha:0.0];
    
    float y = 70.0*SCALE_IPAD;
    
    for (NSDictionary *temp in combinations)
    {
        NSArray *thisCombination = [temp objectForKey:@"combination"];
        int win = [[temp objectForKey:@"win"] intValue];
        float x = 40.0*SCALE_IPAD;
        
        for (NSString *str in thisCombination)
        {
            UIImageView *image = [[UIImageView alloc] initWithImage:
                                  [Globals.i imageNamedCustom:[NSString stringWithFormat:@"%@", str]]];
            
            [image setFrame:CGRectMake(x, y, 50*SCALE_IPAD, 70*SCALE_IPAD)];
            
            x += image.frame.size.width + 10.0*SCALE_IPAD;
            
            [payoutsContainer addSubview:image];
        }
        
        x += 40.0*SCALE_IPAD;
        
        UILabel *thisLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50*SCALE_IPAD, 70*SCALE_IPAD)];
        
        [thisLabel setBackgroundColor:[UIColor clearColor]];
        [thisLabel setTextColor:[UIColor whiteColor]];
        [thisLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:32.0*SCALE_IPAD]];
        
        thisLabel.text = [NSString stringWithFormat:@"%ix", win];
        
        [payoutsContainer addSubview:thisLabel];
        
        y += thisLabel.frame.size.height - 20.0*SCALE_IPAD;
    }
    
    frame = productsButton.frame;
    frame.origin.x += frame.size.width;
    [productsButton setFrame:frame];
    
    frame = payoutsButton.frame;
    frame.origin.x += frame.size.width;
    [payoutsButton setFrame:frame];
    
    frame = machineView.frame;
    frame.origin.x += frame.size.width;
    [machineView setFrame:frame];
    
    [armButtonContainer setAlpha:0.0];
    [betContainer setAlpha:0.0];
    [maxBetContainer setAlpha:0.0];
    
    [backgroundImage setAlpha:0.0];
}

- (void)initializeStartingAnimation
{
    [[Audio i] playFxWhoosh];
    
    [UIView animateWithDuration:[[animations objectForKey:@"machineSlideTime"] floatValue]
        delay:0.0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
            [backgroundImage setAlpha:1.0];
            
            CGRect frame = machineView.frame;
            frame.origin.x -= frame.size.width;
            [machineView setFrame:frame];            
        }
        completion:^(BOOL finished){
            [[Audio i] playFxSlide];
            
            [UIView animateWithDuration:[[animations objectForKey:@"headerSlideTime"] floatValue]
                delay:0.0
                options:UIViewAnimationOptionCurveEaseOut
                animations:^{

                }
                completion:^(BOOL finished){
                    
                    [[Audio i] playFxSlide];
                    
                    [UIView animateWithDuration:[[animations objectForKey:@"sideButtonsSlideTime"] floatValue]
                        delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            CGRect frame;
                            
                            frame = productsButton.frame;
                            frame.origin.x -= frame.size.width;
                            [productsButton setFrame:frame];
                            
                            frame = payoutsButton.frame;
                            frame.origin.x -= frame.size.width;
                            [payoutsButton setFrame:frame];
                        }
                        completion:^(BOOL finished){
                            
                            float duration = [[animations objectForKey:@"footerFadeTime"] floatValue];
                            float delay = [[animations objectForKey:@"footerFadeDelay"] floatValue];
                            
                            [[Audio i] performSelector:@selector(playFxPop) withObject:nil afterDelay:0];
                            [[Audio i] performSelector:@selector(playFxPop) withObject:nil afterDelay:delay];
                            [[Audio i] performSelector:@selector(playFxPop) withObject:nil afterDelay:(2 * delay)];
                            
                            [UIView animateWithDuration:duration
                                delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                                animations:^{
                                    [betContainer setAlpha:1.0];
                                }
                                completion:^(BOOL finished){
                                }
                             ];
                            [UIView animateWithDuration:duration
                                delay:delay
                                options:UIViewAnimationOptionCurveEaseOut
                                animations:^{
                                    [maxBetContainer setAlpha:1.0];
                                }
                                completion:^(BOOL finished){
                                }
                             ];
                            [UIView animateWithDuration:duration
                                delay:(2 * delay)
                                options:UIViewAnimationOptionCurveEaseOut
                                animations:^{
                                    [armButtonContainer setAlpha:1.0];
                                }
                                completion:^(BOOL finished){
                                    //[self activateHelp];
                                }
                             ];
                        }
                     ];
                }
             ];
        }
     ];
}

- (void)initializeFonts
{
    [winsTitleLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:winsTitleLabel.font.pointSize]];
    [winsTitleLabel2 setFont:[UIFont fontWithName:DEFAULT_FONT size:winsTitleLabel2.font.pointSize]];
    [coinsTitleLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:coinsTitleLabel.font.pointSize]];
    [creditsTitleLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:creditsTitleLabel.font.pointSize]];
    [payoutsLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:payoutsLabel.font.pointSize]];
    
    [coinsLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:coinsLabel.font.pointSize]];
    [winsLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:winsLabel.font.pointSize]];
    [creditsLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:creditsLabel.font.pointSize]];
}

- (void)initializeViews
{
    [vegasLights setAlpha:0.0];
}

- (void)initializeVariables
{
    config = [General readConfig];
    
    rand1 = 0;
    
    reels = [config objectForKey:@"reels"];
    combinations = [config objectForKey:@"combinations"];
    animations = [config objectForKey:@"animations"];
    
    texts = [config objectForKey:@"texts"];
    
    rowCount = [[config objectForKey:@"rowCount"] intValue];
    
    itemWidth = [[config objectForKey:@"itemWidth"] intValue] * SCALE_IPAD;
    itemHeight = [[config objectForKey:@"itemHeight"] intValue] * SCALE_IPAD;
    
    gameMechanics = [[GameMechanics alloc] init];
    gameMechanics.mainViewDelegate = self;
    
    reelViews = [NSArray arrayWithObjects:reel1, reel2, reel3, nil];
    
    currentSpinCounts = [NSMutableArray arrayWithCapacity:3];
    currentSpinResults = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < [reels count]; i++)
    {
        [currentSpinCounts insertObject:[NSNumber numberWithInt:0] atIndex:i];
        [currentSpinResults insertObject:[NSNumber numberWithInt:0] atIndex:i];
    }
    
    bulbs = [NSArray arrayWithObjects:bulbImage1, bulbImage2, bulbImage3, bulbImage4, bulbImage5, bulbImage6, bulbImage7, bulbImage8, nil];
    
    for (UIImageView *temp in bulbs)
    {
        [temp setAlpha:0.0];
    }
    
    currentWins = 0;
}

- (void)initializeReels
{
    cards = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < [reels count]; i++)
    {
        UIView *currentReel = [reelViews objectAtIndex:i];
        
        currentCards = [NSMutableArray arrayWithCapacity:(rowCount + 2)];
        
        for (int j = 0; j < [[reels objectAtIndex:i] count] + 2; j++)
        {
            int rowToUse = j % [[reels objectAtIndex:i] count];
            
            UIImageView *currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, j * itemHeight, itemWidth, itemHeight)];
            
            NSString *currentItem = [[reels objectAtIndex:i] objectAtIndex:rowToUse];
            
            [currentImage setImage:[Globals.i imageNamedCustom:[NSString stringWithFormat:@"%@", currentItem]]];
            
            [currentReel addSubview:currentImage];
            [currentCards addObject:currentImage];
        }
        
        int rand = arc4random() % rowCount;
        CGRect frame = currentReel.frame;
        
        frame.origin.y = -rand * itemHeight;
        
        [currentReel setFrame:frame];
        
        [cards insertObject:currentCards atIndex:i];
    }
}

- (void)resetReels
{
    cards = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < [reels count]; i++)
    {
        UIView *currentReel = [reelViews objectAtIndex:i];
        
        [currentReel.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        currentCards = [NSMutableArray arrayWithCapacity:(rowCount + 2)];
        
        for (int j = 0; j < [[reels objectAtIndex:i] count] + 2; j++)
        {
            int rowToUse = j % [[reels objectAtIndex:i] count];
            
            UIImageView *currentImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, j * itemHeight, itemWidth, itemHeight)];
            
            NSString *currentItem = [[reels objectAtIndex:i] objectAtIndex:rowToUse];
            
            [currentImage setImage:[Globals.i imageNamedCustom:[NSString stringWithFormat:@"%@", currentItem]]];
            
            [currentReel addSubview:currentImage];
            [currentCards addObject:currentImage];
        }
        
        int rand = arc4random() % rowCount;
        CGRect frame = currentReel.frame;
        
        frame.origin.y = -rand * itemHeight;
        
        [currentReel setFrame:frame];
        
        [cards insertObject:currentCards atIndex:i];
    }
}

- (IBAction)armButtonTapped:(id)sender
{
    noOfSpins++;
    currentWins = 0;
    
    [self refreshWins:[NSNumber numberWithBool:NO]];
    
    int currentCredits = [gameMechanics getCredits];
    
    int singleBetValue = [[[config objectForKey:@"variables"] objectForKey:@"singleBetValue"] intValue];
    
    if (currentCredits < singleBetValue)
    {
        [self productsButtonTapped:self];
        
        return;
    }
    
    float delay = [[[config objectForKey:@"variables"] objectForKey:@"reelRotationDelay"] floatValue];
    
    [self showHideButtons:NO];
    
    if ([gameMechanics getCoinsUsed] == 0)
    {
        [gameMechanics addCoinsUsed:singleBetValue];
        
        [[Audio i] playFxInsertCoin];
        
        [self refreshCoins:[NSNumber numberWithBool:YES]];
    }
    
    int creditsDropped = [gameMechanics getCoinsUsed];
    
    [gameMechanics decreaseCredits:creditsDropped];
    
    [self refreshCredits:[NSNumber numberWithBool:YES]];
    
    [[Audio i] performSelector:@selector(playFxArmPulled) withObject:nil afterDelay:0.0];
    
    [self performSelector:@selector(rollAllReels) withObject:nil afterDelay:delay];
    
    if (noOfSpins == 10)
    {
        noOfSpins = 0;
    }
}

- (void)rollAllReels
{
    NSString *service_name = @"DoSlot";
    
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%i",
                       Globals.i.UID, [gameMechanics getCoinsUsed]];
    
    [Globals.i getServer:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             if([result isEqualToString:@"1"])
             {
                 // Do nothing coz diamonds earned back
             }
             else if([result isEqualToString:@"2"])
             {
                 int diamonds_balance = [Globals.i.wsWorldProfileDict[@"currency_second"] intValue] + [gameMechanics getCoinsUsed]*1;
                 
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(diamonds_balance) stringValue];
             }
             else if([result isEqualToString:@"3"])
             {
                 int diamonds_balance = [Globals.i.wsWorldProfileDict[@"currency_second"] intValue] + [gameMechanics getCoinsUsed]*2;
                 
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(diamonds_balance) stringValue];
             }
             else if([result isEqualToString:@"4"])
             {
                 int diamonds_balance = [Globals.i.wsWorldProfileDict[@"currency_second"] intValue] + [gameMechanics getCoinsUsed]*3;
                 
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(diamonds_balance) stringValue];
             }
             else if([result isEqualToString:@"6"])
             {
                 int diamonds_balance = [Globals.i.wsWorldProfileDict[@"currency_second"] intValue] + [gameMechanics getCoinsUsed]*5;
                 
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(diamonds_balance) stringValue];
             }
             else if([result isEqualToString:@"8"])
             {
                 int diamonds_balance = [Globals.i.wsWorldProfileDict[@"currency_second"] intValue] + [gameMechanics getCoinsUsed]*7;
                 
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(diamonds_balance) stringValue];
             }
             else if([result isEqualToString:@"10"])
             {
                 int diamonds_balance = [Globals.i.wsWorldProfileDict[@"currency_second"] intValue] + [gameMechanics getCoinsUsed]*9;
                 
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(diamonds_balance) stringValue];
             }
             else
             {
                 result = @"0";
                 
                 // - Diamonds used to clubData
                 int diamonds_balance = [Globals.i.wsWorldProfileDict[@"currency_second"] intValue] - [gameMechanics getCoinsUsed];
                 Globals.i.wsWorldProfileDict[@"currency_second"] = [@(diamonds_balance) stringValue];
             }
             
             [Globals.i updateProfilePower:5];
             
             [self stopRoll:result];
         }
         else
         {
             [self stopOnError];
             [UIManager.i showDialog:NSLocalizedString(@"Oops! there was a network problem. Please try again. No diamonds have been awarded or deducted.", nil) title:@""];
         }
     }];
    
    [[Audio i] playFxReelClick];
    
    keepSpinning = YES;
    
    for (int i = 0; i < [reelViews count]; i++)
    {
        [self performSelectorInBackground:@selector(rollOneReelForever:) withObject:[NSNumber numberWithInt:i]];
    }
    
    [self resetReels];
}

- (void)rollOneReelForever:(NSNumber *)reel
{
    UIView *thisReel = [reelViews objectAtIndex:[reel intValue]];
    
    while(keepSpinning)
    {
        float duration = .1f;
        
        int currentY = thisReel.frame.origin.y;
        int newY = currentY - itemHeight;
        
        NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:newY], thisReel, [NSNumber numberWithFloat:duration], nil] forKeys:[NSArray arrayWithObjects:@"newY", @"view", @"duration", nil]];
        
        [self performSelectorOnMainThread:@selector(setNewY:) withObject:params waitUntilDone:NO];
        
        [NSThread sleepForTimeInterval:duration];
    }
}

- (void)stopOnError
{
    keepSpinning = NO;
    [[Audio i] stopFxReelClick];
    [[Audio i] playFxReelStop];
    [self showHideButtons:YES];
    
    //Increase credits used
    [gameMechanics increaseCredits:[gameMechanics getCoinsUsed]];
    [self refreshCredits:[NSNumber numberWithBool:YES]];
}

- (void)stopRoll:(NSString *)result
{
    currentlyRotating = 0;
    
    keepSpinning = NO;
    
    for (int i = 0; i < [reelViews count]; i++)
    {
        int min = [[[[config objectForKey:@"spins"] objectAtIndex:i] objectForKey:@"min"] intValue];
        int max = [[[[config objectForKey:@"spins"] objectAtIndex:i] objectForKey:@"max"] intValue];
        int rand = (arc4random() % (max - min + 1)) + min;
        
        [currentSpinCounts replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:rand]];
        
        winResult = [result intValue];
        
        if (winResult == 10)
        {
            [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:1]];
        }
        else if (winResult == 8)
        {
            [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:2]];
        }
        else if (winResult == 6)
        {
            [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:3]];
        }
        else if (winResult == 4)
        {
            [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:4]];
        }
        else if (winResult == 3)
        {
            if (i < 2)
            {
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:5]];
            }
            else
            {
                int rand = arc4random() % 5;
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:rand+1]];
            }
        }
        else if (winResult == 2)
        {
            if (i == 0)
            {
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:5]];
            }
            else if (i == 1)
            {
                int rand = arc4random() % 4;
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:rand+1]];
            }
            else if (i == 2)
            {
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:5]];
            }
        }
        else if (winResult == 1)
        {
            if (i > 0)
            {
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:5]];
            }
            else
            {
                int rand = arc4random() % 4;
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:rand+1]];
            }
        }
        else
        {
            if (rand1 == 0)
            {
                rand1 = arc4random() % 5 + 1;

                //Make sure no 2 clovers in a row
                if (rand1 == 5)
                {
                    rand2 = arc4random() % 4 + 1;
                    rand3 = arc4random() % 4 + 1;
                }
                else
                {
                    rand2 = arc4random() % 5 + 1;
                    rand3 = arc4random() % 5 + 1;
                    
                    //Make sure no 3 in a row
                    if ((rand1 == rand2) && (rand1 == rand3))
                    {
                        rand1 = 5;
                    }
                    else if ((rand2 == 5) && (rand3 == 5)) //Make sure no 2 clovers in a row
                    {
                        rand2 = arc4random() % 4 + 1;
                    }
                }
                
                //Make sure no 3 in a row
                if ((rand1 == rand2) && (rand1 == rand3))
                {
                    rand1 = 5;
                }
            }
            
            if (i == 0)
            {
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:rand1]];
            }
            else if (i == 1)
            {
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:rand2]];
            }
            else if (i == 2)
            {
                [currentSpinResults replaceObjectAtIndex:i withObject:[NSNumber numberWithInt:rand3]];
                
                //reset random generator
                rand1 = 0;
            }
        }
    }
    
    currentCards = [NSMutableArray arrayWithCapacity:3];
    
    for (int i = 0; i < [reelViews count]; i++)
    {
        [self setFutureImage:i];
        [self performSelectorInBackground:@selector(rollOneReel:) withObject:[NSNumber numberWithInt:i]];
    }
}

- (void)setFutureImage:(int)reel
{
    UIView *thisReel = [reelViews objectAtIndex:reel];
    int S = [[currentSpinCounts objectAtIndex:reel] intValue]; // number of spins
    int final_type = [[currentSpinResults objectAtIndex:reel] intValue];
    
    //Set in advance the end image
    int currentY = thisReel.frame.origin.y;
    int currentPos = abs((currentY / itemHeight) % rowCount);
    if (currentPos == 0)
    {
        currentPos = rowCount;
    }
    
    int position = (currentPos + S) % rowCount;
    if (position == 0)
    {
        position = rowCount;
    }
    
    UIImageView *currentImage = [[cards objectAtIndex:reel] objectAtIndex:position];

    if (final_type == 1)
    {
        [currentImage setImage:[Globals.i imageNamedCustom:@"seven"]];
    }
    else if (final_type == 2)
    {
        [currentImage setImage:[Globals.i imageNamedCustom:@"bell"]];
    }
    else if (final_type == 3)
    {
        [currentImage setImage:[Globals.i imageNamedCustom:@"grapes"]];
    }
    else if (final_type == 4)
    {
        [currentImage setImage:[Globals.i imageNamedCustom:@"lemon"]];
    }
    else if (final_type == 5)
    {
        [currentImage setImage:[Globals.i imageNamedCustom:@"luck"]];
    }
    
    NSLog(@"Reel[%d] curPos:%d position:%d result:%d", reel, currentPos, position, final_type);
    
    [currentCards addObject:currentImage];
}

- (void)rollOneReel:(NSNumber *)reel
{
    currentlyRotating++;
    
    UIView *thisReel = [reelViews objectAtIndex:[reel intValue]];
    
    int spinCount = 0;
    float duration = [[animations objectForKey:[NSString stringWithFormat:@"spinTime%i", [reel intValue] + 1] ] floatValue];
    
    int S = [[currentSpinCounts objectAtIndex:[reel intValue]] intValue]; // number of spins
    float A = duration / S; // average spin time
    float C = [[animations objectForKey:@"spinSpeedDiversityPercentage"] floatValue]; // maximum deviation
    
    float a = (2 * A * C) / (S - 1);
    float b = A  - A * C - (2 * A * C / (S - 1));
    
    while (spinCount < S)
    {
        spinCount++;
        duration = a * spinCount + b;
        int currentY = thisReel.frame.origin.y;
        int newY = currentY - itemHeight;
        
        NSDictionary *params = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:newY], thisReel, [NSNumber numberWithFloat:duration], nil] forKeys:[NSArray arrayWithObjects:@"newY", @"view", @"duration", nil]];
        [self performSelectorOnMainThread:@selector(setNewY:) withObject:params waitUntilDone:NO];
        
        [NSThread sleepForTimeInterval:duration];
    }
    
    [[Audio i] playFxReelStop];
    currentlyRotating--;
    if (currentlyRotating == 0)
    {
        [[Audio i] stopFxReelClick];
        [self performSelectorOnMainThread:@selector(calculateWin) withObject:nil waitUntilDone:NO];
    }
}

- (void)setNewY:(NSDictionary *)params;
{
    float newY = [[params objectForKey:@"newY"] intValue];
    float duration = [[params objectForKey:@"duration"] floatValue];
    UIView *view = [params objectForKey:@"view"];
    CGRect frame;
    
    if (-newY >= (rowCount + 1) * itemHeight)
    {
        frame = view.frame;
        
        frame.origin.y += rowCount * itemHeight;
        
        [view setFrame:frame];
        
        newY += rowCount * itemHeight;
    }
    
    frame = view.frame;
    
    frame.origin.y = newY;
    
    [UIView animateWithDuration:duration
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         [view setFrame:frame];
                     }
                     completion:^(BOOL finished){
                     }
     ];
}

- (void)calculateWin
{
    BOOL isWin = NO;

    if (winResult != 0)
    {
        int win = winResult * [gameMechanics getCoinsUsed];
        
        if (winResult == 10)
        {
            float delay = [[[config objectForKey:@"variables"] objectForKey:@"jackpotDelay"] floatValue];
            
            //[[Audio i] playFxCheers];
            
            [[Audio i] performSelector:@selector(playFxJackpot) withObject:nil afterDelay:delay];
            
            [self performSelectorInBackground:@selector(bulbShow:) withObject:[NSNumber numberWithInt:96]];
        }
        else
        {
            [[Audio i] playFxWinningCombination];
            
            [self performSelectorInBackground:@selector(bulbShow:) withObject:[NSNumber numberWithInt:32]];
        }
        
        [self performSelectorInBackground:@selector(addWinVisually:) withObject:[NSNumber numberWithInt:win]];
        
        isWin = YES;
    }
    
    [gameMechanics removeCoins];
    
    [self refreshCoins:[NSNumber numberWithBool:NO]];
    
    if (!isWin)
    {
        [self performSelectorOnMainThread:@selector(checkForCredits) withObject:nil waitUntilDone:NO];
    }
    
    [self showHideButtons:YES];
}

- (void)flashBulb:(NSNumber *)index
{
    UIImageView *img = (UIImageView *)[bulbs objectAtIndex:[index intValue]];
    float duration = [[[config objectForKey:@"variables"] objectForKey:@"bulbFadeTime"] floatValue];
    
    [UIView animateWithDuration:duration
        delay:0.0
        options:UIViewAnimationOptionCurveEaseIn
        animations:^{
            [img setAlpha:1.0];
            [vegasLights setAlpha:1.0];
        }
        completion:^(BOOL finished){
            [UIView animateWithDuration:duration
                delay:0.0
                options:UIViewAnimationOptionCurveEaseOut
                animations:^{
                    [img setAlpha:0.0];
                    [vegasLights setAlpha:0.0];
                }
                completion:^(BOOL finished){
                }
            ];
        }
     ];
}

- (void)bulbShow:(NSNumber *)count
{
    int total = [count intValue];
    int counter = -1;
    float duration = [[[config objectForKey:@"variables"] objectForKey:@"bulbFadeTime"] floatValue];
    
    for (int i = 0; i < total; i++)
    {
        counter++;
        
        if (counter >= 8)
        {
            counter = 0;
        }
        
        [self performSelectorOnMainThread:@selector(flashBulb:) withObject:[NSNumber numberWithInt:counter] waitUntilDone:NO];
        
        [NSThread sleepForTimeInterval:(2 * duration)];
    }
}

- (void)showHideButtons:(BOOL)show
{
    float duration = [[animations objectForKey:@"buttonFadeTime"] floatValue];
    
    if (!show)
    {
        [UIView animateWithDuration:duration
            delay:0.0
            options:UIViewAnimationOptionCurveEaseIn
            animations:^{
                [armButton setAlpha:0.0];
                [addCoinButton setAlpha:0.0];
                [addMaxCoinButton setAlpha:0.0];
            }
            completion:^(BOOL finished){

            }
         ];
    }
    else
    {
        [UIView animateWithDuration:duration
            delay:0.0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                [armButton setAlpha:1.0];
                [addCoinButton setAlpha:1.0];
                [addMaxCoinButton setAlpha:1.0];
            }
            completion:^(BOOL finished){

            }
         ];
    }
}

- (void)flashWinningCards
{
    for (int i = 0; i < [currentCards count]; i++)
    {
        UIImageView *temp = [currentCards objectAtIndex:i];
        
        float delay = [[animations objectForKey:@"cardFlashDelay"] floatValue];
        
        [self performSelector:@selector(flashCard:) withObject:temp afterDelay:(i * delay)];
    }
}

- (void)addWinVisually:(NSNumber *)win
{
    float initialDelay = [[[config objectForKey:@"variables"] objectForKey:@"coinDropInitialDelay"] floatValue];
    float cardsDelay = [[animations objectForKey:@"delayAfterFlashingCards"] floatValue];
    
    [NSThread sleepForTimeInterval:initialDelay];
    
    [self performSelectorOnMainThread:@selector(flashWinningCards) withObject:nil waitUntilDone:NO];
    
    [NSThread sleepForTimeInterval:cardsDelay];
    
    int currentWin = [win intValue];
    float delay = [[[config objectForKey:@"variables"] objectForKey:@"coinDropDelay"] floatValue];
    
    for (int i = 0; i < currentWin; i += 5)
    {
        int toAdd = 5;
        
        currentWins += toAdd;
        
        if (currentWins > currentWin)
        {
            toAdd -= currentWins - currentWin;
            
            currentWins = currentWin;
        }
        
        [gameMechanics addWin:toAdd];
        [gameMechanics increaseCredits:toAdd];
        
        [[Audio i] playFxCoinDropping];
        
        [self performSelectorOnMainThread:@selector(refreshWins:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
        [self performSelectorOnMainThread:@selector(refreshCredits:) withObject:[NSNumber numberWithBool:YES] waitUntilDone:NO];
        
        [NSThread sleepForTimeInterval:delay];
    }
}

- (void)refreshCoins:(NSNumber *)animated
{
    int coins = [gameMechanics getCoinsUsed];
    
    [coinsLabel setText:[NSString stringWithFormat:@"%i", coins]];
    
    if ([animated boolValue])
    {
        [self flashLabel:coinsLabel];
    }
}

- (void)refreshCredits:(NSNumber *)animated
{
    int credits = [gameMechanics getCredits];
    [creditsLabel setText:[NSString stringWithFormat:@"%i", credits]];
    
    if ([animated boolValue])
    {
        [self flashLabel:creditsLabel];
    }
}

- (void)flashLabel:(UILabel *)label
{
    UILabel *duplicateLabel = [[UILabel alloc] initWithFrame:label.frame];
    
    duplicateLabel.text = label.text;
    duplicateLabel.textColor = [UIColor whiteColor];
    duplicateLabel.font = label.font;
    duplicateLabel.backgroundColor = [UIColor clearColor];
    duplicateLabel.textAlignment = label.textAlignment;
    
    [label.superview addSubview:duplicateLabel];
    
    float duration = [[animations objectForKey:@"numberHighlightTime"] floatValue];
    float scale = [[animations objectForKey:@"numberHighlightScale"] floatValue];
    
    [UIView animateWithDuration:duration
        delay:0.0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
            [duplicateLabel setTransform:CGAffineTransformScale(duplicateLabel.transform, scale, scale)];
            [duplicateLabel setAlpha:0.0];
        }
        completion:^(BOOL finished){
            [duplicateLabel removeFromSuperview];
        }
     ];
}

- (void)flashCard:(UIImageView *)image
{
    UIImageView *duplicateImage = [[UIImageView alloc] initWithFrame:image.frame];
    
    duplicateImage.backgroundColor = [UIColor clearColor];
    [duplicateImage setImage:image.image];
    
    [image.superview.superview.superview addSubview:duplicateImage];
    
    CGRect frame = duplicateImage.frame;
    
    frame.origin.x += image.superview.frame.origin.x + image.superview.superview.frame.origin.x;
    frame.origin.y = image.superview.superview.frame.origin.y;
    
    [duplicateImage setFrame:frame];
    
    float duration = [[animations objectForKey:@"imageHighlightTime"] floatValue];
    float scale = [[animations objectForKey:@"imageHighlightScale"] floatValue];
    
    [[Audio i] playFxAppear];
    
    [UIView animateWithDuration:duration
        delay:0.0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
            [duplicateImage setTransform:CGAffineTransformScale(duplicateImage.transform, scale, scale)];
            [duplicateImage setAlpha:0.0];
        }
        completion:^(BOOL finished){
        [duplicateImage removeFromSuperview];
        }
     ];
}

- (void)refreshWins:(NSNumber *)animated
{
    [winsLabel setText:[NSString stringWithFormat:@"%i", currentWins]];
    
    if ([animated boolValue])
    {
        [self performSelectorOnMainThread:@selector(flashLabel:) withObject:winsLabel waitUntilDone:NO];
    }
}

- (void)checkForCredits
{
    if ([gameMechanics getCredits] == 0)
    {
        [self productsButtonTapped:self];
    }
}

- (IBAction)addCoinButtonTapped:(id)sender
{
    int maxBetValue = [[[config objectForKey:@"variables"] objectForKey:@"maxBetValue"] intValue];
    int singleBetValue = [[[config objectForKey:@"variables"] objectForKey:@"singleBetValue"] intValue];
    
    int currentCredits = [gameMechanics getCredits];
    int currentCoins = [gameMechanics getCoinsUsed];
    
    if ((currentCoins < maxBetValue) && (currentCoins + singleBetValue <= currentCredits))
    {
        [gameMechanics addCoinsUsed:singleBetValue];
        
        [[Audio i] playFxInsertCoin];
        
        [self refreshCoins:[NSNumber numberWithBool:YES]];
    }
    else
    {
        [gameMechanics removeCoins];
        [gameMechanics addCoinsUsed:singleBetValue];
        
        [[Audio i] playFxInsertCoin];
        
        [self refreshCoins:[NSNumber numberWithBool:YES]];
    }
}

- (IBAction)addMaxCoinButtonTapped:(id)sender
{
    int maxBetValue = [[[config objectForKey:@"variables"] objectForKey:@"maxBetValue"] intValue];
    int currentCredits = [gameMechanics getCredits];
    if (currentCredits >= maxBetValue)
    {
        [gameMechanics removeCoins];
        [gameMechanics addCoinsUsed:maxBetValue];
        
        [[Audio i] playFxInsertCoin];
        
        [self refreshCoins:[NSNumber numberWithBool:YES]];
    }
    else
    {
        [self productsButtonTapped:self];
    }
}

- (void)showHidePayouts:(BOOL)show
{
    float duration = [[animations objectForKey:@"payoutsFadeTime"] floatValue];
    
    if (show)
    {
        [[Audio i] playFxWhoosh];
        
        [UIView animateWithDuration:duration
            delay:0.0
            options:UIViewAnimationOptionCurveEaseIn
            animations:^{
                [payoutsContainer setAlpha:1.0];
            }
            completion:^(BOOL finished){
            }
         ];
    }
    else
    {
        [[Audio i] playFxWhoosh];
        
        [UIView animateWithDuration:duration
            delay:0.0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                [payoutsContainer setAlpha:0.0];
            }
            completion:^(BOOL finished){
            }
         ];
    }
}

- (IBAction)payoutsCloseButtonTapped:(id)sender
{
    [self showHidePayouts:NO];
}

- (IBAction)productsButtonTapped:(id)sender
{
    [[Audio i] playFxWhoosh];

    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ShowBuy"
     object:self];
}

- (IBAction)payoutsButtonTapped:(id)sender
{
    [self showHidePayouts:YES];
}

@end
