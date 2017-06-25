//
//  TabView.h
//  Battle Simulator
//
//  Created by Shankar on 3/24/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

@interface TabView : UIViewController

@property (nonatomic, strong) NSArray *tabArray;

@property (nonatomic, assign) BOOL tabStyle;

- (void)cleanView;
- (void)updateView;
- (void)setBadgeNumber:(NSUInteger)tabIndex number:(NSUInteger)number;

@end
