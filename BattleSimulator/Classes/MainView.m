//
//  MainView.m
//  Battle Simulator
//
//  Created by Shankar on 6/3/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "MainView.h"
#import "Globals.h"

#import "ReportView.h"
#import "ReportDetail.h"
#import "SendTroops.h"
#import "TabView.h"

@interface MainView ()

@property (nonatomic, strong) NSMutableArray *rows;

@property (nonatomic, strong) ReportView *reportView;
@property (nonatomic, strong) ReportDetail *reportDetail;
@property (nonatomic, strong) TabView *itemsTabView;

@property (nonatomic, strong) SendTroops *stAttacker;
@property (nonatomic, strong) SendTroops *stDefender;
@property (nonatomic, strong) SendTroops *stReinforcements;

@property (nonatomic, assign) BOOL isShowingLogin;

@end

@implementation MainView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
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

- (void)startUp //Called when app opens for the first time
{
    self.title = @"MainView";
    
    self.isShowingLogin = NO;
    [[Globals i] pushViewControllerStack:self];
    
    [[Globals i] setUID:@"G1350425862"]; //profile_id = 1
    //[[Globals i] setUID:@"G1206221558"]; //profile_id = 2
    
    [self updateView];
}

- (void)updateView
{
    [self setupDefender];
    [self setupReinforcements];
    [self setupAttacker];
    
    self.rows = nil;
    [self.tableView reloadData];
    
    NSMutableDictionary *row101 = [@{@"r1": @"Kingdoms: Battle Simulator", @"r1_bold": @"1", @"r1_color": @"2", @"nofooter": @"1"} mutableCopy];
    NSMutableArray *rows1 = [@[row101] mutableCopy];
    
    NSMutableDictionary *row102 = [@{@"r1": @" ", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row102];
    
    NSMutableDictionary *row103 = [@{@"r1": @"Is NPC", @"r1_bold": @"1", @"r1_color": @"2", @"r2": @"Disabled", @"r2_color": @"0", @"c1": @" ", @"c1_button": @"off", @"c1_ratio": @"3", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row103];
    
    NSMutableDictionary *row104 = [@{@"r1": @"Trying Capture", @"r1_bold": @"1", @"r1_color": @"2", @"r2": @"Disabled", @"r2_color": @"0", @"c1": @" ", @"c1_button": @"off", @"c1_ratio": @"3", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row104];
    
    NSMutableDictionary *row105 = [@{@"r1": @"Capital City", @"r1_bold": @"1", @"r1_color": @"2", @"r2": @"Disabled", @"r2_color": @"0", @"c1": @" ", @"c1_button": @"off", @"c1_ratio": @"3", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row105];
    
    NSMutableDictionary *row106 = [@{@"r1": @"Set Attacker Troops", @"r1_button": @"3", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row106];
    
    NSMutableDictionary *row107 = [@{@"r1": @"Set Defender Troops", @"r1_button": @"3", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row107];
    
    NSMutableDictionary *row108 = [@{@"r1": @"Set Reinforcements Troops", @"r1_button": @"3", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row108];
    
    NSMutableDictionary *row109 = [@{@"r1": @"Attack Now", @"r1_button": @"2", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row109];
    
    NSMutableDictionary *row110 = [@{@"r1": @"View Reports", @"r1_button": @"4", @"nofooter": @"1"} mutableCopy];
    [rows1 addObject:row110];
    
    self.rows = [@[rows1] mutableCopy];
    
    NSInteger row = 2;
    if ([[self is_npc] isEqualToString:@"1"])
    {
        [self.rows[0][row] setValue:@"Enabled" forKey:@"r2"];
        [self.rows[0][row] setValue:@"6" forKey:@"r2_color"];
        [self.rows[0][row] setValue:@"on" forKey:@"c1_button"];
    }
    else
    {
        [self.rows[0][row] setValue:@"Disabled" forKey:@"r2"];
        [self.rows[0][row] setValue:@"1" forKey:@"r2_color"];
        [self.rows[0][row] setValue:@"off" forKey:@"c1_button"];
    }
    
    row = 3;
    if ([[self is_capture] isEqualToString:@"1"])
    {
        [self.rows[0][row] setValue:@"Enabled" forKey:@"r2"];
        [self.rows[0][row] setValue:@"6" forKey:@"r2_color"];
        [self.rows[0][row] setValue:@"on" forKey:@"c1_button"];
    }
    else
    {
        [self.rows[0][row] setValue:@"Disabled" forKey:@"r2"];
        [self.rows[0][row] setValue:@"1" forKey:@"r2_color"];
        [self.rows[0][row] setValue:@"off" forKey:@"c1_button"];
    }
    
    row = 4;
    if ([[self is_capital] isEqualToString:@"1"])
    {
        [self.rows[0][row] setValue:@"Enabled" forKey:@"r2"];
        [self.rows[0][row] setValue:@"6" forKey:@"r2_color"];
        [self.rows[0][row] setValue:@"on" forKey:@"c1_button"];
    }
    else
    {
        [self.rows[0][row] setValue:@"Disabled" forKey:@"r2"];
        [self.rows[0][row] setValue:@"1" forKey:@"r2_color"];
        [self.rows[0][row] setValue:@"off" forKey:@"c1_button"];
    }
    
    [self.tableView reloadData];
}

- (void)showReport
{
    if (self.reportView == nil)
    {
        self.reportView = [[ReportView alloc] initWithStyle:UITableViewStylePlain];
    }
    self.reportView.title = @"Reports";
    
    [[Globals i] showTemplate:@[self.reportView] :self.reportView.title :0];
    [self.reportView updateView];
}

- (void)setupDefender
{
    if (self.stDefender == nil)
    {
        self.stDefender = [[SendTroops alloc] initWithStyle:UITableViewStylePlain];
        
        self.stDefender.input_type = @"2";
        self.stDefender.title = @"defender";
        [self.stDefender updateView];
    }
}

- (void)showDefender
{
    [[Globals i] showTemplate:@[self.stDefender] :self.stDefender.title :0];
}

- (void)setupReinforcements
{
    if (self.stReinforcements == nil)
    {
        self.stReinforcements = [[SendTroops alloc] initWithStyle:UITableViewStylePlain];
        
        self.stReinforcements.input_type = @"3";
        self.stReinforcements.title = @"reinforcements";
        [self.stReinforcements updateView];
    }
}

- (void)showReinforcements
{
    [[Globals i] showTemplate:@[self.stReinforcements] :self.stReinforcements.title :0];
}

- (void)setupAttacker
{
    if (self.stAttacker == nil)
    {
        self.stAttacker = [[SendTroops alloc] initWithStyle:UITableViewStylePlain];
        
        self.stAttacker.input_type = @"1";
        self.stAttacker.title = @"attacker";
        [self.stAttacker updateView];
    }
}

- (void)showAttacker
{
    [[Globals i] showTemplate:@[self.stAttacker] :self.stAttacker.title :0];
}

- (NSString	*)is_npc
{
    NSString *is_npc = [[NSUserDefaults standardUserDefaults] objectForKey:@"is_npc"];
    
    if (is_npc == nil)
    {
        is_npc = @"0";
    }
    
    return is_npc;
}

- (void)is_npc_yes
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_npc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)is_npc_no
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_npc"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString	*)is_capture
{
    NSString *is_capture = [[NSUserDefaults standardUserDefaults] objectForKey:@"is_capture"];
    
    if (is_capture == nil)
    {
        is_capture = @"0";
    }
    
    return is_capture;
}

- (void)is_capture_yes
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_capture"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)is_capture_no
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"is_capture"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString	*)is_capital
{
    NSString *is_capital = [[NSUserDefaults standardUserDefaults] objectForKey:@"is_capital"];
    
    if (is_capital == nil)
    {
        is_capital = @"1";
    }
    
    return is_capital;
}

- (void)is_capital_yes
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"is_capital"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)is_capital_no
{
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"is_capital"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    //NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    if (row == 5)
    {
        [self showAttacker];
    }
    else if (row == 6)
    {
        [self showDefender];
    }
    else if (row == 7)
    {
        [self showReinforcements];
    }
    else if (row == 8)
    {
        [self postAttackFormula];
    }
    else if (row == 9)
    {
        [self showReport];
    }
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    //NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    
    if (row == 2)
    {
        if ([self.rows[0][row][@"r2"] isEqualToString:@"Enabled"])
        {
            [self is_npc_no];
        }
        else
        {
            [self is_npc_yes];
        }
    }
    else if (row == 3)
    {
        if ([self.rows[0][row][@"r2"] isEqualToString:@"Enabled"])
        {
            [self is_capture_no];
        }
        else
        {
            [self is_capture_yes];
        }
    }
    else if (row == 4)
    {
        if ([self.rows[0][row][@"r2"] isEqualToString:@"Enabled"])
        {
            [self is_capital_no];
        }
        else
        {
            [self is_capital_yes];
        }
    }
    
    [self updateView];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = (self.rows)[indexPath.section][indexPath.row];
    
    return rowData;
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
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
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)postAttackFormula
{
    NSDictionary *p0_dict = [NSDictionary dictionaryWithObjectsAndKeys:
                             [self is_capture],
                             @"is_capture",
                             [self is_npc],
                             @"is_npc",
                             [self is_capital],
                             @"p2_base_type",
                             nil];
    NSDictionary *p1_dict = [[NSDictionary alloc] initWithDictionary:self.stAttacker.sel_dict copyItems:YES];
    NSDictionary *p2_dict = [[NSDictionary alloc] initWithDictionary:self.stDefender.sel_dict copyItems:YES];
    NSDictionary *p3_dict = [[NSDictionary alloc] initWithDictionary:self.stReinforcements.sel_dict copyItems:YES];
    
    NSMutableDictionary *dict = [p0_dict mutableCopy];
    [dict addEntriesFromDictionary:p1_dict];
    [dict addEntriesFromDictionary:p2_dict];
    [dict addEntriesFromDictionary:p3_dict];
    
    NSString *serviceName = @"AttackFormula";
    
    [[Globals i] postServerLoading:dict :serviceName :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{// IMPORTANT - Only update the UI on the main thread
             
             if (success)
             {
                 NSString *returnValue = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 if([returnValue isEqualToString:@"1"]) //Stored Proc Success
                 {
                     [self showReport];
                 }
                 else //Web Service Return 0
                 {
                     if (returnValue != nil)
                     {
                         if (DEBUG)
                         {
                             [[Globals i] showIIS_error:returnValue];
                         }
                         else
                         {
                             [[Globals i] showDialogFail];
                         }
                         [[Globals i] trackEvent:returnValue action:serviceName label:@"uid"];
                     }
                     else
                     {
                         [[Globals i] showDialogError];
                         [[Globals i] trackEvent:@"WS Return 0" action:serviceName label:@"uid"];
                     }
                 }
                 
             }
             else
             {
                 [[Globals i] showDialogError];
             }
         });
     }];
}



@end
