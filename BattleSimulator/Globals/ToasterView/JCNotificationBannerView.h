
#import <QuartzCore/QuartzCore.h>
#import "JCNotificationBanner.h"

@interface JCNotificationBannerView : UIView

@property (nonatomic) JCNotificationBanner *notificationBanner;

- (id)initWithNotification:(JCNotificationBanner *)notification;
- (BOOL)getCurrentPresentingStateAndAtomicallySetPresentingState:(BOOL)state;

@end
