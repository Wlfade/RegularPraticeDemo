//
//  KKDynamicTransmitViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/3/21.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "BaseViewController.h"
#import "KKDynamicWholeItem.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKDynamicTransmitViewController : BaseViewController
@property(nonatomic,strong) KKDynamicWholeItem *dynamicWholeItem;

//@property (nonatomic,strong) NSAttributedString *selfDefineText;
@property (nonatomic,strong) NSString *selfDefineText;

/** 转发成功block */
@property(nonatomic,strong)void(^transBlock)(KKDynamicWholeItem *);
@end

NS_ASSUME_NONNULL_END
