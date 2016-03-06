//
//  AddButtonView.h
//  NewHome
//
//  Created by 小热狗 on 15/8/12.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRadioButton.h"
#import "DOPDropDownMenu.h"
#import "PresetData.h"
#import "ButtonModal.h"
#import "QuickButton.h"
#import "RemoteBtn.h"
@protocol addButtonDelegate <NSObject>
-(void)upLoadBtnImg;//上传按钮图片
-(void)addButton:(NSString *)button_name preset_data_id:(NSInteger)preset_data_id net_data:(NSString *)net_data tag:(long)tag buttonType:(int)buttontype defaultIcon:(NSInteger)defaultIcon width:(NSString *)btnWidth height:(NSString *)btnHeight customSelect:(NSInteger)customSelect;//添加按钮(确定，取消）
@end

@class MLTableAlert;
@interface AddButtonView : UIView<UITextFieldDelegate,QRadioButtonDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITextFieldDelegate>
{
    UITextField *btnNameField; //按钮名输入框
     UIButton *quickBtn;//添加快捷键
    UIButton *sizeBtn;
    UITextField *widthText;
    UITextField *heightText;
     DOPDropDownMenu *menuList;//下拉视图
    ButtonModal *modal;//普通模型
    QuickButton *modalQuick;//快捷按钮模型
    RemoteBtn *remoteBtn;
    
    UIButton *menuBtn;//下拉菜单按钮
    UILabel *backImg;
    BOOL customSelect;
    UIImageView *btnImg;
    float iconWidth;
    float iconHeight;
  float textField_height;
  }

@property(assign,nonatomic)float factIconWidth;
@property(assign,nonatomic)float factIconHeight;
@property (strong, nonatomic) MLTableAlert *alert;
@property(nonatomic,retain)id <addButtonDelegate> delegate;

/*数据源*/
@property (nonatomic, strong) NSMutableArray *radioDownArray;//数据源

@property(nonatomic,strong)NSString *tableName;
 @property(nonatomic,strong) PresetData *presetModal;//数据模型
@property(nonatomic,strong)NSString *buttonType;//按钮类型（无线，情景，条件）
@property(nonatomic,assign)int buttonStyle;//按钮种类(快捷，普通 2:快捷  1:普通)
@property(nonatomic,assign)int customSize;//按钮大小（1：默认 2:自定义）
@property(nonatomic,assign)NSInteger presetDataId; //数据id
@property(nonatomic,strong)NSString *presetData;//数据内容
@property(nonatomic,assign)NSInteger data_type;//数据类型
@property(nonatomic,assign)long currentHostId;
@property(nonatomic,strong)NSString *btnMode;
@property(nonatomic,strong)UITextField *customText;
@property(nonatomic,assign)long defaultIcon;
@property(nonatomic,strong)NSString *cutomeBtnName;
- (id)initWithFrame:(CGRect)frame buttonId:(long)btnId hostId:(long)hostId;//初始化



-(void)showFactIconWidth:(float)width IconHeight:(float)height;
@end
