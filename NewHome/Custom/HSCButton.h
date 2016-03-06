//
//  HSCButton.h
//  AAAA
//
//  Created by zhangmh on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
/*
其实,
 */
#import <UIKit/UIKit.h>

@protocol operationBtnDelegate <NSObject>
-(void)editBtn:(long)btnId;//编辑按钮

@end




@interface HSCButton : UIButton
{
    CGPoint beginPoint;
    UIMenuController * m_menuCtrl;
}
@property(nonatomic,retain)id <operationBtnDelegate> delegate;
@property (nonatomic) BOOL dragEnable;//是否拖动


@property(nonatomic,assign)int  xpositon;//x坐标
@property(nonatomic,assign)int  ypositon;//y坐标
@property(nonatomic,assign)long currentButton;//当前button
@property(nonatomic,strong)NSString *operType;//
@property(nonatomic,assign)long operId;//操作控件id
- (id)initWithFrame:(CGRect)frame type:(NSString *)addType;//添加类型

@end
