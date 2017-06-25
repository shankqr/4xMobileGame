
#import <Foundation/Foundation.h>

@class JCNotificationBanner;

typedef void (^JCNotificationBannerPresenterFinishedBlock)();

@interface JCNotificationBannerPresenter : NSObject

- (void)willBeginPresentingNotifications;
- (void)didFinishPresentingNotifications;
- (void)presentNotification:(JCNotificationBanner *)notification
                   finished:(JCNotificationBannerPresenterFinishedBlock)finished;

@end
