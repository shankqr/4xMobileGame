//
//  SalesView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 2/9/14.
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

#import "SalesView.h"
#import "Globals.h"

@interface SalesView ()

@property (nonatomic, strong) UIImageView *ivBackground;
@property (nonatomic, strong) UILabel *lblDiamonds;
@property (nonatomic, strong) UILabel *lblEnding;

@property (nonatomic, strong) UILabel *lblBundle1;
@property (nonatomic, strong) UILabel *lblBundle2;
@property (nonatomic, strong) UILabel *lblBundle3;
@property (nonatomic, strong) UILabel *lblBundle4;
@property (nonatomic, strong) UILabel *lblPrice;
@property (nonatomic, strong) UILabel *lblMore;

@property (nonatomic, strong) NSTimer *gameTimer;

@property (nonatomic, assign) NSTimeInterval b1s;

@end

@implementation SalesView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self updateView];
}

- (void)updateView
{
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    NSDictionary *wsData = Globals.i.wsSalesDict;
	
    if (wsData != nil)
    {
        self.lblDiamonds.text = wsData[@"sale_row3"];
        self.lblMore.text = wsData[@"sale_row4"];
        self.lblPrice.text = wsData[@"sale_price"];
        self.lblBundle1.text = wsData[@"bundle1_quantity"];
        self.lblBundle2.text = wsData[@"bundle2_quantity"];
        self.lblBundle3.text = wsData[@"bundle3_quantity"];
        self.lblBundle4.text = wsData[@"bundle4_quantity"];
        
        //Update time left in seconds for sale to end
        NSTimeInterval serverTimeInterval = [Globals.i updateTime];
        NSString *strDate = wsData[@"sale_ending"];
        
        NSDate *saleEndDate = [Globals.i dateParser:strDate];
        NSTimeInterval saleEndTime = [saleEndDate timeIntervalSince1970];
        self.b1s = saleEndTime - serverTimeInterval;
        
        if (!self.gameTimer.isValid)
        {
            self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)onTimer
{
    if ([[UIManager.i currentViewTitle] isEqualToString:self.title])
    {
        self.b1s = self.b1s-1;
        NSString *labelString = [Globals.i getCountdownString:self.b1s];
        self.lblEnding.text = labelString;
    }
}

- (void)buy_tap:(id)sender
{
    [Globals.i play_gold];
    
    [Globals.i settPurchasedProduct:@"1000"];
    
    NSString *pi = [Globals.i wsIdentifierDict][Globals.i.wsSalesDict[@"sale_identifier"]];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:pi forKey:@"pi"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"InAppPurchase"
                                                        object:self
                                                      userInfo:userInfo];
}

@end
