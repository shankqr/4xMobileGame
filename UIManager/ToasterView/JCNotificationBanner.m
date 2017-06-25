
#import "JCNotificationBanner.h"

@implementation JCNotificationBanner

@synthesize dict_cell;
@synthesize animation_type;
@synthesize tapHandler;

- (JCNotificationBanner *) initWithDict:(NSDictionary *)dictCell
                         animation_type:(NSString *)animationType
                             tapHandler:(JCNotificationBannerTapHandlingBlock)handler
{
    self = [super init];

    if (self)
    {
        self.dict_cell = dictCell;
        self.animation_type = animationType;
        self.timeout = 1.0;
        self.tapHandler = handler;
    }
    
    return self;
}

@end