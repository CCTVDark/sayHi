//
//  RecorderTableViewCell.m
//  SayHi
//
//  Created by lanouhn on 16/5/16.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "RecorderTableViewCell.h"

@implementation RecorderTableViewCell

- (void)awakeFromNib {
    [self.playButton setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    
}
- (IBAction)RecorderButton:(UIButton *)sender {
     AudioRecorderManager *manager = [AudioRecorderManager sharedManager];
     [manager.player pause];
     [manager.playButton setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
       if (self.player == nil) {
        return;
    }
     if (manager.playButton != sender && manager.playButton!= nil) {
         [manager.playButton setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
         
     }
     manager.playButton = sender;
     
     
     
     if (self.player.isPlaying == NO) {
         
         
         [self.player play];
         [self.playButton setImage:[[UIImage imageNamed:@"pause.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal] ;
    
     }else {
         
         [self.player pause];
         [self.playButton setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]forState:UIControlStateNormal];
     }

}
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
     [self.playButton setImage:[[UIImage imageNamed:@"play.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
