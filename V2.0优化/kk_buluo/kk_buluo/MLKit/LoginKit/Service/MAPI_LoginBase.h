//
//  MAPI_LoginBase.h
//  LoginKit
//
//  Created by david on 2019/2/21.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginKit.h"

NS_ASSUME_NONNULL_BEGIN


/**
 * LoginKitBlock
 *
 * modifiedDic 修改过的error字典
 *
 * resModel 后台返回数据处理后的对象
 */
typedef void(^LoginKitBlock)(NSDictionary * __nullable modifiedDic, ResModel * _Nonnull resModel);


@interface MAPI_LoginBase : NSObject

/**
 * @brief 额外参数,会添加到http请求的params中
 *
 * 其key是后台定的字段, value是要设置的值
 */
@property (nonatomic,copy) NSDictionary *extraParamDic;


/**
 * @brief 发请求 (父类声明,由子类实现)
 * @param view 展示提示的view
 * @param mask 是否有菊花提示
 * @param block 完成请求回调block
 */
- (void)requestAtView:(nullable UIView *)view mask:(BOOL)mask block:(nullable LoginKitBlock)block;

@end

NS_ASSUME_NONNULL_END
