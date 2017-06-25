//
//  DynamicCell.m
//  Battle Simulator 
//
//  Created by Shankar on 10/30/13.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "DynamicCell.h"

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
