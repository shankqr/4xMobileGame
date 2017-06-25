//
//  DCFineTuneSlider
//

@interface DCFineTuneSlider : UISlider

@property (nonatomic, strong) NSString *type;

@property (nonatomic, assign) NSUInteger maxValue;
@property (nonatomic, assign) NSUInteger selectedValue;
@property (nonatomic, assign) NSUInteger fineTuneAmount;

- (id)initWithFrame:(CGRect)frame;
- (void)updateView;

@end