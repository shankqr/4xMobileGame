//
//  DynamicCell.h
//  Battle Simulator 
//
//  Created by Shankar on 10/30/13.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "CellView.h"

@interface DynamicCell : UITableViewCell

@property (nonatomic, strong) CellView *cellview;

+ (UITableViewCell *)dynamicCell:(UITableView *)tableView rowData:(NSDictionary *)rd cellWidth:(float)cell_width;
+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width;

@end
