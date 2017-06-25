
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class JCNotificationBanner;

@interface JCNotificationBannerView : UIView

@property (nonatomic) JCNotificationBanner *notificationBanner;

- (id)initWithNotification:(JCNotificationBanner *)notification;
- (BOOL)getCurrentPresentingStateAndAtomicallySetPresentingState:(BOOL)state;

@end
