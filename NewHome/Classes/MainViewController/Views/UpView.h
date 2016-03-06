//
//  UpView.h
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol upDelegate <NSObject>
-(void)showAddBtnView:(NSString *)state btnId:(long)btnId;//显示按钮添加界面
-(void)editQuick:(long)quickId;//编辑快捷
-(void)deleteQuick:(long)quickId;//删除快捷
-(void)quickButtonClick:(long)buttonId;//按钮点击事件
-(void)queryTempAndWet;//查询温湿度
-(void)timeClick;
-(void)defenseClick:(BOOL)Status;
@end

@interface UpView : UIView
{
    UIMenuController * m_menuCtrl;//长按菜单

    UIScrollView *upScr;//顶部滚动条
    UIView *upNavView; //左边顶部视图
    UIView *environmentView;//右上视图
    
    UIButton *lockBtn;
    UIButton *clockBtn;
    UIImageView *netImgView;
    
    BOOL checkDenfense;
}


@property(nonatomic,strong)UILabel *wetLabel; //湿度label

@property(nonatomic,strong)UILabel *tempLabel; //温度label
@property(nonatomic,assign)long quickId;
@property(nonatomic,retain)id <upDelegate> delegate;
-(void)loadItems:(NSArray *)itmes;  //加载快捷键按钮
-(void)setTemperature:(int)temperature Wet:(int)wet; //加载温度，湿度
//设防撤防状态
-(void)loadDefenceStatus:(NSString *)str;
-(void)showNetConnectStatus:(NSString *)imgStr;
@end
