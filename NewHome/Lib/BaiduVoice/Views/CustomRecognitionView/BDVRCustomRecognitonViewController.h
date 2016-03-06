//
//  BDVRCustomRecognitonViewController.h
//  BDVRClientSample
//
//  Created by Baidu on 13-9-25
//  Copyright 2013 Baidu Inc. All rights reserved.
//

// 头文件
#import <UIKit/UIKit.h>
#import "BDVoiceRecognitionClient.h"
#import <AVFoundation/AVFoundation.h>
@protocol cutomerDelegate <NSObject>

-(void)reopenVoice;
-(void)showVoiceStr:(NSString *)voiceStr;
@end

// 前向声明
@class MainViewController;

// @class - BDVRCustomRecognitonViewController
// @brief - 语音搜索界面的实现类
@interface BDVRCustomRecognitonViewController : UIViewController<MVoiceRecognitionClientDelegate,AVAudioPlayerDelegate>
{
	UIImageView *_dialog;
    MainViewController *clientSampleViewController;
    
    
    
    NSTimer *_voiceLevelMeterTimer; // 获取语音音量界别定时器
   
    AVAudioPlayer *player;
    
     AVAudioPlayer *player1;
    AVAudioPlayer *player2;
    
}

// 属性
@property (nonatomic, retain) UIImageView *dialog;
@property (nonatomic, assign) MainViewController *clientSampleViewController;
@property (nonatomic, retain) NSTimer *voiceLevelMeterTimer;
@property (nonatomic, assign) long count;
@property(nonatomic,retain)id <cutomerDelegate> delegate;
// 方法
- (void)cancel:(id)sender;

@end // BDVRCustomRecognitonViewController
