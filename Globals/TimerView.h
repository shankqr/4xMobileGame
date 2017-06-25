//
//  TimerView.h
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

@interface TimerView : UIView

@property (nonatomic, strong) NSString *strJob;
@property (nonatomic, strong) NSString *base_id;

@property (nonatomic, assign) double TotalTimer;
@property (nonatomic, assign) double timer1;
//@property (nonatomic, assign) double action_time;

@property (nonatomic, assign) NSInteger tv_id;
@property (nonatomic, assign) BOOL will_return;
@property (nonatomic, assign) BOOL is_return;
@property (nonatomic, assign) BOOL is_action;
@property (nonatomic, assign) BOOL is_clone;

- (void)updateView;
- (void)updateNotifications:(NSInteger)speedup_time;

@end
