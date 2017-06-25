//
//  Globals.h
//  Battle Simulator
//
//  Created by Shankar on 6/9/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#define ARC4RANDOM_MAX 0x100000000LL
#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)
#define CHART_CONTENT_MARGIN (10.0f*SCALE_IPAD)
#define CHART_CELL_WIDTH (CELL_CONTENT_WIDTH - CHART_CONTENT_MARGIN*3)
#define DIALOG_CONTENT_MARGIN (20.0f*SCALE_IPAD)
#define DIALOG_CELL_WIDTH (CELL_CONTENT_WIDTH - DIALOG_CONTENT_MARGIN*3)
#define SCREEN_OFFSET_BOTTOM (83.0f*SCALE_IPAD)
#define SCREEN_OFFSET_X (0.0f*SCALE_IPAD)
#define SCREEN_OFFSET_MAINHEADER_Y (43.0f*SCALE_IPAD)
#define SCREEN_OFFSET_DIALOGHEADER_Y (15.0f*SCALE_IPAD)
#define CHAT_HEIGHT (40.0f*SCALE_IPAD)
#define PLUGIN_HEIGHT (UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_MAINHEADER_Y - SCREEN_OFFSET_BOTTOM)
#define MOREVIEW_HEIGHT (UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_MAINHEADER_Y - CHAT_HEIGHT - SCREEN_OFFSET_BOTTOM)

#define GAME_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define GAME_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define ARRAY_FLAGS [NSArray arrayWithObjects: @" ", @"Afghanistan", @"Aland Islands", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"BIOT", @"Bolivia", @"Bosnian", @"Botswana", @"Bouvet Island", @"Brazil", @"British Antarctic Territory", @"British Virgin Islands", @"Brunei", @"Bulgaria", @"Burkina Faso", @"Burma", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Cayman Islands", @"CentralAfricanRepublic", @"Chad", @"Chile", @"China", @"Christmas Island", @"Cocos Islands", @"Colombia", @"Comoros", @"Congo", @"Congo Kinshasa", @"Cook Islands", @"Costa Rica", @"Croatian", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti", @"Dominican Republic", @"Dominicana", @"East Timor", @"Ecuador", @"Egypt", @"El Salvador", @"England", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"European Union", @"Ex Yugoslavia", @"Falkland Islands", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"French Polynesia", @"French Southern Territories", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guernsey", @"Guinea Bissau", @"Guinea", @"Guyana", @"Haiti", @"Holy see", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Ivory Coast", @"Jamaica", @"Jan Mayen", @"Japan", @"Jarvis Island", @"Jersey", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Korea", @"Kosovo", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mayotte", @"Mexico", @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro", @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal", @"Netherlands Antilles", @"Netherlands", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"North Korea", @"Northern Ireland", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Palestinian Territory", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion", @"Romania", @"Russia", @"Rwanda", @"Saint Pierre and Miquelon", @"Saint Vincent and the Grenadines", @"Saint Barthelemy", @"Saint Helena Dependencies", @"Saint Helena", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Martin", @"Samoa", @"San Marino", @"Sao Tome and Principe", @"Saudi Arabia", @"Scotland", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"SMOM", @"Solomon Islands", @"Somalia", @"South Africa", @"South Georgia", @"Spain", @"SPM", @"Sri Lanka", @"Sudan", @"Suriname", @"Svalbard", @"SVG", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"Timor Leste", @"Togo", @"Tokelau", @"Tonga", @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City", @"Venezuela", @"Vietnam", @"Virgin Islands", @"Wales", @"Wallis and Futuna", @"Western Sahara", @"Yemen", @"Zambia", @"Zimbabwe", nil]

//#if TARGET_IPHONE_SIMULATOR
//    #define CORE_URL @"http://gameserver"
//#else
    #define CORE_URL @"http://yourdomain.com"
//#endif

//#define CORE_URL @"http://192.168.1.2"

#define WS_URL CORE_URL "/kingdom"
#define APP_TYPE @"kingdom"
#define SUPPORT_EMAIL @"support@yourdomain.com"

#define DEFAULT_FONT @"TrebuchetMS"
#define DEFAULT_FONT_BOLD @"TrebuchetMS-Bold"
#define CITY_NAME_FONT @"Baskerville-BoldItalic"

#define HUGE_FONT_SIZE (30.0f*SCALE_IPAD)
#define BIG_FONT_SIZE (18.0f*SCALE_IPAD)
#define SMALL_FONT_SIZE (11.0f*SCALE_IPAD)
#define MEDIUM_FONT_SIZE (14.0f*SCALE_IPAD)
#define MINIMUM_FONT_SIZE (1.0f*SCALE_IPAD)

#define CELL_CONTENT_WIDTH UIScreen.mainScreen.bounds.size.width

#define DEFAULT_CONTENT_SPACING (5.0f*SCALE_IPAD)
#define TABLE_HEADER_VIEW_HEIGHT (46.0f*SCALE_IPAD)
#define TABLE_FOOTER_VIEW_HEIGHT (50.0f*SCALE_IPAD)
#define menu_label_height (iPad ? 42.0f : 21.0f)

#import "DynamicCell.h"
#import "DialogBoxView.h"
#import "DCFineTuneSlider.h"

#define DEBUG YES //TODO: Set to no when release to app store

@interface Globals : NSObject

@property (nonatomic, strong) NSMutableDictionary *wsProfileDict;
@property (nonatomic, strong) NSMutableDictionary *wsWorldProfileDict;
@property (nonatomic, strong) NSMutableArray *wsReportArray;
@property (nonatomic, strong) NSMutableArray *localReportArray;
@property (nonatomic, strong) NSMutableArray *wsHeroLevelArray;
@property (nonatomic, strong) NSString *lastReportId;
@property (nonatomic, strong) NSString *workingUrl;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSDateFormatter *dateFormat;
@property (nonatomic, strong) NSTimer *gameTimer;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSString *a1;
@property (nonatomic, strong) NSString *a2;
@property (nonatomic, strong) NSString *a3;
@property (nonatomic, strong) NSString *b1;
@property (nonatomic, strong) NSString *b2;
@property (nonatomic, strong) NSString *b3;
@property (nonatomic, strong) NSString *c1;
@property (nonatomic, strong) NSString *c2;
@property (nonatomic, strong) NSString *c3;
@property (nonatomic, strong) NSString *d1;
@property (nonatomic, strong) NSString *d2;
@property (nonatomic, strong) NSString *d3;
@property (nonatomic, strong) NSString *r1;
@property (nonatomic, strong) NSString *r2;
@property (nonatomic, strong) NSString *r3;
@property (nonatomic, strong) NSString *r4;
@property (nonatomic, strong) NSString *r5;
@property (nonatomic, strong) UIImageView *spinImageView;
@property (nonatomic, assign) NSTimeInterval serverTimeInterval;
@property (nonatomic, assign) NSTimeInterval startServerTimeInterval;
@property (nonatomic, assign) NSTimeInterval offsetServerTimeInterval;

typedef void (^returnBlock)(BOOL success, NSData *data);


//UI Methods
- (void)showLoadingAlert;
- (void)removeLoadingAlert;
- (void)showToast:(NSString *)message optionalTitle:(NSString *)title optionalImage:(NSString *)imagename;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType :(NSInteger)selectedIndex :(NSArray *)headerView;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType :(NSInteger)selectedIndex;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title :(NSInteger)frameType;
- (void)showTemplate:(NSArray *)viewControllers :(NSString *)title;
- (void)closeTemplate;
- (void)showDialog:(NSString *)l1;
- (void)showDialogBlock:(NSString *)l1 :(NSInteger)type :(DialogBlock)block;
- (void)showDialogBlock:(NSMutableArray *)rows type:(NSInteger)frameType :(DialogBlock)block;
- (void)showDialogError;
- (void)flushViewControllerStack;
- (void)pushViewControllerStack:(UIViewController *)view;
- (UIViewController *)popViewControllerStack;
- (UIViewController *)peekViewControllerStack;
- (UIViewController *)firstViewControllerStack;
- (BOOL)isCurrentView:(UIViewController *)view;
- (NSString *)currentViewTitle;
- (void)closeAllTemplate;
- (void)setTemplateBadgeNumber:(NSUInteger)tabIndex number:(NSUInteger)number;
- (UIButton *)buttonWithTitle:(NSString *)title
                       target:(id)target
                     selector:(SEL)selector
                        frame:(CGRect)frame
                  imageNormal:(UIImage *)imageNormal
             imageHighlighted:(UIImage *)imageHighlighted
                imageCentered:(BOOL)imageCentered
                darkTextColor:(BOOL)darkTextColor;
- (UIImage *)dynamicImage:(CGRect)frame prefix:(NSString *)prefix;
- (UIImage *)colorImage:(NSString *)imageName :(UIColor *)color;
- (UIButton *)dynamicButtonWithTitle:(NSString *)title
                              target:(id)target
                            selector:(SEL)selector
                               frame:(CGRect)frame
                                type:(NSString *)type;
- (void)showTroopList:(NSString *)status;
- (void)showIIS_error:(NSString *)str_html;
- (void)setTemplateFrameType:(NSInteger)frame_type;
- (void)showDialogFail;

+ (Globals *)i;
+ (NSOperationQueue *)connectionQueue;
- (NSString *)GameId;
- (NSString *)UID;
- (NSString *)world_url;
- (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock;
- (void)getServer:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)getMainServerLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)getServerLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)getSpLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)setUID:(NSString *)user_uid;
- (double)Random_next:(double)min to:(double)max;
- (NSString *)BoolToBit: (NSString *)boolString;
- (NSString *)shortNumber:(NSString *)val;
- (NSString *)autoNumber:(NSString *)val;
- (NSTimeInterval)updateTime;
- (NSString *)getServerTimeString;
- (NSString *)getServerDateTimeString;
- (NSString *)getTimeAgo:(NSString *)datetimestring;
- (NSString *)getCountdownString:(NSTimeInterval)differenceSeconds;
- (NSInteger)levelFromXp:(NSInteger)xp;
- (NSInteger)getXp;
- (NSInteger)getLevel;
- (NSString *)intString:(NSInteger)val;
- (NSString *)numberFormat:(NSString *)val;
- (NSInteger)getReportBadgeNumber;
- (NSMutableArray *)gettLocalReportData;
- (void)settLocalReportData:(NSMutableArray *)rd;
- (void)addLocalReportData:(NSMutableArray *)rd;
- (NSString *)gettLastReportId;
- (void)settLastReportId:(NSString *)rid;
- (NSDateFormatter *)getDateFormat;
- (NSString *)floatString:(double)val;
- (NSInteger)troopCount:(NSString *)status;
- (NSMutableArray *)createTroopList:(NSDictionary *)dict;
- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label;
- (void)trackEvent:(NSString *)category action:(NSString *)action;
- (void)trackEvent:(NSString *)category;
- (NSString *)numberString:(NSNumber *)val;
- (NSInteger)totalTroopsFromDict:(NSDictionary *)dict;
- (NSString *)floatNumber:(NSString *)val;
- (NSString *)shortNumberDouble:(double)dval;
- (void)updateReports:(returnBlock)completionBlock;
- (void)doAttack:(NSDictionary *)targetBaseDict;
- (void)deleteLocalReport:(NSString *)report_id;

@end
