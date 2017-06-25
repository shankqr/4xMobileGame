//
//  AllianceDescription
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 4/14/14.
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

#import "AllianceDescription.h"
#import "Globals.h"

@interface AllianceDescription ()


@property (nonatomic, assign) CGFloat first_row_height;

@end

@implementation AllianceDescription

- (void)updateView
{
    self.first_row_height = 0.0f;
    self.ui_cells_array = nil;
    [self.tableView reloadData];
    
    NSDictionary *row101 = @{@"r1": NSLocalizedString(@"Alliance Description", nil), @"r1_align": @"1", @"r1_color": @"2", @"r1_bkg": @"bkg2", @"nofooter": @"1"};
    NSDictionary *row102 = @{@"r1": self.aAlliance.alliance_description, @"nofooter": @"1"};
    
	NSArray *rows1 = @[row101, row102];
    
    self.ui_cells_array = [@[rows1] mutableCopy];
	
	[self.tableView reloadData];
    [self.tableView flashScrollIndicators];
}

- (void)applyAlliance
{
    NSString *profile_uid = Globals.i.UID;
    NSString *service_name = @"AllianceApply";
    NSString *wsurl = [NSString stringWithFormat:@"/%@/%@",
                       self.aAlliance.alliance_id, profile_uid];
    
    [Globals.i getSpLoading:service_name :wsurl :^(BOOL success, NSData *data)
     {
         if (success)
         {
             [Globals.i allianceApply:self.aAlliance.alliance_id];
             [self updateView];
             
             [Globals.i trackEvent:@"Alliance Applied"];
             
             [UIManager.i showDialog:NSLocalizedString(@"A request to join has been sent to the Leader. You will be informed once accepted.", nil) title:@"AllianceRequestSent"];
         }
     }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cell_height = [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    if (indexPath.row == 0)
    {
        self.first_row_height = cell_height;
    }
    
    CGFloat min_height = self.tableView.frame.size.width - self.first_row_height - TABLE_HEADER_VIEW_HEIGHT*2;
    
    if ((cell_height < min_height) && (indexPath.row > 0))
    {
        cell_height = min_height;
    }
    
	return cell_height;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    if(![self.aAlliance.alliance_id isEqualToString:Globals.i.wsWorldProfileDict[@"alliance_id"]])
    {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, TABLE_HEADER_VIEW_HEIGHT)];
        [headerView setBackgroundColor:[UIColor blackColor]];
        
        CGFloat button_width = 280.0f*SCALE_IPAD;
        CGFloat button_height = 44.0f*SCALE_IPAD;
        CGFloat button_x = (UIScreen.mainScreen.bounds.size.width - button_width)/2;
        CGFloat button_y = (TABLE_HEADER_VIEW_HEIGHT - button_height);
        
        UIButton *button1;
        
        if ([Globals.i is_allianceApplied:self.aAlliance.alliance_id])
        {
            button1 = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"Applied", nil)
                                                   target:self
                                                 selector:nil
                                                    frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                     type:@"1"];
        }
        else
        {
            button1 = [UIManager.i dynamicButtonWithTitle:NSLocalizedString(@"Apply Now", nil)
                                                   target:self
                                                 selector:@selector(button1_tap:)
                                                    frame:CGRectMake(button_x, button_y, button_width, button_height)
                                                     type:@"2"];
        }
        
        [headerView addSubview:button1];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(![self.aAlliance.alliance_id isEqualToString:Globals.i.wsWorldProfileDict[@"alliance_id"]])
    {
        return TABLE_FOOTER_VIEW_HEIGHT;
    }
    else
    {
        return 0.0f;
    }
}

- (void)button1_tap:(id)sender
{
    NSInteger a_id = [Globals.i.wsWorldProfileDict[@"alliance_id"] integerValue];
    if (a_id > 0)
    {
        NSString *dialog_text = NSLocalizedString(@"You are currently member of an other Alliance. If your application is successfull you will be automaticaly removed from your current Alliance to join this Alliance. Proceed?", nil);
        
        [UIManager.i showDialogBlock:dialog_text
                             title:@"ApplyAllianceConfirmation"
                                    type:2
                                    :^(NSInteger index, NSString *text)
         {
             if(index == 1) //YES
             {
                 [self applyAlliance];
             }
         }];
    }
    else
    {
        [self applyAlliance];
    }
}

@end
