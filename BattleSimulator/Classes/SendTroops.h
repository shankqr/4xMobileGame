//
//  SendTroops.h
//  Battle Simulator
//
//  Created by Shankar on 3/24/09.
//  Copyright 2017 Shankar Nathan. All rights reserved.
//

@interface SendTroops : UITableViewController

@property (nonatomic, strong) NSString *input_type;
@property (nonatomic, strong) NSMutableDictionary *sel_dict;

- (void)updateView;

@end
