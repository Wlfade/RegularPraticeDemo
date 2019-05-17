//
//  KKContractHeaderView.h
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KKContractHeaderViewDelegate <NSObject>

@optional
- (void)didSelectContractHeaderViewForRow:(NSIndexPath *)indexPath;

@end

@interface KKContractHeaderView : UIView

@property (nonatomic, strong) UITableView *headerTabView;
@property (nonatomic, weak) id<KKContractHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
