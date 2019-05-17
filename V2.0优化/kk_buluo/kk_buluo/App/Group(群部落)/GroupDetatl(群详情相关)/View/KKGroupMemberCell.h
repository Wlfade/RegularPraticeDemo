//
//  KKGroupMemberCell.h
//  kk_buluo
//
//  Created by new on 2019/3/18.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKMyGroup;
@class KKGroupMember;
NS_ASSUME_NONNULL_BEGIN
@protocol KKGroupMemberCellDelegate <NSObject>

@optional
- (void)didSelectedLookAllGroupMember;
- (void)didSelectedDeleteGroupMember;
- (void)didSelectedAddGroupMember;
- (void)didSelectedCollectionViewCellGroupModel:(KKGroupMember *)groupModel;
@end


@interface KKGroupMemberCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, weak) id<KKGroupMemberCellDelegate> delegate;
- (void)setDataArrayFromTableViewArray:(NSMutableArray *)array Group:(KKMyGroup *)group;
@end

NS_ASSUME_NONNULL_END
