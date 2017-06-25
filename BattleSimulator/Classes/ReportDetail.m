//
//  ReportDetail.m
//  Battle Simulator
//
//  Created by Shankar on 3/24/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "ReportDetail.h"
#import "Globals.h"

@interface ReportDetail ()

@property (nonatomic, strong) NSMutableArray *rows;

@property (nonatomic, assign) CGFloat frame_width;

@end

@implementation ReportDetail

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delaysContentTouches = NO;
    for (id obj in self.tableView.subviews)
    {
        if ([obj respondsToSelector:@selector(setDelaysContentTouches:)])
        {
            [obj setDelaysContentTouches:NO];
        }
    }
}

- (void)updateView
{
    if ([self.is_popup isEqualToString:@"1"])
    {
        self.frame_width = CHART_CELL_WIDTH;
    }
    else
    {
        self.frame_width = CELL_CONTENT_WIDTH;
    }
    
    [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
    self.rows = [[NSMutableArray alloc] init];
    
    if ([self.reportData[@"report_type"] isEqualToString:@"60"]) //Capture Village
    {
        [self generateReportAttack];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"61"]) //Capture
    {
        [self generateReportAttack];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"10"]) //Attack Village
    {
        [self generateReportAttack];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"11"]) //Attack
    {
        [self generateReportAttack];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"21"]) //Spy
    {
        [self generateReportSpy];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"30"]) //Trade - Incoming / Sending
    {
        [self generateReportTrade];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"31"]) //Trade - Received / Delivered
    {
        [self generateReportTrade];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"40"]) //Reinforce - Incoming
    {
        [self generateReportReinforce];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"41"]) //Reinforce - Received / Delivered
    {
        [self generateReportReinforce];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"50"]) //Transfer - Incoming
    {
        [self generateReportTransfer];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"51"]) //Transfer - Received / Delivered
    {
        [self generateReportTransfer];
    }
    
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)generateReportTrade
{
    NSString *title = @"Resources Delivered";
    NSString *res_color = @"0";
    NSString *prefix = @" ";
    
    if ([self.reportData[@"report_type"] isEqualToString:@"30"]) //Trade - Incoming / Sending
    {
        if ([self.reportData[@"profile1_id"] isEqualToString:[Globals i].wsWorldProfileDict[@"profile_id"]])
        {
            title = @"Resources Sending";
        }
        else
        {
            title = @"Resources Incoming";
        }
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"31"]) //Trade - Received / Delivered
    {
        if ([self.reportData[@"profile1_id"] isEqualToString:[Globals i].wsWorldProfileDict[@"profile_id"]])
        {
            title = @"Resources Delivered";
        }
        else
        {
            title = @"Resources Received";
            res_color = @"6";
            prefix = @"+";
        }
    }
    
    NSString *banner = @"trade_banner";
    
    NSDictionary *row101 = @{@"bkg_prefix": @"bkg4", @"r1": title, @"r1_bold": @"1", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"i1": banner, @"nofooter": @"1"};
    NSMutableArray *rows1 = [@[self.rowData, row101, row102] mutableCopy];
    [self.rows addObject:rows1];
    
    NSMutableArray *rows2 = [[NSMutableArray alloc] init];
    NSDictionary *row201 = @{@"bkg_prefix": @"bkg4", @"r1": @"Resources", @"c1": @"Amount", @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
    [rows2 addObject:row201];
    NSInteger r1 = [self.reportData[@"r1"] integerValue];
    if (r1 > 0)
    {
        NSDictionary *row1 = @{@"i1": @"icon_r1", @"r1": [Globals i].r1, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r1]], @"c1_color": res_color, @"c1_align": @"2"};
        [rows2 addObject:row1];
    }
    NSInteger r2 = [self.reportData[@"r2"] integerValue];
    if (r2 > 0)
    {
        NSDictionary *row1 = @{@"i1": @"icon_r2", @"r1": [Globals i].r2, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r2]], @"c1_color": res_color, @"c1_align": @"2"};
        [rows2 addObject:row1];
    }
    NSInteger r3 = [self.reportData[@"r3"] integerValue];
    if (r3 > 0)
    {
        NSDictionary *row1 = @{@"i1": @"icon_r3", @"r1": [Globals i].r3, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r3]], @"c1_color": res_color, @"c1_align": @"2"};
        [rows2 addObject:row1];
    }
    NSInteger r4 = [self.reportData[@"r4"] integerValue];
    if (r4 > 0)
    {
        NSDictionary *row1 = @{@"i1": @"icon_r4", @"r1": [Globals i].r4, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r4]], @"c1_color": res_color, @"c1_align": @"2"};
        [rows2 addObject:row1];
    }
    NSInteger r5 = [self.reportData[@"r5"] integerValue];
    if (r5 > 0)
    {
        NSDictionary *row1 = @{@"i1": @"icon_r5", @"r1": [Globals i].r5, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r5]], @"c1_color": res_color, @"c1_align": @"2"};
        [rows2 addObject:row1];
    }
    [self.rows addObject:rows2];
}

- (void)generateReportTransfer
{
    NSString *title = @"Troop Transfer";
    NSString *banner = @"reinforce_banner";
    
    NSDictionary *row101 = @{@"bkg_prefix": @"bkg4", @"r1": title, @"r1_bold": @"1", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"i1": banner, @"nofooter": @"1"};
    NSMutableArray *rows1 = [@[self.rowData, row101, row102] mutableCopy];
    [self.rows addObject:rows1];
    
    NSMutableArray *rows3 = [[NSMutableArray alloc] init];
    NSDictionary *row301 = @{@"bkg_prefix": @"bkg4", @"r1": @"Troops", @"c1": @"Total", @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
    [rows3 addObject:row301];
    
    NSMutableArray *rowsTroop = [self troopList:@"p1"];
    [rows3 addObjectsFromArray:rowsTroop];
    
    [self.rows addObject:rows3];
}

- (void)generateReportReinforce
{
    NSString *title = @"Reinforcements";
    NSString *banner = @"reinforce_banner";
    
    if ([self.reportData[@"report_type"] isEqualToString:@"40"]) //Reinforce - Incoming / Sending
    {
        if ([self.reportData[@"profile1_id"] isEqualToString:[Globals i].wsWorldProfileDict[@"profile_id"]])
        {
            title = @"Sending Reinforcements";
        }
        else
        {
            title = @"Incoming Reinforcements";
        }
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"41"]) //Reinforce - Received / Delivered
    {
        if ([self.reportData[@"profile1_id"] isEqualToString:[Globals i].wsWorldProfileDict[@"profile_id"]])
        {
            title = @"Reinforcements Arrived";
        }
        else
        {
            title = @"Reinforcements Arrived";
        }
    }
    
    NSDictionary *row101 = @{@"bkg_prefix": @"bkg4", @"r1": title, @"r1_bold": @"1", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"i1": banner, @"nofooter": @"1"};
    NSMutableArray *rows1 = [@[self.rowData, row101, row102] mutableCopy];
    [self.rows addObject:rows1];
    
    NSMutableArray *rows3 = [[NSMutableArray alloc] init];
    NSDictionary *row301 = @{@"bkg_prefix": @"bkg4", @"r1": @"Troops", @"c1": @"Total", @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
    [rows3 addObject:row301];
    
    NSMutableArray *rowsTroop = [self troopList:@"p1"];
    [rows3 addObjectsFromArray:rowsTroop];
    
    [self.rows addObject:rows3];
}

- (void)generateReportSpy
{
    NSString *title = @"Victory!";
    NSString *spy_title = @"You";
    NSString *banner = @"spy_victory";
    NSString *title_color = @"2";
    NSString *res_color = @"0";
    NSString *prefix = @" ";
    NSString *id_you = @"1";
    NSString *id_enemy = @"2";
    BOOL show_revenge = NO;
    BOOL show_report = NO;
    
    if ([self.reportData[@"report_type"] isEqualToString:@"21"]) //Spy
    {
        if ([self.reportData[@"profile1_id"] isEqualToString:[Globals i].wsWorldProfileDict[@"profile_id"]])
        {
            id_you = @"1";
            id_enemy = @"2";
            spy_title = @"You";
            if ([self.reportData[@"victory"] isEqualToString:@"1"])
            {
                title = @"Victory!";
                banner = @"spy_victory";
                title_color = @"6";
                
                show_revenge = NO;
                show_report = YES;
            }
            else
            {
                title = @"Defeat!";
                banner = @"spy_defeat";
                title_color = @"1";
                
                show_revenge = YES;
                show_report = NO;
            }
        }
        else
        {
            id_you = @"2";
            id_enemy = @"1";
            spy_title = @"Enemy";
            if ([self.reportData[@"victory"] isEqualToString:@"1"])
            {
                title = @"Defeat!";
                banner = @"spy_victory";
                title_color = @"1";
            }
            else
            {
                title = @"Victory!";
                banner = @"spy_defeat";
                title_color = @"6";
            }
            
            show_revenge = YES;
            show_report = NO;
        }
    }
    
    NSDictionary *row101 = @{@"bkg_prefix": @"bkg4", @"r1": title, @"r1_bold": @"1", @"r1_color": title_color, @"r1_align": @"1", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"i1": banner, @"nofooter": @"1"};
    NSMutableArray *rows1 = [@[self.rowData, row101, row102] mutableCopy];
    [self.rows addObject:rows1];
    
    NSString *spy_sent = @"profile1_spy_sent";
    //NSString *spy_captured = @"profile1_spy_captured";
    
    NSMutableArray *rows5 = [[NSMutableArray alloc] init];
    NSDictionary *row501 = @{@"bkg_prefix": @"bkg4", @"r1": @" ", @"c1": @" ", @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1": spy_title, @"e1_align": @"1", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"nofooter": @"1"};
    [rows5 addObject:row501];
    
    NSDictionary *row502 = @{@"r1": @"Spy Sent", @"c1": [[Globals i] numberFormat:self.reportData[spy_sent]], @"c1_align": @"1", @"c1_ratio": @"2.5"};
    [rows5 addObject:row502];
    
    //NSDictionary *row503 = @{@"r1": @"Spy Captured", @"c1": [[Globals i] numberFormat:self.reportData[spy_captured]], @"r1_color": @"1", @"c1_align": @"1", @"c1_ratio": @"2.5"};
    //[rows5 addObject:row503];
    
    [self.rows addObject:rows5];
    
    //Show full report if your spy is success
    if (show_report)
    {
        NSMutableArray *rows2 = [[NSMutableArray alloc] init];
        NSDictionary *row201 = @{@"bkg_prefix": @"bkg4", @"r1": @"Resources", @"c1": @"Amount", @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
        [rows2 addObject:row201];
        NSInteger r1 = [self.reportData[@"r1"] integerValue];
        if (r1 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r1", @"r1": [Globals i].r1, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r1]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        NSInteger r2 = [self.reportData[@"r2"] integerValue];
        if (r2 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r2", @"r1": [Globals i].r2, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r2]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        NSInteger r3 = [self.reportData[@"r3"] integerValue];
        if (r3 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r3", @"r1": [Globals i].r3, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r3]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        NSInteger r4 = [self.reportData[@"r4"] integerValue];
        if (r4 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r4", @"r1": [Globals i].r4, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r4]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        NSInteger r5 = [self.reportData[@"r5"] integerValue];
        if (r5 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r5", @"r1": [Globals i].r5, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r5]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        [self.rows addObject:rows2];
        
        NSInteger int_total_troops = [self.reportData[@"profile2_troops"] integerValue];
        NSInteger int_total_reinforcements = [self.reportData[@"profile2_killed"] integerValue];
        
        NSMutableArray *rows3 = [[NSMutableArray alloc] init];
        NSDictionary *row301 = @{@"bkg_prefix": @"bkg4", @"r1": @"Troops", @"c1": [[Globals i] intString:int_total_troops], @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
        [rows3 addObject:row301];
        
        if (int_total_troops > 0)
        {
            NSMutableArray *rowsTroop = [self troopList:@"p2"];
            [rows3 addObjectsFromArray:rowsTroop];
        }
        [self.rows addObject:rows3];
        
        NSMutableArray *rows4 = [[NSMutableArray alloc] init];
        NSDictionary *row401 = @{@"bkg_prefix": @"bkg4", @"r1": @"Reinforcements", @"c1": [[Globals i] intString:int_total_reinforcements], @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
        [rows4 addObject:row401];
        
        if (int_total_reinforcements > 0)
        {
            NSMutableArray *rowsTroop = [self troopList:@"k2"];
            [rows4 addObjectsFromArray:rowsTroop];
        }
        [self.rows addObject:rows4];
        
    }
    
    //Revenge button
    if (show_revenge)
    {
        NSMutableArray *rows9 = [[NSMutableArray alloc] init];
        NSDictionary *row901 = @{@"r1": @" ", @"nofooter": @"1"};
        [rows9 addObject:row901];
        
        NSDictionary *row902 = @{@"r1": @"Revenge", @"r1_button": @"2", @"nofooter": @"1"};
        [rows9 addObject:row902];
        
        [self.rows addObject:rows9];
    }
}

- (void)generateReportAttack
{
    NSString *title = @"Victory!";
    NSString *banner = @"attack_victory";
    NSString *title_color = @"2";
    NSString *res_color = @"0";
    NSString *prefix = @" ";
    NSString *id_you = @"1";
    NSString *id_enemy = @"2";
    BOOL show_revenge = YES;
    
    if ([self.reportData[@"report_type"] isEqualToString:@"60"]) //Capture NPC Village
    {
        title = @"Attempt to Capture";
        NSString *banner = @"reinforce_banner";
        
        NSDictionary *row101 = @{@"bkg_prefix": @"bkg4", @"r1": title, @"r1_bold": @"1", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
        NSDictionary *row102 = @{@"i1": banner, @"nofooter": @"1"};
        NSMutableArray *rows1 = [@[self.rowData, row101, row102] mutableCopy];
        [self.rows addObject:rows1];
        
        NSMutableArray *rows3 = [[NSMutableArray alloc] init];
        NSDictionary *row301 = @{@"bkg_prefix": @"bkg4", @"r1": @"Troops", @"c1": @"Total", @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
        [rows3 addObject:row301];
        
        NSMutableArray *rowsTroop = [self troopList:@"p1"];
        [rows3 addObjectsFromArray:rowsTroop];
        
        [self.rows addObject:rows3];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"61"]) //Capture Village
    {
        if ([self.reportData[@"profile1_id"] isEqualToString:[Globals i].wsWorldProfileDict[@"profile_id"]])
        {
            id_you = @"1";
            id_enemy = @"2";
            if ([self.reportData[@"victory"] isEqualToString:@"1"])
            {
                title = @"Captured Village!";
                banner = @"capture_victory";
                title_color = @"6";
                res_color = @"6";
                prefix = @"+";
                show_revenge = NO;
            }
            else
            {
                title = @"Defeat! Capture Failed.";
                banner = @"capture_defeat";
                title_color = @"1";
                res_color = @"1";
                prefix = @"+";
            }
        }
        else
        {
            id_you = @"2";
            id_enemy = @"1";
            if ([self.reportData[@"victory"] isEqualToString:@"1"])
            {
                title = @"Defeat! Capture Failed.";
                banner = @"capture_defeat";
                title_color = @"1";
                res_color = @"1";
                prefix = @"-";
            }
            else
            {
                title = @"Captured Village!";
                banner = @"capture_victory";
                title_color = @"6";
                res_color = @"6";
                prefix = @"-";
            }
        }
        
        NSDictionary *row101 = @{@"bkg_prefix": @"bkg4", @"r1": title, @"r1_bold": @"1", @"r1_color": title_color, @"r1_align": @"1", @"nofooter": @"1"};
        NSDictionary *row102 = @{@"i1": banner, @"nofooter": @"1"};
        NSMutableArray *rows1 = [@[self.rowData, row101, row102] mutableCopy];
        [self.rows addObject:rows1];
        
        [self addTroopStats:id_you :id_enemy];
        
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"10"]) //Attack Village
    {
        title = @"Sending Attack";
        NSString *banner = @"reinforce_banner";
        
        NSDictionary *row101 = @{@"bkg_prefix": @"bkg4", @"r1": title, @"r1_bold": @"1", @"r1_color": @"2", @"r1_align": @"1", @"nofooter": @"1"};
        NSDictionary *row102 = @{@"i1": banner, @"nofooter": @"1"};
        NSMutableArray *rows1 = [@[self.rowData, row101, row102] mutableCopy];
        [self.rows addObject:rows1];
        
        NSMutableArray *rows3 = [[NSMutableArray alloc] init];
        NSDictionary *row301 = @{@"bkg_prefix": @"bkg4", @"r1": @"Troops", @"c1": @"Total", @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
        [rows3 addObject:row301];
        
        NSMutableArray *rowsTroop = [self troopList:@"p1"];
        [rows3 addObjectsFromArray:rowsTroop];
        
        [self.rows addObject:rows3];
    }
    else if ([self.reportData[@"report_type"] isEqualToString:@"11"]) //Attack
    {
        if ([self.reportData[@"profile1_id"] isEqualToString:[Globals i].wsWorldProfileDict[@"profile_id"]])
        {
            id_you = @"1";
            id_enemy = @"2";
            if ([self.reportData[@"victory"] isEqualToString:@"1"])
            {
                title = @"Victory!";
                banner = @"attack_victory";
                title_color = @"6";
                res_color = @"6";
                prefix = @"+";
                show_revenge = NO;
            }
            else
            {
                title = @"Defeat!";
                banner = @"attack_defeat";
                title_color = @"1";
                res_color = @"1";
                prefix = @"+";
            }
        }
        else
        {
            id_you = @"2";
            id_enemy = @"1";
            if ([self.reportData[@"victory"] isEqualToString:@"1"])
            {
                title = @"Defeat!";
                banner = @"attack_defeat";
                title_color = @"1";
                res_color = @"1";
                prefix = @"-";
            }
            else
            {
                title = @"Victory!";
                banner = @"attack_victory";
                title_color = @"6";
                res_color = @"6";
                prefix = @"-";
            }
        }
        
        NSDictionary *row101 = @{@"bkg_prefix": @"bkg4", @"r1": title, @"r1_bold": @"1", @"r1_color": title_color, @"r1_align": @"1", @"nofooter": @"1"};
        NSDictionary *row102 = @{@"i1": banner, @"nofooter": @"1"};
        NSMutableArray *rows1 = [@[self.rowData, row101, row102] mutableCopy];
        [self.rows addObject:rows1];
        
        NSMutableArray *rows2 = [[NSMutableArray alloc] init];
        NSDictionary *row201 = @{@"bkg_prefix": @"bkg4", @"r1": @"Resources Obtained", @"c1": @"Amount", @"r1_color": @"2", @"c1_color": @"2", @"c1_align": @"2", @"nofooter": @"1"};
        [rows2 addObject:row201];
        NSInteger r1 = [self.reportData[@"r1"] integerValue];
        if (r1 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r1", @"r1": [Globals i].r1, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r1]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        NSInteger r2 = [self.reportData[@"r2"] integerValue];
        if (r2 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r2", @"r1": [Globals i].r2, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r2]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        NSInteger r3 = [self.reportData[@"r3"] integerValue];
        if (r3 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r3", @"r1": [Globals i].r3, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r3]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        NSInteger r4 = [self.reportData[@"r4"] integerValue];
        if (r4 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r4", @"r1": [Globals i].r4, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r4]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        NSInteger r5 = [self.reportData[@"r5"] integerValue];
        if (r5 > -1)
        {
            NSDictionary *row1 = @{@"i1": @"icon_r5", @"r1": [Globals i].r5, @"c1": [NSString stringWithFormat:@"%@%@", prefix, [[Globals i] intString:r5]], @"c1_color": res_color, @"c1_align": @"2"};
            [rows2 addObject:row1];
        }
        [self.rows addObject:rows2];
        
        [self addTroopStats:id_you :id_enemy];
        
        //Revenge button
        if (show_revenge)
        {
            NSMutableArray *rows9 = [[NSMutableArray alloc] init];
            NSDictionary *row901 = @{@"r1": @" ", @"nofooter": @"1"};
            [rows9 addObject:row901];
            
            NSDictionary *row902 = @{@"r1": @"Revenge", @"r1_button": @"2", @"nofooter": @"1"};
            [rows9 addObject:row902];
            
            [self.rows addObject:rows9];
        }
    }
}

- (void)addTroopStats:(NSString *)id_you :(NSString *)id_enemy
{
    //Troops Total
    NSMutableArray *rows2 = [[NSMutableArray alloc] init];
    NSDictionary *row201 = @{@"bkg_prefix": @"bkg4", @"r1": @"Troops Total", @"c1": @"You", @"c1_align": @"2", @"c1_ratio": @"3", @"e1": @"Enemy", @"e1_align": @"2", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"nofooter": @"1"};
    [rows2 addObject:row201];
    
    NSDictionary *a1 = [self troopTotalRow:@"a1" :id_you :id_enemy];
    if (a1 != nil)
    {
        [rows2 addObject:a1];
    }
    NSDictionary *a2 = [self troopTotalRow:@"a2" :id_you :id_enemy];
    if (a2 != nil)
    {
        [rows2 addObject:a2];
    }
    NSDictionary *a3 = [self troopTotalRow:@"a3" :id_you :id_enemy];
    if (a3 != nil)
    {
        [rows2 addObject:a3];
    }
    
    NSDictionary *b1 = [self troopTotalRow:@"b1" :id_you :id_enemy];
    if (b1 != nil)
    {
        [rows2 addObject:b1];
    }
    NSDictionary *b2 = [self troopTotalRow:@"b2" :id_you :id_enemy];
    if (b2 != nil)
    {
        [rows2 addObject:b2];
    }
    NSDictionary *b3 = [self troopTotalRow:@"b3" :id_you :id_enemy];
    if (b3 != nil)
    {
        [rows2 addObject:b3];
    }
    
    NSDictionary *c1 = [self troopTotalRow:@"c1" :id_you :id_enemy];
    if (c1 != nil)
    {
        [rows2 addObject:c1];
    }
    NSDictionary *c2 = [self troopTotalRow:@"c2" :id_you :id_enemy];
    if (c2 != nil)
    {
        [rows2 addObject:c2];
    }
    NSDictionary *c3 = [self troopTotalRow:@"c3" :id_you :id_enemy];
    if (c3 != nil)
    {
        [rows2 addObject:c3];
    }
    
    NSDictionary *d1 = [self troopTotalRow:@"d1" :id_you :id_enemy];
    if (d1 != nil)
    {
        [rows2 addObject:d1];
    }
    NSDictionary *d2 = [self troopTotalRow:@"d2" :id_you :id_enemy];
    if (d2 != nil)
    {
        [rows2 addObject:d2];
    }
    NSDictionary *d3 = [self troopTotalRow:@"d3" :id_you :id_enemy];
    if (d3 != nil)
    {
        [rows2 addObject:d3];
    }
    
    if ([rows2 count] > 1) //if there is rows either then header
    {
        [self.rows addObject:rows2];
    }
    
    //Troops Killed
    NSMutableArray *rows3 = [[NSMutableArray alloc] init];
    NSDictionary *row301 = @{@"bkg_prefix": @"bkg4", @"r1": @"Troops Killed", @"c1": @"You", @"c1_align": @"2", @"c1_ratio": @"3", @"e1": @"Enemy", @"e1_align": @"2", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"nofooter": @"1"};
    [rows3 addObject:row301];
    
    a1 = [self troopKilledRow:@"a1" :id_you :id_enemy];
    if (a1 != nil)
    {
        [rows3 addObject:a1];
    }
    a2 = [self troopKilledRow:@"a2" :id_you :id_enemy];
    if (a2 != nil)
    {
        [rows3 addObject:a2];
    }
    a3 = [self troopKilledRow:@"a3" :id_you :id_enemy];
    if (a3 != nil)
    {
        [rows3 addObject:a3];
    }
    
    b1 = [self troopKilledRow:@"b1" :id_you :id_enemy];
    if (b1 != nil)
    {
        [rows3 addObject:b1];
    }
    b2 = [self troopKilledRow:@"b2" :id_you :id_enemy];
    if (b2 != nil)
    {
        [rows3 addObject:b2];
    }
    b3 = [self troopKilledRow:@"b3" :id_you :id_enemy];
    if (b3 != nil)
    {
        [rows3 addObject:b3];
    }
    
    c1 = [self troopKilledRow:@"c1" :id_you :id_enemy];
    if (c1 != nil)
    {
        [rows3 addObject:c1];
    }
    c2 = [self troopKilledRow:@"c2" :id_you :id_enemy];
    if (c2 != nil)
    {
        [rows3 addObject:c2];
    }
    c3 = [self troopKilledRow:@"c3" :id_you :id_enemy];
    if (c3 != nil)
    {
        [rows3 addObject:c3];
    }
    
    d1 = [self troopKilledRow:@"d1" :id_you :id_enemy];
    if (d1 != nil)
    {
        [rows3 addObject:d1];
    }
    d2 = [self troopKilledRow:@"d2" :id_you :id_enemy];
    if (d2 != nil)
    {
        [rows3 addObject:d2];
    }
    d3 = [self troopKilledRow:@"d3" :id_you :id_enemy];
    if (d3 != nil)
    {
        [rows3 addObject:d3];
    }
    
    if ([rows3 count] > 1) //if there is rows either then header
    {
        [self.rows addObject:rows3];
    }
    
    //Troops Injured
    NSMutableArray *rows4 = [[NSMutableArray alloc] init];
    NSDictionary *row401 = @{@"bkg_prefix": @"bkg4", @"r1": @"Troops Injured", @"c1": @"You", @"c1_align": @"2", @"c1_ratio": @"3", @"e1": @"Enemy", @"e1_align": @"2", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"nofooter": @"1"};
    [rows4 addObject:row401];
    
    a1 = [self troopInjuredRow:@"a1" :id_you :id_enemy];
    if (a1 != nil)
    {
        [rows4 addObject:a1];
    }
    a2 = [self troopInjuredRow:@"a2" :id_you :id_enemy];
    if (a2 != nil)
    {
        [rows4 addObject:a2];
    }
    a3 = [self troopInjuredRow:@"a3" :id_you :id_enemy];
    if (a3 != nil)
    {
        [rows4 addObject:a3];
    }
    
    b1 = [self troopInjuredRow:@"b1" :id_you :id_enemy];
    if (b1 != nil)
    {
        [rows4 addObject:b1];
    }
    b2 = [self troopInjuredRow:@"b2" :id_you :id_enemy];
    if (b2 != nil)
    {
        [rows4 addObject:b2];
    }
    b3 = [self troopInjuredRow:@"b3" :id_you :id_enemy];
    if (b3 != nil)
    {
        [rows4 addObject:b3];
    }
    
    c1 = [self troopInjuredRow:@"c1" :id_you :id_enemy];
    if (c1 != nil)
    {
        [rows4 addObject:c1];
    }
    c2 = [self troopInjuredRow:@"c2" :id_you :id_enemy];
    if (c2 != nil)
    {
        [rows4 addObject:c2];
    }
    c3 = [self troopInjuredRow:@"c3" :id_you :id_enemy];
    if (c3 != nil)
    {
        [rows4 addObject:c3];
    }
    
    d1 = [self troopInjuredRow:@"d1" :id_you :id_enemy];
    if (d1 != nil)
    {
        [rows4 addObject:d1];
    }
    d2 = [self troopInjuredRow:@"d2" :id_you :id_enemy];
    if (d2 != nil)
    {
        [rows4 addObject:d2];
    }
    d3 = [self troopInjuredRow:@"d3" :id_you :id_enemy];
    if (d3 != nil)
    {
        [rows4 addObject:d3];
    }
    
    if ([rows4 count] > 1) //if there is rows other then header
    {
        [self.rows addObject:rows4];
    }
    
    //Ally Reinforcements to defender
    NSMutableArray *rows5 = [[NSMutableArray alloc] init];
    NSDictionary *row501 = @{@"bkg_prefix": @"bkg4", @"r1": @"Reinforcements", @"c1": @"Total", @"c1_align": @"2", @"c1_ratio": @"3", @"e1": @"Killed", @"e1_align": @"2", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"nofooter": @"1"};
    [rows5 addObject:row501];
    
    a1 = [self reinforcementsRow:@"a1" :id_you :id_enemy];
    if (a1 != nil)
    {
        [rows5 addObject:a1];
    }
    a2 = [self reinforcementsRow:@"a2" :id_you :id_enemy];
    if (a2 != nil)
    {
        [rows5 addObject:a2];
    }
    a3 = [self reinforcementsRow:@"a3" :id_you :id_enemy];
    if (a3 != nil)
    {
        [rows5 addObject:a3];
    }
    
    b1 = [self reinforcementsRow:@"b1" :id_you :id_enemy];
    if (b1 != nil)
    {
        [rows5 addObject:b1];
    }
    b2 = [self reinforcementsRow:@"b2" :id_you :id_enemy];
    if (b2 != nil)
    {
        [rows5 addObject:b2];
    }
    b3 = [self reinforcementsRow:@"b3" :id_you :id_enemy];
    if (b3 != nil)
    {
        [rows5 addObject:b3];
    }
    
    c1 = [self reinforcementsRow:@"c1" :id_you :id_enemy];
    if (c1 != nil)
    {
        [rows5 addObject:c1];
    }
    c2 = [self reinforcementsRow:@"c2" :id_you :id_enemy];
    if (c2 != nil)
    {
        [rows5 addObject:c2];
    }
    c3 = [self reinforcementsRow:@"c3" :id_you :id_enemy];
    if (c3 != nil)
    {
        [rows5 addObject:c3];
    }
    
    d1 = [self reinforcementsRow:@"d1" :id_you :id_enemy];
    if (d1 != nil)
    {
        [rows5 addObject:d1];
    }
    d2 = [self reinforcementsRow:@"d2" :id_you :id_enemy];
    if (d2 != nil)
    {
        [rows5 addObject:d2];
    }
    d3 = [self reinforcementsRow:@"d3" :id_you :id_enemy];
    if (d3 != nil)
    {
        [rows5 addObject:d3];
    }
    
    if ([rows5 count] > 1) //if there is rows other then header
    {
        [self.rows addObject:rows5];
    }

    NSString *you_hero_name = [NSString stringWithFormat:@"profile%@_hero_name", id_you];
    NSString *enemy_hero_name = [NSString stringWithFormat:@"profile%@_hero_name", id_enemy];
    
    NSString *you_hero_xp_str = [NSString stringWithFormat:@"profile%@_hero_xp", id_you];
    NSString *enemy_hero_xp_str = [NSString stringWithFormat:@"profile%@_hero_xp", id_enemy];
    
    NSString *you_hero_xp_gain = [NSString stringWithFormat:@"profile%@_hero_xp_gain", id_you];
    NSString *enemy_hero_xp_gain = [NSString stringWithFormat:@"profile%@_hero_xp_gain", id_enemy];
    
    NSMutableArray *rows6 = [[NSMutableArray alloc] init];
    NSDictionary *row601 = @{@"bkg_prefix": @"bkg4", @"r1": @"Your Hero", @"c1": @"Enemy Hero", @"r1_align": @"1", @"c1_align": @"1", @"c1_ratio": @"2", @"r1_color": @"2", @"c1_color": @"2", @"nofooter": @"1"};
    [rows6 addObject:row601];
    
    NSString *you_hero_xp = self.reportData[you_hero_xp_str];
    NSString *enemy_hero_xp = self.reportData[enemy_hero_xp_str];
    
    NSInteger youHeroLvl = [[Globals i] levelFromXp:[you_hero_xp integerValue]];
    NSInteger enemyHeroLvl = [[Globals i] levelFromXp:[enemy_hero_xp integerValue]];
    
    NSString *u_xp = [NSString stringWithFormat:@"Hero XP: +%@", [[Globals i] numberFormat:self.reportData[you_hero_xp_gain]]];
    NSString *e_xp = [NSString stringWithFormat:@"Hero XP: +%@", [[Globals i] numberFormat:self.reportData[enemy_hero_xp_gain]]];
    NSDictionary *row602 = @{@"r1": [NSString stringWithFormat:@"%@ (Lv. %@)", self.reportData[you_hero_name], [@(youHeroLvl) stringValue]], @"r2": u_xp, @"c1": [NSString stringWithFormat:@"%@ (Lv. %@)", self.reportData[enemy_hero_name], [@(enemyHeroLvl) stringValue]], @"c2": e_xp, @"r1_border": @"1", @"r1_align": @"1", @"c1_align": @"1", @"r2_align": @"1", @"c2_align": @"1", @"c1_ratio": @"2"};
    [rows6 addObject:row602];
    
    [self.rows addObject:rows6];
    
    NSString *you_troops = [NSString stringWithFormat:@"profile%@_troops", id_you];
    NSString *you_reinforcement_troops = [NSString stringWithFormat:@"profile%@_r_troops", id_you];
    
    NSString *enemy_troops = [NSString stringWithFormat:@"profile%@_troops", id_enemy];
    NSString *enemy_reinforcement_troops = [NSString stringWithFormat:@"profile%@_r_troops", id_enemy];
    
    NSInteger int_you_troops = [self.reportData[you_troops] integerValue];
    NSInteger int_you_reinforcement_troops = [self.reportData[you_reinforcement_troops] integerValue];
    
    NSInteger int_enemy_troops = [self.reportData[enemy_troops] integerValue];
    NSInteger int_enemy_reinforcement_troops = [self.reportData[enemy_reinforcement_troops] integerValue];
    
    NSString *you_injured = [NSString stringWithFormat:@"profile%@_injured", id_you];
    NSString *you_reinforcement_injured = [NSString stringWithFormat:@"profile%@_r_injured", id_you];
    
    NSString *enemy_injured = [NSString stringWithFormat:@"profile%@_injured", id_enemy];
    NSString *enemy_reinforcement_injured = [NSString stringWithFormat:@"profile%@_r_injured", id_enemy];
    
    NSString *you_killed = [NSString stringWithFormat:@"profile%@_killed", id_you];
    NSString *you_reinforcement_killed = [NSString stringWithFormat:@"profile%@_r_killed", id_you];
    
    NSString *enemy_killed = [NSString stringWithFormat:@"profile%@_killed", id_enemy];
    NSString *enemy_reinforcement_killed = [NSString stringWithFormat:@"profile%@_r_killed", id_enemy];
    
    NSInteger int_you_killed = [self.reportData[you_killed] integerValue];
    NSInteger int_you_reinforcement_killed = [self.reportData[you_reinforcement_killed] integerValue];
    
    NSInteger int_enemy_killed = [self.reportData[enemy_killed] integerValue];
    NSInteger int_enemy_reinforcement_killed = [self.reportData[enemy_reinforcement_killed] integerValue];
    
    NSInteger you_survived = int_you_troops - int_you_killed;
    NSInteger you_reinforcement_survived = int_you_reinforcement_troops - int_you_reinforcement_killed;
    
    NSInteger enemy_survived = int_enemy_troops - int_enemy_killed;
    NSInteger enemy_reinforcement_survived = int_enemy_reinforcement_troops - int_enemy_reinforcement_killed;
    
    NSMutableArray *rows7 = [[NSMutableArray alloc] init];
    NSDictionary *row701 = @{@"bkg_prefix": @"bkg4", @"r1": @" ", @"c1": @"You", @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1": @"Enemy", @"e1_align": @"1", @"r1_color": @"2", @"c1_color": @"2", @"e1_color": @"2", @"nofooter": @"1"};
    [rows7 addObject:row701];
    
    NSDictionary *row702 = @{@"r1": @"Troops", @"c1": [[Globals i] numberFormat:self.reportData[you_troops]], @"e1": [[Globals i] numberFormat:self.reportData[enemy_troops]], @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1_align": @"1"};
    [rows7 addObject:row702];
    
    NSDictionary *row703 = @{@"r1": @"Injured", @"c1": [[Globals i] numberFormat:self.reportData[you_injured]], @"e1": [[Globals i] numberFormat:self.reportData[enemy_injured]], @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1_align": @"1"};
    [rows7 addObject:row703];
    
    NSDictionary *row704 = @{@"r1": @"Killed", @"c1": [[Globals i] numberFormat:self.reportData[you_killed]], @"e1": [[Globals i] numberFormat:self.reportData[enemy_killed]], @"r1_color": @"1", @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1_align": @"1"};
    [rows7 addObject:row704];
    
    NSDictionary *row705 = @{@"r1": @"Survived", @"c1": [[Globals i] intString:you_survived], @"e1": [[Globals i] intString:enemy_survived], @"r1_color": @"6", @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1_align": @"1"};
    [rows7 addObject:row705];
    
    NSDictionary *row706 = @{@"r1": @"Reinforcements", @"c1": [[Globals i] numberFormat:self.reportData[you_reinforcement_troops]], @"e1": [[Globals i] numberFormat:self.reportData[enemy_reinforcement_troops]], @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1_align": @"1"};
    [rows7 addObject:row706];
    
    NSDictionary *row707 = @{@"r1": @"Reinforcements Injured", @"c1": [[Globals i] numberFormat:self.reportData[you_reinforcement_injured]], @"e1": [[Globals i] numberFormat:self.reportData[enemy_reinforcement_injured]], @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1_align": @"1"};
    [rows7 addObject:row707];
    
    NSDictionary *row708 = @{@"r1": @"Reinforcements Killed", @"c1": [[Globals i] numberFormat:self.reportData[you_reinforcement_killed]], @"e1": [[Globals i] numberFormat:self.reportData[enemy_reinforcement_killed]], @"r1_color": @"1", @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1_align": @"1"};
    [rows7 addObject:row708];
    
    NSDictionary *row709 = @{@"r1": @"Reinforcements Survived", @"c1": [[Globals i] intString:you_reinforcement_survived], @"e1": [[Globals i] intString:enemy_reinforcement_survived], @"r1_color": @"6", @"c1_align": @"1", @"c1_ratio": @"2.5", @"e1_align": @"1"};
    [rows7 addObject:row709];
    
    [self.rows addObject:rows7];
}

- (NSDictionary *)troopTotalRow:(NSString *)troop_tier :(NSString *)id_you :(NSString *)id_enemy
{
    NSDictionary *row1 = nil;
    
    NSString *troop_name = [[Globals i] valueForKey:troop_tier];
    NSString *i1 = [NSString stringWithFormat:@"icon_%@", troop_tier];
    NSString *total_you = [NSString stringWithFormat:@"p%@_%@", id_you, troop_tier];
    NSString *total_enemy = [NSString stringWithFormat:@"p%@_%@", id_enemy, troop_tier];
    NSInteger int_t_you = [self.reportData[total_you] integerValue];
    NSInteger int_t_enemy = [self.reportData[total_enemy] integerValue];
    if ((int_t_you > 0) || (int_t_enemy > 0))
    {
        row1 = @{@"i1": i1, @"r1": troop_name, @"c1": [[Globals i] intString:int_t_you], @"e1": [[Globals i] intString:int_t_enemy], @"c1_color": @"0", @"e1_color": @"0", @"c1_align": @"2", @"c1_ratio": @"3", @"e1_align": @"2"};
    }
    
    return row1;
}

- (NSDictionary *)troopKilledRow:(NSString *)troop_tier :(NSString *)id_you :(NSString *)id_enemy
{
    NSDictionary *row1 = nil;
    
    NSString *troop_name = [[Globals i] valueForKey:troop_tier];
    NSString *i1 = [NSString stringWithFormat:@"icon_%@", troop_tier];
    NSString *killed_you = [NSString stringWithFormat:@"k%@_%@", id_you, troop_tier];
    NSString *killed_enemy = [NSString stringWithFormat:@"k%@_%@", id_enemy, troop_tier];
    NSInteger int_k_you = [self.reportData[killed_you] integerValue];
    NSInteger int_k_enemy = [self.reportData[killed_enemy] integerValue];
    if ((int_k_you > 0) || (int_k_enemy > 0))
    {
        row1 = @{@"i1": i1, @"r1": troop_name, @"c1": [[Globals i] intString:int_k_you], @"e1": [[Globals i] intString:int_k_enemy], @"c1_color": @"1", @"e1_color": @"0", @"c1_align": @"2", @"c1_ratio": @"3", @"e1_align": @"2"};
    }
    
    return row1;
}

- (NSDictionary *)troopInjuredRow:(NSString *)troop_tier :(NSString *)id_you :(NSString *)id_enemy
{
    NSDictionary *row1 = nil;
    
    NSString *troop_name = [[Globals i] valueForKey:troop_tier];
    NSString *i1 = [NSString stringWithFormat:@"icon_%@", troop_tier];
    NSString *injured_you = [NSString stringWithFormat:@"i%@_%@", id_you, troop_tier];
    NSString *injured_enemy = [NSString stringWithFormat:@"i%@_%@", id_enemy, troop_tier];
    NSInteger int_i_you = [self.reportData[injured_you] integerValue];
    NSInteger int_i_enemy = [self.reportData[injured_enemy] integerValue];
    if ((int_i_you > 0) || (int_i_enemy > 0))
    {
        row1 = @{@"i1": i1, @"r1": troop_name, @"c1": [[Globals i] intString:int_i_you], @"e1": [[Globals i] intString:int_i_enemy], @"c1_color": @"1", @"e1_color": @"0", @"c1_align": @"2", @"c1_ratio": @"3", @"e1_align": @"2"};
    }
    
    return row1;
}

- (NSDictionary *)reinforcementsRow:(NSString *)troop_tier :(NSString *)id_you :(NSString *)id_enemy
{
    NSDictionary *row1 = nil;
    
    NSString *troop_name = [[Globals i] valueForKey:troop_tier];
    NSString *i1 = [NSString stringWithFormat:@"icon_%@", troop_tier];
    NSString *r_total = [NSString stringWithFormat:@"r2_%@", troop_tier];
    NSString *r_killed = [NSString stringWithFormat:@"rk2_%@", troop_tier];
    NSInteger int_r_total = [self.reportData[r_total] integerValue];
    NSInteger int_r_killed = [self.reportData[r_killed] integerValue];
    if ((int_r_total > 0) || (int_r_killed > 0))
    {
        row1 = @{@"i1": i1, @"r1": troop_name, @"c1": [[Globals i] intString:int_r_total], @"e1": [[Globals i] intString:int_r_killed], @"c1_color": @"0", @"e1_color": @"1", @"c1_align": @"2", @"c1_ratio": @"3", @"e1_align": @"2"};
    }
    
    return row1;
}

- (NSMutableArray *)troopList:(NSString *)prefix
{
    return [self troopList:prefix :@"0" :0];
}

- (NSMutableArray *)troopList:(NSString *)prefix :(NSString *)color :(NSInteger)min_value_show
{
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    NSDictionary *a1 = [self troopRow:prefix :@"a1" :color :min_value_show];
    if (a1 != nil)
    {
        [rows1 addObject:a1];
    }
    NSDictionary *a2 = [self troopRow:prefix :@"a2" :color :min_value_show];
    if (a2 != nil)
    {
        [rows1 addObject:a2];
    }
    NSDictionary *a3 = [self troopRow:prefix :@"a3" :color :min_value_show];
    if (a3 != nil)
    {
        [rows1 addObject:a3];
    }
    
    NSDictionary *b1 = [self troopRow:prefix :@"b1" :color :min_value_show];
    if (b1 != nil)
    {
        [rows1 addObject:b1];
    }
    NSDictionary *b2 = [self troopRow:prefix :@"b2" :color :min_value_show];
    if (b2 != nil)
    {
        [rows1 addObject:b2];
    }
    NSDictionary *b3 = [self troopRow:prefix :@"b3" :color :min_value_show];
    if (b3 != nil)
    {
        [rows1 addObject:b3];
    }
    
    NSDictionary *c1 = [self troopRow:prefix :@"c1" :color :min_value_show];
    if (c1 != nil)
    {
        [rows1 addObject:c1];
    }
    NSDictionary *c2 = [self troopRow:prefix :@"c2" :color :min_value_show];
    if (c2 != nil)
    {
        [rows1 addObject:c2];
    }
    NSDictionary *c3 = [self troopRow:prefix :@"c3" :color :min_value_show];
    if (c3 != nil)
    {
        [rows1 addObject:c3];
    }
    
    NSDictionary *d1 = [self troopRow:prefix :@"d1" :color :min_value_show];
    if (d1 != nil)
    {
        [rows1 addObject:d1];
    }
    NSDictionary *d2 = [self troopRow:prefix :@"d2" :color :min_value_show];
    if (d2 != nil)
    {
        [rows1 addObject:d2];
    }
    NSDictionary *d3 = [self troopRow:prefix :@"d3" :color :min_value_show];
    if (d3 != nil)
    {
        [rows1 addObject:d3];
    }
    
    return rows1;
}

- (NSDictionary *)troopRow:(NSString *)prefix :(NSString *)troop_tier
{
    return [self troopRow:prefix :troop_tier :@"0" :0];
}

- (NSDictionary *)troopRow:(NSString *)prefix :(NSString *)troop_tier :(NSString *)color :(NSInteger)min_value_show
{
    NSDictionary *row1 = nil;
    
    NSString *troop_name = [[Globals i] valueForKey:troop_tier];
    NSString *i1 = [NSString stringWithFormat:@"icon_%@", troop_tier];
    NSString *total = [NSString stringWithFormat:@"%@_%@", prefix, troop_tier];
    NSInteger int_total = [self.reportData[total] integerValue];
    
    if (int_total > min_value_show-1)
    {
        row1 = @{@"i1": i1, @"r1": troop_name, @"c1": [[Globals i] intString:int_total], @"c1_color": color, @"c1_align": @"2", @"c1_ratio": @"3"};
    }
    
    return row1;
}

- (void)button1_tap:(id)sender //Revenge
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    NSInteger r1_button = [[self.rows[section][row] objectForKey:@"r1_button"] integerValue];
    
    if (r1_button > 1)
    {
        NSString *id_enemy = @"1";
        if ([self.reportData[@"profile1_id"] isEqualToString:[Globals i].wsWorldProfileDict[@"profile_id"]])
        {
            id_enemy = @"2";
        }
        
        NSString *profile_id = [NSString stringWithFormat:@"profile%@_id", id_enemy];
        NSString *base_id = [NSString stringWithFormat:@"profile%@_base_id", id_enemy];
        NSString *base_name = [NSString stringWithFormat:@"profile%@_base_name", id_enemy];
        NSString *map_x = [NSString stringWithFormat:@"profile%@_x", id_enemy];
        NSString *map_y = [NSString stringWithFormat:@"profile%@_y", id_enemy];
        
        NSDictionary *baseDict = @{@"profile_id": self.reportData[profile_id], @"base_id": self.reportData[base_id], @"base_name": self.reportData[base_name], @"map_x": self.reportData[map_x], @"map_y": self.reportData[map_y], @"base_type": @"1"};
        
        if ([self.is_popup isEqualToString:@"1"])
        {
            [[Globals i] closeTemplate];
        }
        else
        {
            [[Globals i] closeAllTemplate];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowMap"
                                                                object:self];
        }
        
        [[Globals i] doAttack:baseDict];
    }
}

- (void)deleteReport
{
    [[Globals i] deleteLocalReport:self.reportData[@"report_id"]];
    
    [[Globals i] closeTemplate];
    
    [[Globals i] showToast:@"Report Deleted!"
             optionalTitle:nil
             optionalImage:@"icon_check"];
}

- (void)button2_tap:(id)sender //Delete
{
    [[Globals i] showDialogBlock:@"Are you sure you want to delete this report?"
                                :2
                                :^(NSInteger index, NSString *text)
     {
         if (index == 1) //YES
         {
             [self deleteReport];
         }
     }];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    return (self.rows)[indexPath.section][indexPath.row];
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:self.frame_width];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:self.frame_width];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == [self.rows count]-1)
    {
        if ([self.is_popup isEqualToString:@"1"])
        {
            return nil;
        }
        else
        {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame_width, TABLE_HEADER_VIEW_HEIGHT)];
            [headerView setBackgroundColor:[UIColor blackColor]];
            
            CGFloat button_width = 280.0f*SCALE_IPAD;
            CGFloat button_height = 44.0f*SCALE_IPAD;
            CGFloat button_x = (self.frame_width - button_width)/2;
            CGFloat button_y = (TABLE_HEADER_VIEW_HEIGHT - button_height);
            
            UIButton *button1 = [[Globals i] dynamicButtonWithTitle:@"Delete this Report"
                                                             target:self
                                                           selector:@selector(button2_tap:)
                                                              frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                               type:@"2"];
            
            [headerView addSubview:button1];
            
            return headerView;
        }
    }
    else
    {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [self.rows count]-1)
    {
        if ([self.is_popup isEqualToString:@"1"])
        {
            return 0.0f;
        }
        else
        {
            return TABLE_FOOTER_VIEW_HEIGHT;
        }
    }
    else
    {
        return 0.0f;
    }
}

@end
