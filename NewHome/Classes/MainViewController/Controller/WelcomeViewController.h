//
//  WelcomeViewController.h
//  NewHome
//
//  Created by 小热狗 on 15/12/22.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgPlaySound.h"
@interface WelcomeViewController : UIViewController
{
    NSString *passText;
    UITextField *inputText;
    MsgPlaySound *playSound;
}
@end
