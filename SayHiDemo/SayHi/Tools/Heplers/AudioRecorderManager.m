//
//  AudioRecorderManager.m
//  SayHi
//
//  Created by lanouhn on 16/5/16.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "AudioRecorderManager.h"

@implementation AudioRecorderManager
+ (AudioRecorderManager *)sharedManager {
    static AudioRecorderManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AudioRecorderManager alloc]init];
        manager.isRecoding = NO;
    });
    return manager;
}


//录音按钮方法的实现
- (void)startStopRecord:(UIButton *)recordButton playButton:(UIButton *)playButton {
        if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }
    //判断当录音状态为不录音的时候
    if (!self.isRecoding) {
        //将录音状态变为录音
        self.isRecoding = YES;
        [self.player pause];
        
        //将录音按钮变为停止
        //[recordButton setTitle:@"停止" forState:UIControlStateNormal];
        [recordButton setImage:[UIImage imageNamed:@"Recording.png"] forState:UIControlStateNormal];
        //播放按钮不能被点击
        [playButton setEnabled:NO];
        [playButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        playButton.titleLabel.alpha = 0.5;
     
        //LinearPCM 是iOS的一种无损编码格式,但是体积较为庞大
        //录音设置
        NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
        //设置录音格式
        [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
        //设置录音采样率，8000是电话采样率，对于一般录音已经够了
        [dicM setObject:@(8000) forKey:AVSampleRateKey];
        //设置通道,这里采用单声道
        [dicM setObject:@(2) forKey:AVNumberOfChannelsKey];
        //每个采样点位数,分为8、16、24、32
        [dicM setObject:@(16) forKey:AVLinearPCMBitDepthKey];
        //是否使用浮点数采样
        [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
        
        
        
        //开始录音,将所获取到得录音存到文件里
        self.recorder = [[AVAudioRecorder alloc] initWithURL:_tmpFile settings:dicM error:nil];
        
        //准备记录录音
        [_recorder prepareToRecord];
        
        //启动或者恢复记录的录音文件
        [_recorder record];
        
        _player = nil;
        
    } else {
        
        //录音状态 点击录音按钮 停止录音
        self.isRecoding = NO;
        //[recordButton setTitle:@"录音" forState:UIControlStateNormal];
        [recordButton setImage:[UIImage imageNamed:@"Recorder.png"] forState:UIControlStateNormal];
        //录音停止的时候,播放按钮可以点击
        [playButton setEnabled:YES];
        [playButton.titleLabel setAlpha:1];
       
        //停止录音
        [_recorder stop];
        //NSString *string = [_tmpFile absoluteString];
        if (self.block) {
            self.block();
        }
        
        _recorder = nil;
        
        NSError *playError;
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:_tmpFile error:&playError];
        //当播放录音为空, 打印错误信息
        if (self.player == nil) {
            //NSLog(@"Error crenting player: %@", [playError description]);
        }
        self.player.delegate = self;
    }
    
}







- (void)playRecorderButtonAction:(UIButton *)sender {
    
    if (self.player == nil) {
        return;
    }
    
    if (self.playButton != sender && self.playButton!= nil) {
        [self.playButton setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
        
    }
    self.playButton = sender;
    
    if (self.player.isPlaying == NO) {
       
        NSError *error;
        NSLog(@"==%@",self.tmpFile);
        if (error != nil) {
            NSLog(@"Wrong init player:%@", error);
        }else{
            [self.player play];
        }
        [sender setImage:[[UIImage imageNamed:@"pause.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    }else {
        
        [self.player pause];
        [sender setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
    }
}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.playButton setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
}



@end
