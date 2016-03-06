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
@protocol addButtonDelegate <NSObject>
-(void)upLoadBtnImg;//上传按钮图片
-(void)addButton:(NSString *)button_name preset_data_id:(NSInteger)preset_data_id net_data:(NSString *)net_data tag:(long)tag buttonType:(int)buttontype;//添加按钮(确定，取消）
@end


@interface AddButtonView : UIView<UITextFieldDelegate,QRadioButtonDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    UITextField *btnNameField; //按钮名输入框
     UIButton *quickBtn;//添加快捷键
     DOPDropDownMenu *menuList;//下拉视图
  
}

@property(nonatomic,retain)id <addButtonDelegate> delegate;

/*数据源*/
@property (nonatomic, strong) NSMutableArray *radioDownArray;//数据源
@property (nonatomic, strong) NSMutableArray *muArray;//数据源

 @property(nonatomic,strong) PresetData *presetModal;//数据模型
@property(nonatomic,strong)NSString *buttonType;//按钮类型（无线，情景，条件）
@property(nonatomic,assign)int buttonStyle;//按钮种类(快捷，普通 1:快捷  2:普通)
@property(nonatomic,assign)NSInteger presetDataId; //数据id
@property(nonatomic,strong)NSString *presetData;//数据内容

@end
