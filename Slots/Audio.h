//
//  Audio.h
//  Liberty Bell
//
//  Created by Shankar Nathan (shankqr@gmail.com) on 5/26/13.
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

#import <AVFoundation/AVFoundation.h>

@interface Audio : NSObject
{
    NSMutableArray *backgroundMusic;
    int currentTrack;
    
    AVAudioPlayer *fxArmPulled;
    AVAudioPlayer *fxCheers;
    AVAudioPlayer *fxInsertCoin;
    AVAudioPlayer *fxJackpot;
    AVAudioPlayer *fxWinningCombination;
    AVAudioPlayer *fxReelClick;
    AVAudioPlayer *fxReelStop;

    NSMutableArray *fxCoinDropping;
    NSMutableArray *fxSlide;
    NSMutableArray *fxPop;
    NSMutableArray *fxWhoosh;
    NSMutableArray *fxAppear;
    
    int currentFxCoinDropping;
    int currentFxSlide;
    int currentFxPop;
    int currentFxWhoosh;
    int currentFxAppear;
}
@property (nonatomic, strong) NSDictionary *config;
+ (Audio *)i;
- (void) initializeBackgroundMusic;
- (void) initializeSoundEffects;
- (void) fadeIn:(int)index;
- (void) fadeOut:(int)index;
- (void) fadeInBack:(NSNumber *)index;
- (void) fadeOutBack:(NSNumber *)index;
- (void) startNextSong;
- (void) stopBackgroundSound;
- (void) playFxArmPulled;
- (void) playFxCheers;
- (void) playFxInsertCoin;
- (void) playFxJackpot;
- (void) playFxWinningCombination;
- (void) playFxCoinDropping;
- (void) playFxReelClick;
- (void) stopFxReelClick;
- (void) playFxReelStop;
- (void) playFxSlide;
- (void) playFxPop;
- (void) playFxWhoosh;
- (void) playFxAppear;

@end
