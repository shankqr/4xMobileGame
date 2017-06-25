//
//  LogView.h
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

@interface LogView : UIViewController
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

- (void)updateView:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid;

@end