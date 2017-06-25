
#import "JCNotificationBannerPresenterSmokeStyle.h"
#import "JCNotificationBannerPresenter_Private.h"
#import "JCNotificationBannerView.h"
#import "JCNotificationBannerViewController.h"

#define SCREEN_OFFSET_BOTTOM (83.0f*SCALE_IPAD)

@implementation JCNotificationBannerPresenterSmokeStyle

- (id)init
{
  if (self = [super init])
  {
    self.minimumHorizontalMargin = 10.0f*SCALE_IPAD;
    self.bannerMaxWidth = UIScreen.mainScreen.bounds.size.width;
    self.bannerHeight = 70.0f*SCALE_IPAD;
  }
  return self;
}

- (void)presentNotification:(JCNotificationBanner *)notification
                    inWindow:(JCNotificationBannerWindow *)window
                    finished:(JCNotificationBannerPresenterFinishedBlock)finished
{
  JCNotificationBannerView *banner = [self newBannerViewForNotification:notification];

  JCNotificationBannerViewController *bannerViewController = [JCNotificationBannerViewController new];
  window.rootViewController = bannerViewController;
  UIView *originalControllerView = bannerViewController.view;

  UIView *containerView = [self newContainerViewForNotification:notification];
  [containerView addSubview:banner];
  bannerViewController.view = containerView;

  window.bannerView = banner;

  containerView.bounds = originalControllerView.bounds;
  containerView.transform = originalControllerView.transform;
  [banner getCurrentPresentingStateAndAtomicallySetPresentingState:YES];

  // Make the banner fill the width of the screen
  CGSize bannerSize = CGSizeMake(self.bannerMaxWidth, self.bannerHeight);
  // Center the banner horizontally.
  CGFloat x = 0;
  // Position the banner offscreen vertically.
  CGFloat y = UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_BOTTOM;

  banner.frame = CGRectMake(x, y, bannerSize.width, bannerSize.height);

  JCNotificationBannerTapHandlingBlock originalTapHandler = banner.notificationBanner.tapHandler;
  JCNotificationBannerTapHandlingBlock wrappingTapHandler = ^{
    if ([banner getCurrentPresentingStateAndAtomicallySetPresentingState:NO])
    {
      if (originalTapHandler)
      {
        originalTapHandler();
      }

      [banner removeFromSuperview];
      finished();
      // Break the retain cycle
      notification.tapHandler = nil;
    }
  };
  banner.notificationBanner.tapHandler = wrappingTapHandler;
    
  // Slide it up while fading it in.
  banner.alpha = 0;
  [UIView animateWithDuration:0.2 delay:0
                      options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     CGRect newFrame = CGRectOffset(banner.frame, 0, -banner.frame.size.height);
                     banner.frame = newFrame;
                     banner.alpha = 0.9;
                   } completion:^(BOOL finished) {
                     // Empty.
                   }];

  // On timeout, slide it down while fading it out.
  if (notification.timeout > 0.0)
  {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, notification.timeout * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                       animations:^{
                         banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
                         banner.alpha = 0;
                       } completion:^(BOOL didFinish) {
                         if ([banner getCurrentPresentingStateAndAtomicallySetPresentingState:NO]) {
                           [banner removeFromSuperview];
                           [containerView removeFromSuperview];
                           finished();
                           // Break the retain cycle
                           notification.tapHandler = nil;
                         }
                       }];
    });
  }
}

#pragma mark - View helpers

- (JCNotificationBannerWindow *)newWindow
{
  JCNotificationBannerWindow *window = [super newWindow];
  window.windowLevel = UIWindowLevelStatusBar;
  return window;
}

@end
