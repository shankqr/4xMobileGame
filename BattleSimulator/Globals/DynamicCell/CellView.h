//
//  CellView.h
//  Battle Simulator 
//
//  Created by Shankar on 4/14/14.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "RowView.h"

@interface CellView : UIView

@property (nonatomic, strong) UIButton *img1;
@property (nonatomic, strong) RowView *rv_n;
@property (nonatomic, strong) RowView *rv_a;
@property (nonatomic, strong) RowView *rv_b;
@property (nonatomic, strong) RowView *rv_c;
@property (nonatomic, strong) RowView *rv_d;
@property (nonatomic, strong) RowView *rv_e;
@property (nonatomic, strong) RowView *rv_f;

- (void)setHighlighted:(BOOL)highlight;
- (void)drawCell:(NSDictionary *)rd cellWidth:(float)cell_width;

+ (CGFloat)dynamicCellHeight:(NSDictionary *)rd cellWidth:(float)cell_width;

@end
