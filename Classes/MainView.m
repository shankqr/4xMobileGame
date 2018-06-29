//
//  MainView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/3/09.
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

#import <StoreKit/StoreKit.h>
#import <StoreKit/SKPaymentTransaction.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import "MainView.h"
#import "Globals.h"

#import "MailView.h"
#import "MailCompose.h"
#import "ChatView.h"
#import "LoginView.h"
#import "BuyView.h"
//#import "SponsorsView.h"
#import "LoadingView.h"
#import "UIView+Glow.h"
#import "QuestView.h"
#import "MissionView.h"
#import "ReportView.h"
#import "BaseList.h"
#import "BaseDetail.h"
#import "ProfileHeader.h"
#import "ProfileView.h"
#import "MoreView.h"
#import "MapView.h"
#import "ItemsView.h"
#import "SalesView.h"
#import "RankingView.h"
#import "EventsView.h"
#import "SearchView.h"
#import "BaseView.h"
#import "CraftView.h"
#import "TavernView.h"
#import "TrainView.h"
#import "ResearchView.h"
#import "MarchesView.h"
#import "OptionsView.h"
//#import "SlotsView.h"
#import "HeroView.h"
#import "HeroSkills.h"
#import "BuildHeader.h"
#import "BuildView.h"
#import "ResourcesView.h"
#import "BuildingChart.h"
#import "CastleView.h"
#import "WallView.h"
#import "HospitalView.h"
#import "StorehouseView.h"
#import "MarketView.h"
#import "EmbassyView.h"
#import "WatchtowerView.h"
#import "SendHeader.h"
#import "SendTroops.h"
#import "MarketSend.h"
#import "ReportDetail.h"
#import "RankingAlliance.h"
#import "SearchAlliance.h"
#import "AllianceProfile.h"
#import "AllianceStats.h"
#import "AllianceDescription.h"
#import "AllianceCreate.h"
#import "AllianceView.h"
#import "AllianceDetail.h"
#import "AllianceMembers.h"
#import "AllianceApplicants.h"
#import "AllianceEvents.h"
#import "Kingdom-Swift.h"

#import "AFNetworking.h"
#import "SSZipArchive.h"

@interface MainView () <SKProductsRequestDelegate, SKPaymentTransactionObserver,
MFMailComposeViewControllerDelegate, UIScrollViewDelegate, SSZipArchiveDelegate, NSURLSessionDataDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

@property (nonatomic, strong) HeroSkills *heroSkills;
@property (nonatomic, strong) BaseView *baseView;
@property (nonatomic, strong) HeroView *heroView;
@property (nonatomic, strong) BaseList *baseList;
@property (nonatomic, strong) BaseDetail *baseDetail;
@property (nonatomic, strong) MailCompose *mailCompose;
@property (nonatomic, strong) ChatView *chatView;
@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) BuyView *buyView;
//@property (nonatomic, strong) SponsorsView *sponsorsView;
@property (nonatomic, strong) LoadingView *loadingView;
@property (nonatomic, strong) CraftView *craftView;
@property (nonatomic, strong) TavernView *tavernView;
@property (nonatomic, strong) CustomBadge *questBadge;
@property (nonatomic, strong) CustomBadge *mailBadge;
@property (nonatomic, strong) CustomBadge *reportBadge;
@property (nonatomic, strong) ProfileHeader *profileHeader;
@property (nonatomic, strong) ProfileView *profileView;
@property (nonatomic, strong) ReportView *reportView;
@property (nonatomic, strong) MailView *mailView;
@property (nonatomic, strong) MoreView *moreView;
@property (nonatomic, strong) MapView *mapView;
@property (nonatomic, strong) QuestView *questView;
@property (nonatomic, strong) MissionView *missionView;
@property (nonatomic, strong) ItemsView *itemsView;
@property (nonatomic, strong) SalesView *salesView;
@property (nonatomic, strong) RankingView *rvProfile;
@property (nonatomic, strong) SearchView *svProfile;
@property (nonatomic, strong) EventsView *eventSoloView;
@property (nonatomic, strong) TrainView *trainView;
@property (nonatomic, strong) ResearchView *researchView;
@property (nonatomic, strong) MarchesView *marchesView;
@property (nonatomic, strong) OptionsView *optionsView;
//@property (nonatomic, strong) SlotsView *slotsView;
@property (nonatomic, strong) ProgressView *pvHeroXp;
@property (nonatomic, strong) BuildHeader *buildHeader;
@property (nonatomic, strong) BuildView *buildView;
@property (nonatomic, strong) ResourcesView *resourcesView;
@property (nonatomic, strong) BuildingChart *buildingChart;
@property (nonatomic, strong) CastleView *castleView;
@property (nonatomic, strong) WallView *wallView;
@property (nonatomic, strong) HospitalView *hospitalView;
@property (nonatomic, strong) StorehouseView *storehouseView;
@property (nonatomic, strong) MarketView *marketView;
@property (nonatomic, strong) EmbassyView *embassyView;
@property (nonatomic, strong) WatchtowerView *watchtowerView;
@property (nonatomic, strong) SendHeader *sendHeader;
@property (nonatomic, strong) SendTroops *sendTroops;
@property (nonatomic, strong) MarketSend *marketSend;
@property (nonatomic, strong) TabView *itemsTabView;
@property (nonatomic, strong) ReportDetail *reportDetail;
@property (nonatomic, strong) ChatView *allianceChatView;
@property (nonatomic, strong) ChatView *allianceWall;
@property (nonatomic, strong) CustomBadge *allianceBadge;
@property (nonatomic, strong) EventsView *eventAllianceView;
@property (nonatomic, strong) RankingAlliance *rvAlliance;
@property (nonatomic, strong) SearchAlliance *svAlliance;
@property (nonatomic, strong) AllianceProfile *allianceProfile;
@property (nonatomic, strong) AllianceStats *allianceStats;
@property (nonatomic, strong) AllianceDescription *allianceDescription;
@property (nonatomic, strong) AllianceCreate *allianceCreate;
@property (nonatomic, strong) AllianceView *allianceView;
@property (nonatomic, strong) AllianceDetail *allianceDetail;
@property (nonatomic, strong) AllianceMembers *allianceMembers;
@property (nonatomic, strong) AllianceApplicants *allianceApplicants;
@property (nonatomic, strong) AllianceEvents *allianceEvents;
//@property (nonatomic, strong) BattleSceneViewController *battleView;

@property (nonatomic, strong) UIView *advisorView;
@property (nonatomic, strong) UIImageView *ivBkgHeader;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UILabel *lblTitle;
@property (nonatomic, strong) UIButton *btnBuy;
@property (nonatomic, strong) UILabel *lblCurrency;
@property (nonatomic, strong) UILabel *lblGetMore;
@property (nonatomic, strong) UIImageView *ivCurrency;
@property (nonatomic, strong) UIButton *btnHero;
@property (nonatomic, strong) UILabel *lblHero;
@property (nonatomic, strong) UIButton *btnProfile;
@property (nonatomic, strong) UILabel *lblPowerName;
@property (nonatomic, strong) UILabel *lblPowerPoints;
@property (nonatomic, strong) UIButton *btnBaseList;
@property (nonatomic, strong) UILabel *lblBaseName;
@property (nonatomic, strong) UILabel *lblBaseLocation;
@property (nonatomic, strong) UIImageView *bkgChat;
@property (nonatomic, strong) UIImageView *bkgTabs;
@property (nonatomic, strong) UIImageView *bkgToggle;
@property (nonatomic, strong) UIButton *mapBtn;
@property (nonatomic, strong) UIButton *questBtn;
@property (nonatomic, strong) UIButton *allianceBtn;
@property (nonatomic, strong) UIButton *itemBtn;
@property (nonatomic, strong) UIButton *mailBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property (nonatomic, strong) UIButton *extraBtn;
@property (nonatomic, strong) UIButton *btnHome;
@property (nonatomic, strong) UIButton *btnBookmark;
@property (nonatomic, strong) UIButton *btnSearch;
@property (nonatomic, strong) UIButton *btnFullscreen;
@property (nonatomic, strong) UIImageView *ivIndicator;
@property (nonatomic, strong) UILabel *itemLbl;
@property (nonatomic, strong) UILabel *questLbl;
@property (nonatomic, strong) UILabel *allianceLbl;
@property (nonatomic, strong) UILabel *mapLbl;
@property (nonatomic, strong) UILabel *mailLbl;
@property (nonatomic, strong) UILabel *moreLbl;
@property (nonatomic, strong) UILabel *extraLbl;
@property (nonatomic, strong) UILabel *lblChatWorld1;
@property (nonatomic, strong) UILabel *lblChatWorld2;
@property (nonatomic, strong) UILabel *lblChatAlliance1;
@property (nonatomic, strong) UILabel *lblChatAlliance2;
@property (nonatomic, strong) UIPageControl *pcChat;
@property (nonatomic, strong) UIScrollView *svChat;
@property (nonatomic, strong) UIImageView *ivChatWorldIcon;
@property (nonatomic, strong) UIImageView *ivChatAllianceIcon;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, assign) NSInteger indicatorState;
@property (nonatomic, assign) NSInteger chatState;
@property (nonatomic, assign) BOOL isShowingLogin;

//GraphicPack
@property (nonatomic, strong) NSString *graphicPackName;
@property (nonatomic, strong) NSString *graphicPackURL;
@property (nonatomic, strong) NSMutableData *graphicPackData;
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) UILabel *lblDownloadStatus;
@property (nonatomic) float downloadSize;

@end

@implementation MainView

#define face_size (48.0f*SCALE_IPAD)
#define frame_border (1.0f*SCALE_IPAD)
#define frame_width (54.0f*SCALE_IPAD)
#define frame_height (50.0f*SCALE_IPAD)
#define pvHeroXP_height (8.0f*SCALE_IPAD)

- (void)downloadGraphicPack
{
    Globals.i.setupInProgress = @"1";
    
    self.lblDownloadStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, BIG_FONT_SIZE)];
    self.lblDownloadStatus.text = NSLocalizedString(@"Downloading Latest Graphic Pack", nil);
    self.lblDownloadStatus.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
    self.lblDownloadStatus.backgroundColor = [UIColor clearColor];
    self.lblDownloadStatus.textColor = [UIColor whiteColor];
    self.lblDownloadStatus.textAlignment = NSTextAlignmentCenter;
    self.lblDownloadStatus.numberOfLines = 1;
    self.lblDownloadStatus.adjustsFontSizeToFitWidth = YES;
    self.lblDownloadStatus.minimumScaleFactor = 0.5f;
    [self.view addSubview:self.lblDownloadStatus];
    
    self.graphicPackName = [NSString stringWithFormat:@"GraphicPack_%@.zip", [Globals.i graphic_pack_id]];
    
    self.graphicPackURL = [NSString stringWithFormat:@"%@/kingdom_assets/%@", CORE_URL, self.graphicPackName];
    
    NSLog(@"Download from: %@", self.graphicPackURL);
    
    self.progressView = [[UIProgressView alloc] init];
    self.progressView.frame = CGRectMake((UIScreen.mainScreen.bounds.size.width/2)-50.0f*SCALE_IPAD, 150.0f*SCALE_IPAD, 100.0f*SCALE_IPAD, 20.0f*SCALE_IPAD);
    [self.view addSubview:self.progressView];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: self delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString: self.graphicPackURL];
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithURL: url];
    
    [dataTask resume];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    completionHandler(NSURLSessionResponseAllow);
    self.progressView.progress = 0.0f;
    self.downloadSize = [response expectedContentLength];
    self.graphicPackData = [[NSMutableData alloc] init];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    [self.graphicPackData appendData:data];
    self.progressView.progress = [self.graphicPackData length]/self.downloadSize;
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"completed; error: %@", error);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:self.graphicPackName];
    
    NSLog(@"Succeeded! Received %lu bytes of data", (unsigned long)[self.graphicPackData length]);

    if ([self.graphicPackData writeToFile:filePath atomically:YES])
    {
        [self.progressView removeFromSuperview];
        
        [self unzipGraphicPack];
    }
    else
    {
        self.lblDownloadStatus.text = NSLocalizedString(@"Error writeToFile!", nil);
    }
}

- (void)unzipGraphicPack
{
    //Unzip
    self.lblDownloadStatus.text = NSLocalizedString(@"Unpacking...", nil);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:self.graphicPackName];
    
    NSLog(@"zip file path: %@", filePath);
    
    NSArray *docPathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
    
    NSLog(@"documents array %@", docPathsArray);
    
    if ([SSZipArchive unzipFileAtPath:filePath toDestination:documentsDirectory delegate:self])
    {
        NSArray *docPathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory error:nil];
        
        NSLog(@"documents after unzip %@", docPathsArray);
        
        [self.lblDownloadStatus removeFromSuperview];
        
        [self setUp];
    }
    else
    {
        self.lblDownloadStatus.text = NSLocalizedString(@"Error unzipFileAtPath!", nil);
    }
}

- (void)setUp //Called when app opens for the first time
{
    self.title = @"MainView";
    
    CGFloat header_height = 43.0f*SCALE_IPAD;
    CGFloat tab_height = 43.0f*SCALE_IPAD;
    CGFloat tab_btn_width = 53.0f*SCALE_IPAD;
    CGFloat btnBuy_width = 100.0f*SCALE_IPAD;
    CGFloat lblTitle_width = UIScreen.mainScreen.bounds.size.width-header_height-btnBuy_width;
    CGFloat ivCurrency_height = 30.0f*SCALE_IPAD;
    CGFloat ivCurrency_width = 30.0f*SCALE_IPAD;
    
    if (self.ivBkgHeader == nil)
    {
        self.ivBkgHeader = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"bkg_header"]];
        [self.ivBkgHeader setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, header_height)];
        [self.view addSubview:self.ivBkgHeader];
    }
    
    if (self.btnBack == nil)
    {
        self.btnBack = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, header_height, header_height)];
        [self.btnBack setBackgroundImage:[Globals.i imageNamedCustom:@"button_back"] forState:UIControlStateNormal];
        [self.btnBack setBackgroundImage:[Globals.i imageNamedCustom:@"button_back_hvr"] forState:UIControlStateHighlighted];
        [self.btnBack addTarget:self action:@selector(back_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnBack];
    }
    
    if (self.lblTitle == nil)
    {
        self.lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(header_height, 0, lblTitle_width, header_height)];
        self.lblTitle.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:MEDIUM_FONT_SIZE];
        self.lblTitle.backgroundColor = [UIColor clearColor];
        self.lblTitle.textColor = [UIColor whiteColor];
        self.lblTitle.textAlignment = NSTextAlignmentCenter;
        self.lblTitle.numberOfLines = 1;
        self.lblTitle.adjustsFontSizeToFitWidth = YES;
        self.lblTitle.minimumScaleFactor = 0.5f;
        [self.view addSubview:self.lblTitle];
    }
    
    CGFloat btnBuy_x = header_height+lblTitle_width;
    
    if (self.btnBuy == nil)
    {
        self.btnBuy = [UIManager.i dynamicButtonWithTitle:@""
                                                 target:self
                                               selector:@selector(buy_tap:)
                                                  frame:CGRectMake(btnBuy_x, 0, btnBuy_width, header_height)
                                                   type:@"Buy"];
        [self.view addSubview:self.btnBuy];
    }
    
    CGFloat spacing = 5.0f*SCALE_IPAD;
    CGFloat ivCurrency_x = header_height + lblTitle_width + spacing;
    
    if (self.ivCurrency == nil)
    {
        self.ivCurrency = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"icon_currency2"]];
        [self.ivCurrency setFrame:CGRectMake(ivCurrency_x, spacing, ivCurrency_width, ivCurrency_height)];
        [self.view addSubview:self.ivCurrency];
    }
    
    CGFloat lblCurrency_x = ivCurrency_x + ivCurrency_width;
    CGFloat lblCurrency_width = btnBuy_width - ivCurrency_width - spacing;
    CGFloat lblCurrency_height = ivCurrency_height/2.0f;
    
    if (self.lblCurrency == nil)
    {
        self.lblCurrency = [[UILabel alloc] initWithFrame:CGRectMake(lblCurrency_x, spacing, lblCurrency_width, lblCurrency_height+spacing)];
        self.lblCurrency.font = [UIFont fontWithName:DEFAULT_FONT size:MEDIUM_FONT_SIZE];
        self.lblCurrency.backgroundColor = [UIColor clearColor];
        self.lblCurrency.textColor = [UIColor blackColor];
        self.lblCurrency.textAlignment = NSTextAlignmentLeft;
        self.lblCurrency.numberOfLines = 1;
        self.lblCurrency.adjustsFontSizeToFitWidth = YES;
        self.lblCurrency.minimumScaleFactor = 0.5f;
        [self.view addSubview:self.lblCurrency];
    }
    
    if (self.lblGetMore == nil)
    {
        self.lblGetMore = [[UILabel alloc] initWithFrame:CGRectMake(lblCurrency_x, spacing+lblCurrency_height, lblCurrency_width, lblCurrency_height)];
        self.lblGetMore.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
        self.lblGetMore.backgroundColor = [UIColor clearColor];
        self.lblGetMore.textColor = [UIColor blackColor];
        self.lblGetMore.textAlignment = NSTextAlignmentLeft;
        self.lblGetMore.numberOfLines = 1;
        self.lblGetMore.adjustsFontSizeToFitWidth = YES;
        self.lblGetMore.minimumScaleFactor = 0.5f;
        self.lblGetMore.text = NSLocalizedString(@"Get More", nil);
        [self.view addSubview:self.lblGetMore];
    }
    
    //HERO XP ProgressBar
    CGFloat lblHero_width = 16.0f*SCALE_IPAD;
    CGFloat lblHero_height = 13.0f*SCALE_IPAD;
    CGFloat pvHeroXP_width = frame_width-lblHero_width-frame_border*2;
    
    if (self.pvHeroXp == nil)
    {
        self.pvHeroXp = [[ProgressView alloc] initWithFrame:CGRectMake(frame_border, frame_height-frame_border-pvHeroXP_height, pvHeroXP_width, pvHeroXP_height)];
        [self.view addSubview:self.pvHeroXp];
    }
    
    //HERO Button
    if (self.btnHero == nil)
    {
        UIImage *imgHero = [Globals.i imageNamedCustom:@"c2"];
        UIImage *imgFrame = [Globals.i imageNamedCustom:@"hero_frame"];
        UIImage *imgLight = [Globals.i imageNamedCustom:@"fx_shine"];
        
        UIGraphicsBeginImageContext(CGSizeMake(frame_width, frame_height));
        [imgHero drawInRect:CGRectMake(frame_border, frame_border, face_size, face_size-pvHeroXP_height)];
        [imgLight drawInRect:CGRectMake(frame_border, frame_border, face_size, face_size)];
        [imgFrame drawInRect:CGRectMake(0.0f, 0.0f, frame_width, frame_height)];
        UIImage *imgH = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIGraphicsBeginImageContext(CGSizeMake(frame_width, frame_height));
        [imgHero drawInRect:CGRectMake(frame_border, frame_border, face_size, face_size-pvHeroXP_height)];
        [imgFrame drawInRect:CGRectMake(0.0f, 0.0f, frame_width, frame_height)];
        UIImage *imgN = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.btnHero = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame_width, frame_height)];
        [self.btnHero setBackgroundImage:imgN forState:UIControlStateNormal];
        [self.btnHero setBackgroundImage:imgH forState:UIControlStateHighlighted];
        [self.btnHero addTarget:self action:@selector(hero_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnHero];
    }
    
    if (self.lblHero == nil)
    {
        self.lblHero = [[UILabel alloc] initWithFrame:CGRectMake(frame_border+pvHeroXP_width, frame_height-frame_border*3-lblHero_height, lblHero_width, lblHero_height)];
        self.lblHero.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
        self.lblHero.backgroundColor = [UIColor clearColor];
        self.lblHero.textColor = [UIColor whiteColor];
        self.lblHero.textAlignment = NSTextAlignmentCenter;
        self.lblHero.numberOfLines = 1;
        self.lblHero.adjustsFontSizeToFitWidth = YES;
        self.lblHero.minimumScaleFactor = 0.1f;
        [self.view addSubview:self.lblHero];
    }
    
    //Profile Button
    CGFloat btnProfile_x = frame_width + 5.0f*SCALE_IPAD;
    CGFloat btnProfile_y = 3.0f*SCALE_IPAD;
    CGFloat middle_width = btnBuy_x - btnProfile_x - 10.0f*SCALE_IPAD;
    CGFloat btnProfile_width = middle_width/2.0f;
    CGFloat btnProfile_height = header_height - 6.0f*SCALE_IPAD;
    
    if (self.btnProfile == nil)
    {
        self.btnProfile = [UIManager.i dynamicButtonWithTitle:@""
                                                     target:self
                                                   selector:@selector(profile_tap:)
                                                      frame:CGRectMake(btnProfile_x, btnProfile_y, btnProfile_width, btnProfile_height)
                                                       type:@"2"];
        [self.view addSubview:self.btnProfile];
    }
    
    CGFloat lblPower_x = btnProfile_x;
    CGFloat lblPower_width = btnProfile_width;
    CGFloat lblPower_height = btnProfile_height/2.0f;
    
    if (self.lblPowerName == nil)
    {
        self.lblPowerName = [[UILabel alloc] initWithFrame:CGRectMake(lblPower_x, spacing, lblPower_width, lblPower_height)];
        self.lblPowerName.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
        self.lblPowerName.backgroundColor = [UIColor clearColor];
        self.lblPowerName.textColor = [UIColor whiteColor];
        self.lblPowerName.textAlignment = NSTextAlignmentCenter;
        self.lblPowerName.numberOfLines = 1;
        self.lblPowerName.adjustsFontSizeToFitWidth = YES;
        self.lblPowerName.minimumScaleFactor = 0.5f;
        self.lblPowerName.text = NSLocalizedString(@"POWER", nil);
        [self.view addSubview:self.lblPowerName];
    }
    
    if (self.lblPowerPoints == nil)
    {
        self.lblPowerPoints = [[UILabel alloc] initWithFrame:CGRectMake(lblPower_x, lblPower_height, lblPower_width, lblPower_height)];
        self.lblPowerPoints.font = [UIFont fontWithName:DEFAULT_FONT size:SMALL_FONT_SIZE];
        self.lblPowerPoints.backgroundColor = [UIColor clearColor];
        self.lblPowerPoints.textColor = [UIColor whiteColor];
        self.lblPowerPoints.textAlignment = NSTextAlignmentCenter;
        self.lblPowerPoints.numberOfLines = 1;
        self.lblPowerPoints.adjustsFontSizeToFitWidth = YES;
        self.lblPowerPoints.minimumScaleFactor = 0.5f;
        [self.view addSubview:self.lblPowerPoints];
    }
    
    //BaseList Button
    CGFloat btnBase_x = btnProfile_x + btnProfile_width + 5.0f*SCALE_IPAD;
    CGFloat btnBase_y = btnProfile_y;
    CGFloat btnBase_width = btnProfile_width;
    CGFloat btnBase_height = btnProfile_height;
    
    if (self.btnBaseList == nil)
    {
        self.btnBaseList = [UIManager.i dynamicButtonWithTitle:@""
                                                      target:self
                                                    selector:@selector(baselist_tap:)
                                                       frame:CGRectMake(btnBase_x, btnBase_y, btnBase_width, btnBase_height)
                                                        type:@"2"];
        [self.view addSubview:self.btnBaseList];
    }
    
    CGFloat lblBase_x = btnBase_x;
    CGFloat lblBase_width = btnBase_width;
    CGFloat lblBase_height = btnBase_height/2.0f;
    
    if (self.lblBaseName == nil)
    {
        self.lblBaseName = [[UILabel alloc] initWithFrame:CGRectMake(lblBase_x, spacing, lblBase_width, lblBase_height)];
        self.lblBaseName.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:SMALL_FONT_SIZE];
        self.lblBaseName.backgroundColor = [UIColor clearColor];
        self.lblBaseName.textColor = [UIColor whiteColor];
        self.lblBaseName.textAlignment = NSTextAlignmentCenter;
        self.lblBaseName.numberOfLines = 1;
        self.lblBaseName.adjustsFontSizeToFitWidth = YES;
        self.lblBaseName.minimumScaleFactor = 0.5f;
        [self.view addSubview:self.lblBaseName];
    }
    
    if (self.lblBaseLocation == nil)
    {
        self.lblBaseLocation = [[UILabel alloc] initWithFrame:CGRectMake(lblBase_x, lblBase_height, lblBase_width, lblBase_height)];
        self.lblBaseLocation.font = [UIFont fontWithName:DEFAULT_FONT size:SMALL_FONT_SIZE];
        self.lblBaseLocation.backgroundColor = [UIColor clearColor];
        self.lblBaseLocation.textColor = [UIColor whiteColor];
        self.lblBaseLocation.textAlignment = NSTextAlignmentCenter;
        self.lblBaseLocation.numberOfLines = 1;
        self.lblBaseLocation.adjustsFontSizeToFitWidth = YES;
        self.lblBaseLocation.minimumScaleFactor = 0.5f;
        [self.view addSubview:self.lblBaseLocation];
    }
    
    CGFloat bkgTabs_y = UIScreen.mainScreen.bounds.size.height-tab_height;
    CGFloat bkgChat_y = bkgTabs_y-CHAT_HEIGHT;
    
    if (self.bkgChat == nil)
    {
        self.bkgChat = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"bkg_chat"]];
        [self.bkgChat setFrame:CGRectMake(0, bkgChat_y, UIScreen.mainScreen.bounds.size.width, CHAT_HEIGHT)];
        [self.view addSubview:self.bkgChat];
    }
    
    if (self.bkgTabs == nil)
    {
        self.bkgTabs = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"bkg_tab"]];
        [self.bkgTabs setFrame:CGRectMake(0, bkgTabs_y, UIScreen.mainScreen.bounds.size.width, tab_height)];
        [self.view addSubview:self.bkgTabs];
    }
    
    if (self.bkgToggle == nil)
    {
        self.bkgToggle = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"bkg_toggle"]];
        [self.bkgToggle setFrame:CGRectMake(0, bkgTabs_y, tab_btn_width, tab_height)];
        [self.view addSubview:self.bkgToggle];
    }
    
    if (self.mapBtn == nil)
    {
        self.mapBtn = [[UIButton alloc] init];
        [self.mapBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_map"] forState:UIControlStateNormal];
        [self.mapBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_map_h"] forState:UIControlStateHighlighted];
        [self.mapBtn addTarget:self action:@selector(map_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.mapBtn];
    }
    
    if (self.questBtn == nil)
    {
        self.questBtn = [[UIButton alloc] init];
        [self.questBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_quest"] forState:UIControlStateNormal];
        [self.questBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_quest_h"] forState:UIControlStateHighlighted];
        [self.questBtn addTarget:self action:@selector(quest_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.questBtn];
    }
    
    if (self.allianceBtn == nil)
    {
        self.allianceBtn = [[UIButton alloc] init];
        [self.allianceBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_alliance"] forState:UIControlStateNormal];
        [self.allianceBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_alliance_h"] forState:UIControlStateHighlighted];
        [self.allianceBtn addTarget:self action:@selector(alliance_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.allianceBtn];
    }
    
    if (self.itemBtn == nil)
    {
        self.itemBtn = [[UIButton alloc] init];
        [self.itemBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_items"] forState:UIControlStateNormal];
        [self.itemBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_items_h"] forState:UIControlStateHighlighted];
        [self.itemBtn addTarget:self action:@selector(items_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.itemBtn];
    }
    
    if (self.mailBtn == nil)
    {
        self.mailBtn = [[UIButton alloc] init];
        [self.mailBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_mail"] forState:UIControlStateNormal];
        [self.mailBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_mail_h"] forState:UIControlStateHighlighted];
        [self.mailBtn addTarget:self action:@selector(mail_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.mailBtn];
    }
    
    if (self.moreBtn == nil)
    {
        self.moreBtn = [[UIButton alloc] init];
        [self.moreBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_more"] forState:UIControlStateNormal];
        [self.moreBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_more_h"] forState:UIControlStateHighlighted];
        [self.moreBtn addTarget:self action:@selector(more_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.moreBtn];
    }
    
    [self.mapBtn setFrame:CGRectMake(0, bkgTabs_y, tab_btn_width, tab_height)];
    [self.questBtn setFrame:CGRectMake(tab_btn_width, bkgTabs_y, tab_btn_width, tab_height)];
    [self.allianceBtn setFrame:CGRectMake(tab_btn_width*2, bkgTabs_y, tab_btn_width, tab_height)];
    [self.itemBtn setFrame:CGRectMake(tab_btn_width*3, bkgTabs_y, tab_btn_width, tab_height)];
    [self.mailBtn setFrame:CGRectMake(tab_btn_width*4, bkgTabs_y, tab_btn_width, tab_height)];
    [self.moreBtn setFrame:CGRectMake(tab_btn_width*5, bkgTabs_y, tab_btn_width, tab_height)];
    
    //Map Buttons
    CGFloat btn_box_size = 32.0f*SCALE_IPAD;
    if (self.btnHome == nil)
    {
        self.btnHome = [[UIButton alloc] initWithFrame:CGRectMake(0.0f, 5.0f*SCALE_IPAD, btn_box_size, btn_box_size)];
        [self.btnHome setBackgroundImage:[Globals.i imageNamedCustom:@"button_home"] forState:UIControlStateNormal];
        [self.btnHome addTarget:self action:@selector(home_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnHome];
    }
    
    if (self.btnSearch == nil)
    {
        self.btnSearch = [[UIButton alloc] initWithFrame:CGRectMake(btn_box_size+5.0f*SCALE_IPAD, 5.0f*SCALE_IPAD, btn_box_size, btn_box_size)];
        [self.btnSearch setBackgroundImage:[Globals.i imageNamedCustom:@"button_search_map"] forState:UIControlStateNormal];
        [self.btnSearch addTarget:self action:@selector(search_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnSearch];
    }
    
    if (self.btnBookmark == nil)
    {
        self.btnBookmark = [[UIButton alloc] initWithFrame:CGRectMake(btn_box_size*2+10.0f*SCALE_IPAD, 5.0f*SCALE_IPAD, btn_box_size, btn_box_size)];
        [self.btnBookmark setBackgroundImage:[Globals.i imageNamedCustom:@"button_bookmark"] forState:UIControlStateNormal];
        [self.btnBookmark addTarget:self action:@selector(bookmark_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnBookmark];
    }
    
    if (self.btnFullscreen == nil)
    {
        self.btnFullscreen = [[UIButton alloc] initWithFrame:CGRectMake(btn_box_size*3+15.0f*SCALE_IPAD, 5.0f*SCALE_IPAD, btn_box_size, btn_box_size)];
        [self.btnFullscreen setBackgroundImage:[Globals.i imageNamedCustom:@"button_fullscreen"] forState:UIControlStateNormal];
        [self.btnFullscreen addTarget:self action:@selector(fullscreen_tap:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.btnFullscreen];
    }
    
    self.btnBookmark.hidden = YES;
    self.btnFullscreen.hidden = YES;
    self.btnHome.hidden = YES;
    self.btnSearch.hidden = YES;
    
    float label_height = SMALL_FONT_SIZE;
    float label_font_size = SMALL_FONT_SIZE;
    float label_offset = 1.0f*SCALE_IPAD;
    
    if (iPad)
    {
        if (self.extraBtn == nil)
        {
            self.extraBtn = [[UIButton alloc] init];
            [self.extraBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_extra"] forState:UIControlStateNormal];
            [self.extraBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_extra_h"] forState:UIControlStateHighlighted];
            [self.extraBtn addTarget:self action:@selector(extra_tap:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.extraBtn];
        }
        
        [self.extraBtn setFrame:CGRectMake(tab_btn_width*5, bkgTabs_y, tab_btn_width, tab_height)];
        [self.moreBtn setFrame:CGRectMake(tab_btn_width*6, bkgTabs_y, tab_btn_width, tab_height)];
        
        if (self.extraLbl == nil)
        {
            self.extraLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.extraBtn.frame.origin.x, UIScreen.mainScreen.bounds.size.height-label_offset-label_height, self.extraBtn.frame.size.width, label_height)];
            self.extraLbl.text = @"REPORT";
            self.extraLbl.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:label_font_size];
            self.extraLbl.backgroundColor = [UIColor clearColor];
            self.extraLbl.textColor = [UIColor whiteColor];
            self.extraLbl.textAlignment = NSTextAlignmentCenter;
            self.extraLbl.numberOfLines = 1;
            self.extraLbl.minimumScaleFactor = 1.0f;
            [self.view insertSubview:self.extraLbl aboveSubview:self.extraBtn];
        }
    }
    
    if (self.mapLbl == nil)
    {
        self.mapLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.mapBtn.frame.origin.x, UIScreen.mainScreen.bounds.size.height-label_offset-label_height, self.mapBtn.frame.size.width, label_height)];
        self.mapLbl.text = NSLocalizedString(@"CITY", nil);
        self.mapLbl.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:label_font_size];
        self.mapLbl.backgroundColor = [UIColor clearColor];
        self.mapLbl.textColor = [UIColor whiteColor];
        self.mapLbl.textAlignment = NSTextAlignmentCenter;
        self.mapLbl.numberOfLines = 1;
        self.mapLbl.minimumScaleFactor = 1.0f;
        [self.view insertSubview:self.mapLbl aboveSubview:self.mapBtn];
    }
    
    if (self.questLbl == nil)
    {
        self.questLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.questBtn.frame.origin.x, UIScreen.mainScreen.bounds.size.height-label_offset-label_height, self.questBtn.frame.size.width, label_height)];
        self.questLbl.text = NSLocalizedString(@"QUEST", nil);
        self.questLbl.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:label_font_size];
        self.questLbl.backgroundColor = [UIColor clearColor];
        self.questLbl.textColor = [UIColor whiteColor];
        self.questLbl.textAlignment = NSTextAlignmentCenter;
        self.questLbl.numberOfLines = 1;
        self.questLbl.minimumScaleFactor = 1.0f;
        [self.view insertSubview:self.questLbl aboveSubview:self.questBtn];
    }
    
    if (self.allianceLbl == nil)
    {
        self.allianceLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.allianceBtn.frame.origin.x, UIScreen.mainScreen.bounds.size.height-label_offset-label_height, self.allianceBtn.frame.size.width, label_height)];
        self.allianceLbl.text = NSLocalizedString(@"ALLIANCE", nil);
        self.allianceLbl.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:label_font_size];
        self.allianceLbl.backgroundColor = [UIColor clearColor];
        self.allianceLbl.textColor = [UIColor whiteColor];
        self.allianceLbl.textAlignment = NSTextAlignmentCenter;
        self.allianceLbl.numberOfLines = 1;
        self.allianceLbl.minimumScaleFactor = 1.0f;
        [self.view insertSubview:self.allianceLbl aboveSubview:self.allianceBtn];
    }
    
    if (self.itemLbl == nil)
    {
        self.itemLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.itemBtn.frame.origin.x, UIScreen.mainScreen.bounds.size.height-label_offset-label_height, self.itemBtn.frame.size.width, label_height)];
        self.itemLbl.text = NSLocalizedString(@"ITEMS", nil);
        self.itemLbl.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:label_font_size];
        self.itemLbl.backgroundColor = [UIColor clearColor];
        self.itemLbl.textColor = [UIColor whiteColor];
        self.itemLbl.textAlignment = NSTextAlignmentCenter;
        self.itemLbl.numberOfLines = 1;
        self.itemLbl.minimumScaleFactor = 1.0f;
        [self.view insertSubview:self.itemLbl aboveSubview:self.itemBtn];
    }
    
    if (self.mailLbl == nil)
    {
        self.mailLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.mailBtn.frame.origin.x, UIScreen.mainScreen.bounds.size.height-label_offset-label_height, self.mailBtn.frame.size.width, label_height)];
        self.mailLbl.text = NSLocalizedString(@"MAIL", nil);
        self.mailLbl.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:label_font_size];
        self.mailLbl.backgroundColor = [UIColor clearColor];
        self.mailLbl.textColor = [UIColor whiteColor];
        self.mailLbl.textAlignment = NSTextAlignmentCenter;
        self.mailLbl.numberOfLines = 1;
        self.mailLbl.minimumScaleFactor = 1.0f;
        [self.view insertSubview:self.mailLbl aboveSubview:self.mailBtn];
    }
    
    if (self.moreLbl == nil)
    {
        self.moreLbl = [[UILabel alloc] initWithFrame:CGRectMake(self.moreBtn.frame.origin.x, UIScreen.mainScreen.bounds.size.height-label_offset-label_height, self.moreBtn.frame.size.width, label_height)];
        self.moreLbl.text = NSLocalizedString(@"MORE", nil);
        self.moreLbl.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:label_font_size];
        self.moreLbl.backgroundColor = [UIColor clearColor];
        self.moreLbl.textColor = [UIColor whiteColor];
        self.moreLbl.textAlignment = NSTextAlignmentCenter;
        self.moreLbl.numberOfLines = 1;
        self.moreLbl.minimumScaleFactor = 1.0f;
        [self.view insertSubview:self.moreLbl aboveSubview:self.moreBtn];
    }
    
    //Create chat
    if (self.svChat == nil)
    {
        self.svChat = [[UIScrollView alloc] init];
        self.svChat.frame = self.bkgChat.frame;
        self.svChat.backgroundColor = [UIColor clearColor];
        self.svChat.pagingEnabled = YES;
        self.svChat.contentSize = CGSizeMake(self.svChat.frame.size.width*2, self.svChat.frame.size.height);
        self.svChat.showsHorizontalScrollIndicator = NO;
        self.svChat.showsVerticalScrollIndicator = NO;
        self.svChat.scrollsToTop = NO;
        self.svChat.delegate = self;
        [self.view addSubview:self.svChat];
    }
    
    float pagecontrol_width = 30.0f*SCALE_IPAD;
    float pagecontrol_height = 8.0f*SCALE_IPAD;
    
    if (self.pcChat == nil)
    {
        self.pcChat = [[UIPageControl alloc] init];
        self.pcChat.frame = CGRectMake(self.bkgChat.frame.size.width/2 - pagecontrol_width/2, self.bkgChat.frame.origin.y, pagecontrol_width, pagecontrol_height);
        self.pcChat.backgroundColor = [UIColor clearColor];
        self.pcChat.numberOfPages = 2;
        self.pcChat.currentPage = 0;
        [self.view addSubview:self.pcChat];
    }
    
    [self loadScrollViewWithPage:0];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchChat)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [self.svChat addGestureRecognizer:recognizer];
    
    self.isShowingLogin = NO;
    [UIManager.i pushViewControllerStack:self];
    
    [self updateIndicator:1];
    
    self.chatState = 1; //World Chat
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [self notificationRegister];
    
    Globals.i.launchFirstTime = @"0"; //So that updateView will not do downloadGraphicPack anymore
    
    [self updateView];
}

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateAdvisor"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAdvisor"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickShowQuestButton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickShowMapButton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickShowAllianceButton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickShowMoreButton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickShowReportButton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickShowMailButtonThenReportTab"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickShowCityButton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ClickShowBaseListButton"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowLogin"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAlliance"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowBuy"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowHelp"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowCraft"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowFeedback"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowInvite"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowMoreGames"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateWorldProfileData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowBaseList"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowHero"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowBaseDetail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowProfile"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAllianceProfile"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAllianceDetail"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"MailCompose"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowTrain"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowResearch"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowMarches"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowOptions"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowSlots"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowSports"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowSearch"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowRanking"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateMailBadge"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PlusoneMailBadge"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PlusoneReportBadge"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateQuestBadge"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PlusQuestBadge"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateAllianceBadge"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowSales"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"InAppPurchase"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"EventSolo"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"EventAlliance"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowTemplateComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateComplete"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UILog"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChatWorld"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChatAlliance"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TabWorld Chat"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TabAlliance Chat"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"BaseUpdated"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowHeroSkills"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeroXP"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowBuildUpgrade"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowResourcesView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowBuildingChart"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowCastle"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowWall"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowHospital"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowStorehouse"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowMarket"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowEmbassy"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowWatchtower"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowArchery"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowStable"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowWorkshop"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowTavern"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowItems"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateHeroType"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SendTroops"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"SendResources"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAllianceCreate"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAllianceMembers"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAllianceApplicants"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAllianceEvents"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAllianceWall"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowAllianceStats"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowMap"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowReportDialog"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"GlowBordersAttack"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"EmptyHeader"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"PreloadItems"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ShowBattle"
                                               object:nil];
}

- (void)notificationReceived:(NSNotification *)notification
{
    NSLog(@"Notification Name : %@",[notification name]);
    
    if ([[notification name] isEqualToString:@"GlowBordersAttack"])
    {
        NSString *str_time = [notification.userInfo objectForKey:@"march_time"];
        float time = [str_time floatValue];
        
        [self glowBorders:[UIColor redColor] duration:time];
    }
    else if ([[notification name] isEqualToString:@"ShowLogin"])
    {
        self.mailView = nil;
        [self.mailBadge setHidden:YES];
        
        self.reportView = nil;
        [self.reportBadge setHidden:YES];
        
        [self.questBadge setHidden:YES];
        
        Globals.i.wsItemArray = nil;
        
        [self gotoLogin:NO];
    }
    else if ([[notification name] isEqualToString:@"ShowAlliance"])
    {
        [self showAlliance];
    }
    else if ([[notification name] isEqualToString:@"ShowBuy"])
    {
        [self showBuy];
    }
    else if ([[notification name] isEqualToString:@"ShowFeedback"])
    {
        [HelpshiftSupport showConversation:self withOptions:nil];
    }
    else if ([[notification name] isEqualToString:@"ShowInvite"])
    {
        [self inviteFriends];
    }
    else if ([[notification name] isEqualToString:@"ShowMoreGames"])
    {
        [self showMoreGames];
    }
    else if ([[notification name] isEqualToString:@"ShowAllianceStats"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (self.allianceStats == nil)
        {
            self.allianceStats = [[AllianceStats alloc] initWithStyle:UITableViewStylePlain];
        }
        
        if ([userInfo objectForKey:@"alliance_object"] != nil)
        {
            self.allianceStats.aAlliance = [userInfo objectForKey:@"alliance_object"];
            self.allianceStats.title = @"Stats";
            [self.allianceStats updateView];
            [UIManager.i showTemplate:@[self.allianceStats] :NSLocalizedString(@"Stats", nil)];
        }
    }
    else if ([[notification name] isEqualToString:@"UpdateWorldProfileData"])
    {
        self.lblCurrency.text = [Globals.i autoNumber:Globals.i.wsWorldProfileDict[@"currency_second"]];
        self.lblPowerPoints.text = [Globals.i autoNumber:Globals.i.wsWorldProfileDict[@"xp"]];
    }
    else if ([[notification name] isEqualToString:@"ShowProfile"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *profile_id = [userInfo objectForKey:@"profile_id"];
        NSString *button_alliance = @"1"; //By default show alliance
        
        if ([[userInfo objectForKey:@"button_alliance"] isEqualToString:@"0"])
        {
            button_alliance = @"0";
        }
        
        [self viewProfile:profile_id :button_alliance];
    }
    else if ([[notification name] isEqualToString:@"ShowBaseList"])
    {
        [self showBaseList];
    }
    else if ([[notification name] isEqualToString:@"ShowHero"])
    {
        [self showHero];
    }
    else if ([[notification name] isEqualToString:@"ShowHeroSkills"])
    {
        [self showHeroSkills];
    }
    else if ([[notification name] isEqualToString:@"ShowBaseDetail"])
    {
        [self showBaseDetail];
    }
    else if ([[notification name] isEqualToString:@"ShowAllianceProfile"])
    {
        [self viewAllianceProfile:notification.userInfo];
    }
    else if ([[notification name] isEqualToString:@"ShowAllianceDetail"])
    {
        if (self.allianceProfile == nil)
        {
            self.allianceProfile = [[AllianceProfile alloc] initWithStyle:UITableViewStylePlain];
        }
        self.allianceProfile.title = @"Alliance";
        
        if (self.allianceDetail == nil)
        {
            self.allianceDetail = [[AllianceDetail alloc] initWithStyle:UITableViewStylePlain];
        }
        self.allianceDetail.title = @"Alliance";
        
        NSString *alliance_id = Globals.i.wsWorldProfileDict[@"alliance_id"];
        NSString *service_name = @"GetAllianceDetail";
        NSString *wsurl = [NSString stringWithFormat:@"/%@",
                           alliance_id];
        
        [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 if (returnArray.count > 0)
                 {
                     AllianceObject *aObject = [[AllianceObject alloc] initWithDictionary:returnArray[0]];
                     self.allianceProfile.aAlliance = aObject;
                     [self.allianceProfile updateView];
                     
                     self.allianceDetail.aAlliance = aObject;
                     [self.allianceDetail updateView];
                     
                     [UIManager.i showTemplate:@[self.allianceDetail] :NSLocalizedString(@"Alliance", nil) :4 :0 :@[self.allianceProfile]];
                 }
             }
         }];
        
        
    }
    else if ([[notification name] isEqualToString:@"MailCompose"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *isAlli = [userInfo objectForKey:@"is_alli"];
        NSString *toID = [userInfo objectForKey:@"to_id"];
        NSString *toName = [userInfo objectForKey:@"to_name"];
        
        [self mailCompose:isAlli toID:toID toName:toName];
    }
    else if ([[notification name] isEqualToString:@"ShowHelp"])
    {
        [HelpshiftSupport showFAQs:self withOptions:nil];
        
        //[self showHelp];
    }
    else if ([[notification name] isEqualToString:@"ShowMarches"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        BOOL hasBuild = NO;
        
        if (b_id == nil)
        {
            //Find any Library in build list
            for (NSDictionary *dict in Globals.i.wsBuildArray)
            {
                if ([dict[@"building_id"] integerValue] == 18)
                {
                    hasBuild = YES;
                    
                    b_id = dict[@"building_id"];
                    b_level = dict[@"building_level"];
                    b_location = dict[@"location"];
                    
                    //Check if this building is under construction
                    if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:b_location] && (Globals.i.buildQueue1 > 1))
                    {
                        NSInteger blvl = [b_level integerValue];
                        blvl = blvl-1;
                        b_level = [@(blvl) stringValue];
                        upgrading = @"1";
                    }
                }
            }
        }
        else
        {
            hasBuild = YES;
        }
        
        if (hasBuild)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.marchesView == nil)
            {
                self.marchesView = [[MarchesView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.marchesView.level = [b_level integerValue];
            [self.marchesView clearView];
            self.marchesView.title = self.buildHeader.title;
            [self.marchesView updateView];
            
            [UIManager.i showTemplate:@[self.marchesView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
        else
        {
            [UIManager.i showDialog:NSLocalizedString(@"You need to build a Rally Point first to view Marches.", nil) title:@"RallyPointNeededToViewMarches"];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowOptions"])
    {
        [self showOptions];
    }
    else if ([[notification name] isEqualToString:@"ShowSports"])
    {
        [self showSports];
    }
    else if ([[notification name] isEqualToString:@"ShowSlots"])
    {
        [self showSlots];
    }
    else if ([[notification name] isEqualToString:@"ShowSearch"])
    {
        [self showSearch];
    }
    else if ([[notification name] isEqualToString:@"ShowRanking"])
    {
        [self showRanking];
    }
    else if ([[notification name] isEqualToString:@"UpdateMailBadge"])
    {
        [self updateMailBadge];
    }
    else if ([[notification name] isEqualToString:@"PlusoneMailBadge"])
    {
        [self plusoneMailBadge];
    }
    else if ([[notification name] isEqualToString:@"PlusoneReportBadge"])
    {
        [self plusoneReportBadge];
    }
    else if ([[notification name] isEqualToString:@"UpdateQuestBadge"])
    {
        [self updateQuestBadge];
    }
    else if ([[notification name] isEqualToString:@"PlusQuestBadge"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *quest_done = [userInfo objectForKey:@"quest_done"];
        
        [self plusQuestBadge:quest_done];
    }
    else if ([[notification name] isEqualToString:@"UpdateAllianceBadge"])
    {
        [self updateAllianceBadge];
    }
    else if ([[notification name] isEqualToString:@"ShowSales"])
    {
        [self showSalesLoading];
    }
    else if ([[notification name] isEqualToString:@"EventSolo"])
    {
        [self showEventSolo];
    }
    else if ([[notification name] isEqualToString:@"EventAlliance"])
    {
        [self showEventAlliance];
    }
    else if ([[notification name] isEqualToString:@"InAppPurchase"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *pi = [userInfo objectForKey:@"pi"];
        
        [self buyProduct:pi];
    }
    else if ([[notification name] isEqualToString:@"ShowTemplateComplete"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *title = [userInfo objectForKey:@"title"];
        
        self.lblTitle.text = title;
        
        if (![title isEqualToString:@"MainView"])
        {
            [self hideBaseViewButtons];
            
            if (![title isEqualToString:@""])
            {
                [Globals.i trackEvent:@"Screen" action:title];
                [Globals.i trackScreenOpen:title];
            }
            
            if (![title isEqualToString:@"Map"])
            {
                self.btnBack.hidden = NO;
                self.lblTitle.hidden = NO;
                
                self.btnBookmark.hidden = YES;
                self.btnFullscreen.hidden = YES;
                self.btnHome.hidden = YES;
                self.btnSearch.hidden = YES;
            }
        }
    }
    else if ([[notification name] isEqualToString:@"CloseTemplateBefore"])
    {
        NSString *title = [UIManager.i currentViewTitle];
        
        if (![title isEqualToString:@""])
        {
            [Globals.i trackScreenClose:title];
        }
        
        if ([title isEqualToString:@"Map"])
        {
            [Globals.i playMusicBackground];
        }
    }
    else if ([[notification name] isEqualToString:@"CloseTemplateComplete"])
    {
        NSString *title = [UIManager.i currentViewTitle];
        self.lblTitle.text = title;
        
        if ([title isEqualToString:@"MainView"])
        {
            [self updateIndicator:1];
            [self showBaseViewButtons];
            
            [self.baseView addbackTimerHolder];
        }
        else if ([title isEqualToString:@"Map"])
        {
            self.btnBack.hidden = YES;
            self.lblTitle.hidden = YES;
            
            self.btnBookmark.hidden = NO;
            self.btnFullscreen.hidden = NO;
            self.btnHome.hidden = NO;
            self.btnSearch.hidden = NO;
        }
    }
    else if ([[notification name] isEqualToString:@"ChatWorld"])
    {
        self.lblChatWorld1.text = [Globals.i getFirstChatString];
        self.lblChatWorld2.text = [Globals.i getSecondChatString];
        
        void (^animationLabel) (void) = ^{
            self.lblChatWorld2.alpha = 0;
        };
        void (^completionLabel) (BOOL) = ^(BOOL f) {
            self.lblChatWorld2.alpha = 1;
        };
        
        NSUInteger opts =  UIViewAnimationOptionAutoreverse;
        
        [UIView animateWithDuration:0.5f delay:0 options:opts
                         animations:animationLabel completion:completionLabel];
    }
    else if ([[notification name] isEqualToString:@"ChatAlliance"])
    {
        self.lblChatAlliance1.text = [Globals.i getFirstAllianceChatString];
        self.lblChatAlliance2.text = [Globals.i getSecondAllianceChatString];
        
        //NSLog(@"first_row: %@", [Globals.i getFirstAllianceChatString]);
        //NSLog(@"second_row: %@", [Globals.i getSecondAllianceChatString]);
        
        void (^animationLabel) (void) = ^{
            self.lblChatAlliance2.alpha = 0;
        };
        void (^completionLabel) (BOOL) = ^(BOOL f) {
            self.lblChatAlliance2.alpha = 1;
        };
        
        NSUInteger opts =  UIViewAnimationOptionAutoreverse;
        
        [UIView animateWithDuration:0.5f delay:0 options:opts
                         animations:animationLabel completion:completionLabel];
    }
    else if ([[notification name] isEqualToString:@"TabWorld Chat"])
    {
        self.svChat.contentOffset = CGPointMake(0,0);
    }
    else if ([[notification name] isEqualToString:@"TabAlliance Chat"])
    {
        self.svChat.contentOffset = CGPointMake(UIScreen.mainScreen.bounds.size.width,0);
    }
    else if ([[notification name] isEqualToString:@"BaseUpdated"])
    {
        [self updateBaseButton];
    }
    else if ([[notification name] isEqualToString:@"UpdateHeroXP"])
    {
        [self updateHero];
    }
    else if ([[notification name] isEqualToString:@"ShowBuildUpgrade"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        
        if (b_id != nil)
        {
            NSString *b_name = [Globals.i getBuildingDict:b_id][@"building_name"];
            
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue] + 1;
            self.buildHeader.firstStep = NO;
            self.buildHeader.title = [NSString stringWithFormat:NSLocalizedString(@"Build %@", nil), b_name];
            [self.buildHeader updateView]; //This has to update first to get req b4 buildView
            
            if (self.buildView == nil)
            {
                self.buildView = [[BuildView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.buildView.building_id = b_id;
            self.buildView.level = [b_level integerValue] + 1;
            [self.buildView clearView];
            self.buildView.title = self.buildHeader.title;
            [self.buildView updateView];
            
            [UIManager.i showTemplate:@[self.buildView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowResourcesView"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.resourcesView == nil)
            {
                self.resourcesView = [[ResourcesView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.resourcesView.building_id = b_id;
            self.resourcesView.level = [b_level integerValue];
            self.resourcesView.title = self.buildHeader.title;
            [self.resourcesView updateView];
            
            [UIManager.i showTemplate:@[self.resourcesView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    //Building Information Level
    else if ([[notification name] isEqualToString:@"ShowBuildingChart"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        
        if (b_id != nil)
        {
            if (self.buildingChart == nil)
            {
                self.buildingChart = [[BuildingChart alloc] initWithStyle:UITableViewStylePlain];
            }
            self.buildingChart.building_id = b_id;
            self.buildingChart.level = [b_level integerValue];
            self.buildingChart.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildingChart updateView];
            
            [UIManager.i showTemplate:@[self.buildingChart] :self.buildingChart.title :3];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowCastle"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.castleView == nil)
            {
                self.castleView = [[CastleView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.castleView.level = [b_level integerValue];
            self.castleView.title = self.buildHeader.title;
            [self.castleView updateView];
            
            [UIManager.i showTemplate:@[self.castleView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowWall"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.wallView == nil)
            {
                self.wallView = [[WallView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.wallView.level = [b_level integerValue];
            self.wallView.title = self.buildHeader.title;
            [self.wallView updateView];
            
            [UIManager.i showTemplate:@[self.wallView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowTrain"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.trainView == nil)
            {
                self.trainView = [[TrainView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.trainView.level = [b_level integerValue];
            self.trainView.location = [b_location integerValue];
            self.trainView.unit_type = @"a";
            self.trainView.title = self.buildHeader.title;
            [self.trainView updateView];
            
            [UIManager.i showTemplate:@[self.trainView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
            
        }
    }
    else if ([[notification name] isEqualToString:@"ShowHospital"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.hospitalView == nil)
            {
                self.hospitalView = [[HospitalView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.hospitalView.level = [b_level integerValue];
            self.hospitalView.location = [b_location integerValue];
            self.hospitalView.title = self.buildHeader.title;
            [self.hospitalView updateView];
            
            [UIManager.i showTemplate:@[self.hospitalView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowStorehouse"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.storehouseView == nil)
            {
                self.storehouseView = [[StorehouseView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.storehouseView.level = [b_level integerValue];
            self.storehouseView.title = self.buildHeader.title;
            [self.storehouseView updateView];
            
            [UIManager.i showTemplate:@[self.storehouseView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowMarket"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        BOOL hasBuild = NO;
        
        if (b_id == nil)
        {
            //Find any market in build list
            for (NSDictionary *dict in Globals.i.wsBuildArray)
            {
                if ([dict[@"building_id"] integerValue] == 12)
                {
                    hasBuild = YES;
                    
                    b_id = dict[@"building_id"];
                    b_level = dict[@"building_level"];
                    b_location = dict[@"location"];
                    
                    //Check if this building is under construction
                    if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:b_location] && (Globals.i.buildQueue1 > 1))
                    {
                        NSInteger blvl = [b_level integerValue];
                        blvl = blvl-1;
                        b_level = [@(blvl) stringValue];
                        upgrading = @"1";
                    }
                }
            }
        }
        else
        {
            hasBuild = YES;
        }
        
        if (hasBuild)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.marketView == nil)
            {
                self.marketView = [[MarketView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.marketView.level = [b_level integerValue];
            self.marketView.title = self.buildHeader.title;
            [self.marketView updateView];
            
            [UIManager.i showTemplate:@[self.marketView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
        else
        {
            [UIManager.i showDialog:NSLocalizedString(@"You will need to build a Market first to Resource Help.", nil) title:@"MarketNeededToSendResource"];
        }
        
    }
    else if ([[notification name] isEqualToString:@"ShowEmbassy"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.embassyView == nil)
            {
                self.embassyView = [[EmbassyView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.embassyView.level = [b_level integerValue];
            self.embassyView.title = self.buildHeader.title;
            [self.embassyView updateView];
            
            [UIManager.i showTemplate:@[self.embassyView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowWatchtower"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.watchtowerView == nil)
            {
                self.watchtowerView = [[WatchtowerView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.watchtowerView.level = [b_level integerValue];
            self.watchtowerView.title = self.buildHeader.title;
            [self.watchtowerView updateView];
            
            [UIManager.i showTemplate:@[self.watchtowerView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowArchery"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.trainView == nil)
            {
                self.trainView = [[TrainView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.trainView.level = [b_level integerValue];
            self.trainView.location = [b_location integerValue];
            self.trainView.unit_type = @"b";
            self.trainView.title = self.buildHeader.title;
            [self.trainView updateView];
            
            [UIManager.i showTemplate:@[self.trainView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowStable"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.trainView == nil)
            {
                self.trainView = [[TrainView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.trainView.level = [b_level integerValue];
            self.trainView.location = [b_location integerValue];
            self.trainView.unit_type = @"c";
            self.trainView.title = self.buildHeader.title;
            [self.trainView updateView];
            
            [UIManager.i showTemplate:@[self.trainView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowWorkshop"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.trainView == nil)
            {
                self.trainView = [[TrainView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.trainView.level = [b_level integerValue];
            self.trainView.location = [b_location integerValue];
            self.trainView.unit_type = @"d";
            self.trainView.title = self.buildHeader.title;
            [self.trainView updateView];
            
            [UIManager.i showTemplate:@[self.trainView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowTavern"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        if (b_id != nil)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.tavernView == nil)
            {
                self.tavernView = [[TavernView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.tavernView.level = [b_level integerValue];
            self.tavernView.title = self.buildHeader.title;
            [self.tavernView updateView];
            
            [UIManager.i showTemplate:@[self.tavernView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowMap"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            NSString *map_x = [userInfo objectForKey:@"to_x"];
            NSString *map_y = [userInfo objectForKey:@"to_y"];
            
            [self showMap:[map_x integerValue] map_y:[map_y integerValue]];
        }
        else
        {
            [self showMap];
        }
        
        [self updateIndicator:2];
    }
    else if ([[notification name] isEqualToString:@"ShowResearch"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        BOOL hasBuild = NO;
        
        if (b_id == nil)
        {
            //Find any Library in build list
            for (NSDictionary *dict in Globals.i.wsBuildArray)
            {
                if ([dict[@"building_id"] integerValue] == 15)
                {
                    hasBuild = YES;
                    
                    b_id = dict[@"building_id"];
                    b_level = dict[@"building_level"];
                    b_location = dict[@"location"];
                    
                    //Check if this building is under construction
                    if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:b_location] && (Globals.i.buildQueue1 > 1))
                    {
                        NSInteger blvl = [b_level integerValue];
                        blvl = blvl-1;
                        b_level = [@(blvl) stringValue];
                        upgrading = @"1";
                    }
                }
            }
        }
        else
        {
            hasBuild = YES;
        }
        
        if (hasBuild)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.researchView == nil)
            {
                self.researchView = [[ResearchView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.researchView.level = [b_level integerValue];
            self.researchView.title = self.buildHeader.title;
            [self.researchView updateView];
            
            [UIManager.i showTemplate:@[self.researchView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
        else
        {
            [UIManager.i showDialog:NSLocalizedString(@"You need to build a Library first to do Research.", nil) title:@"LibraryNeededToStartResearch"];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowCraft"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *b_id = [userInfo objectForKey:@"building_id"];
        NSString *b_level = [userInfo objectForKey:@"building_level"];
        NSString *b_location = [userInfo objectForKey:@"building_location"];
        NSString *upgrading = [userInfo objectForKey:@"upgrading"];
        
        BOOL hasBuild = NO;
        
        if (b_id == nil)
        {
            //Find any blacksmith in build list
            for (NSDictionary *dict in Globals.i.wsBuildArray)
            {
                if ([dict[@"building_id"] integerValue] == 13)
                {
                    hasBuild = YES;
                    
                    b_id = dict[@"building_id"];
                    b_level = dict[@"building_level"];
                    b_location = dict[@"location"];
                    
                    //Check if this building is under construction
                    if([Globals.i.wsBaseDict[@"build_location"] isEqualToString:b_location] && (Globals.i.buildQueue1 > 1))
                    {
                        NSInteger blvl = [b_level integerValue];
                        blvl = blvl-1;
                        b_level = [@(blvl) stringValue];
                        upgrading = @"1";
                    }
                }
            }
        }
        else
        {
            hasBuild = YES;
        }
        
        if (hasBuild)
        {
            self.buildHeader = [[BuildHeader alloc] init];
            self.buildHeader.building_id = b_id;
            self.buildHeader.is_upgrading = upgrading;
            self.buildHeader.location = [b_location integerValue];
            self.buildHeader.level = [b_level integerValue];
            self.buildHeader.firstStep = YES;
            self.buildHeader.title = [Globals.i getBuildingDict:b_id][@"building_name"];
            [self.buildHeader updateView];
            
            if (self.craftView == nil)
            {
                self.craftView = [[CraftView alloc] initWithStyle:UITableViewStylePlain];
            }
            self.craftView.level = [b_level integerValue];
            self.craftView.title = self.buildHeader.title;
            [self.craftView updateView];
            
            [UIManager.i showTemplate:@[self.craftView] :self.buildHeader.title :4 :0 :@[self.buildHeader]];
        }
        else
        {
            [UIManager.i showDialog:NSLocalizedString(@"You need to build a Blacksmith first to begin Crafting.", nil) title:@"BlacksmithNeededToBeginCrafting"];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowItems"])
    {
        [self showItems:notification.userInfo];
    }
    else if ([[notification name] isEqualToString:@"PreloadItems"])
    {
        [self preloadItems];
    }
    else if ([[notification name] isEqualToString:@"UpdateHeroType"])
    {
        [self updateHero];
    }
    else if ([[notification name] isEqualToString:@"SendTroops"])
    {
        if (self.sendHeader == nil)
        {
            self.sendHeader = [[SendHeader alloc] initWithStyle:UITableViewStylePlain];
        }
        self.sendHeader.userInfo = notification.userInfo;
        self.sendHeader.title = [notification.userInfo objectForKey:@"action"];
        [self.sendHeader updateView];
        
        if (self.sendTroops == nil)
        {
            self.sendTroops = [[SendTroops alloc] initWithStyle:UITableViewStylePlain];
        }
        self.sendTroops.userInfo = notification.userInfo;
        self.sendTroops.title = [notification.userInfo objectForKey:@"action"];
        [self.sendTroops updateView];
        [UIManager.i showTemplate:@[self.sendTroops] :self.sendHeader.title :4 :0 :@[self.sendHeader]];
    }
    else if ([[notification name] isEqualToString:@"SendResources"])
    {
        NSInteger market_level = 0;
        for (NSDictionary *dict in Globals.i.wsBuildArray)
        {
            if ([dict[@"building_id"] isEqualToString:@"12"])
            {
                market_level = [dict[@"building_level"] integerValue];
            }
        }
        
        if (market_level > 0)
        {
            if (self.marketSend == nil)
            {
                self.marketSend = [[MarketSend alloc] initWithStyle:UITableViewStylePlain];
            }
            self.marketSend.level = market_level;
            
            NSDictionary *row1 = [notification.userInfo objectForKey:@"base_dict"];
            
            NSString *r1 = row1[@"profile_name"];
            if ([row1[@"alliance_tag"] length] > 2)
            {
                r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
            }
            
            NSString *r2 = [NSString stringWithFormat:NSLocalizedString(@"City (%@,%@)", nil), row1[@"b_x"], row1[@"b_y"]];
            NSDictionary *rtarget = @{@"p_id": row1[@"profile_id"], @"b_id": row1[@"b_id"], @"b_x": row1[@"b_x"], @"b_y": row1[@"b_y"], @"r1": r1, @"r2": r2, @"i1": [NSString stringWithFormat:@"face_%@", row1[@"profile_face"]], @"i1_aspect": @"1", @"r1_icon": [NSString stringWithFormat:@"rank_%@", row1[@"alliance_rank"]]};
            
            self.marketSend.row_target = [rtarget mutableCopy];
            self.marketSend.base_r1 = Globals.i.base_r1;
            self.marketSend.base_r2 = Globals.i.base_r2;
            self.marketSend.base_r3 = Globals.i.base_r3;
            self.marketSend.base_r4 = Globals.i.base_r4;
            self.marketSend.base_r5 = Globals.i.base_r5;
            self.marketSend.title = NSLocalizedString(@"Send Resources", nil);
            
            self.marketSend.exit_to_map = @"1";
            
            [UIManager.i showTemplate:@[self.marketSend] :self.marketSend.title];
            [self.marketSend updateView];
        }
        else
        {
            [UIManager.i showDialog:NSLocalizedString(@"You will need to build a Market in your city to be able to send Resources.", nil) title:@"MarketNeededToSendResources"];
        }
        
    }
    else if ([[notification name] isEqualToString:@"ShowAllianceCreate"])
    {
        NSString *title = NSLocalizedString(@"New Alliance", nil);
        
        if (self.allianceCreate == nil)
        {
            self.allianceCreate = [[AllianceCreate alloc] initWithStyle:UITableViewStylePlain];
        }
        self.allianceCreate.title = title;
        [self.allianceCreate updateView];
        
        [UIManager.i showTemplate:@[self.allianceCreate] :title];
    }
    else if ([[notification name] isEqualToString:@"ShowAllianceMembers"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (self.allianceMembers == nil)
        {
            self.allianceMembers = [[AllianceMembers alloc] initWithStyle:UITableViewStylePlain];
        }
        
        if ([userInfo objectForKey:@"alliance_object"] != nil)
        {
            self.allianceMembers.aAlliance = [userInfo objectForKey:@"alliance_object"];
            self.allianceMembers.button_title = [userInfo objectForKey:@"button_title"];
            self.allianceMembers.title = [userInfo objectForKey:@"button_title"];
            [self.allianceMembers updateView];
            [UIManager.i showTemplate:@[self.allianceMembers] :self.allianceMembers.title];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowAllianceApplicants"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (self.allianceApplicants == nil)
        {
            self.allianceApplicants = [[AllianceApplicants alloc] initWithStyle:UITableViewStylePlain];
        }
        
        if ([userInfo objectForKey:@"alliance_object"] != nil)
        {
            self.allianceApplicants.aAlliance = [userInfo objectForKey:@"alliance_object"];
            self.allianceApplicants.title = NSLocalizedString(@"Applicants", nil);
            [self.allianceApplicants updateView];
            [UIManager.i showTemplate:@[self.allianceApplicants] :self.allianceApplicants.title];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowAllianceEvents"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (self.allianceEvents == nil)
        {
            self.allianceEvents = [[AllianceEvents alloc] initWithStyle:UITableViewStylePlain];
        }
        
        if ([userInfo objectForKey:@"alliance_object"] != nil)
        {
            self.allianceEvents.aAlliance = [userInfo objectForKey:@"alliance_object"];
            self.allianceEvents.title = NSLocalizedString(@"Events", nil);
            [self.allianceEvents updateView];
            [UIManager.i showTemplate:@[self.allianceEvents] :self.allianceEvents.title];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowAllianceWall"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *alliance_id = @"0";
        if ([userInfo objectForKey:@"alliance_object"] != nil)
        {
            AllianceObject *aAlliance = [userInfo objectForKey:@"alliance_object"];
            alliance_id = aAlliance.alliance_id;
        }
        
        NSString *service_name = @"GetAllianceWall";
        NSString *wsurl = [NSString stringWithFormat:@"/%@",
                           alliance_id];
        
        [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 if (self.allianceWall == nil)
                 {
                     self.allianceWall = [[ChatView alloc] init];
                 }
                 self.allianceWall.title = @"Comments";
                 
                 [UIManager.i showTemplate:@[self.allianceWall] :NSLocalizedString(@"Comments", nil)];
                 [self.allianceWall updateView:returnArray table:@"alliance_wall" a_id:alliance_id];
             }
         }];
    }
    else if ([[notification name] isEqualToString:@"ShowReportDialog"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (self.reportDetail == nil)
        {
            self.reportDetail = [[ReportDetail alloc] initWithStyle:UITableViewStylePlain];
        }
        
        self.reportDetail.rowData = [userInfo objectForKey:@"report_header"];
        self.reportDetail.reportData = [userInfo objectForKey:@"report_data"];
        self.reportDetail.title = [userInfo objectForKey:@"report_title"];
        self.reportDetail.is_popup = @"1";
        [self.reportDetail updateView];
        
        [UIManager.i showTemplate:@[self.reportDetail] :self.reportDetail.title :3];
    }
    else if ([[notification name] isEqualToString:@"EmptyHeader"])
    {
        self.btnBack.hidden = YES;
        self.lblTitle.hidden = YES;
    }
    else if ([[notification name] isEqualToString:@"UpdateAdvisor"])
    {
        [self updateAdvisor];
    }
    else if ([[notification name] isEqualToString:@"ShowAdvisor"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *advisor_speech = [userInfo objectForKey:@"advisor_speech"];
        NSInteger advisor_action = [[userInfo objectForKey:@"advisor_action"] integerValue];
        NSLog(@"ShowAdvisor notification received");
        
        [self showAdvisor:advisor_speech :advisor_action];
    }
    else if ([[notification name] isEqualToString:@"ClickShowQuestButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            [self quest_tap:notification];
        }
    }
    else if ([[notification name] isEqualToString:@"ClickShowMapButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            [self map_tap:notification];
        }
    }
    else if ([[notification name] isEqualToString:@"ClickShowAllianceButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            [self alliance_tap:notification];
        }
    }
    else if ([[notification name] isEqualToString:@"ClickShowMoreButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            [self more_tap:notification];
        }
    }
    else if ([[notification name] isEqualToString:@"ClickShowReportButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            //dont know why reports are called extra
            [self extra_tap:notification];
        }
    }
    else if ([[notification name] isEqualToString:@"ClickShowMailButtonThenReportTab"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            [self mail_tap:notification];
            [self showReport];
        }
    }

    else if ([[notification name] isEqualToString:@"ClickShowCityButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            //same button as show map
            [self map_tap:notification];
        }
    }
    else if ([[notification name] isEqualToString:@"ClickShowBaseListButton"])
    {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo != nil)
        {
            [self baselist_tap:notification];
        }
    }
    else if ([[notification name] isEqualToString:@"ShowBattle"])
    {
        /*
        NSString *title = NSLocalizedString(@"Battle", nil);
        
        self.battleView = [[BattleSceneViewController alloc] init];
        self.battleView.title = title;
        [self.battleView initBattleScene];
        
        [UIManager.i showTemplate:@[self.battleView] :title];
        */
    }
}

- (void)updateView //Called after login and when applicationDidBecomeActive
{
    if ([Globals.i.launchFirstTime isEqualToString:@"1"])
    {
        if ([Globals.i.always_download_graphicpack isEqualToString:@"1"])
        {
            if ([Globals.i.setupInProgress isEqualToString:@"0"])
            {
                [self downloadGraphicPack]; //will call setUp once done
            }
        }
        else
        {
            [self setUp];
        }
    }
    else
    {
        [Globals.i playMusicLoading];
        
        //Show sponsor screen for 5 seconds
        //[self showSponsors];
        //[self performSelector:@selector(removeSponsors) withObject:self afterDelay:5.0];
        
        [self gotoLogin:YES]; //Comment this line if showing sponsor above
    }
}
/*
- (void)showSponsors
{
    if (self.sponsorsView == nil)
    {
        self.sponsorsView = [[SponsorsView alloc] init];
        self.sponsorsView.title = @"Sponsors";
    }

    [[UIManager.i peekViewControllerStack].view addSubview:self.sponsorsView.view];
}

- (void)removeSponsors
{
    if (self.sponsorsView != nil)
    {
        [self.sponsorsView.view removeFromSuperview];
    }
    
    [self gotoLogin:YES];
}
*/
- (void)gotoLogin:(BOOL)autoLogin //Open the Login View
{
    if (!autoLogin)
    {
        [Globals.i setUID:@""];
    }
    
    if (!self.isShowingLogin)
    {
        self.isShowingLogin = YES;
        
        [self showLogin:^(NSInteger status)
         {
             if (status == 1) //Login Success
             {
                 self.isShowingLogin = NO;
                 
                 //This will close the LoginView(autheticating)
                 [UIManager.i closeAllTemplate];
                 
                 //Game have NOT been full loaded before
                 if (Globals.i.wsProfileDict == nil)
                 {
                     [self loadAllData];
                 }
                 else
                 {
                     //TODO: Optimize and Load only important stuff
                     [self loadAllData];
                 }
             }
             
         }];
    }
}

- (void)loadAllData
{
    [self showLoading];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    [userInfo setObject:NSLocalizedString(@"Sharpening swords", nil) forKey:@"status"];
    [userInfo setObject:[NSNumber numberWithFloat:0.1f] forKey:@"percent"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                        object:self
                                                      userInfo:userInfo];
    
    [Globals.i getServerProfileData:^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
             if (success)
             {
                 [userInfo setObject:NSLocalizedString(@"Rounding up the horses", nil) forKey:@"status"];
                 [userInfo setObject:[NSNumber numberWithFloat:0.2f] forKey:@"percent"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                     object:self
                                                                   userInfo:userInfo];
                 
                 //Save this for next time open app
                 NSString *download_graphicpack = Globals.i.wsProfileDict[@"always_download_graphicpack"];
                 if ([download_graphicpack isEqualToString:@"1"])
                 {
                     [Globals.i download_graphicpack_on];
                     
                     NSString *gid = Globals.i.wsWorldProfileDict[@"graphic_pack_id"];
                     [Globals.i set_graphic_pack_id:gid];
                 }
                 else
                 {
                     [Globals.i download_graphicpack_off];
                 }
                 
                 
                 //Updates product identifiers and display dialog if need to upgrade app
                 if (Globals.i.wsIdentifierDict != nil)
                 {
                     if (Globals.i.wsIdentifierDict.count == 0)
                     {
                         [Globals.i updateProductIdentifiers];
                     }
                 }
                 else
                 {
                     [Globals.i updateProductIdentifiers];
                 }
                 
                 [userInfo setObject:NSLocalizedString(@"Preparing the feast", nil) forKey:@"status"];
                 [userInfo setObject:[NSNumber numberWithFloat:0.3f] forKey:@"percent"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                     object:self
                                                                   userInfo:userInfo];
                 
                 
                 if (Globals.i.wsSettingsDict != nil)
                 {
                     if (Globals.i.wsSettingsDict.count == 0)
                     {
                         [Globals.i updateSettings];
                     }
                 }
                 else
                 {
                     [Globals.i updateSettings];
                 }
                 
                 [userInfo setObject:NSLocalizedString(@"Waking the troops", nil) forKey:@"status"];
                 [userInfo setObject:[NSNumber numberWithFloat:0.5f] forKey:@"percent"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                     object:self
                                                                   userInfo:userInfo];
                 
                 if (Globals.i.wsBuildingLevelArray != nil)
                 {
                     if (Globals.i.wsBuildingLevelArray.count == 0)
                     {
                         [Globals.i updateBuildingLevel];
                     }
                 }
                 else
                 {
                     [Globals.i updateBuildingLevel];
                 }
                 
                 [userInfo setObject:NSLocalizedString(@"Visiting the docks", nil) forKey:@"status"];
                 [userInfo setObject:[NSNumber numberWithFloat:0.6f] forKey:@"percent"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                     object:self
                                                                   userInfo:userInfo];
                 
                 [Globals.i updateBaseDict:^(BOOL success, NSData *data)
                  {
                      [userInfo setObject:NSLocalizedString(@"Paying taxes", nil) forKey:@"status"];
                      [userInfo setObject:[NSNumber numberWithFloat:0.7f] forKey:@"percent"];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                          object:self
                                                                        userInfo:userInfo];
                      
                      //Show and Update city view first before can show any other views
                      [self loadBaseView];
                      
                      [userInfo setObject:NSLocalizedString(@"Counting diamonds", nil) forKey:@"status"];
                      [userInfo setObject:[NSNumber numberWithFloat:0.8f] forKey:@"percent"];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                          object:self
                                                                        userInfo:userInfo];
                      
                      
                      
                      [Globals.i updateMail];
                      
                      [userInfo setObject:NSLocalizedString(@"Consulting the imp", nil) forKey:@"status"];
                      [userInfo setObject:[NSNumber numberWithFloat:0.9f] forKey:@"percent"];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                          object:self
                                                                        userInfo:userInfo];
                      
                      [Globals.i updateReports:^(BOOL success, NSData *data){}];
                      
                      [userInfo setObject:NSLocalizedString(@"Sounding the battle drums", nil) forKey:@"status"];
                      [userInfo setObject:[NSNumber numberWithFloat:1.0f] forKey:@"percent"];
                      [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadingStatus"
                                                                          object:self
                                                                        userInfo:userInfo];
                      
                      //Will also call LoginWorld once hub is established
                      [Globals.i setupSignalR]; //Realtime notifications from our server (logins to hub)
                      
                      [self removeLoading];
                      
                      //TODO: Turn on tutorial and sales offer
                      /*
                      if ([Globals.i is_tutorial_on])
                      {
                          [Globals.i invokeTutorial];
                      }
                      else
                      {
                          [self showSalesLoading];
                      }
                      */
                      
                      [Globals.i playMusicBackground];
                      
                      [Globals.i checkVersion];
                  }];
                 
             }
             else //When faill to retrieve profile from main server
             {
                 [self removeLoading];
                 
                 [Globals.i changeUserLogout];
                 
                 BOOL password_login = [[NSUserDefaults standardUserDefaults] boolForKey:@"password_login"];
                 
                 if (password_login)
                 {
                     [Globals.i showDialogFailedLoginEmail];
                 }
                 else //Game Center requires a restart in order to authenticate again
                 {
                     [Globals.i showDialogFailedLoginGamecenter];
                 }
             }
         });
     }];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    NSLog(@"SCROLL");
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.svChat.frame.size.width;
    NSInteger page = floor((self.svChat.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    self.pcChat.currentPage = page;
	
    [self loadScrollViewWithPage:page];
}

- (void)loadScrollViewWithPage:(NSInteger)page
{
    float icon_size = 30.0f*SCALE_IPAD;
    float chat_font_size = SMALL_FONT_SIZE;
    float page_control_height = 5.0f*SCALE_IPAD;
    
    if (self.ivChatWorldIcon == nil)
    {
        self.ivChatWorldIcon = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"icon_chat_world"]];
        [self.ivChatWorldIcon setFrame:CGRectMake(0, page_control_height, icon_size, icon_size)];
        [self.svChat addSubview:self.ivChatWorldIcon];
    }
    
    if (self.lblChatWorld1 == nil)
    {
        self.lblChatWorld1 = [[UILabel alloc] init];
        self.lblChatWorld1.frame = CGRectMake(icon_size, page_control_height, UIScreen.mainScreen.bounds.size.width-icon_size, icon_size/2);
        self.lblChatWorld1.font = [UIFont fontWithName:DEFAULT_FONT size:chat_font_size];
        self.lblChatWorld1.backgroundColor = [UIColor clearColor];
        self.lblChatWorld1.textColor = [UIColor whiteColor];
        self.lblChatWorld1.textAlignment = NSTextAlignmentLeft;
        self.lblChatWorld1.numberOfLines = 1;
        self.lblChatWorld1.minimumScaleFactor = 1.0f;
        [self.svChat addSubview:self.lblChatWorld1];
    }
    
    if (self.lblChatWorld2 == nil)
    {
        self.lblChatWorld2 = [[UILabel alloc] init];
        self.lblChatWorld2.frame = CGRectMake(icon_size, page_control_height+(icon_size/2), UIScreen.mainScreen.bounds.size.width-icon_size, icon_size/2);
        self.lblChatWorld2.font = [UIFont fontWithName:DEFAULT_FONT size:chat_font_size];
        self.lblChatWorld2.backgroundColor = [UIColor clearColor];
        self.lblChatWorld2.textColor = [UIColor whiteColor];
        self.lblChatWorld2.textAlignment = NSTextAlignmentLeft;
        self.lblChatWorld2.numberOfLines = 1;
        self.lblChatWorld2.minimumScaleFactor = 1.0f;
        [self.svChat addSubview:self.lblChatWorld2];
    }
    
    if (self.ivChatAllianceIcon == nil)
    {
        self.ivChatAllianceIcon = [[UIImageView alloc] initWithImage:[Globals.i imageNamedCustom:@"icon_chat_alliance"]];
        [self.ivChatAllianceIcon setFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width, page_control_height, icon_size, icon_size)];
        [self.svChat addSubview:self.ivChatAllianceIcon];
    }
    
    if (self.lblChatAlliance1 == nil)
    {
        self.lblChatAlliance1 = [[UILabel alloc] init];
        self.lblChatAlliance1.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width+icon_size, page_control_height, UIScreen.mainScreen.bounds.size.width-icon_size, icon_size/2);
        self.lblChatAlliance1.font = [UIFont fontWithName:DEFAULT_FONT size:chat_font_size];
        self.lblChatAlliance1.backgroundColor = [UIColor clearColor];
        self.lblChatAlliance1.textColor = [UIColor whiteColor];
        self.lblChatAlliance1.textAlignment = NSTextAlignmentLeft;
        self.lblChatAlliance1.numberOfLines = 1;
        self.lblChatAlliance1.minimumScaleFactor = 1.0f;
        [self.svChat addSubview:self.lblChatAlliance1];
    }
    
    if (self.lblChatAlliance2 == nil)
    {
        self.lblChatAlliance2 = [[UILabel alloc] init];
        self.lblChatAlliance2.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width+icon_size, page_control_height+(icon_size/2), UIScreen.mainScreen.bounds.size.width-icon_size, icon_size/2);
        self.lblChatAlliance2.font = [UIFont fontWithName:DEFAULT_FONT size:chat_font_size];
        self.lblChatAlliance2.backgroundColor = [UIColor clearColor];
        self.lblChatAlliance2.textColor = [UIColor whiteColor];
        self.lblChatAlliance2.textAlignment = NSTextAlignmentLeft;
        self.lblChatAlliance2.numberOfLines = 1;
        self.lblChatAlliance2.minimumScaleFactor = 1.0f;
        [self.svChat addSubview:self.lblChatAlliance2];
    }
    
    if (page == 0)
    {
        self.chatState = 1;
    }
    else if (page == 1)
    {
        self.chatState = 2;
        
        if ([Globals.i.wsWorldProfileDict[@"alliance_id"] isEqualToString:@"0"]) //Not in an alliance
        {
            self.lblChatAlliance1.text = NSLocalizedString(@"Join an Alliance to chat here", nil);
        }
    }
}

- (void)updateAdvisor
{
    if (![Globals.i is_tutorial_on] && ([Globals.i.quest_reminder isEqualToString:@"1"]))
    {
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        [userInfo setObject:[self getAnUncompletedQuestName]forKey:@"advisor_speech"];
        [userInfo setObject:[NSNumber numberWithInteger:1] forKey:@"advisor_action"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAdvisor"
                                                            object:self
                                                          userInfo:userInfo];
    }
    else
    {
        [self hideAdvisor];
    }
}

- (NSString *)getAnUncompletedQuestName
{
    for (NSDictionary *quest in Globals.i.wsQuestArray)
    {
        NSLog(@"Quest Name :%@", quest[@"name"]);
        NSLog(@"Quest Claim :%@", quest[@"claimed"]);
        NSLog(@"Quest ProfileId :%@", quest[@"profile_id"]);
        
        if ([quest[@"claimed"] isEqualToString:@"0"])
        {
            return quest[@"name"];
            //Currently advisor advises to do a quest until it is claimed
            /*
            if ([quest[@"profile_id"] isEqualToString:@"0"])
            {
                return quest[@"name"];
            }
            */
        }
    }
    
    return @"";
}

- (void)showAdvisor:(NSString *)l1 :(NSInteger)actionType
{
    [self hideAdvisor];
    
    if (![l1 isEqualToString:@""])
    {
        UIView *advisor_view  = [[UIView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        //int advisor_parent_width = CGRectGetWidth(self.view.bounds);
        //int advisor_parent_height = CGRectGetHeight(self.view.bounds);
        int advisor_view_width_size = UIScreen.mainScreen.bounds.size.width;
        int advisor_view_height_size = advisor_view_width_size*0.2;
        int advisor_x = 0;
        int advisor_y = UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_BOTTOM - advisor_view_height_size;
        advisor_view.frame = CGRectMake(advisor_x, advisor_y, advisor_view_width_size, advisor_view_height_size);

        int advisor_view_width = CGRectGetWidth(advisor_view.bounds);
        int advisor_view_height = CGRectGetHeight(advisor_view.bounds);
        
        advisor_view.tag = (int)actionType;
        
        advisor_view.userInteractionEnabled = NO;
        
        UIImage *advisor_avatar_image = [[Globals.i imageNamedCustom:@"quest_avatar"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)resizingMode:(UIImageResizingModeStretch)];
        
        UIImageView *advisor_avatar_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        int advisor_avatar_view_width = advisor_view_height;
        int advisor_avatar_view_height = advisor_view_height;
        advisor_avatar_view.frame = CGRectMake(0, 0, advisor_avatar_view_width, advisor_avatar_view_height);
        advisor_avatar_view.image = advisor_avatar_image;
        [advisor_view addSubview:advisor_avatar_view];
        
        //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advisorTapped:)];
        //[advisor_avatar_view addGestureRecognizer:tap];
        
        UIImage *speech_bubble_image = [[Globals.i imageNamedCustom:@"speech_bubble"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 0)resizingMode:(UIImageResizingModeStretch)];
        UIImageView *speech_bubble_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        int speech_bubble_view_width = advisor_view_width*0.85;
        int speech_bubble_view_height = advisor_view_height*0.5;
        speech_bubble_view.frame = CGRectMake(advisor_view_width-speech_bubble_view_width, (advisor_view_height/2)-(speech_bubble_view_height/2),speech_bubble_view_width,speech_bubble_view_height);
        speech_bubble_view.image = speech_bubble_image;
        [advisor_view addSubview:speech_bubble_view];
        
        UIImage *question_mark_image = [[Globals.i imageNamedCustom:@"question_mark"]resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)resizingMode:(UIImageResizingModeStretch)];
        
        UIImageView *question_mark_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,0,0)];
        int question_mark_view_width = speech_bubble_view_height*0.5;
        int question_mark_view_height = question_mark_view_width;
        question_mark_view.frame = CGRectMake(speech_bubble_view_width-(question_mark_view_width*1.5), (speech_bubble_view_height/2)-(question_mark_view_height/2), question_mark_view_width, question_mark_view_height);
        question_mark_view.image = question_mark_image;
        [speech_bubble_view addSubview:question_mark_view];

        
        NSString *text =[NSString stringWithFormat:@"%@%@", l1, NSLocalizedString(@". Dont forget to reap the benefits once you have done this", nil)];
        //int dialog_label_width = speech_bubble_view_width*0.7;
        int dialog_label_height = speech_bubble_view_height*0.8;
        UILabel *dialog_label = [[UILabel alloc]initWithFrame:CGRectMake(0,0,0,0)];
        dialog_label.frame = CGRectMake(speech_bubble_view_width*0.2, speech_bubble_view_height*0.1, speech_bubble_view_width*0.8-(question_mark_view_width*2) , dialog_label_height);
        dialog_label.text = text;
        dialog_label.baselineAdjustment = UIBaselineAdjustmentAlignBaselines; // or UIBaselineAdjustmentAlignCenters, or UIBaselineAdjustmentNone
        dialog_label.numberOfLines = 1;
        if(dialog_label.text.length>20)
        {
            dialog_label.numberOfLines=1+dialog_label.text.length/20;
        }
        dialog_label.adjustsFontSizeToFitWidth = YES;
        dialog_label.clipsToBounds = YES;
        dialog_label.textColor = [UIColor whiteColor];
        dialog_label.textAlignment = NSTextAlignmentLeft;
        [speech_bubble_view addSubview:dialog_label];
        
        self.advisorView = advisor_view;
        [self.view addSubview:self.advisorView];
    }
}

- (void)hideAdvisor
{
    [self.advisorView removeFromSuperview];
}

//The event handling method
- (void)advisorTapped:(UITapGestureRecognizer *)recognizer
{
    UIView *advisorView = (UIView *)recognizer.view;
    
    NSLog(@"advisorTapped clicked : %ld",(long)advisorView.tag);
    
    NSLog(@"QuestArray : %@",Globals.i.wsQuestArray[0][@"name"]);
    
    switch (advisorView.tag)
    {
        case 1:
            [self showQuest];
            break;
            
        default:
            break;
    }
    
    //[self hideAdvisor];
    [self getAnUncompletedQuestName];
}

- (void)showChat:(BOOL)goto_alliance_tab
{
	if (self.chatView == nil)
    {
        self.chatView = [[ChatView alloc] init];
    }
    self.chatView.title = @"World Chat";
    
    if ([Globals.i.wsWorldProfileDict[@"alliance_id"] isEqualToString:@"0"])
    {
        [UIManager.i showTemplate:@[self.chatView] :NSLocalizedString(@"World Chat", nil) :1];
        [self.chatView updateView:Globals.i.wsChatFullArray table:@"chat" a_id:@"0"];
    }
    else
    {
        if (self.allianceChatView == nil)
        {
            self.allianceChatView = [[ChatView alloc] init];
        }
        self.allianceChatView.title = @"Alliance Chat";
        
        if (goto_alliance_tab)
        {
            [UIManager.i showTemplate:@[self.chatView, self.allianceChatView] :NSLocalizedString(@"Chat", nil) :1 :1];
        }
        else
        {
            [UIManager.i showTemplate:@[self.chatView, self.allianceChatView] :NSLocalizedString(@"Chat", nil) :1 :0];
        }
        
        [self.chatView updateView:Globals.i.wsChatFullArray table:@"chat" a_id:@"0"];
        
        [self.allianceChatView updateView:Globals.i.wsAllianceChatFullArray table:@"alliance_chat" a_id:Globals.i.wsWorldProfileDict[@"alliance_id"]];
    }
}

- (void)updateHeader
{
    self.lblCurrency.text = [Globals.i autoNumber:Globals.i.wsWorldProfileDict[@"currency_second"]];
    
    self.lblPowerName.text = NSLocalizedString(@"Power", nil);
    self.lblPowerPoints.text = [Globals.i autoNumber:Globals.i.wsWorldProfileDict[@"xp"]];
    
    [self updateHero];
    
    [self updateBaseButton];
}

- (void)updateBaseButton
{
    self.lblBaseName.text = Globals.i.wsBaseDict[@"base_name"];
    self.lblBaseLocation.text = [NSString stringWithFormat:@"(%@,%@)", Globals.i.wsBaseDict[@"map_x"], Globals.i.wsBaseDict[@"map_y"]];
}

- (void)updateHero
{
    self.pvHeroXp.bar1 = [Globals.i getXpProgressBar];
    [self.pvHeroXp updateView];
    
    self.lblHero.text = [Globals.i intString:[Globals.i getLevel]];
    
    UIImage *imgHero = [Globals.i imageNamedCustom:[NSString stringWithFormat:@"hero_face%@", Globals.i.wsWorldProfileDict[@"hero_type"]]];
    UIImage *imgFrame = [Globals.i imageNamedCustom:@"hero_frame"];
    UIImage *imgLight = [Globals.i imageNamedCustom:@"fx_shine"];
    
    UIGraphicsBeginImageContext(CGSizeMake(frame_width, frame_height));
    [imgHero drawInRect:CGRectMake(frame_border, frame_border, face_size, face_size-pvHeroXP_height)];
    [imgLight drawInRect:CGRectMake(frame_border, frame_border, face_size, face_size)];
    [imgFrame drawInRect:CGRectMake(0.0f, 0.0f, frame_width, frame_height)];
    UIImage *imgH = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(CGSizeMake(frame_width, frame_height));
    [imgHero drawInRect:CGRectMake(frame_border, frame_border, face_size, face_size-pvHeroXP_height)];
    [imgFrame drawInRect:CGRectMake(0.0f, 0.0f, frame_width, frame_height)];
    UIImage *imgN = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
	[self.btnHero setBackgroundImage:imgN forState:UIControlStateNormal];
	[self.btnHero setBackgroundImage:imgH forState:UIControlStateHighlighted];
    
    NSInteger sp_balance = Globals.i.spBalance;
    if (sp_balance > 0)
    {
        [self.btnHero startGlowingWithColor:[UIColor yellowColor] intensity:0.3];
    }
    else
    {
        [self.btnHero stopGlowing];
    }
}

- (void)loadBaseView
{
	if (self.baseView == nil)
    {
        self.baseView = [[BaseView alloc] init];
    }
    
    [self.baseView.view setFrame:CGRectMake(SCREEN_OFFSET_X,
                                   SCREEN_OFFSET_MAINHEADER_Y,
                                   UIScreen.mainScreen.bounds.size.width,
                                   UIScreen.mainScreen.bounds.size.height - SCREEN_OFFSET_MAINHEADER_Y - SCREEN_OFFSET_BOTTOM)];
    
    self.baseView.title = @"City";
    
    [self.baseView removeFromParentViewController];
    [self.view insertSubview:self.baseView.view atIndex:0];
    
    [self.baseView startFade];
    
    [self.baseView updateView];
    
    [self showBaseViewButtons];
}

- (void)hideBaseViewButtons
{
    self.lblPowerName.hidden = YES;
    self.lblPowerPoints.hidden = YES;
    self.lblHero.hidden = YES;
    self.pvHeroXp.hidden = YES;
    self.btnProfile.hidden = YES;
    self.btnHero.hidden = YES;
    [self.btnHero stopGlowing];
    self.btnBaseList.hidden = YES;
    self.lblBaseName.hidden = YES;
    self.lblBaseLocation.hidden = YES;
    
    self.lblTitle.hidden = NO;
    self.btnBack.hidden = NO;
}

- (void)showBaseViewButtons
{
    self.lblPowerName.hidden = NO;
    self.lblPowerPoints.hidden = NO;
    self.lblHero.hidden = NO;
    self.pvHeroXp.hidden = NO;
    self.btnProfile.hidden = NO;
    self.btnHero.hidden = NO;
    self.btnBaseList.hidden = NO;
    self.lblBaseName.hidden = NO;
    self.lblBaseLocation.hidden = NO;
    
    self.lblTitle.hidden = YES;
    self.btnBack.hidden = YES;
    
    self.btnBookmark.hidden = YES;
    self.btnFullscreen.hidden = YES;
    self.btnHome.hidden = YES;
    self.btnSearch.hidden = YES;
    
    [self updateHeader];
}

- (void)updateIndicator:(NSInteger)state
{
    self.indicatorState = state;
    
    if (self.ivIndicator == nil)
    {
        UIImage *imgIndicator = [Globals.i imageNamedCustom:@"bkg_indicator"];
        self.ivIndicator = [[UIImageView alloc] initWithImage:imgIndicator];
    }
    
    if ((state > 0) && (state < 4))
    {
        [self.ivIndicator removeFromSuperview];
        [self.ivIndicator setFrame:self.mapBtn.frame];
        [self.view insertSubview:self.ivIndicator belowSubview:self.mapBtn];
        
        if (state == 1)
        {
            [self.mapBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_city"]
                                   forState:UIControlStateNormal];
            
            [self.mapBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_city_h"]
                                   forState:UIControlStateHighlighted];
            
            self.mapLbl.text = NSLocalizedString(@"CITY", nil);
        }
        else if (state == 2)
        {
            [self.mapBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_map"]
                                   forState:UIControlStateNormal];
            
            [self.mapBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_map_h"]
                                   forState:UIControlStateHighlighted];
            
            self.mapLbl.text = NSLocalizedString(@"MAP", nil);
        }
        else if (state == 3)
        {
            [self.mapBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_world"]
                                   forState:UIControlStateNormal];
            
            [self.mapBtn setBackgroundImage:[Globals.i imageNamedCustom:@"btn_world_h"]
                                   forState:UIControlStateHighlighted];
            
            self.mapLbl.text = NSLocalizedString(@"WORLD", nil);
        }
    }
    else if (state == 4)
    {
        [self.ivIndicator removeFromSuperview];
        [self.ivIndicator setFrame:self.questBtn.frame];
        [self.view insertSubview:self.ivIndicator belowSubview:self.questBtn];
    }
    else if (state == 5)
    {
        [self.ivIndicator removeFromSuperview];
        [self.ivIndicator setFrame:self.allianceBtn.frame];
        [self.view insertSubview:self.ivIndicator belowSubview:self.allianceBtn];
    }
    else if (state == 6)
    {
        [self.ivIndicator removeFromSuperview];
        [self.ivIndicator setFrame:self.itemBtn.frame];
        [self.view insertSubview:self.ivIndicator belowSubview:self.itemBtn];
    }
    else if (state == 7)
    {
        [self.ivIndicator removeFromSuperview];
        [self.ivIndicator setFrame:self.mailBtn.frame];
        [self.view insertSubview:self.ivIndicator belowSubview:self.mailBtn];
    }
    else if (state == 8)
    {
        [self.ivIndicator removeFromSuperview];
        [self.ivIndicator setFrame:self.moreBtn.frame];
        [self.view insertSubview:self.ivIndicator belowSubview:self.moreBtn];
    }
    else if (state == 9) //extra ipad button
    {
        [self.ivIndicator removeFromSuperview];
        [self.ivIndicator setFrame:self.extraBtn.frame];
        [self.view insertSubview:self.ivIndicator belowSubview:self.extraBtn];
    }
    else if (state == 0)
    {
        [self.ivIndicator removeFromSuperview];
    }
}

- (void)glowBorders:(UIColor *)uicolor duration:(float)time
{
    if ([uicolor isEqual:[UIColor clearColor]])
    {
        self.view.layer.borderWidth = 0;
        self.view.layer.borderColor = CGColorCreateCopy([uicolor CGColor]);
    }
    else
    {
        self.view.layer.borderWidth = 0;
        self.view.layer.borderColor = CGColorCreateCopy([[uicolor colorWithAlphaComponent:0.7f] CGColor]);
    }
    
    CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    // animate from red to blue border ...
    color.fromValue = (id)[uicolor colorWithAlphaComponent:0.0f].CGColor;
    color.toValue   = (id)[uicolor colorWithAlphaComponent:0.7f].CGColor;
    // ... and change the model value
    self.view.layer.backgroundColor = [uicolor colorWithAlphaComponent:0.0f].CGColor;
    
    CABasicAnimation *width = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    // animate from 2pt to 4pt wide border ...
    width.fromValue = @0;
    width.toValue   = @4;
    // ... and change the model value
    self.view.layer.borderWidth = 0;
    
    CAAnimationGroup *both = [CAAnimationGroup animation];
    // animate both as a group with the duration of 0.5 seconds
    both.duration   = 1.0;
    both.repeatCount = time;
    both.autoreverses = YES;
    both.animations = @[color, width];
    // optionally add other configuration (that applies to both animations)
    both.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    [self.view.layer addAnimation:both forKey:@"color and width"];
}

#pragma mark - Show Views

- (void)touchChat
{
    if (self.chatState == 2)
    {
        [self showChat:YES];
    }
    else
    {
        [self showChat:NO];
    }
}

- (void)profile_tap:(id)sender
{
    [Globals.i play_button];
    
    NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:Globals.i.wsWorldProfileDict[@"profile_id"] forKey:@"profile_id"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                        object:self
                                                      userInfo:userInfo];
    
    [self updateIndicator:1];
}

- (void)hero_tap:(id)sender
{
    [Globals.i play_button];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHero" object:self];
    
    [self updateIndicator:1];
}

- (void)back_tap:(id)sender
{
    [Globals.i play_button];
    
    [UIManager.i closeTemplate];
}

- (void)home_tap:(id)sender
{
    [Globals.i play_button];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Map_Home" object:self];
}

- (void)search_tap:(id)sender
{
    [Globals.i play_button];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Map_Search" object:self];
}

- (void)fullscreen_tap:(id)sender
{
    [Globals.i play_button];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Map_Fullscreen" object:self];
}

- (void)bookmark_tap:(id)sender
{
    [Globals.i play_button];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Map_Bookmark" object:self];
}

- (void)buy_tap:(id)sender
{
    [Globals.i play_gold];
    
    [self showBuy];
}

- (void)baselist_tap:(id)sender
{
    [Globals.i play_button];
    
    [self showBaseList];
}

- (void)map_tap:(id)sender
{
    [Globals.i play_button];
    
    if (self.indicatorState == 1)
    {
        [UIManager.i closeAllTemplate];
        [self showMap];
        [self updateIndicator:2];
    }
    else if (self.indicatorState == 2)
    {
        [UIManager.i closeAllTemplate];
    }
    else
    {
        [UIManager.i closeAllTemplate];
    }
}

- (void)quest_tap:(id)sender
{
    [Globals.i play_button];
    
    [UIManager.i closeAllTemplate];
    
    [self showQuest];
    
    [self updateIndicator:4];
}

- (void)alliance_tap:(id)sender
{
    [Globals.i play_button];
    
    [UIManager.i closeAllTemplate];
    
    [self showAlliance];
    
    [self updateIndicator:5];
}

- (void)more_tap:(id)sender
{
    [Globals.i play_button];
    
    [UIManager.i closeAllTemplate];
    
    [self showMore];
    
    [self updateIndicator:8];
}

- (void)mail_tap:(id)sender
{
    [Globals.i play_button];
    
    [UIManager.i closeAllTemplate];
    
    [self showMail];
    
    [self updateIndicator:7];
    
    [self updateMailBadge];
}

- (void)items_tap:(id)sender
{
    [Globals.i play_button];
    
    [UIManager.i closeAllTemplate];
    
    [self showItems];
    
    [self updateIndicator:6];
}

- (void)extra_tap:(id)sender
{
    [Globals.i play_button];
    
    [UIManager.i closeAllTemplate];
    
    [self showReport];
    
    [self updateIndicator:9];
    
    [self updateMailBadge];
}

- (void)createMailBadge
{
    if (self.mailBadge == nil)
    {
        self.mailBadge = [CustomBadge customBadgeWithString:@"0" withScale:SCALE_IPAD/2.0f];
        
        [self.mailBadge setFrame:CGRectMake(self.mailBtn.frame.origin.x, self.mailBtn.frame.origin.y, self.mailBadge.frame.size.width, self.mailBadge.frame.size.height)];

        [self.view addSubview:self.mailBadge];
    }
}

- (void)createReportBadge
{
    if (self.reportBadge == nil)
    {
        self.reportBadge = [CustomBadge customBadgeWithString:@"0" withScale:SCALE_IPAD/2.0f];
        
        [self.reportBadge setFrame:CGRectMake(self.extraBtn.frame.origin.x, self.extraBtn.frame.origin.y, self.reportBadge.frame.size.width, self.reportBadge.frame.size.height)];
        
        [self.view addSubview:self.reportBadge];
    }
}

- (void)createQuestBadge
{
    if (self.questBadge == nil)
    {
        self.questBadge = [CustomBadge customBadgeWithString:@"0" withScale:SCALE_IPAD/2.0f];
        
        [self.questBadge setFrame:CGRectMake(self.questBtn.frame.origin.x, self.questBtn.frame.origin.y, self.questBadge.frame.size.width, self.questBadge.frame.size.height)];

        [self.view addSubview:self.questBadge];
    }
}

- (void)createAllianceBadge
{
    if (self.allianceBadge == nil)
    {
        self.allianceBadge = [CustomBadge customBadgeWithString:@"0" withScale:SCALE_IPAD/2.0f];
        
        [self.allianceBadge setFrame:CGRectMake(self.allianceBtn.frame.origin.x, self.allianceBtn.frame.origin.y, self.allianceBtn.frame.size.width, self.allianceBtn.frame.size.height)];

        [self.view addSubview:self.allianceBadge];
    }
}

- (void)updateMailBadge
{
    NSInteger mail_number = [Globals.i getMailBadgeNumber];
    NSInteger report_number = [Globals.i getReportBadgeNumber];
    NSInteger badge_number = mail_number;
    
    if (!(iPad))
    {
        badge_number = mail_number + report_number;
        
        if ([[UIManager.i currentViewTitle] isEqualToString:@"Mail"] || [[UIManager.i currentViewTitle] isEqualToString:@"Reports"])
        {
            [UIManager.i setTemplateBadgeNumber:0 number:mail_number];
            [UIManager.i setTemplateBadgeNumber:1 number:report_number];
        }
    }
    else
    {
        if (report_number > 0)
        {
            [self createReportBadge];
            [self.reportBadge autoBadgeSizeWithString:[@(report_number) stringValue]];
            [self.reportBadge setFrame:CGRectMake(self.extraBtn.frame.origin.x+self.extraBtn.frame.size.width-self.reportBadge.frame.size.width, self.extraBtn.frame.origin.y, self.reportBadge.frame.size.width, self.reportBadge.frame.size.height)];
            [self.reportBadge setHidden:NO];
        }
        else
        {
            [self.reportBadge autoBadgeSizeWithString:@"0"];
            [self.reportBadge setHidden:YES];
        }
    }
    
    if (badge_number > 0)
    {
        [self createMailBadge];
        [self.mailBadge autoBadgeSizeWithString:[@(badge_number) stringValue]];
        [self.mailBadge setFrame:CGRectMake(self.mailBtn.frame.origin.x+self.mailBtn.frame.size.width-self.mailBadge.frame.size.width, self.mailBtn.frame.origin.y, self.mailBadge.frame.size.width, self.mailBadge.frame.size.height)];
        [self.mailBadge setHidden:NO];
    }
    else
    {
        [self.mailBadge autoBadgeSizeWithString:@"0"];
        [self.mailBadge setHidden:YES];
    }
}

- (void)plusoneMailBadge
{
    if (self.mailBadge == nil)
    {
        self.mailBadge = [CustomBadge customBadgeWithString:@"1" withScale:SCALE_IPAD/2.0f];
        [self.mailBadge setFrame:CGRectMake(self.mailBtn.frame.origin.x+self.mailBtn.frame.size.width-self.mailBadge.frame.size.width, self.mailBtn.frame.origin.y, self.mailBadge.frame.size.width, self.mailBadge.frame.size.height)];
        [self.view addSubview:self.mailBadge];
    }
    else
    {
        NSInteger badge_number = [self.mailBadge.badgeText integerValue] + 1;
        [self.mailBadge autoBadgeSizeWithString:[@(badge_number) stringValue]];
        [self.mailBadge setFrame:CGRectMake(self.mailBtn.frame.origin.x+self.mailBtn.frame.size.width-self.mailBadge.frame.size.width, self.mailBtn.frame.origin.y, self.mailBadge.frame.size.width, self.mailBadge.frame.size.height)];
        [self.mailBadge setHidden:NO];
    }
}

- (void)plusoneReportBadge
{
    if (iPad)
    {
        if (self.reportBadge == nil)
        {
            self.reportBadge = [CustomBadge customBadgeWithString:@"1" withScale:SCALE_IPAD/2.0f];
            [self.reportBadge setFrame:CGRectMake(self.extraBtn.frame.origin.x+self.extraBtn.frame.size.width-self.reportBadge.frame.size.width, self.extraBtn.frame.origin.y, self.reportBadge.frame.size.width, self.reportBadge.frame.size.height)];
            [self.view addSubview:self.reportBadge];
        }
        else
        {
            NSInteger badge_number = [self.reportBadge.badgeText integerValue] + 1;
            [self.reportBadge autoBadgeSizeWithString:[@(badge_number) stringValue]];
            [self.reportBadge setFrame:CGRectMake(self.extraBtn.frame.origin.x+self.extraBtn.frame.size.width-self.reportBadge.frame.size.width, self.extraBtn.frame.origin.y, self.reportBadge.frame.size.width, self.reportBadge.frame.size.height)];
            [self.reportBadge setHidden:NO];
        }
    }
    else
    {
        [self plusoneMailBadge];
    }
    
}

- (void)updateQuestBadge
{
    NSInteger badge_number = [Globals.i getQuestBadgeNumber];
    
    if (badge_number > 0)
    {
        [self createQuestBadge];
        [self.questBadge autoBadgeSizeWithString:[@(badge_number) stringValue]];
        [self.questBadge setFrame:CGRectMake(self.questBtn.frame.origin.x+self.questBtn.frame.size.width-self.questBadge.frame.size.width, self.questBtn.frame.origin.y, self.questBadge.frame.size.width, self.questBadge.frame.size.height)];
        [self.questBadge setHidden:NO];
    }
    else
    {
        [self.questBadge autoBadgeSizeWithString:@"0"];
        [self.questBadge setHidden:YES];
    }
}

- (void)plusQuestBadge:(NSString *)quest_done
{
    NSInteger badge_number = [self.questBadge.badgeText integerValue] + [quest_done integerValue];
    
    [self createQuestBadge];
    [self.questBadge autoBadgeSizeWithString:[@(badge_number) stringValue]];
    [self.questBadge setFrame:CGRectMake(self.questBtn.frame.origin.x+self.questBtn.frame.size.width-self.questBadge.frame.size.width, self.questBtn.frame.origin.y, self.questBadge.frame.size.width, self.questBadge.frame.size.height)];
    [self.questBadge setHidden:NO];
}

- (void)updateAllianceBadge
{
    
}

- (void)showLogin:(LoginBlock)block
{
    if (self.loginView == nil)
    {
        self.loginView = [[LoginView alloc] init];
    }
    
    self.loginView.title = @"Login";
    self.loginView.loginBlock = block;
    
    [UIManager.i showTemplate:@[self.loginView] :NSLocalizedString(@"Login", nil) :2];
    
    [self.loginView updateView];
}

- (void)showLoading
{
    if (self.loadingView == nil)
    {
        self.loadingView = [[LoadingView alloc] init];
        self.loadingView.title = @"Loading";
    }
    [[UIManager.i peekViewControllerStack].view addSubview:self.loadingView.view];
    [self.loadingView updateView];
}

- (void)removeLoading
{
    if (self.loadingView != nil)
    {
        [self.loadingView close];
    }
}

- (void)showBuy
{
    if (self.buyView == nil)
    {
        self.buyView = [[BuyView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.buyView.title = @"Buy Diamonds";
    [self.buyView updateView];
    [UIManager.i showTemplate:@[self.buyView] :NSLocalizedString(@"Buy Diamonds", nil) :1];
}

- (void)showEventSolo
{
    if (self.eventSoloView == nil)
    {
        self.eventSoloView = [[EventsView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.eventSoloView.title = @"Solo Event";
    self.eventSoloView.isAlliance = @"0";
    self.eventSoloView.serviceNameDetail = @"GetEventSolo";
    self.eventSoloView.serviceNameList = @"GetEventSoloNow";
    self.eventSoloView.serviceNameResult = @"GetEventSoloResult";
    [self.eventSoloView updateView];
    
    [UIManager.i showTemplate:@[self.eventSoloView] :NSLocalizedString(@"Solo Event", nil)];
}

- (void)showEventAlliance
{
    if (self.eventAllianceView == nil)
    {
        self.eventAllianceView = [[EventsView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.eventAllianceView.title = @"Alliance Event";
    self.eventAllianceView.isAlliance = @"1";
    self.eventAllianceView.serviceNameDetail = @"GetEventAlliance";
    self.eventAllianceView.serviceNameList = @"GetEventAllianceNow";
    self.eventAllianceView.serviceNameResult = @"GetEventAllianceResult";
    [self.eventAllianceView updateView];
    
    [UIManager.i showTemplate:@[self.eventAllianceView] :NSLocalizedString(@"Alliance Event", nil)];
}

- (void)showSalesView
{
    if (self.salesView == nil)
    {
        self.salesView = [[SalesView alloc] init];
    }
    
    self.salesView.title = @"Promotion";
    [UIManager.i showTemplate:@[self.salesView] :NSLocalizedString(@"Promotion", nil) :1];
    [self.salesView updateView];
    
    [self.baseView updateSalesButton];
}

- (void)showSalesLoading
{
    NSString *service_name = @"GetSales";
    NSString *wsurl = @"";
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 if (returnArray.count > 0)
                 {
                     Globals.i.wsSalesDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                     
                     [self showSalesView];
                 }
             });
         }
     }];
}

- (void)showMoreGames
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.com/apps/yourdomain"]];
}

- (void)mailCompose:(NSString *)isAlli toID:(NSString *)toid toName:(NSString *)toname
{
    if (self.mailCompose == nil)
    {
        self.mailCompose = [[MailCompose alloc] initWithStyle:UITableViewStylePlain];
    }
    self.mailCompose.title = @"Message";
    self.mailCompose.isAlliance = isAlli;
    self.mailCompose.toID = toid;
    self.mailCompose.toName = toname;
    
    [UIManager.i showTemplate:@[self.mailCompose] :NSLocalizedString(@"Message", nil) :1];
    [self.mailCompose updateView];
}

- (void)showBaseList
{
    if (self.baseList == nil)
    {
        self.baseList = [[BaseList alloc] initWithStyle:UITableViewStylePlain];
    }
    self.baseList.title = @"City List";
    
    [UIManager.i showTemplate:@[self.baseList] :NSLocalizedString(@"City List", nil)];
}

- (void)showHero
{
    if (self.heroView == nil)
    {
        self.heroView = [[HeroView alloc] init];
    }
    self.heroView.title = @"Hero";
    [UIManager.i showTemplate:@[self.heroView] :NSLocalizedString(@"Hero", nil)];
    [self.heroView updateView];
}

- (void)showHeroSkills
{
    Globals.i.skill_point_spent = NO;
    
    if (self.heroSkills == nil)
    {
        self.heroSkills = [[HeroSkills alloc] initWithStyle:UITableViewStylePlain];
    }
    self.heroSkills.title = @"Hero Skills";
    [self.heroSkills updateView];
    
    [UIManager.i showTemplate:@[self.heroSkills] :NSLocalizedString(@"Hero Skills", nil)];
}

- (void)showBaseDetail
{
    if (self.baseDetail == nil)
    {
        self.baseDetail = [[BaseDetail alloc] initWithStyle:UITableViewStylePlain];
    }
    self.baseDetail.title = @"City";
    [self.baseDetail clearView];
    [self.baseDetail updateView];
    
    [UIManager.i showTemplate:@[self.baseDetail] :NSLocalizedString(@"City", nil)];
}

- (void)viewAllianceProfile:(NSDictionary *)userInfo
{
    if (self.allianceProfile == nil)
    {
        self.allianceProfile = [[AllianceProfile alloc] initWithStyle:UITableViewStylePlain];
    }
    self.allianceProfile.title = @"Alliance";
    
    if (self.allianceDescription == nil)
    {
        self.allianceDescription = [[AllianceDescription alloc] initWithStyle:UITableViewStylePlain];
    }
    self.allianceDescription.title = @"Alliance";
    
    if ([userInfo objectForKey:@"alliance_object"] != nil)
    {
        self.allianceProfile.aAlliance = [userInfo objectForKey:@"alliance_object"];
        self.allianceDescription.aAlliance = [userInfo objectForKey:@"alliance_object"];
        
        [self.allianceProfile updateView];
        [self.allianceDescription updateView];
        [UIManager.i showTemplate:@[self.allianceDescription] :NSLocalizedString(@"Alliance", nil) :4 :0 :@[self.allianceProfile]];
    }
    else if ([userInfo objectForKey:@"alliance_id"] != nil)
    {
        NSString *alliance_id = [userInfo objectForKey:@"alliance_id"];
        NSString *service_name = @"GetAllianceDetail";
        NSString *wsurl = [NSString stringWithFormat:@"/%@",
                           alliance_id];
        
        [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
         {
             if (success)
             {
                 NSMutableArray *returnArray = [Globals.i customParser:data];
                 
                 if (returnArray.count > 0)
                 {
                     AllianceObject *aObject = [[AllianceObject alloc] initWithDictionary:returnArray[0]];
                     self.allianceProfile.aAlliance = aObject;
                     self.allianceDescription.aAlliance = aObject;
                     
                     [self.allianceProfile updateView];
                     [self.allianceDescription updateView];
                     [UIManager.i showTemplate:@[self.allianceDescription] :NSLocalizedString(@"Alliance", nil) :4 :0 :@[self.allianceProfile]];
                 }
             }
         }];
    }
}

- (void)viewProfile:(NSString *)profile_id :(NSString *)button_alliance
{
    if (self.profileHeader == nil)
    {
        self.profileHeader = [[ProfileHeader alloc] initWithStyle:UITableViewStylePlain];
    }
    self.profileHeader.title = @"Profile";
    
    self.profileHeader.button_alliance = button_alliance;
    
    if (self.profileView == nil)
    {
        self.profileView = [[ProfileView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.profileView.title = @"Profile";
    
    if (![profile_id isEqualToString:@"0"])
    {
        if ([profile_id isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]]) //My Profile
        {
            self.profileHeader.profileDict = Globals.i.wsWorldProfileDict;
            self.profileView.profileDict = Globals.i.wsWorldProfileDict;
            
            NSString *service_name = @"GetProfileRank";
            NSString *wsurl = [NSString stringWithFormat:@"/%@",
                               profile_id];
            [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     NSMutableArray *returnArray = [Globals.i customParser:data];
                     
                     if (returnArray.count > 0)
                     {
                         self.profileView.profileRank = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                         
                         [self.profileHeader updateView];
                         [self.profileView updateView];
                         
                         [UIManager.i showTemplate:@[self.profileView] :NSLocalizedString(@"Profile", nil) :4 :0 :@[self.profileHeader]];
                     }
                 }
             }];
        }
        else
        {
            NSString *service_name = @"GetProfileInfo";
            NSString *wsurl = [NSString stringWithFormat:@"/%@",
                               profile_id];
            
            [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
             {
                 if (success)
                 {
                     NSMutableArray *returnArray = [Globals.i customParser:data];
                     
                     if (returnArray.count > 0)
                     {
                         self.profileHeader.profileDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                     
                         self.profileView.profileDict = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                         
                         NSString *service_name2 = @"GetProfileRank";
                         NSString *wsurl = [NSString stringWithFormat:@"/%@",
                                            profile_id];
                         [Globals.i getServerLoading:service_name2 :wsurl :^(BOOL success, NSData *data)
                          {
                              if (success)
                              {
                                  NSMutableArray *returnArray = [Globals.i customParser:data];
                                  
                                  if (returnArray.count > 0)
                                  {
                                      self.profileView.profileRank = [[NSDictionary alloc] initWithDictionary:returnArray[0] copyItems:YES];
                                      
                                      [self.profileHeader updateView];
                                      [self.profileView updateView];
                                      
                                      [UIManager.i showTemplate:@[self.profileView] :NSLocalizedString(@"Profile", nil) :4 :0 :@[self.profileHeader]];
                                  }
                              }
                          }];
                     }
                 }
             }];
        }
        
    }
}

- (void)preloadItems
{
    if (self.itemsView == nil)
    {
        self.itemsView = [[ItemsView alloc] initWithStyle:UITableViewStylePlain];
    }
    
    self.itemsView.title = @"Items";
    self.itemsView.itemInfo = nil;
    [self.itemsView updateView];
    
    if (self.itemsTabView == nil)
    {
        self.itemsTabView = [[TabView alloc] init];
        self.itemsTabView.tabArray = @[NSLocalizedString(@"Store", nil), NSLocalizedString(@"My Items", nil)];
        self.itemsTabView.tabStyle = YES;
        [self.itemsTabView updateView];
    }
}

- (void)showItems
{
    [self preloadItems];

    [UIManager.i showTemplate:@[self.itemsView] :NSLocalizedString(@"Items", nil) :4 :0 :@[self.itemsTabView]];
}

- (void)showItems:(NSDictionary *)user_info
{
    if (self.itemsView == nil)
    {
        self.itemsView = [[ItemsView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.itemsView.title = @"Items";
    
    self.itemsView.itemInfo = user_info;
    
    [self.itemsView updateView];
    
    [UIManager.i showTemplate:@[self.itemsView] :NSLocalizedString(@"Items", nil)];
}

- (void)showOptions
{
    if (self.optionsView == nil)
    {
        self.optionsView = [[OptionsView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.optionsView.title = @"Options";
    
    [self.optionsView updateView];
    
    [UIManager.i showTemplate:@[self.optionsView] :NSLocalizedString(@"Options", nil)];
}

- (void)showSlots
{
    //if (self.slotsView == nil)
    //{
    //    self.slotsView = [[SlotsView alloc] initWithNibName:@"SlotsView" bundle:nil];
    //}
    //[UIManager.i showTemplate:@[self.slotsView] :NSLocalizedString(@"Slots", nil) :0];
}

- (void)showMore
{
    if (self.moreView == nil)
    {
        self.moreView = [[MoreView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.moreView.title = @"More";
    
    [UIManager.i showTemplate:@[self.moreView] :NSLocalizedString(@"More", nil)];
}

- (void)showSports
{
    /*
    if (self.sportsView == nil)
    {
        self.sportsView = [[SportsView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.sportsView.title = @"Stadium";
    
    [UIManager.i showTemplate:@[self.sportsView] :self.sportsView.title];
    */
}

- (void)showQuest
{
    if (self.questView == nil)
    {
        self.questView = [[QuestView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.questView.title = @"Quest";
    [self.questView updateView];

    if (self.missionView == nil)
    {
        self.missionView = [[MissionView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.missionView.title = @"Mission";

    [UIManager.i showTemplate:@[self.questView, self.missionView] :@"Quest"];
     
}

- (void)showAlliance
{
    if ([Globals.i.wsWorldProfileDict[@"alliance_id"] isEqualToString:@"0"] || [Globals.i.wsWorldProfileDict[@"alliance_id"] isEqualToString:@""]) //Not in any alliance
    {
        if (self.allianceView == nil)
        {
            self.allianceView = [[AllianceView alloc] initWithStyle:UITableViewStylePlain];
        }
        self.allianceView.title = @"Alliances";
        [self.allianceView updateView];
        
        [UIManager.i showTemplate:@[self.allianceView] :NSLocalizedString(@"Alliances", nil)];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceDetail"
                                                            object:self
                                                          userInfo:nil];
    }
}

- (void)showMap
{
    [self showMap:-1 map_y:-1]; //Defaults to home base
}

- (void)showMap:(NSInteger)map_x map_y:(NSInteger)map_y
{
    [Globals.i playMusicMap];
    
	if (self.mapView == nil)
    {
        self.mapView = [[MapView alloc] init];
    }
    self.mapView.title = @"Map";
    
    self.mapView.goto_map_x = map_x;
    self.mapView.goto_map_y = map_y;
    
    [UIManager.i showTemplate:@[self.mapView] :@"Map" :4];
    [self.mapView updateView];
    
    self.btnBack.hidden = YES;
    self.lblTitle.hidden = YES;
    
    self.btnBookmark.hidden = NO;
    self.btnFullscreen.hidden = NO;
    self.btnHome.hidden = NO;
    self.btnSearch.hidden = NO;
}

- (void)showReport
{
    if (self.reportView == nil)
    {
        self.reportView = [[ReportView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.reportView.title = @"Reports";
    
    [UIManager.i showTemplate:@[self.reportView] :@"Reports"];
    [self.reportView updateView];
}

- (void)showHelp
{
    UIWebView *webView = [[UIWebView alloc] init];
    [webView setFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
    NSString *urlAddress = [[NSString alloc] initWithFormat:@"%@_help/help.html", WS_URL];
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    
    UIViewController *controller = [[UIViewController alloc] init];
    controller.view = webView;
    
    [UIManager.i showTemplate:@[controller] :NSLocalizedString(@"How To Play", nil)];
}

- (void)showSearch
{
    if (self.svProfile == nil)
    {
        self.svProfile = [[SearchView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.svProfile.title = @"Profiles";
    self.svProfile.serviceName = @"GetSearch";
    
    if (self.svAlliance == nil)
    {
        self.svAlliance = [[SearchAlliance alloc] initWithStyle:UITableViewStylePlain];
    }
    self.svAlliance.title = @"Alliance";
    
    [UIManager.i showTemplate:@[self.svProfile, self.svAlliance] :NSLocalizedString(@"Search", nil)];
}

- (void)showRanking
{
    if (self.rvProfile == nil)
    {
        self.rvProfile = [[RankingView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.rvProfile.title = NSLocalizedString(@"Top Players", nil);
    self.rvProfile.serviceName = @"GetProfilesTopLevel";
    [self.rvProfile updateView];
    
    if (self.rvAlliance == nil)
    {
        self.rvAlliance = [[RankingAlliance alloc] initWithStyle:UITableViewStylePlain];
    }
    self.rvAlliance.title = NSLocalizedString(@"Top Alliance", nil);
    [self.rvAlliance updateView];
    
    [UIManager.i showTemplate:@[self.rvProfile, self.rvAlliance] :NSLocalizedString(@"Rankings", nil)];
}

- (void)showMail
{
    if (self.mailView == nil)
    {
        self.mailView = [[MailView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.mailView.title = NSLocalizedString(@"Mails", nil);
    [self.mailView updateView];
    
    if (!(iPad))
    {
        if (self.reportView == nil)
        {
            self.reportView = [[ReportView alloc] initWithStyle:UITableViewStylePlain];
        }
        self.reportView.title = @"Reports";
        
        [UIManager.i showTemplate:@[self.mailView, self.reportView] :@"Mail"];
    }
    else
    {
        [UIManager.i showTemplate:@[self.mailView] :@"Mail"];
    }
}

- (void)mailDeveloper
{
    NSString *subject = [NSString stringWithFormat:@"%@(Version %@)",
                         GAME_NAME,
                         GAME_VERSION];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setToRecipients:[NSArray arrayWithObject:SUPPORT_EMAIL]];
        [mailCont setSubject:subject];
        [mailCont setMessageBody:@"" isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)inviteFriends
{
    NSString *appUrl = Globals.i.wsIdentifierDict[@"url_app"];
    NSString *m = [NSString stringWithFormat:NSLocalizedString(@"Play the best medieval war game! Download here: %@ Download now and receive Diamonds FREE!", nil), appUrl];
    NSString *m_encoded = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                NULL,
                                                                                                (CFStringRef)m,
                                                                                                NULL,
                                                                                                (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                kCFStringEncodingUTF8 ));
    
    NSString *str_twitter = [NSString stringWithFormat:@"twitter://post?message=%@", m_encoded];
    NSURL *twitterURL = [NSURL URLWithString:str_twitter];
    
    NSString *str_whatsapp = [NSString stringWithFormat:@"whatsapp://send?text=%@", m_encoded];
    NSURL *whatsappURL = [NSURL URLWithString:str_whatsapp];
    
    if ([[UIApplication sharedApplication] canOpenURL:whatsappURL])
    {
        [[UIApplication sharedApplication] openURL:whatsappURL];
        [Globals.i trackInvite:@"whatsapp"];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:twitterURL])
    {
        [[UIApplication sharedApplication] openURL:twitterURL];
        [Globals.i trackInvite:@"twitter"];
    }
    else if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setMessageBody:m isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
        
        [Globals.i trackInvite:@"email"];
    }
    else
    {
        //Notification for not having email or whatsapp setup on your device
        [UIManager.i showDialog:NSLocalizedString(@"You require a whatsapp, twitter or email account on your device to be able to invite friends. Please setup any of these and try again.", nil) title:@""];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark StoreKit Methods
- (void)buyProduct:(NSString *)product
{
    [UIManager.i showLoadingAlert];
	
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:product]];
	request.delegate = self;
	[request start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	self.products = response.products;
	NSArray *invalidproductIdentifiers = response.invalidProductIdentifiers;
	
	for (SKProduct *currentProduct in self.products)
	{
		NSLog(@"LocalizedDescription:%@", currentProduct.localizedDescription);
		NSLog(@"LocalizedTitle:%@",currentProduct.localizedTitle);
		
		//Numberformatter
		NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:currentProduct.priceLocale];
		NSString *formattedString = [numberFormatter stringFromNumber:currentProduct.price];
		NSLog(@"Price:%@",formattedString);
		NSLog(@"ProductIdentifier:%@",currentProduct.productIdentifier);
		
		SKPayment *payment = [SKPayment paymentWithProduct:currentProduct];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	//Are there errors for the request?
	for (NSString *invalidproductIdentifier in invalidproductIdentifiers)
	{
        [UIManager.i removeLoadingAlert];
		NSLog(@"InvalidproductIdentifiers:%@",invalidproductIdentifier);
	}
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
	for (SKPaymentTransaction *transaction in transactions)
	{
		switch (transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchased:
				[self completeTransaction:transaction];
				break;
			case SKPaymentTransactionStateFailed:
				[self failedTransaction:transaction];
				break;
			case SKPaymentTransactionStateRestored:
				[self restoreTransaction:transaction];
			default:
				break;
		}
	}
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	NSLog(@"%@", [transaction.error localizedDescription]);
	NSLog(@"%@", [transaction.error localizedRecoverySuggestion]);
	NSLog(@"%@", [transaction.error localizedFailureReason]);
	
	if (transaction.error.code != SKErrorPaymentCancelled)
	{
        [UIManager.i showDialog:NSLocalizedString(@"Please try again now.", nil) title:@""];
	}
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
    [UIManager.i removeLoadingAlert];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self doTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	[self doTransaction:transaction];
}

- (void)doTransaction:(SKPaymentTransaction *)transaction;
{
    [UIManager.i removeLoadingAlert];
    
    NSString *json = @"0";
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[receiptUrl path]])
    {
        NSData *receipt = [NSData dataWithContentsOfURL:receiptUrl];
        json = [receipt base64EncodedStringWithOptions:0];
    }
    
    //NSString *json = [Globals.i encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [Globals.i gettPurchasedProduct],
                          @"error_id",
                          Globals.i.UID,
                          @"uid",
                          json,
                          @"json",
                          nil];
    
    NSString *service_name = @"PostReportError";
    [Globals.i postServerLoading:dict :service_name :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread
             
             if (success)
             {
                 //Track purchase on GA only if receipt is validated on server
                 [self trackPurchaseWithTransaction:transaction];
                 
                 [Globals.i getServerWorldProfileData:^(BOOL success, NSData *data)
                  {
                      dispatch_async(dispatch_get_main_queue(), ^{ //Update UI on main thread
                          if (success)
                          {
                              [UIManager.i showDialog:NSLocalizedString(@"Purchase Success! Thank you for supporting our Games!", nil) title:@""];
                          }
                          else
                          {
                              //Update worldprofile failed
                              [UIManager.i showDialog:NSLocalizedString(@"Purchase Success! Please restart device to take effect.", nil) title:@""];
                          }
                      });
                  }];
             }
         });
     }];
}

- (void)trackPurchaseWithTransaction:(SKPaymentTransaction *)transaction
{
    SKPayment *payment = transaction.payment;
    NSString *sku = payment.productIdentifier;
    SKProduct *product;
    
    for (SKProduct *skProduct in self.products)
    {
        if ([skProduct.productIdentifier isEqualToString:sku])
        {
            product = skProduct;
        }
    }
    
    NSLocale *priceLocale = product.priceLocale;
    NSString *currencyCode = [priceLocale objectForKey:NSLocaleCurrencyCode];
    //NSString *transactionId = transaction.transactionIdentifier;
    NSNumber *productPrice = product.price;
    NSNumber *revenue = @(productPrice.floatValue * payment.quantity);
    
    [Globals.i trackPurchase:revenue currencyCode:currencyCode localizedTitle:product.localizedTitle sku:sku];
}

@end
