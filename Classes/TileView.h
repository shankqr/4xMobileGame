//
//  TileView.h
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

@interface TileView : UIView

@property (nonatomic, strong) NSString *showFrame;
@property (nonatomic, strong) NSString *showFlag;
@property (nonatomic, strong) NSString *showCircle;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) NSString *strLevel;
@property (nonatomic, strong) NSString *strLabel;
@property (nonatomic, strong) NSString *tile_content;

@property (nonatomic, strong) NSNumber *tile_x;
@property (nonatomic, strong) NSNumber *tile_y;

@property (nonatomic, strong) UIImageView *imageTile;
@property (nonatomic, strong) UIImageView *imageCircle;
@property (nonatomic, strong) UIImageView *imageFlag;
@property (nonatomic, strong) UIImageView *imageLevel;

@end
