//
//  BottomView.h
//  NewHome
//
//  Created by 小热狗 on 15/7/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol bottomDelegate <NSObject>

-(void)showHostSettingView; //显示主机设置界面
-(void)showAddRoomView;//显示房间添加界面
-(void)changeRoom:(long)roomId;//切换房间

-(void)editRoom:(long)roomId;//编辑房间
-(void)deleteRoom:(long)roomId;//删除房间

-(void)editEquiRoom:(long)roomId;//编辑分组房间
-(void)deleteEquiRoom:(long)roomId;//删除分组房间

-(void)VoiceClick;
-(void)stopVoiceClick;
@end
@interface BottomView : UIView
{
    
    BOOL micOpen;
    UIScrollView *bottomScr;//房间滚动条
    UIView *bottomNavView; //左边底部视图;

    UIScrollView *equiScr; //设备分组滚动条
    UIView *equiView; //右边底部视图

    UIButton *selectBtn;//当前选中button
    UIButton * microphoneBtn;
    UIMenuController * m_menuCtrl;//长按菜单
    UIMenuController * m_menuCtrl_equi;//长按菜单

}


@property(nonatomic,retain)id <bottomDelegate> delegate;
@property(nonatomic,assign)long roomId;
//滚动条加载房间按钮
-(void)setBottomItems:(NSArray *)items;
//设备分组按钮
-(void)setEquipmentItems:(NSArray *)items;


-(void)loadRoomSelect:(long)tag;
@end
