//
//  LogView.m
//  Kingdom Game
//
//  Created by Shankar on 3/24/09.
//  Copyright 2010 TapFantasy. All rights reserved.
//

#import "LogView.h"
#import "Globals.h"

#define KEYBOARD_HEIGHT (iPad ? 264.0f : 216.0f)
#define TEXTBOX_HEIGHT 31.0f

@interface LogView ()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *allianceId;
@property (nonatomic, strong) NSString *postTable;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSString *selected_profileid;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, assign) Boolean keyboardIsShowing;
@property (nonatomic, assign) CGRect keyboardBounds;

@end

@implementation LogView

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    if (self.tableView == nil)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [self.tableView setBackgroundColor:[UIColor clearColor]];
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self.view addSubview:self.tableView];
    }
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
    
    if (self.textField == nil)
    {
        self.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        self.textField.borderStyle = UITextBorderStyleBezel;
        self.textField.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:self.textField];
    }
    self.textField.returnKeyType = UIReturnKeyDone;
    self.textField.autocorrectionType = UITextAutocorrectionTypeNo;
	self.textField.delegate = self;
    
    self.allianceId = @"0";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self keyboardWillHide];
    
    [self sendClicked];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.keyboardIsShowing)
    {
        self.keyboardIsShowing = YES;
        self.keyboardBounds = CGRectMake(0.0f, UIScreen.mainScreen.bounds.size.height, UIScreen.mainScreen.bounds.size.width, KEYBOARD_HEIGHT);

        [self resizeViewControllerToFitScreen];
        
        [self reloadTableView];
    }
}

- (void)keyboardWillHide
{
    [self.textField resignFirstResponder];
    
	self.keyboardIsShowing = NO;
	self.keyboardBounds = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
	[self resizeViewControllerToFitScreen];
}

- (void)resizeViewControllerToFitScreen
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.3f];
    
	if (self.keyboardIsShowing)
    {
        CGPoint p = [self.view convertPoint:self.view.frame.origin toView:[Globals.i firstViewControllerStack].view];
        
        float view_y = p.y;
        float bottom_offset = UIScreen.mainScreen.bounds.size.height - self.view.frame.size.height - view_y;
        float text_y = self.view.frame.size.height - TEXTBOX_HEIGHT - self.keyboardBounds.size.height + bottom_offset;
        
        self.tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, text_y);
        self.textField.frame = CGRectMake(0.0f, text_y, self.view.frame.size.width, TEXTBOX_HEIGHT);
    }
    else
    {
        self.tableView.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - TEXTBOX_HEIGHT);
        self.textField.frame = CGRectMake(0.0f, self.view.frame.size.height - TEXTBOX_HEIGHT, self.view.frame.size.width, TEXTBOX_HEIGHT);
    }
    
	[UIView commitAnimations];
}

- (void)updateView:(NSMutableArray *)ds table:(NSString *)tn a_id:(NSString *)aid
{
    self.rows = nil;
    [self.tableView reloadData];
    
    self.allianceId = aid;
    self.postTable = tn;
    self.dataSource = ds;
    
    self.messages = [[NSMutableArray alloc] init];
    
    self.keyboardIsShowing = NO;
    [self resizeViewControllerToFitScreen];
    
    [self refreshMessages];
    
    if ([self.allianceId isEqualToString:@"0"]) //Register to refresh events from Main
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refreshMessages)
                                                     name:@"UILog"
                                                   object:nil];
    }
}

- (void)sendClicked
{
	if ([self.textField.text length] > 0)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            Globals.i.wsWorldProfileDict[@"profile_id"],
                            @"profile_id",
                            Globals.i.wsWorldProfileDict[@"profile_name"],
                            @"profile_name",
                            Globals.i.wsWorldProfileDict[@"profile_face"],
                            @"profile_face",
                            Globals.i.wsWorldProfileDict[@"alliance_id"],
                            @"alliance_id",
                            Globals.i.wsWorldProfileDict[@"alliance_tag"],
                            @"alliance_tag",
                            Globals.i.wsWorldProfileDict[@"alliance_logo"],
                            @"alliance_logo",
                            self.textField.text,
                            @"message",
                            self.postTable,
                            @"table_name",
                            self.allianceId,
                            @"target_alliance_id",
                            nil];
        
        [Globals.i postServer:dict :@"PostChat" :^(BOOL success, NSData *data){}];
        
        //Show typed text instantly
        NSString *datenow = [Globals.i getServerDateTimeString];
        [dict addEntriesFromDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        datenow,
                                        @"date_posted", nil]];
        if (self.messages != nil)
        {
            [self.messages addObject:dict];
        }
        else
        {
            self.messages = [[NSMutableArray alloc] initWithObjects:dict, nil];
        }
        
        self.rows = [@[self.messages] mutableCopy];
        [self reloadTableView];
	}
    
	self.textField.text = @"";
}

- (void)refreshMessages
{
    NSLog(@"Log received in UI");
    if([self.dataSource count] > [self.messages count])
    {
        self.messages = [[NSMutableArray alloc] initWithArray:self.dataSource copyItems:YES];
        
        self.rows = [@[self.messages] mutableCopy];
        
        [self reloadTableView];
    }
}

- (void)reloadTableView
{
    [self.tableView reloadData];
    
    if ([self.messages count] > 0)
    {
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([self.messages count] - 1) inSection:0];
        if (scrollIndexPath != nil)
        {
            [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
}

- (NSDictionary *)getRowData:(NSIndexPath *)indexPath
{
    NSMutableDictionary *row101 = nil;
    
    if ([self.messages count] > 0)
    {
        NSDictionary *row1 = (self.messages)[indexPath.row];

        NSString *r1 = row1[@"profile_name"];
        if ([row1[@"alliance_tag"] length] > 2)
        {
            r1 = [NSString stringWithFormat:@"[%@]%@", row1[@"alliance_tag"], row1[@"profile_name"]];
        }
        NSString *r2 = row1[@"message"];
        NSString *i1 = @"";
        if (row1[@"profile_face"] != nil)
        {
            if ([row1[@"profile_face"] integerValue] > 0)
            {
                i1 = [NSString stringWithFormat:@"face_%@", row1[@"profile_face"]];
            }
        }
        
        NSString *b1 = @"";
        if (row1[@"date_posted"] != nil)
        {
            b1 = [Globals.i getTimeAgo:row1[@"date_posted"]];
        }
        
        row101 = [@{@"n1_width": @"50", @"r1": r1, @"r1_font": @"14.0", @"r1_bold": @"1", @"r2": r2, @"r2_font": @"14.0", @"b1": b1, @"b1_font": @"12.0", @"i1": i1, @"i1_aspect": @"1"} mutableCopy];
        
        if(![row1[@"profile_id"] isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]])
        {
            [row101 addEntriesFromDictionary:@{@"i1_h": @" "}];
        }
    }
    
    return row101;
}

- (void)img1_tap:(id)sender
{
    [Globals.i play_button];
    
    NSInteger i = [sender tag];
    NSInteger row = (i % 100) - 1;
    
    NSDictionary *rowData = self.messages[row];
    
    if(![rowData[@"profile_id"] isEqualToString:Globals.i.wsWorldProfileDict[@"profile_id"]])
    {
        self.selected_profileid = [[NSString alloc] initWithString:rowData[@"profile_id"]];
        
        if (self.keyboardIsShowing)
        {
            [self keyboardWillHide];
        }
        
        [Globals.i closeTemplate];
        
        //Show profile viewer
        NSMutableDictionary* userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:self.selected_profileid forKey:@"profile_id"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowProfile"
                                                            object:self
                                                          userInfo:userInfo];
    }
}

#pragma mark Table Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicCell *dcell = (DynamicCell *)[DynamicCell dynamicCell:self.tableView rowData:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
    
    [dcell.cellview.img1 addTarget:self action:@selector(img1_tap:) forControlEvents:UIControlEventTouchUpInside];
    dcell.cellview.img1.tag = (indexPath.section+1)*100 + (indexPath.row+1);
    
    return dcell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.rows count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rows[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DynamicCell dynamicCellHeight:[self getRowData:indexPath] cellWidth:CELL_CONTENT_WIDTH];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.keyboardIsShowing)
    {
        [self keyboardWillHide];
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	return nil;
}

@end