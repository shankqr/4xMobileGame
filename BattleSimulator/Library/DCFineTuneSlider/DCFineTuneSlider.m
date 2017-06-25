//
//  DCFineTuneSlider
//

#import "DCFineTuneSlider.h"

#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)
#define DEFAULT_FONT @"TrebuchetMS-Bold"
#define FONT_SIZE (10.0f*SCALE_IPAD)

@interface DCFineTuneSlider()

@property (nonatomic, assign) BOOL fineTuning;
@property (nonatomic, assign) CGPoint lastTouchPoint;

@property (nonatomic, retain) UIButton *increaseButton;
@property (nonatomic, retain) UIButton *decreaseButton;
@property (nonatomic, retain) UILabel *balLabel;
@property (nonatomic, retain) UILabel *valLabel;

- (void)setup;

@end

@implementation DCFineTuneSlider

#pragma mark -
#pragma mark Init

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];
	}
	
	return self;
}

- (void)bringFront
{
    [self.decreaseButton bringSubviewToFront:self];
    [self.increaseButton bringSubviewToFront:self];
}

- (void)setup
{
    self.selectedValue = 0;
    self.fineTuneAmount = 1;
    
    UIImage *thumbImage = [UIImage imageNamed:@"slider_button"];
    [self setThumbImage:thumbImage forState:UIControlStateNormal];
    UIImage *trackImage = [UIImage imageNamed:@"slider_track"];
    [self setMinimumTrackTintColor:[UIColor blackColor]];
    [self setMinimumTrackImage:trackImage forState:UIControlStateNormal];
    [self setMaximumTrackImage:trackImage forState:UIControlStateNormal];
    
    self.continuous = NO;

    self.balLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.balLabel setNumberOfLines:1];
    [self.balLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:FONT_SIZE]];
    [self.balLabel setBackgroundColor:[UIColor blackColor]];
    [self.balLabel setTextColor:[UIColor whiteColor]];
    [self.balLabel setTextAlignment:NSTextAlignmentCenter];
    self.balLabel.minimumScaleFactor = 0.1;
    self.balLabel.adjustsFontSizeToFitWidth = YES;
    [self.balLabel setUserInteractionEnabled:NO];
    self.balLabel.text = [self intString:self.maxValue];
    //[self addSubview:self.balLabel];
    
    self.valLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.valLabel setNumberOfLines:1];
    [self.valLabel setFont:[UIFont fontWithName:DEFAULT_FONT size:FONT_SIZE]];
    [self.valLabel setBackgroundColor:[UIColor blackColor]];
    [self.valLabel setTextColor:[UIColor whiteColor]];
    [self.valLabel setTextAlignment:NSTextAlignmentCenter];
    self.valLabel.minimumScaleFactor = 0.1;
    self.valLabel.adjustsFontSizeToFitWidth = YES;
    [self.valLabel setUserInteractionEnabled:NO];
    self.valLabel.text = @"0";
    [self addSubview:self.valLabel];
    
    // create the fine tune buttons, their frames are setup in layoutSubviews
    self.decreaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.decreaseButton addTarget:self action:@selector(fineTuneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.decreaseButton setImage:[UIImage imageNamed:@"slider_minus"] forState:UIControlStateNormal];
    [self addSubview:self.decreaseButton];
    
    self.increaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.increaseButton addTarget:self action:@selector(fineTuneButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.increaseButton setImage:[UIImage imageNamed:@"slider_plus"] forState:UIControlStateNormal];
    [self addSubview:self.increaseButton];
}

#pragma mark Layout

- (CGRect)trackRectForBounds:(CGRect)bounds
{
	// return a shortened track rect to account for the fine tune buttons
    CGRect result = [super trackRectForBounds:bounds];
    return CGRectInset(result, self.frame.size.height*7, 0.0f);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = NO;
    
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbRect = [self thumbRectForBounds:self.bounds trackRect:trackRect value:self.value];
    
    if (CGRectContainsPoint(self.decreaseButton.frame, point))
    {
        [self.decreaseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        pointInside = YES;
    }
    else if (CGRectContainsPoint(self.increaseButton.frame, point))
    {
        [self.increaseButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        pointInside = YES;
    }
    else if (CGRectContainsPoint(thumbRect, point))
    {
        pointInside = YES;
    }
    
    return pointInside;
}

- (void)layoutSubviews
{
	[super layoutSubviews];

	CGFloat buttonSize = self.frame.size.height*1.5;
    CGFloat labelWidth = self.frame.size.height*6;
    CGFloat labelHeight = self.frame.size.height*2;
    CGFloat buttonOverlap = 5.0f*SCALE_IPAD;
    
    self.balLabel.frame = CGRectMake(0, -self.frame.size.height/2.0f, labelWidth, labelHeight);
    self.valLabel.frame = CGRectMake(self.frame.size.width-labelWidth, -self.frame.size.height/2.0f, labelWidth, labelHeight);

	self.decreaseButton.frame = CGRectMake(labelWidth-buttonOverlap, -self.frame.size.height/3.0f, buttonSize, buttonSize);
	self.increaseButton.frame = CGRectMake(self.frame.size.width-labelWidth-buttonSize+buttonOverlap, -self.frame.size.height/3.0f, buttonSize, buttonSize);

    [self bringFront];
}

- (void)fineTuneButtonPressed:(id)sender
{
	if (sender == self.increaseButton)
    {
        if (self.selectedValue < (self.maxValue))
        {
            self.selectedValue = self.selectedValue + self.fineTuneAmount;
            [self updateView];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
	else if (sender == self.decreaseButton)
    {
        if (self.selectedValue > 0)
        {
            self.selectedValue = self.selectedValue - self.fineTuneAmount;
            [self updateView];
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }
    }
}

- (NSString *)numberString:(NSNumber *)val
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedOutput = [formatter stringFromNumber:val];
    return formattedOutput;
}

- (NSString *)intString:(NSInteger)val
{
    NSNumber *number = @(val);
    return [self numberString:number];
}

- (void)updateView
{
    double newVal = self.selectedValue/(double)self.maxValue;
    if (newVal > 1)
    {
        newVal = 1.0f;
    }
    else if (newVal < 0)
    {
        newVal = 0.0f;
    }
    [super setValue:newVal animated:YES];
    [self drawLabels];
}

- (void)drawLabels
{
    self.balLabel.text = [self intString:self.maxValue-self.selectedValue];
    self.valLabel.text = [self intString:self.selectedValue];
}

- (void)setValue:(float)value animated:(BOOL)animated
{
    [super setValue:value animated:animated];
    
    self.selectedValue = value*self.maxValue;
    [self drawLabels];
}

@end
