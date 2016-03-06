//
//  AddCameraView.h
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderDelegate.h"
#import "CameraModal.h"
@protocol addCameraDelegate <NSObject>
-(void)scanCamera;
-(void)addCamera:(NSString *)camear_name uid:(NSString *)uid user_name:(NSString *)user_name password:(NSString *)password tag:(long)tag width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect;//添加按钮(确定，取消）

@end
@interface AddCameraView : UIView<UITextFieldDelegate,QRCodeReaderDelegate>
{   UITextField *carmeraNameText; //摄像头名字
    UITextField *carmeraUidText;  //摄像头UID
    UITextField *carmeraUserNameText; //摄像头账户
    UITextField *carmeraPassWordText;  //摄像头密码
    CameraModal *modal;//摄像头模型
    UIButton *sizeBtn;
    UITextField *widthText;
    UITextField *heightText;
    BOOL customSelect;
float textField_height;
}
@property(nonatomic,retain)id <addCameraDelegate> delegate;
@property(nonatomic,assign)int customSize;//按钮大小（1：默认 2:自定义）
- (id)initWithFrame:(CGRect)frame buttonId:(long)btnId;//初始化


@end
