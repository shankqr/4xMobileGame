
#import "JCNotificationBanner.h"

@class JCNotificationBannerPresenter;

@interface JCNotificationCenter : NSObject

@property (nonatomic) JCNotificationBannerPresenter *presenter;

+ (JCNotificationCenter *)sharedCenter;

/** Adds notification to queue with given parameters. */
+ (void)enqueueNotificationWithMessage:(NSDictionary *)dictCell
                         animationType:(NSString *)animationType
                            tapHandler:(JCNotificationBannerTapHandlingBlock)tapHandler;

- (void)enqueueNotification:(JCNotificationBanner *)notification;

@end
