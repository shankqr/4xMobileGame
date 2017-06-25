
#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)

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
