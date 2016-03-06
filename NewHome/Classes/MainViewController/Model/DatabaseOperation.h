//
//  DatabaseOperation.h
//  NewHome
//
//  Created by 小热狗 on 15/7/17.
//  Copyright (c) 2015年 小热狗. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HostModal.h"
#import "RoomModal.h"
#import "ButtonModal.h"
#import "QuickButton.h"
#import "PresetData.h"
#import "CameraModal.h"
#import "RemoteModal.h"
#import "RemoteBtn.h"
#import "SwitchModal.h"
#import "NumberModal.h"
#import "IOModal.h"
#import "LogModal.h"
#import <AVFoundation/AVFoundation.h>

@interface DatabaseOperation : NSObject<AVAudioPlayerDelegate>
{
    AVAudioPlayer *player;
    
}


//创建数据库
+(void)createSqlite:(NSString *)dataName;

//创建数据表格
+(void)createPresetData:(NSString *)hostId;
//引用导入数据库
+(void)importSqlite:(NSString *)sqliteStr;
////根据主机创建数据库
//+(void)createSqlite:(HostModal *)modal;


/***************************插入数据******************************/
// 插入主机模型数据
+ (BOOL)insertHostModal:(HostModal *)modal;
// 插入房间模型数据
+ (BOOL)insertRoomModal:(RoomModal *)modal hostId:(long)hostId;
// 插入按钮模型数据
+ (BOOL)insertButtonModal:(ButtonModal *)modal;
// 插入快按钮
+ (BOOL)insertQuickModal:(QuickButton *)modal;
// 插入最新数据表格
+ (void)insertPresetModal:(PresetData *)modal tableName:(NSString *)tableName;

//插入摄像头模型数据
+ (BOOL)insertCameraModal:(CameraModal *)modal;

//插入遥控板模型数据
+ (void)insertRemoteModal:(RemoteModal *)modal;

//插入开关模型数据
+ (BOOL)insertSwitchModal:(SwitchModal *)modal;

//插入数值模型数据
+ (BOOL)insertNumberModal:(NumberModal *)modal;
//插入IO模型数据
+ (BOOL)insertIOModal:(IOModal *)modal;

//插入log日志数据
+ (BOOL)insertLogModal:(LogModal *)modal;

/*************************查询********************************/
/** 查询主机数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryHostsData:(NSString *)querySql;

/** 查询房间数据,如果 传空 默认会查询表中所有数据 */
+ (NSArray *)queryRoomData:(NSString *)querySql;


/** 通过房间Id查询按钮数据 */
+ (NSArray *)queryButtonData:(long)roomId;


/** 通过房间Id查询摄像头数据 */
+ (NSArray *)queryCameraData:(long)roomId;

/** 通过房间Id查询遥控板 */
+ (NSArray *)queryRemoteData:(long)roomId;
/** 通过房间Id查询按钮数据 */
+ (NSArray *)queryRemoteBtnData:(long)remoteId;

/** 通过remoteBtnId查询按钮数据 */
+ (RemoteBtn *)queryEditRemoteBtn:(long)remoteBtnId;


/** 通过房间Id查询开关数据 */
+ (NSArray *)querySwitchData:(long)roomId;
/** 通过开关地址码查询 */
+ (NSArray *)querySwitchs:(NSString *)switchAddr roomId:(long)roomId;

/** 通过房间Id查询数值数据 */
+ (NSArray *)queryNumbedrData:(long)roomId;
/** 通过房间Id查询IO数据 */
+ (NSArray *)queryIOData:(long)roomId;

/** 通过主机Id查询Log数据 */
+ (NSArray *)queryLogData:(long)hostId;



/** 通过cameraId查询按钮数据 */
+ (RemoteBtn *)queryRemoteButton:(long)remoteId;

/** 通过cameraId查询按钮数据 */
+ (CameraModal *)queryCamera:(long)cameraId;
/** 通过switchId查询按钮数据 */
+ (SwitchModal *)querySwitch:(long)switchId;
/** 通过numberId查询按钮数据 */
+ (NumberModal *)queryNumber:(long)numberId;
/** 通过ioId查询按钮数据 */
+ (IOModal *)queryIo:(long)ioId;
/** 通过switchAddr查询按钮数据 */
+ (SwitchModal *)queryCurrentSwitch:(NSString *)switchAddr switchId:(long)switchId;

/** 通过numberAddr查询按钮数据 */
+ (NumberModal *)queryCurrentNumber:(NSString *)numberAddr;
/** 查询主机状态 */
+(BOOL)queryHostStatus;

/** 查询是数值或开关 */
+(NSString *)querySwitchOrNumber:(NSString *)addrCode;

/** 通过数据查询数据模型 */
+(PresetData *)queryPresetModal:(NSString *)preset_data hostId:(long)hostId;


/** 通过数据id查询数据模型 */

+(PresetData *)queryPresetDataType:(long)presetId;
/* 查询连接主机 */

+(HostModal *)queryConnectHost;

/* 查询主机下的房间 */
+ (NSArray *)queryRoomsData:(NSInteger)hostId roomType:(NSInteger)roomType;

/*通过房间id查询房间*/
+(RoomModal *)queryRoom:(NSInteger)roomId hostId:(NSInteger)hostId;

/*通过类型名字查询数据内容*/
+ (NSArray *)queryPresetData;

/*通过类型查询数据内容*/
+ (NSArray *)queryCategroyPredata:(NSInteger)data_type tableName:(NSString *)tableName;



/*通过数据id查询数据内容*/
+(NSString *)queryData:(NSInteger)PresetId;
/*通过快捷按钮id查询数据内容*/
+(NSString *)queryQuickBtnData:(long)quickBtnId;

/*通过按钮id查询数据内容*/
+(NSString *)queryBtnData:(long)buttonId;
/*通过主机id查询快捷按钮*/
+(NSArray *)queryQuick:(long)hostId;

/*通过主机id查询主机数据*/
+(HostModal *)queryHostData:(long)hostId;
/*查询所有数据内容*/
+ (NSArray *)queryPreset:(NSString *)querySql;

/** 通过buttonId查询按钮数据 */
+ (ButtonModal *)queryBtn:(long)btnId;


/** 通过quickId查询按钮数据 */
+ (QuickButton *)queryQuickBtn:(long)quickId;

/*通过遥控板id,按钮id查询按钮信息*/
+(RemoteBtn *)queryRemoteBtn:(NSInteger)buttonId;

/** 语音查询 */
+(void)queryVoiceKey:(NSString *)words hostId:(long)hostId voiceNumber:(long)voiceNb;
/*************************修改********************************/


/*修改主机数据*/
+(BOOL)modifyHostData:(HostModal *)modal hostId:(long)hostId;


/*修改数据名字*/
+(BOOL)modifyPresetName:(NSString *)presetName presetId:(long)presetId hostId:(long)hostId;


/*修改按钮坐标*/
+(void)modifyXposition:(int)xpositon andYpostion:(int)yposition andButtonId:(int)buttonid;


/*修改摄像头坐标*/
+(void)modifyCameraXposition:(int)xpositon andYpostion:(int)yposition andCameraId:(int)cameraId;


/*修改遥控板坐标*/
+(void)modifyRemoteXposition:(int)xpositon andYpostion:(int)yposition andRemoteId:(int)remoteId;

/*修改开关坐标*/
+(void)modifySwitchXposition:(int)xpositon andYpostion:(int)yposition andSwitchId:(int)switchId;

/*修改数值坐标*/
+(void)modifyNumberXposition:(int)xpositon andYpostion:(int)yposition andNumberId:(int)numberId;
/*修改io坐标*/
+(void)modifyIoXposition:(int)xpositon andYpostion:(int)yposition andIoId:(int)ioId;
//修改按钮
+(BOOL)modifyBtnData:(ButtonModal *)modal buttonId:(long)buttonId;

//修改快捷按钮
+(BOOL)modifyQuickBtnData:(QuickButton *)modal quickId:(long)quickId;
//修改摄像头
+(BOOL)modifyCameraData:(CameraModal *)modal cameraId:(long)cameraId;
//修改开关
+(BOOL)modifySwitchData:(SwitchModal *)modal switchId:(long)switchId;
//修改数值
+(BOOL)modifyNumberData:(NumberModal *)modal numberId:(long)numberId;
//修改数值
+(BOOL)modifyIoData:(IOModal *)modal ioId:(long)ioId;
//修改遥控板按钮
+(BOOL)modifyRemoteBtnData:(RemoteBtn *)modal btnId:(long)btnId;

//编辑设备分组
+(BOOL)modifyEquipRoomName:(NSString *)roomName roomBackgroud:(NSString *)roomBackgroud roomIcon:(NSInteger)roomIcon roomId:(long)roomId;
//编辑房间
+(BOOL)modifyRoomName:(NSString *)roomName roomBackgroud:(NSString *)roomBackgroud roomId:(long)roomId;
/*************************删除********************************/
/*删除主机数据*/
+(BOOL)deleteHostData:(long)hostId;

/**删除按钮**/
+(BOOL)deleteBtn:(long)buttonId;

/**删除快捷按钮**/
+(BOOL)deleteQuickBtn:(long)quickId;

/**删除摄像头**/
+(BOOL)deleteCamera:(long)cameraId;
/**删除遥控板**/
+(BOOL)deleteRemote:(long)remoteId;

/**删除开关**/
+(BOOL)deleteSwitch:(long)switchId;
/**删除数值**/
+(BOOL)deleteNumber:(long)numberId;
/**删除IO**/
+(BOOL)deleteIo:(long)ioId;
/**删除房间**/
+(BOOL)deleteRoom:(long)roomId;

/**删除日志**/
+(BOOL)deleteLog:(long)hostId;


/** 删除数据,如果 传空 默认会删除表中所有数据 */
+ (BOOL)deleteData:(NSString *)deleteSql;

/** 修改数据 */
+ (BOOL)modifyData:(NSString *)modifySql;






/*************************其他********************************/

/** 切换主机 */
+ (void)changeHost:(NSInteger)hostId;

/**获取第一个房间**/
+(long)getFirstRoomId:(long)hostId;
/**通过第一个房间id获取图片路径**/
+(NSString *)getDataThroughFirstRoomId:(long)firstRoomId;

-(void)playOk;

@end
