//
//  CellView.h
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 4/14/14.
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

#import <UIKit/UIKit.h>

@class RowView;

@interface CellView : UIView

@property (nonatomic, strong) UIButton *img1;
@property (nonatomic, strong) RowView *rv_n;
@property (nonatomic, strong) RowView *rv_a;
@property (nonatomic, strong) RowView *rv_b;
@property (nonatomic, strong) RowView *rv_c;
@property (nonatomic, strong) RowView *rv_d;
@property (nonatomic, strong) RowView *rv_e;
@property (nonatomic, strong) RowView *rv_f;
@property (nonatomic, strong) RowView *rv_g;

- (void)setHighlighted:(BOOL)highlight;
- (void)drawCell:(NSDictionary *)rd cellWidth:(float)cell_width;

+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width;

@end
