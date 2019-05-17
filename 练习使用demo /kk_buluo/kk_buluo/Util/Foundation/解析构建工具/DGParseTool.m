//
//  DGParseTool.m
//  DGTool
//
//  Created by david on 2018/10/9.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGParseTool.h"

#define kSuffix @"_map"


@implementation DGParseTool


+ (NSMutableArray *)addMapToArr:(NSMutableArray *)mArr forKey:(NSString *)key map:(NSDictionary *)map{
    NSString *definedKey = [key stringByAppendingString:kSuffix];
    return [self addMapToArr:mArr forKey:key map:map definedKey:definedKey];
}


+ (NSMutableArray *)addMapToArr:(NSMutableArray *)mArr forKey:(NSString *)key map:(NSDictionary *)map definedKey:(NSString *)definedKey{
    
    for (int i=0; i<mArr.count; i++) {
        
        //1.获取需要添加key-value的itemDic
        NSMutableDictionary *itemDic = [[NSMutableDictionary alloc]initWithDictionary:mArr[i]];
        
        //2.过滤
        //2.1 dic中没有指定key的情况
        if (!itemDic[key]) {
            NSLog(@"%@ not found in arr",key);
            continue ;
        }
        NSString *value = [NSString stringWithFormat:@"%@",itemDic[key]];
        
        //2.2 map中没有所需value的情况
        if (!map[value]) {
            NSLog(@"%@ not found in arr",value);
            continue ;
        }
        id mapValue = map[value];
        
        //3.添加 key-value,
        if ([definedKey isEqualToString:key] || definedKey.length < 1) {
            NSString *dKey = [key stringByAppendingString:kSuffix];
            [itemDic setObject:mapValue forKey:[NSString stringWithFormat:@"%@",dKey]];
        }else{
            [itemDic setObject:mapValue forKey:[NSString stringWithFormat:@"%@",definedKey]];
        }
        
        //4.更新mArr中的itemDic
        [mArr replaceObjectAtIndex:i withObject:itemDic];
    }
    
    //5.retutn
    return mArr;
}


+ (NSMutableArray *)addKeyValueToArr:(NSMutableArray *)mArr forKey:(NSString *)key prefix:(NSString *)prefix definedKey:(NSString *)definedKey {
    
    for (NSInteger i=0; i<mArr.count; i++) {
        //1.获取需要添加key-value的itemDic
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:mArr[i]];
        
        //2.过滤 dic中没有指定key的情况
        if (!itemDic[key]) {
            NSLog(@"%@ not found in arr",key);
            continue ;
        }
        NSString *value = [NSString stringWithFormat:@"%@",itemDic[key]];
        
        //3.拼接
        NSString *targetStr = [prefix stringByAppendingString:value];
        
        //4.过滤 targetStr为nil
        if (targetStr.length < 1) {
            continue ;
        }
        
        //5.添加key-value
        [itemDic setObject:targetStr forKey:definedKey];
        
        //6.更新mArr中的itemDic
        [mArr replaceObjectAtIndex:i withObject:itemDic];
    }
    
    //7.return
    return mArr;
}


+ (NSMutableArray *)addBoolValueToArr:(NSMutableArray *)mArr forKey:(NSString *)key judgeArr:(NSArray *)judgeArr definedKey:(NSString *)definedKey {
    
    for (NSInteger i=0; i<mArr.count; i++) {
        //1.获取需要添加key-value的itemDic
        NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:mArr[i]];
        
        //2.过滤 dic中没有指定key的情况
        if (!itemDic[key]) {
            NSLog(@"%@ not found in arr",key);
            continue ;
        }
        NSString *value = [NSString stringWithFormat:@"%@",itemDic[key]];
        
        //3.添加key-value
        if([judgeArr containsObject:value]){
            [itemDic setObject:@(1) forKey:definedKey];
        }else{
            [itemDic setObject:@(0) forKey:definedKey];
        }
        
        //4.更新mArr中的itemDic
        [mArr replaceObjectAtIndex:i withObject:itemDic];
    }
    
    //5.return
    return mArr;
}

@end
