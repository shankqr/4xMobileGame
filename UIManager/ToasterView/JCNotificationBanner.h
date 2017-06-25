
#import <Foundation/Foundation.h>

typedef void (^JCNotificationBannerTapHandlingBlock)();

@interface JCNotificationBanner : NSObject

@property (nonatomic) NSDictionary *dict_cell;
@property (nonatomic) NSString *animation_type;

@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, copy) JCNotificationBannerTapHandlingBlock tapHandler;

- (JCNotificationBanner *) initWithDict:(NSDictionary *)dictCell
                         animation_type:(NSString *)animationType
                             tapHandler:(JCNotificationBannerTapHandlingBlock)handler;

@end
