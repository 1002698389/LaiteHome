//
//  MsgPlaySound.h
//  NewHome
//
//  Created by 小热狗 on 15/12/23.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@interface MsgPlaySound : NSObject
{
    SystemSoundID sound;//系统声音的id 取值范围为：1000-2000
}
-(id)initSystemShake;//系统 震动
-(id)initSystemSoundWithName:(NSString *)soundName SoundType:(NSString *)soundType;//初始化系统声音
- (void)play;//播放
@end
