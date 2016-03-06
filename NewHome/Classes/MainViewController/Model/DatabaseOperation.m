//
//  DatabaseOperation.m
//  NewHome
//
//  Created by 小热狗 on 15/7/17.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import "DatabaseOperation.h"
#import "FMDatabase.h"
#import "HostModal.h"
#import "RemoteBtn.h"
#import "FMDatabaseAdditions.h"
#import "AppDelegate.h"

#define LVSQLITE_NAME @"home.sqlite"

@implementation DatabaseOperation


static FMDatabase *_fmdb;


#pragma mark 数据库创建
//创建数据库
+(void)createSqlite:(NSString *)dataName;
{
    NSString *documentsDir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES) objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [documentsDir stringByAppendingPathComponent: dataName]];
    NSLog(@"databasePath=%@",databasePath);
    NSError *err;
    BOOL isExit;
    //声明一个文件管理类
    NSFileManager *fm=[NSFileManager defaultManager];
     //[fm removeItemAtPath:databasePath error:nil];
    if (![fm fileExistsAtPath:databasePath]) {
        NSString *source=[[NSBundle mainBundle]pathForResource:@"sysdata" ofType:@"sqlite"];
        isExit=[fm copyItemAtPath:source toPath:databasePath error:&err];

        if (isExit&&err==nil) {
            NSLog(@"数据库文件复制成功");
            _fmdb=[FMDatabase databaseWithPath:databasePath];
            if (_fmdb) {
                [_fmdb open];
                
                NSLog(@"数据库文件打开成功");
            }else{
                NSLog(@"数据库文件打开失败");
            }

        }else{
            NSLog(@"数据库文件复制失败");
        }
    }else{
        NSLog(@"数据库文件已经存在");
        
        _fmdb=[FMDatabase databaseWithPath:databasePath];
        if (_fmdb) {
            [_fmdb open];

            NSLog(@"数据库文件打开成功");
        }else{
            NSLog(@"数据库文件打开失败");
        }
    }
    
    
}
//引用导入数据库
+(void)importSqlite:(NSString *)sqliteStr{
    
    NSString *documentsDir =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask,
                                                                 YES) objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [documentsDir stringByAppendingPathComponent: sqliteStr]];
    NSLog(@"databasePath=%@",databasePath);
    NSError *err;
    BOOL isExit;
    //声明一个文件管理类
    NSFileManager *fm=[NSFileManager defaultManager];
    //[fm removeItemAtPath:databasePath error:nil];
    if (![fm fileExistsAtPath:databasePath]) {
        NSArray* foo = [sqliteStr componentsSeparatedByString: @"."];
        NSString* str1 = [foo objectAtIndex: 0];
         NSString* str2 = [foo objectAtIndex: 1];
        
        NSString *source=[[NSBundle mainBundle]pathForResource:str1 ofType:str2];
        isExit=[fm copyItemAtPath:source toPath:databasePath error:&err];
        
        if (isExit&&err==nil) {
            NSLog(@"数据库文件复制成功");
            _fmdb=[FMDatabase databaseWithPath:databasePath];
            if (_fmdb) {
                [_fmdb open];
                
                NSLog(@"数据库文件打开成功");
            }else{
                NSLog(@"数据库文件打开失败");
            }
            
        }else{
            NSLog(@"数据库文件复制失败");
        }
    }else{
        NSLog(@"数据库文件已经存在");
        
        _fmdb=[FMDatabase databaseWithPath:databasePath];
        if (_fmdb) {
            [_fmdb open];
            
            NSLog(@"数据库文件打开成功");
        }else{
            NSLog(@"数据库文件打开失败");
        }
    }

    
    
}
//创建数据表格
+(void)createPresetData:(NSString *)hostId{
    
    NSString *createSql=[NSString stringWithFormat:@"CREATE TABLE '%@' (_id INTEGER, name CHAR(7), data_type INTEGER,data CHAR(26))",hostId];
    [_fmdb executeUpdate:createSql];
    
    
}










#pragma mark 数据添加

//主机插入数据
+ (BOOL)insertHostModal:(HostModal *)modal{
   
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO host(_id, host_network, host_intranet,network_port,intranet_port,imei,type,host_name) VALUES (null, '%@', '%@','%@','%@','%@','%zd','%@');",modal.host_network,modal.host_intranet,modal.network_port,modal.intranet_port,modal.imei,modal.type,modal.host_name];
    
    return [_fmdb executeUpdate:insertSql];
}


// 插入房间模型数据
+ (BOOL)insertRoomModal:(RoomModal *)modal hostId:(long)hostId{
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO rooms(_id,room_name,room_background,room_icon,room_type,host_id) VALUES (null, '%@', '%@','%zd','%zd','%zd');",modal.room_name,modal.room_background,modal.room_icon,modal.room_type,hostId];
    return [_fmdb executeUpdate:insertSql];
}
// 插入按钮模型数据
+ (BOOL)insertButtonModal:(ButtonModal *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Room_Buttons(_id,button_room,button_name,button_icon,preset_data_id,button_x,button_y,width,height,defaultIcon,cutomSelect,net_data) VALUES (null, '%zd','%@','%@','%zd','%zd','%zd','%f','%f','%zd','%zd','%@');",modal.button_room,modal.button_name,modal.button_icon,modal.preset_data_id,modal.button_x,modal.button_y,modal.width,modal.height,modal.defaultIocn,modal.customSelect,modal.net_data];
    return [_fmdb executeUpdate:insertSql];
    
  }

//快捷按钮模型数据
+ (BOOL)insertQuickModal:(QuickButton *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Quick_button(_id,button_name,preset_data_id,host_id,net_data) VALUES (null, '%@', '%ld','%zd','%@');",modal.button_name,(long)modal.preset_data_id,modal.host_id,modal.net_data];
    return [_fmdb executeUpdate:insertSql];
    
}

//插入摄像头模型数据
+ (BOOL)insertCameraModal:(CameraModal *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Camear(_id,room_id,uid,user_name,password,camear_x,camear_y,definition,camear_name,width,height,cutomSelect) VALUES (null,'%ld','%@','%@','%@','%zd','%zd','%zd','%@','%f','%f','%zd');",(long)modal.room_id,modal.uid,modal.user_name,modal.password,modal.camear_x,modal.camear_y,modal.definition,modal.camear_name,modal.width,modal.height,modal.customSelect];
    return [_fmdb executeUpdate:insertSql];
    
}


//插入开关模型数据
+ (BOOL)insertSwitchModal:(SwitchModal *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO SwitchBtn(_id,roomId,switchName,switchAddr,switchIcon,swichLine,swich_x,swich_y) VALUES (null,'%ld','%@','%@','%zd','%zd','%zd','%zd');",(long)modal.room_id,modal.switchName,modal.switchAddr,modal.switchIcon,modal.switchLine,modal.switch_x,modal.switch_y];
    return [_fmdb executeUpdate:insertSql];
    
}

//插入数值模型数据
+ (BOOL)insertNumberModal:(NumberModal *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO NumberVaule(_id,roomId,numberName,numberAddr,valueOne,ValueTwo,number_x,number_y,width,height,cutomSelect) VALUES (null,'%ld','%@','%@','%@','%@','%zd','%zd','%f','%f','%zd');",(long)modal.room_id,modal.numberName,modal.numberAddr,modal.numberOne,modal.numberTwo,modal.number_x,modal.number_y,modal.width,modal.height,modal.customSelect];
    return [_fmdb executeUpdate:insertSql];
    
}

//插入IO模型数据
+ (BOOL)insertIOModal:(IOModal *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO IOValue(_id,roomId,ioName,io_x,io_y,width,height,cutomSelect) VALUES (null,'%ld','%@','%zd','%zd','%f','%f','%zd');",(long)modal.room_id,modal.ioName,modal.io_x,modal.io_y,modal.width,modal.height,modal.customSelect];
    return [_fmdb executeUpdate:insertSql];
    
}
//插入log日志数据
+ (BOOL)insertLogModal:(LogModal *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Log(_id,createTime,content,hostId) VALUES (null,'%@','%@','%ld');",modal.createTime,modal.content,(long)modal.host_id];
    return [_fmdb executeUpdate:insertSql];
    
}


// 插入遥控板按钮模型数据
+ (BOOL)insertRemoteBtnModal:(RemoteBtn *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO RemoteBtn(_id,button_name,preset_data,remote_id) VALUES (null,'%@','%@','%zd');",modal.button_name,modal.preset_data,modal.remote_id];
    return [_fmdb executeUpdate:insertSql];

}





//插入遥控板模型数据
+ (void)insertRemoteModal:(RemoteModal *)modal{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO Remote(_id,room_id,remote_x,remote_y) VALUES (null,'%ld','%zd','%zd');",(long)modal.room_id,modal.remote_x,modal.remote_y];
    BOOL result=[_fmdb executeUpdate:insertSql];
    if (result) {
        RemoteModal *remoteModal=[RemoteModal new];
        NSArray *arrayModal=[DatabaseOperation queryRemoteData:modal.room_id];
        remoteModal=[arrayModal lastObject];
        
        
        RemoteBtn *modal=[RemoteBtn new];
        modal=[RemoteBtn remoteModalWith:nil preset_data:nil remoteBtnId:0 remoteId:remoteModal._id];
                for (int i=0; i<11; i++) {
                    BOOL isInsertBtn=[DatabaseOperation insertRemoteBtnModal:modal];
            NSLog(@"%hhd",isInsertBtn);
        }
       
    
    
    }
      
}




// 插入最新数据表格
+ (void)insertPresetModal:(PresetData *)modal tableName:(NSString *)tableName{
    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO '%@'(_id,name,data_type,data) VALUES ('%ld', '%@', '%ld','%@');",tableName,(long)modal._id,modal.name,(long)modal.data_type,modal.data];

    [_fmdb executeUpdate:insertSql];
    
}



#pragma mark 数据查询

/** 查询主机数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryHostsData:(NSString *)querySql{
    if (querySql == nil) {
        querySql = @"SELECT * FROM host;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
    
        NSString *  _id          =[set stringForColumn:@"_id"];
        NSString *  hostName     =[set stringForColumn:@"host_name"];
        NSString *  imei         =[set stringForColumn:@"imei"];
        NSString *  host_network =[set stringForColumn:@"host_network"];
        NSString *  network_port =[set stringForColumn:@"network_port"];
        NSString *  host_intranet=[set stringForColumn:@"host_intranet"];
        NSString *  intranet_port=[set stringForColumn:@"intranet_port"];
        NSString *  type         =[set stringForColumn:@"type"];
        
        
        HostModal *modal=[HostModal hostModalWith:hostName imei:imei hostNetwork:host_network hostIntranet:host_intranet networkPort:network_port intranetPort:intranet_port Type:type.integerValue hostId:_id.integerValue];
        [arrM addObject:modal];
    }
    return arrM;

}

/* 查询主机状态 */
+(BOOL)queryHostStatus{
   
      FMResultSet *set=[_fmdb executeQuery:@"select _id,host_network,host_intranet,network_port,intranet_port,imei,type,host_name from host  where type=1"];
    
    
    return [set next];
    
}
/** 查询是数值或开关 */
+(NSString *)querySwitchOrNumber:(NSString *)addrCode{
    NSString *judgeStr;
    FMResultSet *set=[_fmdb executeQuery:[NSString stringWithFormat:@"select _id from SwitchBtn where switchAddr='%@'",addrCode]];
    if ([set next]) {
       judgeStr=@"switch";
    }else{
        judgeStr=@"number";
        
    }
    return judgeStr;
}
/* 查询连接主机 */

+(HostModal *)queryConnectHost{
    
    HostModal *hostModal=[HostModal new];
    FMResultSet *set=[_fmdb executeQuery:@"select _id,host_network,host_intranet,network_port,intranet_port,imei,type,host_name from host  where type=1"];
 while ([set next]) {
    NSString *  _id          =[set stringForColumn:@"_id"];
    NSString *  hostName     =[set stringForColumn:@"host_name"];
    NSString *  imei         =[set stringForColumn:@"imei"];
    NSString *  host_network =[set stringForColumn:@"host_network"];
    NSString *  network_port =[set stringForColumn:@"network_port"];
    NSString *  host_intranet=[set stringForColumn:@"host_intranet"];
    NSString *  intranet_port=[set stringForColumn:@"intranet_port"];
    NSString *  type         =[set stringForColumn:@"type"];
    
    hostModal=[HostModal hostModalWith:hostName imei:imei hostNetwork:host_network hostIntranet:host_intranet networkPort:network_port intranetPort:intranet_port Type:type.integerValue hostId:_id.integerValue];
 }
    return hostModal;
    
}


/** 通过数据查询数据模型 */
+(PresetData *)queryPresetModal:(NSString *)preset_data hostId:(long)hostId{
    PresetData *modal=[PresetData new];
     NSString *querySql=[NSString stringWithFormat:@"select * from '%ld'  where data='%@'",(long)hostId,preset_data];
     FMResultSet *set = [_fmdb executeQuery:querySql];
    while ([set next]) {
        NSString *  _id          =[set stringForColumn:@"_id"];
        NSString *  name     =[set stringForColumn:@"name"];
        NSString *  data_type         =[set stringForColumn:@"data_type"];
         NSString *  syn             =[set stringForColumn:@"syn"];
        
        modal=[PresetData presetDataModalWith:name data_type:data_type.integerValue data:preset_data presetId:_id.integerValue syn:syn];
    }
    return modal;

    
    
}
/** 通过数据id查询数据模型 */
+(PresetData *)queryPresetDataType:(long)presetId{
    
    PresetData *modal=[PresetData new];
    NSString *querySql=[NSString stringWithFormat:@"select * from PRESET_DATA  where _id='%ld'",(long)presetId];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    while ([set next]) {
        
        NSString *  _id          =[set stringForColumn:@"_id"];
        NSString *  name     =[set stringForColumn:@"name"];
        NSString *  data_type         =[set stringForColumn:@"data_type"];
        NSString *  data   =[set stringForColumn:@"data"];
         NSString *  syn             =[set stringForColumn:@"syn"];
        modal=[PresetData presetDataModalWith:name data_type:data_type.integerValue data:data presetId:_id.integerValue syn:syn];
    }
    return modal;
    
    
}

/* 查询主机下的房间 */
+ (NSArray *)queryRoomsData:(NSInteger)hostId roomType:(NSInteger)roomType{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Rooms  where host_id='%ld' and room_type='%ld'",(long)hostId,(long)roomType];

    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  room_name       =[set stringForColumn:@"room_name"];
        NSString *  room_icon       =[set stringForColumn:@"room_icon"];
        NSString *  room_background =[set stringForColumn:@"room_background"];
        NSString *  room_type       =[set stringForColumn:@"room_type"];
               
        RoomModal *modal=[RoomModal roomModalWith:room_name roomIcon:room_icon.integerValue roomBackground:room_background roomHaveCamera:0 cameraAddress:nil cameraUsername:nil cameraPassword:nil hostId:hostId roomType:room_type.integerValue roomId:_id.integerValue];
        [arrM addObject:modal];
    }
    return arrM;
    
}

/*通过房间id查询房间*/
+(RoomModal *)queryRoom:(NSInteger)roomId hostId:(NSInteger)hostId{
    
    
    RoomModal *roomModal=[RoomModal new];
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Rooms  where _id='%ld' and host_id='%ld'",(long)roomId,(long)hostId];
    
   
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  room_name       =[set stringForColumn:@"room_name"];
        NSString *  room_icon       =[set stringForColumn:@"room_icon"];
        NSString *  room_background =[set stringForColumn:@"room_background"];
        NSString *  room_type       =[set stringForColumn:@"room_type"];
        
        roomModal=[RoomModal roomModalWith:room_name roomIcon:room_icon.integerValue roomBackground:room_background roomHaveCamera:0 cameraAddress:nil cameraUsername:nil cameraPassword:nil hostId:hostId roomType:room_type.integerValue roomId:_id.integerValue];
           }
    
    return roomModal;

 }



///*通过遥控板id,按钮id查询按钮信息*/
//+(RemoteBtn *)queryRoom:(NSInteger)remoteId{
//    
//    ButtonModal *modal=[ButtonModal new];
//    NSString *querySql=[NSString stringWithFormat:@"select * from RemoteBtn remote_id='%ld'",(long)remoteId];
//    FMResultSet *set = [_fmdb executeQuery:querySql];
//            
//        while ([set next]) {
//            
//            NSString *  _id             =[set stringForColumn:@"_id"];
//            NSString *  button_room     =[set stringForColumn:@"button_room"];
//            NSString *  button_name     =[set stringForColumn:@"button_name"];
//            NSString *  button_icon     =[set stringForColumn:@"button_icon"];
//            NSString *  preset_data_id  =[set stringForColumn:@"preset_data_id"];
//            NSString *  net_data        =[set stringForColumn:@"net_data"];
//            NSString *  button_x        =[set stringForColumn:@"button_x"];
//            NSString *  button_y        =[set stringForColumn:@"button_y"];
//            NSString *  remote_id       =[set stringForColumn:@"remote_id"];
//            
//            modal=[ButtonModal buttonModalWith:button_room.integerValue buttonName:button_name buttonIcon:button_icon presetDataId:preset_data_id.integerValue netData:net_data buttonX:button_x.integerValue buttonY:button_y.integerValue buttonId:_id.integerValue remote_id:remote_id.integerValue];
//       }
//    
//    return modal;
//
//    
//    
//    
//    
//}
//

/*通过类型名字查询数据内容*/
+ (NSArray *)queryPresetData{
    
    NSString *querySql=@"select _id,name,data_type,data from PRESET_DATA";
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  name            =[set stringForColumn:@"name"];
        NSString *  data_type       =[set stringForColumn:@"data_type"];
        NSString *  data            =[set stringForColumn:@"data"];
        NSString *  syn             =[set stringForColumn:@"syn"];
        PresetData*modal=[PresetData presetDataModalWith:name data_type:data_type.integerValue data:data presetId:_id.integerValue syn:syn];
        
        [arrM addObject:modal];
    }
    return arrM;

    
}


/*通过类型查询数据内容*/
+ (NSArray *)queryCategroyPredata:(NSInteger)data_type tableName:(NSString *)tableName{
    
    NSString *querySql=[NSString stringWithFormat:@"select _id,name,data_type,data from '%@' where data_type='%ld'",tableName,(long)data_type];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  name            =[set stringForColumn:@"name"];
        NSString *  data_type       =[set stringForColumn:@"data_type"];
        NSString *  data            =[set stringForColumn:@"data"];
        NSString *  syn             =[set stringForColumn:@"syn"];
        PresetData*modal=[PresetData presetDataModalWith:name data_type:data_type.integerValue data:data presetId:_id.integerValue syn:syn];
        
        [arrM addObject:modal];
    }
    return arrM;

    
    
    
    
}




/*通过数据id查询数据内容*/
+(NSString *)queryData:(NSInteger)PresetId{
    NSString *presetData;
    
    NSString *querySql=[NSString stringWithFormat:@"select * from PRESET_DATA  where _id='%ld'",(long)PresetId];
    
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
       
       presetData=[set stringForColumn:@"data"];
        
      
    }
    
    return presetData;
  
}




/*通过按钮id查询数据内容*/
+(NSString *)queryBtnData:(long)buttonId{
    
    NSString *presetData;
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Room_Buttons  where _id='%ld'",(long)buttonId];
    
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        presetData=[set stringForColumn:@"net_data"];
        
        
    }
    
    return presetData;

}







/*通过快捷按钮id查询数据内容*/
+(NSString *)queryQuickBtnData:(long)quickBtnId{
    
    NSString *presetData;
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Quick_button  where _id='%ld'",(long)quickBtnId];
    
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        presetData=[set stringForColumn:@"net_data"];
        
        
    }
    
    return presetData;
    
    
    
    
}









/** 通过房间Id查询按钮数据 */
+ (NSArray *)queryButtonData:(long)roomId{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Room_Buttons  where button_room='%ld'",(long)roomId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  button_room     =[set stringForColumn:@"button_room"];
        NSString *  button_name     =[set stringForColumn:@"button_name"];
        NSString *  button_icon     =[set stringForColumn:@"button_icon"];
        NSString *  preset_data_id  =[set stringForColumn:@"preset_data_id"];
        NSString *  net_data        =[set stringForColumn:@"net_data"];
        NSString *  button_x        =[set stringForColumn:@"button_x"];
        NSString *  button_y        =[set stringForColumn:@"button_y"];
         NSString *  width        =[set stringForColumn:@"width"];
         NSString *  height        =[set stringForColumn:@"height"];
         NSString *  defaultIcon        =[set stringForColumn:@"defaultIcon"];
         NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
    ButtonModal *modal=[ButtonModal buttonModalWith:button_room.integerValue buttonName:button_name buttonIcon:button_icon presetDataId:preset_data_id.integerValue netData:net_data buttonX:button_x.integerValue buttonY:button_y.integerValue width:width.floatValue height:height.floatValue defaultIcon:defaultIcon.integerValue customSelect:customSelect.integerValue buttonId:_id.integerValue ];
            [arrM addObject:modal];
    }
    return arrM;
    
    
}

/** 通过房间Id查询摄像头数据 */
+ (NSArray *)queryCameraData:(long)roomId{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Camear  where room_id='%ld'",(long)roomId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  room_id       =[set stringForColumn:@"room_id"];
        NSString *  uid           =[set stringForColumn:@"uid"];
        NSString *  user_name     =[set stringForColumn:@"user_name"];
        NSString *  password      =[set stringForColumn:@"password"];
        NSString *  camear_x      =[set stringForColumn:@"camear_x"];
        NSString *  camear_y      =[set stringForColumn:@"camear_y"];
        NSString *  camear_name   =[set stringForColumn:@"camear_name"];
        NSString *  definition   =[set stringForColumn:@"definition"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        CameraModal *modal=[CameraModal cameraModalWith:camear_name uid:uid user_name:user_name password:password camear_x:camear_x.integerValue camear_y:camear_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue definition:definition.integerValue room_id:room_id.integerValue _id:_id.integerValue];
       
        [arrM addObject:modal];
    }
    return arrM;
    
    
}


/** 通过房间Id查询遥控板 */
+ (NSArray *)queryRemoteData:(long)roomId{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Remote  where room_id='%ld'",(long)roomId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  room_id       =[set stringForColumn:@"room_id"];
        NSString *  remote_x      =[set stringForColumn:@"remote_x"];
        NSString *  remote_y      =[set stringForColumn:@"remote_y"];
       
        RemoteModal *modal=[RemoteModal remoteModalWith:_id.integerValue remote_x:remote_x.integerValue remote_y:remote_y.integerValue room_id:room_id.integerValue];
        
               [arrM addObject:modal];
    }
    return arrM;

    
}
/** 通过开关地址码查询 */
+ (NSArray *)querySwitchs:(NSString *)switchAddr roomId:(long)roomId{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from SwitchBtn  where switchAddr='%@' and roomId='%ld'",switchAddr,roomId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  switchName           =[set stringForColumn:@"switchName"];
        NSString *  switchAddr     =[set stringForColumn:@"switchAddr"];
        NSString *  switchIcon      =[set stringForColumn:@"switchIcon"];
        NSString *  swichLine      =[set stringForColumn:@"swichLine"];
        NSString *  swich_x      =[set stringForColumn:@"swich_x"];
        NSString *  swich_y   =[set stringForColumn:@"swich_y"];
        
        
        SwitchModal *modal=[SwitchModal switchModalWith:switchName switchAddr:switchAddr switchIcon:switchIcon.integerValue switchLine:swichLine.integerValue room_id:roomId.integerValue switch_x:swich_x.integerValue switch_y:swich_y.integerValue _id:_id.integerValue];
        
        
        [arrM addObject:modal];
    }
    return arrM;
    
    
}

/** 通过房间Id查询开关数据 */
+ (NSArray *)querySwitchData:(long)roomId{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from SwitchBtn  where roomId='%ld'",(long)roomId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  switchName           =[set stringForColumn:@"switchName"];
        NSString *  switchAddr     =[set stringForColumn:@"switchAddr"];
        NSString *  switchIcon      =[set stringForColumn:@"switchIcon"];
        NSString *  swichLine      =[set stringForColumn:@"swichLine"];
        NSString *  swich_x      =[set stringForColumn:@"swich_x"];
        NSString *  swich_y   =[set stringForColumn:@"swich_y"];
        
        
        SwitchModal *modal=[SwitchModal switchModalWith:switchName switchAddr:switchAddr switchIcon:switchIcon.integerValue switchLine:swichLine.integerValue room_id:roomId.integerValue switch_x:swich_x.integerValue switch_y:swich_y.integerValue _id:_id.integerValue];
        
        
        [arrM addObject:modal];
    }
    return arrM;
    
    
}



/** 通过房间Id查询数值数据 */
+ (NSArray *)queryNumbedrData:(long)roomId{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from NumberVaule  where roomId='%ld'",(long)roomId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  numberName           =[set stringForColumn:@"numberName"];
        NSString *  numberAddr     =[set stringForColumn:@"numberAddr"];
        NSString *  valueOne      =[set stringForColumn:@"valueOne"];
        NSString *  ValueTwo      =[set stringForColumn:@"ValueTwo"];
        NSString *  number_x      =[set stringForColumn:@"number_x"];
        NSString *  number_y      =[set stringForColumn:@"number_y"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        NumberModal *modal=[NumberModal numberModalWith:numberName numberAddr:numberAddr numberOne:valueOne numberTwo:ValueTwo room_id:roomId.integerValue number_x:number_x.integerValue number_y:number_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue _id:_id.integerValue];
        
      
        
        
        [arrM addObject:modal];
    }
    return arrM;
    
    
}


/** 通过房间Id查询IO数据 */
+ (NSArray *)queryIOData:(long)roomId{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from IOValue  where roomId='%ld'",(long)roomId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  ioName           =[set stringForColumn:@"ioName"];
        NSString *  io_x      =[set stringForColumn:@"io_x"];
        NSString *  io_y      =[set stringForColumn:@"io_y"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        IOModal *modal=[IOModal ioModalWith:ioName room_id:roomId.integerValue io_x:io_x.integerValue io_y:io_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue _id:_id.integerValue];
        
        [arrM addObject:modal];
    }
    return arrM;
    
    
}

/** 通过主机Id查询Log数据 */
+ (NSArray *)queryLogData:(long)hostId{
    NSString *querySql=[NSString stringWithFormat:@"select * from Log  where hostId='%ld'",(long)hostId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  hostId       =[set stringForColumn:@"hostId"];
        NSString *  createTime           =[set stringForColumn:@"createTime"];
        NSString *  content      =[set stringForColumn:@"content"];
        
        LogModal *modal=[LogModal logModalWith:createTime content:content hostId:hostId.integerValue logId:_id.integerValue];
        
        [arrM addObject:modal];
    }
    return arrM;
    
    
}


/** 通过遥控板Id查询按钮数据 */
+ (NSArray *)queryRemoteBtnData:(long)remoteId{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from RemoteBtn  where remote_id='%ld'",(long)remoteId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  button_name     =[set stringForColumn:@"button_name"];
       
        NSString *  preset_data        =[set stringForColumn:@"preset_data"];
       
       
        RemoteBtn *modal=[RemoteBtn remoteModalWith:button_name preset_data:preset_data remoteBtnId:_id.integerValue remoteId:remoteId];
        [arrM addObject:modal];
    }
    return arrM;
    
    
}


+ (RemoteBtn *)queryRemoteButton:(long)remoteId{
    
    RemoteBtn *modal=[RemoteBtn new];
    
    
    NSString *querySql=[NSString stringWithFormat:@"select * from RemoteBtn  where _id='%ld'",(long)remoteId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  button_name     =[set stringForColumn:@"button_name"];
        
        NSString *  preset_data        =[set stringForColumn:@"preset_data"];
        
        
        modal=[RemoteBtn remoteModalWith:button_name preset_data:preset_data remoteBtnId:_id.integerValue remoteId:remoteId];
        
    }
    return modal;

    
    
    
}


/** 通过buttonId查询按钮数据 */
+ (ButtonModal *)queryBtn:(long)btnId{
    
    ButtonModal *modal=[ButtonModal new];

    
    NSString *querySql=[NSString stringWithFormat:@"select * from Room_Buttons  where _id='%ld'",(long)btnId];
    
      FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  button_room     =[set stringForColumn:@"button_room"];
        NSString *  button_name     =[set stringForColumn:@"button_name"];
        NSString *  button_icon     =[set stringForColumn:@"button_icon"];
        NSString *  preset_data_id  =[set stringForColumn:@"preset_data_id"];
        NSString *  net_data        =[set stringForColumn:@"net_data"];
        NSString *  button_x        =[set stringForColumn:@"button_x"];
        NSString *  button_y        =[set stringForColumn:@"button_y"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString *  defaultIcon        =[set stringForColumn:@"defaultIcon"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        modal=[ButtonModal buttonModalWith:button_room.integerValue buttonName:button_name buttonIcon:button_icon presetDataId:preset_data_id.integerValue netData:net_data buttonX:button_x.integerValue buttonY:button_y.integerValue width:width.floatValue height:height.floatValue defaultIcon:defaultIcon.integerValue customSelect:customSelect.integerValue buttonId:_id.integerValue ];

       
        
    }
    return modal;
    
    
}





/** 通过quickId查询按钮数据 */
+ (QuickButton *)queryQuickBtn:(long)quickId{
    
    QuickButton *modal=[QuickButton new];
    
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Quick_button  where _id='%ld'",(long)quickId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
       
        NSString *  button_name     =[set stringForColumn:@"button_name"];
        NSString *  preset_data_id  =[set stringForColumn:@"preset_data_id"];
        NSString *  net_data        =[set stringForColumn:@"net_data"];
        NSString *  host_id        =[set stringForColumn:@"host_id"];
       
        
        modal=[QuickButton quickButtonModalWith:button_name presetDataId:preset_data_id.integerValue hostId:host_id.integerValue quickBtnId:_id.integerValue net_data:net_data];
        
    }
    return modal;

     
}
/*通过遥控板id,按钮id查询按钮信息*/
+(RemoteBtn *)queryRemoteBtn:(NSInteger)buttonId{
    
    RemoteBtn *modal=[RemoteBtn new];
    
    
    NSString *querySql=[NSString stringWithFormat:@"select * from RemoteBtn  where _id='%ld'",(long)buttonId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        
        NSString *  button_name     =[set stringForColumn:@"button_name"];
        NSString *  preset_data  =[set stringForColumn:@"preset_data"];
        NSString *  remote_id        =[set stringForColumn:@"remote_id"];
        
        
        modal=[RemoteBtn remoteModalWith:button_name preset_data:preset_data remoteBtnId:_id.integerValue remoteId:remote_id.integerValue];
        
    }
    return modal;

    
    
    
    
    
    
}

/** 语音查询 */
+(void)queryVoiceKey:(NSString *)words hostId:(long)hostId voiceNumber:(long)voiceNb{
    
    //先查询PRESET_DATA
    NSString *querySql1=[NSString stringWithFormat:@"select * from PRESET_DATA  where name='%@'",words];
    FMResultSet *set1 = [_fmdb executeQuery:querySql1];
    if ([set1 next]) {
        
        NSString *  data            =[set1 stringForColumn:@"data"];
        
        
       
         [[NSNotificationCenter defaultCenter] postNotificationName:@"presetData" object:data];
      
        [CurrentTableName shared].queryResult=@"yes";
        
        
    }else{
        
       //查询同步后PRESET_DATA
        
        NSString *querySql2=[NSString stringWithFormat:@"select * from '%ld'  where name='%@'",hostId,words];
        FMResultSet *set2 = [_fmdb executeQuery:querySql2];
        if ([set2 next]) {
            
            NSString *  data            =[set2 stringForColumn:@"data"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"presetData" object:data];
            
           [CurrentTableName shared].queryResult=@"yes";
            
            
        }else{
               //查询按钮
        NSString *querySql3=[NSString stringWithFormat:@"select * from Room_Buttons  where button_name='%@'",words];
        FMResultSet *set3 = [_fmdb executeQuery:querySql3];
        if ([set3 next]) {
            
        NSString *  data            =[set3 stringForColumn:@"net_data"];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"presetData_syn" object:data];
        
            
            [CurrentTableName shared].queryResult=@"yes";
        }else{
            //查询快捷按钮
            NSString *querySql3=[NSString stringWithFormat:@"select * from Quick_button  where button_name='%@'",words];
            FMResultSet *set3 = [_fmdb executeQuery:querySql3];
            if ([set3 next]) {
                
                NSString *  data            =[set3 stringForColumn:@"net_data"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"presetData_syn" object:data];
               [CurrentTableName shared].queryResult=@"yes";
            }else{
            
            //查询遥控板
            
            NSArray *remoteBtnArr=[self queryRemoteName:words];
            if (remoteBtnArr.count!=0) {
                NSString *  data =remoteBtnArr[0];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"remoteBtnClick" object:data];
            [CurrentTableName shared].queryResult=@"yes";
            }else{
           //查询开关
                
                NSArray *swithArry=[self querySwitchName:words];
                if (swithArry.count!=0) {
                    
                    SwitchModal *switchModal=[SwitchModal new];
                    switchModal=swithArry[0];
                    NSString *switchId=[NSString stringWithFormat:@"%d",switchModal._id];
                    NSString *switchAddr=switchModal.switchAddr;
                    NSString *switchLine=[NSString stringWithFormat:@"%d",switchModal.switchLine];
                    NSArray *array=[NSArray arrayWithObjects:switchId,switchAddr,switchLine, nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"switchClick" object:array];
                
                [CurrentTableName shared].queryResult=@"yes";
                
                }else{
                  //查询数值
                    NSArray *numberArray=[self queryNumberName:words];
                    if (numberArray.count!=0) {
                        NumberModal *numberModal=[NumberModal new];
                        numberModal=numberArray[0];
                        NSString *numAddr=numberModal.numberAddr;
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"numberClick" object:numAddr];
                    
                    
                    [CurrentTableName shared].queryResult=@"yes";
                    
                    }else{
                    
                    
                    
                    //查询io
                    NSArray *ioArray=[self queryIOName:words];
                    if (ioArray.count!=0) {
                        
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"ioClick" object:nil];
                    
                    [CurrentTableName shared].queryResult=@"yes";
                    
                    }else{
                        //查询房间
                        NSString *querySql3=[NSString stringWithFormat:@"select * from Rooms  where room_name='%@' and host_id='%ld'",words,hostId];
                        FMResultSet *set3 = [_fmdb executeQuery:querySql3];
                        if ([set3 next]) {
                            
                            NSString *  _id             =[set3 stringForColumn:@"_id"];
                            
                             [[NSNotificationCenter defaultCenter] postNotificationName:@"roomChange" object:_id];
                          [CurrentTableName shared].queryResult=@"yes";
                            
                            
                            
                        }else{
                            if ([[CurrentTableName shared].queryResult isEqualToString:@"yes"]) {
                                 [CurrentTableName shared].queryResult=@"yes";
                            }else{
                            [CurrentTableName shared].queryResult=@"no";
                            }
                        
                            }
                            
                            
                        
                        
                        
                    }
               
                
                }
                
                }
                
            }
      
        
            }
        
        }
    
   
        }
    
    
    }
    
    
}

/** 通过遥控板名字查询 */
+(NSArray *)queryRemoteName:(NSString *)remoteName{
    NSMutableArray *arrM = [NSMutableArray array];
    NSString *querySql=[NSString stringWithFormat:@"select * from RemoteBtn  where button_name='%@'",remoteName];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    while ([set next]) {
        
        NSString *  preset_data  =[set stringForColumn:@"preset_data"];
    
        
        [arrM addObject:preset_data];
    }
    return arrM;

    
    
}

/** 通过开关名字查询 */
+ (NSArray *)querySwitchName:(NSString *)switchName{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from SwitchBtn  where switchName='%@'",switchName];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  switchName           =[set stringForColumn:@"switchName"];
        NSString *  switchAddr     =[set stringForColumn:@"switchAddr"];
        NSString *  switchIcon      =[set stringForColumn:@"switchIcon"];
        NSString *  swichLine      =[set stringForColumn:@"swichLine"];
        NSString *  swich_x      =[set stringForColumn:@"swich_x"];
        NSString *  swich_y   =[set stringForColumn:@"swich_y"];
        
        
        SwitchModal *modal=[SwitchModal switchModalWith:switchName switchAddr:switchAddr switchIcon:switchIcon.integerValue switchLine:swichLine.integerValue room_id:roomId.integerValue switch_x:swich_x.integerValue switch_y:swich_y.integerValue _id:_id.integerValue];
        
        
        [arrM addObject:modal];
    }
    return arrM;
    
    
}


/** 通过数值名字查询 */
+ (NSArray *)queryNumberName:(NSString *)numberName{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from NumberVaule  where numberName='%@'",numberName];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  numberName           =[set stringForColumn:@"numberName"];
        NSString *  numberAddr     =[set stringForColumn:@"numberAddr"];
        NSString *  valueOne      =[set stringForColumn:@"valueOne"];
        NSString *  ValueTwo      =[set stringForColumn:@"ValueTwo"];
        NSString *  number_x      =[set stringForColumn:@"number_x"];
        NSString *  number_y      =[set stringForColumn:@"number_y"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        NumberModal *modal=[NumberModal numberModalWith:numberName numberAddr:numberAddr numberOne:valueOne numberTwo:ValueTwo room_id:roomId.integerValue number_x:number_x.integerValue number_y:number_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue _id:_id.integerValue];
        
        
        
        
        [arrM addObject:modal];
    }
    return arrM;
    
    
}


/** 通过房间Id查询IO数据 */
+ (NSArray *)queryIOName:(NSString *)ioName{
    
    NSString *querySql=[NSString stringWithFormat:@"select * from IOValue  where ioName='%@'",ioName];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  ioName           =[set stringForColumn:@"ioName"];
        NSString *  io_x      =[set stringForColumn:@"io_x"];
        NSString *  io_y      =[set stringForColumn:@"io_y"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        IOModal *modal=[IOModal ioModalWith:ioName room_id:roomId.integerValue io_x:io_x.integerValue io_y:io_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue _id:_id.integerValue];
        
        [arrM addObject:modal];
    }
    return arrM;
    
    
}


/** 通过cameraId查询按钮数据 */
+ (CameraModal *)queryCamera:(long)cameraId{
    
    CameraModal *modal=[CameraModal new];
    
    
    NSString *querySql=[NSString stringWithFormat:@"select * from Camear  where _id='%ld'",(long)cameraId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  room_id       =[set stringForColumn:@"room_id"];
        NSString *  uid           =[set stringForColumn:@"uid"];
        NSString *  user_name     =[set stringForColumn:@"user_name"];
        NSString *  password      =[set stringForColumn:@"password"];
        NSString *  camear_x      =[set stringForColumn:@"camear_x"];
        NSString *  camear_y      =[set stringForColumn:@"camear_y"];
        NSString *  camear_name   =[set stringForColumn:@"camear_name"];
        NSString *  definition   =[set stringForColumn:@"definition"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        modal=[CameraModal cameraModalWith:camear_name uid:uid user_name:user_name password:password camear_x:camear_x.integerValue camear_y:camear_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue definition:definition.integerValue room_id:room_id.integerValue _id:_id.integerValue];
        
          }
    return modal;
    
    
}


/** 通过switchId查询按钮数据 */
+ (SwitchModal *)querySwitch:(long)switchId{
    
    SwitchModal *modal=[SwitchModal new];
    
    
    NSString *querySql=[NSString stringWithFormat:@"select * from SwitchBtn  where _id='%ld'",(long)switchId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  switchName           =[set stringForColumn:@"switchName"];
        NSString *  switchAddr     =[set stringForColumn:@"switchAddr"];
        NSString *  switchIcon      =[set stringForColumn:@"switchIcon"];
        NSString *  swichLine      =[set stringForColumn:@"swichLine"];
        NSString *  swich_x      =[set stringForColumn:@"swich_x"];
        NSString *  swich_y   =[set stringForColumn:@"swich_y"];
        
        
        modal=[SwitchModal switchModalWith:switchName switchAddr:switchAddr switchIcon:switchIcon.integerValue switchLine:swichLine.integerValue room_id:roomId.integerValue switch_x:swich_x.integerValue switch_y:swich_y.integerValue _id:_id.integerValue];

        
    }
    return modal;
    
    
}

/** 通过numberId查询按钮数据 */
+ (NumberModal *)queryNumber:(long)numberId{
    
    NumberModal *modal=[NumberModal new];
    
    
    NSString *querySql=[NSString stringWithFormat:@"select * from NumberVaule  where _id='%ld'",(long)numberId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  numberName           =[set stringForColumn:@"numberName"];
        NSString *  numberAddr     =[set stringForColumn:@"numberAddr"];
        NSString *  valueOne      =[set stringForColumn:@"valueOne"];
        NSString *  ValueTwo      =[set stringForColumn:@"ValueTwo"];
        NSString *  number_x      =[set stringForColumn:@"number_x"];
        NSString *  number_y      =[set stringForColumn:@"number_y"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        modal=[NumberModal numberModalWith:numberName numberAddr:numberAddr numberOne:valueOne numberTwo:ValueTwo room_id:roomId.integerValue number_x:number_x.integerValue number_y:number_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue _id:_id.integerValue];
        
        
    }
    return modal;
    
    
}
/** 通过ioId查询按钮数据 */
+ (IOModal *)queryIo:(long)ioId{
    IOModal *modal=[IOModal new];
    
    
    NSString *querySql=[NSString stringWithFormat:@"select * from IOValue  where _id='%ld'",(long)ioId];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  ioName           =[set stringForColumn:@"ioName"];
        NSString *  io_x      =[set stringForColumn:@"io_x"];
        NSString *  io_y      =[set stringForColumn:@"io_y"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        modal=[IOModal ioModalWith:ioName room_id:roomId.integerValue io_x:io_x.integerValue io_y:io_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue _id:_id.integerValue];
        
        
    }
    return modal;

    
    
}

/** 通过switchAddr查询按钮数据 */
+ (SwitchModal *)queryCurrentSwitch:(NSString *)switchAddr switchId:(long)switchId{
    SwitchModal *modal=[SwitchModal new];
    
    
    NSString *querySql=[NSString stringWithFormat:@"select * from SwitchBtn  where switchAddr='%@' and _id='%ld'",switchAddr,switchId];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  switchName           =[set stringForColumn:@"switchName"];
        NSString *  switchAddr     =[set stringForColumn:@"switchAddr"];
        NSString *  switchIcon      =[set stringForColumn:@"switchIcon"];
        NSString *  swichLine      =[set stringForColumn:@"swichLine"];
        NSString *  swich_x      =[set stringForColumn:@"swich_x"];
        NSString *  swich_y   =[set stringForColumn:@"swich_y"];
        
        
        modal=[SwitchModal switchModalWith:switchName switchAddr:switchAddr switchIcon:switchIcon.integerValue switchLine:swichLine.integerValue room_id:roomId.integerValue switch_x:swich_x.integerValue switch_y:swich_y.integerValue _id:_id.integerValue];
        
        
    }
    return modal;

       
    
}







/** 通过numberAddr查询按钮数据 */
+ (NumberModal *)queryCurrentNumber:(NSString *)numberAddr{
    
    NumberModal *modal=[NumberModal new];

    NSString *querySql=[NSString stringWithFormat:@"select * from NumberVaule  where numberAddr='%@'",numberAddr];
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        
        NSString *  _id           =[set stringForColumn:@"_id"];
        NSString *  roomId       =[set stringForColumn:@"roomId"];
        NSString *  numberName           =[set stringForColumn:@"numberName"];
        NSString *  numberAddr     =[set stringForColumn:@"numberAddr"];
        NSString *  valueOne      =[set stringForColumn:@"valueOne"];
        NSString *  ValueTwo      =[set stringForColumn:@"ValueTwo"];
        NSString *  number_x      =[set stringForColumn:@"number_x"];
        NSString *  number_y      =[set stringForColumn:@"number_y"];
        NSString *  width        =[set stringForColumn:@"width"];
        NSString *  height        =[set stringForColumn:@"height"];
        NSString    *customSelect  =[set stringForColumn:@"cutomSelect"];
        modal=[NumberModal numberModalWith:numberName numberAddr:numberAddr numberOne:valueOne numberTwo:ValueTwo room_id:roomId.integerValue number_x:number_x.integerValue number_y:number_y.integerValue width:width.floatValue height:height.floatValue customSelect:customSelect.integerValue _id:_id.integerValue];
        
    }
    return modal;
    
    
}

/*通过主机id查询快捷按钮*/
+(NSArray *)queryQuick:(long)hostId{
    NSString *querySql=[NSString stringWithFormat:@"select * from Quick_button  where host_id='%ld'",(long)hostId];
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  button_name     =[set stringForColumn:@"button_name"];
        NSString *  preset_data_id  =[set stringForColumn:@"preset_data_id"];
        NSString *  host_id         =[set stringForColumn:@"host_id"];
        NSString *  net_data        =[set stringForColumn:@"net_data"];
        QuickButton *modal=[QuickButton quickButtonModalWith:button_name presetDataId:preset_data_id.integerValue hostId:host_id.integerValue quickBtnId:_id.integerValue net_data:net_data];
       
        [arrM addObject:modal];
    }
    return arrM;
     
}

/*通过主机id查询主机数据*/
+(HostModal *)queryHostData:(long)hostId{
    HostModal *hostModal=[HostModal new];
    NSString *querySql=[NSString stringWithFormat:@"select * from host where _id='%ld'",(long)hostId];

    FMResultSet *set= [_fmdb executeQuery:querySql];
    while ([set next]) {
        NSString *  _id          =[set stringForColumn:@"_id"];
        NSString *  hostName     =[set stringForColumn:@"host_name"];
        NSString *  imei         =[set stringForColumn:@"imei"];
        NSString *  host_network =[set stringForColumn:@"host_network"];
        NSString *  network_port =[set stringForColumn:@"network_port"];
        NSString *  host_intranet=[set stringForColumn:@"host_intranet"];
        NSString *  intranet_port=[set stringForColumn:@"intranet_port"];
        NSString *  type         =[set stringForColumn:@"type"];
        
        hostModal=[HostModal hostModalWith:hostName imei:imei hostNetwork:host_network hostIntranet:host_intranet networkPort:network_port intranetPort:intranet_port Type:type.integerValue hostId:_id.integerValue];
    }
    return hostModal;
    
}

/** 通过remoteBtnId查询按钮数据 */
+ (RemoteBtn *)queryEditRemoteBtn:(long)remoteBtnId {
    
    RemoteBtn *modal=[RemoteBtn new];
    
    NSString *querySql=[NSString stringWithFormat:@"select * from RemoteBtn  where _id='%ld'",(long)remoteBtnId];
    
    
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id             =[set stringForColumn:@"_id"];
        NSString *  button_name     =[set stringForColumn:@"button_name"];
        
        NSString *  preset_data        =[set stringForColumn:@"preset_data"];
        
        
        modal=[RemoteBtn remoteModalWith:button_name preset_data:preset_data remoteBtnId:_id.integerValue remoteId:remoteBtnId];
        
    }
    return modal;
    
    
}



/** 查询主机数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryPreset:(NSString *)querySql{
    if (querySql == nil) {
        querySql = @"SELECT * FROM PRESET_DATA;";
    }
    
    NSMutableArray *arrM = [NSMutableArray array];
    FMResultSet *set = [_fmdb executeQuery:querySql];
    
    while ([set next]) {
        
        NSString *  _id        =[set stringForColumn:@"_id"];
        NSString *  name       =[set stringForColumn:@"name"];
        NSString *  data_type  =[set stringForColumn:@"data_type"];
        NSString *  data       =[set stringForColumn:@"data"];
        NSString *  syn             =[set stringForColumn:@"syn"];
        PresetData*modal=[PresetData presetDataModalWith:name data_type:data_type.integerValue data:data presetId:_id.integerValue syn:syn];
       
        [arrM addObject:modal];
    }
    return arrM;
    
}




#pragma mark 数据修改
//修改主机
+(BOOL)modifyHostData:(HostModal *)modal hostId:(long)hostId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update host set host_name ='%@',imei='%@',host_network='%@',network_port='%@', host_intranet='%@', intranet_port='%@'  where _id =%ld",modal.host_name,modal.imei,modal.host_network,modal.network_port,modal.host_intranet,modal.intranet_port,hostId];
    return [_fmdb executeUpdate:modifySql];
 
}



//修改按钮
+(BOOL)modifyBtnData:(ButtonModal *)modal buttonId:(long)buttonId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update Room_Buttons set button_name ='%@',button_icon='%@',net_data='%@',defaultIcon='%zd',width='%f',height='%f',cutomSelect='%zd',preset_data_id='%zd' where _id =%ld",modal.button_name,modal.button_icon,modal.net_data,modal.defaultIocn,modal.width,modal.height,modal.customSelect,modal.preset_data_id,buttonId];
    return [_fmdb executeUpdate:modifySql];
    
}


//修改快捷按钮
+(BOOL)modifyQuickBtnData:(QuickButton *)modal quickId:(long)quickId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update Quick_button set button_name ='%@',net_data='%@',preset_data_id='%zd' where _id =%ld",modal.button_name,modal.net_data,modal.preset_data_id,quickId];
    return [_fmdb executeUpdate:modifySql];
    
}
//修改遥控板按钮
+(BOOL)modifyRemoteBtnData:(RemoteBtn *)modal btnId:(long)btnId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update RemoteBtn set button_name ='%@',preset_data='%@' where _id =%ld",modal.button_name,modal.preset_data,btnId];
    return [_fmdb executeUpdate:modifySql];
    
}

//修改摄像头
+(BOOL)modifyCameraData:(CameraModal *)modal cameraId:(long)cameraId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update Camear set camear_name ='%@',uid='%@',user_name='%@',password='%@' ,width='%f',height='%f',cutomSelect='%zd' where _id =%ld",modal.camear_name,modal.uid,modal.user_name,modal.password,modal.width,modal.height,modal.customSelect,cameraId];
    return [_fmdb executeUpdate:modifySql];
    
}

//修改开关
+(BOOL)modifySwitchData:(SwitchModal *)modal switchId:(long)switchId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update SwitchBtn set switchName ='%@',switchAddr='%@',switchIcon='%ld',swichLine='%ld' where _id =%ld",modal.switchName,modal.switchAddr,(long)modal.switchIcon,(long)modal.switchLine,switchId];
    return [_fmdb executeUpdate:modifySql];
    
}

//修改数值
+(BOOL)modifyNumberData:(NumberModal *)modal numberId:(long)numberId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update NumberVaule set numberName ='%@',numberAddr='%@',valueOne='%@',ValueTwo='%@',width='%f',height='%f',cutomSelect='%zd' where _id =%ld",modal.numberName,modal.numberAddr,modal.numberOne,modal.numberTwo,modal.width,modal.height,modal.customSelect,numberId];
    return [_fmdb executeUpdate:modifySql];
    
}

//修改数值
+(BOOL)modifyIoData:(IOModal *)modal ioId:(long)ioId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update IOValue set ioName ='%@',width='%f',height='%f',cutomSelect='%zd' where _id =%ld",modal.ioName,modal.width,modal.height,modal.customSelect,ioId];
    return [_fmdb executeUpdate:modifySql];
    
}







//编辑房间
+(BOOL)modifyRoomName:(NSString *)roomName roomBackgroud:(NSString *)roomBackgroud roomId:(long)roomId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update Rooms set room_name ='%@',room_background='%@' where _id =%ld",roomName,roomBackgroud,roomId];
    
     return [_fmdb executeUpdate:modifySql];
    
    
}

//编辑设备分组
+(BOOL)modifyEquipRoomName:(NSString *)roomName roomBackgroud:(NSString *)roomBackgroud roomIcon:(NSInteger)roomIcon roomId:(long)roomId{
    
    
    NSString *modifySql=[NSString stringWithFormat:@"update Rooms set room_name ='%@',room_background='%@', room_icon='%ld' where _id =%ld",roomName,roomBackgroud,roomIcon,(long)roomId];
    
    return [_fmdb executeUpdate:modifySql];
    
    
}


////修改按钮
//+(BOOL)modifyRoomData:(RoomModal *)modal roomId:(long)roomId{
//    
//    
//    NSString *modifySql=[NSString stringWithFormat:@"update Room_Buttons set button_name ='%@',button_icon='%@',net_data='%@' where _id =%ld",modal.button_name,modal.button_icon,modal.net_data,buttonId];
//    return [_fmdb executeUpdate:modifySql];
//    
//}







/*修改数据名字*/
+(BOOL)modifyPresetName:(NSString *)presetName presetId:(long)presetId hostId:(long)hostId{
    
    NSString *tableName=[NSString stringWithFormat:@"%ld",hostId];
    NSString *modifySql=[NSString stringWithFormat:@"update '%@' set name ='%@'  where _id =%ld",tableName,presetName,presetId];
    return [_fmdb executeUpdate:modifySql];
    
}


/*修改按钮坐标*/
+(void)modifyXposition:(int)xpositon andYpostion:(int)yposition andButtonId:(int)buttonid{
    
    BOOL result=[_fmdb executeUpdate:[NSString stringWithFormat:@"update Room_Buttons set button_x =%d,button_y=%d where _id =%d",xpositon,yposition,buttonid]];
    
    
    NSLog(@"%@",[NSString stringWithFormat:@"update room_buttons set xposition =%d,yposition=%d where id =%d",xpositon,yposition,buttonid]);
    if (result) {
        
        NSLog(@"更新坐标成功");
        
        
    }

    
}


/*修改摄像头坐标*/
+(void)modifyCameraXposition:(int)xpositon andYpostion:(int)yposition andCameraId:(int)cameraId{
    
    BOOL result=[_fmdb executeUpdate:[NSString stringWithFormat:@"update Camear set camear_x =%d,camear_y=%d where _id =%d",xpositon,yposition,cameraId]];
    
    
     if (result) {
        
        NSLog(@"更新坐标成功");
        
        
    }
    
    
    
}



/*修改遥控板坐标*/
+(void)modifyRemoteXposition:(int)xpositon andYpostion:(int)yposition andRemoteId:(int)remoteId{
    
    BOOL result=[_fmdb executeUpdate:[NSString stringWithFormat:@"update Remote set remote_x =%d,remote_y=%d where _id =%d",xpositon,yposition,remoteId]];
    
    
    if (result) {
        
        NSLog(@"更新坐标成功");
        
        
    }
    
    
    
}


/*修改开关坐标*/
+(void)modifySwitchXposition:(int)xpositon andYpostion:(int)yposition andSwitchId:(int)switchId{
    
    BOOL result=[_fmdb executeUpdate:[NSString stringWithFormat:@"update SwitchBtn set swich_x =%d,swich_y=%d where _id =%d",xpositon,yposition,switchId]];
    
    
    if (result) {
        
        NSLog(@"更新坐标成功");
        
        
    }
    
    
    
}


/*修改数值坐标*/
+(void)modifyNumberXposition:(int)xpositon andYpostion:(int)yposition andNumberId:(int)numberId{
    
    BOOL result=[_fmdb executeUpdate:[NSString stringWithFormat:@"update NumberVaule set number_x =%d,number_y=%d where _id =%d",xpositon,yposition,numberId]];
    
    
    if (result) {
        
        NSLog(@"更新坐标成功");
        
        
    }
    
    
    
}

/*修改io坐标*/
+(void)modifyIoXposition:(int)xpositon andYpostion:(int)yposition andIoId:(int)ioId{
    
    BOOL result=[_fmdb executeUpdate:[NSString stringWithFormat:@"update IOValue set io_x =%d,io_y=%d where _id =%d",xpositon,yposition,ioId]];
    
    
    if (result) {
        
        NSLog(@"更新坐标成功");
        
        
    }
    
    
    
}



#pragma mark 数据删除
+(BOOL)deleteHostData:(long)hostId{
  
  NSString *deleteSql=[NSString stringWithFormat:@"DELETE FROM host WHERE _id='%ld'",hostId];
        return [_fmdb executeUpdate:deleteSql];
}



/**删除按钮**/
+(BOOL)deleteBtn:(long)buttonId{
    
   
    NSString *deleteBtn=[NSString stringWithFormat:@"DELETE FROM Room_Buttons WHERE _id='%ld'",buttonId];
    
    return [_fmdb executeUpdate:deleteBtn];
    
    
}


/**删除快捷按钮**/
+(BOOL)deleteQuickBtn:(long)quickId{
    
    NSString *deleteBtn=[NSString stringWithFormat:@"DELETE FROM Quick_button WHERE _id='%ld'",quickId];
    
    return [_fmdb executeUpdate:deleteBtn];
    
    
    
}



/**删除摄像头**/
+(BOOL)deleteCamera:(long)cameraId{
    
    NSString *deleteBtn=[NSString stringWithFormat:@"DELETE FROM Camear WHERE _id='%ld'",cameraId];
    
    return [_fmdb executeUpdate:deleteBtn];
    
    
    
}

/**删除遥控板**/
+(BOOL)deleteRemote:(long)remoteId{
    
    NSString *deleteBtn=[NSString stringWithFormat:@"DELETE FROM Remote WHERE _id='%ld'",remoteId];
    
    return [_fmdb executeUpdate:deleteBtn];
    
    
    
}
/**删除开关**/
+(BOOL)deleteSwitch:(long)switchId{
    
    NSString *deleteBtn=[NSString stringWithFormat:@"DELETE FROM SwitchBtn WHERE _id='%ld'",switchId];
    
    return [_fmdb executeUpdate:deleteBtn];
    
    
    
}
/**删除数值**/
+(BOOL)deleteNumber:(long)numberId{
    
    NSString *deleteBtn=[NSString stringWithFormat:@"DELETE FROM NumberVaule WHERE _id='%ld'",numberId];
    
    return [_fmdb executeUpdate:deleteBtn];
    
    
    
}
/**删除IO**/
+(BOOL)deleteIo:(long)ioId{
    
    NSString *deleteBtn=[NSString stringWithFormat:@"DELETE FROM IOValue WHERE _id='%ld'",ioId];
    
    return [_fmdb executeUpdate:deleteBtn];
    
    
    
}

/**删除房间**/
+(BOOL)deleteRoom:(long)roomId{
    
    
    NSString *deleteRoom=[NSString stringWithFormat:@"DELETE FROM Rooms WHERE _id='%ld'",roomId];
    
    return [_fmdb executeUpdate:deleteRoom];
    
    
}

/**删除日志**/
+(BOOL)deleteLog:(long)hostId{
    
    NSString *deleteLog=[NSString stringWithFormat:@"DELETE FROM Log WHERE hostId='%ld'",hostId];
    
    return [_fmdb executeUpdate:deleteLog];
    
    
    
}

//
///** 查询房间数据,如果 传空 默认会查询表中所有数据 */
//+ (NSArray *)queryRoomData:(NSString *)querySql{
//    
//}
//
//
///** 查询按钮数据,如果 传空 默认会查询表中所有数据 */
//+ (NSArray *)queryButtonData:(NSString *)querySql{
//    
//}
//
///** 查询快捷按钮数据,如果 传空 默认会查询表中所有数据 */
//+ (NSArray *)queryQuickData:(NSString *)querySql{
//    
//}
//












//+ (BOOL)deleteData:(NSString *)deleteSql {
//    
//    if (deleteSql == nil) {
//        deleteSql = @"DELETE FROM t_modals";
//    }
//    
//    return [_fmdb executeUpdate:deleteSql];
//    
//}
//
//+ (BOOL)modifyData:(NSString *)modifySql {
//    
//    if (modifySql == nil) {
//        modifySql = @"UPDATE t_modals SET ID_No = '789789' WHERE name = 'lisi'";
//    }
//    return [_fmdb executeUpdate:modifySql];
//}
//





/** 切换主机 */
+ (void)changeHost:(NSInteger)hostId{
    
  BOOL result=[_fmdb executeUpdate:@"update host set type =0"];
    if (result) {
        
       BOOL re=[_fmdb executeUpdate:[NSString stringWithFormat:@"update host set type =1 where _id =%ld",(long)hostId]];
        
        if (re) {
            NSLog(@"切换主机成功");
        }
    }

}


/**获取第一个房间**/
+(long)getFirstRoomId:(long)hostId{
    
     long roomid = 0;
    FMResultSet *result=[_fmdb executeQuery:[NSString stringWithFormat:@"select *from Rooms where host_id=%ld order by _id limit 0,1",hostId]];
    
    while ([result next]) {
        
        
        roomid=[result intForColumn:@"_id"];
        
    }
   
  return roomid;


}


+(NSString *)getDataThroughFirstRoomId:(long)firstRoomId{
    
    NSString * backStr;
    FMResultSet *result=[_fmdb executeQuery:[NSString stringWithFormat:@"select  room_background from Rooms  where _id=%ld",firstRoomId]];
    
    
    while ([result next]) {
        
        
        backStr=[result stringForColumn:@"room_background"];
        
    }
  


  return backStr;



}



-(void)playOk{
    
    
}

@end
