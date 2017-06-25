//
//  Globals.h
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/9/09.
/*
 Copyright © 2017 SHANKAR NATHAN (shankqr@gmail.com). All rights reserved.
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#define iPad UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
#define SCALE_IPAD (iPad ? 2.0f : 1.0f)

#define TILE_WIDTH (70.0f*SCALE_IPAD)
#define TILE_HEIGHT (42.5f*SCALE_IPAD)
#define TILE_MAX_ROW_CAPACITY 1000 // add 0 to increase rows capacity
#define TILE_ID_MAKE(col, row) ((col+1)*TILE_MAX_ROW_CAPACITY+(row+1))
#define TILE_COL_FROMID(id) (id/TILE_MAX_ROW_CAPACITY - 1)
#define TILE_ROW_FROMID(id) (id%TILE_MAX_ROW_CAPACITY - 1)
#define TILE_TERRAIN @"0"
#define TILE_CITY_MAIN @"1"
#define TILE_CITY_SECONDARY @"2"
#define TILE_CITY_ALLIANCE_MEMBER @"3"
#define TILE_CITY_ENEMY @"4"
#define TILE_VILLAGE @"5"
#define TILE_WONDER @"6"
#define TILE_MONSTER @"7"

#define GAME_NAME [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define GAME_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define ARRAY_FLAGS [NSArray arrayWithObjects: @" ", @"Afghanistan", @"Aland Islands", @"Albania", @"Algeria", @"American Samoa", @"Andorra", @"Angola", @"Anguilla", @"Antarctica", @"Antigua and Barbuda", @"Argentina", @"Armenia", @"Aruba", @"Australia", @"Austria", @"Azerbaijan", @"Bahamas", @"Bahrain", @"Bangladesh", @"Barbados", @"Belarus", @"Belgium", @"Belize", @"Benin", @"Bermuda", @"Bhutan", @"BIOT", @"Bolivia", @"Bosnian", @"Botswana", @"Bouvet Island", @"Brazil", @"British Antarctic Territory", @"British Virgin Islands", @"Brunei", @"Bulgaria", @"Burkina Faso", @"Burma", @"Burundi", @"Cambodia", @"Cameroon", @"Canada", @"Cape Verde", @"Cayman Islands", @"CentralAfricanRepublic", @"Chad", @"Chile", @"China", @"Christmas Island", @"Cocos Islands", @"Colombia", @"Comoros", @"Congo", @"Congo Kinshasa", @"Cook Islands", @"Costa Rica", @"Croatian", @"Cuba", @"Cyprus", @"Czech Republic", @"Denmark", @"Djibouti", @"Dominican Republic", @"Dominicana", @"East Timor", @"Ecuador", @"Egypt", @"El Salvador", @"England", @"Equatorial Guinea", @"Eritrea", @"Estonia", @"Ethiopia", @"European Union", @"Ex Yugoslavia", @"Falkland Islands", @"Faroe Islands", @"Fiji", @"Finland", @"France", @"French Polynesia", @"French Southern Territories", @"Gabon", @"Gambia", @"Georgia", @"Germany", @"Ghana", @"Gibraltar", @"Greece", @"Greenland", @"Grenada", @"Guadeloupe", @"Guam", @"Guatemala", @"Guernsey", @"Guinea Bissau", @"Guinea", @"Guyana", @"Haiti", @"Holy see", @"Honduras", @"Hong Kong", @"Hungary", @"Iceland", @"India", @"Indonesia", @"Iran", @"Iraq", @"Ireland", @"Isle of Man", @"Israel", @"Italy", @"Ivory Coast", @"Jamaica", @"Jan Mayen", @"Japan", @"Jarvis Island", @"Jersey", @"Jordan", @"Kazakhstan", @"Kenya", @"Kiribati", @"Korea", @"Kosovo", @"Kuwait", @"Kyrgyzstan", @"Laos", @"Latvia", @"Lebanon", @"Lesotho", @"Liberia", @"Libya", @"Liechtenstein", @"Lithuania", @"Luxembourg", @"Macau", @"Macedonia", @"Madagascar", @"Malawi", @"Malaysia", @"Maldives", @"Mali", @"Malta", @"Marshall Islands", @"Martinique", @"Mauritania", @"Mauritius", @"Mayotte", @"Mexico", @"Micronesia", @"Moldova", @"Monaco", @"Mongolia", @"Montenegro", @"Montserrat", @"Morocco", @"Mozambique", @"Myanmar", @"Namibia", @"Nauru", @"Nepal", @"Netherlands Antilles", @"Netherlands", @"New Caledonia", @"New Zealand", @"Nicaragua", @"Niger", @"Nigeria", @"Niue", @"Norfolk Island", @"North Korea", @"Northern Ireland", @"Northern Mariana Islands", @"Norway", @"Oman", @"Pakistan", @"Palau", @"Palestinian Territory", @"Panama", @"Papua New Guinea", @"Paraguay", @"Peru", @"Philippines", @"Pitcairn", @"Poland", @"Portugal", @"Puerto Rico", @"Qatar", @"Reunion", @"Romania", @"Russia", @"Rwanda", @"Saint Pierre and Miquelon", @"Saint Vincent and the Grenadines", @"Saint Barthelemy", @"Saint Helena Dependencies", @"Saint Helena", @"Saint Kitts and Nevis", @"Saint Lucia", @"Saint Martin", @"Samoa", @"San Marino", @"Sao Tome and Principe", @"Saudi Arabia", @"Scotland", @"Senegal", @"Serbia", @"Seychelles", @"Sierra Leone", @"Singapore", @"Slovakia", @"Slovenia", @"SMOM", @"Solomon Islands", @"Somalia", @"South Africa", @"South Georgia", @"Spain", @"SPM", @"Sri Lanka", @"Sudan", @"Suriname", @"Svalbard", @"SVG", @"Swaziland", @"Sweden", @"Switzerland", @"Syria", @"Taiwan", @"Tajikistan", @"Tanzania", @"Thailand", @"Timor Leste", @"Togo", @"Tokelau", @"Tonga", @"Trinidad and Tobago", @"Tunisia", @"Turkey", @"Turkmenistan", @"Turks and Caicos Islands", @"Tuvalu", @"Uganda", @"Ukraine", @"United Arab Emirates", @"United Kingdom", @"United States", @"Uruguay", @"Uzbekistan", @"Vanuatu", @"Vatican City", @"Venezuela", @"Vietnam", @"Virgin Islands", @"Wales", @"Wallis and Futuna", @"Western Sahara", @"Yemen", @"Zambia", @"Zimbabwe", nil]

#define CORE_URL @"http://yourdomain.com"
#define WS_URL CORE_URL "/kingdom"
#define APP_TYPE @"kingdom"
#define SUPPORT_EMAIL @"support@yourdomain.com"

#define DEFAULT_FONT @"TrebuchetMS"
#define DEFAULT_FONT_BOLD @"TrebuchetMS-Bold"
#define CITY_NAME_FONT @"Baskerville-BoldItalic"
#define HUGE_FONT_SIZE (25.0f*SCALE_IPAD)
#define BIG_FONT_SIZE (14.0f*SCALE_IPAD)
#define SMALL_FONT_SIZE (8.0f*SCALE_IPAD)
#define MEDIUM_FONT_SIZE (11.0f*SCALE_IPAD)
#define CELL_FONT_SIZE @"15.0"

#define SCALE_BUILDINGS 1.0f
#define SCALE_CASLTE (SCALE_BUILDINGS*1.0f)
#define BUILDING_FONT @"Blox (BRK)"

#define btnBaseDetail_h (35.0f*SCALE_IPAD)
#define TABLE_HEADER_VIEW_HEIGHT (46.0f*SCALE_IPAD)
#define TABLE_FOOTER_VIEW_HEIGHT (50.0f*SCALE_IPAD)
#define CHART_CELL_WIDTH (CELL_CONTENT_WIDTH - CHART_CONTENT_MARGIN*3)
#define CHAT_HEIGHT (40.0f*SCALE_IPAD)
#define CELL_CONTENT_WIDTH UIScreen.mainScreen.bounds.size.width
#define DEFAULT_CONTENT_SPACING (5.0f*SCALE_IPAD)
#define menu_label_height (iPad ? 42.0f : 21.0f)
#define MOREVIEW_HEIGHT (UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_MAINHEADER_Y - CHAT_HEIGHT - SCREEN_OFFSET_BOTTOM)

//Dont change TV values (must start with 0 coz array using it),
//stored proc speedups & speedups_percent and others may depend on these values
#define TV_BUILD 0
#define TV_RESEARCH 1
#define TV_ATTACK 2
#define TV_TRADE 3
#define TV_REINFORCE 4
#define TV_TRANSFER 5
#define TV_HEAL 6
#define TV_A 7
#define TV_B 8
#define TV_C 9
#define TV_D 10
#define TV_SPY 11
#define TV_BOOST_R1 12
#define TV_BOOST_R2 13
#define TV_BOOST_R3 14
#define TV_BOOST_R4 15
#define TV_BOOST_R5 16
#define TV_BOOST_ATT 17
#define TV_BOOST_DEF 18

//Timer Object types
#define TO_ATTACK 1
#define TO_TRADE 2
#define TO_TRANSFER 4

//Login and Register page
#define kSecret @"password123"

#import "UIManager.h"
#import "AllianceObject.h"

//Helpshift
#import "HelpshiftCore.h"
#import "HelpshiftSupport.h"

#define DEBUG NO //TODO: Set to no when release to app store

#define tvHeight (30.0f*SCALE_IPAD)
#define tvWidth (250.0f*SCALE_IPAD)

@class TimerView;
@class TimerHolder;

@interface Globals : NSObject

@property (nonatomic, strong) TimerHolder *timerHolder;
@property (nonatomic, strong) NSMutableArray *tvStack;
@property (nonatomic, strong) NSMutableDictionary *wsProfileDict;
@property (nonatomic, strong) NSMutableDictionary *wsWorldProfileDict;
@property (nonatomic, strong) NSMutableDictionary *wsBaseDict;
@property (nonatomic, strong) NSDictionary *wsIdentifierDict;
@property (nonatomic, strong) NSDictionary *wsSettingsDict;
@property (nonatomic, strong) NSDictionary *wsProfileInfoDict;
@property (nonatomic, strong) NSDictionary *wsSalesDict;
@property (nonatomic, strong) NSDictionary *wsEventSoloDict;
@property (nonatomic, strong) NSDictionary *wsEventAllianceDict;
@property (nonatomic, strong) NSDictionary *localMailReplyDict;
@property (nonatomic, strong) NSMutableArray *wsReportArray;
@property (nonatomic, strong) NSMutableArray *wsMailArray;
@property (nonatomic, strong) NSMutableArray *wsMailReplyArray;
@property (nonatomic, strong) NSMutableArray *localReportArray;
@property (nonatomic, strong) NSMutableArray *localMailArray;
@property (nonatomic, strong) NSMutableArray *wsLogArray;
@property (nonatomic, strong) NSMutableArray *wsLogFullArray;
@property (nonatomic, strong) NSMutableArray *wsChatArray;
@property (nonatomic, strong) NSMutableArray *wsChatFullArray;
@property (nonatomic, strong) NSMutableArray *wsAllianceChatArray;
@property (nonatomic, strong) NSMutableArray *wsAllianceChatFullArray;
@property (nonatomic, strong) NSMutableArray *wsBaseArray;
@property (nonatomic, strong) NSMutableArray *wsBuildArray;
@property (nonatomic, strong) NSMutableArray *wsBuildingArray;
@property (nonatomic, strong) NSMutableArray *wsUnitArray;
@property (nonatomic, strong) NSMutableArray *wsResearchArray;
@property (nonatomic, strong) NSMutableArray *wsBuildingLevelArray;
@property (nonatomic, strong) NSMutableArray *wsHeroLevelArray;
@property (nonatomic, strong) NSMutableArray *wsItemArray;
@property (nonatomic, strong) NSMutableArray *region_array;
@property (nonatomic, strong) NSMutableArray *region_outdated_array;
@property (nonatomic, strong) NSMutableArray *map_city_array;
@property (nonatomic, strong) NSMutableArray *map_village_array;
@property (nonatomic, strong) NSMutableArray *alliance_applied;
@property (nonatomic, strong) NSMutableArray *trades_in;
@property (nonatomic, strong) NSMutableArray *reinforces_in;
@property (nonatomic, strong) NSMutableArray *reinforces_out;
@property (nonatomic, strong) NSMutableArray *attacks_in;
@property (nonatomic, strong) NSMutableArray *attacks_out;
@property (nonatomic, strong) NSMutableArray *alliance_members;
@property (nonatomic, strong) NSMutableArray *wsQuestArray;
@property (nonatomic, strong) NSMutableArray *wsMissionArray;
@property (nonatomic, strong) NSString *selected_alliance_id;
@property (nonatomic, strong) NSString *purchasedProductString;
@property (nonatomic, strong) NSString *purchasedGemsString;
@property (nonatomic, strong) NSString *lastReportId;
@property (nonatomic, strong) NSString *lastMailId;
@property (nonatomic, strong) NSString *workingUrl;
@property (nonatomic, strong) NSString *selected_profileid;
@property (nonatomic, strong) NSString *selectedBaseId;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *devicetoken;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *selectedMapTile;
@property (nonatomic, strong) NSString *lastGlobalChatId;
@property (nonatomic, strong) NSString *lastAllianceChatId;
@property (nonatomic, strong) UILocalNotification *loginNotification;
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

@property (nonatomic, strong) NSString *launchFirstTime;
@property (nonatomic, strong) NSString *setupInProgress;

@property (nonatomic, assign) NSTimeInterval serverTimeInterval;
@property (nonatomic, assign) NSTimeInterval startServerTimeInterval;
@property (nonatomic, assign) NSTimeInterval offsetServerTimeInterval;

@property (nonatomic, assign) double buildUntil;
@property (nonatomic, assign) double buildQueue1;

@property (nonatomic, assign) double researchUntil;
@property (nonatomic, assign) double researchQueue1;

@property (nonatomic, assign) double attackUntil;
@property (nonatomic, assign) double attackQueue1;
@property (nonatomic, assign) double attackJobTime;

@property (nonatomic, assign) double tradeUntil;
@property (nonatomic, assign) double tradeQueue1;

@property (nonatomic, assign) double reinforceUntil;
@property (nonatomic, assign) double reinforceQueue1;

@property (nonatomic, assign) double transferUntil;
@property (nonatomic, assign) double transferQueue1;

@property (nonatomic, assign) double hospitalUntil;
@property (nonatomic, assign) double hospitalQueue1;

@property (nonatomic, assign) double aUntil;
@property (nonatomic, assign) double aQueue1;

@property (nonatomic, assign) double bUntil;
@property (nonatomic, assign) double bQueue1;

@property (nonatomic, assign) double cUntil;
@property (nonatomic, assign) double cQueue1;

@property (nonatomic, assign) double dUntil;
@property (nonatomic, assign) double dQueue1;

@property (nonatomic, assign) double spyUntil;
@property (nonatomic, assign) double spyQueue1;

@property (nonatomic, assign) double boostR1Until;
@property (nonatomic, assign) double boostR1Queue1;

@property (nonatomic, assign) double boostR2Until;
@property (nonatomic, assign) double boostR2Queue1;

@property (nonatomic, assign) double boostR3Until;
@property (nonatomic, assign) double boostR3Queue1;

@property (nonatomic, assign) double boostR4Until;
@property (nonatomic, assign) double boostR4Queue1;

@property (nonatomic, assign) double boostR5Until;
@property (nonatomic, assign) double boostR5Queue1;

@property (nonatomic, assign) double boostAttackUntil;
@property (nonatomic, assign) double boostAttackQueue1;

@property (nonatomic, assign) double boostDefendUntil;
@property (nonatomic, assign) double boostDefendQueue1;

@property (nonatomic, assign) NSInteger base_a1;
@property (nonatomic, assign) NSInteger base_a2;
@property (nonatomic, assign) NSInteger base_a3;
@property (nonatomic, assign) NSInteger base_b1;
@property (nonatomic, assign) NSInteger base_b2;
@property (nonatomic, assign) NSInteger base_b3;
@property (nonatomic, assign) NSInteger base_c1;
@property (nonatomic, assign) NSInteger base_c2;
@property (nonatomic, assign) NSInteger base_c3;
@property (nonatomic, assign) NSInteger base_d1;
@property (nonatomic, assign) NSInteger base_d2;
@property (nonatomic, assign) NSInteger base_d3;

@property (nonatomic, assign) NSInteger t_a1;
@property (nonatomic, assign) NSInteger t_a2;
@property (nonatomic, assign) NSInteger t_a3;
@property (nonatomic, assign) NSInteger t_b1;
@property (nonatomic, assign) NSInteger t_b2;
@property (nonatomic, assign) NSInteger t_b3;
@property (nonatomic, assign) NSInteger t_c1;
@property (nonatomic, assign) NSInteger t_c2;
@property (nonatomic, assign) NSInteger t_c3;
@property (nonatomic, assign) NSInteger t_d1;
@property (nonatomic, assign) NSInteger t_d2;
@property (nonatomic, assign) NSInteger t_d3;

@property (nonatomic, assign) NSInteger h_a1;
@property (nonatomic, assign) NSInteger h_a2;
@property (nonatomic, assign) NSInteger h_a3;
@property (nonatomic, assign) NSInteger h_b1;
@property (nonatomic, assign) NSInteger h_b2;
@property (nonatomic, assign) NSInteger h_b3;
@property (nonatomic, assign) NSInteger h_c1;
@property (nonatomic, assign) NSInteger h_c2;
@property (nonatomic, assign) NSInteger h_c3;
@property (nonatomic, assign) NSInteger h_d1;
@property (nonatomic, assign) NSInteger h_d2;
@property (nonatomic, assign) NSInteger h_d3;

@property (nonatomic, assign) NSInteger i_a1;
@property (nonatomic, assign) NSInteger i_a2;
@property (nonatomic, assign) NSInteger i_a3;
@property (nonatomic, assign) NSInteger i_b1;
@property (nonatomic, assign) NSInteger i_b2;
@property (nonatomic, assign) NSInteger i_b3;
@property (nonatomic, assign) NSInteger i_c1;
@property (nonatomic, assign) NSInteger i_c2;
@property (nonatomic, assign) NSInteger i_c3;
@property (nonatomic, assign) NSInteger i_d1;
@property (nonatomic, assign) NSInteger i_d2;
@property (nonatomic, assign) NSInteger i_d3;

@property (nonatomic, assign) NSInteger r_a1;
@property (nonatomic, assign) NSInteger r_a2;
@property (nonatomic, assign) NSInteger r_a3;
@property (nonatomic, assign) NSInteger r_b1;
@property (nonatomic, assign) NSInteger r_b2;
@property (nonatomic, assign) NSInteger r_b3;
@property (nonatomic, assign) NSInteger r_c1;
@property (nonatomic, assign) NSInteger r_c2;
@property (nonatomic, assign) NSInteger r_c3;
@property (nonatomic, assign) NSInteger r_d1;
@property (nonatomic, assign) NSInteger r_d2;
@property (nonatomic, assign) NSInteger r_d3;

@property (nonatomic, assign) NSInteger a_r1;
@property (nonatomic, assign) NSInteger a_r2;
@property (nonatomic, assign) NSInteger a_r3;
@property (nonatomic, assign) NSInteger a_r4;
@property (nonatomic, assign) NSInteger a_r5;

@property (nonatomic, assign) NSInteger a_a1;
@property (nonatomic, assign) NSInteger a_a2;
@property (nonatomic, assign) NSInteger a_a3;
@property (nonatomic, assign) NSInteger a_b1;
@property (nonatomic, assign) NSInteger a_b2;
@property (nonatomic, assign) NSInteger a_b3;
@property (nonatomic, assign) NSInteger a_c1;
@property (nonatomic, assign) NSInteger a_c2;
@property (nonatomic, assign) NSInteger a_c3;
@property (nonatomic, assign) NSInteger a_d1;
@property (nonatomic, assign) NSInteger a_d2;
@property (nonatomic, assign) NSInteger a_d3;

@property (nonatomic, assign) NSInteger transfered_a1;
@property (nonatomic, assign) NSInteger transfered_a2;
@property (nonatomic, assign) NSInteger transfered_a3;
@property (nonatomic, assign) NSInteger transfered_b1;
@property (nonatomic, assign) NSInteger transfered_b2;
@property (nonatomic, assign) NSInteger transfered_b3;
@property (nonatomic, assign) NSInteger transfered_c1;
@property (nonatomic, assign) NSInteger transfered_c2;
@property (nonatomic, assign) NSInteger transfered_c3;
@property (nonatomic, assign) NSInteger transfered_d1;
@property (nonatomic, assign) NSInteger transfered_d2;
@property (nonatomic, assign) NSInteger transfered_d3;

//Map current scroll location
@property (nonatomic, assign) NSInteger map_center_x;
@property (nonatomic, assign) NSInteger map_center_y;
@property (nonatomic, assign) NSInteger map_tiles_x;
@property (nonatomic, assign) NSInteger map_tiles_y;

@property (nonatomic, assign) double base_r1;
@property (nonatomic, assign) double base_r2;
@property (nonatomic, assign) double base_r3;
@property (nonatomic, assign) double base_r4;
@property (nonatomic, assign) double base_r5;

@property (nonatomic, assign) BOOL gettingChatWorld;
@property (nonatomic, assign) BOOL gettingChatAlliance;
@property (nonatomic, assign) BOOL req1_b;
@property (nonatomic, assign) BOOL req2_b;
@property (nonatomic, assign) BOOL mapzoom_big; //if its normal size zoom (not tiny)
@property (nonatomic, assign) BOOL skill_point_spent; //track that hero skill point is spent and need to pull latest base data

typedef void (^returnBlock)(BOOL success, NSData *data);

//UI Methods
- (void)showDialogFail;
- (void)showDialogError;
- (void)showDialogFailedLoginEmail;
- (void)showDialogFailedLoginGamecenter;
- (void)showItems:(NSString *)category2;
- (void)showTroopList:(NSString *)status;
- (void)showConfirmCapture:(NSDictionary *)targetBaseDict;
- (void)invokeTutorial;
- (void)tutorial_off;

//TimerView Methods
- (void)popTvStack:(NSInteger)tv_id;
- (void)updateTv:(NSInteger)tv_id base_id:(NSString *)base_id time:(NSInteger)time title:(NSString *)title;
- (void)updateTv:(NSInteger)tv_id base_id:(NSString *)base_id time:(NSInteger)time title:(NSString *)title is_return:(BOOL)is_return will_return:(BOOL)will_return;
- (void)updateTv:(NSInteger)tv_id time:(NSInteger)time title:(NSString *)title;
- (void)updateTv:(NSInteger)tv_id time:(NSInteger)time title:(NSString *)title is_return:(BOOL)is_return will_return:(BOOL)will_return;
- (TimerView *)copyTvViewFromStack:(NSInteger)tv_id;
- (BOOL)isTvViewFromStack:(NSInteger)tv_id;
- (BOOL)isThereTvView:(NSInteger)tv_id;
- (void)setTimerViewTitle:(NSInteger)tv_id base_id:(NSString *)base_id title:(NSString *)title;
- (NSString *)fetchTimerViewTitle:(NSInteger)tv_id base_id:(NSString *)base_id;
- (void)setTimerViewParameter:(NSInteger)tv_id base_id:(NSString *)base_id param_name:(NSString *)parameter_name param_value:(NSString *)parameter_value;
- (NSString *)fetchTimerViewParameter:(NSInteger)tv_id base_id:(NSString *)base_id param_name:(NSString *)parameter_name;
- (void)updateTimerHolder;
- (void)setTimerViewTitle:(NSInteger)tv_id :(NSString *)title;
- (NSString *)fetchTimerViewTitle:(NSInteger)tv_id;
- (void)setTimerViewParameter:(NSInteger)tv_id :(NSString *)parameter_name :(NSString *)parameter_value;
- (NSString *)fetchTimerViewParameter:(NSInteger)tv_id :(NSString *)parameter_name;

//Graphic Pack
- (NSString	*)always_download_graphicpack;
- (void)download_graphicpack_on;
- (void)download_graphicpack_off;
- (NSString	*)graphic_pack_id;
- (void)set_graphic_pack_id:(NSString *)gid;
- (UIImage *)imageNamedCustom:(NSString *)image_name;

//Options
- (NSString	*)quest_reminder;
- (void)quest_reminder_on;
- (void)quest_reminder_off;

//Sound Methods
- (NSString	*)sound_fx;
- (NSString	*)music_intro;
- (NSString	*)music_bg;
- (void)sound_fx_on;
- (void)music_intro_on;
- (void)music_bg_on;
- (void)sound_fx_off;
- (void)music_intro_off;
- (void)music_bg_off;
- (void)playMusicLoading;
- (void)playMusicMap;
- (void)playMusicBackground;
- (void)play_archery;
- (void)play_barracks;
- (void)play_blacksmith;
- (void)play_castle;
- (void)play_embassy;
- (void)play_farm;
- (void)play_hospital;
- (void)play_house;
- (void)play_library;
- (void)play_market;
- (void)play_mine;
- (void)play_quarry;
- (void)play_rallypoint;
- (void)play_sawmill;
- (void)play_siege;
- (void)play_stable;
- (void)play_storehouse;
- (void)play_tavern;
- (void)play_wall;
- (void)play_watchtower;
- (void)play_attack;
- (void)play_button;
- (void)play_gold;
- (void)play_march;
- (void)play_messages;
- (void)play_notification;
- (void)play_placement;
- (void)play_speedup;
- (void)play_training;
- (void)play_build;
- (void)play_destroy;


+ (Globals *)i;
+ (NSOperationQueue *)connectionQueue;
- (NSString *)GameId;
- (NSString *)UID;
- (NSString *)world_url;
- (void)postServer:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock;
- (void)postServerLoading:(NSDictionary *)dict :(NSString *)service :(returnBlock)completionBlock;
- (void)getServer:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)getMainServerLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)getServerLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)loginGameCenter:(NSString *)playerID :(returnBlock)completionBlock;
- (void)getSpLoading:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)getSp:(NSString *)service_name :(NSString *)param :(returnBlock)completionBlock;
- (void)setUID:(NSString *)user_uid;
- (void)setLat:(NSString *)lat;
- (NSString *)getLat;
- (void)setLongi:(NSString *)longi;
- (NSString *)getLongi;
- (void)setDtoken:(NSString *)dt;
- (NSString *)getDtoken;
- (double)Random_next:(double)min to:(double)max;
- (void)resetLoginReminderNotification;
- (NSString *)BoolToBit: (NSString *)boolString;
- (NSString *)shortNumber:(NSString *)val;
- (NSString *)autoNumber:(NSString *)val;
- (NSTimeInterval)updateTime;
- (NSString *)getServerTimeString;
- (NSString *)getServerDateTimeString;
- (NSDate *)getServerDateTime;
- (NSString *)getTimeAgo:(NSString *)datetimestring;
- (NSInteger)getQuestBadgeNumber;
- (NSString *)getFirstUILogString;
- (NSString *)getSecondUILogString;
- (NSString *)getFirstChatString;
- (NSString *)getSecondChatString;
- (NSString *)getFirstAllianceChatString;
- (NSString *)getSecondAllianceChatString;
- (NSString *)getLastChatID;
- (NSString *)getLastAllianceChatID;
- (void)checkVersion;
- (void)updateProductIdentifiers;
- (void)updateSettings;
- (NSString *)gettSelectedBaseId;
- (void)settSelectedBaseId:(NSString *)bid;
- (NSString *)gettPurchasedProduct;
- (void)settPurchasedProduct:(NSString *)type;
- (NSString *)gettPurchasedGems;
- (void)settPurchasedGems:(NSString *)type;
- (NSString *)getCountdownString:(NSTimeInterval)differenceSeconds;
- (NSInteger)xpFromLevel:(NSInteger)level;
- (NSInteger)levelFromXp:(NSInteger)xp;
- (NSInteger)getXp;
- (NSInteger)getXpMax;
- (NSInteger)getXpMaxBefore;
- (NSInteger)getLevel;
- (NSString *)uintString:(NSUInteger)val;
- (NSString *)intString:(NSInteger)val;
- (NSString *)numberFormat:(NSString *)val;
- (void)updateBaseDict:(returnBlock)completionBlock;
- (NSInteger)getReportBadgeNumber;
- (NSMutableArray *)gettLocalReportData;
- (void)settLocalReportData:(NSMutableArray *)rd;
- (void)addLocalReportData:(NSMutableArray *)rd;
- (NSString *)gettLastReportId;
- (void)settLastReportId:(NSString *)rid;
- (NSDictionary *)gettLocalMailReply;
- (void)settLocalMailReply:(NSDictionary *)rd;
- (NSArray *)findMailReply:(NSString *)mail_id;
- (void)updateMailReply:(NSString *)mail_id;
- (NSInteger)getMailBadgeNumber;
- (NSMutableArray *)gettLocalMailData;
- (void)settLocalMailData:(NSMutableArray *)rd;
- (void)addLocalMailData:(NSMutableArray *)rd;
- (NSString *)gettLastMailId;
- (void)settLastMailId:(NSString *)rid;
- (void)addMailReply:(NSString *)mail_id :(NSArray *)mail_reply;
- (void)deleteLocalMail:(NSString *)mail_id;
- (void)replyCounterPlus:(NSString *)mail_id;
- (BOOL)updateEventSolo;
- (BOOL)updateEventAlliance;
- (NSDateFormatter *)getDateFormat;
- (void)getServerProfileData:(returnBlock)completionBlock;
- (void)getServerWorldProfileData:(returnBlock)completionBlock;
- (NSDictionary *)getUnitDict:(NSString *)type tier:(NSString *)tier;
- (NSMutableArray *)getUnitArray:(NSString *)type;
- (NSDictionary *)getBuildingDict:(NSString *)building_id;
- (NSDictionary *)getBuildingLevel:(NSString *)building_id level:(NSUInteger)level;
- (NSDictionary *)getHeroLevelDict:(NSInteger)level;
- (float)getXpProgressBar;
- (float)getXpMoreToLevelUp;
- (NSInteger)getXpBar;
- (NSInteger)getXpBarFull;
- (NSInteger)spBalance;
- (NSInteger)powerFromLevel:(NSInteger)level;
- (void)updateHeroXP:(NSInteger)xp_gain;
- (void)updateProfilePower:(NSInteger)power_gain;
- (NSString *)floatString:(double)val;
- (NSString *)getItemImageName:(NSString *)item_id;
- (NSDictionary *)getItemDict:(NSString *)item_id;
- (void)setupAllQueue;
- (void)setupBuildQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupResearchQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupAttackQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupTradeQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupReinforceQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupTransferQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupHospitalQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupAQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupBQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupCQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupDQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupSpyQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupBoostR1Queue:(NSTimeInterval)serverTimeInterval;
- (void)setupBoostR2Queue:(NSTimeInterval)serverTimeInterval;
- (void)setupBoostR3Queue:(NSTimeInterval)serverTimeInterval;
- (void)setupBoostR4Queue:(NSTimeInterval)serverTimeInterval;
- (void)setupBoostR5Queue:(NSTimeInterval)serverTimeInterval;
- (void)setupBoostAttackQueue:(NSTimeInterval)serverTimeInterval;
- (void)setupBoostDefendQueue:(NSTimeInterval)serverTimeInterval;
- (CGFloat)distance2xy:(CGFloat)from_x :(CGFloat)from_y :(CGFloat)to_x :(CGFloat)to_y;
- (CGFloat)distance2points:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint;
- (CGFloat)pointPairToBearingRadians:(CGPoint)startingPoint secondPoint:(CGPoint)endingPoint;
- (NSDictionary *)getResearchDict:(NSString *)research_id;
- (NSInteger)troopCount:(NSString *)status;
- (NSMutableArray *)createTroopList:(NSDictionary *)dict;
- (BOOL)NSStringIsValidEmail:(NSString *)checkString;
- (NSString *)stringToHex:(NSString *)str;
- (NSString	*)get_signin_name;
- (void)set_signin_name:(NSString *)name;
- (void)trackEvent:(NSString *)category action:(NSString *)action label:(NSString *)label;
- (void)trackEvent:(NSString *)category action:(NSString *)action;
- (void)trackEvent:(NSString *)category;
- (void)trackInvite:(NSString *)method;
- (void)trackScreenOpen:(NSString *)title;
- (void)trackScreenClose:(NSString *)title;
- (void)trackPurchase:(NSNumber *)revenue currencyCode:(NSString *)currencyCode localizedTitle:(NSString *)localizedTitle sku:(NSString *)sku;
- (void)trackSpend:(NSNumber *)cost itemName:(NSString *)itemName itemId:(NSString *)itemId;
- (void)GetTradesIn:(returnBlock)completionBlock;
- (void)GetAttacksIn:(returnBlock)completionBlock;
- (void)GetAttacksOut:(returnBlock)completionBlock;
- (void)GetReinforcesIn:(returnBlock)completionBlock;
- (void)GetReinforcesOut:(returnBlock)completionBlock;
- (void)GetAllianceMembers:(NSString *)alliance_id :(returnBlock)completionBlock;
- (void)allianceApply:(NSString *)alliance_id;
- (BOOL)is_allianceApplied:(NSString *)alliance_id;
- (NSString *)numberString:(NSNumber *)val;
- (void)showAlliesTroopCapacity:(NSString *)profile_id;
- (void)getBaseMain:(NSString *)profile_id :(returnBlock)completionBlock;
- (NSInteger)totalTroopsFromDict:(NSDictionary *)dict;
- (NSString *)floatNumber:(NSString *)val;
- (void)setupSignalR;
- (NSString *)shortNumberDouble:(double)dval;
- (void)signalr_logout;
- (void)updateMail;
- (void)updateReports:(returnBlock)completionBlock;
- (void)heroEquip:(NSString *)item_id hero_field:(NSString *)hero_field;
- (void)logout;
- (void)changeUserLogout;
- (void)addBaseResources:(NSString *)base_id :(double)ar1 :(double)ar2 :(double)ar3 :(double)ar4 :(double)ar5;
- (void)flushToStack;
- (void)flushToStackType:(NSInteger)type;
- (void)addTo:(NSInteger)type time:(NSInteger)time base_id:(NSString *)base_id title:(NSString *)title img:(NSString *)img dict:(NSDictionary *)dict;
- (NSMutableArray *)getToStackTransfer:(NSString *)base_id;
- (void)getNearestVillage:(NSInteger)center_x :(NSInteger)center_y :(returnBlock)completionBlock;
- (void)getRegions:(returnBlock)completionBlock;
- (void)getMapCities:(NSInteger)region_id :(returnBlock)completionBlock;
- (void)getMapVillages:(NSInteger)region_id :(returnBlock)completionBlock;
- (void)doTransferTroops:(NSDictionary *)targetBaseDict;
- (void)doReinforce:(NSString *)target_profile_id;
- (void)doTrade:(NSDictionary *)targetBaseDict;
- (void)doSpy:(NSDictionary *)targetBaseDict;
- (void)doAttack:(NSDictionary *)targetBaseDict;
- (void)deleteLocalReport:(NSString *)report_id;
- (void)updateBuildingLevel;
- (void)scheduleNotificationForDate:(NSDate *)date AlertBody:(NSString *)alertBody NotificationID:(NSString *)notificationID;
- (BOOL)cancelLocalNotification:(NSString *)notificationID;
- (void)cancelAllLocalNotification;
- (void)loginWorld;
- (NSInteger)mapHeight;
- (NSInteger)mapWidth;
- (NSInteger)terrainGenerator:(NSInteger)x :(NSInteger)y;
- (BOOL)is_tutorial_on;
- (NSMutableArray *)customParser:(NSData *)data;
- (NSDate *)dateParser:(NSString *)strDate;
- (void)emailToDeveloper;

@end
