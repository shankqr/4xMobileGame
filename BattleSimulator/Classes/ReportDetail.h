//
//  ReportDetail.h
//  Battle Simulator
//
//  Created by Shankar on 3/24/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

@interface ReportDetail : UITableViewController

@property (nonatomic, strong) NSDictionary *rowData;
@property (nonatomic, strong) NSDictionary *reportData;
@property (nonatomic, strong) NSString *is_popup;

- (void)updateView;

@end
