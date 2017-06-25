//
//  ResearchView.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 10/20/13.
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

#import "ResearchView.h"
#import "Globals.h"
#import "TechList.h"

@interface ResearchView ()

@property (nonatomic, strong) NSString *building_id;
@property (nonatomic, strong) TimerView *tv_view;
@property (nonatomic, strong) UIView *blockView;
@property (nonatomic, strong) TechList *techList;

@end

@implementation ResearchView

- (void)notificationRegister
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"CloseTemplateBefore"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"TimerViewEnd"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"UpdateResearchView"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationReceived:)
                                                 name:@"ChooseTechArea"
                                               object:nil];

}

- (void)notificationReceived:(NSNotification *)notification
{
    if ([[notification name] isEqualToString:@"CloseTemplateBefore"])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *view_title = [userInfo objectForKey:@"view_title"];
        
        if ([self.title isEqualToString:view_title])
        {
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
    }
    else if ([[notification name] isEqualToString:@"TimerViewEnd"] || [[notification name] isEqualToString:@"UpdateResearchView"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *tv_id = [userInfo objectForKey:@"tv_id"];
            
            if ([tv_id integerValue] == TV_RESEARCH)
            {
                [self updateView];
            }
        }
    }
    if ([[notification name] isEqualToString:@"ChooseTechArea"])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if (userInfo != nil)
        {
            NSNumber *techArea_index = [userInfo objectForKey:@"tech_area"];
            
            NSLog(@"techArea_index : %@",techArea_index);
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[techArea_index intValue]+1 inSection:0];
            
            DynamicCell *customCellView = (DynamicCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            NSLog(@"customCellView TechArea : %@",customCellView);
            
            
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self.tableView.delegate tableView:self.tableView willSelectRowAtIndexPath:indexPath];

        }
    }

}

- (void)updateView
{
    [self notificationRegister];
    
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    self.building_id = @"15";
    
    self.tv_view = [Globals.i copyTvViewFromStack:TV_RESEARCH];
    
    NSDictionary *row101 = @{@"r1": [Globals.i getBuildingDict:self.building_id][@"info_chart"], @"r1_align": @"1", @"r1_bold": @"1", @"r1_color": @"2", @"bkg_prefix": @"bkg1", @"nofooter": @"1"};
    
    NSDictionary *row102 = @{@"i1": @"research_city", @"r1": NSLocalizedString(@"City", nil), @"r1_bold": @"1", @"n1_width": @"50", @"i2": @"arrow_right"};

    NSDictionary *row103 = @{@"i1": @"research_economics", @"r1": NSLocalizedString(@"Economics", nil), @"r1_bold": @"1", @"n1_width": @"50", @"i2": @"arrow_right"};

    NSDictionary *row104 = @{@"i1": @"research_military", @"r1": NSLocalizedString(@"Military", nil), @"r1_bold": @"1", @"n1_width": @"50", @"i2": @"arrow_right"};

    NSDictionary *row105 = @{@"i1": @"research_combat", @"r1": NSLocalizedString(@"Combat", nil), @"r1_bold": @"1", @"n1_width": @"50", @"i2": @"arrow_right"};

    NSDictionary *row106 = @{@"i1": @"research_troops", @"r1": NSLocalizedString(@"Troops", nil), @"r1_bold": @"1", @"n1_width": @"50", @"i2": @"arrow_right"};
    
    NSDictionary *row107 = @{@"r1": @" ", @"nofooter": @"1"};
    NSDictionary *row108 = @{@"r1": NSLocalizedString(@"More Information", nil), @"r1_button": @"2", @"nofooter": @"1"};

    NSMutableArray *rows1 = [@[row101, row102, row103, row104, row105, row106, row107, row108] mutableCopy];
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
    
    //Block it if its researching
    if (self.tv_view != nil)
    {
        if (self.blockView == nil)
        {
            self.blockView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, TABLE_HEADER_VIEW_HEIGHT, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height)];
            [self.blockView setBackgroundColor:[UIColor blackColor]];
            [self.blockView setAlpha:0.75f];
        }
        else
        {
            [self.blockView removeFromSuperview];
        }
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView setScrollEnabled:NO];
        [self.tableView addSubview:self.blockView];
    }
    else
    {
        if (self.blockView != nil)
        {
            [self.blockView removeFromSuperview];
        }
        
        [self.tableView setScrollEnabled:YES];
    }

}

- (void)button1_tap:(id)sender
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:self.building_id forKey:@"building_id"];
    [userInfo setObject:@(self.level) forKey:@"building_level"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowBuildingChart"
                                                        object:self
                                                      userInfo:userInfo];
}

- (void)button2_tap:(id)sender
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row > 0) && (indexPath.row < [self.ui_cells_array[0] count]))
    {
        if (self.techList == nil)
        {
            self.techList = [[TechList alloc] initWithStyle:UITableViewStylePlain];
        }
        self.techList.title = NSLocalizedString(@"Tech List", nil);
        [UIManager.i showTemplate:@[self.techList] :self.techList.title];
        
        self.techList.building_level = self.level;
        self.techList.tech_type = indexPath.row-1;
        [self.techList updateView];
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    if (self.tv_view != nil && section == 0)
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, TABLE_HEADER_VIEW_HEIGHT)];
        [headerView setBackgroundColor:[UIColor blackColor]];
        [headerView addSubview:(UIView *)self.tv_view];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.tv_view != nil && section == 0)
    {
        return TABLE_HEADER_VIEW_HEIGHT;
    }
    else
    {
        return 0;
    }
}

@end
