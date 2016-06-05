//
//  ChatViewController.m
//  SayHi
//
//  Created by lanouhn on 16/5/14.
//  Copyright © 2016年 LiuGouDong. All rights reserved.
//

#import "ChatViewController.h"
#import "ChatViewCell.h"
#import "ImageTableViewCell.h"
#import "RecorderTableViewCell.h"
#import "RecorderReceiveCell.h"
#import <CoreText/CoreText.h>
@interface ChatViewController ()<EMChatManagerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
@property (nonatomic, strong)AppDelegate *myApp;
//消息表视图
@property (nonatomic, strong)UITableView *tableView;
//数据源
@property (nonatomic, strong)NSMutableArray *dataArray;

//输入框
@property (nonatomic, strong)UITextField *textField;
//辅助功能条
@property (nonatomic, strong)UIView *viewF;
//
@property (nonatomic, assign)CGFloat contentY;

//录音Button
@property (nonatomic, strong)UIButton *RecorderButton;
@property (nonatomic, strong)UIButton *RecorderPlayButton;

//现在的时间,0时区，只为创建录音文件时不重复文件名
@property (nonatomic, strong)NSString *nowTime;
@end

@implementation ChatViewController


- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    //关闭导航栏自动64留白
    self.automaticallyAdjustsScrollViewInsets = NO;
    //数据源开空间
    self.dataArray = [NSMutableArray array];
    //初始化消息对象
    [self setConversation];
    
    //初始化视图控件
    [self setViews];
    
    
    //配置所有block回调方法
    [self setBlock];
}
#pragma mark -- 初始化消息对象
- (void)setConversation {
     [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //删除会话
    //[[EMClient sharedClient].chatManager deleteConversation:self.tempName deleteMessages:YES];
    //查找当前会话中的消息
    NSArray *messageArray = [self.conversation loadMoreMessagesFromId:nil limit:INT_MAX direction:EMMessageSearchDirectionUp];
    //插入数据源
    [self.dataArray addObjectsFromArray:messageArray];
}
#pragma mark -- 初始化视图控件
- (void)setViews {
    //背景图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"chat.jpg"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    //返回button
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(10, 25, 60, 30);
    [backButton setTitle:@"<返回" forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backDisMiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    //表视图
    [self setTableView];
    //输入框
    [self setTextField];
    //辅助功能
    [self setAssist];
}
#pragma mark -- 表视图控件
- (void)setTableView {
    self.tableView = [[UITableView alloc]initWithFrame:kFrameTwo style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
    
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatViewCell" bundle:nil] forCellReuseIdentifier:@"chatViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"imageTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecorderTableViewCell" bundle:nil] forCellReuseIdentifier:@"recorderViewCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"RecorderReceiveCell" bundle:nil] forCellReuseIdentifier:@"recorderReceiveCell"];
}
#pragma mark -- 辅助功能
- (void)setAssist {
    self.viewF = [[UIView alloc]initWithFrame:CGRectMake(3, kDeviceHeight - 30 - 30, kDeviceWidth - 6, 30)];
    self.viewF.backgroundColor = [UIColor whiteColor];
    //选择图片
    UIButton *button = [UIButton setButtonWithFrame:CGRectMake(0, 0, 32, 30) title:@"图片" target:self action:@selector(handleImage:)];
    [button setImage:[UIImage imageNamed:@"imageButton.png"] forState:UIControlStateNormal];
    [self.viewF addSubview:button];
    [self.view addSubview:self.viewF];
    //录音
    self.RecorderButton = [UIButton setButtonWithFrame:CGRectMake(40, 0, 32, 30) title:@"录音" target:self action:@selector(handleRecorder:)];
    [self.RecorderButton setImage:[UIImage imageNamed:@"Recorder.png"] forState:UIControlStateNormal];
    [self.viewF addSubview:self.RecorderButton];

}
#pragma mark -- 表视图控件
- (void)setTextField {
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(3, kDeviceHeight - 30, kDeviceWidth - 6, 30)];
    self.textField.layer.borderWidth = 1.0;
    self.textField.layer.borderColor =  [UIColor colorWithRed:14/255.0 green:174/255.0 blue:131/255.0 alpha:1].CGColor;
    self.textField.delegate = self;
    self.textField.layer.cornerRadius = 3;
    self.textField.layer.masksToBounds = YES;
    self.textField.returnKeyType = UIReturnKeyDefault;
    self.textField.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
}
- (void)commentTableViewTouchInSide{
    [self.textField resignFirstResponder];
}
#pragma mark -- textField点击改变frame方法
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    //弹出输入框操作
    //监测键盘即将出现
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardshow:) name:UIKeyboardWillShowNotification object:nil];
    //键盘即将消失的监测方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];  
}
#pragma mark -- textField代理方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.chatType = ChatTypeText;
    [self sendMessage:self.textField.text];
    self.textField.text = nil;
    [self.textField resignFirstResponder];
    return YES;
}
#pragma mark -- 实现键盘即将消失的方法
- (void)keyboardHide:(NSNotification *)notifi {
    //获取键盘的高度
//    CGRect keyboardRect = [notifi.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];//将字符串转为CGRect的结构体
    //获取键盘收回的时间
    float time = [[notifi.userInfo objectForKey:UIKeyboardWillHideNotification] floatValue];
    //现在使用动画改变keyboardView的位置
    [UIView animateWithDuration:time animations:^{
        self.tableView.transform = CGAffineTransformMakeTranslation(0, 0);
        self.textField.transform = CGAffineTransformMakeTranslation(0, 0);
        self.viewF.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}
#pragma mark -- 实现键盘即将出现的方法
- (void)keyboardshow:(NSNotification *)notifi {
    //同样 获取键盘的高度
    CGRect keyboardRect = [notifi.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    //获取键盘弹出所需要的时间
    float time = [[notifi.userInfo objectForKey:UIKeyboardWillShowNotification] floatValue];
    //以此来做动画
    [UIView animateWithDuration:time animations:^{
     self.tableView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
        self.textField.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
        self.viewF.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
    }];
}



#pragma mark -- 封装发送文本消息方法
- (void)sendMessage:(NSString *)textBoby {
    if (textBoby.length == 0) {
        return;
    }
    //1.消息体
    EMTextMessageBody *body = [[EMTextMessageBody alloc]initWithText:textBoby];
    //2.告诉服务器消息的发送者
    NSString *form = [EMClient sharedClient].currentUsername;
    //生成message
    EMMessage *message = [[EMMessage alloc]initWithConversationID:self.conversation.conversationId from:form to:self.tempName body:body ext:nil];
    if (self.group) {
        message.chatType = EMChatTypeGroupChat;
    }else {
        message.chatType = EMChatTypeChat;// 设置为单聊消息
    }
    //关键：给服务器发送聊天消息
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        //封装插入数据源 以及插入cell的方法
        if (!error) {
            NSLog(@"消息发送成功");
            [self insertWithMessage:message];
        }else {
            NSLog(@"消息发送失败%@", error);
        }
    }];
}

#pragma mark -- 发送图片Button
- (void)handleImage:(UIButton *)sender {
    
    [[ImageSelectManager sharedManager] headerImageTapAction:self];
}
#pragma mark -- 录音Button
- (void)handleRecorder:(UIButton *)sender {
    AudioRecorderManager *manager = [AudioRecorderManager sharedManager];
   
#warning mark -- 这里放录音完成后，文件的存储路径
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //获取源文件url
    NSURL *sourceFile = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    NSDate *nowDate = [NSDate date];
    //1.创建日期格式对象
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //2.自定义日期格式
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    //3.开始转换
    NSString *dateString = [formatter stringFromDate:nowDate];
    if (!manager.isRecoding) {
    manager.tmpFile = [sourceFile URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.wav", dateString]];
    }
    [manager startStopRecord:sender playButton:self.RecorderPlayButton];
}
#pragma mark -- 播放Button
- (void)handleRecorderPlay:(UIButton *)sender {
    AudioRecorderManager *manager = [AudioRecorderManager sharedManager];
    [manager playRecorderButtonAction:sender];
}
#pragma mark -- 收到消息的方法
- (void)didReceiveMessages:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        if ([message.conversationId isEqualToString:self.conversation.conversationId]) {
            //插入数据（因为可以和不同的人同时聊天，唯一标识就是会话对象）
            [self insertWithMessage:message];
        }
    }
}

#pragma mark -- 封装插入数据源 以及cell
- (void)insertWithMessage:(EMMessage *)message {
     [self.dataArray addObject:message];
    EMMessageBody *msgBody = message.body;
    if (msgBody.type == EMMessageBodyTypeVoice) {
        [[EMClient sharedClient].chatManager asyncDownloadMessageAttachments:message progress:^(int progress) {
            
        } completion:^(EMMessage *message, EMError *error) {
           
            [self.tableView reloadData];
            
        }];
    }
    //插入cell
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}
#pragma mark -- 配置Cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    EMMessage *message = [self.dataArray objectAtIndex:indexPath.row];
    EMMessageBody *msgBody = message.body;
    if (msgBody.type == EMMessageBodyTypeText) {
        ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatViewCell" forIndexPath:indexPath];
        
        cell.messageLabel.text = [self getInfoFromMessage:message];
        cell.messageLabel.textColor = [UIColor blackColor];
        cell.messageLabel.attributedText = [self getAttributedString:message];

        //cell.messageLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (message.direction == EMMessageDirectionSend) {
            //如果是自己发送的信息，就让文字向右排放
            cell.messageLabel.textAlignment = NSTextAlignmentRight;
        }else {
            cell.messageLabel.textAlignment = NSTextAlignmentLeft;
        }
        return cell;
    }else if (msgBody.type == EMMessageBodyTypeImage)  {
        // 得到一个图片消息body
        
        EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageTableViewCell" forIndexPath:indexPath];
        NSLog(@"小图LocalPath -- %@"   ,body.remotePath);
        NSURL *imageUrl = [NSURL URLWithString:body.remotePath];
        NSURLRequest *request = [NSURLRequest requestWithURL:imageUrl];

        __weak ImageTableViewCell *weakCell = cell;
        [cell.ChatimageView setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            
            weakCell.ChatimageView.image = image;
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        }];
        
        cell.ChatimageView.contentMode = UIViewContentModeCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;

    }else {
#warning mark -- cell里处理文件夹
        EMVoiceMessageBody *body = ((EMVoiceMessageBody *)msgBody);
        
        NSURL *url = [NSURL fileURLWithPath:body.localPath];
            NSError *playError = nil;
       if (message.direction == EMMessageDirectionReceive) {
            //如果是对方发送的信息，就让路径拼接上后缀
            NSLog(@"走了");
            NSString *lastStr = [[body.localPath componentsSeparatedByString:@"/"] lastObject];
           
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //获取源文件url
            NSURL *sourceFile = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
            NSURL *tempURL = [sourceFile URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", lastStr]];
            [fileManager createDirectoryAtURL:tempURL withIntermediateDirectories:YES attributes:nil error:nil];
            tempURL = [tempURL URLByAppendingPathComponent:@"Recorder.wav"];
            NSURL *bodyURl = [NSURL fileURLWithPath:body.localPath];
            [fileManager moveItemAtURL:bodyURl toURL:tempURL error:nil];
            url = tempURL;
            NSLog(@"对方发的%ld",indexPath.row);
            RecorderReceiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recorderReceiveCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playError];
            cell.receiveLabel.text = [NSString stringWithFormat:@"%@：", message.from];
            //当播放录音为空, 打印错误信息
            if (cell.player == nil) {
                NSLog(@"Error crenting player: %@", [playError description]);
            }
            cell.player.delegate = cell;
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        
        RecorderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recorderViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&playError];
        
            //当播放录音为空, 打印错误信息
            if (cell.player == nil) {
                NSLog(@"Error crenting player: %@", [playError description]);
            }
            cell.player.delegate = cell;
            cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}

#pragma mark -- 封装从Message 中获取聊天信息的方法
- (NSString *)getInfoFromMessage:(EMMessage *)message {
    EMMessageBody *messageBody = message.body;
    //获取文字信息
    EMTextMessageBody *textBody = (EMTextMessageBody *)messageBody;
    //获取聊天信息
    if (message.direction == EMMessageDirectionSend) {
        NSString *text = [NSString stringWithFormat:@"%@：我", textBody.text];
     
        return text;
    }else {
        NSString *text = [NSString stringWithFormat:@"%@：%@", message.from, textBody.text];
        return text;
    }
}
#pragma mark -- 修改文本颜色
- (NSMutableAttributedString *)getAttributedString:(EMMessage *)message {
    EMMessageBody *messageBody = message.body;
    //获取文字信息
    EMTextMessageBody *textBody = (EMTextMessageBody *)messageBody;
    //获取聊天信息
    if (message.direction == EMMessageDirectionSend) {
        NSString *text = [NSString stringWithFormat:@"%@：我", textBody.text];
       // 创建一个NSMutableAttributedString
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
                //添加文本的颜色
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(textBody.text.length, 2)];
        return attrStr;
    }else {
        NSString *text = [NSString stringWithFormat:@"%@：%@", message.from, textBody.text];
        //创建一个NSMutableAttributedString
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:text];
                //添加文本的颜色
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:NSMakeRange(0, message.from.length + 1)];
        return attrStr;
    }
}



#pragma mark -- 配置所有助手Blcok回调
- (void)setBlock {
    //图片选择Blcok
    ImageSelectManager *ImageManager = [ImageSelectManager sharedManager];
    [ImageManager setBlock:^(NSData *data) {
        EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:data displayName:@"图片消息"];
        NSString *from = [[EMClient sharedClient] currentUsername];
        //生成Message
        EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:from to:self.tempName body:body ext:nil];
        if (self.group) {
            message.chatType = EMChatTypeGroupChat;
        }else {
            message.chatType = EMChatTypeChat;// 设置为单聊消息
        }
        
        //关键：给服务器发送聊天消息
        [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
            //封装插入数据源 以及插入cell的方法
            if (!error) {
                NSLog(@"消息发送成功");
                [self insertWithMessage:message];
                
            }else {
                NSLog(@"消息发送失败");
            }
        }];
        
    }];
    //录音Block
    AudioRecorderManager *audioManager = [AudioRecorderManager sharedManager];
    __weak AudioRecorderManager *weakManger = audioManager;
    [audioManager setBlock:^{

        //        NSFileManager *fileManager = [NSFileManager defaultManager];
//        //获取源文件url
//        NSURL *sourceFile = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
//        NSURL *tempURL = [sourceFile URLByAppendingPathComponent:@"Recorder.wav"];
        
        NSString *RecorderPath = [weakManger.tmpFile absoluteString];
        EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:RecorderPath displayName:@"语音消息"];
        body.duration = weakManger.player.duration;
        NSString *from = [[EMClient sharedClient] currentUsername];
        
        // 生成message
        EMMessage *message = [[EMMessage alloc] initWithConversationID:self.conversation.conversationId from:from to:self.tempName body:body ext:nil];
        if (self.group) {
            message.chatType = EMChatTypeGroupChat;
        }else {
            message.chatType = EMChatTypeChat;// 设置为单聊消息
        }
        //关键：给服务器发送聊天消息
        [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
            //封装插入数据源 以及插入cell的方法
            if (!error) {
                NSLog(@"消息发送成功");
                [self insertWithMessage:message];
               
               
            }else {
                NSLog(@"消息发送失败");
                UIAlertController *control = [UIAlertController alertControllerWithTitle:@"提示" message:@"语音发送失败" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
                [control addAction:cancel];
                [self presentViewController:control animated:YES completion:nil];
            }
        }];
    }];

}


//返回上一界面
- (void)backDisMiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -- cell高度问题
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EMMessage *message = [self.dataArray objectAtIndex:indexPath.row];
        if (message.body.type == EMMessageBodyTypeText) {
           NSString *tmpStr = [self getInfoFromMessage:message];
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:17]};
            CGRect rect = [tmpStr boundingRectWithSize:CGSizeMake(kDeviceWidth - 12, MAXFLOAT) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin) attributes:dic context:nil];
            return rect.size.height + 15;
        }else if (message.body.type == EMMessageBodyTypeVoice){
            return 40;
        }else {
            return 199;
    }

}

#pragma mark -- 视图加载时
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.dataArray.count == 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataArray.count - 1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

@end
