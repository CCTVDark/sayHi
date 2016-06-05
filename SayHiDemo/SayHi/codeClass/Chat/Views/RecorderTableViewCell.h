//
//  RecorderTableViewCell.h
//  SayHi
//
//  Created by lanouhn on 16/5/16.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecorderTableViewCell : UITableViewCell<AVAudioPlayerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong)AVAudioPlayer *player;
//用于记录是否播放
@property (nonatomic, assign)NSInteger isPlay;
@end
