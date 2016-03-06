//
//  LGSocketServe.m
//  AsyncSocketDemo
//
//  Created by ligang on 15/4/3.
//  Copyright (c) 2015年 ligang. All rights reserved.
//

#import "LGSocketServe.h"
#import "DatabaseOperation.h"
#import "HostModal.h"
#import "MainView.h"
#import "LogModal.h"
#import "UpView.h"
//自己设定
#define HOST @"192.168.0.1"
#define PORT 8080

//设置连接超时
#define TIME_OUT 5

//设置读取超时 -1 表示不会使用超时
#define READ_TIME_OUT -1

//设置写入超时 -1 表示不会使用超时
#define WRITE_TIME_OUT -1

//每次最多读取多少
#define MAX_BUFFER 1024


@implementation LGSocketServe


static LGSocketServe *socketServe = nil;

#pragma mark public static methods


+ (LGSocketServe *)sharedSocketServe {
    @synchronized(self) {
        if(socketServe == nil) {
            socketServe = [[[self class] alloc] init];
        }
    }
    return socketServe;
}


+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (socketServe == nil)
        {
            socketServe = [super allocWithZone:zone];
            return socketServe;
        }
    }
    return nil;
}


- (void)startConnectSocket:(NSString *)address port:(NSString *)port hostId:(long)hostId;
{
   
    
    
    currentHostId=hostId;
    self.ipAddress=address;
    self.ipPort=port;
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    [self.socket setRunLoopModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
    [self SocketOpen:address port:[port integerValue] ];
    
}

- (NSInteger)SocketOpen:(NSString*)addr port:(NSInteger)port
{
    
    if (![self.socket isConnected])
    {
        NSError *error = nil;
        [self.socket connectToHost:addr onPort:port withTimeout:TIME_OUT error:&error];
    }
    
    return 0;
}


-(void)cutOffSocket
{
    self.socket.userData = SocketOfflineByUser;
    [self.socket disconnect];
}


- (void)sendMessage:(id)message
{
    NSData *data=[self stringToByte:message];
    NSLog(@"%@",data);

    [self.socket writeData:data withTimeout:WRITE_TIME_OUT tag:1];
}





#pragma mark - Delegate

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
    
    
    if (sock.userData == SocketOfflineByServer) {
        // 服务器掉线，重连
        
        if ([[CurrentTableName shared].netStatus isEqualToString:@"wifi"]) {
            
            NSLog(@"wifi内网连接失败");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"netChange" object:nil];
            
        }
        
        
       
    }
    else if (sock.userData == SocketOfflineByUser) {
        
        
        
        
//        // 如果由用户断开，不进行重连
//         NSLog(@"如果由用户断开，重连");
       // [self startConnectSocket:hostModal.host_network port:hostModal.network_port hostId:hostModal._id];
        return;
    }else if (sock.userData == SocketOfflineByWifiCut) {
        
        // wifi断开，不进行重连
         NSLog(@"wifi断开，重连");
      //  [self startConnectSocket:hostModal.host_network port:hostModal.network_port hostId:hostModal._id];

        return;
    }
    
}



- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err
{
    
    
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"netOff" object:nil];
    NSLog(@"已经断开连接");
    
    
    NSData * unreadData = [sock unreadData]; // ** This gets the current buffer
    if(unreadData.length > 0) {
        [self onSocket:sock didReadData:unreadData withTag:0]; // ** Return as much data that could be collected
    } else {
        
       // NSLog(@" willDisconnectWithError %ld   err = %@",sock.userData,[err description]);
        if (err.code == 57) {
            self.socket.userData = SocketOfflineByWifiCut;
        }
    }
    
}



- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
    NSLog(@"didAcceptNewSocket");
}


- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{

    NSString *str;
    //这是异步返回的连接成功，
    NSLog(@"已经连接上主机");
    if ([[CurrentTableName shared].netStatus isEqualToString:@"wifi"]) {
        str=@"wifi";
    }else if ([[CurrentTableName shared].netStatus isEqualToString:@"wwan"]||[[CurrentTableName shared].netStatus isEqualToString:@"wifiNet"]){
         str=@"wwan";
        
    }
    checkRecive=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showNetIcon" object:str];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //通过定时器不断发送消息，来检测长连接
        [NSTimer scheduledTimerWithTimeInterval:20 target:self selector:@selector(checkLongConnectByServe) userInfo:nil repeats:YES];

    });
  }

//-(void)operationTimer{
//           [self.heartTimer invalidate];
//        self.heartTimer=nil;
//    
//    
//}


// 心跳连接
-(void)checkLongConnectByServe{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"chekeSocket" object:nil];
   
    if (checkRecive==NO) {
        
    
    NSLog(@"正在重连");
      //[self operationTimer];
       //[self localNotify:@"正在重连"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reconnect" object:nil];

    
    
    }else{
        //[self localNotify:@"向服务器发送固定可是的消息，来检测长连接"];

    
    NSLog(@"向服务器发送固定可是的消息，来检测长连接");
    
    checkRecive=NO;
        
    }
}

-(void)netChange{
    NSLog(@"正在切换");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"netChange" object:nil];
}
//接受消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
        
     [CurrentTableName shared].hostSynStatus=@"willrecive";
    
     pushWord=NO;
    //服务端返回消息数据量比较大时，可能分多次返回。所以在读取消息的时候，设置MAX_BUFFER表示每次最多读取多少，当data.length < MAX_BUFFER我们认为有可能是接受完一个完整的消息，然后才解析
    if( data.length < MAX_BUFFER )
    {
        
        NSString *recvStr=[NSString stringWithFormat:@"%@",data]; //收到的数据
        NSLog(@"主机放回数据:%@",recvStr);
        NSRange recvRange= NSMakeRange(1,2);
        NSString *recvHead=[recvStr substringWithRange:recvRange];//判断头
       
#pragma mark 主机同步
        if ([[CurrentTableName shared].hostIsSyn isEqualToString:@"sysYes"]) {
            NSString *hostCompleteStr;//主机完整的字符
            NSString *hostHead;
            NSString *hostTail=@"01>";//主机同步尾巴

            //主机“sysYes”正在同步
            if ([recvHead isEqualToString:@"bb"]||[recvHead isEqualToString:@"cc"]||[recvHead isEqualToString:@"dd"]||[recvHead isEqualToString:@"ee"]||[recvHead isEqualToString:@"BB"]||[recvHead isEqualToString:@"CC"]||[recvHead isEqualToString:@"DD"]||[recvHead isEqualToString:@"EE"]) {
                //头包含bb,cc,dd,ee
                
                NSRange hostTailRange = [recvStr rangeOfString:hostTail];//判断主机字符串是否完整
                
                if (hostTailRange.length >0)//包含
                {
                    hostCompleteStr=recvStr;//即包含头，又包含尾巴
                    NSRange handRecvRange= NSMakeRange(1,2);
                    hostHead=[hostCompleteStr substringWithRange:handRecvRange];//判断头
                    
                }else{
                    //不完整
                    [CurrentTableName shared].synOne=[recvStr stringByReplacingOccurrencesOfString:@">" withString:@""];//第一部分
                    return;
                }
            }else{
                //头不包含bb,cc,dd,ee
                [CurrentTableName shared].synTwo=[recvStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
                 hostCompleteStr=[[CurrentTableName shared].synOne stringByAppendingString:[CurrentTableName shared].synTwo];//获得完整的主机字符
                NSRange handRecvRange= NSMakeRange(1,2);
                hostHead=[hostCompleteStr substringWithRange:handRecvRange];//判断头

               }
            if ([hostHead isEqualToString:@"bb"]||[hostHead isEqualToString:@"cc"]||[hostHead isEqualToString:@"dd"]||[hostHead isEqualToString:@"ee"]||[hostHead isEqualToString:@"BB"]||[hostHead isEqualToString:@"CC"]||[hostHead isEqualToString:@"DD"]||[hostHead isEqualToString:@"EE"]) {
                [CurrentTableName shared].synOne=@"";
                
                
                NSArray *hostArray=[hostCompleteStr componentsSeparatedByString:@" "];
                NSString *hostData=[hostArray componentsJoinedByString:@""];
                NSString *handleHostStr=[hostData stringByReplacingOccurrencesOfString:hostTail withString:@""];//处理好的主机字符
                if (handleHostStr.length<7) {
                    return;
                }
                
                
                NSString *hostLastStr=[handleHostStr substringFromIndex:7];
                NSString *otherStr=[hostData substringFromIndex:7];
                NSString *opertationStr=[otherStr substringToIndex:4];
                if ([opertationStr isEqualToString:@"0801"]) {
                    return;
                }
                NSString *chine=[self changeLanguage:hostLastStr];
                NSLog(@"-------------%@",chine);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"hostSyn" object:chine];
        
            }
        
        }
        
        
        
#pragma mark 文字反馈
         NSString *textCompleteStr;//文字完整的字符
         NSString *textContainStr=@"eeeeeeeeeeee";//反馈包含字符
         NSArray *textArray=[recvStr componentsSeparatedByString:@" "];
         NSString *textData=[textArray componentsJoinedByString:@""];
         NSString *handTextRecvHead;//处理后的文字头判断
         if ([recvHead isEqualToString:@"d7"]||[recvHead isEqualToString:@"D7"]){
            //头包含d7
           NSRange textContainRange = [textData rangeOfString:textContainStr];//判断文字字符串是否完整
             if (textContainRange.length >0)//包含
             {
                 textCompleteStr=textData;//即包含头，又包含eeeeeeeeeeee
                 NSRange handRecvRange= NSMakeRange(1,2);
                 handTextRecvHead=[textCompleteStr substringWithRange:handRecvRange];//判断头
                 
             }else{
                 //不完整
                 [CurrentTableName shared].feedBackOne=[recvStr stringByReplacingOccurrencesOfString:@">" withString:@""];//第一部分
                 return;
             }
         
         }else{
            //头不包含d7
             [CurrentTableName shared].feedBackTwo=[recvStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
             textCompleteStr=[[CurrentTableName shared].feedBackOne stringByAppendingString:[CurrentTableName shared].feedBackTwo] ;
             NSArray *textNotContainArray=[textCompleteStr componentsSeparatedByString:@" "];
             textCompleteStr=[textNotContainArray componentsJoinedByString:@""];
             NSRange handRecvRange= NSMakeRange(1,2);
             handTextRecvHead=[textCompleteStr substringWithRange:handRecvRange];//判断头
            
         }
        if ([handTextRecvHead isEqualToString:@"d7"]||[handTextRecvHead isEqualToString:@"D7"]){
        //最终执行文字反馈回调
            [self textFeedBack:textCompleteStr textContainStr:textContainStr];
            [CurrentTableName shared].feedBackOne=@"";
        }
    
 #pragma mark 开关和数值返回
        NSString *numAndSwiCompleteStr;//开关数值完整的字符
        NSString *numAndSwiTail=@"0f>";//开关数值尾巴
        NSString *numAndSwiData;
        NSString *handNumAndSwiRecvHead;//处理后的文字头判断
       if ([recvHead isEqualToString:@"1a"]||[recvHead isEqualToString:@"1A"]){
         //头包含1a
            
           NSRange numAndSwiTailRange = [recvStr rangeOfString:numAndSwiTail];//判断数值开关字符串是否完整
           
           if (numAndSwiTailRange.length >0)//包含
           {
               numAndSwiCompleteStr=recvStr;//即包含头，又包含尾巴
               
               NSRange handRecvRange= NSMakeRange(1,2);
               NSArray *numAndSwiArray=[numAndSwiCompleteStr componentsSeparatedByString:@" "];
               numAndSwiData=[numAndSwiArray componentsJoinedByString:@""];
               handNumAndSwiRecvHead=[numAndSwiCompleteStr substringWithRange:handRecvRange];//判断头

               
           }else{
               //不完整
               [CurrentTableName shared].numAndSwiOne=[recvStr stringByReplacingOccurrencesOfString:@">" withString:@""];//第一部分
               return;
           }

       }else{
           //头不包含1a
           [CurrentTableName shared].numAndSwiTwo=[recvStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
           numAndSwiCompleteStr=[[CurrentTableName shared].numAndSwiOne stringByAppendingString:[CurrentTableName shared].numAndSwiTwo];//获得完整的主机字符
           NSArray *numAndSwiArray=[numAndSwiCompleteStr componentsSeparatedByString:@" "];
           numAndSwiData=[numAndSwiArray componentsJoinedByString:@""];
           NSRange handRecvRange= NSMakeRange(1,2);
           handNumAndSwiRecvHead=[numAndSwiCompleteStr substringWithRange:handRecvRange];//判断头

      
       }
        if ([handNumAndSwiRecvHead isEqualToString:@"1a"]||[handNumAndSwiRecvHead isEqualToString:@"1A"]){
            //最终执行文字反馈回调
            [self numberAndSwitch:numAndSwiData];
            [CurrentTableName shared].numAndSwiOne=@"";
        }
        
#pragma mark io返回
         NSString *ioCompleteStr;//开关数值完整的字符
         NSString *ioData;
         NSString *ioRecvHead;//处理后的文字头判断

        
        if ([recvHead isEqualToString:@"ab"]||[recvHead isEqualToString:@"AB"]){
            if (recvStr.length==42) {
               //完整
                ioCompleteStr=recvStr;
                NSRange handRecvRange= NSMakeRange(1,2);
                NSArray *ioArray=[ioCompleteStr componentsSeparatedByString:@" "];
                ioData=[ioArray componentsJoinedByString:@""];
                ioRecvHead=[ioCompleteStr substringWithRange:handRecvRange];//判断头
            checkRecive=YES;
            }else{
                
                
              //不完整
                 [CurrentTableName shared].ioOne=[recvStr stringByReplacingOccurrencesOfString:@">" withString:@""];//第一部分
                return;
            }
        
        }else{
            [CurrentTableName shared].ioTwo=[recvStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
            ioCompleteStr=[[CurrentTableName shared].ioOne stringByAppendingString:[CurrentTableName shared].ioTwo];//获得完整的主机字符
            NSArray *ioArray=[ioCompleteStr componentsSeparatedByString:@" "];
            ioData=[ioArray componentsJoinedByString:@""];
            NSRange handRecvRange= NSMakeRange(1,2);
            ioRecvHead=[ioCompleteStr substringWithRange:handRecvRange];//判断头
       }
        if ([ioRecvHead isEqualToString:@"ab"]||[ioRecvHead isEqualToString:@"AB"]){
            
             checkRecive=YES;
            //最终执行文字反馈回调
            [self ioVaulue:ioData];
            [CurrentTableName shared].ioOne=@"";
        }
        
#pragma mark 温度湿度设防撤防
        NSString *enviCompleteStr;//开关数值完整的字符
        NSString *enviRecvHead;//处理后的文字头判断
        if ([recvHead isEqualToString:@"33"]){
            if (recvStr.length==13) {
            //checkRecive=YES;
                NSLog(@"收到探测器出错");
               
            }
            
            
            
            if (recvStr.length==19) {
                //完整
                enviCompleteStr=recvStr;
                NSRange handRecvRange= NSMakeRange(1,2);
               enviRecvHead=[enviCompleteStr substringWithRange:handRecvRange];//判断头
                
            }else{
                //不完整
                [CurrentTableName shared].enviOne=[recvStr stringByReplacingOccurrencesOfString:@">" withString:@""];//第一部分
                return;
            }
            
        }else{
            [CurrentTableName shared].enviTwo=[recvStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
            enviCompleteStr=[[CurrentTableName shared].enviOne stringByAppendingString:[CurrentTableName shared].enviTwo];//获得完整的主机字符
            NSRange handRecvRange= NSMakeRange(1,2);
            enviRecvHead=[enviCompleteStr substringWithRange:handRecvRange];//判断头
        }
        if ([enviRecvHead isEqualToString:@"33"]){
            //checkRecive=YES;
            NSLog(@"收到");
          
            //最终执行文字反馈回调
            [self environment:enviCompleteStr];
            [CurrentTableName shared].enviOne=@"";
        }



    
    }
   
    
    [self.socket readDataWithTimeout:READ_TIME_OUT buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
    
}


//发送消息成功之后回调
- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //读取消息
    [self.socket readDataWithTimeout:-1 buffer:nil bufferOffset:0 maxLength:MAX_BUFFER tag:0];
}


#pragma mark 数据处理
-(NSString*)changeLanguage:(NSString*)chinese{
    NSString *strResult;
    // NSLog(@"chinese:%@",chinese);
    if (chinese.length%2==0) {
        //第二次转换
        NSData *newData = [self hexToByteToNSData:chinese];
        unsigned long encode = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        strResult = [[NSString alloc] initWithData:newData encoding:encode];
        NSLog(@"strResult:%@",strResult);
    }else{
        NSString *strResult = @"已假定是汉字的转换，所传字符串的长度必须是4的倍数!";
        NSLog(@"%@",strResult);
        return NULL;
    }
    return strResult;
}

-(NSData *)hexToByteToNSData:(NSString *)str{
    int j=0;
    Byte bytes[[str length]/2];
    for(int i=0;i<[str length];i++)
    {
        int int_ch;  ///两位16进制数转化后的10进制数
        unichar hex_char1 = [str characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        unichar hex_char2 = [str characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        int_ch = int_ch1+int_ch2;
        bytes[j] = int_ch;  ///将转化后的数放入Byte数组里
        //        if (j==[str length]/2-2) {
        //            int k=2;
        //            int_ch=bytes[0]^bytes[1];
        //            while (k
        //                int_ch=int_ch^bytes[k];
        //                k++;
        //            }
        //            bytes[j] = int_ch;
        //        }
        j++;
    }
    NSData *newData = [[NSData alloc] initWithBytes:bytes length:[str length]/2 ];
    NSLog(@"%@",newData);
    return newData;
}
-(NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"------字符串=======%@",unicodeString);
    return unicodeString;
    
    
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


-(int)EnvironmentData:(NSString *)enviData{
    
    int int_ch = 0;  /// 两位16进制数转化后的10进制数
    
    for(int i=0;i<[enviData length];i++)
    {
        
        
        unichar hex_char1 = [enviData characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
        i++;
        
        unichar hex_char2 = [enviData characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            int_ch2 = hex_char2-87; //// a 的Ascll - 97
        
        int_ch = int_ch1+int_ch2;
        NSLog(@"int_ch=%d",int_ch);
        
    }
    
    
    return int_ch;
}


-(NSString *)getCurrentTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}


//处理温度湿度设防撤防反馈回调
-(void)environment:(NSString *)environmentStr{
    NSRange range = NSMakeRange(5,2);
    NSString *temperature = [environmentStr substringWithRange:range];
    int tempData=[self EnvironmentData:temperature];
    NSRange range1 = NSMakeRange(10,2);
    NSString *wet=[environmentStr substringWithRange:range1];
     int wetData=[self EnvironmentData:wet];
    NSRange range3=NSMakeRange(12, 2);
   NSString *defenseStr=[environmentStr substringWithRange:range3];
    NSArray *array=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d",tempData],[NSString stringWithFormat:@"%d",wetData],defenseStr, nil];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"temAndwet" object:array];

    
    
}



//处理io反馈回调
-(void)ioVaulue:(NSString *)ioCompleteStr{
    NSString *firStr=[ioCompleteStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *newStr=[firStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *recStr=[newStr substringFromIndex:2];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ioStatus" object:recStr];
    
}
//处理开关数值反馈回调
-(void)numberAndSwitch:(NSString *)numAndSwiCompleteStr{
    
    NSString *firStr=[numAndSwiCompleteStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *newStr=[firStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSString *addStr=[newStr substringToIndex:10];
    NSString *lineStr=[newStr substringFromIndex:10];
    NSString *codeStr=[DatabaseOperation querySwitchOrNumber:addStr];
    if ([codeStr isEqualToString:@"switch"]) {
        NSArray *array=[NSArray arrayWithObjects:addStr,lineStr, nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"switchStatus" object:array];
        
        
    }else if ([codeStr isEqualToString:@"number"]){
        
        if (lineStr.length==14) {
            NSString *fontColor1;
            NSString *fontColor2;
            NSString *fontValue1;
            NSString *fontValue2;
            NSRange range= NSMakeRange(4,2);
            NSRange range1= NSMakeRange(2,2);
            NSRange range3= NSMakeRange(10,2);
            NSRange range4= NSMakeRange(8,2);
            
            NSString *color1=[lineStr substringWithRange:range];
            NSString *vlaue1=[lineStr substringWithRange:range1];
            NSString *color2=[lineStr substringWithRange:range3];
            NSString *vlaue2=[lineStr substringWithRange:range4];
            if ([color1 isEqualToString:@"00"]) {
                fontColor1=@"white";
            }else if ([color1 isEqualToString:@"01"]) {
                fontColor1=@"green";
            }
            if ([color2 isEqualToString:@"00"]) {
                fontColor2=@"white";
            }else if ([color2 isEqualToString:@"01"]) {
                fontColor2=@"green";
            }
            
            fontValue1=[NSString stringWithFormat:@"%d",[self EnvironmentData:vlaue1]];
            fontValue2=[NSString stringWithFormat:@"%d",[self EnvironmentData:vlaue2]];
            NSArray *array=[NSArray arrayWithObjects:fontValue1,fontColor1,fontValue2,fontColor2,addStr, nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"numberStatus" object:array];
            
        }
        
        
    }
    
}

//处理文字反馈回调
-(void)textFeedBack:(NSString *)textCompleteStr textContainStr:(NSString *)textContainStr{
    NSString *firStr=[textCompleteStr stringByReplacingOccurrencesOfString:@"<" withString:@""];
    NSString *newStr=[firStr stringByReplacingOccurrencesOfString:@">" withString:@""];
    NSArray *array=[newStr componentsSeparatedByString:textContainStr];//分割eeeeeeee
    NSString *backStr=[array objectAtIndex:0];
    if ([backStr length]>10){
       [[NSNotificationCenter defaultCenter] postNotificationName:@"voiceShake" object:nil];
        NSString *str1=[backStr substringToIndex:10];
        NSString *str2=[str1 substringFromIndex:8];
        if ([str2 isEqualToString:@"01"]) {
            NSString *str3=[backStr substringFromIndex:10];
            NSString *chine=[self changeLanguage:str3];
            if ([chine isEqualToString:@"设防开启"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"defenseOpen" object:nil];
            }else if ([chine isEqualToString:@"设防关闭"]){
                [[NSNotificationCenter defaultCenter] postNotificationName:@"defenseClose" object:nil];
            }
             NSString *pushStatus=[appDelegate.appDefault objectForKey:@"pushStatus"];
            if ([pushStatus isEqualToString:@"pushOpen"]||[pushStatus isEqualToString:@"first"]) {
                //获取应用程序沙盒的Documents目录
                NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
                NSString *plistPath1 = [paths objectAtIndex:0];
                
                //得到完整的文件名
                NSString *filename=[plistPath1 stringByAppendingPathComponent:@"pushKey.plist"];
                NSMutableDictionary *data1 = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
                if (data1==nil) {
                    [self localNotify:chine];
                }else{
                    NSString *open=[data1 objectForKey:@"openPushKey"];
                    if ([open isEqualToString:@"NO"]) {
                        [self localNotify:chine];
                    }else{
                        
                        for (int k=1; k<=5; k++) {
                            NSString *keyWord=[data1 objectForKey:[NSString stringWithFormat:@"key%d",k]];
                            if ([chine rangeOfString:keyWord].location != NSNotFound) {
                                
                                pushWord=YES;
                                
                            }
                        }
                        if (pushWord==YES) {
                            [self localNotify:chine];
                        }
                        
                    }
                    
                    
                }
                
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"chinese" object:chine];
                // [MainView firstLabel:chine];
                NSString *time=[self getCurrentTime];
                LogModal *logModal=[LogModal logModalWith:time content:chine hostId:currentHostId logId:0];
                
                BOOL isInsert=[DatabaseOperation insertLogModal:logModal];
                if (isInsert) {
                    NSLog(@"日志添加成功");
                    
                }else{
                    NSLog(@"日志添加失败");
                }
                
                
            }else if ([str2 isEqualToString:@"02"]){
                //                    NSString *str3=[str2 substringFromIndex:10];
                //                    NSString *chine=[self changeLanguage:str3];
                //                    NSLog(@"反馈：%@,%@",str3,chine);
                //                    [_mainView secondLabel:chine];
                
            }
        }
    }
    
    
}






-(void)localNotify:(NSString *)content{
    
    // 初始化本地通知对象
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification) {
        // 设置通知的提醒时间
        NSDate *currentDate   = [NSDate date];
        notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
        notification.fireDate = [currentDate dateByAddingTimeInterval:0.2];
        // 设置提醒的文字内容
        notification.alertBody   = content;
        notification.alertAction = NSLocalizedString(@"查看", nil);
        // 通知提示音 使用默认的
        notification.soundName= UILocalNotificationDefaultSoundName;
        
        // 设置应用程序右上角的提醒个数
    [UIApplication sharedApplication].applicationIconBadgeNumber +=1;
        // 设定通知的userInfo，用来标识该通知
        
        NSDictionary *dict =[NSDictionary dictionaryWithObjectsAndKeys:@"notification",@"nfkey",nil];
        [notification setUserInfo:dict];
        // 将通知添加到系统中
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    
    
    
}


@end
