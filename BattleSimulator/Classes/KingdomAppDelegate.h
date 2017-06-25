//
//  AppDelegate.h
//  Battle Simulator
//
//  Created by Shankar on 6/26/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

@class MainView;
@interface KingdomAppDelegate : UIResponder <UIApplicationDelegate> 

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MainView *mainView;

@property (nonatomic, assign) BOOL beenSleeping;

@end

