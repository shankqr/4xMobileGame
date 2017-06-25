//
//  4x MMO Mobile Strategy GameAppDelegate.h
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/26/09.
//  Copyright Shankar Nathan 2010. All rights reserved.
//

@class MainView;
@interface KingdomAppDelegate : UIResponder <UIApplicationDelegate> 

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MainView *mainView;

@property (nonatomic, assign) BOOL beenSleeping;

@end

