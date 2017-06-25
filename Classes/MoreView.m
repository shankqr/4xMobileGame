//
//  MoreView.m
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

#import "MoreView.h"
#import "Globals.h"
#import "MainCell.h"

@interface MoreView ()

@property (nonatomic, strong) MainCell *cell;

@end

@implementation MoreView


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    [self updateView];
}

- (void)updateView
{
    NSDictionary *row0 = @{@"r1": [NSString stringWithFormat:NSLocalizedString(@"Logged in as %@ on %@. To learn more about the game please go to Help", nil), Globals.i.get_signin_name, Globals.i.wsProfileDict[@"server_webservice"]], @"bkg_prefix": @"bkg1", @"nofooter": @"1", @"r1_color": @"2", @"r1_align": @"1", @"r1_bold": @"1"};
    NSArray *rows1 = @[row0];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
    
	[self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [DynamicCell dynamicCell:self.tableView rowData:self.ui_cells_array[0][0] cellWidth:CELL_CONTENT_WIDTH];
    }
    else
    {
        self.cell = (MainCell *)[tableView dequeueReusableCellWithIdentifier:@"MainCell"];
        if (self.cell == nil)
        {
            self.cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MainCell"];
            [self.cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        
        return self.cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return [DynamicCell dynamicCellHeight:self.ui_cells_array[0][0] cellWidth:CELL_CONTENT_WIDTH];
    }
    else
    {
        return MOREVIEW_HEIGHT;
    }
}

@end
