//
//  SendTroops.m
//  Battle Simulator
//
//  Created by Shankar on 3/24/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

#import "SendTroops.h"
#import "Globals.h"

@interface SendTroops ()

@property (nonatomic, strong) NSMutableArray *rows;

@property (nonatomic, assign) NSUInteger sel_value;

@end

@implementation SendTroops

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)updateView
{
    self.rows = nil;
    [self.tableView reloadData];
    
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    if ([self.input_type isEqualToString:@"1"])
    {
        self.sel_dict = [@{@"p1_research_life": @"0",
                           @"p1_hero_life": @"0",
                           @"p1_item_attack": @"0",
                           @"p1_research_attack": @"0",
                           @"p1_research_a_attack": @"0",
                           @"p1_research_b_attack": @"0",
                           @"p1_research_c_attack": @"0",
                           @"p1_research_d_attack": @"0",
                           @"p1_hero_attack": @"0",
                           @"p1_hero_a_attack": @"0",
                           @"p1_hero_b_attack": @"0",
                           @"p1_hero_c_attack": @"0",
                           @"p1_hero_d_attack": @"0",
                           @"p1_a1": @"0",
                           @"p1_b1": @"0",
                           @"p1_c1": @"0",
                           @"p1_d1": @"0",
                           @"p1_a2": @"0",
                           @"p1_b2": @"0",
                           @"p1_c2": @"0",
                           @"p1_d2": @"0",
                           @"p1_a3": @"0",
                           @"p1_b3": @"0",
                           @"p1_c3": @"0",
                           @"p1_d3": @"0"} mutableCopy];
        
        NSMutableDictionary *row101 = [@{@"type": @"p1_research_life", @"i1": @"tech_life", @"r1": @"Research Life", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row101];
        
        NSMutableDictionary *row102 = [@{@"type": @"p1_hero_life", @"i1": @"skill_life", @"r1": @"Hero Life", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row102];
        
        NSMutableDictionary *row103 = [@{@"type": @"p1_item_attack", @"i1": @"icon_attack", @"r1": @"Item Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row103];
        
        NSMutableDictionary *row104 = [@{@"type": @"p1_research_attack", @"i1": @"tech_attack", @"r1": @"Research Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row104];
        
        NSMutableDictionary *row105 = [@{@"type": @"p1_research_a_attack", @"i1": @"tech_a_attack", @"r1": @"Research Infantary Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row105];
        
        NSMutableDictionary *row106 = [@{@"type": @"p1_research_b_attack", @"i1": @"tech_b_attack", @"r1": @"Research Ranged Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row106];
        
        NSMutableDictionary *row107 = [@{@"type": @"p1_research_c_attack", @"i1": @"tech_c_attack", @"r1": @"Research Cavalry Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row107];
        
        NSMutableDictionary *row108 = [@{@"type": @"p1_research_d_attack", @"i1": @"tech_d_attack", @"r1": @"Research Siege Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row108];
        
        NSMutableDictionary *row109 = [@{@"type": @"p1_hero_attack", @"i1": @"skill_attack", @"r1": @"Hero Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row109];
        
        NSMutableDictionary *row110 = [@{@"type": @"p1_hero_a_attack", @"i1": @"skill_a_attack", @"r1": @"Hero Infantary Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row110];
        
        NSMutableDictionary *row111 = [@{@"type": @"p1_hero_b_attack", @"i1": @"skill_b_attack", @"r1": @"Hero Ranged Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row111];
        
        NSMutableDictionary *row112 = [@{@"type": @"p1_hero_c_attack", @"i1": @"skill_c_attack", @"r1": @"Hero Cavalry Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row112];
        
        NSMutableDictionary *row113 = [@{@"type": @"p1_hero_d_attack", @"i1": @"skill_d_attack", @"r1": @"Hero Siege Attack", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row113];
        
        NSMutableDictionary *row201 = [@{@"type": @"p1_a1", @"i1": @"icon_a1", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row201];
        
        NSMutableDictionary *row202 = [@{@"type": @"p1_a2", @"i1": @"icon_a2", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row202];
        
        NSMutableDictionary *row203 = [@{@"type": @"p1_a3", @"i1": @"icon_a3", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row203];
        
        NSMutableDictionary *row204 = [@{@"type": @"p1_b1", @"i1": @"icon_b1", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row204];
        
        NSMutableDictionary *row205 = [@{@"type": @"p1_b2", @"i1": @"icon_b2", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row205];
        
        NSMutableDictionary *row206 = [@{@"type": @"p1_b3", @"i1": @"icon_b3", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row206];
        
        NSMutableDictionary *row207 = [@{@"type": @"p1_c1", @"i1": @"icon_c1", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row207];
        
        NSMutableDictionary *row208 = [@{@"type": @"p1_c2", @"i1": @"icon_c2", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row208];
        
        NSMutableDictionary *row209 = [@{@"type": @"p1_c3", @"i1": @"icon_c3", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row209];
        
        NSMutableDictionary *row210 = [@{@"type": @"p1_d1", @"i1": @"icon_d1", @"r1": [NSString stringWithFormat:@"%@ (Seige)", [Globals i].d1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row210];
        
        NSMutableDictionary *row211 = [@{@"type": @"p1_d2", @"i1": @"icon_d2", @"r1": [NSString stringWithFormat:@"%@ (Siege)", [Globals i].d2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row211];
        
        NSMutableDictionary *row212 = [@{@"type": @"p1_d3", @"i1": @"icon_d3", @"r1": [NSString stringWithFormat:@"%@ (Siege)", [Globals i].d3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row212];
    }
    else if ([self.input_type isEqualToString:@"2"])
    {
        self.sel_dict = [@{@"p2_research_life": @"0",
                           @"p2_hero_life": @"0",
                           @"p2_item_defense": @"0",
                           @"p2_research_defense": @"0",
                           @"p2_hero_defense": @"0",
                           @"p2_wall": @"0",
                           @"p2_total_bases": @"0",
                           @"village_shared_defense_bonus": @"0",
                           @"p2_a1": @"0",
                           @"p2_b1": @"0",
                           @"p2_c1": @"0",
                           @"p2_d1": @"0",
                           @"p2_a2": @"0",
                           @"p2_b2": @"0",
                           @"p2_c2": @"0",
                           @"p2_d2": @"0",
                           @"p2_a3": @"0",
                           @"p2_b3": @"0",
                           @"p2_c3": @"0",
                           @"p2_d3": @"0"} mutableCopy];
        
        NSMutableDictionary *row101 = [@{@"type": @"p2_research_life", @"i1": @"tech_life", @"r1": @"Research Life", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row101];
        
        NSMutableDictionary *row102 = [@{@"type": @"p2_hero_life", @"i1": @"skill_life", @"r1": @"Hero Life", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row102];
        
        NSMutableDictionary *row103 = [@{@"type": @"p2_item_defense", @"i1": @"icon_defense", @"r1": @"Item Defense", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row103];
        
        NSMutableDictionary *row104 = [@{@"type": @"p2_research_defense", @"i1": @"tech_defense", @"r1": @"Research Defense", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row104];
        
        NSMutableDictionary *row105 = [@{@"type": @"p2_hero_defense", @"i1": @"skill_defense", @"r1": @"Hero Defense", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(100)} mutableCopy];
        [rows1 addObject:row105];
        
        NSMutableDictionary *row106 = [@{@"type": @"p2_wall", @"i1": @"icon_wall", @"r1": @"Wall Level", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(22)} mutableCopy];
        [rows1 addObject:row106];
        
        NSMutableDictionary *row107 = [@{@"type": @"p2_total_bases", @"i1": @"t72", @"r1": @"Total Vilages", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(22)} mutableCopy];
        [rows1 addObject:row107];
        
        NSMutableDictionary *row108 = [@{@"type": @"village_shared_defense_bonus", @"i1": @"t72", @"r1": @"Village Defense(shared)", @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(1000)} mutableCopy];
        [rows1 addObject:row108];
        
        NSMutableDictionary *row201 = [@{@"type": @"p2_a1", @"i1": @"icon_a1", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row201];
        
        NSMutableDictionary *row202 = [@{@"type": @"p2_a2", @"i1": @"icon_a2", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row202];
        
        NSMutableDictionary *row203 = [@{@"type": @"p2_a3", @"i1": @"icon_a3", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row203];
        
        NSMutableDictionary *row204 = [@{@"type": @"p2_b1", @"i1": @"icon_b1", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row204];
        
        NSMutableDictionary *row205 = [@{@"type": @"p2_b2", @"i1": @"icon_b2", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row205];
        
        NSMutableDictionary *row206 = [@{@"type": @"p2_b3", @"i1": @"icon_b3", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row206];
        
        NSMutableDictionary *row207 = [@{@"type": @"p2_c1", @"i1": @"icon_c1", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row207];
        
        NSMutableDictionary *row208 = [@{@"type": @"p2_c2", @"i1": @"icon_c2", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row208];
        
        NSMutableDictionary *row209 = [@{@"type": @"p2_c3", @"i1": @"icon_c3", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row209];
        
        NSMutableDictionary *row210 = [@{@"type": @"p2_d1", @"i1": @"icon_d1", @"r1": [NSString stringWithFormat:@"%@ (Seige)", [Globals i].d1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row210];
        
        NSMutableDictionary *row211 = [@{@"type": @"p2_d2", @"i1": @"icon_d2", @"r1": [NSString stringWithFormat:@"%@ (Siege)", [Globals i].d2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row211];
        
        NSMutableDictionary *row212 = [@{@"type": @"p2_d3", @"i1": @"icon_d3", @"r1": [NSString stringWithFormat:@"%@ (Siege)", [Globals i].d3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row212];
    }
    else if ([self.input_type isEqualToString:@"3"])
    {
        self.sel_dict = [@{@"r2_a1": @"0",
                           @"r2_b1": @"0",
                           @"r2_c1": @"0",
                           @"r2_d1": @"0",
                           @"r2_a2": @"0",
                           @"r2_b2": @"0",
                           @"r2_c2": @"0",
                           @"r2_d2": @"0",
                           @"r2_a3": @"0",
                           @"r2_b3": @"0",
                           @"r2_c3": @"0",
                           @"r2_d3": @"0"} mutableCopy];
        
        NSMutableDictionary *row201 = [@{@"type": @"r2_a1", @"i1": @"icon_a1", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row201];
        
        NSMutableDictionary *row202 = [@{@"type": @"r2_a2", @"i1": @"icon_a2", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row202];
        
        NSMutableDictionary *row203 = [@{@"type": @"r2_a3", @"i1": @"icon_a3", @"r1": [NSString stringWithFormat:@"%@ (Infantry)", [Globals i].a3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row203];
        
        NSMutableDictionary *row204 = [@{@"type": @"r2_b1", @"i1": @"icon_b1", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row204];
        
        NSMutableDictionary *row205 = [@{@"type": @"r2_b2", @"i1": @"icon_b2", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row205];
        
        NSMutableDictionary *row206 = [@{@"type": @"r2_b3", @"i1": @"icon_b3", @"r1": [NSString stringWithFormat:@"%@ (Ranged)", [Globals i].b3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row206];
        
        NSMutableDictionary *row207 = [@{@"type": @"r2_c1", @"i1": @"icon_c1", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row207];
        
        NSMutableDictionary *row208 = [@{@"type": @"r2_c2", @"i1": @"icon_c2", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row208];
        
        NSMutableDictionary *row209 = [@{@"type": @"r2_c3", @"i1": @"icon_c3", @"r1": [NSString stringWithFormat:@"%@ (Cavalry)", [Globals i].c3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row209];
        
        NSMutableDictionary *row210 = [@{@"type": @"r2_d1", @"i1": @"icon_d1", @"r1": [NSString stringWithFormat:@"%@ (Seige)", [Globals i].d1], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row210];
        
        NSMutableDictionary *row211 = [@{@"type": @"r2_d2", @"i1": @"icon_d2", @"r1": [NSString stringWithFormat:@"%@ (Siege)", [Globals i].d2], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row211];
        
        NSMutableDictionary *row212 = [@{@"type": @"r2_d3", @"i1": @"icon_d3", @"r1": [NSString stringWithFormat:@"%@ (Siege)", [Globals i].d3], @"r2_slider": @"0", @"s1": @"0", @"slider_max": @(9999)} mutableCopy];
        [rows1 addObject:row212];
    }
    
    NSDictionary *row107 = @{@"r1": @" ", @"nofooter": @"1", @"fit": @"1"};
    [rows1 addObject:row107];
    
    self.rows = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)slider1_change:(UISlider *)sender
{
    NSInteger row = sender.tag-101;
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] initWithDictionary:self.rows[0][row] copyItems:YES];
    self.sel_value = ((DCFineTuneSlider *)sender).selectedValue;
    
    [dict1 setValue:@(self.sel_value) forKey:@"s1"];
    
    [self.rows[0] removeObjectAtIndex:row];
    [self.rows[0] insertObject:dict1 atIndex:row];
    
    [self.sel_dict setValue:@(self.sel_value) forKey:dict1[@"type"]];
    
    [self updateSendHeader];
}

- (void)updateSendHeader
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.sel_dict forKey:@"sel_dict"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateSendHeader"
                                                        object:self
                                                      userInfo:userInfo];
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSDictionary *rowData = (self.rows)[indexPath.section][indexPath.row];
    
    return rowData;
}

#pragma mark Table Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [(UISlider *)dcell.cellview.rv_a.slider addTarget:self action:@selector(slider1_change:) forControlEvents:UIControlEventValueChanged];
    ((UISlider *)dcell.cellview.rv_a.slider).tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
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

@end
