//
//  AddSwitchView.h
//  NewHome
//
//  Created by 小热狗 on 15/10/23.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWBubbleMenuButton.h"
#import "HYActivityView.h"
#import "SwitchModal.h"
@protocol addSwitchDelegate <NSObject>


-(void)addSwitch:(NSString *)switchName switchAddr:(NSString *)swithAddr switchIcon:(int)switchIcon tag:(long)tag swtichLine:(int)swtichLine;//添加按钮(确定，取消）

@end
@class MLTableAlert;
@interface AddSwitchView : UIView<UITextFieldDelegate>
{
    UITextField *carmeraNameText; //摄像头名字
    UITextField *carmeraUidText;  //摄像头UID
    UITextField *carmeraUserNameText; //摄像头账户
    UITextField *carmeraPassWordText;  //摄像头密码
UIButton *roomDisplay;//图标
      DWBubbleMenuButton *upMenuView; //设备分组图标菜单
    NSArray *imgName; //设备分组名称数组
    NSArray *imgArray; //设备分组图标数组
    CGRect menu_frame;
    UIButton *menuBtn;//下拉菜单按钮
    UIButton*iconBtn;
    SwitchModal *modal;
   float textField_height;
}

- (id)initWithFrame:(CGRect)frame buttonId:(long)btnId hostId:(long)hostId;
@property(nonatomic,retain)id <addSwitchDelegate> delegate;
@property (strong, nonatomic) MLTableAlert *alert;
@property (nonatomic, strong) HYActivityView *activityView;


@property(nonatomic,assign)long swithIcon;
@property(nonatomic,assign)long swithLine;
@end
