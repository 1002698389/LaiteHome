//
//  AppDelegate.h
//  NewHome
//
//  Created by 小热狗 on 15/7/17.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IOTCamera/Camera.h>
#import <AVFoundation/AVFoundation.h>
#import "Reachability.h"
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
@interface AppDelegate : UIResponder <UIApplicationDelegate,AVAudioPlayerDelegate>
//{
//     AVAudioPlayer *player;
//   }
@property (strong, nonatomic) AVAudioPlayer *myBackMusic;
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic)NSUserDefaults *appDefault;//保存推送开启，及判断语音第一次

@end

