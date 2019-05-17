//
//  KKPersonalPageTableHeadView.h
//  kk_buluo
//
//  Created by 樊星 on 2019/3/24.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKPersonalPageModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    
    PERSONAL_PAGE_OWNER, //自己个人主页
    PERSONAL_PAGE_OTHER, //他人个人主页
    PERSONAL_PAGE_GROUP, //群主页
    PERSONAL_PAGE_GUILD,  //公会号主页
    
}KKPersonPageType;
typedef void(^openWepAppActionBlock)(KKPersonalPageModel *model);
@interface KKPersonalPageTableHeadView : UITableViewHeaderFooterView
@property (nonatomic, assign) KKPersonPageType personalPageType;
@property (nonatomic, strong) KKPersonalPageModel *model;
@property (nonatomic, copy)   void (^clickTitle)(NSString *title);
@property (nonatomic, copy)   void (^clickGroup)(KKPersonalPageGroupModel *groupModel);
@property (nonatomic, copy) openWepAppActionBlock openWepAppActionBlock;
+(CGFloat)getHeadViewHeightWithPersonalPageType:(KKPersonPageType)type andUserModel:(KKPersonalPageModel *)model;
@end

NS_ASSUME_NONNULL_END
