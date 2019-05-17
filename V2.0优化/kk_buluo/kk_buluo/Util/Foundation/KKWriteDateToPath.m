//
//  KKWriteDateToPath.m
//  kk_buluo
//
//  Created by 单车 on 2019/4/3.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKWriteDateToPath.h"

@implementation KKWriteDateToPath
+ (void)writeDataToFilePath:(NSString *)filePath withData:(id)dict{
    //    NSString * path =@"/Users/danche/Desktop/动态/topic.plist";
    BOOL iswriteSucess = [dict writeToFile:filePath atomically:YES];
}
@end
