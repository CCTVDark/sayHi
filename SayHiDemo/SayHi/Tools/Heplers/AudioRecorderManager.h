//
//  AudioRecorderManager.h
//  SayHi
//
//  Created by lanouhn on 16/5/16.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioRecorderManager : NSObject<AVAudioPlayerDelegate>
//录音存储路径
@property (nonatomic, strong)NSURL *tmpFile;

@property (nonatomic, strong)NSString *stringUrl;
@property (nonatomic, strong)NSString *recordTemporaryPathString;
//录音
@property (nonatomic, strong)AVAudioRecorder *recorder;
//播放
@property (nonatomic, strong)AVAudioPlayer *player;
//录音状态(是否录音)
@property (nonatomic, assign)BOOL isRecoding;
//
@property (nonatomic, strong)UIButton *playButton;

//单例方法
+ (AudioRecorderManager *)sharedManager;
//开始录音
- (void)startStopRecord:(UIButton *)recordButton playButton:(UIButton *)playButton;
//开始播放录音
- (void)playRecorderButtonAction:(UIButton *)sender;
//声明block回调用于发送录音
@property (nonatomic, copy)void(^block)();
@end
