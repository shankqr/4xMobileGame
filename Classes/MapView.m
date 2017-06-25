//
//  MapView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 9/6/13.
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

#import "MapView.h"
#import "TileView.h"
#import "XyBox.h"
#import "BookmarkList.h"
#import "BookmarkCreate.h"
#import "DialogTerrain.h"
#import "DialogCity.h"
#import "DialogVillage.h"
#import "Globals.h"
#import "TimerHolder.h"
#import "Kingdom-Swift.h"

#define f_height (20.0f*SCALE_IPAD)

@interface MapView () <UIScrollViewDelegate, TiledScrollViewDelegate>

@property (nonatomic, strong) TiledScrollView *scrollView;
@property (nonatomic, strong) UIButton *btnHome;
@property (nonatomic, strong) UIButton *btnBookmark;
@property (nonatomic, strong) UIButton *btnSearch;
@property (nonatomic, strong) UIButton *btnFullscreen;
@property (nonatomic, strong) UILabel *lblFooter;
@property (nonatomic, strong) UILabel *lblArrow;
@property (nonatomic, strong) XyBox *xyBox;
@property (nonatomic, strong) BookmarkList *bookmarkList;
@property (nonatomic, strong) BookmarkCreate *bookmarkCreate;
@property (nonatomic, strong) DialogTerrain *dialogTerrain;
@property (nonatomic, strong) DialogCity *dialogCity;
@property (nonatomic, strong) DialogVillage *dialogVillage;

@property (nonatomic, assign) CGPoint point_center_prev;
@property (nonatomic, assign) NSInteger map_size_x;
@property (nonatomic, assign) NSInteger map_size_y;
@property (nonatomic, assign) BOOL isFullScreen;

@end

@implementation MapView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isFullScreen = NO;
    [self resizeView];
    
    CGFloat btn_box_size = 32.0f*SCALE_IPAD;
    
    if (self.btnHome == nil)
    {
        self.btnHome = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, btn_box_size, btn_box_size)];
        [self.btnHome setBackgroundImage:[Globals.i imageNamedCustom:@"button_home"] forState:UIControlStateNormal];
        [self.btnHome addTarget:self action:@selector(home_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnHome];
    }
    
    if (self.btnSearch == nil)
    {
        self.btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(btn_box_size+5.0f*SCALE_IPAD, 0.0f, btn_box_size, btn_box_size)];
        [self.btnSearch setBackgroundImage:[Globals.i imageNamedCustom:@"button_search_map"] forState:UIControlStateNormal];
        [self.btnSearch addTarget:self action:@selector(search_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnSearch];
    }
    
    if (self.btnBookmark == nil)
    {
        self.btnBookmark = [[UIButton alloc] initWithFrame:CGRectMake(btn_box_size*2+10.0f*SCALE_IPAD, 0.0f, btn_box_size, btn_box_size)];
        [self.btnBookmark setBackgroundImage:[Globals.i imageNamedCustom:@"button_bookmark"] forState:UIControlStateNormal];
        [self.btnBookmark addTarget:self action:@selector(bookmark_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnBookmark];
    }
    
    if (self.btnFullscreen == nil)
    {
        self.btnFullscreen = [[UIButton alloc] initWithFrame:CGRectMake(btn_box_size*3+15.0f*SCALE_IPAD, 0.0f, btn_box_size, btn_box_size)];
        [self.btnFullscreen setBackgroundImage:[Globals.i imageNamedCustom:@"button_fullscreen"] forState:UIControlStateNormal];
        [self.btnFullscreen addTarget:self action:@selector(fullscreen_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnFullscreen];
    }
    
    if (self.lblFooter == nil)
    {
        self.lblFooter = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height-f_height, self.view.frame.size.width, f_height)];
        [self.lblFooter setNumberOfLines:1];
        self.lblFooter.textAlignment = NSTextAlignmentCenter;
        [self.lblFooter setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE]];
        [self.lblFooter setBackgroundColor:[UIColor blackColor]];
        [self.lblFooter setTextColor:[UIColor whiteColor]];
        self.lblFooter.minimumScaleFactor = 1.0;
        [self.view addSubview:self.lblFooter];
    }
    [self.lblFooter setHidden:YES];
    
    if (self.lblArrow == nil)
    {
        self.lblArrow = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 50.0f, 25.0f)];
        [self.lblArrow setNumberOfLines:1];
        self.lblArrow.textAlignment = NSTextAlignmentCenter;
        [self.lblArrow setFont:[UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE]];
        [self.lblArrow setBackgroundColor:[UIColor blackColor]];
        [self.lblArrow setTextColor:[UIColor whiteColor]];
        self.lblArrow.minimumScaleFactor = 0.5;
        [self.view addSubview:self.lblArrow];
    }
    [self.lblArrow setHidden:YES];
    self.lblArrow.text = @"";
    
    self.goto_map_x = -1;
    self.goto_map_y = -1;
    
    self.btnBookmark.hidden = YES;
    self.btnFullscreen.hidden = YES;
    self.btnHome.hidden = YES;
    self.btnSearch.hidden = YES;
    

}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TileSelected"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GotoTile"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BookmarkTile"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ExitFullscreen"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"RefreshMap"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TimerViewEnd"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TVStackUpdated"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"Map_Home"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"Map_Search"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"Map_Fullscreen"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"Map_Bookmark"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CenterOnTile"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"TileSelected"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSNumber *x = [userInfo objectForKey:@"tile_x"];
        NSNumber *y = [userInfo objectForKey:@"tile_y"];
        
        //NSLog(@"TileSelected x: %d y: %d",[x integerValue],[y integerValue]);
        
        [self tileSelected:[x integerValue] andRow:[y integerValue]];
         
    }
    else if ([[notification name] isEqualToString:@"GotoTile"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *x = [userInfo objectForKey:@"x"];
        NSString *y = [userInfo objectForKey:@"y"];
        
        [self gotoTile:[x integerValue] :[y integerValue]];
    }
    else if ([[notification name] isEqualToString:@"BookmarkTile"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *default_title = [userInfo objectForKey:@"default_title"];
        NSString *x = [userInfo objectForKey:@"x"];
        NSString *y = [userInfo objectForKey:@"y"];
        
        self.bookmarkCreate = [[BookmarkCreate alloc] initWithStyle:UITableViewStylePlain];
        self.bookmarkCreate.defaultTitle = default_title;
        self.bookmarkCreate.map_x = [x integerValue];
        self.bookmarkCreate.map_y = [y integerValue];
        self.bookmarkCreate.title = @"Create Bookmark";
        [self.bookmarkCreate updateView];
        
        [UIManager.i showTemplate:@[self.bookmarkCreate] :NSLocalizedString(@"Create Bookmark", nil) :8];
    }
    else if ([[notification name] isEqualToString:@"ExitFullscreen"])
    {
        if (self.isFullScreen)
        {
            self.isFullScreen = NO;
            [self resizeView];
        }
    }
    else if ([[notification name] isEqualToString:@"RefreshMap"])
    {
        [self.scrollView refreshVisibleMap];
        //[self.scrollView layoutSubviews];
        
        if (!([[Globals.i fetchTimerViewParameter:TV_ATTACK :@"to_map_x"] isEqualToString:@""]) && !([[Globals.i fetchTimerViewParameter:TV_ATTACK :@"to_map_y"] isEqualToString:@""]))
        {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:[@(TV_ATTACK) stringValue] forKey:@"tv_id"];
            [userInfo setObject:[Globals.i fetchTimerViewParameter:TV_ATTACK :@"to_map_x"] forKey:@"to_x"];
            [userInfo setObject:[Globals.i fetchTimerViewParameter:TV_ATTACK :@"to_map_y"] forKey:@"to_y"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DrawMarchingLine"
                                                                object:self
                                                              userInfo:userInfo];
        }
        else
        {
            NSLog(@"fetchTimerViewParameter value nil");
        }
            
    }
    else if ([[notification name] isEqualToString:@"Map_Home"])
    {
        [self mapHome];
    }
    else if ([[notification name] isEqualToString:@"Map_Bookmark"])
    {
        [self mapBookmark];
    }
    else if ([[notification name] isEqualToString:@"Map_Fullscreen"])
    {
        [self mapFullscreen];
    }
    else if ([[notification name] isEqualToString:@"Map_Search"])
    {
        [self mapSearch];
    }
    else if ([[notification name] isEqualToString:@"CenterOnTile"])
    {
        
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo!=nil)
        {
            NSNumber *tutorial_step = [userInfo objectForKey:@"tutorial_step"];
            NSNumber *map_x = [userInfo objectForKey:@"coordinate_x"];
            NSNumber *map_y = [userInfo objectForKey:@"coordinate_y"];
            NSLog(@"Centering Map on Tile X : %ld Tile Y: %ld",(long)[map_x integerValue],(long)[map_y integerValue]);
            
            //NSNumber *centerX = [NSNumber numberWithDouble:UIScreen.mainScreen.bounds.size.width*0.5];
            //NSNumber *centerY = [NSNumber numberWithDouble:UIScreen.mainScreen.bounds.size.height*0.5];
            
            
            [self gotoTile: [map_x integerValue]:[map_y integerValue] :[tutorial_step integerValue]+1];
            
            [self.scrollView refreshVisibleMap];
            //NSLog(@"Done Centering");
            
        }
    }
}

- (UIView *)tileForTiledScrollView:(TiledScrollView *)tiledScrollView xIndex:(NSInteger)xIndex yIndex:(NSInteger)yIndex frame:(CGRect)frame
{
    TileView *tileView = [[TileView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, TILE_WIDTH, TILE_HEIGHT)];
    tileView.contentMode = UIViewContentModeScaleAspectFit;
    
    tileView.tile_x = @(xIndex);
    tileView.tile_y = @(yIndex);
    
    //NSLog(@"tileForTiledScrollView(%@,%@)", [@(xIndex) stringValue], [@(yIndex) stringValue]);
    
    NSString *tile_type = @"0";
    NSString *tile_owner = @"0";
    NSString *tile_label = @"0";
    NSString *tile_content = TILE_TERRAIN;
    
    NSDictionary *city_dict = nil;
    NSDictionary *village_dict = nil;
    NSInteger b_lvl = 0;
    
    NSMutableArray *map_city_array_copy = [[NSMutableArray alloc] initWithArray:Globals.i.map_city_array copyItems:YES];
    for (NSDictionary *dict in map_city_array_copy)
    {
        if (([dict[@"map_x"] integerValue] == xIndex) && ([dict[@"map_y"] integerValue] == yIndex))
        {
            city_dict = [[NSDictionary alloc] initWithDictionary:dict copyItems:YES];
            break;
        }
    }
    
    if (city_dict != nil)
    {
        b_lvl = [city_dict[@"building_level"] integerValue];
        if (b_lvl < 10)
        {
            tile_type = @"1";
        }
        else if (b_lvl < 17)
        {
            tile_type = @"2";
        }
        else
        {
            tile_type = @"3";
        }
        
        if ([city_dict[@"base_type"] isEqualToString:@"1"])
        {
            tile_type = [NSString stringWithFormat:@"8%@", tile_type];
        }
        else
        {
            tile_type = [NSString stringWithFormat:@"7%@", tile_type];
        }
        
        tile_owner = city_dict[@"profile_id"];
        
        if (![city_dict[@"alliance_tag"] isEqualToString:@""] && ![city_dict[@"profile_name"] isEqualToString:@""])
        {
            tile_label = [NSString stringWithFormat:@"(%@)%@", city_dict[@"alliance_tag"], city_dict[@"profile_name"]];
        }
        else if (![city_dict[@"profile_name"] isEqualToString:@""])
        {
            tile_label = city_dict[@"profile_name"];
        }
        
        if ([Globals.i.wsWorldProfileDict[@"profile_id"] isEqualToString:city_dict[@"profile_id"]])
        {
            if ([Globals.i.wsBaseDict[@"base_id"] isEqualToString:city_dict[@"base_id"]])
            {
                tile_content = TILE_CITY_MAIN;
            }
            else
            {
                tile_content = TILE_CITY_SECONDARY;
            }
        }
        else if ([city_dict[@"alliance_id"] isEqualToString:@"0"])
        {
            tile_content = TILE_CITY_ENEMY;
        }
        else if ([Globals.i.wsWorldProfileDict[@"alliance_id"] isEqualToString:city_dict[@"alliance_id"]])
        {
            tile_content = TILE_CITY_ALLIANCE_MEMBER;
        }
        else
        {
            tile_content = TILE_CITY_ENEMY;
        }
    }
    else
    {
        for (NSDictionary *dict in Globals.i.map_village_array)
        {
            if (([dict[@"map_x"] integerValue] == xIndex) && ([dict[@"map_y"] integerValue] == yIndex))
            {
                village_dict = [[NSDictionary alloc] initWithDictionary:dict copyItems:YES];
                break;
            }
        }
        
        if (village_dict != nil)
        {
            tile_content = TILE_VILLAGE;
            
            NSInteger v_lvl = [village_dict[@"village_level"] integerValue]; //Max is 10
            if (v_lvl < 4)
            {
                tile_type = @"71";
            }
            else if (v_lvl < 8)
            {
                tile_type = @"72";
            }
            else
            {
                tile_type = @"73";
            }
            
            b_lvl = v_lvl; //this will set the level label bellow
            
            tile_label = @"Village";
            tileView.backgroundColor = [UIColor redColor];
        }
        else if (([Globals.i mapWidth] > xIndex) && ([Globals.i mapHeight] > yIndex))
        {
            NSInteger terrain = [Globals.i terrainGenerator:xIndex :yIndex];
            tile_type = [@(terrain) stringValue];
        }
        else
        {
            tile_type = @"0";
        }
    }
    
    if (![tile_type isEqualToString:@"0"])
    {
        tileView.imageName = [NSString stringWithFormat:@"t%@", tile_type];
        
        if ([tile_owner isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]])
        {
            tileView.showFlag = @"1";
        }
        else
        {
            tileView.showFlag = @"0";
        }
        
        if (b_lvl > 0)
        {
            tileView.strLevel = [@(b_lvl) stringValue];
        }
        else
        {
            tileView.strLevel = @"0";
        }
        
        if (![tile_label isEqualToString:@""])
        {
            tileView.strLabel = tile_label;
        }
        else
        {
            tileView.strLabel = @"0";
        }
        
        tileView.tile_content = tile_content;
    }
    
    return tileView;
}

- (void)resizeView
{
    CGRect viewRect;
    
    if (self.isFullScreen)
    {
        viewRect = CGRectMake(0.0f,
                              0.0f,
                              UIScreen.mainScreen.bounds.size.width,
                              UIScreen.mainScreen.bounds.size.height);
        
        [UIManager.i setTemplateFrameType:2];
        [self.btnFullscreen setBackgroundImage:[Globals.i imageNamedCustom:@"button_smallscreen"] forState:UIControlStateNormal];
        
        self.btnBookmark.hidden = NO;
        self.btnFullscreen.hidden = NO;
        self.btnHome.hidden = NO;
        self.btnSearch.hidden = NO;
    }
    else
    {
        viewRect = CGRectMake(0.0f,
                              0.0f,
                              UIScreen.mainScreen.bounds.size.width,
                              UIScreen.mainScreen.bounds.size.height-SCREEN_OFFSET_MAINHEADER_Y-SCREEN_OFFSET_BOTTOM);
        
        [UIManager.i setTemplateFrameType:4];
        [self.btnFullscreen setBackgroundImage:[Globals.i imageNamedCustom:@"button_fullscreen"] forState:UIControlStateNormal];
        
        self.btnBookmark.hidden = YES;
        self.btnFullscreen.hidden = YES;
        self.btnHome.hidden = YES;
        self.btnSearch.hidden = YES;
    }
    
    [self.view setFrame:viewRect];
    [self.scrollView setFrame:viewRect];
    
    [self.lblFooter setFrame:CGRectMake(0.0f, self.view.frame.size.height-f_height, self.view.frame.size.width, f_height)];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (scrollView.zoomScale < 0.5)
    {
        Globals.i.mapzoom_big = NO;
    }
    else
    {
        Globals.i.mapzoom_big = YES;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScrollViewDidZoom" object:self];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    if (scrollView.zoomScale >= scrollView.maximumZoomScale)
    {
        [self.scrollView setBouncesZoom:YES];
    }
    else
    {
        [self.scrollView setBouncesZoom:NO];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale;
{
    [self refresh_scrollview_contentsize];
    
    // The scroll view has zoomed, so you need to re-center the contents
    //[self centerScrollViewContents];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    // Return the view that you want to zoom
    return self.scrollView.containerView;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
}

- (void)centerScrollViewContents
{
    CGSize boundsSize = self.scrollView.bounds.size;
    CGRect contentsFrame = self.scrollView.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width)
    {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    }
    else
    {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height)
    {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    }
    else
    {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.scrollView.containerView.frame = contentsFrame;
}

- (void)setupScrollView
{
    NSLog(@"setupScrollView");
    if (self.scrollView == nil)
    {
        self.scrollView = [[TiledScrollView alloc] initWithFrame:self.view.frame contentSize:CGSizeMake(0, 0) tiledDelegate:self tileSize:CGSizeMake(TILE_WIDTH, TILE_HEIGHT)];
        self.scrollView.delegate = self;
        [self.view insertSubview:self.scrollView atIndex:0];
    }
    else
    {
        //TODO: refresh current tiles on view
    }
    
    [self.view addSubview:Globals.i.timerHolder];
    [Globals.i updateTimerHolder];
}

- (void)refresh_scrollview_contentsize
{
    self.map_size_x = TILE_WIDTH*[Globals.i mapWidth]*self.scrollView.zoomScale;
    self.map_size_y = TILE_HEIGHT*[Globals.i mapHeight]*self.scrollView.zoomScale;
    
    self.scrollView.contentSize = CGSizeMake(self.map_size_x, self.map_size_y);
    [self.scrollView.containerView setFrame:CGRectMake(0.0f, 0.0f, self.map_size_x, self.map_size_y)];
}

- (void)updateView
{
    [UIManager.i showLoadingAlert];
    [self notificationRegister];
    
    if (Globals.i.map_village_array == nil)
    {
        [Globals.i getMapVillages:0 :^(BOOL success, NSData *data)
        {
            [self setupMapTerrain];
        }];
    }
    else
    {
        [self setupMapTerrain];
    }
    [UIManager.i removeLoadingAlert];

}

- (void)setupMapTerrain
{
    [self setupScrollView];
    [self refresh_scrollview_contentsize];
    [self gotoDefaultTile];
}

- (CGPoint)topLeftPoint:(NSInteger)map_x andRow:(NSInteger)map_y tutorialStep:(NSInteger)tutorial_step
{
    float h_tiles = [self total_tiles_x_axis];
    float v_tiles = [self total_tiles_y_axis];
    
    float h_width = h_tiles * TILE_WIDTH * self.scrollView.zoomScale;
    float v_height = v_tiles * TILE_HEIGHT * self.scrollView.zoomScale;
    
    float h_center = (h_width/2.0f);
    float v_center = (v_height/2.0f);
    
    float point_x = ((float)map_x + 0.5f) * TILE_WIDTH * self.scrollView.zoomScale;
    float point_y = ((float)map_y + 0.5f) * TILE_HEIGHT * self.scrollView.zoomScale;
    
    float start_x = point_x - h_center;
    float start_y = point_y - v_center;
    
    float offset_x = 0;
    float offset_y = 0;
    
    if (start_x < 0)
    {
        offset_x = start_x;
        start_x = 0;
    }
    else if (start_x > self.map_size_x-h_width)
    {
        offset_x = start_x - (self.map_size_x-h_width);
        start_x = self.map_size_x-h_width;
    }
    
    if (start_y < 0)
    {
        offset_y = start_y;
        start_y = 0;
    }
    else if (start_y > self.map_size_y-v_height)
    {
        offset_y = start_y - (self.map_size_y-v_height);
        start_y = self.map_size_y-v_height;
    }
    
    //NSLog(@"offset_x : %f",offset_x);
    //NSLog(@"offset_y : %f",offset_y);
    
    if(tutorial_step>0)
    {
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:[NSNumber numberWithInteger:tutorial_step]  forKey:@"tutorial_step"];
        
        if(iPad)
        {
            [userInfo setObject:[NSNumber numberWithDouble:100+offset_x/2]  forKey:@"hole_x"];
            [userInfo setObject:[NSNumber numberWithDouble:150+offset_y/2] forKey:@"hole_y"];
            [userInfo setObject:[NSNumber numberWithInteger:150] forKey:@"hole_w"];
            [userInfo setObject:[NSNumber numberWithInteger:150] forKey:@"hole_h"];
        }
        else
        {
            [userInfo setObject:[NSNumber numberWithDouble:90+offset_x/2]  forKey:@"hole_x"];
            [userInfo setObject:[NSNumber numberWithDouble:150+offset_y/2] forKey:@"hole_y"];
            [userInfo setObject:[NSNumber numberWithInteger:150] forKey:@"hole_w"];
            [userInfo setObject:[NSNumber numberWithInteger:150] forKey:@"hole_h"];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateHighlightedArea"
                                                            object:self
                                                          userInfo:userInfo];
    }
    
    return CGPointMake(start_x, start_y);
}

- (CGFloat)pointPairToBearingDegrees:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint
{
    CGPoint originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y); // get origin point to origin by subtracting end from start
    float bearingRadians = atan2f(originPoint.y, originPoint.x); // get bearing in radians
    float bearingDegrees = bearingRadians * (180.0 / M_PI); // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)); // correct discontinuity
    return bearingDegrees;
}

- (float)total_tiles_x_axis
{
    return self.scrollView.frame.size.width / TILE_WIDTH / self.scrollView.zoomScale;
}

- (float)total_tiles_y_axis
{
    return self.scrollView.frame.size.height / TILE_HEIGHT / self.scrollView.zoomScale;
}

- (CGPoint)centerTilePoint:(NSInteger)x andRow:(NSInteger)y
{
    float h_tiles = [self total_tiles_x_axis];
    float v_tiles = [self total_tiles_y_axis];
    
    float start_tile_x = (float)x / TILE_WIDTH;
    float start_tile_y = (float)y / TILE_HEIGHT;
    
    NSInteger center_x = start_tile_x + (h_tiles/2.0f);
    NSInteger center_y = start_tile_y + (v_tiles/2.0f);
    
    //Center
    CGFloat c_x = x + ((self.view.frame.size.width/2.0f) / self.scrollView.zoomScale);
    CGFloat c_y = y + ((self.view.frame.size.height/2.0f) / self.scrollView.zoomScale);
    CGPoint center_point = CGPointMake(c_x, c_y);
    //Home
    NSInteger h_x = [[Globals.i wsBaseDict][@"map_x"] integerValue];
    NSInteger h_y = [[Globals.i wsBaseDict][@"map_y"] integerValue];
    CGFloat home_x = ((CGFloat)h_x + 0.5f) * TILE_WIDTH;
    CGFloat home_y = ((CGFloat)h_y + 0.5f) * TILE_HEIGHT;
    CGPoint home_point = CGPointMake(home_x, home_y);
    
    CGFloat radians = [Globals.i pointPairToBearingRadians:center_point secondPoint:home_point];
    CGPoint edgePoint = [self radialIntersectionWithRadians:radians];
    
    CGFloat distance = [Globals.i distance2points:home_point secondPoint:center_point];
    
    [self drawArrow:edgePoint :radians :distance];
    
    CGPoint center_tile = CGPointMake(center_x, center_y);
    
    return center_tile;
}

- (void)drawArrow:(CGPoint)arrow_point :(CGFloat)angle :(CGFloat)distance
{
    //NSLog(@"Angle :%@", @(angle));
    
    CGFloat a_width = 70.0f*SCALE_IPAD;
    CGFloat a_height = 25.0f*SCALE_IPAD;
    
    CGFloat a_x = 0;
    CGFloat a_y = arrow_point.y - a_height/2.0f;
    
    a_x = arrow_point.x - a_width;
    
    self.lblArrow.transform = CGAffineTransformIdentity;
    
    [self.lblArrow setFrame:CGRectMake(a_x, a_y, a_width, a_height)];
    NSInteger int_distance = distance;
    self.lblArrow.text = [NSString stringWithFormat:@"%@ M ➜", @(int_distance)];
    
    [self.lblArrow.layer setAnchorPoint:CGPointMake(1.0f, 0.5f)];
    [self.lblArrow setTransform:CGAffineTransformMakeRotation(angle)];
    
    CGFloat c_x = (self.view.frame.size.width/2.0f);
    CGFloat c_y = (self.view.frame.size.height/2.0f);
    CGPoint center_point = CGPointMake(c_x, c_y);
    
    CGFloat arrow_from_center = [Globals.i distance2points:arrow_point secondPoint:center_point];
    arrow_from_center = arrow_from_center / self.scrollView.zoomScale;
    
    if (distance > arrow_from_center)
    {
        [self.lblArrow setHidden:NO];
    }
    else
    {
        [self.lblArrow setHidden:YES];
    }
}

- (CGPoint)radialIntersectionWithRadians:(CGFloat)radians
{
    radians = fmodf(radians, 2 * M_PI);
    if (radians < 0)
    {
        radians += (CGFloat)(2 * M_PI);
    }
    
    return [self radialIntersectionWithConstrainedRadians:radians];
}

- (CGPoint)radialIntersectionWithConstrainedRadians:(CGFloat)radians
{
    // This method requires 0 <= radians < 2 * π.
    CGRect frame = self.view.frame;
    CGFloat xRadius = frame.size.width / 2;
    CGFloat yRadius = frame.size.height / 2;
    
    CGPoint pointRelativeToCenter;
    CGFloat tangent = tanf(radians);
    CGFloat y = xRadius * tangent;
    // An infinite line passing through the center at angle `radians`
    // intersects the right edge at Y coordinate `y` and the left edge
    // at Y coordinate `-y`.
    if (fabs(y) <= yRadius)
    {
        // The line intersects the left and right edges before it intersects
        // the top and bottom edges.
        if (radians < (CGFloat)M_PI_2 || radians > (CGFloat)(M_PI + M_PI_2))
        {
            // The ray at angle `radians` intersects the right edge.
            pointRelativeToCenter = CGPointMake(xRadius, y);
        }
        else
        {
            // The ray intersects the left edge.
            pointRelativeToCenter = CGPointMake(-xRadius, -y);
        }
    }
    else
    {
        // The line intersects the top and bottom edges before it intersects
        // the left and right edges.
        CGFloat x = yRadius / tangent;
        if (radians < (CGFloat)M_PI)
        {
            // The ray at angle `radians` intersects the bottom edge.
            pointRelativeToCenter = CGPointMake(x, yRadius);
        }
        else
        {
            // The ray intersects the top edge.
            pointRelativeToCenter = CGPointMake(-x, -yRadius);
        }
    }
    
    return CGPointMake(pointRelativeToCenter.x + CGRectGetMidX(frame),
                       pointRelativeToCenter.y + CGRectGetMidY(frame));
}

- (void)animateFooter:(float)duration
{
    self.lblFooter.hidden = NO;
    self.lblFooter.alpha = 1;
    [UIView animateWithDuration:duration animations:^{
        self.lblFooter.alpha = 0;
    } completion: ^(BOOL finished) {
        self.lblFooter.hidden = finished;
    }];
}

- (void)showDialogTerrain:(NSString *)dialog_title :(NSInteger)x andRow:(NSInteger)y
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    if (self.dialogTerrain == nil)
    {
        self.dialogTerrain = [[DialogTerrain alloc] initWithStyle:UITableViewStylePlain];
    }
    
    self.dialogTerrain.map_x = x;
    self.dialogTerrain.map_y = y;
    self.dialogTerrain.title = dialog_title;
    [self.dialogTerrain updateView];
    
    [UIManager.i showTemplate:@[self.dialogTerrain] :@"Terrain Tile" :9];
}

- (void)showDialogCity:(NSString *)dialog_title :(NSDictionary *)dict :(NSInteger)x andRow:(NSInteger)y
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    if (self.dialogCity == nil)
    {
        self.dialogCity = [[DialogCity alloc] initWithStyle:UITableViewStylePlain];
    }
    self.dialogCity.city_dict = [dict mutableCopy];
    self.dialogCity.map_x = x;
    self.dialogCity.map_y = y;
    self.dialogCity.title = dialog_title;
    [self.dialogCity updateView];
    
    [UIManager.i showTemplate:@[self.dialogCity] :dialog_title :9];
}

- (void)showDialogVillage:(NSDictionary *)dict :(NSInteger)x andRow:(NSInteger)y
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    if (self.dialogVillage == nil)
    {
        self.dialogVillage = [[DialogVillage alloc] initWithStyle:UITableViewStylePlain];
    }
    self.dialogVillage.village_dict = [dict mutableCopy];
    self.dialogVillage.map_x = x;
    self.dialogVillage.map_y = y;
    self.dialogVillage.title = @"Barbarian Village";
    [self.dialogVillage updateView];
    
    [UIManager.i showTemplate:@[self.dialogVillage] :@"Barbarian Tile" :9];
}

- (void)tileMoving:(NSInteger)xIndex yIndex:(NSInteger)yIndex
{
    if ((xIndex >= 0) && (yIndex >= 0))
    {
        CGPoint cp = [self centerTilePoint:xIndex andRow:yIndex];
        
        self.lblFooter.text = [NSString stringWithFormat:@"X:%@ Y:%@", @(cp.x), @(cp.y)];
        
        [self animateFooter:1.0];
        
        if (!CGPointEqualToPoint(self.point_center_prev, cp))
        {
            float h_tiles = [self total_tiles_x_axis];
            float v_tiles = [self total_tiles_y_axis];
            
            Globals.i.map_center_x = cp.x;
            Globals.i.map_center_y = cp.y;
            Globals.i.map_tiles_x = (NSInteger)roundf(h_tiles);
            Globals.i.map_tiles_y = (NSInteger)roundf(v_tiles);
            
            [Globals.i getRegions:^(BOOL success, NSData *data){}];
        }
        
        self.point_center_prev = cp;
    }
}

- (void)tileSelected:(NSInteger)x andRow:(NSInteger)y
{
    self.lblFooter.text = [NSString stringWithFormat:@"X:%@ Y:%@", @(x), @(y)];
    
    [self animateFooter:2.0];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    NSString *tile_name = NSLocalizedString(@"Terrain", nil);
    
    NSDictionary *city_dict = nil;
    NSMutableArray *map_city_array_copy = [[NSMutableArray alloc] initWithArray:Globals.i.map_city_array copyItems:YES];
    for (NSDictionary *dict in map_city_array_copy)
    {
        if (([dict[@"map_x"] integerValue] == x) && ([dict[@"map_y"] integerValue] == y))
        {
            city_dict = dict;
            break;
        }
    }
    
    if (city_dict != nil)
    {
        if (![city_dict[@"base_name"] isEqualToString:@""])
        {
            tile_name = city_dict[@"base_name"];
        }
        else
        {
            tile_name = NSLocalizedString(@"Unknown City", nil);
        }
        
        [self showDialogCity:tile_name :city_dict :x andRow:y];
    }
    else
    {
        NSDictionary *village_dict = nil;
        
        for (NSDictionary *dict in Globals.i.map_village_array)
        {
            if (([dict[@"map_x"] integerValue] == x) && ([dict[@"map_y"] integerValue] == y))
            {
                village_dict = dict;
                break;
            }
        }
        
        if (village_dict != nil)
        {
            [self showDialogVillage:village_dict :x andRow:y];
        }
        else if (([Globals.i mapWidth] > x) && ([Globals.i mapHeight] > y))
        {
            NSInteger tile_type = [Globals.i terrainGenerator:x :y];
            
            if ((tile_type > 10) && (tile_type < 20))
            {
                tile_name = NSLocalizedString(@"Desert", nil);
            }
            else if ((tile_type > 20) && (tile_type < 30))
            {
                tile_name = NSLocalizedString(@"Lake", nil);
            }
            else if ((tile_type > 30) && (tile_type < 40))
            {
                tile_name = NSLocalizedString(@"Plains", nil);
            }
            else if ((tile_type > 40) && (tile_type < 50))
            {
                tile_name = NSLocalizedString(@"Forest", nil);
            }
            else if ((tile_type > 50) && (tile_type < 60))
            {
                tile_name = NSLocalizedString(@"Hills", nil);
            }
            else if ((tile_type > 60) && (tile_type < 70))
            {
                tile_name = NSLocalizedString(@"Mountain", nil);
            }
            
            [self showDialogTerrain:tile_name :x andRow:y];
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmptyHeader" object:self];
}

- (void)gotoTile:(NSInteger)map_x :(NSInteger)map_y
{
    [self gotoTile:map_x :map_y :0];
}

- (void)gotoTile:(NSInteger)map_x :(NSInteger)map_y :(NSInteger)tutorial_step
{
    //NSLog(@"gotoTile");
    if ((map_x < [Globals.i mapWidth]) && (map_x >= 0) && (map_y < [Globals.i mapHeight]) && (map_y >= 0))
    {
        self.scrollView.contentOffset = [self topLeftPoint:map_x andRow:map_y tutorialStep:tutorial_step];
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"Coordinates are out of bounds!", nil) title:@"CoordinateOutOfBounds"];
    }
}

- (void)searchMap
{
    self.xyBox = [[XyBox alloc] initWithStyle:UITableViewStylePlain];
    [self.xyBox updateView];
    self.xyBox.title = @"Search";
    
    [UIManager.i showTemplate:@[self.xyBox] :NSLocalizedString(@"Search", nil) :8];
}

- (void)gotoDefaultTile
{
    if (self.goto_map_x == -1 && self.goto_map_y == -1)
    {
        [self gotoHome];
    }
    else
    {
        [self gotoTile:self.goto_map_x :self.goto_map_y];
    }
}

- (void)gotoHome
{
    //Get current base coordinate
    NSString *map_x = [Globals.i wsBaseDict][@"map_x"];
    NSString *map_y = [Globals.i wsBaseDict][@"map_y"];
    
    [self gotoTile:[map_x integerValue] :[map_y integerValue]];
}

- (void)mapHome
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    [self gotoHome];
}

- (void)mapSearch
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    [self searchMap];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmptyHeader" object:self];
}

- (void)mapFullscreen
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    if (self.isFullScreen == YES)
    {
        self.isFullScreen = NO;
    }
    else
    {
        self.isFullScreen = YES;
    }
    
    [self resizeView];
}

- (void)mapBookmark
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseMapDialogs" object:self];
    
    if (self.bookmarkList == nil)
    {
        self.bookmarkList = [[BookmarkList alloc] initWithStyle:UITableViewStylePlain];
    }
    self.bookmarkList.title = @"Bookmarks";
    [self.bookmarkList updateView];
    
    [UIManager.i showTemplate:@[self.bookmarkList] :NSLocalizedString(@"Bookmarks", nil) :3];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EmptyHeader" object:self];
}

- (void)home_tap:(id)sender
{
    [self mapHome];
}

- (void)search_tap:(id)sender
{
    [self mapSearch];
}

- (void)fullscreen_tap:(id)sender
{
    [self mapFullscreen];
}

- (void)bookmark_tap:(id)sender
{
    [self mapBookmark];
}

@end
