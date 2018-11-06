//
//  Globals.m
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

@import AVFoundation;
#import "Globals.h"
#import "SRConnection.h"
#import "SRHubs.h"
#import "TutorialView.h"
#import "TTTOrdinalNumberFormatter.h"
#import "MapBaseCompare.h"
#import "TimerObject.h"
#import "TimerView.h"
#import "TimerHolder.h"

@interface Globals () <SRConnectionDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) TutorialView *tutorialView;
@property (nonatomic, strong) SRHubConnection *hubConnection;
@property (nonatomic, strong) SRHubProxy *hubProxy;
@property (nonatomic, strong) NSMutableArray *tvViews;
@property (nonatomic, strong) NSMutableArray *toStack;
@property (nonatomic, strong) NSDate *timerStartDate;

@property (nonatomic, assign) NSInteger base_fetch_retries;

//Sound
@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *loadingMusicPlayer;
@property (strong, nonatomic) AVAudioPlayer *mapMusicPlayer;
@property (nonatomic, retain) AVQueuePlayer *queuePlayer;

@property (assign) SystemSoundID sfx_archery;
@property (assign) SystemSoundID sfx_barracks;
@property (assign) SystemSoundID sfx_blacksmith;
@property (assign) SystemSoundID sfx_castle;
@property (assign) SystemSoundID sfx_embassy;
@property (assign) SystemSoundID sfx_farm;
@property (assign) SystemSoundID sfx_hospital;
@property (assign) SystemSoundID sfx_house;
@property (assign) SystemSoundID sfx_library;
@property (assign) SystemSoundID sfx_market;
@property (assign) SystemSoundID sfx_mine;
@property (assign) SystemSoundID sfx_quarry;
@property (assign) SystemSoundID sfx_rallypoint;
@property (assign) SystemSoundID sfx_sawmill;
@property (assign) SystemSoundID sfx_siege;
@property (assign) SystemSoundID sfx_stable;
@property (assign) SystemSoundID sfx_storehouse;
@property (assign) SystemSoundID sfx_tavern;
@property (assign) SystemSoundID sfx_wall;
@property (assign) SystemSoundID sfx_watchtower;
@property (assign) SystemSoundID sfx_attack;
@property (assign) SystemSoundID sfx_button;
@property (assign) SystemSoundID sfx_gold;
@property (assign) SystemSoundID sfx_march;
@property (assign) SystemSoundID sfx_messages;
@property (assign) SystemSoundID sfx_notification;
@property (assign) SystemSoundID sfx_placement;
@property (assign) SystemSoundID sfx_speedup;
@property (assign) SystemSoundID sfx_training;
@property (assign) SystemSoundID sfx_build;
@property (assign) SystemSoundID sfx_destroy;

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
        
        //Timers
        self.tvViews = [[NSMutableArray alloc] init];
        for (int i=0; i<19; i++) //add number if add new type of timer
        {
            TimerView *tv_view = [[TimerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tvWidth, tvHeight)];
            tv_view.tv_id = i;
            
            [self.tvViews addObject:tv_view];
        }
        self.toStack = [[NSMutableArray alloc] init];
        self.timerHolder = [[TimerHolder alloc] init];
        
        self.launchFirstTime = @"1"; //Use to decide wether to setup MainView
        self.setupInProgress = @"0"; //Use to avoid calling starUp twice or more
        self.selected_profileid = @"0";
        self.selected_alliance_id = @"0";
        self.workingUrl = @"0";
        self.selectedMapTile = @"0";
        self.lastGlobalChatId = @"0";
        self.lastAllianceChatId = @"0";
        
        //Map loc
        self.map_center_x = 0;
        self.map_center_y = 0;
        self.map_tiles_x = 0;
        self.map_tiles_y = 0;
        
        self.serverTimeInterval = 0;
        self.startServerTimeInterval = 0;
        self.offsetServerTimeInterval = 0;
        self.buildQueue1 = 0;
        self.base_fetch_retries = 0;
        self.gettingChatWorld = NO;
        self.gettingChatAlliance = NO;
        self.req1_b = YES;
        self.req2_b = YES;
        self.mapzoom_big = YES;
        self.skill_point_spent = NO;
        
        self.wsLogArray = [[NSMutableArray alloc] init];
        self.wsLogFullArray = [[NSMutableArray alloc] init];
        self.wsChatFullArray = [[NSMutableArray alloc] init];
        self.wsAllianceChatFullArray = [[NSMutableArray alloc] init];
        self.wsBuildArray = [[NSMutableArray alloc] init];
        
        if (!self.gameTimer.isValid)
        {
            self.gameTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.gameTimer forMode:NSRunLoopCommonModes];
        }
        
        [self notificationRegister];
        
        //UNIT TYPES
        self.a1 = NSLocalizedString(@"Spearmen", nil);
        self.a2 = NSLocalizedString(@"Swordsmen", nil);
        self.a3 = NSLocalizedString(@"Halberdier", nil);
        self.b1 = NSLocalizedString(@"Archers", nil);
        self.b2 = NSLocalizedString(@"Longbowmen", nil);
        self.b3 = NSLocalizedString(@"Marksmen", nil);
        self.c1 = NSLocalizedString(@"Light Cavalry", nil);
        self.c2 = NSLocalizedString(@"Heavy Cavalry", nil);
        self.c3 = NSLocalizedString(@"Knight", nil);
        self.d1 = NSLocalizedString(@"Battering Ram", nil);
        self.d2 = NSLocalizedString(@"Ballista", nil);
        self.d3 = NSLocalizedString(@"Catapult", nil);
        
        //RESOURCES TYPES
        self.r1 = NSLocalizedString(@"Food", nil);
        self.r2 = NSLocalizedString(@"Wood", nil);
        self.r3 = NSLocalizedString(@"Stone", nil);
        self.r4 = NSLocalizedString(@"Ore", nil);
        self.r5 = NSLocalizedString(@"Gold", nil);
        
        //Sound
        [self configureAudioSession];
        [self configureAudioPlayer];
        [self configureSystemSound];
    }
    return self;
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BaseUpdated"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SpeedUp"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SpeedUpPercent"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TimerViewEnd"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SpeedUpBuild"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TabSelected"
                                               object:nil];
}

- (void)logout
{
    [UIManager.i closeTemplate];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"ShowLogin"
     object:self];
    
    [self playMusicLoading];
}

- (void)changeUserLogout
{
    //Causes to crash if no internet
    [self signalr_logout];
    
    
    [self setUID:@""];
    
    [self settSelectedBaseId:@"0"];
    
    [self settLocalMailData:nil];
    [self settLocalMailReply:nil];
    
    [self settLastMailId:@"0"];
    
    [self settLocalReportData:nil];
    
    [self settLastReportId:@"0"];
    
    //clear chat
    [self.wsChatFullArray removeAllObjects];
    [self.wsAllianceChatFullArray removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatWorld" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatAlliance" object:self];
    
    [self logout];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"SpeedUp"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSString *base_id = [userInfo objectForKey:@"base_id"];
            NSString *item_value = [userInfo objectForKey:@"item_value"];
            NSString *type = [userInfo objectForKey:@"item_type"];
            
            NSLog(@"base_id :%@",base_id);
            NSLog(@"item_value :%@",item_value);
            NSLog(@"type :%@",type);
            
            if ([Globals.i.wsBaseDict[@"base_id"] isEqualToString:base_id])
            {
                NSInteger tv_id = [type integerValue];
                NSInteger iv = [item_value integerValue];
                
                //Update local notifications
                [((TimerView *)self.tvViews[tv_id]) updateNotifications:iv];
                
                if (tv_id == TV_BUILD)
                {
                    Globals.i.buildUntil = Globals.i.buildUntil - iv;
                }
                else if (tv_id == TV_RESEARCH)
                {
                    Globals.i.researchUntil = Globals.i.researchUntil - iv;
                }
                else if (tv_id == TV_HEAL)
                {
                    Globals.i.hospitalUntil = Globals.i.hospitalUntil - iv;
                }
                else if (tv_id == TV_A)
                {
                    Globals.i.aUntil = Globals.i.aUntil - iv;
                }
                else if (tv_id == TV_B)
                {
                    Globals.i.bUntil = Globals.i.bUntil - iv;
                }
                else if (tv_id == TV_C)
                {
                    Globals.i.cUntil = Globals.i.cUntil - iv;
                }
                else if (tv_id == TV_D)
                {
                    Globals.i.dUntil = Globals.i.dUntil - iv;
                }
                else if (tv_id == TV_SPY)
                {
                    Globals.i.spyUntil = Globals.i.spyUntil - iv;
                }
            }
            
        }
    }
    else if ([[notification name] isEqualToString:@"SpeedUpPercent"])
    {
        NSDictionary *userInfo = notification.userInfo;
        //NSTimeInterval serverTimeInterval = [self updateTime];
        if (userInfo != nil)
        {
            NSString *base_id = [userInfo objectForKey:@"base_id"];
            //NSString *item_value = [userInfo objectForKey:@"item_value"];
            //NSLog(@"item_value :%ld",[[userInfo objectForKey:@"item_value"] integerValue]);
            NSString *type = [userInfo objectForKey:@"item_type"];
            
            if ([Globals.i.wsBaseDict[@"base_id"] isEqualToString:base_id])
            {
                NSInteger tv_id = [type integerValue];
                //NSInteger iv = [item_value integerValue];
                
                if (tv_id == TV_ATTACK||tv_id == TV_TRADE||tv_id == TV_REINFORCE||tv_id == TV_TRANSFER)
                {
                    [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                     {
                         NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                         [userInfo setObject:@(tv_id) forKey:@"tv_id"];
                         [userInfo setObject:self.wsBaseDict[@"base_id"] forKey:@"base_id"];
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTimer"
                                                                             object:self
                                                                           userInfo:userInfo];
                     }];
                }
            }
            
        }
    }
    else if ([[notification name] isEqualToString:@"BaseUpdated"])
    {
        //TODO: not using timerObject, instead duduct at Global timer
        //[self PrepareAttackResults];
        
        [self GetTradesIn:^(BOOL success, NSData *data){ }]; //Creates timer objects for resources coming in
    }
    else if ([[notification name] isEqualToString:@"TimerViewEnd"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *tv_id = [userInfo objectForKey:@"tv_id"];
            
            if ([tv_id integerValue] == TV_BUILD)
            {
                Globals.i.buildQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_RESEARCH)
            {
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.researchQueue1 = 0;
                 }];
            }
            else if ([tv_id integerValue] == TV_ATTACK)
            {
                Globals.i.attackQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_TRADE)
            {
                Globals.i.tradeQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_REINFORCE)
            {
                Globals.i.reinforceQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_TRANSFER)
            {
                Globals.i.transferQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_HEAL)
            {
                Globals.i.hospitalQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_A)
            {
                Globals.i.aQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_B)
            {
                Globals.i.bQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_C)
            {
                Globals.i.cQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_D)
            {
                Globals.i.dQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_SPY)
            {
                Globals.i.spyQueue1 = 0;
            }
            else if ([tv_id integerValue] == TV_BOOST_R1)
            {
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.boostR1Queue1 = 0;
                 }];
            }
            else if ([tv_id integerValue] == TV_BOOST_R2)
            {
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.boostR2Queue1 = 0;
                 }];
            }
            else if ([tv_id integerValue] == TV_BOOST_R3)
            {
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.boostR3Queue1 = 0;
                 }];
            }
            else if ([tv_id integerValue] == TV_BOOST_R4)
            {
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.boostR4Queue1 = 0;
                 }];
            }
            else if ([tv_id integerValue] == TV_BOOST_R5)
            {
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.boostR5Queue1 = 0;
                 }];
            }
            else if ([tv_id integerValue] == TV_BOOST_ATT)
            {
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.boostAttackQueue1 = 0;
                 }];
            }
            else if ([tv_id integerValue] == TV_BOOST_DEF)
            {
                [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                 {
                     Globals.i.boostDefendQueue1 = 0;
                 }];
            }

            
            [Globals.i popTvStack:[tv_id integerValue]];
        }
    }
    else if ([[notification name] isEqualToString:@"SpeedUpBuild"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSString *base_id = [userInfo objectForKey:@"base_id"];
            NSString *item_value = [userInfo objectForKey:@"item_value"];
            
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:base_id forKey:@"base_id"];
            [userInfo setObject:item_value forKey:@"item_value"];
            [userInfo setObject:@"TV_BUILD" forKey:@"item_type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SpeedUp"
                                                                object:self
                                                              userInfo:userInfo];
            
        }
    }
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

- (NSMutableArray *)customParser:(NSData *)data
{
    NSMutableArray *sourceArray = [[NSMutableArray alloc] init];
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    if (!data)
    {
        return returnArray;
    }
    
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

- (NSDate *)dateParser:(NSString *)strDate
{
    strDate = [[strDate componentsSeparatedByString:@"."] objectAtIndex:0];
    
    //NSLog(@"dateParser input: %@", strDate);
    
    NSDate *date = [[self getDateFormat] dateFromString:strDate];
    
    //NSLog(@"dateParser output: %@", [[self getDateFormat] stringFromDate:date]);
    
    return date;
}

//Used for mail and report dont show loading and dont track
- (void)getServer:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       Globals.i.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getServer:%@", wsurl);
    
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
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       WS_URL, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getMainServerLoading:%@", wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  
                  completionBlock(NO, nil);
                  dispatch_async(dispatch_get_main_queue(), ^{[Globals.i showDialogError];});
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
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       Globals.i.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getServerLoading:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  
                  completionBlock(NO, nil);
                  dispatch_async(dispatch_get_main_queue(), ^{[Globals.i showDialogError];});
              }
              else
              {
                  completionBlock(YES, data);
              }
          });
      }] resume];
}

- (void)loginGameCenter:(NSString *)playerID :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    NSString *service_name = @"LoginGameCenter";
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       WS_URL, service_name, playerID];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"loginGameCenter:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:playerID];
                  
                  completionBlock(NO, nil);
                  dispatch_async(dispatch_get_main_queue(), ^{[Globals.i showDialogError];});
              }
              else
              {
                  [Globals.i trackEvent:service_name];
                  
                  NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  if ([returnValue isEqualToString:@"1"]) //Stored Proc Success
                  {
                      completionBlock(YES, data);
                  }
                  else if ([returnValue isEqualToString:@"-1"]) //Stored Proc Failed
                  {
                      [Globals.i showDialogFail];
                      [Globals.i trackEvent:@"SP Failed" action:service_name label:playerID];
                  }
                  else //Web Service Return 0
                  {
                      if (returnValue != nil)
                      {
                          if (DEBUG)
                          {
                              [UIManager.i showIIS_error:returnValue];
                          }
                          else
                          {
                              [Globals.i showDialogFail];
                          }
                          
                          [Globals.i trackEvent:returnValue action:service_name label:playerID];
                      }
                      else
                      {
                          [Globals.i showDialogError];
                          [Globals.i trackEvent:@"WS Return 0" action:service_name label:playerID];
                      }
                  }
              }
          });
      }] resume];
}

- (void)getSp:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       Globals.i.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getSp:%@", wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (error || !response || !data)
          {
              completionBlock(NO, nil);
          }
          else
          {
              NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              if ([returnValue isEqualToString:@"1"]) //Stored Proc Success
              {
                  completionBlock(YES, data);
              }
          }
      }] resume];
}

- (void)getSpLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@%@",
                       Globals.i.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getSpLoading:%@", wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              
              [UIManager.i removeLoadingAlert];
              
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  
                  completionBlock(NO, nil);
                  dispatch_async(dispatch_get_main_queue(), ^{[Globals.i showDialogError];});
              }
              else
              {
                  [Globals.i trackEvent:service_name];
                  
                  NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                  if ([returnValue isEqualToString:@"1"]) //Stored Proc Success
                  {
                      completionBlock(YES, data);
                  }
                  else if ([returnValue isEqualToString:@"-1"]) //Stored Proc Failed
                  {
                      [Globals.i showDialogFail];
                      [Globals.i trackEvent:@"SP Failed" action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
                  }
                  else //Web Service Return 0
                  {
                      if (returnValue != nil)
                      {
                          if (DEBUG)
                          {
                              [UIManager.i showIIS_error:returnValue];
                          }
                          else
                          {
                              [Globals.i showDialogFail];
                          }
                          [Globals.i trackEvent:returnValue action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
                      }
                      else
                      {
                          [Globals.i showDialogError];
                          [Globals.i trackEvent:@"WS Return 0" action:service_name label:Globals.i.wsWorldProfileDict[@"uid"]];
                      }
                  }
              }
          });
      }] resume];
}

//Used in ChatView
- (void)postServer:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock
{
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Globals.i.world_url, service]]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", service, error, [error localizedDescription]);
             completionBlock(NO, nil);
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
    [postDataTask resume];
}

- (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", Globals.i.world_url, service]]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];});
         if (error || !response || !data)
         {
             NSLog(@"Error posting to %@: %@ %@", service, error, [error localizedDescription]);
             completionBlock(NO, nil);
             dispatch_async(dispatch_get_main_queue(), ^{[Globals.i showDialogError];});
         }
         else
         {
             completionBlock(YES, data);
         }
     }];
    [postDataTask resume];
}

- (void)setupSignalR
{
    if (self.hubConnection == nil)
    {
        // Connect to the service
        NSString *hubURL = [NSString stringWithFormat:@"%@", Globals.i.world_url];
        self.hubConnection = [SRHubConnection connectionWithURLString:hubURL];
        self.hubConnection.delegate = self;
        
        // Create a proxy to the service
        self.hubProxy = [self.hubConnection createHubProxy:@"ChatHub"];
        
        [self.hubProxy on:@"broadcastMessage" perform:self selector:@selector(broadcastMessage:)];
        
        [self.hubProxy on:@"alliance_approve" perform:self selector:@selector(alliance_approve:)];
        
        [self.hubProxy on:@"alliance_kick" perform:self selector:@selector(alliance_kick)];
        
        [self.hubProxy on:@"chat_kingdom" perform:self selector:@selector(chat_kingdom: : : : : : : : :)];
        
        [self.hubProxy on:@"chat_kingdom_history" perform:self selector:@selector(chat_kingdom_history: : : : : : : : :)];
        
        [self.hubProxy on:@"chat_alliance" perform:self selector:@selector(chat_alliance: : : : : : : : :)];
        
        [self.hubProxy on:@"chat_alliance_history" perform:self selector:@selector(chat_alliance_history: : : : : : : : :)];
        
        [self.hubProxy on:@"mail_send" perform:self selector:@selector(mail_send: : : : : : : : :)];
        
        [self.hubProxy on:@"mail_reply" perform:self selector:@selector(mail_reply: : : : : : : : :)];
        
        [self.hubProxy on:@"send_resources" perform:self selector:@selector(send_resources:)];
        
        [self.hubProxy on:@"speedup_resources" perform:self selector:@selector(speedup_resources:)];
        
        [self.hubProxy on:@"send_reinforce" perform:self selector:@selector(send_reinforce:)];
        
        [self.hubProxy on:@"reinforcements_return" perform:self selector:@selector(reinforcements_return:)];
        
        [self.hubProxy on:@"send_spies" perform:self selector:@selector(send_spies:)];
        
        [self.hubProxy on:@"send_attack" perform:self selector:@selector(send_attack: :)];
        
        //Called by webservice after an attack is processed if you are the defender
        [self.hubProxy on:@"send_attack_processed" perform:self selector:@selector(send_attack_processed:)];
        
        //Called by webservice after an attack is processed if you are the attacker
        [self.hubProxy on:@"send_attack_attacker" perform:self selector:@selector(send_attack_attacker:)];
        
        [self.hubProxy on:@"quest_done" perform:self selector:@selector(quest_done:)];
        
        [self.hubProxy on:@"base_gain" perform:self selector:@selector(base_gain:)];
        
        [self.hubProxy on:@"base_lost" perform:self selector:@selector(base_lost:)];
        
        // Start the connection
        [self.hubConnection start];
    }
    else
    {
        [self signalr_login];
    }
}

- (void)broadcastMessage:(NSString *)message
{
    [UIManager.i showDialog:message title:@"MessageBroadcast"];
}

- (void)alliance_approve:(NSString *)alliance_id
{
    self.wsWorldProfileDict[@"alliance_id"] = alliance_id;
    
    [UIManager.i showDialog:NSLocalizedString(@"Congrats! Your application to join an Alliance has been approved by the Leader.", nil) title:@"AllianceApproved"];
    
    [self.hubProxy invoke:@"AllianceGroupAdd" withArgs:@[self.wsWorldProfileDict[@"profile_id"], alliance_id]];
}

- (void)alliance_kick
{
    [self.hubProxy invoke:@"AllianceGroupRemove" withArgs:@[self.wsWorldProfileDict[@"profile_id"], self.wsWorldProfileDict[@"alliance_id"]]];
    
    self.wsWorldProfileDict[@"alliance_id"] = @"0";
    
    [UIManager.i showDialog:NSLocalizedString(@"Sorry! You have been kicked out of your current Alliance!", nil) title:@"AllianceKicked"];
}

- (void)log_ui:(NSString *)msg
{
    NSMutableDictionary *log_ui_row = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       msg,
                                       @"message",
                                       nil];
    
    [self.wsLogFullArray addObject:log_ui_row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UILog" object:self];
}

- (void)chat_kingdom:(NSString *)profile_id :(NSString *)profile_name :(NSString *)profile_face :(NSString *)msg :(NSString *)alliance_id :(NSString *)alliance_tag :(NSString *)alliance_logo :(NSString *)target_alliance_id :(NSString *)chat_id
{
    Globals.i.lastGlobalChatId = chat_id;
    
    NSMutableDictionary *chat_row = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     profile_id,
                                     @"profile_id",
                                     profile_name,
                                     @"profile_name",
                                     profile_face,
                                     @"profile_face",
                                     alliance_id,
                                     @"alliance_id",
                                     alliance_tag,
                                     @"alliance_tag",
                                     alliance_logo,
                                     @"alliance_logo",
                                     msg,
                                     @"message",
                                     target_alliance_id,
                                     @"target_alliance_id",
                                     nil];
    
    [self.wsChatFullArray addObject:chat_row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatWorld" object:self];
}

- (void)chat_kingdom_history:(NSString *)profile_id :(NSString *)profile_name :(NSString *)profile_face :(NSString *)msg :(NSString *)alliance_id :(NSString *)alliance_tag :(NSString *)alliance_logo :(NSString *)target_alliance_id :(NSString *)chat_id
{
    long long server_chat_id = [chat_id longLongValue];
    long long client_chat_id = [Globals.i.lastGlobalChatId longLongValue];
    
    if (server_chat_id > client_chat_id)
    {
        [self chat_kingdom:profile_id :profile_name :profile_face :msg :alliance_id :alliance_tag :alliance_logo :target_alliance_id :chat_id];
    }
}

- (void)chat_alliance:(NSString *)profile_id :(NSString *)profile_name :(NSString *)profile_face :(NSString *)msg :(NSString *)alliance_id :(NSString *)alliance_tag :(NSString *)alliance_logo :(NSString *)target_alliance_id :(NSString *)chat_id
{
    Globals.i.lastAllianceChatId = chat_id;
    
    NSMutableDictionary *chat_row = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     profile_id,
                                     @"profile_id",
                                     profile_name,
                                     @"profile_name",
                                     profile_face,
                                     @"profile_face",
                                     alliance_id,
                                     @"alliance_id",
                                     alliance_tag,
                                     @"alliance_tag",
                                     alliance_logo,
                                     @"alliance_logo",
                                     msg,
                                     @"message",
                                     target_alliance_id,
                                     @"target_alliance_id",
                                     nil];
    
    [self.wsAllianceChatFullArray addObject:chat_row];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChatAlliance" object:self];
}

- (void)chat_alliance_history:(NSString *)profile_id :(NSString *)profile_name :(NSString *)profile_face :(NSString *)msg :(NSString *)alliance_id :(NSString *)alliance_tag :(NSString *)alliance_logo :(NSString *)target_alliance_id :(NSString *)chat_id
{
    long long server_chat_id = [chat_id longLongValue];
    long long client_chat_id = [Globals.i.lastAllianceChatId longLongValue];
    
    if (server_chat_id > client_chat_id)
    {
        [self chat_alliance:profile_id :profile_name :profile_face :msg :alliance_id :alliance_tag :alliance_logo :target_alliance_id :chat_id];
    }
}

- (void)mail_send:(NSString *)mail_id :(NSString *)profile_id :(NSString *)profile_name :(NSString *)profile_face :(NSString *)msg :(NSString *)to_id :(NSString *)to_name :(NSString *)is_alliance :(NSString *)date_posted
{
    if (![profile_id isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]])
    {
        [UIManager.i showToast:[NSString stringWithFormat:NSLocalizedString(@"%@ has sent you a mail!", nil), profile_name]
               optionalTitle:@"Mail"
               optionalImage:@"mail_unread"];
        
        NSMutableDictionary *mail_row = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                         mail_id,
                                         @"mail_id",
                                         date_posted,
                                         @"date_posted",
                                         @"0",
                                         @"open_read",
                                         @"0",
                                         @"reply_counter",
                                         profile_id,
                                         @"profile_id",
                                         profile_name,
                                         @"profile_name",
                                         profile_face,
                                         @"profile_face",
                                         msg,
                                         @"message",
                                         to_id,
                                         @"to_id",
                                         to_name,
                                         @"to_name",
                                         is_alliance,
                                         @"is_alliance",
                                         nil];
        
        Globals.i.localMailArray = [Globals.i gettLocalMailData];
        [Globals.i.localMailArray insertObject:mail_row atIndex:0];
        
        [[NSUserDefaults standardUserDefaults] setObject:self.localMailArray forKey:@"MailData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneMailBadge" object:self];
        
        [Globals.i settLastMailId:mail_id];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailView" object:self];
    }
}

- (void)mail_reply:(NSString *)profile_id :(NSString *)profile_name :(NSString *)profile_face :(NSString *)msg :(NSString *)mail_id :(NSString *)from_id :(NSString *)reply_counter :(NSString *)to_id :(NSString *)is_alliance
{
    if (![profile_id isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]])
    {
        NSString *toast = @"";
        if ([is_alliance isEqualToString:@"0"]) //one to one mail
        {
            toast = [NSString stringWithFormat:NSLocalizedString(@"%@ has replied your mail!", nil), profile_name];
        }
        else
        {
            toast = [NSString stringWithFormat:NSLocalizedString(@"%@ has replied alliance mail!", nil), profile_name];
        }
        
        [UIManager.i showToast:toast
               optionalTitle:@"Mail"
               optionalImage:@"mail_unread"];
        
        if (![self setMailNotRead:mail_id])
        {
            [self updateMail];
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneMailBadge" object:self];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailView" object:self];
    }
}

- (void)send_resources:(NSString *)base_id
{
    [UIManager.i showToast:NSLocalizedString(@"An alliance member have sent you resources! Check your Watchtower.", nil)
           optionalTitle:@"IncomingResources"
           optionalImage:@"report_trade"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
    
    NSString *curr_base_id = Globals.i.wsBaseDict[@"base_id"];
    
    if ([curr_base_id isEqualToString:base_id])
    {
        [Globals.i updateBaseDict:^(BOOL success, NSData *data){ }]; //Creates timer objects for resources coming in
    }
}

- (void)speedup_resources:(NSString *)base_id //Called when sender speedup the the march
{
    NSString *curr_base_id = Globals.i.wsBaseDict[@"base_id"];
    
    if ([curr_base_id isEqualToString:base_id])
    {
        [Globals.i updateBaseDict:^(BOOL success, NSData *data){ }]; //Creates timer objects for resources coming in
    }
}

- (void)send_reinforce:(NSString *)base_id
{
    [UIManager.i showToast:NSLocalizedString(@"An alliance member have sent you reinforcements! Check your embassy.", nil)
           optionalTitle:@"IncomingReinforcements"
           optionalImage:@"report_reinforce"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
}

- (void)reinforcements_return:(NSString *)reinforce_id
{
    [UIManager.i showToast:NSLocalizedString(@"An alliance member have pulled back all thier reinforcements from your city.", nil)
           optionalTitle:@"ReinforcementsPulled"
           optionalImage:@"report_reinforce"];
}

- (void)send_spies:(NSString *)base_id
{
    [UIManager.i showToast:NSLocalizedString(@"Someone has spied on your city! Check your reports.", nil)
           optionalTitle:@"SpyDetected"
           optionalImage:@"report_spy_defeat"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
}

- (void)send_attack:(NSString *)base_id :(NSString *)march_time
{
    //Update watchtower
    [UIManager.i showToast:NSLocalizedString(@"Someone has sent an attack to your city! Check your watchtower.", nil)
           optionalTitle:@"Watchtower"
           optionalImage:@"report_attack_defeat"];
    
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:march_time forKey:@"march_time"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GlowBordersAttack"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)send_attack_processed:(NSString *)base_id
{
    NSString *curr_base_id = Globals.i.wsBaseDict[@"base_id"];
    
    if ([curr_base_id isEqualToString:base_id])
    {
        [UIManager.i showToast:NSLocalizedString(@"Your city is under Attack!", nil)
               optionalTitle:NSLocalizedString(@"Watchtower", nil)
               optionalImage:@"report_attack_defeat"];
        
        //Deducts troops, add injured and deducts resources
        [Globals.i updateBaseDict:^(BOOL success, NSData *data){ }];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
}

- (void)send_attack_attacker:(NSString *)base_id
{
    [Globals.i updateBaseDict:^(BOOL success, NSData *data){ }];
    //[self PrepareAttackResults];
}

- (void)quest_done:(NSString *)done
{
    NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject:done forKey:@"quest_done"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusQuestBadge"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)base_lost:(NSString *)base_id
{
    NSString *curr_base_id = Globals.i.wsBaseDict[@"base_id"];
    
    if ([curr_base_id isEqualToString:base_id])
    {
        [UIManager.i showToast:NSLocalizedString(@"Enemy has captured this Village!", nil)
               optionalTitle:NSLocalizedString(@"Watchtower", nil)
               optionalImage:@"report_attack_defeat"];
        
        //if success change to another base
        [self settSelectedBaseId:@"0"];
        [Globals.i updateBaseDict:^(BOOL success, NSData *data)
         {
             [UIManager.i closeAllTemplate];
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"BaseChanged"
              object:self];
         }];
    }
    else
    {
        [UIManager.i showToast:NSLocalizedString(@"Enemy has captured one of your Village!", nil)
               optionalTitle:NSLocalizedString(@"Watchtower", nil)
               optionalImage:@"report_attack_defeat"];
    }
    
    // - base_count to profile
    NSInteger old = [self.wsWorldProfileDict[@"base_count"] integerValue];
    NSInteger new = old - 1;
    self.wsWorldProfileDict[@"base_count"] = [@(new) stringValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
}

- (void)base_gain:(NSString *)base_id
{
    // + base_count to profile
    NSInteger old = [self.wsWorldProfileDict[@"base_count"] integerValue];
    NSInteger new = old + 1;
    self.wsWorldProfileDict[@"base_count"] = [@(new) stringValue];
    
    [UIManager.i showToast:NSLocalizedString(@"You captured a Village!", nil)
           optionalTitle:NSLocalizedString(@"Watchtower", nil)
           optionalImage:@"report_attack_victory"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusoneReportBadge" object:self];
}

- (void)signalr_login
{
    NSString *uid = [Globals.i UID];
    NSString *pid = self.wsWorldProfileDict[@"profile_id"];
    NSString *aid = self.wsWorldProfileDict[@"alliance_id"];
    
    NSLog(@"uid:%@, pid:%@, aid:%@", uid, pid, aid);
    
    [self.hubProxy invoke:@"Login" withArgs:@[uid, pid, aid]];
    
    //Send device token to our world servers
    [self loginWorld];
}

- (void)signalr_logout
{
    if (self.hubConnection != nil)
    {
        [self.hubProxy invoke:@"Logout" withArgs:@[Globals.i.UID, self.wsWorldProfileDict[@"profile_id"], self.wsWorldProfileDict[@"alliance_id"]]];
    }
}

#pragma mark -
#pragma mark SRConnection Delegate

- (void)SRConnectionDidOpen:(SRConnection *)connection
{
    [self signalr_login];
}

- (void)SRConnection:(SRConnection *)connection didReceiveData:(id)data
{
    
}

- (void)SRConnectionDidClose:(SRConnection *)connection
{
    
}

- (void)SRConnection:(SRConnection *)connection didReceiveError:(NSError *)error
{
    
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
        
        //Test other webservices
        //wurl = [NSString stringWithFormat:@"http://%@/kingdom_world0", self.wsProfileDict[@"server_ip"]];
    }
    
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
        //[HelpshiftSupport setUserIdentifier:user_uid];
        
        //Crashlytics id
        //[CrashlyticsKit setUserIdentifier:user_uid];
        //[CrashlyticsKit setUserEmail:[self get_signin_name]];
        //[CrashlyticsKit setUserName:[self get_signin_name]];
        
        //GA id
        //[GameAnalytics configureUserId:user_uid];
    }
}

- (NSString	*)sound_fx
{
    NSString *sound_fx = [[NSUserDefaults standardUserDefaults] objectForKey:@"sound_fx"];
    
    if (sound_fx == nil)
    {
        sound_fx = @"1";
    }
    
    return sound_fx;
}

- (NSString	*)music_intro
{
    NSString *music_intro = [[NSUserDefaults standardUserDefaults] objectForKey:@"music_intro"];
    
    if (music_intro == nil)
    {
        music_intro = @"1";
    }
    
    return music_intro;
}

- (NSString	*)music_bg
{
    NSString *music_bg = [[NSUserDefaults standardUserDefaults] objectForKey:@"music_bg"];
    
    if (music_bg == nil)
    {
        music_bg = @"1";
    }
    
    return music_bg;
}

- (NSString	*)quest_reminder
{
    NSString *quest_reminder = [[NSUserDefaults standardUserDefaults] objectForKey:@"quest_reminder"];
    
    if (quest_reminder == nil)
    {
        quest_reminder = @"1";
    }
    
    return quest_reminder;
}

- (NSString	*)get_signin_name
{
    NSString *signin_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"signin_name"];
    
    if (signin_name == nil)
    {
        signin_name = @" ";
    }
    
    return signin_name;
}

- (void)set_signin_name:(NSString *)name
{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:@"signin_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sound_fx_on
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"sound_fx"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)music_intro_on
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"music_intro"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)music_bg_on
{
    [self.queuePlayer play];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"music_bg"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)sound_fx_off
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"sound_fx"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)music_intro_off
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"music_intro"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)music_bg_off
{
    [self.queuePlayer pause];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"music_bg"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)quest_reminder_on
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"quest_reminder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Update Advisor
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateAdvisor"
     object:self];
}

- (void)quest_reminder_off
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"quest_reminder"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Update Advisor
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateAdvisor"
     object:self];
}

- (NSString	*)always_download_graphicpack
{
    NSString *always_download_graphicpack = [[NSUserDefaults standardUserDefaults] objectForKey:@"always_download_graphicpack"];
    
    if (always_download_graphicpack == nil)
    {
        always_download_graphicpack = @"0";
    }
    
    return always_download_graphicpack;
}

- (void)download_graphicpack_on
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"always_download_graphicpack"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)download_graphicpack_off
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"always_download_graphicpack"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString	*)graphic_pack_id
{
    NSString *graphic_pack_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"graphic_pack_id"];
    
    if (graphic_pack_id == nil)
    {
        graphic_pack_id = @"1";
    }
    
    return graphic_pack_id;
}

- (void)set_graphic_pack_id:(NSString *)gid
{
    [[NSUserDefaults standardUserDefaults] setObject:gid forKey:@"graphic_pack_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//Tutorial flags
- (BOOL)is_tutorial_on
{
    NSString *tutorial_on = [[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial_on"];
    if (tutorial_on == nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:Globals.i.wsWorldProfileDict[@"tutorial_on"] forKey:@"tutorial_on"];
        tutorial_on = [[NSUserDefaults standardUserDefaults] objectForKey:@"tutorial_on"];
        if (tutorial_on == nil)
        {
            return false;
        }
    }

    if ([tutorial_on isEqualToString:@"1"])
    {
        return true;
    }
    else
    {
        return false;
    }
}

- (void)tutorial_off
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"tutorial_on"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tutorialView updateTutorial];
    [self.tutorialView removeFromSuperview];
}

- (NSTimeInterval)updateTime
{
    if (self.serverTimeInterval < 1)
    {
        NSString *wsurl = [[NSString alloc] initWithFormat:@"%@/CurrentTimeIso", WS_URL];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        NSString *returnValue = [NSString stringWithContentsOfURL:url encoding:NSASCIIStringEncoding error:nil];
        
        NSDate *serverDateTime = [Globals.i dateParser:returnValue];
        self.serverTimeInterval = [serverDateTime timeIntervalSince1970];
        
        self.startServerTimeInterval = [serverDateTime timeIntervalSince1970];
        self.timerStartDate = [[NSDate alloc] init];
        
        NSTimeInterval localTimeInterval = [self.timerStartDate timeIntervalSince1970];
        self.offsetServerTimeInterval = self.serverTimeInterval - localTimeInterval;
    }
    
    /*
    NSLog(@"ServerInterval:%@ start(local):%@ offset:%@",
          [@(self.serverTimeInterval) stringValue],
          [@(self.startServerTimeInterval) stringValue],
          [@(self.offsetServerTimeInterval) stringValue]);
    */
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
    NSString *datenow = [[self getDateFormat] stringFromDate:[self getServerDateTime]];
    
    return datenow;
}

- (NSDate *)getServerDateTime
{
    NSDate *localdatetime = [NSDate date];
    NSDate *serverdatetime = [localdatetime dateByAddingTimeInterval:self.offsetServerTimeInterval];
    
    return serverdatetime;
}

- (NSDateFormatter *)getDateFormat
{
    if (self.dateFormat == nil)
    {
        self.dateFormat = [[NSDateFormatter alloc] init];
        [self.dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [self.dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [self.dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    }
    
    return self.dateFormat;
}

- (NSString *)getTimeAgo:(NSString *)datetimestring
{
    NSString *diff = datetimestring;
    
    if (datetimestring != nil && [datetimestring length] > 0)
    {
        NSDate *date1 = [Globals.i dateParser:datetimestring];
        
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
                diff = NSLocalizedString(@"1 month ago", nil);
            }
            else
            {
                diff = [NSString stringWithFormat:NSLocalizedString(@"%@ months ago", nil), @([breakdownInfo month])];
            }
        }
        else if ([breakdownInfo day] > 0)
        {
            if ([breakdownInfo day] == 1)
            {
                diff = NSLocalizedString(@"1 day ago", nil);
            }
            else
            {
                diff = [NSString stringWithFormat:NSLocalizedString(@"%@ days ago", nil), @([breakdownInfo day])];
            }
        }
        else if ([breakdownInfo hour] > 0)
        {
            if ([breakdownInfo hour] == 1)
            {
                diff = NSLocalizedString(@"1 hour ago", nil);
            }
            else
            {
                diff = [NSString stringWithFormat:NSLocalizedString(@"%@ hours ago", nil), @([breakdownInfo hour])];
            }
        }
        else if ([breakdownInfo minute] > 0)
        {
            if ([breakdownInfo minute] == 1)
            {
                diff = NSLocalizedString(@"1 min ago", nil);
            }
            else
            {
                diff = [NSString stringWithFormat:NSLocalizedString(@"%@ mins ago", nil), @([breakdownInfo minute])];
            }
        }
        else if ([breakdownInfo second] > 0)
        {
            if ([breakdownInfo second] == 1)
            {
                diff = NSLocalizedString(@"1 sec ago", nil);
            }
            else
            {
                diff = [NSString stringWithFormat:NSLocalizedString(@"%@ secs ago", nil), @([breakdownInfo second])];
            }
        }
        else
        {
            diff = NSLocalizedString(@"1 sec ago", nil);
        }
    }
    
    return diff;
}

- (void)emailToDeveloper
{
    NSString *mailto = [NSString stringWithFormat:@"mailto://%@?subject=%@(Version %@)",
                        SUPPORT_EMAIL,
                        GAME_NAME,
                        GAME_VERSION];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mailto stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]]];
}

- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label
{
    //NSString *ga_event = [NSString stringWithFormat:@"%@:%@:%@", category, action, label];
    //[GameAnalytics addDesignEventWithEventId:ga_event];
    
    //[Answers logCustomEventWithName:category customAttributes:@{@"Action":action, @"Label":label}];
}

- (void)trackEvent:(NSString *)category action:(NSString *)action
{
    //NSString *ga_event = [NSString stringWithFormat:@"%@:%@", category, action];
    //[GameAnalytics addDesignEventWithEventId:ga_event];
    
    //[Answers logCustomEventWithName:category customAttributes:@{@"Action":action}];
}

- (void)trackEvent:(NSString *)category
{
    //NSString *ga_event = [NSString stringWithFormat:@"%@", category];
    //[GameAnalytics addDesignEventWithEventId:ga_event];
    
    //[Answers logCustomEventWithName:category customAttributes:@{}];
}
    
- (void)trackInvite:(NSString *)method
{
    //NSString *ga_event = [NSString stringWithFormat:@"Invite:%@", method];
    //[GameAnalytics addDesignEventWithEventId:ga_event];
    
    //[Answers logInviteWithMethod:method customAttributes:@{}];
}
    
- (void)trackScreenOpen:(NSString *)title
{
    //[GameAnalytics addProgressionEventWithProgressionStatus:GAProgressionStatusStart progression01:title progression02:nil progression03:nil];
        
    //[Answers logLevelStart:title customAttributes:@{}];
}
    
- (void)trackScreenClose:(NSString *)title
{
    //[GameAnalytics addProgressionEventWithProgressionStatus:GAProgressionStatusComplete progression01:title progression02:nil progression03:nil score:0];

    //[Answers logLevelEnd:title score:nil success:@YES customAttributes:@{}];
}
    
- (void)trackPurchase:(NSNumber *)revenue currencyCode:(NSString *)currencyCode localizedTitle:(NSString *)localizedTitle sku:(NSString *)sku
{
    NSDecimalNumber *decimalRevenue = [NSDecimalNumber decimalNumberWithDecimal:[revenue decimalValue]];
    /*
    [Answers logPurchaseWithPrice:decimalRevenue
                         currency:currencyCode
                          success:@YES
                         itemName:localizedTitle
                         itemType:@"InApp"
                           itemId:sku
                 customAttributes:@{}];
    */
    NSInteger priceInCents = [[decimalRevenue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]] intValue];
    //[GameAnalytics addBusinessEventWithCurrency:currencyCode amount:priceInCents itemType:localizedTitle itemId:sku cartType:@"InApp" autoFetchReceipt:YES];
    
    NSNumber *gems_purchased = @([[self gettPurchasedGems] intValue]);
    //[GameAnalytics addResourceEventWithFlowType:GAResourceFlowTypeSource currency:@"Gems" amount:gems_purchased itemType:localizedTitle itemId:sku];
}

- (void)trackSpend:(NSNumber *)cost itemName:(NSString *)itemName itemId:(NSString *)itemId
{
    //[GameAnalytics addResourceEventWithFlowType:GAResourceFlowTypeSink currency:@"Gems" amount:cost itemType:itemName itemId:itemId];
}

- (void)showDialogError
{
    [UIManager.i showDialogBlock:NSLocalizedString(@"Sorry, there was an internet connection issue or your session has timed out. Please try again or re-open game. Would you like to report this problem to us?", nil)
                      title:@""
                       type:2
                           :^(NSInteger index, NSString *text) {
                               if (index == 1) //YES
                               {
                                   [[NSNotificationCenter defaultCenter]
                                    postNotificationName:@"ShowFeedback"
                                    object:self];
                               }
                           }];
}

- (void)showDialogFail
{
    [UIManager.i showDialogBlock:NSLocalizedString(@"Sorry, the action you took failed. Please try again. Would you like to report this problem to us?", nil)
                      title:@""
                       type:2
                           :^(NSInteger index, NSString *text) {
                               if (index == 1) //YES
                               {
                                   [[NSNotificationCenter defaultCenter]
                                    postNotificationName:@"ShowFeedback"
                                    object:self];
                               }
                           }];
}

- (void)showDialogFailedLoginEmail
{
    [UIManager.i showDialogBlock:NSLocalizedString(@"Please try to login again. If the problem persists, please contact " SUPPORT_EMAIL @". Would you like to report this problem to us?", nil)
                      title:@""
                       type:2
                           :^(NSInteger index, NSString *text) {
                               if (index == 1) //YES
                               {
                                   [[NSNotificationCenter defaultCenter]
                                    postNotificationName:@"ShowFeedback"
                                    object:self];
                               }
                           }];
}

- (void)showDialogFailedLoginGamecenter
{
    [UIManager.i showDialogBlock:NSLocalizedString(@"Check internet and please restart this app. If the problem persists, please contact " SUPPORT_EMAIL @". Would you like to report this problem to us?", nil)
                           title:@""
                            type:2
                                :^(NSInteger index, NSString *text) {
                                    if (index == 1) //YES
                                    {
                                        [[NSNotificationCenter defaultCenter]
                                         postNotificationName:@"ShowFeedback"
                                         object:self];
                                    }
                                }];
}

- (void)invokeTutorial
{
    NSLog(@"InvokeTutorial");
    BOOL tutorial_is_on = [self is_tutorial_on];
    
    if (tutorial_is_on)
    {
        if (self.tutorialView == nil)
        {
            CGRect full_frame = CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height);
            self.tutorialView = [[TutorialView alloc] initWithFrame:full_frame];
            
            //Pre load items so it does not slow down the tutorial in the speedup part
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PreloadItems" object:self];
        }
        else
        {
            [self.tutorialView removeFromSuperview];
        }
        
        NSLog(@"firstViewControllerStack : %@", [UIManager.i firstViewControllerStack].title);
        [[UIManager.i firstViewControllerStack].view addSubview:self.tutorialView];
        
        [self.tutorialView updateView];
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:[NSNumber numberWithInteger:[Globals.i.wsWorldProfileDict[@"last_completed_tutorial_step"] integerValue]] forKey:@"last_completed_tutorial_step"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ContinueTutorial"
                                                            object:self
                                                          userInfo:userInfo];
        
        [self.tutorialView updateView];
    }
}

- (void)setupAllQueue
{
    [self flushTvStack];
    
    //Update time left in seconds for queue to end
    NSTimeInterval serverTimeInterval = [self updateTime];
    
    [self setupBuildQueue:serverTimeInterval];
    
    [self setupResearchQueue:serverTimeInterval];
    
    [self setupAttackQueue:serverTimeInterval];
    
    [self setupTradeQueue:serverTimeInterval];
    
    [self setupReinforceQueue:serverTimeInterval];
    
    [self setupTransferQueue:serverTimeInterval];
    
    [self setupHospitalQueue:serverTimeInterval];
    
    [self setupAQueue:serverTimeInterval];
    
    [self setupBQueue:serverTimeInterval];
    
    [self setupCQueue:serverTimeInterval];
    
    [self setupDQueue:serverTimeInterval];
    
    [self setupSpyQueue:serverTimeInterval];
    
    [self setupBoostR1Queue:serverTimeInterval];
    
    [self setupBoostR2Queue:serverTimeInterval];
    
    [self setupBoostR3Queue:serverTimeInterval];
    
    [self setupBoostR4Queue:serverTimeInterval];
    
    [self setupBoostR5Queue:serverTimeInterval];
    
    [self setupBoostAttackQueue:serverTimeInterval];
    
    [self setupBoostDefendQueue:serverTimeInterval];
    
}

- (void)setupBuildQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"build_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.buildUntil = [queueDate timeIntervalSince1970];
    Globals.i.buildQueue1 = Globals.i.buildUntil - serverTimeInterval;
}

- (void)setupResearchQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"research_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.researchUntil = [queueDate timeIntervalSince1970];
    Globals.i.researchQueue1 = Globals.i.researchUntil - serverTimeInterval;
    
    if (Globals.i.researchQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"research_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_RESEARCH];
        
        [self updateTv:TV_RESEARCH time:time title:title];
    }
}

- (void)setupAttackQueue:(NSTimeInterval)serverTimeInterval
{
    Globals.i.attackJobTime = [Globals.i.wsBaseDict[@"attack_job_time"] doubleValue];
    //NSLog(@"attack_job_time : %@",Globals.i.wsBaseDict[@"attack_job_time"]);
    
    NSString *strDate_AttackArrival = Globals.i.wsBaseDict[@"attack_queue"];
    NSDate *queueDate_arrive = [Globals.i dateParser:strDate_AttackArrival];
    NSTimeInterval queueTimeArrive = [queueDate_arrive timeIntervalSince1970];
    
    NSString *strDate_AttackEnd = Globals.i.wsBaseDict[@"attack_queue"];
    NSDate *queueDate_attackEnd = [Globals.i dateParser:strDate_AttackEnd];
    [queueDate_attackEnd dateByAddingTimeInterval:Globals.i.attackJobTime];
    NSTimeInterval queueTimeAttackEnd = [queueDate_attackEnd timeIntervalSince1970];
    
    NSString *strDate_AttackReturn = Globals.i.wsBaseDict[@"attack_return"];
    NSDate *queueDate_return = [Globals.i dateParser:strDate_AttackReturn];
    NSTimeInterval queueTimeReturn = [queueDate_return timeIntervalSince1970];
    
    NSInteger time = 0;
    NSString *title = [self fetchTimerViewTitle:TV_ATTACK];
    
    
    //before queueDate_arrive
    if (queueTimeArrive - serverTimeInterval > 0)
    {
        Globals.i.attackUntil = queueTimeArrive;
        Globals.i.attackQueue1 = Globals.i.attackUntil - serverTimeInterval;
        
        time = [Globals.i.wsBaseDict[@"attack_time"] integerValue];
        
        title = [NSString stringWithFormat:NSLocalizedString(@"Attacking %@", nil), title];
        [self updateTv:TV_ATTACK time:time title:title];
    }
    //before queueDate_attackEnd
    else if(queueTimeAttackEnd - serverTimeInterval > 0)//attacking
    {
        Globals.i.attackUntil = queueTimeAttackEnd;
        Globals.i.attackQueue1 = Globals.i.attackUntil - serverTimeInterval;
        
        time = [Globals.i.wsBaseDict[@"attack_job_time"] integerValue];
        
        title = [NSString stringWithFormat:NSLocalizedString(@"Battling at %@", nil), title];
        [self updateTv:TV_ATTACK time:time title:title];
    }
    else if(queueTimeReturn - serverTimeInterval > 0)//returning
    {
        Globals.i.attackUntil = queueTimeReturn;
        Globals.i.attackQueue1 = Globals.i.attackUntil - serverTimeInterval;
        
        time = [Globals.i.wsBaseDict[@"attack_time"] integerValue];
        
        title = [NSString stringWithFormat:NSLocalizedString(@"Returning from %@", nil), title];
        [self updateTv:TV_ATTACK time:time title:title];
    }
    else //ended
    {
        
    }
    
    
}

- (void)setupTradeQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"trade_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.tradeUntil = [queueDate timeIntervalSince1970];
    Globals.i.tradeQueue1 = Globals.i.tradeUntil - serverTimeInterval;
    
    if (Globals.i.tradeQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"trade_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_TRADE];
        
        [self updateTv:TV_TRADE time:time title:title];
    }
}

- (void)setupReinforceQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"reinforce_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.reinforceUntil = [queueDate timeIntervalSince1970];
    Globals.i.reinforceQueue1 = Globals.i.reinforceUntil - serverTimeInterval;
    
    if (Globals.i.reinforceQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"reinforce_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_REINFORCE];
        
        NSInteger reinforce_action = [self.wsBaseDict[@"reinforce_action"] integerValue];
        if (reinforce_action == 2) //pulling back reinforcements
        {
            [self updateTv:TV_REINFORCE time:time title:title is_return:YES will_return:NO];
        }
        else
        {
            [self updateTv:TV_REINFORCE time:time title:title];
        }
    }
}

- (void)setupTransferQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"transfer_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.transferUntil = [queueDate timeIntervalSince1970];
    Globals.i.transferQueue1 = Globals.i.transferUntil - serverTimeInterval;
    
    if (Globals.i.transferQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"transfer_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_TRANSFER];
        
        [self updateTv:TV_TRANSFER time:time title:title];
    }
}

- (void)setupHospitalQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"hospital_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.hospitalUntil = [queueDate timeIntervalSince1970];
    Globals.i.hospitalQueue1 = Globals.i.hospitalUntil - serverTimeInterval;
    
    if (Globals.i.hospitalQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"hospital_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_HEAL];
        
        [self updateTv:TV_HEAL time:time title:title];
    }
}

- (void)setupAQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"a_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.aUntil = [queueDate timeIntervalSince1970];
    Globals.i.aQueue1 = Globals.i.aUntil - serverTimeInterval;
    
    if (Globals.i.aQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"a_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_A];
        
        [self updateTv:TV_A time:time title:title];
    }
}

- (void)setupBQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"b_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.bUntil = [queueDate timeIntervalSince1970];
    Globals.i.bQueue1 = Globals.i.bUntil - serverTimeInterval;
    
    if (Globals.i.bQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"b_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_B];
        
        [self updateTv:TV_B time:time title:title];
    }
}

- (void)setupCQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"c_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.cUntil = [queueDate timeIntervalSince1970];
    Globals.i.cQueue1 = Globals.i.cUntil - serverTimeInterval;
    
    if (Globals.i.cQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"c_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_C];
        
        [self updateTv:TV_C time:time title:title];
    }
}

- (void)setupDQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"d_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.dUntil = [queueDate timeIntervalSince1970];
    Globals.i.dQueue1 = Globals.i.dUntil - serverTimeInterval;
    
    if (Globals.i.dQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"d_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_D];
        
        [self updateTv:TV_D time:time title:title];
    }
}

- (void)setupSpyQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"spy_queue"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.spyUntil = [queueDate timeIntervalSince1970];
    Globals.i.spyQueue1 = Globals.i.spyUntil - serverTimeInterval;
    
    if (Globals.i.spyQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"spy_time"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_SPY];
        
        [self updateTv:TV_SPY time:time title:title];
    }
}

- (void)setupBoostR1Queue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"item_r1_ending"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];

    Globals.i.boostR1Until = [queueDate timeIntervalSince1970];
    Globals.i.boostR1Queue1 = Globals.i.boostR1Until - serverTimeInterval;
    /*
    if (Globals.i.boostR1Queue1 > 0)
    {
        NSLog(@"Globals.i.boostR1Queue1 > 0");
        NSInteger time = [Globals.i.wsBaseDict[@"item_r1"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_BOOST_R1];
        
        [self updateTv:TV_BOOST_R1 time:time title:title];
    }
     */
}

- (void)setupBoostR2Queue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"item_r2_ending"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.boostR2Until = [queueDate timeIntervalSince1970];
    Globals.i.boostR2Queue1 = Globals.i.boostR2Until - serverTimeInterval;
    /*
    if (Globals.i.boostR2Queue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"item_r2"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_BOOST_R2];
        
        [self updateTv:TV_BOOST_R2 time:time title:title];
    }
     */
}

- (void)setupBoostR3Queue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"item_r3_ending"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.boostR3Until = [queueDate timeIntervalSince1970];
    Globals.i.boostR3Queue1 = Globals.i.boostR3Until - serverTimeInterval;
    /*
    if (Globals.i.boostR3Queue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"item_r3"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_BOOST_R3];
        
        [self updateTv:TV_BOOST_R3 time:time title:title];
    }
     */
}

- (void)setupBoostR4Queue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"item_r4_ending"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.boostR4Until = [queueDate timeIntervalSince1970];
    Globals.i.boostR4Queue1 = Globals.i.boostR4Until - serverTimeInterval;
    /*
    if (Globals.i.boostR4Queue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"item_r4"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_BOOST_R4];
        
        [self updateTv:TV_BOOST_R4 time:time title:title];
    }
     */
}

- (void)setupBoostR5Queue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"item_r5_ending"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.boostR5Until = [queueDate timeIntervalSince1970];
    Globals.i.boostR5Queue1 = Globals.i.boostR5Until - serverTimeInterval;
    /*
    if (Globals.i.boostR5Queue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"item_r5"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_BOOST_R5];
        
        [self updateTv:TV_BOOST_R5 time:time title:title];
    }
     */
}

- (void)setupBoostAttackQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"item_attack_ending"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.boostAttackUntil = [queueDate timeIntervalSince1970];
    Globals.i.boostAttackQueue1 = Globals.i.boostAttackUntil - serverTimeInterval;
    /*
    if (Globals.i.boostAttackQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"item_attack"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_BOOST_ATT];
        
        [self updateTv:TV_BOOST_ATT time:time title:title];
    }
     */
}

- (void)setupBoostDefendQueue:(NSTimeInterval)serverTimeInterval
{
    NSString *strDate = Globals.i.wsBaseDict[@"item_defense_ending"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    
    Globals.i.boostDefendUntil = [queueDate timeIntervalSince1970];
    Globals.i.boostDefendQueue1 = Globals.i.boostDefendUntil - serverTimeInterval;
    /*
    if (Globals.i.boostDefendQueue1 > 0)
    {
        NSInteger time = [Globals.i.wsBaseDict[@"item_defend"] integerValue];
        NSString *title = [self fetchTimerViewTitle:TV_BOOST_DEF];
        
        [self updateTv:TV_BOOST_DEF time:time title:title];
    }
     */
}

- (void)addBaseResources:(NSString *)base_id :(double)ar1 :(double)ar2 :(double)ar3 :(double)ar4 :(double)ar5
{
    double r1 = [self.wsBaseDict[@"r1"] doubleValue];
    double r2 = [self.wsBaseDict[@"r2"] doubleValue];
    double r3 = [self.wsBaseDict[@"r3"] doubleValue];
    double r4 = [self.wsBaseDict[@"r4"] doubleValue];
    double r5 = [self.wsBaseDict[@"r5"] doubleValue];
    
    r1 = r1 + ar1;
    if(r1<0)
    {
        r1=0;
    }
    
    r2 = r2 + ar2;
    if(r2<0)
    {
        r2=0;
    }
    
    r3 = r3 + ar3;
    if(r3<0)
    {
        r3=0;
    }
    
    r4 = r4 + ar4;
    if(r4<0)
    {
        r4=0;
    }
    
    r5 = r5 + ar5;
    if(r5<0)
    {
        r5=0;
    }
    
    self.base_r1 = r1;
    self.wsBaseDict[@"r1"] = [@(self.base_r1) stringValue];
    self.base_r2 = r2;
    self.wsBaseDict[@"r2"] = [@(self.base_r2) stringValue];
    self.base_r3 = r3;
    self.wsBaseDict[@"r3"] = [@(self.base_r3) stringValue];
    self.base_r4 = r4;
    self.wsBaseDict[@"r4"] = [@(self.base_r4) stringValue];
    self.base_r5 = r5;
    self.wsBaseDict[@"r5"] = [@(self.base_r5) stringValue];
}

- (void)addTo:(NSInteger)type time:(NSInteger)time base_id:(NSString *)base_id title:(NSString *)title img:(NSString *)img dict:(NSDictionary *)dict
{
    if (type == TO_TRADE)
    {
        double r1 = [dict[@"r1"] doubleValue];
        double r2 = [dict[@"r2"] doubleValue];
        double r3 = [dict[@"r3"] doubleValue];
        double r4 = [dict[@"r4"] doubleValue];
        double r5 = [dict[@"r5"] doubleValue];
        
        if (r1 > 0 || r2 > 0 || r3 > 0 || r4 > 0 || r5 > 0)
        {
            [self addBaseResources:base_id :r1*-1 :r2*-1 :r3*-1 :r4*-1 :r5*-1];
        }
    }
    
    TimerObject *to = [[TimerObject alloc] init];
    to.type = type;
    to.timer1 = time;
    to.base_id = base_id;
    to.str_title = title;
    to.str_image = img;
    to.dict = dict;
    
    [to updateView];
    
    [self.toStack addObject:to];
}

- (void)flushToStack
{
    if (self.toStack == nil)
    {
        self.toStack = [[NSMutableArray alloc] init];
    }
    else
    {
        for (TimerObject *to in self.toStack)
        {
            [to destroy];
        }
        
        self.toStack = [[NSMutableArray alloc] init];
    }
}

- (void)flushToStackType:(NSInteger)type
{
    if (self.toStack != nil)
    {
        NSInteger rowRemoved = 999;
        for (NSInteger i = 0; i < [self.toStack count]; i++)
        {
            if ([(TimerObject *)self.toStack[i] type] == type)
            {
                rowRemoved = i;
                [(TimerObject *)self.toStack[i] destroy];
                [self.toStack removeObjectAtIndex:i];
            }
        }
    }
}

- (NSMutableArray *)getToStackType:(NSInteger)type
{
    NSMutableArray *timer_objects = [[NSMutableArray alloc] init];
    
    if (self.toStack != nil)
    {
        for (NSInteger i = 0; i < [self.toStack count]; i++)
        {
            if ([(TimerObject *)self.toStack[i] type] == type)
            {
                [timer_objects addObject:self.toStack[i]];
            }
        }
    }
    
    return timer_objects;
}

- (NSMutableArray *)getToStackTransfer:(NSString *)base_id
{
    NSMutableArray *timer_objects = [[NSMutableArray alloc] init];
    
    if (self.toStack != nil)
    {
        for (NSInteger i = 0; i < [self.toStack count]; i++)
        {
            if ([(TimerObject *)self.toStack[i] type] == TO_TRANSFER)
            {
                NSString *to_baseid = [(TimerObject *)self.toStack[i] base_id];
                if ([to_baseid isEqualToString:base_id])
                {
                    [timer_objects addObject:self.toStack[i]];
                }
            }
        }
    }
    
    return timer_objects;
}

#pragma mark - END TimerViewStack

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

- (CGFloat)distance2xy:(CGFloat)from_x :(CGFloat)from_y :(CGFloat)to_x :(CGFloat)to_y
{
    CGFloat distX = to_x - from_x;
    CGFloat distY = to_y - from_y;
    
    CGFloat distXY = sqrt((distX * distX) + (distY * distY));
    
    return distXY;
}

- (CGFloat)distance2points:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint
{
    return [self distance2xy:startingPoint.x :startingPoint.y :endingPoint.x :endingPoint.y];
}

- (CGFloat)pointPairToBearingRadians:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    
    return bearingRadians;
}

- (NSString *)numberString:(NSNumber *)val
{
    //NSLog(@"val : %@",val);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedOutput = [formatter stringFromNumber:val];
    //NSLog(@"number formattted : %@",formattedOutput);
    if (formattedOutput == nil)
    {
        formattedOutput = [val stringValue];
    }
    //NSLog(@"number formattted 2nd: %@",formattedOutput);
    return formattedOutput;
}

- (NSString *)intString:(NSInteger)val
{
    NSNumber *number = @(val);
    
    return [self numberString:number];
}

- (NSString *)uintString:(NSUInteger)val
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
    val = [val stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    NSNumber *number = [NSNumber numberWithInteger:[val integerValue]];
    
    return [self numberString:number];
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
    
    NSString *decimal = [[NSLocale currentLocale] objectForKey:NSLocaleDecimalSeparator];
    //NSLog(@"Decimal type is : %@", decimal);
    
    if ([decimal isEqualToString:@","])
    {
        shortformNumber = [shortformNumber stringByReplacingOccurrencesOfString:@"." withString:@","];
    }
    
    return shortformNumber;
}

- (NSString *)BoolToBit:(NSString *)boolString
{
    if ([boolString isEqualToString:@"True"])
    {
        return @"1";
    }
    else
    {
        return @"0";
    }
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

- (void)checkVersion
{
    if (self.wsIdentifierDict != nil)
    {
        float latest_version = [self.wsIdentifierDict[@"latest_version"] floatValue];
        float this_version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
        
        if (latest_version > this_version)
        {
            [UIManager.i showDialogBlock:NSLocalizedString(@"New Version Available. Upgrade to latest version?", nil)
                            title:@""
                             type:2
                                 :^(NSInteger index, NSString *text)
             {
                 if (index == 1) //YES
                 {
                     NSString *str_url = self.wsIdentifierDict[@"url_app"];
                     NSLog(@"%@", str_url);
                     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str_url]];
                 }
             }];
        }
    }
}

- (void)resetLoginReminderNotification
{
    //Create new future notifcations for 3 days, 7 days and 15 days
    if (self.loginNotification == nil)
    {
        self.loginNotification = [[UILocalNotification alloc] init];
    }
    self.loginNotification.timeZone = [NSTimeZone defaultTimeZone];
    self.loginNotification.soundName = @"sfx_notification.mp3";
    NSDictionary *userDict = @{@"ID": @"login_reminder"};
    self.loginNotification.userInfo = userDict;
    
    self.loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*3];
    self.loginNotification.alertBody = NSLocalizedString(@"Your people miss you! It's been 3 days since they last saw you. Login now and catch up with them.", nil);
    [[UIApplication sharedApplication] scheduleLocalNotification:self.loginNotification];
    
    self.loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*7];
    self.loginNotification.alertBody = NSLocalizedString(@"Your people miss you! It's been a week since they last saw you. Login now and catch up with them.", nil);
    [[UIApplication sharedApplication] scheduleLocalNotification:self.loginNotification];
    
    self.loginNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*15];
    self.loginNotification.alertBody = NSLocalizedString(@"Your people miss you! It's been 2 weeks since they last saw you. Login now and catch up with them.", nil);
    [[UIApplication sharedApplication] scheduleLocalNotification:self.loginNotification];
}

- (NSString *)getFirstUILogString
{
    NSString *message;
    
    NSInteger i = [self.wsLogFullArray count];
    
    if (i > 1)
    {
        NSDictionary *row1 = self.wsLogFullArray[i-2];
        
        message = [NSString stringWithFormat:@"Log : %@",
                   row1[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getSecondUILogString
{
    NSString *message;
    
    NSInteger i = [self.wsLogFullArray count];
    
    if (i > 0)
    {
        NSDictionary *row1 = self.wsLogFullArray[i-1];
        
        message = [NSString stringWithFormat:@"Log: %@",
                   row1[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getFirstChatString
{
    NSString *message;
    
    NSInteger i = [self.wsChatFullArray count];
    
    if (i > 1)
    {
        NSDictionary *row1 = self.wsChatFullArray[i-2];
        
        NSString *r1 = row1[@"profile_name"];
        if ([row1[@"alliance_tag"] length] > 2)
        {
            r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
        }
        
        message = [NSString stringWithFormat:@"%@: %@",
                   r1,
                   row1[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}


- (NSString *)getSecondChatString
{
    NSString *message;
    
    NSInteger i = [self.wsChatFullArray count];
    
    if (i > 0)
    {
        NSDictionary *row1 = self.wsChatFullArray[i-1];
        
        NSString *r1 = row1[@"profile_name"];
        if ([row1[@"alliance_tag"] length] > 2)
        {
            r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
        }
        
        message = [NSString stringWithFormat:@"%@: %@",
                   r1,
                   row1[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getFirstAllianceChatString
{
    NSString *message;
    
    NSInteger i = [self.wsAllianceChatFullArray count];
    
    if (i > 1)
    {
        NSDictionary *row1 = self.wsAllianceChatFullArray[i-2];
        
        NSString *r1 = row1[@"profile_name"];
        if ([row1[@"alliance_tag"] length] > 2)
        {
            r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
        }
        
        message = [NSString stringWithFormat:@"%@: %@",
                   r1,
                   row1[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getSecondAllianceChatString
{
    NSString *message;
    
    NSInteger i = [self.wsAllianceChatFullArray count];
    
    if (i > 0)
    {
        NSDictionary *row1 = self.wsAllianceChatFullArray[i-1];
        
        NSString *r1 = row1[@"profile_name"];
        if ([row1[@"alliance_tag"] length] > 2)
        {
            r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
        }
        
        message = [NSString stringWithFormat:@"%@: %@",
                   r1,
                   row1[@"message"]];
    }
    else
    {
        message = @"";
    }
    
    return message;
}

- (NSString *)getLastChatID
{
    NSInteger i = [self.wsChatFullArray count];
    if (i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else if (i > 0)
    {
        NSDictionary *rowData = self.wsChatFullArray[i-1];
        return rowData[@"chat_id"];
    }
    
    return @"0";
}

- (NSString *)getLastAllianceChatID
{
    NSInteger i = [self.wsAllianceChatFullArray count];
    if (i == 0)
    {
        return @"0"; //tells server to fetch most current
    }
    else if (i > 0)
    {
        NSDictionary *rowData = self.wsAllianceChatFullArray[i-1];
        return rowData[@"chat_id"];
    }
    
    return @"0";
}

- (void)allianceApply:(NSString *)alliance_id
{
    if (self.alliance_applied == nil)
    {
        self.alliance_applied = [[NSMutableArray alloc] init];
    }
    
    [self.alliance_applied addObject:alliance_id];
}

- (BOOL)is_allianceApplied:(NSString *)alliance_id
{
    BOOL ret = NO;
    
    for (NSString *aid in self.alliance_applied)
    {
        if ([aid isEqualToString:alliance_id])
        {
            ret = YES;
        }
    }
    
    return ret;
}

- (NSString *)getDtoken
{
    self.devicetoken = [[NSUserDefaults standardUserDefaults] objectForKey:@"Devicetoken"];
    if (self.devicetoken == nil)
    {
        self.devicetoken = @"0";
    }
    
    return self.devicetoken;
}

- (void)setDtoken:(NSString *)dt
{
    self.devicetoken = dt;
    [[NSUserDefaults standardUserDefaults] setObject:self.devicetoken forKey:@"Devicetoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLat
{
    self.latitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"];
    if (self.latitude == nil)
    {
        self.latitude = @"0";
    }
    
    return self.latitude;
}

- (void)setLat:(NSString *)lat
{
    self.latitude = lat;
    [[NSUserDefaults standardUserDefaults] setObject:self.latitude forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLongi
{
    self.longitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"];
    if (self.longitude == nil)
    {
        self.longitude = @"0";
    }
    
    return self.longitude;
}

- (void)setLongi:(NSString *)longi
{
    self.longitude = longi;
    [[NSUserDefaults standardUserDefaults] setObject:self.longitude forKey:@"Longitude"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettPurchasedProduct
{
    self.purchasedProductString = [[NSUserDefaults standardUserDefaults] objectForKey:@"PurchasedProduct"];
    if (self.purchasedProductString == nil)
    {
        self.purchasedProductString = @"0";
    }
    
    return self.purchasedProductString;
}

- (void)settPurchasedProduct:(NSString *)type
{
    self.purchasedProductString = type;
    [[NSUserDefaults standardUserDefaults] setObject:self.purchasedProductString forKey:@"PurchasedProduct"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)gettPurchasedGems
{
    self.purchasedGemsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"PurchasedGems"];
    if (self.purchasedGemsString == nil)
    {
        self.purchasedGemsString = @"0";
    }
    
    return self.purchasedGemsString;
}

- (void)settPurchasedGems:(NSString *)type
{
    self.purchasedGemsString = type;
    [[NSUserDefaults standardUserDefaults] setObject:self.purchasedGemsString forKey:@"PurchasedGems"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//MAIL
- (void)updateMail
{
    //Get all mail from mail_id=0 because need to see if there is reply
    NSString *service_name = @"GetMail";
    
    NSString *wsurl = [NSString stringWithFormat:@"/0/%@/%@",
                       Globals.i.wsWorldProfileDict[@"profile_id"],
                       Globals.i.wsWorldProfileDict[@"alliance_id"]];
    
    [Globals.i getServer:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 Globals.i.wsMailArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                 
                 [Globals.i addLocalMailData:Globals.i.wsMailArray];
             }
             else //return is not an array
             {
                 [Globals.i trackEvent:@"Not Array Type" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
             }
         }
     }];
}

- (NSDictionary *)gettLocalMailReply
{
    self.localMailReplyDict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"MailReply"];
    if (self.localMailReplyDict == nil)
    {
        self.localMailReplyDict = [[NSDictionary alloc] init];
    }
    
    return self.localMailReplyDict;
}

- (void)settLocalMailReply:(NSDictionary *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:[[NSDictionary alloc] initWithDictionary:rd copyItems:YES] forKey:@"MailReply"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)findMailReply:(NSString *)mail_id
{
    self.localMailReplyDict = [self gettLocalMailReply];
    
    return [self.localMailReplyDict objectForKey:mail_id];
}

- (void)addMailReply:(NSString *)mail_id :(NSArray *)mail_reply
{
    self.localMailReplyDict = [self gettLocalMailReply];
    NSMutableDictionary *mdReply = [[NSMutableDictionary alloc] initWithDictionary:self.localMailReplyDict copyItems:YES];
    [mdReply setObject:mail_reply forKey:mail_id];
    
    [self settLocalMailReply:mdReply];
}

- (void)deleteLocalMail:(NSString *)mail_id
{
    self.localMailReplyDict = [self gettLocalMailReply];
    
    if ([self.localMailReplyDict count] > 0)
    {
        NSMutableDictionary *mdReply = [[NSMutableDictionary alloc] initWithDictionary:self.localMailReplyDict copyItems:YES];
        [mdReply removeObjectForKey:mail_id];
        [self settLocalMailReply:mdReply];
    }
    
    self.localMailArray = [self gettLocalMailData];
    NSInteger count = [self.localMailArray count];
    NSInteger index_to_remove = -1;
    for (NSUInteger i = 0; i < count; i++)
    {
        if ([self.localMailArray[i][@"mail_id"] isEqualToString:mail_id])
        {
            index_to_remove = i;
        }
    }
    
    if (index_to_remove > -1)
    {
        [self.localMailArray removeObjectAtIndex:index_to_remove];
        [self settLocalMailData:self.localMailArray];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailView" object:self];
    }
}

- (void)replyCounterPlus:(NSString *)mail_id
{
    self.localMailArray = [self gettLocalMailData];
    NSInteger count = [self.localMailArray count];
    
    for (NSUInteger i = 0; i < count; i++)
    {
        if ([self.localMailArray[i][@"mail_id"] isEqualToString:mail_id])
        {
            NSInteger rcounter = [self.localMailArray[i][@"reply_counter"] intValue] + 1;
            self.localMailArray[i][@"reply_counter"] = [@(rcounter) stringValue];
            
            [self settLocalMailData:self.localMailArray];
        }
    }
}

- (NSString *)gettLastMailId
{
    self.lastMailId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Mailid"];
    if (self.lastMailId == nil)
    {
        self.lastMailId = @"0";
    }
    
    return self.lastMailId;
}

- (void)settLastMailId:(NSString *)mid
{
    self.lastMailId = mid;
    [[NSUserDefaults standardUserDefaults] setObject:self.lastMailId forKey:@"Mailid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSMutableArray *)gettLocalMailData
{
    NSMutableArray *fullMutable = [[NSMutableArray alloc] init];
    
    NSArray *lclMail = [[NSUserDefaults standardUserDefaults] arrayForKey:@"MailData"];
    if (lclMail.count > 0)
    {
        for (NSDictionary *obj in lclMail)
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

- (void)settLocalMailData:(NSMutableArray *)rd
{
    [[NSUserDefaults standardUserDefaults] setObject:rd forKey:@"MailData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailBadge" object:self];
}

- (void)addLocalMailData:(NSMutableArray *)rd
{
    self.localMailArray = [self gettLocalMailData];
    
    //Check old mails if there is any replies
    for (NSUInteger i = 0; i < [self.localMailArray count]; i++)
    {
        NSString *local_mail_id = self.localMailArray[i][@"mail_id"];
        
        //Search newly fetched mail for match with local mail
        for (NSUInteger j = 0; j < [rd count]; j++)
        {
            if ([rd[j][@"mail_id"] isEqualToString:local_mail_id]) //Match found
            {
                NSUInteger newmail_reply_counter = [rd[j][@"reply_counter"] integerValue];
                NSUInteger oldmail_reply_counter = [self.localMailArray[i][@"reply_counter"] integerValue];
                
                //Reply counter is bigger
                if (newmail_reply_counter > oldmail_reply_counter)
                {
                    self.localMailArray[i][@"open_read"] = @"0"; //Set as not read
                    self.localMailArray[i][@"reply_counter"] = [@(newmail_reply_counter) stringValue]; //update reply_counter
                }
            }
        }
    }
    
    //Add new mails to top of localMailArray
    for (NSInteger i = 0; i < [rd count]; i++)
    {
        if ([rd[i][@"mail_id"] integerValue] > [[self gettLastMailId] integerValue])
        {
            [self.localMailArray insertObject:rd[i] atIndex:0];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.localMailArray forKey:@"MailData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"UpdateMailBadge"
     object:self];
    
    NSString *m_id = (rd)[0][@"mail_id"];
    [Globals.i settLastMailId:m_id];
}

- (BOOL)setMailNotRead:(NSString *)mail_id
{
    BOOL result = NO;
    
    self.localMailArray = [self gettLocalMailData];
    
    for (NSUInteger i = 0; i < [self.localMailArray count]; i++)
    {
        NSString *local_mail_id = self.localMailArray[i][@"mail_id"];
        if ([local_mail_id isEqualToString:mail_id]) //Match found
        {
            result = YES;
            NSInteger replycount = [self.localMailArray[i][@"reply_counter"] integerValue] + 1;
            self.localMailArray[i][@"open_read"] = @"0"; //Set as not read
            self.localMailArray[i][@"reply_counter"] = [@(replycount) stringValue]; //update reply_counter
            
            NSDictionary *replyRow = [[NSDictionary alloc] initWithDictionary:self.localMailArray[i] copyItems:YES];
            [self.localMailArray removeObjectAtIndex:i];
            [self.localMailArray insertObject:replyRow atIndex:0]; //Move to the top
        }
    }
    
    if (result)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.localMailArray forKey:@"MailData"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}

- (void)updateMailReply:(NSString *)mail_id
{
    NSString *service_name = @"GetMailReply";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       mail_id];
    
    [self getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 if (returnArray.count > 0)
                 {
                     self.wsMailReplyArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                         
                     [self addMailReply:mail_id :self.wsMailReplyArray];
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateMailDetail"
                                                                             object:self
                                                                           userInfo:nil];
                 }
                 else //return is not an array
                 {
                     [Globals.i trackEvent:@"Not Array Type" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
                 }
                 
             }
         });
     }];
}

- (NSInteger)getMailBadgeNumber
{
    NSInteger count = 0;
    
    NSArray *lclMail = [[NSUserDefaults standardUserDefaults] arrayForKey:@"MailData"];
    if ([lclMail count] > 0)
    {
        for (NSDictionary *rowData in lclMail)
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

// Reports
- (void)updateReports:(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    NSString *service_name = @"GetReport";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@",
                       self.world_url,
                       service_name,
                       [self gettLastReportId],
                       self.wsWorldProfileDict[@"profile_id"],
                       self.wsWorldProfileDict[@"alliance_id"]];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
              
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      Globals.i.wsReportArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                          
                      [Globals.i addLocalReportData:Globals.i.wsReportArray];
                          
                      NSString *r_id = (Globals.i.wsReportArray)[0][@"report_id"];
                      [Globals.i settLastReportId:r_id];
                  }
                  else //return is not an array
                  {
                      [Globals.i trackEvent:@"Not Array Type" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
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
    if (self.serverTimeInterval > 0)
    {
        NSTimeInterval elapsed = [self.timerStartDate timeIntervalSinceNow];
        self.serverTimeInterval = self.startServerTimeInterval - elapsed;
    }
    
    if (self.wsBaseDict != nil)
    {
        double r1 = [self.wsBaseDict[@"r1"] doubleValue];
        double r2 = [self.wsBaseDict[@"r2"] doubleValue];
        double r3 = [self.wsBaseDict[@"r3"] doubleValue];
        double r4 = [self.wsBaseDict[@"r4"] doubleValue];
        double r5 = [self.wsBaseDict[@"r5"] doubleValue];
        
        double r1_production = [self.wsBaseDict[@"r1_production"] doubleValue] / 3600.0;
        double r1_capacity = [self.wsBaseDict[@"r1_capacity"] doubleValue];
        
        double r2_production = [self.wsBaseDict[@"r2_production"] doubleValue] / 3600.0;
        double r2_capacity = [self.wsBaseDict[@"r2_capacity"] doubleValue];
        
        double r3_production = [self.wsBaseDict[@"r3_production"] doubleValue] / 3600.0;
        double r3_capacity = [self.wsBaseDict[@"r3_capacity"] doubleValue];
        
        double r4_production = [self.wsBaseDict[@"r4_production"] doubleValue] / 3600.0;
        double r4_capacity = [self.wsBaseDict[@"r4_capacity"] doubleValue];
        
        double r5_production = [self.wsBaseDict[@"r5_production"] doubleValue] / 3600.0;
        double r5_capacity = [self.wsBaseDict[@"r5_capacity"] doubleValue];
        
        
        if (r1 < r1_capacity)
        {
            r1 = r1 + r1_production;
        }
        if (r1 < 0) //Food should not be negative
        {
            r1 = 0;
        }
        
        if (r2 < r2_capacity)
        {
            r2 = r2 + r2_production;
        }
        
        if (r3 < r3_capacity)
        {
            r3 = r3 + r3_production;
        }
        
        if (r4 < r4_capacity)
        {
            r4 = r4 + r4_production;
        }
        
        if (r5 < r5_capacity)
        {
            r5 = r5 + r5_production;
        }
        
        self.wsBaseDict[@"r1"] = [@(r1) stringValue];
        self.wsBaseDict[@"r2"] = [@(r2) stringValue];
        self.wsBaseDict[@"r3"] = [@(r3) stringValue];
        self.wsBaseDict[@"r4"] = [@(r4) stringValue];
        self.wsBaseDict[@"r5"] = [@(r5) stringValue];
        
        //Reduce TimerViews Queue
        Globals.i.buildQueue1 = Globals.i.buildUntil - self.serverTimeInterval;
        Globals.i.researchQueue1 = Globals.i.researchUntil - self.serverTimeInterval;
        Globals.i.attackQueue1 = Globals.i.attackUntil - self.serverTimeInterval;
        Globals.i.tradeQueue1 = Globals.i.tradeUntil - self.serverTimeInterval;
        
        
        
        NSInteger a1 = [self.wsBaseDict[@"a1"] integerValue];
        NSInteger a2 = [self.wsBaseDict[@"a2"] integerValue];
        NSInteger a3 = [self.wsBaseDict[@"a3"] integerValue];
        NSInteger b1 = [self.wsBaseDict[@"b1"] integerValue];
        NSInteger b2 = [self.wsBaseDict[@"b2"] integerValue];
        NSInteger b3 = [self.wsBaseDict[@"b3"] integerValue];
        NSInteger c1 = [self.wsBaseDict[@"c1"] integerValue];
        NSInteger c2 = [self.wsBaseDict[@"c2"] integerValue];
        NSInteger c3 = [self.wsBaseDict[@"c3"] integerValue];
        NSInteger d1 = [self.wsBaseDict[@"d1"] integerValue];
        NSInteger d2 = [self.wsBaseDict[@"d2"] integerValue];
        NSInteger d3 = [self.wsBaseDict[@"d3"] integerValue];
        
        //Training
        self.t_a1 = [self.wsBaseDict[@"t_a1"] integerValue];
        self.t_a2 = [self.wsBaseDict[@"t_a2"] integerValue];
        self.t_a3 = [self.wsBaseDict[@"t_a3"] integerValue];
        self.t_b1 = [self.wsBaseDict[@"t_b1"] integerValue];
        self.t_b2 = [self.wsBaseDict[@"t_b2"] integerValue];
        self.t_b3 = [self.wsBaseDict[@"t_b3"] integerValue];
        self.t_c1 = [self.wsBaseDict[@"t_c1"] integerValue];
        self.t_c2 = [self.wsBaseDict[@"t_c2"] integerValue];
        self.t_c3 = [self.wsBaseDict[@"t_c3"] integerValue];
        self.t_d1 = [self.wsBaseDict[@"t_d1"] integerValue];
        self.t_d2 = [self.wsBaseDict[@"t_d2"] integerValue];
        self.t_d3 = [self.wsBaseDict[@"t_d3"] integerValue];
        
        //Hospitalized
        self.h_a1 = [self.wsBaseDict[@"h_a1"] integerValue];
        self.h_a2 = [self.wsBaseDict[@"h_a2"] integerValue];
        self.h_a3 = [self.wsBaseDict[@"h_a3"] integerValue];
        self.h_b1 = [self.wsBaseDict[@"h_b1"] integerValue];
        self.h_b2 = [self.wsBaseDict[@"h_b2"] integerValue];
        self.h_b3 = [self.wsBaseDict[@"h_b3"] integerValue];
        self.h_c1 = [self.wsBaseDict[@"h_c1"] integerValue];
        self.h_c2 = [self.wsBaseDict[@"h_c2"] integerValue];
        self.h_c3 = [self.wsBaseDict[@"h_c3"] integerValue];
        self.h_d1 = [self.wsBaseDict[@"h_d1"] integerValue];
        self.h_d2 = [self.wsBaseDict[@"h_d2"] integerValue];
        self.h_d3 = [self.wsBaseDict[@"h_d3"] integerValue];
        
        //Injured
        self.i_a1 = [self.wsBaseDict[@"i_a1"] integerValue];
        self.i_a2 = [self.wsBaseDict[@"i_a2"] integerValue];
        self.i_a3 = [self.wsBaseDict[@"i_a3"] integerValue];
        self.i_b1 = [self.wsBaseDict[@"i_b1"] integerValue];
        self.i_b2 = [self.wsBaseDict[@"i_b2"] integerValue];
        self.i_b3 = [self.wsBaseDict[@"i_b3"] integerValue];
        self.i_c1 = [self.wsBaseDict[@"i_c1"] integerValue];
        self.i_c2 = [self.wsBaseDict[@"i_c2"] integerValue];
        self.i_c3 = [self.wsBaseDict[@"i_c3"] integerValue];
        self.i_d1 = [self.wsBaseDict[@"i_d1"] integerValue];
        self.i_d2 = [self.wsBaseDict[@"i_d2"] integerValue];
        self.i_d3 = [self.wsBaseDict[@"i_d3"] integerValue];
        
        //Reinforcing
        self.r_a1 = [self.wsBaseDict[@"r_a1"] integerValue];
        self.r_a2 = [self.wsBaseDict[@"r_a2"] integerValue];
        self.r_a3 = [self.wsBaseDict[@"r_a3"] integerValue];
        self.r_b1 = [self.wsBaseDict[@"r_b1"] integerValue];
        self.r_b2 = [self.wsBaseDict[@"r_b2"] integerValue];
        self.r_b3 = [self.wsBaseDict[@"r_b3"] integerValue];
        self.r_c1 = [self.wsBaseDict[@"r_c1"] integerValue];
        self.r_c2 = [self.wsBaseDict[@"r_c2"] integerValue];
        self.r_c3 = [self.wsBaseDict[@"r_c3"] integerValue];
        self.r_d1 = [self.wsBaseDict[@"r_d1"] integerValue];
        self.r_d2 = [self.wsBaseDict[@"r_d2"] integerValue];
        self.r_d3 = [self.wsBaseDict[@"r_d3"] integerValue];
        
        if (Globals.i.hospitalQueue1 > 0)
        {
            Globals.i.hospitalQueue1 = Globals.i.hospitalUntil - self.serverTimeInterval;
        }
        else //when hospital queue is over, it reduces the injured amount
        {
            self.i_a1 = self.i_a1 - self.h_a1;
            self.i_a2 = self.i_a2 - self.h_a2;
            self.i_a3 = self.i_a3 - self.h_a3;
            self.i_b1 = self.i_b1 - self.h_b1;
            self.i_b2 = self.i_b2 - self.h_b2;
            self.i_b3 = self.i_b3 - self.h_b3;
            self.i_c1 = self.i_c1 - self.h_c1;
            self.i_c2 = self.i_c2 - self.h_c2;
            self.i_c3 = self.i_c3 - self.h_c3;
            self.i_d1 = self.i_d1 - self.h_d1;
            self.i_d2 = self.i_d2 - self.h_d2;
            self.i_d3 = self.i_d3 - self.h_d3;
        }
        
        if (Globals.i.aQueue1 > 0)
        {
            Globals.i.aQueue1 = Globals.i.aUntil - self.serverTimeInterval;
        }
        else
        {
            a1 = a1 + self.t_a1;
            a2 = a2 + self.t_a2;
            a3 = a3 + self.t_a3;
        }
        
        if (Globals.i.bQueue1 > 0)
        {
            Globals.i.bQueue1 = Globals.i.bUntil - self.serverTimeInterval;
        }
        else
        {
            b1 = b1 + self.t_b1;
            b2 = b2 + self.t_b2;
            b3 = b3 + self.t_b3;
        }
        
        if (Globals.i.cQueue1 > 0)
        {
            Globals.i.cQueue1 = Globals.i.cUntil - self.serverTimeInterval;
        }
        else
        {
            c1 = c1 + self.t_c1;
            c2 = c2 + self.t_c2;
            c3 = c3 + self.t_c3;
        }
        
        if (Globals.i.dQueue1 > 0)
        {
            Globals.i.dQueue1 = Globals.i.dUntil - self.serverTimeInterval;
        }
        else
        {
            d1 = d1 + self.t_d1;
            d2 = d2 + self.t_d2;
            d3 = d3 + self.t_d3;
        }
        
        if (Globals.i.spyQueue1 > 0)
        {
            Globals.i.spyQueue1 = Globals.i.spyUntil - self.serverTimeInterval;
        }
        else
        {
            //TODO: add spy
            //spy = spy + self.t_spy;
        }
        
        if (Globals.i.reinforceQueue1 > 0)
        {
            Globals.i.reinforceQueue1 = Globals.i.reinforceUntil - self.serverTimeInterval;
            
            NSInteger reinforce_action = [self.wsBaseDict[@"reinforce_action"] integerValue];
            if (reinforce_action == 2) //pulling back reinforcements
            {
                NSInteger rt_a1 = [self.wsBaseDict[@"rt_a1"] integerValue];
                NSInteger rt_a2 = [self.wsBaseDict[@"rt_a2"] integerValue];
                NSInteger rt_a3 = [self.wsBaseDict[@"rt_a3"] integerValue];
                NSInteger rt_b1 = [self.wsBaseDict[@"rt_b1"] integerValue];
                NSInteger rt_b2 = [self.wsBaseDict[@"rt_b2"] integerValue];
                NSInteger rt_b3 = [self.wsBaseDict[@"rt_b3"] integerValue];
                NSInteger rt_c1 = [self.wsBaseDict[@"rt_c1"] integerValue];
                NSInteger rt_c2 = [self.wsBaseDict[@"rt_c2"] integerValue];
                NSInteger rt_c3 = [self.wsBaseDict[@"rt_c3"] integerValue];
                NSInteger rt_d1 = [self.wsBaseDict[@"rt_d1"] integerValue];
                NSInteger rt_d2 = [self.wsBaseDict[@"rt_d2"] integerValue];
                NSInteger rt_d3 = [self.wsBaseDict[@"rt_d3"] integerValue];
                
                self.r_a1 = self.r_a1 + rt_a1;
                self.r_a2 = self.r_a2 + rt_a2;
                self.r_a3 = self.r_a3 + rt_a3;
                self.r_b1 = self.r_b1 + rt_b1;
                self.r_b2 = self.r_b2 + rt_b2;
                self.r_b3 = self.r_b3 + rt_b3;
                self.r_c1 = self.r_c1 + rt_c1;
                self.r_c2 = self.r_c2 + rt_c2;
                self.r_c3 = self.r_c3 + rt_c3;
                self.r_d1 = self.r_d1 + rt_d1;
                self.r_d2 = self.r_d2 + rt_d2;
                self.r_d3 = self.r_d3 + rt_d3;
            }
        }
        
        if (Globals.i.transferQueue1 > 0)
        {
            Globals.i.transferQueue1 = Globals.i.transferUntil - self.serverTimeInterval;
        }
        
        self.transfered_a1 = 0;
        self.transfered_a2 = 0;
        self.transfered_a3 = 0;
        
        self.transfered_b1 = 0;
        self.transfered_b2 = 0;
        self.transfered_b3 = 0;
        
        self.transfered_c1 = 0;
        self.transfered_c2 = 0;
        self.transfered_c3 = 0;
        
        self.transfered_d1 = 0;
        self.transfered_d2 = 0;
        self.transfered_d3 = 0;
        
        NSMutableArray *to_transfers = [self getToStackTransfer:self.wsBaseDict[@"base_id"]];
        for (NSDictionary *to in to_transfers)
        {
            NSDictionary *dict = [(TimerObject *)to dict];
            
            self.transfered_a1 = [dict[Globals.i.a1] integerValue];
            self.transfered_b1 = [dict[Globals.i.b1] integerValue];
            self.transfered_c1 = [dict[Globals.i.c1] integerValue];
            self.transfered_d1 = [dict[Globals.i.d1] integerValue];
            
            self.transfered_a2 = [dict[Globals.i.a2] integerValue];
            self.transfered_b2 = [dict[Globals.i.b2] integerValue];
            self.transfered_c2 = [dict[Globals.i.c2] integerValue];
            self.transfered_d2 = [dict[Globals.i.d2] integerValue];
            
            self.transfered_a3 = [dict[Globals.i.a3] integerValue];
            self.transfered_b3 = [dict[Globals.i.b3] integerValue];
            self.transfered_c3 = [dict[Globals.i.c3] integerValue];
            self.transfered_d3 = [dict[Globals.i.d3] integerValue];
        }
        
        //Attacking survived
        self.a_r1 = 0;
        self.a_r2 = 0;
        self.a_r3 = 0;
        self.a_r4 = 0;
        self.a_r5 = 0;
        
        self.a_a1 = 0;
        self.a_a2 = 0;
        self.a_a3 = 0;
        self.a_b1 = 0;
        self.a_b2 = 0;
        self.a_b3 = 0;
        self.a_c1 = 0;
        self.a_c2 = 0;
        self.a_c3 = 0;
        self.a_d1 = 0;
        self.a_d2 = 0;
        self.a_d3 = 0;
        
        NSString *strDate = Globals.i.wsBaseDict[@"attack_return"];
        
        NSDate *queueDate = [Globals.i dateParser:strDate];
        NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
        NSInteger march_time_left = queueTime - self.serverTimeInterval;
        //NSInteger attack_time = [Globals.i.wsBaseDict[@"attack_time"] integerValue];
        
        if (march_time_left > 0) //&& (attack_time > march_time_left))
        {
            self.a_r1 = [self.wsBaseDict[@"a_r1"] integerValue];
            self.a_r2 = [self.wsBaseDict[@"a_r2"] integerValue];
            self.a_r3 = [self.wsBaseDict[@"a_r3"] integerValue];
            self.a_r4 = [self.wsBaseDict[@"a_r4"] integerValue];
            self.a_r5 = [self.wsBaseDict[@"a_r5"] integerValue];
            
            self.a_a1 = [self.wsBaseDict[@"a_a1"] integerValue];
            self.a_a2 = [self.wsBaseDict[@"a_a2"] integerValue];
            self.a_a3 = [self.wsBaseDict[@"a_a3"] integerValue];
            self.a_b1 = [self.wsBaseDict[@"a_b1"] integerValue];
            self.a_b2 = [self.wsBaseDict[@"a_b2"] integerValue];
            self.a_b3 = [self.wsBaseDict[@"a_b3"] integerValue];
            self.a_c1 = [self.wsBaseDict[@"a_c1"] integerValue];
            self.a_c2 = [self.wsBaseDict[@"a_c2"] integerValue];
            self.a_c3 = [self.wsBaseDict[@"a_c3"] integerValue];
            self.a_d1 = [self.wsBaseDict[@"a_d1"] integerValue];
            self.a_d2 = [self.wsBaseDict[@"a_d2"] integerValue];
            self.a_d3 = [self.wsBaseDict[@"a_d3"] integerValue];
        }
        
        self.base_r1 = r1 - self.a_r1;
        //HACK when attacking with 0 food , upkeep is actually eating food captured back from attack, it could end up being negative
        if(self.base_r1<0)
        {
            self.base_r1=0;
        }
        self.base_r2 = r2 - self.a_r2;
        self.base_r3 = r3 - self.a_r3;
        self.base_r4 = r4 - self.a_r4;
        self.base_r5 = r5 - self.a_r5;
        
        self.base_a1 = a1 - self.i_a1 - self.r_a1 - self.transfered_a1 - self.a_a1;
        self.base_a2 = a2 - self.i_a2 - self.r_a2 - self.transfered_a2 - self.a_a2;
        self.base_a3 = a3 - self.i_a3 - self.r_a3 - self.transfered_a3 - self.a_a3;
        self.base_b1 = b1 - self.i_b1 - self.r_b1 - self.transfered_b1 - self.a_b1;
        self.base_b2 = b2 - self.i_b2 - self.r_b2 - self.transfered_b2 - self.a_b2;
        self.base_b3 = b3 - self.i_b3 - self.r_b3 - self.transfered_b3 - self.a_b3;
        self.base_c1 = c1 - self.i_c1 - self.r_c1 - self.transfered_c1 - self.a_c1;
        self.base_c2 = c2 - self.i_c2 - self.r_c2 - self.transfered_c2 - self.a_c2;
        self.base_c3 = c3 - self.i_c3 - self.r_c3 - self.transfered_c3 - self.a_c3;
        self.base_d1 = d1 - self.i_d1 - self.r_d1 - self.transfered_d1 - self.a_d1;
        self.base_d2 = d2 - self.i_d2 - self.r_d2 - self.transfered_d2 - self.a_d2;
        self.base_d3 = d3 - self.i_d3 - self.r_d3 - self.transfered_d3 - self.a_d3;
        
        
        if (Globals.i.boostR1Queue1 > 0)
        {
            Globals.i.boostR1Queue1 = Globals.i.boostR1Until - self.serverTimeInterval;
        }
        if (Globals.i.boostR2Queue1 > 0)
        {
            Globals.i.boostR2Queue1 = Globals.i.boostR2Until - self.serverTimeInterval;
        }
        if (Globals.i.boostR3Queue1 > 0)
        {
            Globals.i.boostR3Queue1 = Globals.i.boostR3Until - self.serverTimeInterval;
        }
        if (Globals.i.boostR4Queue1 > 0)
        {
            Globals.i.boostR4Queue1 = Globals.i.boostR4Until - self.serverTimeInterval;
        }
        if (Globals.i.boostR5Queue1 > 0)
        {
            Globals.i.boostR5Queue1 = Globals.i.boostR5Until - self.serverTimeInterval;
        }
        if (Globals.i.boostAttackQueue1 > 0)
        {
            Globals.i.boostAttackQueue1 = Globals.i.boostAttackUntil - self.serverTimeInterval;
        }
        if (Globals.i.boostDefendQueue1 > 0)
        {
            Globals.i.boostDefendQueue1 = Globals.i.boostDefendUntil - self.serverTimeInterval;
        }
    }
}

- (NSInteger)getQuestBadgeNumber
{
    NSInteger count = 0;
    
    if ([self.wsQuestArray count] > 0)
    {
        for (NSDictionary *rowData in self.wsQuestArray)
        {
            if (![rowData[@"profile_id"] isEqualToString:@"0"] && ![rowData[@"profile_id"] isEqualToString:@""])
            {
                if ([rowData[@"claimed"] isEqualToString:@"0"])
                {
                    count = count + 1;
                }
            }
        }
    }
    
    return count;
}

- (void)updateProductIdentifiers
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/ProductIdentifiersJson/%@",
                       WS_URL, [self GameId]];
    
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSMutableArray *returnArray = [Globals.i customParser:data];
    
    if (returnArray.count > 0)
    {
        self.wsIdentifierDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
    }
    else
    {
        self.wsIdentifierDict = [[NSDictionary alloc] init];
    }
}

- (void)loginWorld
{
    NSString *devicetoken = [Globals.i getDtoken];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/LoginWorld/%@/%@/%@",
                       self.world_url, Globals.i.UID, devicetoken, self.wsWorldProfileDict[@"alliance_id"]];
    
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
    NSError *error = nil;
    NSStringEncoding encoding = 0;
    
    NSString *returnString = [[NSString alloc] initWithContentsOfURL:url
                                                        usedEncoding:&encoding
                                                               error:&error];
    
    NSLog(@"LoginWorld returned: %@", returnString);
}

- (BOOL)updateEventSolo
{
    BOOL hasEvent = NO;
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetEventSolo",
                       self.world_url];
    
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSMutableArray *returnArray = [Globals.i customParser:data];
    
    if (returnArray.count > 0)
    {
        self.wsEventSoloDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
        hasEvent = YES;
    }
    else
    {
        self.wsEventSoloDict = nil;
    }
    
    return hasEvent;
}

- (BOOL)updateEventAlliance
{
    BOOL hasEvent = NO;
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetEventAlliance",
                       self.world_url];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSMutableArray *returnArray = [Globals.i customParser:data];
    
    if (returnArray.count > 0)
    {
        self.wsEventAllianceDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
        hasEvent = YES;
    }
    else
    {
        self.wsEventAllianceDict = nil;
    }
    
    return hasEvent;
}

- (void)getServerProfileData:(returnBlock)completionBlock
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetProfileJson/%@",
                       WS_URL, self.UID];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getServerProfileData:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS MAIN Failed" action:@"GetProfileJson" label:self.UID];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.wsProfileDict = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                      
                      //Now get world profile data
                      [self getServerWorldProfileData:completionBlock];
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
              }
          });
      }] resume];
}

- (void)getServerWorldProfileData:(returnBlock)completionBlock
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetProfile/%@",
                       self.world_url, self.wsProfileDict[@"uid"]];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getServerWorldProfileData:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:@"GetProfile" label:self.wsWorldProfileDict[@"profile_id"]];
                  completionBlock(NO, nil);
              }
              else
              {
                  //Always be prepared for return string -1 if main db profile uid no match with kingdom_world uid
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.wsWorldProfileDict = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                      
                      [[NSNotificationCenter defaultCenter]
                       postNotificationName:@"UpdateWorldProfileData"
                       object:self];
                      
                      completionBlock(YES, data);
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
                  
              }
          });
      }] resume];
}

- (void)updateBaseDict:(returnBlock)completionBlock
{
    NSString *selected_base_id = [self gettSelectedBaseId];
    if ([selected_base_id isEqualToString:@"0"])
    {
        selected_base_id = [self setDefaultBaseId];
    }
    
    NSString *service_name = @"GetBase";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@",
                       self.world_url, service_name, selected_base_id, self.wsWorldProfileDict[@"profile_id"]];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"updateBaseDict:%@", wsurl);
    
    [UIManager.i showLoadingAlert];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.base_fetch_retries = 0;
                      
                      self.wsBaseDict = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                      
                      [[NSNotificationCenter defaultCenter]
                       postNotificationName:@"BaseUpdated"
                       object:self];
                      
                      completionBlock(YES, data);
                  }
                  else if (self.base_fetch_retries > 0)
                  {
                      self.base_fetch_retries = 0;
                      
                      [self trackEvent:@"updateBaseDict" action:@"GetBase" label:Globals.i.wsWorldProfileDict[@"uid"]];
                      
                      [self settSelectedBaseId:@"0"];
                      
                      [self logout];
                      
                      [self showDialogError];
                      
                      completionBlock(NO, nil);
                  }
                  else
                  {
                      self.base_fetch_retries = self.base_fetch_retries + 1;
                      
                      [self settSelectedBaseId:@"0"];
                      
                      [self updateBaseDict:completionBlock];
                  }
              }
              
              [UIManager.i removeLoadingAlert];
          });
      }] resume];
}

- (void)getBaseMain:(NSString *)profile_id :(returnBlock)completionBlock
{
    NSString *service_name = @"GetBaseMain";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       self.world_url, service_name, profile_id];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getBaseMain:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
                  completionBlock(NO, nil);
              }
              else
              {
                  completionBlock(YES, data);
              }
          });
      }] resume];
}

- (void)GetAllianceMembers:(NSString *)alliance_id :(returnBlock)completionBlock
{
    self.selected_alliance_id = @"0";
    
    NSString *service_name = @"GetAllianceMembers";
    
    NSString *param = alliance_id;
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       self.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"GetAllianceMembers:%@",wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  if (returnArray.count > 0)
                  {
                      self.alliance_members = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      self.selected_alliance_id = alliance_id;
                      
                      completionBlock(YES, data);
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
              }
          });
      }] resume];
}

- (void)PrepareAttackResults //TODO: not using timerObject, instead duduct at Global timer
{
    NSTimeInterval serverTimeInterval = [self updateTime];
    
    NSString *strDate = Globals.i.wsBaseDict[@"attack_return"];
    
    NSDate *queueDate = [Globals.i dateParser:strDate];
    NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
    NSInteger march_time_left = queueTime - serverTimeInterval;
    NSInteger attack_time = [Globals.i.wsBaseDict[@"attack_time"] integerValue];
    if ((march_time_left > 0) && (attack_time > march_time_left))
    {
        [self flushToStackType:TO_ATTACK];
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict addEntriesFromDictionary:@{@"r1": Globals.i.wsBaseDict[@"a_r1"]}];
        [dict addEntriesFromDictionary:@{@"r2": Globals.i.wsBaseDict[@"a_r2"]}];
        [dict addEntriesFromDictionary:@{@"r3": Globals.i.wsBaseDict[@"a_r3"]}];
        [dict addEntriesFromDictionary:@{@"r4": Globals.i.wsBaseDict[@"a_r4"]}];
        [dict addEntriesFromDictionary:@{@"r5": Globals.i.wsBaseDict[@"a_r5"]}];
        
        [self addTo:TO_ATTACK time:march_time_left base_id:Globals.i.wsBaseDict[@"base_id"] title:NSLocalizedString(@"Attack Returned", nil) img:@"icon_attack" dict:dict];
    }
}

- (void)GetTradesIn:(returnBlock)completionBlock
{
    //Clear trades in
    self.trades_in = [[NSMutableArray alloc] init];
    [self flushToStackType:TO_TRADE];
    
    NSString *service_name = @"GetTradesTo";
    
    NSString *param = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsBaseDict[@"base_id"]];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       self.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.trades_in = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      NSTimeInterval serverTimeInterval = [self updateTime];
                      
                      for (NSDictionary *dict in self.trades_in)
                      {
                          NSString *strDate = dict[@"date_arrive"];
                          
                          NSDate *queueDate = [Globals.i dateParser:strDate];
                          NSTimeInterval queueTime = [queueDate timeIntervalSince1970];
                          NSInteger march_time_left = queueTime - serverTimeInterval;
                          if (march_time_left > 1)
                          {
                              NSString *title = [NSString stringWithFormat:NSLocalizedString(@"Resources have arrived from %@.", nil), dict[@"from_profile_name"]];
                              [self addTo:TO_TRADE time:march_time_left base_id:Globals.i.wsBaseDict[@"base_id"] title:title img:@"report_trade" dict:dict];
                          }
                      }
                      
                      completionBlock(YES, data);
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
              }
          });
      }] resume];
}

- (void)GetAttacksIn:(returnBlock)completionBlock
{
    self.attacks_in = [[NSMutableArray alloc] init];
    
    NSString *service_name = @"GetAttacksArriveTo";
    
    NSString *param = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsBaseDict[@"base_id"]];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       self.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.attacks_in = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      
                      completionBlock(YES, data);
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
              }
          });
      }] resume];
}

- (void)GetAttacksOut:(returnBlock)completionBlock
{
    self.attacks_out = [[NSMutableArray alloc] init];
    
    NSString *service_name = @"GetAttacksFrom";
    
    NSString *param = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsBaseDict[@"base_id"]];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       self.world_url, service_name, param];
    
    NSLog(@"Marches : %@",wsurl);
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.attacks_out = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      
                      completionBlock(YES, data);
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
              }
              
          });
      }] resume];
}

- (void)GetReinforcesIn:(returnBlock)completionBlock
{
    self.reinforces_in = [[NSMutableArray alloc] init];
    
    NSString *service_name = @"GetReinforcementsTo";
    
    NSString *param = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsBaseDict[@"base_id"]];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       self.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.reinforces_in = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      
                      completionBlock(YES, data);
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
              }
          });
      }] resume];
}

- (void)GetReinforcesOut:(returnBlock)completionBlock
{
    self.reinforces_out = [[NSMutableArray alloc] init];
    
    NSString *service_name = @"GetReinforcementsFrom";
    
    NSString *param = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsBaseDict[@"base_id"]];
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       self.world_url, service_name, param];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:param];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.reinforces_out = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      
                      completionBlock(YES, data);
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
              }
          });
      }] resume];
}

- (void)getNearestVillage:(NSInteger)center_x :(NSInteger)center_y :(returnBlock)completionBlock
{
    NSString *service_name = @"GetNearestVillage";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@",
                       self.world_url, service_name, [@(center_x) stringValue],[@(center_y) stringValue]];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [UIManager.i showLoadingAlert];
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (error || !response || !data)
          {
              [Globals.i trackEvent:@"WS Failed" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
              completionBlock(NO, nil);
          }
          else
          {
              NSMutableArray *returnArray = [Globals.i customParser:data];
              
              if (returnArray.count > 0)
              {
                  completionBlock(YES, data);
              }
              else
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
                  
                  completionBlock(NO, nil);
              }
              
          }
          [UIManager.i removeLoadingAlert];
      }] resume];
}

- (void)getRegions:(returnBlock)completionBlock
{
    NSString *service_name = @"GetRegions";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@",
                       self.world_url, service_name, [@(Globals.i.map_center_x) stringValue], [@(Globals.i.map_center_y) stringValue], [@(Globals.i.map_tiles_x) stringValue], [@(Globals.i.map_tiles_y) stringValue]];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSLog(@"getRegions %@", wsurl);
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (error || !response || !data)
          {
              [Globals.i trackEvent:@"WS Failed" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
              completionBlock(NO, nil);
          }
          else
          {
              NSMutableArray *returnArray = [Globals.i customParser:data];
              
              if (returnArray.count > 0)
              {
                  for (NSDictionary *dict_server in returnArray)
                  {
                      NSLog(@"GetRegions return region_id:%@ (%@)", dict_server[@"region_id"], dict_server[@"last_process"]);
                  }
                  
                  if (self.region_array == nil)
                  {
                      self.region_array = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      self.region_outdated_array = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                  }
                  else if (self.region_array.count == 0)
                  {
                      self.region_array = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      self.region_outdated_array = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                  }
                  else
                  {
                      NSMutableArray *arrayToCheck = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      NSMutableArray *region_array_copy = [[NSMutableArray alloc] initWithArray:self.region_array copyItems:YES];
                      self.region_outdated_array = [[NSMutableArray alloc] init];
                      
                      for (NSMutableDictionary *dict_server in returnArray)
                      {
                          for (NSMutableDictionary *dict_client in region_array_copy)
                          {
                              if ([dict_client[@"region_id"] isEqualToString:dict_server[@"region_id"]])
                              {
                                  NSString *strDateServer = dict_server[@"last_process"];
                                  NSDate *dateServer = [Globals.i dateParser:strDateServer];
                                  
                                  NSString *strDateClient = dict_client[@"last_process"];
                                  NSDate *dateClient = [Globals.i dateParser:strDateClient];
                                  
                                  if ([dateServer compare:dateClient] == NSOrderedDescending)
                                  {
                                      //server is later than client
                                      //update date and add region_id to region_outdated_array
                                      
                                      NSMutableDictionary *dictRegionId = [[NSMutableDictionary alloc] initWithDictionary:dict_server copyItems:YES];
                                      [self.region_outdated_array addObject:dictRegionId];
                                      
                                      [self.region_array removeObject:dict_client];
                                      [self.region_array addObject:dict_server];
                                  }
                                  
                                  [arrayToCheck removeObject:dict_server];
                              }
                          }
                      }
                      
                      [self.region_array addObjectsFromArray:arrayToCheck];
                      [self.region_outdated_array addObjectsFromArray:arrayToCheck];
                      for (NSDictionary *dict in arrayToCheck)
                      {
                          NSLog(@"Added new region_id:%@(%@)", dict[@"region_id"], dict[@"last_process"]);
                      }
                      
                  }
                  
                  for (NSMutableDictionary *dictRegionId in self.region_outdated_array)
                  {
                      NSString *strRegionId = dictRegionId[@"region_id"];
                      NSLog(@"outdated region_id: %@", strRegionId);
                      
                      [Globals.i getMapCities:[strRegionId integerValue] :^(BOOL success, NSData *data){}];
                  }
                  
                  completionBlock(YES, data);
              }
              else
              {
                  completionBlock(NO, nil);
              }
          }
          
      }] resume];
}

- (void)getMapCities:(NSInteger)region_id :(returnBlock)completionBlock
{
    NSString *service_name = @"GetMapCitiesExtended";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@/%@",
                       self.world_url, service_name, self.wsWorldProfileDict[@"profile_id"], [@(region_id) stringValue]];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [UIManager.i showLoadingAlert];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (error || !response || !data)
          {
              [Globals.i trackEvent:@"WS Failed" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
              completionBlock(NO, nil);
          }
          else
          {
              NSMutableArray *returnArray = [Globals.i customParser:data];
              
              if (returnArray.count > 0)
              {
                  NSMutableArray *serverArray = [[NSMutableArray alloc] init];
                  for (NSDictionary *dict in returnArray)
                  {
                      [serverArray addObject:[[MapBaseCompare alloc] initWithDictionary:dict]];
                  }
                  
                  NSMutableArray *clientArray = [[NSMutableArray alloc] init];
                  NSMutableArray *map_city_array_copy = [[NSMutableArray alloc] initWithArray:self.map_city_array copyItems:YES];
                  for (NSDictionary *dict in map_city_array_copy)
                  {
                      [clientArray addObject:[[MapBaseCompare alloc] initWithDictionary:dict]];
                  }
                  
                  //NSLog(@"serverArray count: (%@)", [@(serverArray.count) stringValue]);
                  
                  //NSLog(@"clientArray count: (%@)", [@(clientArray.count) stringValue]);
                  
                  if (clientArray.count > 0)
                  {
                      if (serverArray.count > 0)
                      {
                          NSSet *setCurrent = [NSSet setWithArray:clientArray];
                          NSSet *setUpdated = [NSSet setWithArray:serverArray];
                          
                          NSMutableSet *setFinal = [setUpdated mutableCopy];
                          [setFinal unionSet:setCurrent];
                          
                          NSArray *arrFinal = [setFinal valueForKey:@"dictionary"];
                          
                          //NSLog(@"arrFinal count: (%@)", [@(arrFinal.count) stringValue]);
                          
                          self.map_city_array = [[NSMutableArray alloc] init];
                          
                          for (NSDictionary *dict in arrFinal)
                          {
                              [self.map_city_array addObject:dict];
                              NSLog(@"Updated base_id: %@", dict[@"base_id"]);
                          }
                      }
                  }
                  else
                  {
                      self.map_city_array = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                  }
                  
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshMap" object:self];
                  
                  NSLog(@"map_city_array count: (%@)", [@(self.map_city_array.count) stringValue]);
              }
              
              completionBlock(YES, data);
          }
          [UIManager.i removeLoadingAlert];
          
      }] resume];
}

- (void)getMapVillages:(NSInteger)region_id :(returnBlock)completionBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i showLoadingAlert];});
    
    NSString *service_name = @"GetMapVillages";
    NSString *wsurl = [NSString stringWithFormat:@"%@/%@/%@",
                       self.world_url, service_name, [@(region_id) stringValue]];
    
    wsurl = [wsurl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [[self.session dataTaskWithURL:[NSURL URLWithString:wsurl]
                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          dispatch_async(dispatch_get_main_queue(), ^{[UIManager.i removeLoadingAlert];
              if (error || !response || !data)
              {
                  [Globals.i trackEvent:@"WS Failed" action:service_name label:self.wsWorldProfileDict[@"profile_id"]];
                  completionBlock(NO, nil);
              }
              else
              {
                  NSMutableArray *returnArray = [Globals.i customParser:data];
                  
                  if (returnArray.count > 0)
                  {
                      self.map_village_array = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                      
                      completionBlock(YES, data);
                  }
                  else
                  {
                      completionBlock(NO, nil);
                  }
              }
          });
      }] resume];
}

- (NSInteger)xpFromLevel:(NSInteger)level
{
    NSDictionary *hlDict = [self getHeroLevelDict:level];
    return [hlDict[@"total_xp"] integerValue];
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

- (NSInteger)getXpMax
{
    return [self xpFromLevel:[self getLevel]+1];
}

- (NSInteger)getXpMaxBefore
{
    return [self xpFromLevel:[self getLevel]];
}

- (NSInteger)getLevel
{
    return [self levelFromXp:[self getXp]];
}

- (NSInteger)getXpBar
{
    return [self getXp] - [self getXpMaxBefore];
}

- (NSInteger)getXpBarFull
{
    return [self getXpMax] - [self getXpMaxBefore];
}

- (float)getXpProgressBar
{
    float progress = 0.0f;
    
    float p1 = [self getXpBar];
    float p2 = [self getXpBarFull];
    
    progress = p1/p2;
    
    return progress;
}

- (float)getXpMoreToLevelUp
{
    return [self getXpMax] - [self getXp];
}

- (NSInteger)spFromLevel:(NSInteger)level
{
    NSDictionary *hlDict = [self getHeroLevelDict:level];
    return [hlDict[@"total_skill_points"] integerValue];
}

- (NSInteger)spRewardFromLevel:(NSInteger)level
{
    NSDictionary *hlDict = [self getHeroLevelDict:level];
    return [hlDict[@"skill_points"] integerValue];
}

- (NSInteger)powerFromLevel:(NSInteger)level
{
    NSDictionary *hlDict = [self getHeroLevelDict:level];
    return [hlDict[@"total_power"] integerValue];
}

- (NSInteger)powerRewardFromLevel:(NSInteger)level
{
    NSDictionary *hlDict = [self getHeroLevelDict:level];
    return [hlDict[@"power"] integerValue];
}

- (NSInteger)spUsed
{
    NSInteger usedSp = 0;
    
    NSInteger h01 = [self.wsWorldProfileDict[@"hero_r1"] integerValue];
    NSInteger h02 = [self.wsWorldProfileDict[@"hero_r2"] integerValue];
    NSInteger h03 = [self.wsWorldProfileDict[@"hero_r3"] integerValue];
    NSInteger h04 = [self.wsWorldProfileDict[@"hero_r4"] integerValue];
    NSInteger h05 = [self.wsWorldProfileDict[@"hero_r5"] integerValue];
    
    NSInteger h06 = [self.wsWorldProfileDict[@"hero_build"] integerValue];
    NSInteger h07 = [self.wsWorldProfileDict[@"hero_research"] integerValue];
    NSInteger h08 = [self.wsWorldProfileDict[@"hero_march"] integerValue];
    NSInteger h09 = [self.wsWorldProfileDict[@"hero_trade"] integerValue];
    NSInteger h10 = [self.wsWorldProfileDict[@"hero_craft"] integerValue];
    NSInteger h11 = [self.wsWorldProfileDict[@"hero_heal"] integerValue];
    NSInteger h12 = [self.wsWorldProfileDict[@"hero_training"] integerValue];
    
    NSInteger h13 = [self.wsWorldProfileDict[@"hero_attack"] integerValue];
    NSInteger h14 = [self.wsWorldProfileDict[@"hero_defense"] integerValue];
    NSInteger h15 = [self.wsWorldProfileDict[@"hero_life"] integerValue];
    NSInteger h16 = [self.wsWorldProfileDict[@"hero_load"] integerValue];
    
    NSInteger h17 = [self.wsWorldProfileDict[@"hero_a_attack"] integerValue];
    NSInteger h18 = [self.wsWorldProfileDict[@"hero_b_attack"] integerValue];
    NSInteger h19 = [self.wsWorldProfileDict[@"hero_c_attack"] integerValue];
    NSInteger h20 = [self.wsWorldProfileDict[@"hero_d_attack"] integerValue];
    
    usedSp = h01+h02+h03+h04+h05+h06+h07+h08+h09+h10+h11+h12+h13+h14+h15+h16+h17+h18+h19+h20;
    
    return usedSp;
}

- (NSInteger)spBalance
{
    NSInteger balanceSp = 0;
    
    NSInteger total_sp = [self spFromLevel:[self getLevel]];
    NSInteger used_sp = [self spUsed];
    
    balanceSp = total_sp - used_sp;
    
    return balanceSp;
}

- (void)updateProfilePower:(NSInteger)power_gain
{
    // + XP to profile
    NSInteger old_xp = [self.wsWorldProfileDict[@"xp"] integerValue];
    NSInteger new_xp = old_xp + power_gain;
    self.wsWorldProfileDict[@"xp"] = [@(new_xp) stringValue];
    
    NSInteger xp_gain = [self.wsWorldProfileDict[@"xp_gain"] integerValue] + power_gain;
    self.wsWorldProfileDict[@"xp_gain"] = [@(xp_gain) stringValue];
    
    NSInteger xp_gain_a = [self.wsWorldProfileDict[@"xp_gain_a"] integerValue] + power_gain;
    self.wsWorldProfileDict[@"xp_gain_a"] = [@(xp_gain_a) stringValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateWorldProfileData" object:self];
    
    [UIManager.i showToast:[NSString stringWithFormat:@" + %@", [Globals.i intString:power_gain]]
           optionalTitle:@"PowerIncreased"
           optionalImage:@"icon_power"];
}

- (void)updateHeroXP:(NSInteger)xp_gain
{
    NSInteger xp_max = [Globals.i getXpMax];
    
    // + XP to hero_xp
    NSInteger new_hero_xp = [self getXp] + xp_gain;
    self.wsWorldProfileDict[@"hero_xp"] = [@(new_hero_xp) stringValue];
    
    NSInteger hero_xp_gain = [self.wsWorldProfileDict[@"hero_xp_gain"] integerValue] + xp_gain;
    self.wsWorldProfileDict[@"hero_xp_gain"] = [@(hero_xp_gain) stringValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHeroXP"
                                                        object:self
                                                      userInfo:nil];
    
    if (new_hero_xp >= xp_max)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHeroSkillPoints"
                                                            object:self
                                                          userInfo:nil];
        
        [self showHeroLevelUp];
        
        [UIManager.i showToast:NSLocalizedString(@"Congratulations. Your hero Leveled UP!", nil)
               optionalTitle:@"HeroLevelUp"
               optionalImage:@"icon_check"];
        
        //Sound please
    }
    else
    {
        [UIManager.i showToast:[NSString stringWithFormat:@" + %@", [Globals.i intString:xp_gain]]
               optionalTitle:@"HeroXPIncreased"
               optionalImage:@"icon_hero_xp"];
    }
}

- (void)showHeroLevelUp
{
    NSInteger sp_reward = [self spRewardFromLevel:[self getLevel]];
    NSInteger pwr_reward = [self powerRewardFromLevel:[self getLevel]];
    
    NSString *img_hero = @"hero_levelup";
    
    NSDictionary *row10 = @{@"nofooter": @"1", @"r1": NSLocalizedString(@"Level Up!", nil), @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE};
    NSDictionary *row11 = @{@"nofooter": @"1", @"i1": img_hero, @"r1": NSLocalizedString(@"Congratulations! Your hero has just Level Up.", nil), @"r1_align": @"1"};
    NSDictionary *row12 = @{@"bkg_prefix": @"bkg2", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"r1": [NSString stringWithFormat:NSLocalizedString(@"Level %@", nil), [self intString:[self getLevel]]]};
    NSDictionary *row13 = @{@"r1": NSLocalizedString(@"Power", nil), @"c1": [NSString stringWithFormat:@"+%@", [self intString:pwr_reward]], @"footer_spacing": @"10"};
    NSDictionary *row14 = @{@"r1": NSLocalizedString(@"Skill Points", nil), @"c1": [NSString stringWithFormat:@"+%@", [self intString:sp_reward]], @"footer_spacing": @"10"};
    NSArray *rows1 = @[row10, row11, row12, row13, row14];
    NSMutableArray *rows = [@[rows1] mutableCopy];
    
    NSInteger sp_balance = [self spBalance];
    NSString *btn_title = [NSString stringWithFormat:NSLocalizedString(@"Skill Points: %@", nil), [self intString:sp_balance]];
    
    NSDictionary *row21 = @{@"nofooter": @"1", @"r1": btn_title, @"r1_button": @"2", @"c1": NSLocalizedString(@"OK", nil), @"c1_button": @"2",};
    NSArray *rows2 = @[row21];
    [rows addObject:rows2];
    
    [UIManager.i showDialogBlockRow:rows
                            title:@"HeroLevelUp"
                             type:7
                                 :^(NSInteger index, NSString *text)
     {
         if (index == 1) //Skill Points
         {
             [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHeroSkills"
                                                                 object:self
                                                               userInfo:nil];
         }
         if (index == 2) //OK
         {
             //Do nothing
         }
     }];
}

- (void)showConfirmCapture:(NSDictionary *)targetBaseDict
{
    NSString *str_base_count = Globals.i.wsWorldProfileDict[@"base_count"];
    double base_count = [str_base_count doubleValue];
    
    NSString *str_r5 = [Globals.i floatString:Globals.i.base_r5];
    
    NSString *str_formula_a = Globals.i.wsSettingsDict[@"capture_require_formula_a"];
    NSString *str_formula_b = Globals.i.wsSettingsDict[@"capture_require_formula_b"];
    NSString *str_formula_c = Globals.i.wsSettingsDict[@"capture_require_formula_c"];
    NSString *str_formula_d = Globals.i.wsSettingsDict[@"capture_require_formula_d"];
    
    double formula_a = [str_formula_a doubleValue];
    double formula_b = [str_formula_b doubleValue];
    double formula_c = [str_formula_c doubleValue];
    double formula_d = [str_formula_d doubleValue];
    
    double r5_req = formula_a*pow(base_count, formula_b) + formula_c*base_count + formula_d;
    
    NSString *str_r5_req = [Globals.i intString:r5_req];
    
    NSDictionary *row10 = @{@"nofooter": @"1", @"r1": NSLocalizedString(@"Requirements", nil), @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE};
    
    NSDictionary *row11 = @{@"r1": NSLocalizedString(@"You should send sufficient siege units to destroy enemy walls and defeat their troops. All the Gold required and Troops sent will be consumed for this attempt.", nil), @"nofooter": @"1"};
    
    TTTOrdinalNumberFormatter *ordinalNumberFormatter = [[TTTOrdinalNumberFormatter alloc] init];
    [ordinalNumberFormatter setLocale:[NSLocale currentLocale]];
    [ordinalNumberFormatter setGrammaticalGender:TTTOrdinalNumberFormatterMaleGender];
    NSNumber *number = [NSNumber numberWithDouble:base_count];
    
    NSDictionary *row12 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"You have %@ Gold, required %@ Gold for the %@ village.", nil), str_r5, str_r5_req, [ordinalNumberFormatter stringFromNumber:number]], @"nofooter": @"1"};
    
    NSArray *rows1 = @[row10, row11, row12];
    NSMutableArray *rows = [@[rows1] mutableCopy];
    
    NSDictionary *row21 = @{@"nofooter": @"1", @"r1": NSLocalizedString(@"Cancel", nil), @"r1_button": @"2", @"c1": NSLocalizedString(@"PROCEED", nil), @"c1_button": @"2",};
    NSArray *rows2 = @[row21];
    [rows addObject:rows2];
    
    [UIManager.i showDialogBlockRow:rows
                            title:@"CaptureConfirmation"
                             type:7
                                 :^(NSInteger index, NSString *text)
     {
         if (index == 1) //Cancel
         {
             
         }
         else if (index == 2) //OK
         {
             if (Globals.i.base_r5 >= r5_req)
             {
                 [self doCapture:targetBaseDict];
             }
             else
             {
                 [UIManager.i showDialog:[NSString stringWithFormat:NSLocalizedString(@"Sorry Sire, you require %@ Gold to capture this village.", nil), [Globals.i intString:r5_req]] title:@"InsufficientGoldForCapture"];
             }
         }
     }];
}

- (void)updateHeroLevelArray //TODO: fucked mny times
{
    if ((self.wsHeroLevelArray == nil) && (self.world_url != nil))
    {
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetHeroLevel",
                           self.world_url];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSMutableArray *returnArray = [Globals.i customParser:data];
        
        if (returnArray.count > 0)
        {
            self.wsHeroLevelArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
        }
    }
}

- (NSDictionary *)getHeroLevelDict:(NSInteger)level
{
    if (self.wsHeroLevelArray == nil)
    {
        [self updateHeroLevelArray];
    }
    
    NSDictionary *hlDict = nil;
    
    for (NSDictionary *dict in self.wsHeroLevelArray)
    {
        if ([dict[@"hero_level"] integerValue] == level)
        {
            hlDict = dict;
        }
    }
    
    return hlDict;
}

- (void)heroEquip:(NSString *)item_id hero_field:(NSString *)hero_field
{
    NSString *service_name = @"HeroEquip";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@",
                       Globals.i.wsWorldProfileDict[@"uid"], hero_field, item_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             Globals.i.wsWorldProfileDict[hero_field] = item_id;
             
             [[NSNotificationCenter defaultCenter]
              postNotificationName:@"UpdateHeroItems"
              object:self];
             
             NSString *str_toast = NSLocalizedString(@"Item is equiped Successfully!", nil);
             
             if ([item_id isEqualToString:@"0"])
             {
                 str_toast = NSLocalizedString(@"Item is unequiped!", nil);
             }
             else
             {
                 [UIManager.i closeAllTemplate];
                 
                 [[NSNotificationCenter defaultCenter]
                  postNotificationName:@"ShowHero"
                  object:self];
             }
             //Updates all hero boost
             [Globals.i updateBaseDict:^(BOOL success, NSData *data)
              {
                  [UIManager.i showToast:str_toast
                         optionalTitle:@"HeroBoosted"
                         optionalImage:@"icon_check"];
              }];
         }
     }];
}

- (void)doTrade:(NSDictionary *)targetBaseDict
{
    if ([Globals.i isTvViewFromStack:TV_TRADE])
    {
        [UIManager.i showDialog:NSLocalizedString(@"You are only allowed to do one trade action at a time. You could speedup the current trade or wait for it to reach the destination, then try again.", nil) title:@"OneTradeRestriction"];
    }
    else
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:targetBaseDict forKey:@"base_dict"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SendResources"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

- (void)doSpy:(NSDictionary *)targetBaseDict
{
    BOOL hasBuildTavern = NO;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:@"17"])
        {
            hasBuildTavern = YES;
        }
    }
    
    if (hasBuildTavern)
    {
        NSInteger total_spy = [Globals.i.wsBaseDict[@"spy"] integerValue];
        
        if (total_spy > 0)
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:targetBaseDict forKey:@"base_dict"];
            [userInfo setObject:@"Spy" forKey:@"action"];
            [userInfo setObject:@(0) forKey:@"limit"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendTroops"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else
        {
            NSString *dialog_text = NSLocalizedString(@"You have no spies currently, recruit some spies in the Tavern.", nil);
            [UIManager.i showDialog:dialog_text title:@"NoSpiesAvailable"];
        }
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"You will need to build a Tavern in your city to be able to recruit and send Spies to other cities.", nil) title:@"TavernNeededForSpies"];
    }
}

- (void)doAttack:(NSDictionary *)targetBaseDict
{
    BOOL hasBuildRallyPoint = NO;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:@"18"])
        {
            hasBuildRallyPoint = YES;
        }
    }
    
    if (hasBuildRallyPoint)
    {
        if ([Globals.i isTvViewFromStack:TV_ATTACK])
        {
            [UIManager.i showDialog:NSLocalizedString(@"You are only allowed to do one attack at a time. You could speedup the current attack or wait for it to return, then try again.", nil) title:@"OneAttackRestriction"];
        }
        else
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:targetBaseDict forKey:@"base_dict"];
            [userInfo setObject:@"Attack" forKey:@"action"];
            [userInfo setObject:@(0) forKey:@"limit"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendTroops"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"You will need to build a Rally Point in your city to be able to Attack.", nil) title:@"RallyPointNeededForAttack"];
    }
}

- (void)doCapture:(NSDictionary *)targetBaseDict
{
    BOOL hasBuildRallyPoint = NO;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:@"18"])
        {
            hasBuildRallyPoint = YES;
        }
    }
    
    if (hasBuildRallyPoint)
    {
        if ([Globals.i isTvViewFromStack:TV_ATTACK])
        {
            [UIManager.i showDialog:NSLocalizedString(@"You are only allowed to do one attack at a time. You could speedup the current attack or wait for it to return, then try again.", nil) title:@"OneAttackRestriction"];
        }
        else
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:targetBaseDict forKey:@"base_dict"];
            [userInfo setObject:@"Capture" forKey:@"action"];
            [userInfo setObject:@(0) forKey:@"limit"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendTroops"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"You will need to build a Rally Point in your city to be able to send Troops.", nil) title:@"RallyPointNeededForAttack"];
    }
}

- (void)doTransferTroops:(NSDictionary *)targetBaseDict
{
    BOOL hasBuildRallyPoint = NO;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:@"18"])
        {
            hasBuildRallyPoint = YES;
        }
    }
    
    if (hasBuildRallyPoint)
    {
        if ([Globals.i isTvViewFromStack:TV_REINFORCE] || [Globals.i isTvViewFromStack:TV_TRANSFER])
        {
            [UIManager.i showDialog:NSLocalizedString(@"You can only bring one set of Troops home any one time. You could speedup the march, or wait for them to reach their destination. Please try again.", nil) title:@"OneReturnRestriction"];
        }
        else
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:targetBaseDict forKey:@"base_dict"];
            [userInfo setObject:@"Transfer" forKey:@"action"];
            [userInfo setObject:@(0) forKey:@"limit"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendTroops"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"You will need to build a Rally Point in your city to be able to transfer troops to your other cities.", nil) title:@"RallyPointNeededForTransfer"];
    }
}

- (void)doReinforce:(NSString *)target_profile_id
{
    BOOL hasBuildRallyPoint = NO;
    for (NSDictionary *dict in Globals.i.wsBuildArray)
    {
        if ([dict[@"building_id"] isEqualToString:@"18"])
        {
            hasBuildRallyPoint = YES;
        }
    }
    
    if (hasBuildRallyPoint)
    {
        if ([Globals.i isTvViewFromStack:TV_REINFORCE] || [Globals.i isTvViewFromStack:TV_TRANSFER])
        {
            [UIManager.i showDialog:NSLocalizedString(@"You can only bring one set of Troops home any one time. You could speedup the march, or wait for them to reach their destination. Please try again.", nil) title:@"OneReinforcementRestriction"];
        }
        else
        {
            [Globals.i showAlliesTroopCapacity:target_profile_id];
        }
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"You will need to build a Rally Point in your city to be able to Reinforce other cities.", nil) title:@"RallyPointNeededForReinforcement"];
    }
}

- (void)showReinforceDialog:(NSDictionary *)mainBaseDict :(NSInteger)embasy_capacity
{
    NSString *to_base_id = mainBaseDict[@"base_id"];
    NSInteger total_troops = [self troopsReinforceForBase:to_base_id];
    
    NSInteger limit = embasy_capacity - total_troops;
    
    NSString *troopTotal = [self intString:total_troops];
    NSString *troopCapacity = [self intString:embasy_capacity];
    
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Reinforce", nil), @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Send your Alliance Member reinforcements to help defend their capital City.", nil), @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row103 = @{@"r1": NSLocalizedString(@"Allies Embassy Troop Capacity per Ally", nil), @"r1_align": @"1", @"r1_bold": @"1", @"r1_font": CELL_FONT_SIZE, @"nofooter": @"1"};
    NSDictionary *row104 = @{@"r1": [NSString stringWithFormat:@"%@ / %@", troopTotal, troopCapacity], @"r1_align": @"1", @"r1_color": @"2", @"r1_bkg": @"bkg3", @"nofooter": @"1"};
    NSArray *rows1 = @[row101, row102, row103, row104];
    NSMutableArray *rows = [@[rows1] mutableCopy];
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Reinforce", nil), @"r1_button": @"2", @"c1": NSLocalizedString(@"Cancel", nil), @"c1_button": @"2", @"nofooter": @"1"};
    NSArray *rows2 = @[row201];
    [rows addObject:rows2];
    
    [UIManager.i showDialogBlockRow:rows
                            title:@"ReinforcementConfirmation"
                             type:7
                                 :^(NSInteger index, NSString *text)
     {
         if (index == 1) //Reinforce
         {
             if (limit > 0)
             {
                 NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                 [userInfo setObject:mainBaseDict forKey:@"base_dict"];
                 [userInfo setObject:@"Reinforce" forKey:@"action"];
                 [userInfo setObject:@(limit) forKey:@"limit"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"SendTroops"
                                                                     object:self
                                                                   userInfo:userInfo];
             }
             else
             {
                 [UIManager.i showDialog:NSLocalizedString(@"You have reached the maximum reinforce capacity for this ally. Request this ally to upgrade thier Embassy, or pull back troops and send new reinforcements.", nil) title:@"MaximumReinforcementReached"];
             }
         }
     }];
}

- (NSInteger)troopsReinforceForBase:(NSString *)base_id
{
    NSInteger troop_count = 0;
    
    for (NSDictionary *dict in Globals.i.reinforces_out)
    {
        if ([dict[@"to_base_id"] isEqualToString:base_id] && [dict[@"is_return"] isEqualToString:@"0"])
        {
            troop_count = troop_count + [self totalTroopsFromDict:dict];
        }
    }
    
    return troop_count;
}

- (void)embassyCapacityForBase:(NSDictionary *)mainBaseDict
{
    NSString *to_base_id = mainBaseDict[@"base_id"];
    
    NSString *service_name = @"GetBuild";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       to_base_id, @"13"];
    
    [self getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 if (returnArray.count > 0)
                 {
                     NSInteger capacity = 0;
                     for (NSMutableDictionary *dict in returnArray)
                     {
                         capacity = [dict[@"capacity"] integerValue];
                     }
                     
                     if ([Globals.i.reinforces_out count] > 0)
                     {
                         [self showReinforceDialog:mainBaseDict :capacity];
                     }
                     else
                     {
                         [Globals.i GetReinforcesOut:^(BOOL success, NSData *data)
                          {
                              [self showReinforceDialog:mainBaseDict :capacity];
                          }
                          ];
                     }
                     
                 }
                 else
                 {
                     [UIManager.i showDialog:NSLocalizedString(@"This alliance member does not have an embassy in the capital city, unable to conduct reinforce!", nil) title:@"AllianceMemberEmbassyNeededForReinforcement"];
                 }
             }
         });
     }];
}

- (void)showAlliesTroopCapacity:(NSString *)profile_id
{
    [Globals.i getBaseMain:profile_id :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 if (returnArray.count > 0)
                 {
                     NSDictionary *mainBaseDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                     
                     [self embassyCapacityForBase:mainBaseDict];
                 }
                 else //A message when no main base is present
                 {
                     [UIManager.i showDialog:NSLocalizedString(@"This alliance member is no longer active, unable to conduct reinforce!", nil) title:@"AllianceNotActive"];
                 }
             }
         });
     }];
}

- (NSString *)gettSelectedBaseId
{
    self.selectedBaseId = [[NSUserDefaults standardUserDefaults] objectForKey:@"Baseid"];
    
    if (self.selectedBaseId == nil)
    {
        self.selectedBaseId = @"0";
    }
    
    return self.selectedBaseId;
}

- (void)settSelectedBaseId:(NSString *)bid
{
    self.selectedBaseId = bid;
    [[NSUserDefaults standardUserDefaults] setObject:self.selectedBaseId forKey:@"Baseid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)updateSettings
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetSettings",
                       self.world_url];
    
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSMutableArray *returnArray = [Globals.i customParser:data];
    
    if (returnArray.count > 0)
    {
        self.wsSettingsDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
    }
    else
    {
        NSLog(@"WARNING: GetSettings return empty array!");
        self.wsSettingsDict = [[NSDictionary alloc] init];
    }
}

- (void)updateUnitArray
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetUnit",
                       self.world_url];
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSMutableArray *returnArray = [Globals.i customParser:data];
    
    if (returnArray.count > 0)
    {
        self.wsUnitArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
    }
}

- (NSDictionary *)getUnitDict:(NSString *)type tier:(NSString *)tier
{
    if (self.wsUnitArray == nil)
    {
        [self updateUnitArray];
    }
    
    NSDictionary *unitDict = nil;
    
    for (NSDictionary *dict in self.wsUnitArray)
    {
        if ([dict[@"type"] isEqualToString:type] && [dict[@"tier"] isEqualToString:tier])
        {
            unitDict = dict;
        }
    }
    
    return unitDict;
}

- (NSMutableArray *)getUnitArray:(NSString *)type
{
    if (self.wsUnitArray == nil)
    {
        [self updateUnitArray];
    }
    
    NSMutableArray *unit_type = [[NSMutableArray alloc] init];
    
    for (NSMutableDictionary *dict in self.wsUnitArray)
    {
        if ([dict[@"type"] isEqualToString:type])
        {
            [unit_type addObject:dict];
        }
    }
    
    return unit_type;
}

- (void)updateBuildingArray
{
    self.wsBuildingArray = [[NSMutableArray alloc] init];
    
    NSDictionary *row1 = @{@"building_id": @"1", @"building_name": NSLocalizedString(@"Farm", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"Build Farms to provide Food for your city.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Farms to increase Food production and your City's Food Capacity.", nil)};
    
    NSDictionary *row2 = @{@"building_id": @"2", @"building_name": NSLocalizedString(@"Sawmill", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"Build Sawmills to provide Wood for your city.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Sawmills to increase Wood production and your City's Wood Capacity.", nil)};
    
    NSDictionary *row3 = @{@"building_id": @"3", @"building_name": NSLocalizedString(@"Stone Quarry", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"Build Quarrys to provide Stone for your city.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Quarrys to increase Stone production and your City's Stone Capacity.", nil)};
    
    NSDictionary *row4 = @{@"building_id": @"4", @"building_name": NSLocalizedString(@"Iron Mine", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"Build Mines to provide Ore for your city.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Mines to increase Ore production and your City's Ore Capacity.", nil)};
    
    NSDictionary *row5 = @{@"building_id": @"5", @"building_name": NSLocalizedString(@"House", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"Build Houses to produce Gold for your city from taxes.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Houses to increase Gold production and your City's Gold Capacity.", nil)};
    
    NSDictionary *row6 = @{@"building_id": @"6", @"building_name": NSLocalizedString(@"Barracks", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"The Barracks allows you to train Infantry units.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Barracks to increase the Infantry unit training capacity in your City.", nil)};
    
    NSDictionary *row7 = @{@"building_id": @"7", @"building_name": NSLocalizedString(@"Archery Range", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"Archery Range allows you to train Ranged units.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Archery Range to increase the Range unit training capacity in your City.", nil)};
    
    NSDictionary *row8 = @{@"building_id": @"8", @"building_name": NSLocalizedString(@"Stable", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"Stable allows you to train Cavalry units.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Stable to increase the Cavalry unit training capacity in your City.", nil)};
    
    NSDictionary *row9 = @{@"building_id": @"9", @"building_name": NSLocalizedString(@"Siege Workshop", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"Workshop allows you to train Siege units.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Siege Workshop to increase the Siege unit training capacity in your City.", nil)};
    
    NSDictionary *row10 = @{@"building_id": @"10", @"building_name": NSLocalizedString(@"Hospital", nil), @"max_per_base": @"0", @"info": NSLocalizedString(@"The Hospital allows you to heal your wounded Troops defending the city.", nil), @"info_chart": NSLocalizedString(@"Build and Upgrade your Hospital to increase the amount of Troops you can heal at a time.", nil)};
    
    NSDictionary *row11 = @{@"building_id": @"11", @"building_name": NSLocalizedString(@"Storehouse", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"Protect your Food, Wood, Stone and Ore in your city from being raided.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Storehouse to increase the capacity of resources for Food, Wood, Stone and Ore protected from a raid by enemy.", nil)};
    
    NSDictionary *row12 = @{@"building_id": @"12", @"building_name": NSLocalizedString(@"Market", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"Send resources to your other cities or allies from your market.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Market to reduce the tax rate imposed on transfering resources as well as increasing the transfer limit.", nil)};
    
    NSDictionary *row13 = @{@"building_id": @"13", @"building_name": NSLocalizedString(@"Embassy", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"Send and receive reinforcements from your allies here.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Embassy to increase the Troop capacity per ally you can hold on your city. Troops sent by you ally will help defend againts enemy attack and pay for their own upkeep.", nil)};
    
    NSDictionary *row14 = @{@"building_id": @"14", @"building_name": NSLocalizedString(@"Watchtower", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"View incoming attacks, trades and reinforcements to your city from afar.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Watchtower to view more details of incoming attacks towards your City.", nil)};
    
    NSDictionary *row15 = @{@"building_id": @"15", @"building_name": NSLocalizedString(@"Library", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"Research various technology to improve your kingdom.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Library to unlock new research.", nil)};
    
    NSDictionary *row16 = @{@"building_id": @"16", @"building_name": NSLocalizedString(@"Blacksmith", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"The Blacksmith creates weapons and armor for your Troops and Hero.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Blacksmith to unlock more military and combat research.", nil)};
    
    NSDictionary *row17 = @{@"building_id": @"17", @"building_name": NSLocalizedString(@"Tavern", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"Taven allows you to recruit Spies to spy on your enemies.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Tavern to increase the amount of Spies you can train and have in the City. The more spies you have the harder to spy on you.", nil)};
    
    NSDictionary *row18 = @{@"building_id": @"18", @"building_name": NSLocalizedString(@"Rally Point", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"Increases your March size.", nil), @"info_chart": NSLocalizedString(@"Upgrade to increase your March capacity.", nil)};
    
    NSDictionary *row19 = @{@"building_id": @"101", @"building_name": NSLocalizedString(@"Castle", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"Castle unlocks new and higher level buildings.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Castle to unlock new and higher level buildings in your City.", nil)};
    
    NSDictionary *row20 = @{@"building_id": @"102", @"building_name": NSLocalizedString(@"Wall", nil), @"max_per_base": @"1", @"info": NSLocalizedString(@"Wall provides defense bonus againts enemy attacks.", nil), @"info_chart": NSLocalizedString(@"Upgrade your Wall to increase the defense bonus againts enemy attacks.", nil)};
    
    [self.wsBuildingArray addObjectsFromArray:@[row1, row2, row3, row4, row5, row6, row7, row8, row9, row10, row11, row12, row13, row14, row15, row16, row17, row18, row19, row20]];
}

- (NSDictionary *)getBuildingDict:(NSString *)building_id
{
    if (self.wsBuildingArray == nil)
    {
        [self updateBuildingArray];
    }
    
    NSDictionary *buildingDict = nil;
    
    for (NSDictionary *dict in self.wsBuildingArray)
    {
        if ([dict[@"building_id"] isEqualToString:building_id])
        {
            buildingDict = dict;
        }
    }
    
    return buildingDict;
}

- (void)updateBuildingLevel
{
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetBuildingLevel",
                       self.world_url];
    
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSMutableArray *returnArray = [Globals.i customParser:data];
    
    if (returnArray.count > 0)
    {
        self.wsBuildingLevelArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
    }
}

- (NSDictionary *)getBuildingLevel:(NSString *)building_id level:(NSUInteger)level
{
    if (self.wsBuildingLevelArray == nil)
    {
        [self updateBuildingLevel];
    }
    
    NSDictionary *buildingLevelDict = nil;
    
    for (NSDictionary *dict in self.wsBuildingLevelArray)
    {
        if (([dict[@"building_id"] isEqualToString:building_id]) &&
            ([dict[@"building_level"] integerValue] == level))
        {
            buildingLevelDict = dict;
        }
    }
    
    return buildingLevelDict;
}

- (NSDictionary *)getResearchDict:(NSString *)research_id
{
    if (self.wsResearchArray == nil)
    {
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetResearch",
                           self.world_url];
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSMutableArray *returnArray = [Globals.i customParser:data];
        
        if (returnArray.count > 0)
        {
            self.wsResearchArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
        }
    }
    
    NSDictionary *researchDict = nil;
    
    for (NSDictionary *dict in self.wsResearchArray)
    {
        if ([dict[@"research_id"] isEqualToString:research_id])
        {
            researchDict = dict;
        }
    }
    
    return researchDict;
}

- (NSString *)setDefaultBaseId
{
    NSString *baseid = @"0";
    
    NSString *wsurl = [NSString stringWithFormat:@"%@/GetBaseAll/%@",
                       self.world_url, self.wsWorldProfileDict[@"profile_id"]];
    
    NSURL *url = [[NSURL alloc] initWithString:wsurl];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    NSMutableArray *returnArray = [Globals.i customParser:data];
    
    if (returnArray.count > 0)
    {
        NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
        
        baseid = returnDict[@"base_id"];
        
        [self settSelectedBaseId:baseid];
    }
    else
    {
        //NO Base at all!
        [self trackEvent:@"setDefaultBaseId" action:@"GetBaseAll" label:Globals.i.wsWorldProfileDict[@"uid"]];
        
        [self changeUserLogout];
        
        [self showDialogError];
    }
    
    return baseid;
}

- (void)showItems:(NSString *)category2
{
    UIManager.i.tabViewTitle = @"Store";
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:category2 forKey:@"item_category2"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowItems"
                                                        object:self
                                                      userInfo:userInfo];
}

- (NSString *)getItemImageName:(NSString *)item_id
{
    NSString *image_name = @"0";
    
    if (self.wsItemArray == nil)
    {
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetItems/%@",
                           self.world_url, self.wsWorldProfileDict[@"profile_id"]];
        
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSMutableArray *returnArray = [Globals.i customParser:data];
        
        if (returnArray.count > 0)
        {
            self.wsItemArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
        }
    }
    
    for (NSDictionary *obj in Globals.i.wsItemArray)
    {
        if ([obj[@"item_id"] isEqualToString:item_id])
        {
            image_name = obj[@"item_image"];
        }
    }
    
    return image_name;
}

- (NSDictionary *)getItemDict:(NSString *)item_id
{
    NSDictionary *row1 = nil;
    
    if (self.wsItemArray == nil)
    {
        NSString *wsurl = [NSString stringWithFormat:@"%@/GetItems/%@",
                           self.world_url, self.wsWorldProfileDict[@"profile_id"]];
        
        NSURL *url = [[NSURL alloc] initWithString:wsurl];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        NSMutableArray *returnArray = [Globals.i customParser:data];
        
        if (returnArray.count > 0)
        {
            self.wsItemArray = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
        }
    }
    
    for (NSDictionary *obj in Globals.i.wsItemArray)
    {
        if ([obj[@"item_id"] isEqualToString:item_id])
        {
            row1 = obj;
        }
    }
    
    return row1;
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
    [UIManager.i showDialogBlockRow:dialogRows title:@"TroopList" type:3 :^(NSInteger index, NSString *text){ }];
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
    
    NSDictionary *row201 = @{@"r1": NSLocalizedString(@"Troop Type", nil), @"c1": NSLocalizedString(@"Amount", nil), @"r1_color": @"2", @"c1_color": @"2", @"c1_ratio": @"2.5", @"c1_align": @"2", @"r1_border": @"1", @"r1_align": @"3", @"bkg_prefix": @"bkg2", @"nofooter": @"1"};
    [rows1 addObject:row201];
    
    if (a1 > 0)
    {
        NSDictionary *row201 = @{@"i1": @"icon_a1", @"r1": Globals.i.a1, @"r1_border": @"1", @"c1": [Globals.i intString:a1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row201];
    }
    if (a2 > 0)
    {
        NSDictionary *row202 = @{@"i1": @"icon_a2", @"r1": Globals.i.a2, @"r1_border": @"1", @"c1": [Globals.i intString:a2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row202];
    }
    if (a3 > 0)
    {
        NSDictionary *row203 = @{@"i1": @"icon_a3", @"r1": Globals.i.a3, @"r1_border": @"1", @"c1": [Globals.i intString:a3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row203];
    }
    
    if (b1 > 0)
    {
        NSDictionary *row301 = @{@"i1": @"icon_b1", @"r1": Globals.i.b1, @"r1_border": @"1", @"c1": [Globals.i intString:b1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row301];
    }
    if (b2 > 0)
    {
        NSDictionary *row302 = @{@"i1": @"icon_b2", @"r1": Globals.i.b2, @"r1_border": @"1", @"c1": [Globals.i intString:b2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row302];
    }
    if (b3 > 0)
    {
        NSDictionary *row303 = @{@"i1": @"icon_b3", @"r1": Globals.i.b3, @"r1_border": @"1", @"c1": [Globals.i intString:b3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row303];
    }
    
    if (c1 > 0)
    {
        NSDictionary *row401 = @{@"i1": @"icon_c1", @"r1": Globals.i.c1, @"r1_border": @"1", @"c1": [Globals.i intString:c1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row401];
    }
    if (c2 > 0)
    {
        NSDictionary *row402 = @{@"i1": @"icon_c2", @"r1": Globals.i.c2, @"r1_border": @"1", @"c1": [Globals.i intString:c2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row402];
    }
    if (c3 > 0)
    {
        NSDictionary *row403 = @{@"i1": @"icon_c3", @"r1": Globals.i.c3, @"r1_border": @"1", @"c1": [Globals.i intString:c3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row403];
    }
    
    if (d1 > 0)
    {
        NSDictionary *row501 = @{@"i1": @"icon_d1", @"r1": Globals.i.d1, @"r1_border": @"1", @"c1": [Globals.i intString:d1], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row501];
    }
    if (d2 > 0)
    {
        NSDictionary *row502 = @{@"i1": @"icon_d2", @"r1": Globals.i.d2, @"r1_border": @"1", @"c1": [Globals.i intString:d2], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row502];
    }
    if (d3 > 0)
    {
        NSDictionary *row503 = @{@"i1": @"icon_d3", @"r1": Globals.i.d3, @"r1_border": @"1", @"c1": [Globals.i intString:d3], @"c1_ratio": @"2.5", @"c1_align": @"2"};
        [rows1 addObject:row503];
    }
    
    NSInteger total_troops = a1 + a2 + a3 + b1 + b2 + b3 + c1 + c2 + c3 + d1 + d2 + d3;
    
    NSDictionary *row203 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Total Troops: %@", nil), [Globals.i intString:total_troops]], @"nofooter": @"1"};
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

- (void)scheduleNotificationForDate:(NSDate *)date AlertBody:(NSString *)alertBody NotificationID:(NSString *)notificationID
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = date;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = alertBody;
    //localNotification.alertAction = actionButtonTitle;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:notificationID forKey:notificationID];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

- (void)cancelAllLocalNotification
{
    for (UILocalNotification *notify in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        [[UIApplication sharedApplication] cancelLocalNotification:notify];
    }
}

- (BOOL)cancelLocalNotification:(NSString*)notificationID
{
    //loop through all scheduled notifications and cancel the one we're looking for
    UILocalNotification *cancelThisNotification = nil;
    BOOL hasNotification = NO;
    
    for (UILocalNotification *someNotification in [[UIApplication sharedApplication] scheduledLocalNotifications])
    {
        if ([[someNotification.userInfo objectForKey:notificationID] isEqualToString:notificationID])
        {
            cancelThisNotification = someNotification;
            hasNotification = YES;
            break;
        }
    }
    if (hasNotification == YES)
    {
        NSLog(@"%@ ",cancelThisNotification);
        [[UIApplication sharedApplication] cancelLocalNotification:cancelThisNotification];
    }
    
    return hasNotification;
}

- (NSInteger)mapHeight
{
    NSString *map_height = @"100";
    
    if (self.wsSettingsDict != nil)
    {
        map_height = Globals.i.wsSettingsDict[@"map_height"];
    }
    
    return [map_height integerValue];
}

- (NSInteger)mapWidth
{
    NSString *map_width = @"100";
    
    if (self.wsSettingsDict != nil)
    {
        map_width = Globals.i.wsSettingsDict[@"map_width"];
    }
    
    return [map_width integerValue];
}

- (NSInteger)terrainGenerator:(NSInteger)x :(NSInteger)y
{
    int tile_type = 63;
    int seed = [self.wsProfileDict[@"world_id"] intValue];
    seed = seed+1;
    //int seed = 1;
    //NSLog(@" seed: %ld",(int)seed);
    int terrain_type = 0;
    int terrain_level = 0;
    int current_x = (int)x;
    int current_y = (int)y;
    int terrain_types = 6;
    int terrain_levels = 3;
    int formula_number =0;
    int sum_of_x_y = abs((current_x)-(current_y*current_y));
    
    //NSLog(@" sum_of_x_y: %ld",(long)sum_of_x_y);
    
    int sum_of_x_y_mod_10 = 0;
    
    sum_of_x_y_mod_10 = sum_of_x_y%10;
    
    switch (sum_of_x_y_mod_10)
    {
        case 9:
            formula_number=1;
            terrain_type = (abs((current_x*current_y+seed))%terrain_types)+1;
            terrain_level = (abs((current_x-current_y*seed))%terrain_levels)+1;
            break;
        case 8:
            formula_number=2;
            terrain_type = (abs((current_x+current_y-seed))%terrain_types)+1;
            terrain_level = (abs((current_x+current_y*seed))%terrain_levels)+1;
            break;
        case 7:
            formula_number=3;
            terrain_type = (abs((current_x+current_y+seed))%terrain_types)+1;
            terrain_level = (abs((current_x*current_y-seed))%terrain_levels)+1;
            break;
        case 6:
            formula_number=4;
            terrain_type = (abs((current_x-current_y*seed))%terrain_types)+1;
            terrain_level = (abs((current_x+current_y+seed))%terrain_levels)+1;
            break;
        case 5:
            formula_number=5;
            terrain_type = (abs((current_x+current_y*seed-seed))%terrain_types)+1;
            terrain_level = (abs((current_x-current_y*seed+seed))%terrain_levels)+1;
            break;
        case 4:
            formula_number=6;
            terrain_type = (abs((current_x*current_y-seed))%terrain_types)+1;
            terrain_level = (abs((current_x+current_y+seed))%terrain_levels)+1;
            break;
        case 3:
            formula_number=7;
            terrain_type = (abs((current_x-current_y*seed))%terrain_types)+1;
            terrain_level = (abs((current_x-current_y*seed))%terrain_levels)+1;
            break;
        case 2:
            formula_number=8;
            terrain_type = (abs((current_x*current_y+seed))%terrain_types)+1;
            terrain_level = (abs((current_x-current_y-seed))%terrain_levels)+1;
            break;
        default:
            formula_number=9;
            terrain_type = (abs((current_x+current_y*seed))%terrain_types)+1;
            terrain_level = (abs((current_x*current_y-seed))%terrain_levels)+1;
            break;
    }
    
    tile_type = (terrain_type*10)+terrain_level;
    
    /*
     NSLog(@" formula_number : %d",formula_number);
     NSLog(@" terrain_type : %d",terrain_type);
     NSLog(@" terrain_level : %d",terrain_level);
     NSLog(@" tile_type : %d",tile_type);
     */
    return (NSInteger)tile_type;
}

#pragma mark - Audio

- (void)playMusicLoading
{
    // If other music is already playing, nothing more to do here
    if ([self.audioSession isOtherAudioPlaying] || [self.music_intro isEqualToString:@"0"])
    {
        return;
    }
    
    [self.mapMusicPlayer stop];
    self.mapMusicPlayer.currentTime = 0;
    [self.queuePlayer pause];
    
    [self.loadingMusicPlayer prepareToPlay];
    [self.loadingMusicPlayer play];
}

- (void)playMusicMap
{
    // If other music is already playing, nothing more to do here
    if ([self.audioSession isOtherAudioPlaying] || [self.music_intro isEqualToString:@"0"])
    {
        return;
    }
    
    [self.loadingMusicPlayer stop];
    self.loadingMusicPlayer.currentTime = 0;
    [self.queuePlayer pause];
    
    [self.mapMusicPlayer prepareToPlay];
    [self.mapMusicPlayer play];
}

- (void)playMusicBackground
{
    [self.loadingMusicPlayer stop];
    self.loadingMusicPlayer.currentTime = 0;
    [self.mapMusicPlayer stop];
    self.mapMusicPlayer.currentTime = 0;
    
    [self.queuePlayer play];
}

- (void)configureAudioSession
{
    // Implicit initialization of audio session
    self.audioSession = [AVAudioSession sharedInstance];
    
    // Set category of audio session
    // See handy chart on pg. 46 of the Audio Session Programming Guide for what the categories mean
    // Not absolutely required in this example, but good to get into the habit of doing
    // See pg. 10 of Audio Session Programming Guide for "Why a Default Session Usually Isn't What You Want"
    
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying])
    {
        // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
    }
    else
    {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    
    if (setCategoryError)
    {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}

- (void)configureAudioPlayer
{
    //NSDictionary *m1 = @{@"path": @"1", @"type": @"mp3"}; //Loading
    //NSDictionary *m2 = @{@"path": @"2", @"type": @"mp3"}; //Map
    
    NSDictionary *m3 = @{@"path": @"3", @"type": @"mp3"};
    NSDictionary *m4 = @{@"path": @"4", @"type": @"mp3"};
    NSDictionary *m5 = @{@"path": @"5", @"type": @"mp3"};
    NSDictionary *m6 = @{@"path": @"6", @"type": @"mp3"};
    NSDictionary *m7 = @{@"path": @"7", @"type": @"mp3"};
    NSDictionary *m8 = @{@"path": @"8", @"type": @"mp3"};
    NSMutableArray *musicArray = [[NSMutableArray alloc] initWithObjects:m3, m4, m5, m6, m7, m8, nil];

    //Randomize a loading music
    NSUInteger count = [musicArray count];
    //NSUInteger randomNumber = arc4random() % count;
    //NSDictionary *rndm_music = musicArray[randomNumber];
    
    NSString *loadingMusicPath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"mp3"];
    NSURL *loadingMusicURL = [NSURL fileURLWithPath:loadingMusicPath];
    self.loadingMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:loadingMusicURL error:nil];
    self.loadingMusicPlayer.delegate = self;  // We need this so we can restart after interruptions
    self.loadingMusicPlayer.volume = 0.05f;
    self.loadingMusicPlayer.numberOfLoops = 0;	// Negative number means loop forever
    
    NSString *mapMusicPath = [[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp3"];
    NSURL *mapMusicURL = [NSURL fileURLWithPath:mapMusicPath];
    self.mapMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:mapMusicURL error:nil];
    self.mapMusicPlayer.delegate = self;
    self.mapMusicPlayer.volume = 0.05f;
    self.mapMusicPlayer.numberOfLoops = 0;
    
    for (NSUInteger i = 2; i < count; ++i)
    {
        // Select a random element between i and end of array to swap with.
        NSUInteger nElements = count - i;
        NSUInteger n = (arc4random() % nElements) + i;
        [musicArray exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    
    // Create audio playlist for background music
    for (NSDictionary *m in musicArray)
    {
        [self addToPlaylist:m[@"path"] ofType:m[@"type"]];
    }
}

- (void)addToPlaylist:(NSString*)pathForResource ofType:(NSString*)ofType
{
    // Path to the audio file
    NSString *path = [[NSBundle mainBundle] pathForResource:pathForResource ofType:ofType];
    
    // If we can access the file...
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:path]];
        
        if (self.queuePlayer == nil)
        {
            self.queuePlayer = [[AVQueuePlayer alloc] initWithPlayerItem:item];
            self.queuePlayer.volume = 0.02f;
        }
        else
        {
            [self.queuePlayer insertItem:item afterItem:nil];
        }
    }
    
}

- (void)configureSystemSound
{
    // File Formats (a.k.a. audio containers or extensions): CAF, AIF, WAV
    // Data Formats (a.k.a. audio encoding): linear PCM (such as LEI16) or IMA4
    NSString *sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_notification" ofType:@"mp3"];
    NSURL *sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_notification);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_farm" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_farm);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_archery" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_archery);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_barracks" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_barracks);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_blacksmith" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_blacksmith);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_castle" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_castle);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_embassy" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_embassy);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_hospital" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_hospital);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_house" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_house);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_library" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_library);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_market" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_market);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_mine" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_mine);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_quarry" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_quarry);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_rallypoint" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_rallypoint);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_sawmill" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_sawmill);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_siege" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_siege);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_stable" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_stable);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_storehouse" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_storehouse);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_tavern" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_tavern);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_wall" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_wall);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"building_watchtower" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_watchtower);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_attack" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_attack);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_button" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_button);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_gold" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_gold);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_march" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_march);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_messages" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_messages);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_placement" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_placement);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_speedup" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_speedup);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_training" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_training);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_build" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_build);
    
    sfxPath = [[NSBundle mainBundle] pathForResource:@"sfx_destroy" ofType:@"mp3"];
    sfxURL = [NSURL fileURLWithPath:sfxPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)sfxURL, &_sfx_destroy);
}

- (void)play_archery
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_archery);
}

- (void)play_barracks
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_barracks);
}

- (void)play_blacksmith
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_blacksmith);
}

- (void)play_castle
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_castle);
}

- (void)play_embassy
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_embassy);
}

- (void)play_farm
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_farm);
}

- (void)play_hospital
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_hospital);
}

- (void)play_house
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_house);
}

- (void)play_library
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_library);
}

- (void)play_market
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_market);
}

- (void)play_mine
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_mine);
}

- (void)play_quarry
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_quarry);
}

- (void)play_rallypoint
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_rallypoint);
}

- (void)play_sawmill
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_sawmill);
}

- (void)play_siege
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_siege);
}

- (void)play_stable
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_stable);
}

- (void)play_storehouse
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_storehouse);
}

- (void)play_tavern
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_tavern);
}

- (void)play_wall
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_wall);
}

- (void)play_watchtower
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_watchtower);
}

- (void)play_attack
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_attack);
}

- (void)play_gold
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_gold);
}

- (void)play_march
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_march);
}

- (void)play_messages
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_messages);
}

- (void)play_notification
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_notification);
}

- (void)play_placement
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_placement);
}

- (void)play_speedup
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_speedup);
}

- (void)play_training
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_training);
}

- (void)play_build
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_build);
}

- (void)play_destroy
{
    if ([self.sound_fx isEqualToString:@"1"])
        AudioServicesPlaySystemSound(self.sfx_destroy);
}

- (void)play_button
{
    //if ([self.sound_fx isEqualToString:@"1"])
    //    AudioServicesPlaySystemSound(self.sfx_button);
}

- (UIImage *)imageNamedCustom:(NSString *)image_name
{
    if ([Globals.i.always_download_graphicpack isEqualToString:@"1"])
    {
        NSString *fileName = [NSString stringWithFormat:@"/GraphicPack_%@/%@.png", [self graphic_pack_id], image_name];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        //NSLog(@"Image File: %@", dataPath);
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        {
            return [UIImage imageWithContentsOfFile:dataPath];
        }
        else
        {
            return [UIImage imageNamed:image_name];
        }
    }
    else
    {
        return [UIImage imageNamed:image_name];
    }
}

//TimerView Methods
- (void)popTvStack:(NSInteger)tv_id
{
    TimerView *timerViewPoped;
    
    if (self.tvStack == nil)
    {
        self.tvStack = [[NSMutableArray alloc] init];
    }
    else
    {
        NSInteger rowRemoved = 999;
        for (NSInteger i = 0; i < [self.tvStack count]; i++)
        {
            if ([(TimerView *)self.tvStack[i] tv_id] == tv_id)
            {
                rowRemoved = i;
                timerViewPoped = self.tvStack[i];
                [(TimerView *)self.tvStack[i] removeFromSuperview];
                [self.tvStack removeObjectAtIndex:i];
            }
        }
        
        if ((rowRemoved != 999) || (rowRemoved == [self.tvStack count])) //Set frame for rest of TimerView's
        {
            NSInteger maxRow = [self.tvStack count];
            for (NSInteger i = rowRemoved; i < maxRow; i++)
            {
                TimerView *tv = (TimerView *)self.tvStack[i];
                CGFloat tv_x = tv.frame.origin.x;
                CGFloat tv_y = tv.frame.origin.y - tvHeight;
                
                [tv setFrame:CGRectMake(tv_x, tv_y, tvWidth, tvHeight)];
            }
        }
    }
    
    [self updateTimerHolder];
}

- (void)updateTv:(NSInteger)tv_id time:(NSInteger)time title:(NSString *)title
{
    [self updateTv:tv_id base_id:self.wsBaseDict[@"base_id"] time:time title:title is_return:NO will_return:NO];
}

- (void)updateTv:(NSInteger)tv_id base_id:(NSString *)base_id time:(NSInteger)time title:(NSString *)title
{
    [self updateTv:tv_id base_id:self.wsBaseDict[@"base_id"] time:time title:title is_return:NO will_return:NO];
}

- (void)updateTv:(NSInteger)tv_id time:(NSInteger)time title:(NSString *)title is_return:(BOOL)is_return will_return:(BOOL)will_return
{
    [self updateTv:tv_id base_id:self.wsBaseDict[@"base_id"] time:time title:title is_return:is_return will_return:will_return];
}

//Only changes MASTER not clones as the reference for clones are not here (Currently used only for reinforcement)
- (void)updateTv:(NSInteger)tv_id base_id:(NSString *)base_id time:(NSInteger)time title:(NSString *)title is_return:(BOOL)is_return will_return:(BOOL)will_return
{
    NSLog(@"updateTv");
    
    ((TimerView *)self.tvViews[tv_id]).TotalTimer = time; //Overwritten in UpdateTimer
    ((TimerView *)self.tvViews[tv_id]).strJob = title;
    ((TimerView *)self.tvViews[tv_id]).base_id = base_id;
    ((TimerView *)self.tvViews[tv_id]).is_return = is_return;
    ((TimerView *)self.tvViews[tv_id]).will_return = will_return;
    [self pushTvStack:((TimerView *)self.tvViews[tv_id])];
    
    [((TimerView *)self.tvViews[tv_id]) updateView];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TVStackUpdated"
                                                        object:self
                                                      userInfo:nil];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:@(tv_id) forKey:@"tv_id"];
    [userInfo setObject:@(time) forKey:@"time"];
    [userInfo setObject:title forKey:@"title"];
    [userInfo setObject:base_id forKey:@"base_id"];
    [userInfo setObject:@(is_return) forKey:@"is_return"];
    [userInfo setObject:@(will_return) forKey:@"will_return"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTimer"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)flushTvStack
{
    if (self.tvStack == nil)
    {
        self.tvStack = [[NSMutableArray alloc] init];
    }
    else
    {
        for (TimerView *tv in self.tvStack)
        {
            [tv removeFromSuperview];
        }
        
        self.tvStack = [[NSMutableArray alloc] init];
    }
}

- (void)updateTimerHolder
{
    if (self.timerHolder == nil)
    {
        self.timerHolder = [[TimerHolder alloc] init];
    }
    
    [self.timerHolder updateView];
}

- (BOOL)isThereTvView:(NSInteger)tv_id
{
    BOOL result = NO;
    
    for (TimerView *tv in self.tvStack)
    {
        if (tv.tv_id == tv_id)
        {
            result = YES;
        }
    }
    
    return result;
}

- (TimerView *)copyTvViewFromStack:(NSInteger)tv_id
{
    NSLog(@"Copying : %ld",(long)tv_id);
    TimerView *tv_view;
    
    for (TimerView *tv in self.tvStack)
    {
        if (tv.tv_id == tv_id)
        {
            tv_view = [[TimerView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, 46.0f*SCALE_IPAD)];
            tv_view.tv_id = tv.tv_id;
            tv_view.TotalTimer = tv.TotalTimer;
            tv_view.timer1 = tv.timer1;
            //tv_view.action_time = tv.action_time;
            tv_view.strJob = tv.strJob;
            tv_view.base_id = tv.base_id;
            tv_view.is_return = tv.is_return;
            tv_view.will_return = tv.will_return;
            tv_view.is_action = tv.is_action;
            tv_view.is_clone = YES;
            [tv_view updateView];
        }
    }
    
    return tv_view;
}

- (BOOL)isTvViewFromStack:(NSInteger)tv_id
{
    BOOL result = NO;
    
    for (TimerView *tv in self.tvStack)
    {
        if (tv.tv_id == tv_id)
        {
            result = YES;
        }
    }
    
    return result;
}

- (void)pushTvStack:(TimerView *)tv
{
    NSInteger intStack = 0;
    
    if (self.tvStack == nil)
    {
        self.tvStack = [[NSMutableArray alloc] init];
        intStack = 0;
    }
    else
    {
        intStack = [self.tvStack count];
    }
    
    float tv_y = 0.0f + (tvHeight * intStack);
    [tv setFrame:CGRectMake(0.0f, tv_y, tvWidth, tvHeight)];
    
    [self.tvStack addObject:tv];
    
    [self updateTimerHolder];
}

- (void)setTimerViewTitle:(NSInteger)tv_id :(NSString *)title
{
    [self setTimerViewTitle:tv_id base_id:self.wsBaseDict[@"base_id"] title:title];
}

- (NSString *)fetchTimerViewTitle:(NSInteger)tv_id
{
    return [self fetchTimerViewTitle:tv_id base_id:self.wsBaseDict[@"base_id"]];
}

- (void)setTimerViewParameter:(NSInteger)tv_id :(NSString *)parameter_name :(NSString *)parameter_value
{
    [self setTimerViewParameter:tv_id base_id:self.wsBaseDict[@"base_id"] param_name:parameter_name param_value:parameter_value];
}

- (NSString *)fetchTimerViewParameter:(NSInteger)tv_id :(NSString *)parameter_name
{
    return [self fetchTimerViewParameter:tv_id base_id:self.wsBaseDict[@"base_id"] param_name:parameter_name];
}

- (void)setTimerViewTitle:(NSInteger)tv_id base_id:(NSString *)base_id title:(NSString *)title
{
    NSString *key = [NSString stringWithFormat:@"tv_%@_%@", [@(tv_id) stringValue], base_id];
    
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setTimerViewParameter:(NSInteger)tv_id base_id:(NSString *)base_id param_name:(NSString *)parameter_name param_value:(NSString *)parameter_value
{
    NSString *key = [NSString stringWithFormat:@"tv_%@_%@_%@", [@(tv_id) stringValue], base_id, parameter_name];
    
    NSLog(@"setTimerViewParameter : %@ : %@", key,parameter_value);
    
    [[NSUserDefaults standardUserDefaults] setObject:parameter_value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)fetchTimerViewTitle:(NSInteger)tv_id base_id:(NSString *)base_id
{
    NSString *key = [NSString stringWithFormat:@"tv_%@_%@", [@(tv_id) stringValue], base_id];
    
    NSString *title = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (title == nil)
    {
        title = @"";
    }
    
    return title;
}

- (NSString *)fetchTimerViewParameter:(NSInteger)tv_id base_id:(NSString *)base_id param_name:(NSString *)parameter_name
{
    NSString *key = [NSString stringWithFormat:@"tv_%@_%@_%@", [@(tv_id) stringValue], base_id, parameter_name];
    
    NSString *parameter_value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    NSLog(@"fetchTimerViewParameter : %@ : %@", key,parameter_value);
    
    if (parameter_value == nil)
    {
        parameter_value = @"";
    }
    
    return parameter_value;
}

@end
