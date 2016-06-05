//
//  RecorderReceiveCell.h
//  SayHi
//
//  Created by lanouhn on 16/5/30.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecorderReceiveCell : UITableViewCell<AVAudioPlayerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong)AVAudioPlayer *player;
//用于记录是否播放
@property (nonatomic, assign)NSInteger isPlay;
@property (strong, nonatomic) IBOutlet UILabel *receiveLabel;

@end
