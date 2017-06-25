//
//  DynamicCell.m
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

#import "DynamicCell.h"
#import "CellView.h"

@interface DynamicCell ()

@end

@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.cellview = [[CellView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.cellview];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    [self.cellview setHighlighted:highlighted];
}

- (void)drawCell:(NSDictionary *)rd cellWidth:(float)cell_width
{
    [self.cellview drawCell:rd cellWidth:cell_width];
}

#pragma mark - DynamicCell

+ (DynamicCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rd cellWidth:(float)cell_width
{
    DynamicCell *cell = (DynamicCell *)[tableView dequeueReusableCellWithIdentifier:@"DynamicCell"];
    
    if (cell == nil)
    {
        cell = [[DynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DynamicCell"];
    }
    
    [cell drawCell:rd cellWidth:cell_width];
    
    return cell;
}

+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width
{
    return [CellView dynamicCellHeight:rd cellWidth:cell_width];
}

@end
