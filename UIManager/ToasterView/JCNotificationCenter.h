
#import <Foundation/Foundation.h>

@class JCNotificationBanner;
@class JCNotificationBannerPresenter;

@interface JCNotificationCenter : NSObject
typedef void (^JCNotificationBannerTapHandlingBlock)();
@property (nonatomic) JCNotificationBannerPresenter *presenter;

+ (JCNotificationCenter *)sharedCenter;

/** Adds notification to queue with given parameters. */
+ (void)enqueueNotificationWithMessage:(NSDictionary *)dictCell
                         animationType:(NSString *)animationType
                            tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (void)enqueueNotification:(JCNotificationBanner *)notification;

@end
