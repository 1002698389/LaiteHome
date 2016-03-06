//
//  AddNumberView.h
//  NewHome
//
//  Created by 小热狗 on 15/10/23.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberModal.h"
@protocol addNumberDelegate <NSObject>


-(void)addNumber:(NSString *)numberName numberAddr:(NSString *)numberAddr numberOne:(NSString *)numberOne tag:(long)tag numberTwo:(NSString *)numberTwo width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect;//添加按钮(确定，取消）

@end
@interface AddNumberView : UIView<UITextFieldDelegate>
{
    
    UITextField *carmeraNameText; //摄像头名字
    UITextField *carmeraUidText;  //摄像头UID
    UITextField *carmeraUserNameText; //摄像头账户
    UITextField *carmeraPassWordText;  //摄像头密码
    NumberModal *modal;
    UIButton *sizeBtn;
    UITextField *widthText;
    UITextField *heightText;
    BOOL customSelect;
    float textField_height;

}
- (id)initWithFrame:(CGRect)frame buttonId:(long)btnId hostId:(long)hostId;
@property(nonatomic,retain)id <addNumberDelegate> delegate;
@property(nonatomic,assign)int customSize;//按钮大小（1：默认 2:自定义）
@end
