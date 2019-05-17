//
//  KKFollowerItem.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKFollowerItem : NSObject
/** 用户id */
@property (nonatomic,strong) NSString *commonObjectId;
/** 头像地址 */
@property (nonatomic,strong) NSString *commonObjectLogoUrl;
/** 用户昵称 */
@property (nonatomic,strong) NSString *commonObjectName;

@property (nonatomic,strong) NSString *commonObjectTypeName;

@property (nonatomic,strong) UIImage *placeholdImage;

@property (nonatomic,strong) UIColor *titleColor;
@end

NS_ASSUME_NONNULL_END
