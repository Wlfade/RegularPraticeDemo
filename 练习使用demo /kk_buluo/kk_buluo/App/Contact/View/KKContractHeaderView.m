//
//  KKContractHeaderView.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKContractHeaderView.h"
#import "KKContactCell.h"

@interface KKContractHeaderView ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation KKContractHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"新朋友", @"部落群", @"消息号", @"我的推荐", @"我的关注", nil];
    }
    return _dataArray;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _headerTabView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _headerTabView.dataSource = self;
        _headerTabView.delegate = self;
        _headerTabView.scrollEnabled = NO;
        [_headerTabView registerClass:[KKContactCell class] forCellReuseIdentifier:@"cellID"];
        [self addSubview:self.headerTabView];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.dataArray[indexPath.row] attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 17],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    cell.nameLabel.attributedText = string;
    
    switch (indexPath.row) {
        case 0:
            cell.headPicImageView.image = [UIImage imageNamed:@"contact_new_friends"];
            break;
        case 1:
            cell.headPicImageView.image = [UIImage imageNamed:@"contact_group_contact"];
            break;
        case 2:
            cell.headPicImageView.image = [UIImage imageNamed:@"contact_news_number"];
            break;
        case 3:
            cell.headPicImageView.image = [UIImage imageNamed:@"contact_my_collection"];
            break;
        case 4:
            cell.headPicImageView.image = [UIImage imageNamed:@"contact_my_like"];
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didSelectContractHeaderViewForRow:)]) {
        [self.delegate didSelectContractHeaderViewForRow:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
