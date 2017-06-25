//
//  SearchView.m
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

#import "SearchView.h"
#import "Globals.h"

@interface SearchView ()

@property (nonatomic, strong) UISearchBar *searchBar1;

@end

@implementation SearchView

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
    
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       searchText];
    
    [Globals.i getServerLoading:self.serviceName :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 for (NSDictionary *row1 in returnArray)
                 {
                     NSString *r1_icon;
                     if ([row1[@"alliance_rank"] integerValue] > 0)
                     {
                         r1_icon = [NSString stringWithFormat:@"rank_%@", row1[@"alliance_rank"]];
                     }
                     else
                     {
                         r1_icon = @"";
                     }
                     
                     NSString *r1 = row1[@"profile_name"];
                     if ([row1[@"alliance_tag"] length] > 2)
                     {
                         r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
                     }
                     
                     NSString *r2 = [NSString stringWithFormat:NSLocalizedString(@"%@  Kills:%@", nil), [Globals.i autoNumber:row1[@"xp"]], [Globals.i autoNumber:row1[@"kills"]]];
                     NSString *r2_icon = @"icon_power";
                     NSDictionary *row101 = @{@"profile_id": row1[@"profile_id"], @"r1": r1, @"r1_bold": @"1", @"r1_icon": r1_icon, @"r2": r2, @"r2_icon": r2_icon, @"r2_align": @"1", @"i1": [NSString stringWithFormat:@"face_%@", row1[@"profile_face"]], @"i1_aspect": @"1", @"i2": @"arrow_right"};
                     
                     [rows1 addObject:row101];
                 }
             }
             else
             {
                 NSDictionary *row101 = @{@"profile_id": @"0", @"r1": NSLocalizedString(@"No Match Found", nil), @"r1_align": @"1", @"nofooter": @"1"};
                 
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
    if (indexPath.row > -1)
    {
        NSDictionary *rowData = self.ui_cells_array[indexPath.section][indexPath.row];
        
        NSString *selected_profileid = rowData[@"profile_id"];
        
        if (![selected_profileid isEqualToString:@"0"])
        {
            NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
            [userInfo setObject:selected_profileid forKey:@"profile_id"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
    
    return nil;
}

@end
