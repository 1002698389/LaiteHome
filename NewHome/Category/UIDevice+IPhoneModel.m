//
//  UIDevice+IPhoneModel.m
//  NewHome
//
//  Created by 小热狗 on 16/1/31.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import "UIDevice+IPhoneModel.h"

@implementation UIDevice (IPhoneModel)
+ (iPhoneModel)iPhonesModel {
         //bounds method gets the points not the pixels!!!
         CGRect rect = [[UIScreen mainScreen] bounds];
    
         CGFloat width = rect.size.width;
        CGFloat height = rect.size.height;
    
         //get current interface Orientation
         UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
         //unknown
         if (UIInterfaceOrientationUnknown == orientation) {
                 return UnKnown;
             }
    
       
    
         //portrait
         if (UIInterfaceOrientationPortrait == orientation) {
                 if (width ==  320.0f) {
                         if (height == 480.0f) {
                                 return iPhone4;
                             } else {
                                     return iPhone5;
                                 }
                    } else if (width == 375.0f) {
                             return iPhone6;
                         } else if (width == 414.0f) {
                                 return iPhone6Plus;
                             }
             } else if (UIInterfaceOrientationLandscapeLeft == orientation || UIInterfaceOrientationLandscapeRight == orientation) {//landscape
                     if (height == 320.0) {
                             if (width == 480.0f) {
                                     return iPhone4;
                                 } else {
                                         return iPhone5;
                                     }
                         } else if (height == 375.0f) {
                                 return iPhone6;
                             } else if (height == 414.0f) {
                                     return iPhone6Plus;
                                 }
                 }
    
         return UnKnown;
     }
@end
