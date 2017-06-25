//
//  Globals.m
//  Battle Simulator
//
//  Created by Shankar on 6/9/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "Globals.h"
#import "TemplateView.h"
#import "JCNotificationCenter.h"
#import "JCNotificationBannerPresenterSmokeStyle.h"

@interface Globals () <TemplateDelegate>

@property (nonatomic, strong) NSMutableArray *viewControllerStack;
@property (nonatomic, strong) DialogBoxView *dialogBox;
@property (nonatomic, strong) TemplateView *templateView;
@property (nonatomic, strong) NSDate *timerStartDate;

@end

@implementation Globals

static Globals *_i;

- (id)init
{
	if (self = [super init])
	{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        self.session = [NSURLSession sessionWithConfiguration:configuration];
        
        self.workingUrl = @"0";
        self.serverTimeInterval = 0;
        self.startServerTimeInterval = 0;
        self.offsetServerTimeInterval = 0;
        
        self.wsWorldProfileDict = [@{@"profile_id": @"1", @"alliance_id": @"1"} mutableCopy];
        
        if (!self.gameTimer.isValid)
        {
            self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
        }
        
        //UNIT TYPES
        self.a1 = @"Spearmen";
        self.a2 = @"Swordsmen";
        self.a3 = @"Axe Fighters";
        self.b1 = @"Archers";
        self.b2 = @"Longbowmen";
        self.b3 = @"Marksmen";
        self.c1 = @"Light Cavalry";
        self.c2 = @"Mounted Archer";
        self.c3 = @"Heavy Cavalry";
        self.d1 = @"Ballista";
        self.d2 = @"Battering Ram";
        self.d3 = @"Catapult";
        
        //RESOURCES TYPES
        self.r1 = @"Food";
        self.r2 = @"Wood";
        self.r3 = @"Stone";
        self.r4 = @"Ore";
        self.r5 = @"Gold";
        
	}
	return self;
}

- (void)doAttack:(NSDictionary *)targetBaseDict
{
    
}

+ (Globals *)i
{
	if (!_i)
	{
		_i = [[Globals alloc] init];
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

//Used for mail and report dont show loading and dont track
- (void)getServer:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       [Globals i].world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSLog(@"getServer:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
        if (error || !response || !data)
        {
            NSLog(@"Error posting to %@: %@ %@", wsurl, error, [error localizedDescription]);
            completionBlock(NO, nil);
        }
        else
        {
            completionBlock(YES, data);
        }
    });
    }] resume];
}

- (void)getMainServerLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       WS_URL, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSLog(@"getMainServerLoading:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];
          if (error || !response || !data)
          {
              [[Globals i] trackEvent:@"WS Failed" action:service_name label:param];
              
              completionBlock(NO, nil);
              dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
          }
          else
          {
              completionBlock(YES, data);
          }
      });
      }] resume];
}

- (void)getServerLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       [Globals i].world_url, service_name, param];

    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSLog(@"getServerLoading:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];
          if (error || !response || !data)
          {
              [[Globals i] trackEvent:@"WS Failed" action:service_name label:param];
              
              completionBlock(NO, nil);
              dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
          }
          else
          {
              completionBlock(YES, data);
          }
      });
      }] resume];
}

- (void)getSpLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       [Globals i].world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    NSLog(@"getSpLoading:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[Globals i] removeLoadingAlert];

        if (error || !response || !data)
        {
            [[Globals i] trackEvent:@"WS Failed" action:service_name label:param];
            
            completionBlock(NO, nil);
            dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
        }
        else
        {
            [[Globals i] trackEvent:service_name];
            
            NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if ([returnValue isEqualToString:@"1"]) //Stored Proc Success
            {
                completionBlock(YES, data);
            }
            else if ([returnValue isEqualToString:@"-1"]) //Stored Proc Failed
            {
                [[Globals i] showDialogFail];
                [[Globals i] trackEvent:@"SP Failed" action:service_name label:[Globals i].wsWorldProfileDict[@"uid"]];
            }
            else //Web Service Return 0
            {
                if (returnValue != nil)
                {
                    if (DEBUG)
                    {
                        [[Globals i] showIIS_error:returnValue];
                    }
                    else
                    {
                        [[Globals i] showDialogFail];
                    }
                    [[Globals i] trackEvent:returnValue action:service_name label:[Globals i].wsWorldProfileDict[@"uid"]];
                }
                else
                {
                    [[Globals i] showDialogError];
                    [[Globals i] trackEvent:@"WS Return 0" action:service_name label:[Globals i].wsWorldProfileDict[@"uid"]];
                }
            }
        }
    });
    }] resume];
}

- (void)showIIS_error:(NSString *)str_html
{
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    
    [webView loadHTMLString:str_html baseURL:nil];
    
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view = webView;
    
    [[Globals i] showTemplate:@[controller] :@"IIS Error"];
}

- (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *postLength = [@([postData length]) stringValue];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    NSString *url = [NSString stringWithFormat:@"%@/%@", [Globals i].world_url, service];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];
    
    [[self.session dataTaskWithRequest:request
                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];});
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", service, error, [error localizedDescription]);
             completionBlock(NO, nil);
             dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showDialogError];});
         }
         else
         {
             completionBlock(YES, data);
         }
     }] resume];
}

- (NSString	*)GameId
{
	return @"1";
}

- (NSString	*)UID
{
    self.uid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserUID"];
    
    return self.uid;
}

- (NSString	*)world_url
{
    NSString *wurl = nil;
    
    if (self.wsProfileDict != nil)
    {
        wurl = [NSString stringWithFormat:@"http://%@/%@", self.wsProfileDict[@"server_ip"], self.wsProfileDict[@"server_webservice"]];
    }
    
    wurl = [NSString stringWithFormat:@"http://%@/%@", @"yourdomain.com", @"kingdom_world0"];
    
    return wurl;
}

- (void)setUID:(NSString *)user_uid
{
    self.uid = user_uid;
    [[NSUserDefaults standardUserDefaults] setObject:self.uid forKey:@"UserUID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (![user_uid isEqualToString:@""])
    {
        //Helpshift id
        //[Helpshift setUserIdentifier:user_uid];
    }
}

- (NSTimeInterval)updateTime
{
    if (self.serverTimeInterval < 1)
    {
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/CurrentTime", WS_URL];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        NSString *returnValue  = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        returnValue = [NSString stringWithFormat:@"%@ -0000", returnValue];
        
        NSDate *serverDateTime = [[self getDateFormat] dateFromString:returnValue];
        self.serverTimeInterval = [serverDateTime timeIntervalSince1970];
        
        self.startServerTimeInterval = [serverDateTime timeIntervalSince1970];
        self.timerStartDate = [[NSDate alloc] init];
        
        NSTimeInterval localTimeInterval = [self.timerStartDate timeIntervalSince1970];
        self.offsetServerTimeInterval = self.serverTimeInterval - localTimeInterval;
    }
    
    NSLog(@"ServerInterval:%@ start(local):%@ offset:%@",
          [@(self.serverTimeInterval) stringValue],
          [@(self.startServerTimeInterval) stringValue],
          [@(self.offsetServerTimeInterval) stringValue]);

    return self.serverTimeInterval;
}

- (NSString *)getServerTimeString
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormater setDateFormat:@"HH:mm:ss"];
    
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:self.offsetServerTimeInterval];
    
    return [dateFormater stringFromDate:serverdatetime];
}

- (NSString *)getServerDateTimeString
{
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:self.offsetServerTimeInterval];
    
    NSString *datenow = [[self getDateFormat] stringFromDate:serverdatetime];
    return datenow;
}

- (NSDateFormatter *)getDateFormat
{
    if (self.dateFormat == nil)
    {
        self.dateFormat = [[NSDateFormatter alloc] init];
        [self.dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [self.dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [self.dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss Z"];
    }
    
    return self.dateFormat;
}

- (NSString *)getTimeAgo:(NSString *)datetimestring
{
    NSString *diff = datetimestring;
    
    if (datetimestring != nil && [datetimestring length] > 0)
    {
        NSDate *date1 = [[self getDateFormat] dateFromString:[NSString stringWithFormat:@"%@ -0000", datetimestring]];
        if (date1 == nil)
        {
            date1 = [[self getDateFormat] dateFromString:datetimestring];
        }
        
        NSDate *date2 = [NSDate date];
        
        if (self.offsetServerTimeInterval != 0) //Calibrate if local time is adjusted
        {
            date2 = [date2 dateByAddingTimeInterval:self.offsetServerTimeInterval];
        }
        
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        
        // Get conversion to months, days, hours, minutes
        NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitSecond;
        
        NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1 toDate:date2 options:0];
        
        if ([breakdownInfo month] > 0)
        {
            if ([breakdownInfo month] == 1)
            {
                diff = @"1 month ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ months ago", @([breakdownInfo month])];
            }
        }
        else if ([breakdownInfo day] > 0)
        {
            if ([breakdownInfo day] == 1)
            {
                diff = @"1 day ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ days ago", @([breakdownInfo day])];
            }
        }
        else if ([breakdownInfo hour] > 0)
        {
            if ([breakdownInfo hour] == 1)
            {
                diff = @"1 hour ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ hours ago", @([breakdownInfo hour])];
            }
        }
        else if ([breakdownInfo minute] > 0)
        {
            if ([breakdownInfo minute] == 1)
            {
                diff = @"1 min ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ mins ago", @([breakdownInfo minute])];
            }
        }
        else if ([breakdownInfo second] > 0)
        {
            if ([breakdownInfo second] == 1)
            {
                diff = @"1 sec ago";
            }
            else
            {
                diff = [NSString stringWithFormat:@"%@ secs ago", @([breakdownInfo second])];
            }
        }
        else
        {
            diff = @"1 sec ago";
        }
    }
    
    return diff;
}

- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label
{

}

- (void)trackEvent:(NSString *)category action:(NSString *)action
{

}

- (void)trackEvent:(NSString *)category
{

}

- (void)showLoadingAlert
{
    NSArray *imageNames = @[@"loader_1.png", @"loader_2.png", @"loader_3.png", @"loader_4.png", @"loader_5.png",
                            @"loader_6.png", @"loader_7.png", @"loader_8.png", @"loader_9.png", @"loader_10.png",
                            @"loader_11.png", @"loader_12.png"];
    
    CGFloat l_width = 0.0;
    CGFloat l_height = 0.0;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++)
    {
        UIImage *l_image = [UIImage imageNamed:[imageNames objectAtIndex:i]];
        l_width = l_image.size.width/2.0f * SCALE_IPAD;
        l_height = l_image.size.height/2.0f * SCALE_IPAD;
        
        if (!(iPad))
        {
            CGSize scaleSize = CGSizeMake(l_width, l_height);
            UIGraphicsBeginImageContextWithOptions(scaleSize, NO, 0.0);
            [l_image drawInRect:CGRectMake(0, 0, scaleSize.width, scaleSize.height)];
            l_image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        [images addObject:l_image];
    }
    
    if (self.spinImageView == nil)
    {
        self.spinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        self.spinImageView.animationImages = images;
        self.spinImageView.userInteractionEnabled = YES;
        self.spinImageView.contentMode = UIViewContentModeCenter;
        self.spinImageView.animationDuration = 1.0;
    }
    
    [[self firstViewControllerStack].view addSubview:self.spinImageView];
    [self.spinImageView startAnimating];
}

- (void)removeLoadingAlert
{
    [self.spinImageView removeFromSuperview];
}

- (void)showToast:(NSString *)message optionalTitle:(NSString *)title optionalImage:(NSString *)imagename
{
    NSMutableDictionary *dict_cell;
    
    if (title == nil)
    {
        title = @"Success!";
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

- (void)showDialog:(NSString *)l1
{
    self.dialogBox = [[DialogBoxView alloc] initWithStyle:UITableViewStylePlain];
    
    self.dialogBox.displayText = l1;
    self.dialogBox.dialogType = 1;
    self.dialogBox.dialogBlock = nil;
    [self.dialogBox updateView];
    
    [self showTemplate:@[self.dialogBox] :@"" :7];
}

- (void)showDialogError
{
    [self showDialog:@"Sorry, there was an internet connection issue or your session has timed out. Please retry."];
}

- (void)showDialogFail
{
    [self showDialog:@"Sorry, the action you took failed. Please try again, if persist please contact " SUPPORT_EMAIL];
}

- (void)showDialogBlock:(NSString *)l1 :(NSInteger)type :(DialogBlock)block
{
    self.dialogBox = [[DialogBoxView alloc] initWithStyle:UITableViewStylePlain];

    self.dialogBox.displayText = l1;
    self.dialogBox.dialogType = type;
    self.dialogBox.dialogBlock = block;
    [self.dialogBox updateView];
    
    [self showTemplate:@[self.dialogBox] :@"" :7];
}

- (void)showDialogBlock:(NSMutableArray *)rows type:(NSInteger)frameType :(DialogBlock)block
{
    self.dialogBox = [[DialogBoxView alloc] initWithStyle:UITableViewStylePlain];
    
    self.dialogBox.rows = rows;
    self.dialogBox.dialogBlock = block;
    [self.dialogBox updateView];
    
    [self showTemplate:@[self.dialogBox] :@"" :frameType];
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
    
    return title;
}

- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title
{
    [self showTemplate:viewControllers :title :0 :0 :nil]; //hacked to set frameType to 0 intead of 4
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
    self.templateView = [[TemplateView alloc] init];
    self.templateView.delegate = self;
	self.templateView.viewControllers = viewControllers;
    self.templateView.title = title;
    self.templateView.frameType = frameType;
    self.templateView.selectedIndex = selectedIndex;
    self.templateView.headerView = headerView;
    [self.templateView updateView];
    
    NSInteger prev_frameType = 0;
    
    if([[self peekViewControllerStack] isKindOfClass:[TemplateView class]])
    {
        prev_frameType = [(TemplateView *)self.peekViewControllerStack frameType];
    }
    
    if (prev_frameType == 6 || prev_frameType == 7) //Always on top
    {
        //Sorting
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
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %lu", tabBarController.title, viewController.title, (unsigned long)index);
    
	return YES;
}

- (void)mh_tabBarController:(TemplateView *)tabBarController didSelectViewController:(UIViewController *)viewController atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %lu", tabBarController.title, viewController.title, (unsigned long)index);
    
    if ([viewController.title isEqualToString:@"World Chat"])
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TabChatWorld"
         object:self];
    }
    
    if ([viewController.title isEqualToString:@"Alliance Chat"])
    {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"TabChatAlliance"
         object:self];
    }
}

- (UIImage *)colorImage:(NSString *)imageName :(UIColor *)color
{
    UIImage *img = [UIImage imageNamed:imageName];
    
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
    
    UIImage *img1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_1.png", prefix]];
    UIImage *img2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_2.png", prefix]];
    UIImage *img3 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_3.png", prefix]];
    
    UIImage *img4 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_4.png", prefix]];
    UIImage *img5 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_5.png", prefix]];
    UIImage *img6 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_6.png", prefix]];
    
    UIImage *img7 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_7.png", prefix]];
    UIImage *img8 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_8.png", prefix]];
    UIImage *img9 = [UIImage imageNamed:[NSString stringWithFormat:@"%@_9.png", prefix]];
    
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
        button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:MEDIUM_FONT_SIZE];
    }
    else if (frame.size.width > 80.0f*SCALE_IPAD)
    {
        button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
    }
    else
    {
        button.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:10.0f*SCALE_IPAD];
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

- (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (NSString *)stringToHex:(NSString *)str
{
    NSUInteger len = [str length];
    unichar *chars = malloc(len * sizeof(unichar));
    [str getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for (NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%x", chars[i]]];
    }
    free(chars);
    
    return hexString;
}

- (double)Random_next:(double)min to:(double)max
{
    return ((double)arc4random() / UINT_MAX) * (max-min) + min;
}

- (NSString *)numberString:(NSNumber *)val
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedOutput = [formatter stringFromNumber:val];
    
    return formattedOutput;
}

- (NSString *)intString:(NSInteger)val
{
    NSNumber *number = @(val);

    return [self numberString:number];
}

- (NSString *)floatString:(double)val
{
    NSInteger rounded = lround(val);

    return [self intString:rounded];
}

- (NSString *)floatNumber:(NSString *)val
{
    double dval = [val doubleValue];
    
    return [self floatString:dval];
}

- (NSString *)autoNumber:(NSString *)val
{
    double dval = [val doubleValue];
    
    if (dval > 999999)
    {
        return [self shortNumber:val];
    }
    else
    {
        return [self floatString:dval];
    }
}

- (NSString *)numberFormat:(NSString *)val
{
    NSString *formattedOutput = @"";
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    if (val != nil)
    {
        NSNumber *number = [formatter numberFromString:val];
        formattedOutput = [formatter stringFromNumber:number];
    }
    
    return formattedOutput;
}

- (NSString *)shortNumber:(NSString *)val
{
    double dval = [val doubleValue];
    
    return [self shortNumberDouble:dval];
}

- (NSString *)shortNumberDouble:(double)dval
{
    NSString *shortformNumber = @"1k";
    
    if (dval > 999)
    {
        if (dval > 999999)
        {
            if (dval > 999999999)
            {
                dval = dval / 1000000000;
                if (dval > 99)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.0fb", trunc(dval)];
                }
                else if (dval > 9)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.1fb", trunc(dval*10)/10];
                }
                else
                {
                    shortformNumber = [NSString stringWithFormat:@"%.2fb", trunc(dval*100)/100];
                }
            }
            else
            {
                dval = dval / 1000000;
                if (dval > 99)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.0fm", trunc(dval)];
                }
                else if (dval > 9)
                {
                    shortformNumber = [NSString stringWithFormat:@"%.1fm", trunc(dval*10)/10];
                }
                else
                {
                    shortformNumber = [NSString stringWithFormat:@"%.2fm", trunc(dval*100)/100];
                }
            }
        }
        else
        {
            dval = dval / 1000;
            if (dval > 99)
            {
                shortformNumber = [NSString stringWithFormat:@"%.0fk", trunc(dval)];
            }
            else if (dval > 9)
            {
                shortformNumber = [NSString stringWithFormat:@"%.1fk", trunc(dval*10)/10];
            }
            else
            {
                shortformNumber = [NSString stringWithFormat:@"%.2fk", trunc(dval*100)/100];
            }
        }
    }
    else
    {
        shortformNumber = [NSString stringWithFormat:@"%.0f", dval];
    }
    
    return shortformNumber;
}

- (NSString *)BoolToBit:(NSString *)boolString
{
	if([boolString isEqualToString:@"True"])
		return @"1";
	else
		return @"0";
}

- (NSString *)getCountdownString:(NSTimeInterval)differenceSeconds
{
    NSInteger days = (NSInteger)((double)differenceSeconds/(3600.0*24.00));
    NSInteger diffDay = differenceSeconds-(days*3600*24);
    NSInteger hours = (NSInteger)((double)diffDay/3600.00);
    NSInteger diffMin = diffDay-(hours*3600);
    NSInteger minutes = (NSInteger)(diffMin/60.0);
    NSInteger seconds = diffMin-(minutes*60);
    
    NSString *countdown;
    
    if (days > 0)
    {
        countdown = [NSString stringWithFormat:@"%ldd %02ld:%02ld:%02ld",(long)days,(long)hours,(long)minutes,(long)seconds];
    }
    else if (hours > 0)
    {
        countdown = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
    }
    else
    {
        countdown = [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
    }
    
    return countdown;
}

// Reports
- (void)updateReports:(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] showLoadingAlert];});
    
    NSString *service_name = @"GetReport";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                       self.world_url,
                       service_name,
                       [self gettLastReportId],
                       self.wsWorldProfileDict[@"profile_id"],
                       self.wsWorldProfileDict[@"alliance_id"]];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[[Globals i] removeLoadingAlert];
          
          if (error || !response || !data)
          {
              [[Globals i] trackEvent:@"WS Failed" action:service_name label:self.wsProfileDict[@"profile_id"]];
              completionBlock(NO, nil);
          }
          else
          {
              NSMutableArray *returnArray = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:nil];
              
              if ([returnArray count] > 0)
              {
                  [Globals i].wsReportArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                  
                  [[Globals i] addLocalReportData:[Globals i].wsReportArray];
                  
                  NSString *r_id = ([Globals i].wsReportArray)[0][@"report_id"];
                  [[Globals i] settLastReportId:r_id];
              }
              
              completionBlock(YES, data);
          }
      });
      }] resume];
}

- (NSString *)gettLastReportId
{
    self.lastReportId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Reportid"];
    if (self.lastReportId == nil)
    {
        self.lastReportId = @"0";
    }
    
    return self.lastReportId;
}

- (void)settLastReportId:(NSString *)rid
{
    self.lastReportId = rid;
    [[NSUserDefaults standardUserDefaults] setObject:self.lastReportId forKey:@"Reportid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)gettLocalReportData
{
    NSMutableArray *fullMutable = [[NSMutableArray alloc] init];
    
    NSArray *lclReport = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ReportData"];
    if (lclReport.count > 0)
    {
        for (NSDictionary *obj in lclReport)
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:obj copyItems:YES];
                [fullMutable addObject:dic];
            }
        }
    }
    
    return fullMutable;
}

- (void)settLocalReportData:(NSMutableArray *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:rd forKey:@"ReportData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailBadge" object:self];
}

- (void)addLocalReportData:(NSMutableArray *)rd
{
    self.localReportArray = [self gettLocalReportData];
    
    NSRange range = NSMakeRange(0, [rd count]);
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    
    [self.localReportArray insertObjects:rd atIndexes:indexSet]; //add to the top of array
    
    [[NSUserDefaults standardUserDefaults] setObject:self.localReportArray forKey:@"ReportData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailBadge" object:self];
}

- (void)deleteLocalReport:(NSString *)report_id
{
    self.localReportArray = [self gettLocalReportData];
    NSInteger count = [self.localReportArray count];
    NSInteger index_to_remove = -1;
    for (NSUInteger i = 0; i < count; i++)
    {
        if ([self.localReportArray[i][@"report_id"] isEqualToString:report_id])
        {
            index_to_remove = i;
        }
    }
    
    if (index_to_remove > -1)
    {
        [self.localReportArray removeObjectAtIndex:index_to_remove];
        [self settLocalReportData:self.localReportArray];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateReportView" object:self];
    }
}

- (NSInteger)getReportBadgeNumber
{
    NSInteger count = 0;
    
    NSArray *lclReport = [[NSUserDefaults standardUserDefaults] arrayForKey:@"ReportData"];
    if ([lclReport count] > 0)
    {
        for (NSDictionary *rowData in lclReport)
        {
            if ([rowData isKindOfClass:[NSDictionary class]])
            {
                if ([rowData[@"open_read"] isEqualToString:@"0"])
                {
                    count = count + 1;
                }
            }
        }
    }
    
    return count;
}

//Runs every second once
- (void)onTimer 
{

}

- (void)updateHeroLevelArray //TODO: fucked mny times
{
    if ((self.wsHeroLevelArray == nil) && (self.world_url != nil))
    {
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetHeroLevel",
                           self.world_url];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        self.wsHeroLevelArray = [[NSMutableArray alloc] initWithContentsOfURL:url];
    }
}

- (NSInteger)levelFromXp:(NSInteger)xp
{
    if (self.wsHeroLevelArray == nil)
    {
        [self updateHeroLevelArray];
    }
    
    NSInteger level = 1;
    
    for (NSDictionary *dict in self.wsHeroLevelArray)
    {
        if (([dict[@"total_xp"] integerValue] > 0) && ([dict[@"total_xp"] integerValue] < xp))
        {
            NSDictionary *hlDict = dict;
            level = [hlDict[@"hero_level"] integerValue];
        }
    }
    
    return level;
}

- (NSInteger)getXp
{
    NSInteger xp = [self.wsWorldProfileDict[@"hero_xp"] integerValue];
    
    return xp;
}

- (NSInteger)getLevel
{
    return [self levelFromXp:[self getXp]];
}

- (NSInteger)troopCount:(NSString *)status
{
    NSString *a1 = [NSString stringWithFormat:@"%@_a1", status];
    NSString *a2 = [NSString stringWithFormat:@"%@_a2", status];
    NSString *a3 = [NSString stringWithFormat:@"%@_a3", status];
    NSString *b1 = [NSString stringWithFormat:@"%@_b1", status];
    NSString *b2 = [NSString stringWithFormat:@"%@_b2", status];
    NSString *b3 = [NSString stringWithFormat:@"%@_b3", status];
    NSString *c1 = [NSString stringWithFormat:@"%@_c1", status];
    NSString *c2 = [NSString stringWithFormat:@"%@_c2", status];
    NSString *c3 = [NSString stringWithFormat:@"%@_c3", status];
    NSString *d1 = [NSString stringWithFormat:@"%@_d1", status];
    NSString *d2 = [NSString stringWithFormat:@"%@_d2", status];
    NSString *d3 = [NSString stringWithFormat:@"%@_d3", status];
    
    NSInteger int_a1 = [[self valueForKey:a1] integerValue];
    NSInteger int_a2 = [[self valueForKey:a2] integerValue];
    NSInteger int_a3 = [[self valueForKey:a3] integerValue];
    NSInteger int_b1 = [[self valueForKey:b1] integerValue];
    NSInteger int_b2 = [[self valueForKey:b2] integerValue];
    NSInteger int_b3 = [[self valueForKey:b3] integerValue];
    NSInteger int_c1 = [[self valueForKey:c1] integerValue];
    NSInteger int_c2 = [[self valueForKey:c2] integerValue];
    NSInteger int_c3 = [[self valueForKey:c3] integerValue];
    NSInteger int_d1 = [[self valueForKey:d1] integerValue];
    NSInteger int_d2 = [[self valueForKey:d2] integerValue];
    NSInteger int_d3 = [[self valueForKey:d3] integerValue];
    
    NSInteger total = int_a1+int_a2+int_a3+int_b1+int_b2+int_b3+int_c1+int_c2+int_c3+int_d1+int_d2+int_d3;
    
    return total;
}

- (void)showTroopList:(NSString *)status
{
    NSString *a1 = [NSString stringWithFormat:@"%@_a1", status];
    NSString *a2 = [NSString stringWithFormat:@"%@_a2", status];
    NSString *a3 = [NSString stringWithFormat:@"%@_a3", status];
    NSString *b1 = [NSString stringWithFormat:@"%@_b1", status];
    NSString *b2 = [NSString stringWithFormat:@"%@_b2", status];
    NSString *b3 = [NSString stringWithFormat:@"%@_b3", status];
    NSString *c1 = [NSString stringWithFormat:@"%@_c1", status];
    NSString *c2 = [NSString stringWithFormat:@"%@_c2", status];
    NSString *c3 = [NSString stringWithFormat:@"%@_c3", status];
    NSString *d1 = [NSString stringWithFormat:@"%@_d1", status];
    NSString *d2 = [NSString stringWithFormat:@"%@_d2", status];
    NSString *d3 = [NSString stringWithFormat:@"%@_d3", status];
    
    NSDictionary *dict = @{@"a1": [self valueForKey:a1], @"a2": [self valueForKey:a2], @"a3": [self valueForKey:a3],
                           @"b1": [self valueForKey:b1], @"b2": [self valueForKey:b2], @"b3": [self valueForKey:b3],
                           @"c1": [self valueForKey:c1], @"c2": [self valueForKey:c2], @"c3": [self valueForKey:c3],
                           @"d1": [self valueForKey:d1], @"d2": [self valueForKey:d2], @"d3": [self valueForKey:d3]};
    
    NSMutableArray *array = [self createTroopList:dict];
    [array removeObjectAtIndex:array.count-1];
    
    NSMutableArray *dialogRows = [@[array] mutableCopy];
    [[Globals i] showDialogBlock:dialogRows type:3 :^(NSInteger index, NSString *text){ }];
}

- (NSMutableArray *)createTroopList:(NSDictionary *)dict
{
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    NSInteger a1 = [dict[@"a1"] integerValue];
    NSInteger a2 = [dict[@"a2"] integerValue];
    NSInteger a3 = [dict[@"a3"] integerValue];
    NSInteger b1 = [dict[@"b1"] integerValue];
    NSInteger b2 = [dict[@"b2"] integerValue];
    NSInteger b3 = [dict[@"b3"] integerValue];
    NSInteger c1 = [dict[@"c1"] integerValue];
    NSInteger c2 = [dict[@"c2"] integerValue];
    NSInteger c3 = [dict[@"c3"] integerValue];
    NSInteger d1 = [dict[@"d1"] integerValue];
    NSInteger d2 = [dict[@"d2"] integerValue];
    NSInteger d3 = [dict[@"d3"] integerValue];
    
    NSDictionary *row201 = @{@"r1": @"Troop Type", @"c1": @"Amount", @"r1_color": @"2", @"c1_color": @"2", @"c1_ratio": @"2.5", @"c1_align": @"2", @"r1_border": @"1", @"r1_align": @"3", @"r1_font": @"13.0", @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    [rows1 addObject:row201];
    
    if (a1 > 0)
    {
        NSDictionary *row201 = @{@"i1": @"icon_a1", @"r1": [Globals i].a1, @"r1_border": @"1", @"c1": [[Globals i] intString:a1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row201];
    }
    if (a2 > 0)
    {
        NSDictionary *row202 = @{@"i1": @"icon_a2", @"r1": [Globals i].a2, @"r1_border": @"1", @"c1": [[Globals i] intString:a2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row202];
    }
    if (a3 > 0)
    {
        NSDictionary *row203 = @{@"i1": @"icon_a3", @"r1": [Globals i].a3, @"r1_border": @"1", @"c1": [[Globals i] intString:a3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row203];
    }
    
    if (b1 > 0)
    {
        NSDictionary *row301 = @{@"i1": @"icon_b1", @"r1": [Globals i].b1, @"r1_border": @"1", @"c1": [[Globals i] intString:b1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row301];
    }
    if (b2 > 0)
    {
        NSDictionary *row302 = @{@"i1": @"icon_b2", @"r1": [Globals i].b2, @"r1_border": @"1", @"c1": [[Globals i] intString:b2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row302];
    }
    if (b3 > 0)
    {
        NSDictionary *row303 = @{@"i1": @"icon_b3", @"r1": [Globals i].b3, @"r1_border": @"1", @"c1": [[Globals i] intString:b3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row303];
    }
    
    if (c1 > 0)
    {
        NSDictionary *row401 = @{@"i1": @"icon_c1", @"r1": [Globals i].c1, @"r1_border": @"1", @"c1": [[Globals i] intString:c1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row401];
    }
    if (c2 > 0)
    {
        NSDictionary *row402 = @{@"i1": @"icon_c2", @"r1": [Globals i].c2, @"r1_border": @"1", @"c1": [[Globals i] intString:c2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row402];
    }
    if (c3 > 0)
    {
        NSDictionary *row403 = @{@"i1": @"icon_c3", @"r1": [Globals i].c3, @"r1_border": @"1", @"c1": [[Globals i] intString:c3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row403];
    }
    
    if (d1 > 0)
    {
        NSDictionary *row501 = @{@"i1": @"icon_d1", @"r1": [Globals i].d1, @"r1_border": @"1", @"c1": [[Globals i] intString:d1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row501];
    }
    if (d2 > 0)
    {
        NSDictionary *row502 = @{@"i1": @"icon_d2", @"r1": [Globals i].d2, @"r1_border": @"1", @"c1": [[Globals i] intString:d2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row502];
    }
    if (d3 > 0)
    {
        NSDictionary *row503 = @{@"i1": @"icon_d3", @"r1": [Globals i].d3, @"r1_border": @"1", @"c1": [[Globals i] intString:d3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row503];
    }
    
    NSInteger total_troops = a1 + a2 + a3 + b1 + b2 + b3 + c1 + c2 + c3 + d1 + d2 + d3;
    
    NSDictionary *row203 = @{@"r1": [NSString stringWithFormat:@"Total Troops: %@", [[Globals i] intString:total_troops]], @"nofooter": @"1"};
    [rows1 addObject:row203];
    
    [rows1 addObject:@(total_troops)]; //Last row is total troops as a NSNumber
    
    return rows1;
}

- (NSInteger)totalTroopsFromDict:(NSDictionary *)dict
{
    NSInteger a1 = [dict[@"a1"] integerValue];
    NSInteger a2 = [dict[@"a2"] integerValue];
    NSInteger a3 = [dict[@"a3"] integerValue];
    NSInteger b1 = [dict[@"b1"] integerValue];
    NSInteger b2 = [dict[@"b2"] integerValue];
    NSInteger b3 = [dict[@"b3"] integerValue];
    NSInteger c1 = [dict[@"c1"] integerValue];
    NSInteger c2 = [dict[@"c2"] integerValue];
    NSInteger c3 = [dict[@"c3"] integerValue];
    NSInteger d1 = [dict[@"d1"] integerValue];
    NSInteger d2 = [dict[@"d2"] integerValue];
    NSInteger d3 = [dict[@"d3"] integerValue];
    
    NSInteger total_troops = a1 + a2 + a3 + b1 + b2 + b3 + c1 + c2 + c3 + d1 + d2 + d3;
    
    return total_troops;
}

@end
