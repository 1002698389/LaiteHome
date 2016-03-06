//
//  UIDevice+IPhoneModel.h
//  NewHome
//
//  Created by 小热狗 on 16/1/31.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(char, iPhoneModel){//0~3
        iPhone4,//320*480
        iPhone5,//320*568
        iPhone6,//375*667
        iPhone6Plus,//414*736
        UnKnown
     };
@interface UIDevice (IPhoneModel)
+ (iPhoneModel)iPhonesModel;
@end
