//
//  KKSubjectLengthConfig.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/31.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ContentLengthItem;

@interface KKSubjectLengthConfig : NSObject

@property (nonatomic,assign) NSInteger transmitContentLength;

@property (nonatomic,strong) ContentLengthItem *personal;

@property (nonatomic,strong) ContentLengthItem *normal;
@end

@interface ContentLengthItem : NSObject
@property (nonatomic,assign) NSInteger minContentLength;

@property (nonatomic,assign) NSInteger maxContentLength;

@property (nonatomic,assign) NSInteger minHiddenContentLength;

@property (nonatomic,assign) NSInteger maxTitleLength;

@property (nonatomic,assign) NSInteger maxTagNum;

@property (nonatomic,assign) NSInteger maxHiddenContentLength;

@property (nonatomic,assign) NSInteger minTitleLength;
@end

NS_ASSUME_NONNULL_END
