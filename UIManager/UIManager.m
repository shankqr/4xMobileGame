//
//  UIManager.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/9/09.
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

#import "UIManager.h"
#import "TemplateView.h"
#import "DynamicCell.h"
#import "DialogBoxView.h"

@interface UIManager () <TemplateDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerStack;
@property (nonatomic, strong) DialogBoxView *dialogBox;
@property (nonatomic, strong) TemplateView *templateView;
@property (nonatomic, strong) UIImageView *spinImageView;
@property (nonatomic, strong) UIImageView *spinReverseImageView;

@end

@implementation UIManager

static UIManager *_i;

- (id)init
{
    if (self = [super init])
    {
        if (self.viewControllerStack == nil)
        {
            self.viewControllerStack = [[NSMutableArray alloc] init];
        }
        
        self.tabViewTitle = @"";
        self.loading = 0;
    }
    
    return self;
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TabSelected"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"TabSelected"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSString *tab_title = [userInfo objectForKey:@"tab_title"];
            self.tabViewTitle = tab_title;
        }
    }
}

+ (UIManager *)i
{
    if (!_i)
    {
        _i = [[UIManager alloc] init];
    }
    
    return _i;
}

static dispatch_once_t once;
static NSOperationQueue *connectionQueue;
+ (NSOperationQueue *)connectionQueue
{
    dispatch_once(&once, ^{
        connectionQueue = [[NSOperationQueue alloc] init];
        [connectionQueue setMaxConcurrentOperationCount:1];
        [connectionQueue setName:@"com.tapy.connectionqueue"];
    });
    return connectionQueue;
}

- (NSMutableArray *)customParser:(NSData *)data
{
    NSMutableArray *sourceArray = [[NSMutableArray alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    sourceArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    for (NSDictionary *dict in sourceArray)
    {
        NSMutableDictionary *d1 = [[NSMutableDictionary alloc] init];
        
        [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
        {
            if (!obj)
            {
                [d1 setObject:@"" forKey:key];
            }
            else if (obj == [NSNull null])
            {
                [d1 setObject:@"" forKey:key];
            }
            else if ([obj isKindOfClass:[NSString class]])
            {
                [d1 setObject:obj forKey:key];
            }
            else
            {
                [d1 setObject:[obj stringValue] forKey:key];
            }
        }];
        
        [returnArray addObject:d1];
    }
    
    //NSLog(@"%@", returnArray);

    return returnArray;
}

- (void)showDialog:(NSString *)l1
{
    [self showDialog:l1 title:@""];
}

- (void)showDialog:(NSString *)l1 title:(NSString*)frameTitle
{
    self.dialogBox = [[DialogBoxView alloc] initWithStyle:UITableViewStylePlain];
    
    self.dialogBox.displayText = l1;
    self.dialogBox.dialogType = 1;
    self.dialogBox.dialogBlock = nil;
    [self.dialogBox updateView];
    
    [self showTemplate:@[self.dialogBox] :frameTitle :7];
}

- (void)showDialogBlock:(NSString *)l1 :(NSInteger)type :(DialogBlock)block
{
    [self showDialogBlock:l1 title:@"" type:type :block];
}

- (void)showDialogBlock:(NSString *)l1 title:(NSString*)frameTitle type:(NSInteger)type :(DialogBlock)block
{
    self.dialogBox = [[DialogBoxView alloc] initWithStyle:UITableViewStylePlain];
    
    self.dialogBox.displayText = l1;
    self.dialogBox.dialogType = type;
    self.dialogBox.dialogBlock = block;
    [self.dialogBox updateView];
    
    [self showTemplate:@[self.dialogBox] :frameTitle :7];
}

- (void)showDialogBlockRow:(NSMutableArray *)rows title:(NSString*)frameTitle type:(NSInteger)frameType :(DialogBlock)block
{
    //NSLog(@"showDialogBlock Type : %ld",(long)frameType);
    self.dialogBox = [[DialogBoxView alloc] initWithStyle:UITableViewStylePlain];
    
    self.dialogBox.rows = rows;
    self.dialogBox.dialogType = -1;
    self.dialogBox.dialogBlock = block;
    [self.dialogBox updateView];
    
    [self showTemplate:@[self.dialogBox] :frameTitle :frameType];
}

- (void)flushViewControllerStack
{
    if (self.viewControllerStack == nil)
    {
        self.viewControllerStack = [[NSMutableArray alloc] init];
    }
    
    [self.viewControllerStack removeAllObjects];
}

- (void)pushViewControllerStack:(UIViewController *)view
{
    if (self.viewControllerStack == nil)
    {
        self.viewControllerStack = [[NSMutableArray alloc] init];
    }
    
    if (view != nil)
    {
        [self.viewControllerStack addObject:view];
    }
}

- (UIViewController *)popViewControllerStack
{
    UIViewController *view = nil;
    
    if ([self.viewControllerStack count] != 0)
    {
        view = [self.viewControllerStack lastObject];
        [self.viewControllerStack removeLastObject];
    }
    
    return view;
}

- (UIViewController *)peekViewControllerStack
{
    UIViewController *view = nil;
    
    if ([self.viewControllerStack count] != 0)
    {
        view = [self.viewControllerStack lastObject];
    }
    
    return view;
}

- (UIViewController *)firstViewControllerStack
{
    UIViewController *view = nil;
    
    if ([self.viewControllerStack count] != 0)
    {
        view = [self.viewControllerStack firstObject];
    }
    
    return view;
}

- (BOOL)isCurrentView:(UIViewController *)view
{
    return ([self peekViewControllerStack] == view);
}

- (NSString *)currentViewTitle
{
    NSString *title = [self peekViewControllerStack].title;
    
    //NSLog(@"currentViewTitle: %@", title);
    
    return title;
}

- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title
{
    [self showTemplate:viewControllers :title :4 :0 :nil];
}

- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType
{
    [self showTemplate:viewControllers :title :frameType :0 :nil];
}

- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType :(NSInteger)selectedIndex
{
    [self showTemplate:viewControllers :title :frameType :selectedIndex :nil];
}

- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType :(NSInteger)selectedIndex :(NSArray *)headerView
{
    //NSLog(@"SHOWING TEMPLATE");
    self.templateView = [[TemplateView alloc] init];
    self.templateView.delegate = self;
    self.templateView.viewControllers = viewControllers;
    self.templateView.title = title;
    self.templateView.frameType = frameType;
    self.templateView.selectedIndex = selectedIndex;
    self.templateView.headerView = headerView;
    [self.templateView updateView];
    
    NSInteger prev_frameType = 0;
    
    if ([[self peekViewControllerStack] isKindOfClass:[TemplateView class]])
    {
        prev_frameType = [(TemplateView *)self.peekViewControllerStack frameType];
        //NSLog(@"prev_frameType : %ld",(long)prev_frameType);
        //NSLog(@"prev_frame title : %@",(TemplateView *)self.peekViewControllerStack.title);
    }
    
    //NSLog(@"FrameType : %ld",(long)self.templateView.frameType);
    //NSLog(@"SelectedIndex : %ld",(long)selectedIndex);
    //NSLog(@"Title : %@",title);
    //NSLog(@"viewControllers count: %lu",(unsigned long)viewControllers.count);
    //NSLog(@"headerView count : %lu",(unsigned long)headerView.count);
    if (prev_frameType == FRAME_TableFit || prev_frameType == FRAME_TableFitNoCloseButton) //Always on top
    {
        //Sorting
        //NSLog(@"self.peekViewControllerStack.view : %@",self.peekViewControllerStack.view);
        [[self firstViewControllerStack].view insertSubview:self.templateView.view belowSubview:self.peekViewControllerStack.view];
        
        TemplateView *temp = (TemplateView *)self.popViewControllerStack;
        
        [self pushViewControllerStack:self.templateView];
        
        [self pushViewControllerStack:temp];
    }
    else
    {
        [[self firstViewControllerStack].view addSubview:self.templateView.view];
        [self pushViewControllerStack:self.templateView];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:title forKey:@"title"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTemplateComplete"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)setTemplateBadgeNumber:(NSUInteger)tabIndex number:(NSUInteger)number
{
    if (([self peekViewControllerStack] != nil) && ([self.viewControllerStack count] > 1))
    {
        if ([[self peekViewControllerStack] isKindOfClass:[TemplateView class]])
        {
            [(TemplateView *)[self peekViewControllerStack] setBadgeNumber:tabIndex number:number];
        }
    }
}

- (void)closeTemplate
{
    if (([self peekViewControllerStack] != nil) && ([self.viewControllerStack count] > 1))
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:[self currentViewTitle] forKey:@"view_title"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseTemplateBefore"
                                                            object:self
                                                          userInfo:userInfo];
        
        if ([[self peekViewControllerStack] isKindOfClass:[TemplateView class]])
        {
            [(TemplateView *)[self peekViewControllerStack] cleanView];
        }
        
        [[self peekViewControllerStack].view removeFromSuperview];
        
        [self popViewControllerStack];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"CloseTemplateComplete"
         object:self];
    }
}

- (void)setTemplateFrameType:(NSInteger)frame_type
{
    if (([self peekViewControllerStack] != nil) && ([self.viewControllerStack count] > 1))
    {
        if ([[self peekViewControllerStack] isKindOfClass:[TemplateView class]])
        {
            ((TemplateView *)[self peekViewControllerStack]).frameType = frame_type;
            [(TemplateView *)[self peekViewControllerStack] updateView];
        }
    }
}

- (void)closeAllTemplate
{
    while ([self.viewControllerStack count] > 1) //Close all accept MainView
    {
        [self closeTemplate];
    }
}

- (BOOL)mh_tabBarController:(TemplateView *)tabBarController shouldSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    //NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %lu", tabBarController.title, viewController.title, (unsigned long)index);
    
    return YES;
}

- (void)mh_tabBarController:(TemplateView *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
    //NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %lu", tabBarController.title, viewController.title, (unsigned long)index);
    NSString *noti = [NSString stringWithFormat:@"Tab%@", viewController.title];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:noti
     object:self];
}

- (UIImage *)colorImage:(NSString *)imageName :(UIColor *)color
{
    UIImage *img = [self imageNamedCustom:imageName];
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

- (UIImage *)dynamicImage:(CGRect)frame prefix:(NSString *)prefix
{
    NSInteger frame_width = frame.size.width;
    NSInteger frame_height = frame.size.height;
    
    if (!(iPad)) //Double up
    {
        frame_width = frame_width*2;
        frame_height = frame_height*2;
    }
    
    UIImage *img1 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_1", prefix]];
    UIImage *img2 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_2", prefix]];
    UIImage *img3 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_3", prefix]];
    
    UIImage *img4 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_4", prefix]];
    UIImage *img5 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_5", prefix]];
    UIImage *img6 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_6", prefix]];
    
    UIImage *img7 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_7", prefix]];
    UIImage *img8 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_8", prefix]];
    UIImage *img9 = [self imageNamedCustom:[NSString stringWithFormat:@"%@_9", prefix]];
    
    CGSize imgSize = CGSizeMake(frame_width, frame_height);
    UIGraphicsBeginImageContext(imgSize);
    
    if (!img4 || !img5 || !img6)
    {
        if (frame_width > (img1.size.width + img3.size.width))
        {
            [[img8 resizableImageWithCapInsets:UIEdgeInsetsZero
                                  resizingMode:UIImageResizingModeStretch]
             drawInRect:CGRectMake(img1.size.width, img1.size.height, frame_width - (img1.size.width + img3.size.width), frame_height - img1.size.height)];
        }
        
        [[img9 resizableImageWithCapInsets:UIEdgeInsetsZero
                              resizingMode:UIImageResizingModeStretch]
         drawInRect:CGRectMake(frame_width - img3.size.width, img3.size.height, img3.size.width, frame_height - img3.size.height)];
        
        [[img7 resizableImageWithCapInsets:UIEdgeInsetsZero
                              resizingMode:UIImageResizingModeStretch]
         drawInRect:CGRectMake(0.0f, img1.size.height, img1.size.width, frame_height - img1.size.height)];
    }
    else
    {
        if (frame_width > (img7.size.width + img9.size.width))
        {
            [[img8 resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]
             drawInRect:CGRectMake(img7.size.width, frame_height - img7.size.height, frame_width - (img7.size.width + img9.size.width), img7.size.height)];
        }
        [img9 drawInRect:CGRectMake(frame_width - img9.size.width, frame_height - img9.size.height, img9.size.width, img9.size.height)];
        [img7 drawInRect:CGRectMake(0.0f, frame_height - img7.size.height, img7.size.width, img7.size.height)];
        
        if (frame_height > (img1.size.height + img7.size.height))
        {
            if (frame_width > (img4.size.width + img6.size.width))
            {
                [[img5 resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]
                 drawInRect:CGRectMake(img4.size.width, img1.size.height, frame_width - (img4.size.width + img6.size.width), frame_height - img1.size.height - img7.size.height)];
            }
            
            [[img6 resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]
             drawInRect:CGRectMake(frame_width - img6.size.width, img3.size.height, img6.size.width, frame_height - img3.size.height - img9.size.height)];
            
            [[img4 resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]
             drawInRect:CGRectMake(0.0f, img1.size.height, img4.size.width, frame_height - img1.size.height - img7.size.height)];
        }
    }
    
    if (frame_width > (img1.size.width + img3.size.width))
    {
        [[img2 resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]
         drawInRect:CGRectMake(img1.size.width, 0.0f, frame_width - (img1.size.width + img3.size.width), img1.size.height)];
    }
    [img3 drawInRect:CGRectMake(frame_width - img3.size.width, 0.0f, img3.size.width, img3.size.height)];
    [img1 drawInRect:CGRectMake(0.0f, 0.0f, img1.size.width, img1.size.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIButton *)dynamicButtonWithTitle:(NSString *)title
                              target:(id)target
                            selector:(SEL)selector
                               frame:(CGRect)frame
                                type:(NSString *)type
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    frame.size.width = (int)floorf(frame.size.width);
    frame.size.height = (int)floorf(frame.size.height);
    
    if (frame.size.width > 140.0f*SCALE_IPAD)
    {
        button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:DEFAULT_FONT_SIZE];
    }
    else if (frame.size.width > 80.0f*SCALE_IPAD)
    {
        button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:9.0f*SCALE_IPAD];
    }
    else
    {
        button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:8.0f*SCALE_IPAD];
    }
    
    button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.numberOfLines = 0;
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    button.backgroundColor = [UIColor clearColor];
    
    if (![type isEqualToString:@"0"]) //Invisible button
    {
        UIImage *normalImage = [self dynamicImage:frame prefix:[NSString stringWithFormat:@"btn%@", type]];
        [button setBackgroundImage:normalImage forState:UIControlStateNormal];
        
        if ([type isEqualToString:@"1"]) //Disabled button
        {
            [button setBackgroundImage:normalImage forState:UIControlStateHighlighted];
        }
        else
        {
            UIImage *highlightImage = [self dynamicImage:frame prefix:[NSString stringWithFormat:@"btn%@_hvr", type]];
            [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
        }
    }
    
    return button;
}

- (UIButton *)buttonWithTitle:(NSString *)title
                       target:(id)target
                     selector:(SEL)selector
                        frame:(CGRect)frame
                  imageNormal:(UIImage *)imageNormal
             imageHighlighted:(UIImage *)imageHighlighted
                imageCentered:(BOOL)imageCentered
                darkTextColor:(BOOL)darkTextColor
{
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [button setTitle:title forState:UIControlStateNormal];
    if (darkTextColor)
    {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
    {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
    if (imageCentered)
    {
        button.imageView.contentMode = UIViewContentModeCenter;
    }
    
    UIImage *newImage = [imageNormal stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [button setImage:newImage forState:UIControlStateNormal];
    
    UIImage *newHighlightedImage = [imageHighlighted stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
    [button setImage:newHighlightedImage forState:UIControlStateHighlighted];
    
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    
    // in case the parent view draws with a custom color or gradient, use a transparent color
    button.backgroundColor = [UIColor clearColor];
    
    return button;
}

- (UIImage *)imageNamedCustom:(NSString *)image_name
{
    //return [UIImage imageNamed:image_name];
    
    //Only works with graphic pack id = 1
    NSString *fileName = [NSString stringWithFormat:@"/GraphicPack_1/%@.png", image_name];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath])
    {
        return [UIImage imageWithContentsOfFile:dataPath];
    }
    else
    {
        return [UIImage imageNamed:image_name];
    }
}

- (void)showLoadingAlert
{
    UIImage *spin_reverse_image = [self imageNamedCustom:@"loader_spin_reverse"];
    UIImage *scaled_spin_reverse_image = [UIImage imageWithCGImage:[spin_reverse_image CGImage]
                                                             scale:(spin_reverse_image.scale * 2.0)
                                                       orientation:(spin_reverse_image.imageOrientation)];
    
    UIImage *spin_image = [self imageNamedCustom:@"loader_spin"];
    UIImage *scaled_spin_image = [UIImage imageWithCGImage:[spin_image CGImage]
                                                     scale:(spin_image.scale * 2.0)
                                               orientation:(spin_image.imageOrientation)];
    
    if (self.spinReverseImageView == nil)
    {
        self.spinReverseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        self.spinReverseImageView.image = iPad? spin_reverse_image : scaled_spin_reverse_image;
        self.spinReverseImageView.userInteractionEnabled = YES;
        self.spinReverseImageView.contentMode = UIViewContentModeCenter;
        self.spinReverseImageView.animationDuration = 1.0;
    }
    
    if (self.spinImageView == nil)
    {
        self.spinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        self.spinImageView.image = iPad? spin_image : scaled_spin_image;
        self.spinImageView.userInteractionEnabled = YES;
        self.spinImageView.contentMode = UIViewContentModeCenter;
        self.spinImageView.animationDuration = 1.0;
    }
    
    [[self firstViewControllerStack].view addSubview:self.spinReverseImageView];
    [[self firstViewControllerStack].view addSubview:self.spinImageView];
    
    [self spinAnimateView:self.spinImageView duration:2.0 clockwise:YES];
    [self spinAnimateView:self.spinReverseImageView duration:2.0 clockwise:NO];
    
    self.loading = self.loading + 1;
}

- (void)spinAnimateView:(UIView*)view duration:(CGFloat)duration clockwise:(BOOL)clockwise
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithDouble: M_PI * 2 * (clockwise ? 1.0 : -1.0)];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = FLT_MAX;
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)removeLoadingAlert
{
    //NSLog(@"Removing Loading Alert");
    
    [self.spinImageView removeFromSuperview];
    [self.spinReverseImageView removeFromSuperview];
    
    self.loading = self.loading - 1;
    if (self.loading < 0)
    {
        self.loading = 0;
    }
}

- (void)showToast:(NSString *)message optionalTitle:(NSString *)title optionalImage:(NSString *)imagename
{
    //[self play_notification];
    
    NSMutableDictionary *dict_cell;
    
    if (title == nil)
    {
        title = NSLocalizedString(@"Success!", nil);
    }
    
    dict_cell = [@{@"r1": title, @"r2": message, @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"r2_color": @"2", @"nofooter": @"1"} mutableCopy];
    
    if (imagename != nil)
    {
        [dict_cell addEntriesFromDictionary:@{@"n1_width": @"60", @"i1": imagename, @"i1_aspect": @"1"}];
    }
    
    [JCNotificationCenter sharedCenter].presenter = [JCNotificationBannerPresenterSmokeStyle new];
    
    [JCNotificationCenter
     enqueueNotificationWithMessage:dict_cell
     animationType:@"1"
     tapHandler:^{}];
}

- (void)showIIS_error:(NSString *)str_html
{
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    [webView loadHTMLString:str_html baseURL:nil];
    
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view = webView;
    
    [self showTemplate:@[controller] :@"IIS Error"];
}

- (BOOL)is_loading
{
    //NSLog(@"is_loading : %d", (int)self.loading);
    
    if (self.loading > 0)
    {
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}

@end
