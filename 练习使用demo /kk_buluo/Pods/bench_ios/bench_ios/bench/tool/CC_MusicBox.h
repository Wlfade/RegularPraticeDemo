//
//  CC_MusicBox.h
//  bench_ios
//
//  Created by gwh on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface CC_MusicBox : NSObject<AVAudioPlayerDelegate>{
    int fadeTimeCount;
    int isMusic;
}

+ (instancetype)getInstance;

@property(nonatomic,assign) BOOL forbiddenMusic;
@property(nonatomic,assign) BOOL forbiddenEffect;

@property(nonatomic,retain) AVAudioPlayer *audioPlayer;

/**
 * 淡入淡出
 * 使背景音乐过渡不突兀 当切换场景时检查是否有背景音乐在播放 如果有将它淡出 然后将新的背景音乐淡入 起到平滑作用
 */
@property(nonatomic,assign) BOOL fade;

/**
 *  音效循环次数
 */
@property(nonatomic,assign) int effectReplayTimes;

/**
 *  音乐循环次数
 */
@property(nonatomic,assign) int musicReplayTimes;

/**
 *  设置最大音量
    注意：如不设置 最大音量为手机设置的音量
 */
@property(nonatomic,assign) float defaultVolume;

- (void)stopMusic;
- (void)playMusic:(NSString *)name type:(NSString *)type;
- (void)playEffect:(NSString *)name type:(NSString *)type;

@end
