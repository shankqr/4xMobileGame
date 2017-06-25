//
//  BookmarkCreate
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 6/10/09.
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

#import "BookmarkCreate.h"
#import "Globals.h"

@interface BookmarkCreate ()

@property (nonatomic, strong) UITableViewCell *inputCell1;
@property (nonatomic, strong) UITextField *titleText;
@property (nonatomic, strong) NSString *selectedLabel;

@end

@implementation BookmarkCreate

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.selectedLabel = @"1";
}

- (void)updateView
{
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSString *r1 = [NSString stringWithFormat:@"Coordinates: X:%@ Y:%@", @(self.map_x), @(self.map_y)];

    NSMutableDictionary *row101 = [@{@"r1": self.title, @"r1_color": @"0", @"r1_align": @"1", @"r1_bold": @"1", @"nofooter": @"1"} mutableCopy];
    NSMutableDictionary *row102 = [@{@"r1": r1, @"r1_color": @"0", @"r1_align": @"1", @"nofooter": @"1", @"fit": @"1"} mutableCopy];
    NSMutableDictionary *row103 = [@{@"r1": @" ", @"nofooter": @"1"} mutableCopy];
    NSMutableDictionary *row104 = [@{@"r1": NSLocalizedString(@"Set Title", nil), @"r1_align": @"1", @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"} mutableCopy];
    NSMutableDictionary *row105 = [@{@"t1": self.defaultTitle, @"t1_keyboard": @"4", @"nofooter": @"1"} mutableCopy];
    NSMutableDictionary *row106 = [@{@"r1": NSLocalizedString(@"Choose Label", nil), @"r1_align": @"1", @"r1_color": @"0", @"nofooter": @"1", @"fit": @"1"} mutableCopy];
    NSMutableDictionary *row107 = [@{@"r1": @" ", @"c1": @" ", @"e1": @" ", @"r1_icon": @"bookmark_fav", @"c1_icon": @"bookmark_friend", @"e1_icon": @"bookmark_enemy", @"r1_align": @"1", @"c1_align": @"1", @"e1_align": @"1", @"r1_button": @"2", @"c1_button": @"2", @"e1_button": @"2", @"c1_ratio": @"3", @"nofooter": @"1"} mutableCopy];
    NSMutableDictionary *row108 = [@{@"r1": @" ", @"nofooter": @"1"} mutableCopy];
    
    NSMutableArray *rows1 = [@[row101, row102, row103, row104, row105, row106, row107, row108] mutableCopy];
    
    NSMutableDictionary *row201 = [@{@"r1": NSLocalizedString(@"Confirm", nil), @"r1_button": @"2", @"nofooter": @"1"} mutableCopy];
    NSMutableArray *rows2 = [@[row201] mutableCopy];
    
    self.ui_cells_array = [@[rows1, rows2] mutableCopy];
    
    if ([self.selectedLabel isEqualToString:@"1"])
    {
        [self.ui_cells_array[0][6] setValue:@"2" forKey:@"r1_button"];
    }
    else if ([self.selectedLabel isEqualToString:@"2"])
    {
        [self.ui_cells_array[0][6] setValue:@"2" forKey:@"c1_button"];
    }
    else if ([self.selectedLabel isEqualToString:@"3"])
    {
        [self.ui_cells_array[0][6] setValue:@"2" forKey:@"e1_button"];
    }
    
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)button1_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 201)
    {
        self.inputCell1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
        self.titleText = (UITextField *)[self.inputCell1 viewWithTag:6];
        NSString *str_title = self.titleText.text;
        
        if ([str_title isEqualToString:@""])
        {
            str_title = self.defaultTitle;
        }
        
        NSString *service_name = @"CreateBookmark";
        NSString *wsurl = [NSString stringWithFormat:@"/%@/%@/%@/%@/%@",
                           Globals.i.UID, str_title, self.selectedLabel, [@(self.map_x) stringValue], [@(self.map_y) stringValue]];
        
        [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 if (success)
                 {
                     [UIManager.i closeTemplate];
                     
                     [UIManager.i showToast:NSLocalizedString(@"Bookmark Created!", nil)
                              optionalTitle:@"BookmarkCreated"
                              optionalImage:@"icon_check"];
                 }
             });
         }];
    }
    else if (i == 107) //Fav
    {
        self.selectedLabel = @"1";
        [self updateView];
    }
}

- (void)button2_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 107) //Friend
    {
        self.selectedLabel = @"2";
        [self updateView];
    }
}

- (void)button3_tap:(id)sender
{
    NSInteger i = [sender tag];
    
    if (i == 107) //Enemy
    {
        self.selectedLabel = @"3";
        [self updateView];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:DIALOG_CELL_WIDTH];
    
    [dcell.cellview.rv_a.btn addTarget:self action:@selector(button1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_a.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_c.btn addTarget:self action:@selector(button2_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_c.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    [dcell.cellview.rv_e.btn addTarget:self action:@selector(button3_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.rv_e.btn.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

@end
