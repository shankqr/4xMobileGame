//
//  DCFineTuneSlider
//

#import <UIKit/UIKit.h>

@interface DCFineTuneSlider : UISlider

@property (nonatomic, strong) NSString *type;

@property (nonatomic, assign) NSUInteger maxValue;
@property (nonatomic, assign) NSUInteger selectedValue;
@property (nonatomic, assign) NSUInteger fineTuneAmount;
@property (nonatomic, retain) UIButton *increaseButton;
@property (nonatomic, retain) UIButton *decreaseButton;

- (id)initWithFrame:(CGRect)frame;
- (void)updateView;

@end
