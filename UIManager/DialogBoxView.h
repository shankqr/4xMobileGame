//
//  DialogBoxView.h
//  4x MMO Mobile Strategy Game
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 11/19/09.
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

#import <UIKit/UIKit.h>

typedef void (^DialogBlock)(NSInteger index, NSString *text);

@interface DialogBoxView : UITableViewController

@property (nonatomic, strong) DialogBlock dialogBlock;
@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *displayText;

@property (nonatomic, assign) NSInteger dialogType;

- (void)updateView;

@end
