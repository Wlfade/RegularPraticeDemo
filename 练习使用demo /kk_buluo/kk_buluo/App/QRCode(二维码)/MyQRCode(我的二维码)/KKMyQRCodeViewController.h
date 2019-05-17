//
//  KKMyQRCodeViewController.h
//  kk_buluo
//
//  Created by 单车 on 2019/4/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QRCodeType) {
    QRCodeTypeUSER= 0, //个人
    QRCodeTypeGROUP, //群
    QRCodeTypeGUILD //工会
};

NS_ASSUME_NONNULL_BEGIN

@interface KKMyQRCodeViewController : UIViewController

-(instancetype)initWithType:(QRCodeType )type withId:(NSString * _Nullable)objctId;

@end

NS_ASSUME_NONNULL_END
