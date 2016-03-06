//
//  SwitchBtn.m
//  NewHome
//
//  Created by 小热狗 on 15/12/11.
//  Copyright © 2015年 小热狗. All rights reserved.
//

#import "SwitchBtn.h"

@implementation SwitchBtn
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
        
        self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        
        [self addGestureRecognizer:self.leftSwipeGestureRecognizer];
        [self addGestureRecognizer:self.rightSwipeGestureRecognizer];
 
       
    }
    return self;
}


- (void)handleSwipes:(UISwipeGestureRecognizer *)sender
{   long operId;
    NSString *str;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        operId=sender.view.tag;
        str=[NSString stringWithFormat:@"%ld",operId];
        NSLog(@"尼玛的, 你在往左边跑啊....%ld",operId);
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeQuerySwith" object:str];
          }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
         operId=sender.view.tag;
         str=[NSString stringWithFormat:@"%ld",operId];
        NSLog(@"尼玛的, 你在往右边跑啊....%ld",operId);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"swipeQuerySwith" object:str];
        
    }
}


@end
