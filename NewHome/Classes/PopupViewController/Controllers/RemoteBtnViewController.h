//
//  RemoteBtnViewController.h
//  NewHome
//
//  Created by 冉思路 on 15/8/31.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
#import "DOPDropDownMenu.h"
#import "ButtonModal.h"
#import "PresetData.h"
#import "RemoteBtn.h"
@protocol editRemoteViewDelegate <NSObject>
-(void)addRemoteBtn:(NSString *)button_name preset_data_id:(NSInteger)preset_data_id net_data:(NSString *)net_data tag:(long)tag;
@end





@class MLTableAlert;
@interface RemoteBtnViewController : UIViewController<UITextFieldDelegate,QRadioButtonDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
 UITextField *btnNameField; //按钮名输入框
  DOPDropDownMenu *menuList;//下拉视图
 ButtonModal *modal;//普通模型
    UIButton *menuBtn;//下拉菜单按钮
    RemoteBtn *remoteBtnModal;//按钮
    UILabel *backImg;
     BOOL customSelect;
    float textField_height;
}
@property (strong, nonatomic) MLTableAlert *alert;
/*数据源*/
@property (nonatomic, strong) NSMutableArray *radioDownArray;//数据源
@property(nonatomic,strong)UITextField *customText;
@property(nonatomic,strong)NSString *cutomeBtnName;
@property(nonatomic,strong)NSString *tableName;
@property(nonatomic,strong) PresetData *presetModal;//数据模型
@property(nonatomic,strong)NSString *buttonType;//按钮类型（无线，情景，条件）
@property(nonatomic,assign)int buttonStyle;//按钮种类(快捷，普通 2:快捷  1:普通)
@property(nonatomic,assign)NSInteger presetDataId; //数据id
@property(nonatomic,strong)NSString *presetData;//数据内容
@property(nonatomic,assign)NSInteger data_type;//数据类型
@property(nonatomic,retain)id <editRemoteViewDelegate> delegate;
@property(nonatomic,assign)long editBtnTag;
@property(nonatomic,assign)long currentHostId;
@property(nonatomic,assign)long clickTag;
@property(nonatomic,strong)NSString *btnMode;
@property(nonatomic,strong)NSString *buttonName;
@end
