//
//  SearchAlliance.m
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 3/24/09.
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

#import "SearchAlliance.h"
#import "Globals.h"

@interface SearchAlliance ()

@property (nonatomic, strong) UISearchBar *searchBar1;
@property (nonatomic, strong) NSMutableArray *array_alliance_object;

@end

@implementation SearchAlliance

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect search_frame = CGRectMake(0, 0, self.tableView.frame.size.width, 44*SCALE_IPAD);
    self.searchBar1 = [[UISearchBar alloc] initWithFrame:search_frame];
    self.searchBar1.delegate = self;
    self.searchBar1.showsCancelButton = YES;
    self.searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar1.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar1.barStyle = UIBarStyleBlack;
    self.searchBar1.backgroundColor = [UIColor clearColor];
    self.searchBar1.placeholder = NSLocalizedString(@"Search..", nil);
    [self.searchBar1 sizeToFit];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor whiteColor]];
    
    self.tableView.tableHeaderView = self.searchBar1;
}

#pragma mark UISearchDisplayController Delegate Methods
- (BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    if (searchBar.text.length > 2)
    {
        if (self.array_alliance_object == nil)
        {
            self.array_alliance_object = [[NSMutableArray alloc] init];
        }
        
        [self updateView:searchBar.text];
    }
    else
    {
        [UIManager.i showDialog:NSLocalizedString(@"Invalid search. Search should be at least 3 characters long.", nil) title:@"InvalidSearch"];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (void)updateView:(NSString *)searchText
{
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    NSString *service_name = @"GetSearchAlliance";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       searchText];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [self.array_alliance_object removeAllObjects];
             
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 for (NSDictionary *row1 in returnArray)
                 {
                     AllianceObject *aAlliance = [[AllianceObject alloc] initWithDictionary:row1];
                     [self.array_alliance_object addObject:aAlliance];
                     
                     NSString *r1 = row1[@"alliance_name"];
                     if ([row1[@"alliance_tag"] length] > 2)
                     {
                         r1 = [NSString stringWithFormat:@"%@[%@]", row1[@"alliance_name"], row1[@"alliance_tag"]];
                     }
                     NSString *r2 = [NSString stringWithFormat:@"Leader: %@", row1[@"leader_name"]];
                     NSString *b1 = row1[@"alliance_marquee"];
                     NSString *b1_bkg = @"bkg3";
                     NSString *b1_marquee = @"1";
                     NSString *i1 = [NSString stringWithFormat:@"a_logo_%@", row1[@"alliance_logo"]];
                     NSString *r1_icon = @"";
                     if (([row1[@"alliance_language"] integerValue] > 0) && ([row1[@"alliance_language"] integerValue] < 263))
                     {
                         r1_icon = [NSString stringWithFormat:@"flag_%@", row1[@"alliance_language"]];
                     }
                     
                     NSDictionary *row101 = @{@"alliance_id": row1[@"alliance_id"], @"i1": i1, @"i1_aspect": @"1", @"r1": r1, @"r1_bold": @"1", @"r1_icon": r1_icon, @"r2": r2, @"b1": b1, @"b1_marquee": b1_marquee, @"b1_color": @"2", @"b1_bkg": b1_bkg, @"i2": @"arrow_right", @"nofooter": @"1"};
                     NSDictionary *row102 = @{@"bkg_prefix": @"bkg1", @"r1_icon": @"icon_power", @"r1": [Globals.i autoNumber:row1[@"power"]], @"r1_color": @"2", @"r1_align": @"1", @"c1_icon": @"icon_kills", @"c1": [Globals.i autoNumber:row1[@"kills"]], @"c1_color": @"2", @"c1_align": @"1", @"c1_ratio": @"3", @"e1_icon": @"icon_members", @"e1": [NSString stringWithFormat:@"%@/%@0", row1[@"total_members"], row1[@"alliance_level"]], @"e1_color": @"2", @"e1_align": @"1"};
                     
                     [rows1 addObject:row101];
                     [rows1 addObject:row102];
                 }
             }
             else
             {
                 NSDictionary *row101 = @{@"r1": NSLocalizedString(@"No Match Found", nil), @"r1_align": @"1", @"nofooter": @"1"};
                 
                 [rows1 addObject:row101];
             }
             
             self.ui_cells_array = [@[rows1] mutableCopy];
             
             [self.tableView reloadData];
             [self.tableView flashScrollIndicators];
         }
     }];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row > -1) && (indexPath.row % 2 == 0) && ([self.array_alliance_object count] > 0)) //Even number rows
    {
        NSInteger index = indexPath.row / 2;
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.array_alliance_object[index] forKey:@"alliance_object"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowAllianceProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
    
    return nil;
}

@end
