//
//  TemplateView.h
//  Battle Simulator
//
//  Created by Shankar on 3/24/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

@protocol TemplateDelegate;

@interface TemplateView : UIViewController

@property (nonatomic, copy) NSArray *headerView;
@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, assign) NSUInteger frameType;

@property (nonatomic, weak) id <TemplateDelegate> delegate;

- (void)cleanView;
- (void)updateView;
- (void)setBadgeNumber:(NSUInteger)tabIndex number:(NSUInteger)number;
- (void)closeButton_tap:(id)sender;

@end

@protocol TemplateDelegate <NSObject>
@optional
- (BOOL)mh_tabBarController:(TemplateView *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
- (void)mh_tabBarController:(TemplateView *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index;
@end

