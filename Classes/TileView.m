//
//  TileView.m
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

#import "TileView.h"
#import "Globals.h"

@interface TileView () <UIGestureRecognizerDelegate>

@end

@implementation TileView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;

        self.showFrame = @"0";
        self.showCircle = @"0";
        self.showFlag = @"0";
        self.imageName = @"0";
        self.strLevel = @"0";
        self.strLabel = @"0";
        self.tile_content = TILE_TERRAIN;
        
        UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleFingerTap.cancelsTouchesInView = YES;
        singleFingerTap.delegate = self;
        [self addGestureRecognizer:singleFingerTap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationReceived:)
                                                     name:@"TileSelected"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationReceived:)
                                                     name:@"ScrollViewDidZoom"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(notificationReceived:)
                                                     name:@"SelectTile"
                                                   object:nil];
    }
    
    return self;
}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"TileSelected"])
    {
        self.showCircle = @"0";
        [self drawCircle];
    }
    else if ([[notification name] isEqualToString:@"ScrollViewDidZoom"])
    {
        if (Globals.i.mapzoom_big)
        {
            [self renderTile];
        }
        else
        {
            [self.imageTile removeFromSuperview];
            [self.imageCircle removeFromSuperview];
            [self.imageLevel removeFromSuperview];
            [self.imageFlag removeFromSuperview];
        }
    }
    else if ([[notification name] isEqualToString:@"SelectTile"])
    {
        //Do not use this as more than one tile have the same tile_x,tile_y (why?)
        
        /*
        NSDictionary *userInfo = notification.userInfo;
        if(userInfo!=nil)
        {
            NSNumber *map_x = [userInfo objectForKey:@"coordinate_x"];
            NSNumber *map_y = [userInfo objectForKey:@"coordinate_y"];

            NSLog(@"Self Tile Tile X : %d Tile Y: %d",[self.tile_x integerValue],[self.tile_y integerValue]);

            if([self.tile_x isEqualToNumber: map_x]&&[self.tile_y isEqualToNumber:map_y])
            {
                NSLog(@"Selecting Tile on Tile X : %d Tile Y: %d",[map_x integerValue],[map_y integerValue]);
                NSLog(@"elf.imageName :%@",self.imageName);
                
                
                [self handleSingleTap:nil];
            }
            
        }
         */
    }

}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (Globals.i.mapzoom_big)
    {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.tile_x forKey:@"tile_x"];
        [userInfo setObject:self.tile_y forKey:@"tile_y"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TileSelected"
                                                            object:self
                                                          userInfo:userInfo];
        
        self.showCircle = @"1";
        [self drawCircle];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)drawCircle
{
    if ([self.showCircle isEqualToString:@"1"] && Globals.i.mapzoom_big)
    {
        if (self.imageCircle == nil)
        {
            self.imageCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, TILE_WIDTH, TILE_HEIGHT)];
        }
        [self.imageCircle setImage:[Globals.i imageNamedCustom:@"tile_circle"]];
        //[self.imageCircle setUserInteractionEnabled:YES];
        
        [self.imageCircle removeFromSuperview];
        [self insertSubview:self.imageCircle aboveSubview:self.imageTile];
    }
    else
    {
        [self.imageCircle removeFromSuperview];
    }
}

- (void)renderTile
{
    if (![self.imageName isEqualToString:@"0"])
    {
        if (self.imageTile == nil)
        {
            self.imageTile = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, TILE_WIDTH, TILE_HEIGHT)];
        }
        //[self.imageTile setUserInteractionEnabled:YES];
        [self.imageTile setImage:[Globals.i imageNamedCustom:self.imageName]];
        
        [self.imageTile removeFromSuperview];
        [self addSubview:self.imageTile];
    }
    else
    {
        [self.imageTile removeFromSuperview];
    }
    
    [self drawCircle];
    
    if (![self.strLevel isEqualToString:@"0"])
    {
        if (self.imageLevel == nil)
        {
            UIImage *image = [Globals.i imageNamedCustom:[NSString stringWithFormat:@"level_overlay_%@", self.strLevel]];
            NSInteger sizex = (image.size.width/2.0f);
            NSInteger sizey = (image.size.height/2.0f);
            
            self.imageLevel = [[UIImageView alloc] initWithFrame:CGRectMake(TILE_WIDTH-sizex, TILE_HEIGHT-sizey, sizex, sizey)];
            [self.imageLevel setImage:image];
            //[self.imageLevel setUserInteractionEnabled:YES];
        }
        [self.imageLevel removeFromSuperview];
        [self addSubview:self.imageLevel];
    }
    else
    {
        [self.imageLevel removeFromSuperview];
    }
    
    if ([self.showFrame isEqualToString:@"1"])
    {
        CGRect rectangle = CGRectMake(0.0f, 0.0f, TILE_WIDTH, TILE_HEIGHT);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 0.0f); //this is the transparent color
        CGContextSetRGBStrokeColor(context, 0.0f, 0.0f, 0.0f, 0.5f);
        CGContextFillRect(context, rectangle);
        CGContextStrokeRect(context, rectangle); //this will draw the border
    }
    
    if ([self.showFlag isEqualToString:@"1"])
    {
        if (self.imageFlag == nil)
        {
            self.imageFlag = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, TILE_HEIGHT-25.0f*SCALE_IPAD, 16.0f*SCALE_IPAD, 25.0f*SCALE_IPAD)];
        }
        [self.imageFlag setImage:[Globals.i imageNamedCustom:@"tile_flag"]];
        //[self.imageFlag setUserInteractionEnabled:YES];
        
        [self.imageFlag removeFromSuperview];
        [self addSubview:self.imageFlag];
    }
    else
    {
        [self.imageFlag removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect
{
    if (Globals.i.mapzoom_big)
    {
        [self renderTile];
    }
    else
    {
        [self.imageTile removeFromSuperview];
        [self.imageCircle removeFromSuperview];
        [self.imageLevel removeFromSuperview];
        [self.imageFlag removeFromSuperview];
    }
    
}

@end
