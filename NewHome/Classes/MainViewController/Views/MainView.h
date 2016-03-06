//
//  MainView.h
//  NewHome
//
//  Created by 小热狗 on 15/7/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RemoteBtn.h"

@protocol mainViewDelegate <NSObject>

-(void)BtnClick:(long)buttonId;//按钮点击事件
-(void)stopCameraShow;
-(void)remoteButtonClick:(long)buttonId;
-(void)switchClick:(long)switchId;
-(void)switchQuery:(long)switchId;
-(void)numberClick:(long)numberId;

-(void)IOClick:(long)ioId;

-(void)querySwitchStatus:(NSString *)swithcLine switchAddr:(NSString *)swichAddr;
-(void)queryNumberValue:(NSString *)numberAddr;
-(void)queryIoVaule;

-(void)closeMessagePush;
-(void)openMessagePush;
-(void)cameraOperation:(long)tag;

-(void)speekTouchBegin;
-(void)speekTouchEnd;
//编辑遥控板按钮
-(void)editRomteBtn:(long)tag;

-(void)checkLog;
-(void)setLog;
@end

@interface MainView : UIView<UIGestureRecognizerDelegate>
{
     UIMenuController * m_menuCtrl;
    UIImageView *bagImageView;//背景图片
    RemoteBtn *reBtnModal;
    UIButton *messageBtn;
    UIImageView *backImg;
    UIView *logView;
    NSTimer *timer;
}
@property(nonatomic,retain)id <mainViewDelegate> delegate;
@property(nonatomic,strong)UILabel *firstLabel;
@property(nonatomic,strong)UILabel *secondLabel;
@property(nonatomic,assign)long operId;//操作控件id
@property(nonatomic,assign)long switchCount;
@property(nonatomic,assign)long switchNub;
@property(nonatomic,assign)long numberNub;
@property(nonatomic,strong)NSArray *switchArray;
@property(nonatomic,strong)NSArray *numberArray;
@property(nonatomic,strong)NSArray *ioArray;
@property(nonatomic,assign)long currentSwitchId;
@property(nonatomic,assign)long currentNumberId;
@property(nonatomic,strong)NSArray *switchKeys;
@property(nonatomic,strong)UILabel *voiceFontLabel;
//加载背景图片
-(void)setBackgroundImg:(NSString *)filePath;
//加载控件
-(void)setControlBtns:(NSArray *)items;

//加载摄像头
-(void)setcamera:(NSArray *)cameraArray;

//加载遥控板
-(void)setRomte:(NSArray *)remoteArray;
//展示开关状态
-(void)showSwitchStatus:(NSString *)swithAddr newStr:(NSString *)newStr currentRoomId:(long)roomId;
//展示数值
-(void)showNumberText1:(NSString *)text1 color1:(NSString *)color1 text2:(NSString *)text2 color2:(NSString *)color2 numberAddr:(NSString *)numAddr;
//展示io值
-(void)showIoStatus:(NSString *)reciveStr;
//加载开关
-(void)setSwitchBtns:(NSArray *)items;
//加载数值
-(void)setNumberBtns:(NSArray *)items;
//数值
-(void)setIOBtns:(NSArray *)items;
//文字反馈显示
-(void)firstLabel:(NSString *)firstText;


-(void)secondLabel:(NSString *)secondText;

-(void)showVoiceLabel:(NSString *)voiceText;


@end
