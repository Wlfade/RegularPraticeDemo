//
//  KKGroupMemberCell.m
//  kk_buluo
//
//  Created by new on 2019/3/18.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKGroupMemberCell.h"
#import "KKGroupMember.h"
#import "KKMyGroup.h"
#import "KKGroupMemberCollectionViewCell.h"

@interface KKGroupMemberCell()
@property (nonatomic, strong) NSMutableArray *maxShowArray;
@property (nonatomic, strong) UIButton *lookAllGroupMember;
@property (nonatomic, strong) KKMyGroup *group;
@end

@implementation KKGroupMemberCell

- (NSMutableArray *)maxShowArray {
    if (!_maxShowArray) {
        _maxShowArray = [NSMutableArray array];
    }
    return _maxShowArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
/// 传递群成员信息, 传递群信息
- (void)setDataArrayFromTableViewArray:(NSMutableArray *)array Group:(KKMyGroup *)group  {
    [self.dataArray removeAllObjects];
    [self.maxShowArray removeAllObjects];
    self.group = group;
    [self.dataArray addObjectsFromArray:array];
    /// 如果当前用户是群主
    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:group.creator.userId]) {
        /// 最大显示数量18
        if (self.dataArray.count > 3) {
            for (NSInteger i = 0; i < 3; i ++) {
                [self.maxShowArray addObject:self.dataArray[i]];
            }
        }else {
            [self.maxShowArray addObjectsFromArray:self.dataArray];
        }
        /// 由于tableView重用池特性, 需要等到数组有值时再添加
        if (self.maxShowArray.count != 0) {
            [self.maxShowArray addObject:@"add_group_member"];
            [self.maxShowArray addObject:@"delete_group_member"];
        }
    }else {
        /// 最大显示数量19
        if (self.dataArray.count > 4) {
            for (NSInteger i = 0; i < 4; i ++) {
                [self.maxShowArray addObject:self.dataArray[i]];
            }
        }else {
            [self.maxShowArray addObjectsFromArray:self.dataArray];
        }
        /// 由于tableView重用池特性, 需要等到数组有值时再添加
        if (self.maxShowArray.count != 0) {
            [self.maxShowArray addObject:@"add_group_member"];
        }
    }
    
    [_lookAllGroupMember setTitle:[NSString stringWithFormat:@"共%lu人 ", self.dataArray.count] forState:UIControlStateNormal];
    [self.collectionView reloadData];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:20], [ccui getRH:90], [ccui getRH:16])];
        groupNameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
        groupNameLabel.textColor = COLOR_BLACK_TEXT;
        groupNameLabel.text = @"群成员";
        [self.contentView addSubview:groupNameLabel];
        
        _lookAllGroupMember = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookAllGroupMember.top = [ccui getRH:20];
        _lookAllGroupMember.left = SCREEN_WIDTH - [ccui getRH:80 + 15];
        _lookAllGroupMember.size = CGSizeMake([ccui getRH:80], [ccui getRH:18]);
        _lookAllGroupMember.titleLabel.adjustsFontSizeToFitWidth = YES;
        _lookAllGroupMember.titleLabel.font = [UIFont systemFontOfSize:[ccui getRH:11]];
        _lookAllGroupMember.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_lookAllGroupMember];
        [_lookAllGroupMember addTarget:self action:@selector(lookAllGroupMemberAction) forControlEvents:UIControlEventTouchUpInside];
        [_lookAllGroupMember setTitleColor:COLOR_GRAY_TEXT forState:UIControlStateNormal];
        /// buttton 左面文字 右面图片
        [_lookAllGroupMember setTitleEdgeInsets:UIEdgeInsetsMake(0, - _lookAllGroupMember.imageView.image.size.width - [ccui getRH:10], 0, _lookAllGroupMember.imageView.image.size.width)];
        [_lookAllGroupMember setImageEdgeInsets:UIEdgeInsetsMake(0, _lookAllGroupMember.titleLabel.bounds.size.width + [ccui getRH:60], 0, -_lookAllGroupMember.titleLabel.bounds.size.width + [ccui getRH:5])];
        [_lookAllGroupMember setImage:[UIImage imageNamed:@"arrow_right_gray"] forState:UIControlStateNormal];
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView =
        [[UICollectionView alloc] initWithFrame:CGRectMake(0, [ccui getRH:35], SCREEN_WIDTH, [ccui getRH:101]) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = YES;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[KKGroupMemberCollectionViewCell class]
                forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self.contentView addSubview:self.collectionView];
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        self.collectionView.bounces = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if (self.maxShowArray.count <= 5) {
//
//        self.collectionView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH / 5 + [ccui getRH:50]);
//    }else if (self.maxShowArray.count > 5 && self.maxShowArray.count <= 10) {
//
//        self.collectionView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH / 5 * 2 + [ccui getRH:50]);
//    }else if (self.maxShowArray.count > 10 && self.maxShowArray.count <= 15){
//
//        self.collectionView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH / 5 * 3 + [ccui getRH:50]);
//    }else {
//
//        self.collectionView.frame = CGRectMake(0, 50, SCREEN_WIDTH, SCREEN_WIDTH / 5 * 4 + [ccui getRH:50]);
//    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(SCREEN_WIDTH / 5 - 2, [ccui getRH:88]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.maxShowArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKGroupMemberCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell"
                                              forIndexPath:indexPath];
    /// 这里要判断权限, 群主有权限删除;
    /// 删除群组成员
    NSLog(@"bool = %d", [[KKUserInfoMgr shareInstance].userId isEqualToString:self.group.creator.userId]);
    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:self.group.creator.userId]) {
        if (indexPath.item == self.maxShowArray.count - 1) {
            
            [cell.headerPic setImage:[UIImage imageNamed:self.maxShowArray[self.maxShowArray.count - 1]] forState:UIControlStateNormal];
            cell.nickName.text = @"";
            /// 添加群组成员
        }else if (indexPath.item == self.maxShowArray.count - 2) {
            
            [cell.headerPic setImage:[UIImage imageNamed:self.maxShowArray[self.maxShowArray.count - 2]] forState:UIControlStateNormal];
            cell.nickName.text = @"";
        }else {
            /// 第一次初始化, dataArray为nil
            if (self.maxShowArray.count > 2) {
                
                KKGroupMember *group = self.maxShowArray[indexPath.item];
                if ([self.maxShowArray[indexPath.item] isKindOfClass:[KKGroupMember class]]) {
                    
                    if (group.loginName.length != 0) {
                        
                        [cell.headerPic sd_setImageWithURL:[NSURL URLWithString:group.userLogoUrl] forState:UIControlStateNormal];
                        cell.nickName.textColor = COLOR_DARK_GRAY_TEXT;
                        cell.nickName.font = [UIFont systemFontOfSize:[ccui getRH:11]];
                        cell.nickName.text = group.loginName;
                    }
                }
            }
        }
    }else {
        if (indexPath.item == self.maxShowArray.count - 1) {
            
            [cell.headerPic setImage:[UIImage imageNamed:self.maxShowArray[self.maxShowArray.count - 1]] forState:UIControlStateNormal];
            cell.nickName.text = @"";

        }else {
            if (self.maxShowArray.count > 1) {
                
                KKGroupMember *group = self.maxShowArray[indexPath.item];
                if ([self.maxShowArray[indexPath.item] isKindOfClass:[KKGroupMember class]]) {
                    [cell.headerPic sd_setImageWithURL:[NSURL URLWithString:group.userLogoUrl] forState:UIControlStateNormal];
                    if (group.loginName.length != 0) {

                        cell.nickName.textColor = COLOR_DARK_GRAY_TEXT;
                        cell.nickName.font = [UIFont systemFontOfSize:[ccui getRH:11]];
                        cell.nickName.text = group.loginName;
                    }
                }
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:self.group.creator.userId]) {
        if (indexPath.item == self.maxShowArray.count - 1) {
            
            if ([self.delegate respondsToSelector:@selector(didSelectedDeleteGroupMember)]) {
                [self.delegate didSelectedDeleteGroupMember];
            }
        }else if (indexPath.item == self.maxShowArray.count - 2){
            
            if ([self.delegate respondsToSelector:@selector(didSelectedAddGroupMember)]) {
                [self.delegate didSelectedAddGroupMember];
            }
        }else {
            
            KKGroupMember *group = self.maxShowArray[indexPath.item];
            if ([self.delegate respondsToSelector:@selector(didSelectedCollectionViewCellGroupModel:)]) {
                [self.delegate didSelectedCollectionViewCellGroupModel:group];
            }
        }
    }else {
        if (indexPath.item == self.maxShowArray.count - 1) {
            if ([self.delegate respondsToSelector:@selector(didSelectedAddGroupMember)]) {
                [self.delegate didSelectedAddGroupMember];
            }
        }else {
            KKGroupMember *group = self.maxShowArray[indexPath.item];
            if ([self.delegate respondsToSelector:@selector(didSelectedCollectionViewCellGroupModel:)]) {
                [self.delegate didSelectedCollectionViewCellGroupModel:group];
            }
        }
    }
}
- (void)lookAllGroupMemberAction {
    if ([self.delegate respondsToSelector:@selector(didSelectedLookAllGroupMember)]) {
        [self.delegate didSelectedLookAllGroupMember];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
