//
//  RowView.h
//  Battle Simulator 
//
//  Created by Shankar on 4/14/14.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

@class DCFineTuneSlider;

@interface RowView : UIView

@property (nonatomic, strong) NSMutableDictionary *rowData;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) DCFineTuneSlider *slider;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, assign) CGRect frame_view;

- (CGFloat)updateView;
- (void)hideAll;

@end
