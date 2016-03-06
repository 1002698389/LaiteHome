//
//  PoppueAddRoomViewController.h
//  NewHome
//
//  Created by 小热狗 on 15/8/3.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DWBubbleMenuButton.h"
#import "RoomModal.h"
#import "HYActivityView.h"
@protocol popAddRoomlDelegate <NSObject>

-(void)addRoom:(NSString *)room_name room_icon:(NSInteger)room_icon room_type:(NSInteger)room_type tag:(long)tag;//添加房间(取消，确定）


-(void)upLoadImg;//上传房间图片
-(void)equimentGroupSelect:(int)imgTag;//选择设备分组
@end
@class MLTableAlert;
@interface PoppueAddRoomViewController : UIViewController<UITextFieldDelegate>
{
    RoomModal *modal;//房间模型
    CGRect menu_frame;
    UITextField *roomNameField; //房间名输入框
    UITextField *btnNameField; //按钮名输入框
    UIButton *roomDisplay; //添加房间浏览按钮（设备分组）
    UIButton *selectBtn;//添加房间设备分组选择框
    UIButton *quickBtn;//添加快捷键
    UIImageView *disPlayImgView;//浏览图片
    DWBubbleMenuButton *upMenuView; //设备分组图标菜单
    NSArray *imgName; //设备分组名称数组
    NSArray *imgArray; //设备分组图标数组
    UIButton*iconBtn;
     float textField_height;
}
@property(nonatomic,assign)int roomType; //房间类型
@property(nonatomic,retain)id <popAddRoomlDelegate> delegate;
@property(nonatomic,assign)long roomId;
@property(nonatomic,assign)long hostId;
@property(nonatomic,assign)int roomIcon;//房间图标
@property (nonatomic, strong) HYActivityView *activityView;
@property (strong, nonatomic) MLTableAlert *alert;
-(void)setImage:(UIImage *)image; //显示图片
@end
