//
//  KKContractHeaderView.m
//  kk_buluo
//
//  Created by summerxx on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKContractHeaderView.h"
#import "KKContactCell.h"

@interface KKContractHeaderView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *iconNameArray;
@property (nonatomic, assign) NSInteger noReadNotesCount;
@property (nonatomic, strong) UIView *noReadNotesView;

@end

@implementation KKContractHeaderView

#pragma mark - lazy load
- (UIView *)noReadNotesView {
    if (!_noReadNotesView) {
        _noReadNotesView = [[UIView alloc] init];
        _noReadNotesView.layer.cornerRadius = 4;
        _noReadNotesView.backgroundColor = [UIColor redColor];
    }
    return _noReadNotesView;
}

- (void)headerViewReloadDataNoReadNotesCount:(NSInteger)count {
    _noReadNotesCount = count;
    [self.headerTabView reloadData];
}

-(NSArray *)titleArray {
    if (!_titleArray) {
        _titleArray = @[@"新朋友", @"部落群", @"我的推荐", @"我的关注"];
    }
    return _titleArray;
}

-(NSArray *)iconNameArray {
    if (!_iconNameArray) {
        _iconNameArray = @[@"contact_new_friends",@"contact_group_contact",@"contact_my_collection",@"contact_my_like"];
    }
    return _iconNameArray;
}

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerTabView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _headerTabView.dataSource = self;
        _headerTabView.delegate = self;
        _headerTabView.scrollEnabled = NO;
        _headerTabView.tableFooterView = [[UIView alloc]init];
        [_headerTabView registerClass:[KKContactCell class] forCellReuseIdentifier:@"cellID"];
        [self addSubview:self.headerTabView];
    }
    return self;
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:56];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    
    //cell配置
    KKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.nameLabel.textColor = COLOR_BLACK_TEXT;
    cell.nameLabel.font = [UIFont systemFontOfSize:[ccui getRH:16]];
    cell.headPicImageView.image = Img(self.iconNameArray[row]);
    cell.nameLabel.text = self.titleArray[row];
    
    //新朋友
    if (0 == row) {
        cell.headPicImageView.clipsToBounds = NO;
        [cell.headPicImageView addSubview:self.noReadNotesView];
        /// 这里根据圆的特性计算的
        _noReadNotesView.top = [ccui getRH:4];
        _noReadNotesView.left = [ccui getRH:16 + 13.5 - 4];
        _noReadNotesView.size = CGSizeMake(8, 8);
        if (_noReadNotesCount == 0) {
            _noReadNotesView.hidden = YES;
        }else {
            _noReadNotesView.hidden = NO;
        }
    }
    
    //去掉最后一行的separatorLine
    if (self.titleArray.count == row+1){
        for (UIView *subview in cell.subviews) {
            if ([subview isKindOfClass:[NSClassFromString(@"_UITableViewCellSeparatorView") class]]){
                [subview removeFromSuperview];
            }
        }
    }
    
    //return
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        _noReadNotesView.hidden = YES;
    }
    if ([self.delegate respondsToSelector:@selector(didSelectContractHeaderViewForRow:)]) {
        [self.delegate didSelectContractHeaderViewForRow:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.headerTabView setSeparatorInset:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.headerTabView setLayoutMargins:UIEdgeInsetsMake(0, 56, 0, 0)];
    }
}
@end
