//
//  DynamicCell.h
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 10/30/13.
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

@class CellView;

@interface DynamicCell : UITableViewCell

@property (nonatomic, strong) CellView *cellview;

+ (UITableViewCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rd cellWidth:(float)cell_width;
+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width;

@end
