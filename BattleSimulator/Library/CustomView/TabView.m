//
//  TabView.m
//  Battle Simulator
//
//  Created by Shankar on 3/24/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "TabView.h"
#import "Globals.h"
#import "CustomBadge.h"

#define tabBarHeight (40.0f*SCALE_IPAD)

@interface TabView ()

@property (nonatomic, strong) UIView *tabButtonsContainerView;

@property (nonatomic, assign) NSUInteger selectedIndex;

@end

@implementation TabView

static const NSInteger TagOffset = 1000;

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tabStyle = YES;
}

- (void)cleanView
{
    [self.tabButtonsContainerView removeFromSuperview];
}

- (void)updateView
{
    CGRect rect = CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, tabBarHeight);

    self.view = [[UIView alloc] initWithFrame:rect];
    self.view.backgroundColor = [[UIColor alloc] initWithRed:0./255 green:0./255 blue:0./255 alpha:0.6];
    
    self.tabButtonsContainerView = [[UIView alloc] initWithFrame:rect];
    [self.tabButtonsContainerView setFrame:rect];
    self.tabButtonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tabButtonsContainerView];

	[self reloadTabButtons];
    
    [self layoutTabButtons];
}

- (void)reloadTabButtons
{
	[self removeTabButtons];
	[self addTabButtons];
    
	// Force redraw of the previously active tab.
	NSUInteger lastIndex = _selectedIndex;
	_selectedIndex = NSNotFound;
	self.selectedIndex = lastIndex;
}

- (void)removeTabButtons
{
	while ([self.tabButtonsContainerView.subviews count] > 0)
	{
		[[self.tabButtonsContainerView.subviews lastObject] removeFromSuperview];
	}
}

- (void)addTabButtons
{
	NSUInteger index = 0;
    
	for (NSString *tabTitle in self.tabArray)
	{
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.tag = TagOffset + index;
		button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
		button.titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        button.titleLabel.minimumScaleFactor = 0.5f;
        
		[button setTitle:tabTitle forState:UIControlStateNormal];
        
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, 5.0f*SCALE_IPAD, 0.0f, 5.0f*SCALE_IPAD)];
        
		[button addTarget:self action:@selector(tabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        CustomBadge *badge = [CustomBadge customBadgeWithString:@"0" withScale:SCALE_IPAD];
        
        [badge setFrame:CGRectMake(0, 0, badge.frame.size.width, badge.frame.size.height)];
        badge.hidden = YES;
        [button addSubview:badge];
        
		[self.tabButtonsContainerView addSubview:button];
        
		++index;
	}
}

- (void)setBadgeNumber:(NSUInteger)tabIndex number:(NSUInteger)number
{
    UIButton *tabButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + tabIndex];
    
    for (UIView *viewRef in tabButton.subviews)
    {
        if ([viewRef isKindOfClass:[CustomBadge class]])
        {
            CustomBadge *tabBadge = (CustomBadge *)viewRef;
            [tabBadge autoBadgeSizeWithString:[@(number) stringValue]];
            [tabBadge setFrame:CGRectMake(tabButton.frame.size.width-tabBadge.frame.size.width, 0, tabBadge.frame.size.width, tabBadge.frame.size.height)];
            tabBadge.hidden = NO;
            
            if (number == 0)
            {
                tabBadge.hidden = YES;
            }
        }
    }
}

- (void)layoutTabButtons
{
	NSUInteger index = 0;
	NSUInteger count = [self.tabArray count];
    
	CGRect rect = CGRectMake(0.0f, 0.0f, floorf(UIScreen.mainScreen.bounds.size.width / count), tabBarHeight);
    
	NSArray *buttons = [self.tabButtonsContainerView subviews];
	for (UIButton *button in buttons)
	{
		if (index == count - 1)
        {
			rect.size.width = UIScreen.mainScreen.bounds.size.width - rect.origin.x;
        }
        
		button.frame = rect;
		rect.origin.x += rect.size.width;
        
        [self deselectTabButton:button];
        
		if (index == self.selectedIndex)
        {
			[self selectTabButton:button];
        }
        
		++index;
	}
}

- (void)tabButtonPressed:(UIButton *)sender
{
    NSUInteger newSelectedIndex = sender.tag - TagOffset;
    
    if(_selectedIndex != newSelectedIndex)
    {
        [self setSelectedIndex:newSelectedIndex];

        NSString *title = sender.titleLabel.text;

        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:title forKey:@"tab_title"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabSelected"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)setSelectedIndex:(NSUInteger)newSelectedIndex
{
    if (_selectedIndex != NSNotFound)
    {
        UIButton *fromButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
        [self deselectTabButton:fromButton];
    }

    _selectedIndex = newSelectedIndex;
    
    UIButton *toButton;
    if (_selectedIndex != NSNotFound)
    {
        toButton = (UIButton *)[self.tabButtonsContainerView viewWithTag:TagOffset + _selectedIndex];
        [self selectTabButton:toButton];
    }
}

#pragma mark - Change these methods to customize the look of the buttons

- (void)selectTabButton:(UIButton *)button
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
	UIImage *image_h = [[Globals i] dynamicImage:button.frame prefix:@"tab1_hvr"];
    
    if (!self.tabStyle)
    {
        image_h = [[Globals i] dynamicImage:button.frame prefix:@"tab2_hvr"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
	[button setBackgroundImage:image_h forState:UIControlStateNormal];
	[button setBackgroundImage:image_h forState:UIControlStateHighlighted];
}

- (void)deselectTabButton:(UIButton *)button
{
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
	UIImage *image_h = [[Globals i] dynamicImage:button.frame prefix:@"tab1_hvr"];
    UIImage *image_n = [[Globals i] dynamicImage:button.frame prefix:@"tab1"];
    
    if (!self.tabStyle)
    {
        image_h = [[Globals i] dynamicImage:button.frame prefix:@"tab2_hvr"];
        image_n = [[Globals i] dynamicImage:button.frame prefix:@"tab2"];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
	[button setBackgroundImage:image_n forState:UIControlStateNormal];
	[button setBackgroundImage:image_h forState:UIControlStateHighlighted];
}

@end
