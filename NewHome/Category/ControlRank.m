//
//  ControlRank.m
//  NewHome
//
//  Created by 小热狗 on 16/2/4.
//  Copyright © 2016年 小热狗. All rights reserved.
//

#import "ControlRank.h"
#define XCOUNT 7
#define YCOUNT 3
#define Margin 10
@implementation ControlRank
+(NSDictionary *)throughItmes:(long)itmes{
     NSDictionary *dic;
    float baseY=8+Navi_height+50;
    float baseX=50;
    float width=(SCREEN_WIDTH-2*baseX)/XCOUNT;
    float height=(SCREEN_HEIGHT-2*Navi_height-16)/YCOUNT;
    int i;//第几行
    int j;//第几列
    NSLog(@"%ld",itmes/(XCOUNT*YCOUNT));
    NSLog(@"%ld",itmes%(XCOUNT*YCOUNT));

    
    
    if (itmes<=XCOUNT-1) {
        i=0;
        j=itmes;
    
    
    }else if (itmes/(XCOUNT*YCOUNT)<1) {
        i=itmes/XCOUNT;
        j=itmes%XCOUNT;
    
    }else{
        if (itmes%(XCOUNT*YCOUNT)==0) {
            i=0;
            j=0;
        }else{
            int n=itmes%(XCOUNT*YCOUNT);
            if (n<=XCOUNT-1) {
                i=0;
                j=n;
            }else{
                i=n/XCOUNT;
                j=n%XCOUNT;
            
            }
            
        }
 
    }
                float x=baseX+j*width;
                float y=baseY+i*height;
                
                NSString *xp=[NSString stringWithFormat:@"%f",x];
                NSString *yp=[NSString stringWithFormat:@"%f",y];
                
                dic=@{@"x":xp,@"y":yp};

    return dic;
    
    
}
@end
