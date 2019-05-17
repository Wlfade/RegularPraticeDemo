//
//  DGParseTool.h
//  DGTool
//
//  Created by david on 2018/10/9.
//  Copyright © 2018 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DGParseTool : NSObject



/**
 向dicArray里边 添加构建出来的key-value对
 @discussion 会调用addMapToArr: forKey:map:definedKey:definedKey 且默认definedKey=key_map
 */
+ (nonnull NSMutableArray *)addMapToArr:(nonnull NSMutableArray *)mArr forKey:(nonnull NSString *)key map:(nonnull NSDictionary *)map;

/**
 向dicArray里边 添加构建出来的key-value对
 
 @param mArr  需要加键值对的目标,mArr里边元素是dic
 @param key  dic元素的key,用此key对应的value(必须是String)作为key,去获取map对应的value
 @param map  原料map
 @param definedKey  新构建键值对,自定义的key
 @return  被构建出来的新数组
 
 * mArr = @[@{id:001, name:aaa},@{id: 002, name:bbb}];
 * map = @{001: 18岁, 002: 20岁}
 * 这里的key=id, 假定definedKey=age
 * 结果:resultArr = @[@{id:001, name:aaa, age:18岁},@{id: 002, name:bbb, age:20岁}];
 */
+ (NSMutableArray *)addMapToArr:(nonnull NSMutableArray *)mArr forKey:(nonnull NSString *)key map:(nonnull NSDictionary *)map definedKey:(nonnull NSString *)definedKey;



/**
 向dicArray里边 添加构建出来的key-value对
 
 @param mArr  需要加键值对的目标,mArr里边元素是dic
 @param key   dic元素的key,要拼接到prefix后边的str
 @param prefix   前缀
 @param definedKey   新构建键值对,自定义的key
 @return 被构建出来的新数组
 
 * mArr = @[@{id:001, name:aaa},@{id: 002, name:bbb}];
 * prefix = @"http://xxx.resource?userId="
 * 这里的key=id, 假定definedKey=userLogoUrl
 * 结果:resultArr = @[@{id:001, name:aaa, userLogoUrl:http://xxx.resource?userId=001},@{id: 002, name:bbb, userLogoUrl:http://xxx.resource?userId=002}];
 */
+ (nonnull NSMutableArray *)addKeyValueToArr:(nonnull NSMutableArray *)mArr forKey:(nonnull NSString *)key prefix:(nonnull NSString *)prefix definedKey:(nonnull NSString *)definedKey;


/**
 向dicArray里边 添加构建出来的布尔值的key-value对
 
 @param mArr  需要加键值对的目标,mArr里边元素是dic
 @param key   dic元素的key,用此key对应的value(必须是String),judgeArr判断是否包含此value,来决定生成的bool值
 @param judgeArr   bool值的判断依据Arr,
 @param definedKey   新构建键值对,自定义的key
 @return 被构建出来的新数组
 
 * mArr = @[@{id:001, name:aaa},@{id: 002, name:bbb}];
 * juedgeArr = @[002,004,005]
 * 这里的key=id, 假定definedKey=selected
 * 结果:resultArr = @[@{id:001, name:aaa, selected:NO},@{idStr: 002, name:bbb, selected:YES}];
 */
+ (nonnull NSMutableArray *)addBoolValueToArr:(nonnull NSMutableArray *)mArr forKey:(nonnull NSString *)key judgeArr:(nonnull NSArray *)judgeArr definedKey:(nonnull NSString *)definedKey;

@end
