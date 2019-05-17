//
//  BaseViewController.h
//  DGTool
//
//  Created by david on 2018/12/26.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Base.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WhereType) {
    KKMyWebAppListViewControllerType = 0,
    KKDiscoverVCType,
    KKPersonalPageControllerType,
    KKChatSetGuildVCType,
    KKChatVCType,
};

@interface BaseViewController : UIViewController

@property (nonatomic,strong) NSString *fromStr;

@property (nonatomic,strong) NSString *toStr;
@property (nonatomic, assign) WhereType fromWhere;

@end

NS_ASSUME_NONNULL_END
