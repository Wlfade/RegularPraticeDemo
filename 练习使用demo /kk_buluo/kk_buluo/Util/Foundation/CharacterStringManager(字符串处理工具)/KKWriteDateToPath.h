//
//  KKWriteDateToPath.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/3.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKWriteDateToPath : NSObject
+ (void)writeDataToFilePath:(NSString *)filePath withData:(id)dict;
@end

NS_ASSUME_NONNULL_END
