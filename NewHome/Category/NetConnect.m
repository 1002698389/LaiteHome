//
//  NetConnect.m
//  NewHome
//
//  Created by 小热狗 on 15/7/22.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "NetConnect.h"
#import "AsyncSocket.h"
#import "HostModal.h"
@implementation NetConnect



//连接主机
-(void)connectHost:(HostModal *)modal{
    
    
 [self connectHost:modal.host_intranet andPort:[modal.intranet_port integerValue]]; //通过内网及内网端口连接主机
  
    
    
}

-(void)connectHost:(NSString *)hostIp andPort:(int)port{
    
    [self connectServer:hostIp port:port];
    // [self connectServer:hostIp port:port];
    
    
    
}


- (void)reconnect:(NSString *)hostIP andHostPort:(int)hostPort{
    
    int stat = [self connectServer:hostIP port:hostPort];
    switch (stat) {
        case SRV_CONNECT_SUC:
            [self showMessage:@"连接成功"];
            break;
        case SRV_CONNECTED:
            [self showMessage:@"已经连接"];
            break;
        default:
            break;
    }
    
    
}


- (void)sendMsg:(NSString *)dataMsg{
    
    
    NSData *data=[self stringToByte:dataMsg];
    NSLog(@"%@",data);
    
    [client writeData:data withTimeout:-1 tag:0];
    
    
    
    
}


//连接sever
-(int)connectServer: (NSString *) hostIP port:(int) hostPort{
    
    if (client == nil) {
        client = [[AsyncSocket alloc] initWithDelegate:self];
        NSError *err = nil;
        //192.168.110.128
        if (![client connectToHost:hostIP onPort:hostPort error:&err]) {
            NSLog(@"%ld %@", (long)[err code], [err localizedDescription]);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[@"Connection failed to host "
                                                                     stringByAppendingString:hostIP]
                                                            message:[[[NSString alloc]initWithFormat:@"%ld",(long)[err code]] stringByAppendingString:[err localizedDescription]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            //client = nil;
            return SRV_CONNECT_FAIL;
        } else {
            NSLog(@"连接成功");
            return SRV_CONNECT_SUC;
        }
    }
    else {
        [client readDataWithTimeout:-1 tag:0];
        return SRV_CONNECTED;
    }
    
}


#pragma mark socket uitl

- (void) showMessage:(NSString *) msg{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}


#pragma mark socket delegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port{
    
    
    NSString *msg = @"连接成功";
    [self showMessage:msg];
    
    [client readDataWithTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    NSLog(@"连接错误");
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    NSString *msg = @"连接失败";
    [self showMessage:msg];
    
    client = nil;
}

- (void)onSocketDidSecure:(AsyncSocket *)sock{
    
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    
 NSString *enviStr=[NSString stringWithFormat:@"%@",data];
    NSLog(@"收到");
    NSLog(@"%@",data);
//    NSRange range = NSMakeRange(5,2);
//    
//    NSString *temperature = [enviStr substringWithRange:range];
//    int tempData=[self EnvironmentData:temperature];
//    NSRange range1 = NSMakeRange(10,2);
//    NSString *wet=[enviStr substringWithRange:range1];
//    int wetData=[self EnvironmentData:wet];
//    NSRange range2 = NSMakeRange(12,2);
//    // NSString *defence=[enviStr substringWithRange:range2];
//    
//    [environmentView setTemperature:tempData Wet:wetData];
//    
//    
//    
//    NSLog(@"wendu :%@",enviStr);
//    
//    NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Hava received datas is :%@",aStr);
//    //self.outputMsg.text = aStr;
    
    [client readDataWithTimeout:-1 tag:0];
}

//发送消息数据转换
-(NSData*)stringToByte:(NSString*)string
{
    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!=0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    return bytes;
}


@end
