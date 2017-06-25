//
//  SplashView
//  Battle Simulator 
//
//  Created by Shankar on 4/14/14.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "SplashView.h"
#import "Globals.h"

@interface SplashView ()

@property (nonatomic, strong) UIImageView *iv_bg;
@property (nonatomic, strong) UIImageView *iv_char;

@end

@implementation SplashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        if (iPad)
        {
            CGFloat char_width = 577.0f;
            
            self.iv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
            
            //Center
            //self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(95.5f, 0.0f, char_width, UIScreen.mainScreen.bounds.size.height)];
            
            //Align Right
            self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-char_width, 0.0f, char_width, UIScreen.mainScreen.bounds.size.height)];
        }
        else if (UIScreen.mainScreen.bounds.size.height == 568)
        {
            self.iv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(-53.0f, 0.0f, 426.0f, UIScreen.mainScreen.bounds.size.height)];
            self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
        }
        else if (UIScreen.mainScreen.bounds.size.height == 480)
        {
            CGFloat char_width = 270.0f;
            
            self.iv_bg = [[UIImageView alloc] initWithFrame:CGRectMake(-20.0f, 0.0f, 360.0f, UIScreen.mainScreen.bounds.size.height)];
            
            //Center
            //self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(25.0f, 0.0f, char_width, UIScreen.mainScreen.bounds.size.height)];
            
            //Align Right
            self.iv_char = [[UIImageView alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width-char_width, 0.0f, char_width, UIScreen.mainScreen.bounds.size.height)];
        }
        [self.iv_bg setImage:[UIImage imageNamed:@"login_bg.png"]];
        [self addSubview:self.iv_bg];
        [self.iv_char setImage:[UIImage imageNamed:@"login_char.png"]];
        [self addSubview:self.iv_char];
    }
    
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL pointInside = NO;
    return pointInside;
}

- (void)updateView
{

}

@end
