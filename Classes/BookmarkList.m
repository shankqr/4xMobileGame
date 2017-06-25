//
//  BookmarkList
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 10/23/13.
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

#import "BookmarkList.h"
#import "Globals.h"

@interface BookmarkList ()

@property (nonatomic, strong) NSMutableArray *array_bookmark;

@end

@implementation BookmarkList

- (void)updateView
{
    NSString *service_name = @"GetBookmarks";
    NSString *wsurl = [NSString stringWithFormat:@"/%@",
                       Globals.i.wsWorldProfileDict[@"profile_id"]];
    
    [Globals.i getServerLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
         if (success)
         {
             NSMutableArray *returnArray = [Globals.i customParser:data];
             
             if (returnArray.count > 0)
             {
                 self.array_bookmark = [[NSMutableArray alloc] initWithArray:returnArray copyItems:YES];
                 [self drawTable:[returnArray mutableCopy]];
             }
             else
             {
                 NSMutableArray *rows1 = [[NSMutableArray alloc] init];
                 NSDictionary *row101 = @{@"r1": NSLocalizedString(@"You have no Bookmarks!", nil), @"r1_align": @"1", @"nofooter": @"1"};
                 [rows1 addObject:row101];
                 
                 self.ui_cells_array = [@[rows1] mutableCopy];
                 [self.tableView reloadData];
             }
         }
        });
     }];
}

- (void)drawTable:(NSMutableArray *)ds
{
    NSMutableArray *rows1 = [[NSMutableArray alloc] init];
    
    for (NSDictionary *row1 in ds)
    {
        NSString *i1;
        if ([row1[@"label"] integerValue] == 1)
        {
            i1 = @"bookmark_fav";
        }
        else if ([row1[@"label"] integerValue] == 2)
        {
            i1 = @"bookmark_friend";
        }
        else if ([row1[@"label"] integerValue] == 3)
        {
            i1 = @"bookmark_enemy";
        }
        
        NSString *r1 = row1[@"title"];
        NSString *r2 = [NSString stringWithFormat:@"Location: X:%@ Y:%@", row1[@"map_x"], row1[@"map_y"]];
        
        NSString *r1_button = @"2";
        NSString *c1_button = @"2";
        
        NSDictionary *row101 = @{@"bookmark_id": row1[@"bookmark_id"], @"map_x": row1[@"map_x"], @"map_y": row1[@"map_y"], @"i1": i1, @"r1": r1, @"r2": r2, @"nofooter": @"1"};
        [rows1 addObject:row101];
        
        NSDictionary *row102 = @{@"r1": NSLocalizedString(@"Delete", nil), @"c1": NSLocalizedString(@"Go To", nil), @"r1_button": r1_button, @"c1_button": c1_button};
        [rows1 addObject:row102];
    }
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
    [self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)removeBookmarkRedraw:(NSString *)bookmark_id
{
    if ([self.array_bookmark count] > 0)
    {
        for (NSInteger i = 0; i < [self.array_bookmark count]; i++)
        {
            if ([self.array_bookmark[i][@"bookmark_id"] isEqualToString:bookmark_id])
            {
                [self.array_bookmark removeObjectAtIndex:i];
                i = i - 1;
            }
        }
        
        [self drawTable:self.array_bookmark];
    }
}

- (void)deleteBookmark:(NSString *)bookmark_id
{
    NSString *service_name = @"DeleteBookmark";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       Globals.i.UID, bookmark_id];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             if (success)
             {
                 [self removeBookmarkRedraw:bookmark_id];
                 
                 [UIManager.i showToast:NSLocalizedString(@"Bookmark Deleted!", nil)
                          optionalTitle:@"BookmarkDeleted"
                          optionalImage:@"icon_check"];
             }
         });
     }];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"r1_button"] integerValue];
    
    if ((button > 1) && (i > 101)) //Delete
    {
        NSString *selected_bookmark_id = self.ui_cells_array[section][row-1][@"bookmark_id"];
        if (selected_bookmark_id != nil)
        {
            [UIManager.i showDialogBlock:NSLocalizedString(@"Delete this bookmark?", nil)
                                 title:@"DeleteBookmarkConfirmation"
                                        type:2
                                        :^(NSInteger index, NSString *text)
             {
                 if (index == 1) //YES
                 {
                     [self deleteBookmark:selected_bookmark_id];
                 }
             }];
        }
    }
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    NSInteger section = (i / 100) - 1;
    NSInteger row = (i % 100) - 1;
    NSInteger button = [[self.ui_cells_array[section][row] objectForKey:@"c1_button"] integerValue];
    
    if ((button > 1) && (i > 101)) //Goto
    {
        NSString *str_x = self.ui_cells_array[section][row-1][@"map_x"];
        NSString *str_y = self.ui_cells_array[section][row-1][@"map_y"];
        if (str_x != nil && str_y != nil)
        {
            [UIManager.i closeTemplate];
            
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
            [userInfo setObject:str_x forKey:@"x"];
            [userInfo setObject:str_y forKey:@"y"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GotoTile"
                                                                object:self
                                                              userInfo:userInfo];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CHART_CELL_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
