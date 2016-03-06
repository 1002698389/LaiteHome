//
//  HSCButton.m
//  AAAA
//
//  Created by zhangmh on 12-7-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HSCButton.h"
#import "DatabaseOperation.h"

@implementation HSCButton

@synthesize dragEnable;

- (id)initWithFrame:(CGRect)frame type:(NSString *)addType
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        
        self.operType=addType;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled=YES;
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 1.0;
       [self addGestureRecognizer:longPressGr];
     
        //拖动振动
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(allShake:) name: @"allShake" object: nil];
        //拖动振动
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(allStop:) name: @"allStop" object: nil];
    
    }
    return self;
}


-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"good" message:@"longpress" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
//        [alert show];
//        
        //add your code here
    
    
        [self becomeFirstResponder];
        self.operId=gesture.view.tag;
        m_menuCtrl = [UIMenuController sharedMenuController];
        
        if (dragEnable==NO) {
            UIMenuItem *itemDrag = [[UIMenuItem alloc] initWithTitle:@"拖动" action:@selector(btnShakeStart)];
            UIMenuItem *itemEdit = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(editBtn)];
            UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteBtn)];
            
            
            [m_menuCtrl setMenuItems:[NSArray arrayWithObjects:itemDrag,itemEdit, itemDelete, nil]];
            

        }else{
            
            
            UIMenuItem *itemDrag = [[UIMenuItem alloc] initWithTitle:@"退出拖动" action:@selector(btnShakeStop)];
            UIMenuItem *itemEdit = [[UIMenuItem alloc] initWithTitle:@"编辑" action:@selector(editBtn)];
            UIMenuItem *itemDelete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteBtn)];
            
            [m_menuCtrl setMenuItems:[NSArray arrayWithObjects:itemDrag,itemEdit, itemDelete, nil]];
            

            
            
            
            
            
        }
        
    
        [m_menuCtrl setTargetRect:self.frame inView: self.superview];
        [m_menuCtrl setMenuVisible:YES animated:YES];
    
    
    
    
    
    
    
    
    
    
    }
}


-(void)click{
    
    NSLog(@"good");
    
}


-(BOOL)canBecomeFirstResponder{
    return YES;
    
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(btnShakeStart)) {
        
        return YES;
        
    }else if (action == @selector(editBtn)){
        return YES;
    }else if (action == @selector(deleteBtn)){
        return YES;
    }else if (action == @selector(btnShakeStop)){
        return YES;
    }
    
   
    
    
    return NO;

}



-(void)btnShakeStart{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"btnShakeStart" object:nil];

    
    
}
-(void)allShake:(NSNotification*) notification{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    array=notification.object;
    
    for (int i=0; i<array.count; i++) {
        self.dragEnable=YES;
        [self startShake:self];
        NSArray *views = [self subviews];
        for(UIView* view in views)
        {
            view.userInteractionEnabled=NO;
        }

    }
    
   



}

-(void)allStop:(NSNotification*) notification{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    array=notification.object;
    
    for (int i=0; i<array.count; i++) {
        self.dragEnable=NO;
        
        [self stopShake:self];
        
        NSArray *views = [self subviews];
        for(UIView* view in views)
        {
            view.userInteractionEnabled=YES;
        }
        
        
    }
    
    
    
    
    
}



-(void)btnShakeStop{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"btnShakeStop" object:nil];
    
    
    
}


-(void)dragBtn{
    
    self.dragEnable=YES;
    [self startShake:self];
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        view.userInteractionEnabled=NO;
    }



}
-(void)editBtn{
    
    NSString *str=[NSString stringWithFormat:@"%ld",self.operId];
    
    if ([self.operType isEqualToString:@"button"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editBtn" object:str];
    }else if ([self.operType isEqualToString:@"camera"]){
      
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editCamera" object:str];
        
    
    }else if ([self.operType isEqualToString:@"remote"]){
        
        
    
    
   
   
   
    }else if ([self.operType isEqualToString:@"switch"]){
        
        
         [[NSNotificationCenter defaultCenter] postNotificationName:@"editSwitch" object:str];
        
        
        
        
    }else if ([self.operType isEqualToString:@"number"]){
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editNumber" object:str];
        
        
        
        
    }else if ([self.operType isEqualToString:@"io"]){
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"editIo" object:str];
        
        
        
        
    }
    
    
    
    


}



-(void)synchro{
    
    
    
}

-(void)deleteBtn{

    
    NSString *str=[NSString stringWithFormat:@"%ld",self.operId];
    
    if ([self.operType isEqualToString:@"button"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteBtn" object:str];

    }else if ([self.operType isEqualToString:@"camera"]){
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteCamera" object:str];
        
        
    }else if ([self.operType isEqualToString:@"remote"]){
   [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteremote" object:str];
    
    
    }else if ([self.operType isEqualToString:@"switch"]){
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteSwitch" object:str];
        
        
    }else if ([self.operType isEqualToString:@"number"]){
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteNumber" object:str];
        
        
    }else if ([self.operType isEqualToString:@"io"]){
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"deleteIo" object:str];
        
        
    }
   
    
    
}

-(void)enddragBtn{
    
       self.dragEnable=NO;
    
    [self stopShake:self];
    
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        view.userInteractionEnabled=YES;
    }
    
    
    
    

    
}


#pragma mark - 拖动晃动
- (void)startShake:(UIView* )view
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform, -0.06, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(view.layer.transform, 0.06, 0, 0, 1)];
    [view.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake:(UIView* )imageV
{
    [imageV.layer removeAnimationForKey:@"shakeAnimation"];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
   
    [super touchesBegan:touches withEvent:event];
    
    if (!dragEnable) {
        return;
    }
    UITouch *touch = [touches anyObject];
    NSLog(@"触摸的是谁谁谁%@",touch);
   
    self.currentButton=touch.view.tag;
    self.operId=touch.view.tag;
    beginPoint = [touch locationInView:self];
    

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [super touchesMoved:touches withEvent:event];
    if (!dragEnable) {
        return;
    }

    
    
    //计算位移=当前位置-起始位置
    CGPoint point = [[touches anyObject] locationInView:self];
    float dx = point.x - beginPoint.x;
    float dy = point.y - beginPoint.y;
    
    NSLog(@"当前位置x:%f,y:%f",dx,dy);
    
    //计算移动后的view中心点
    CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
    
    
    /* 限制用户不可将视图托出屏幕 */
    float halfx = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newcenter.x = MAX(halfx, newcenter.x);
    //x坐标右边界
    newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
    
   
    
    //y坐标同理
    float halfy = CGRectGetMidY(self.bounds);
    newcenter.y = MAX(halfy+Navi_height+10, newcenter.y)+Navi_height+10;
    newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y)-Navi_height-10;
    
   
//    [SharePosition shared].xPosition=newcenter.x-50;
//    [SharePosition shared].yPosition=newcenter.y-50;
    
    self.xpositon=newcenter.x;
    self.ypositon=newcenter.y;
    
    
    NSString *currentBtn=[NSString stringWithFormat:@"%ld",self.currentButton];

    
    NSLog(@"当前位置x:%f,y:%f",newcenter.x,newcenter.y);
    
    
    //移动view
    self.center = newcenter;


    
    if ([self.operType isEqualToString:@"button"]) {
        [DatabaseOperation modifyXposition:self.xpositon andYpostion:self.ypositon andButtonId:self.operId];
        
    }else if ([self.operType isEqualToString:@"camera"]){
        
        
        [DatabaseOperation modifyCameraXposition:self.xpositon andYpostion:self.ypositon andCameraId:self.operId];
        
    }else if ([self.operType isEqualToString:@"remote"]){
        
        
        [DatabaseOperation modifyRemoteXposition:self.xpositon andYpostion:self.ypositon andRemoteId:self.operId];
        
    }else if ([self.operType isEqualToString:@"switch"]){
        
        
        [DatabaseOperation modifySwitchXposition:self.xpositon andYpostion:self.ypositon andSwitchId:self.operId];
        
    }else if ([self.operType isEqualToString:@"number"]){
        
        
        [DatabaseOperation modifyNumberXposition:self.xpositon andYpostion:self.ypositon andNumberId:self.operId];
        
    }else if ([self.operType isEqualToString:@"io"]){
        
        
        [DatabaseOperation modifyIoXposition:self.xpositon andYpostion:self.ypositon andIoId:self.operId];
            }
    
   
    
   



}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
