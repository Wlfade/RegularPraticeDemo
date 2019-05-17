//
//  KKDyDetaiCommentReplyView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDyDetaiCommentReplyView.h"

#import "KKDyComReplyCell.h"

#import "KKDynamicCommentReplyItem.h"

#import "KKTouchTableView.h"

@interface KKDyDetaiCommentReplyView ()
<UITableViewDelegate,UITableViewDataSource,KKTouchTableViewDelegate>
@property (nonatomic,strong)KKTouchTableView *commentReplyTableView;
@end

static NSString * const cellIdentify = @"comReplyCell";

@implementation KKDyDetaiCommentReplyView

- (instancetype)init{
    if (self = [super init]) {
        [self creatSubView];
    }
    return self;
}
- (KKTouchTableView *)commentReplyTableView{
    if (!_commentReplyTableView) {
        KKTouchTableView *commentReplyTableView = [[KKTouchTableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
        commentReplyTableView.backgroundColor = [UIColor clearColor];
        commentReplyTableView.delegate = self;
        commentReplyTableView.dataSource = self;
        commentReplyTableView.touchDelegate = self;
        commentReplyTableView.scrollEnabled = NO;
        commentReplyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [commentReplyTableView registerClass:[KKDyComReplyCell class] forCellReuseIdentifier:cellIdentify];
        _commentReplyTableView = commentReplyTableView;
    }
    return _commentReplyTableView;
}
- (void)creatSubView{
    [self addSubview:self.commentReplyTableView];
}
- (void)setReplyList:(NSArray *)replyList{
    _replyList = replyList;
    [self.commentReplyTableView reloadData];
}
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.replyList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDynamicCommentReplyItem *item = [self.replyList objectAtIndex:indexPath.row];
    return item.dyReplyHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDyComReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    
    KKDynamicCommentReplyItem *item = [self.replyList objectAtIndex:indexPath.row];

    cell.replyItem = item;

    return cell;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    self.commentReplyTableView.frame = CGRectMake(0, 0, selfWidth, selfHeight - 5);
}

- (void)tableView:(UITableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"评论的回复点击事件");
    
    if ([self.delegate respondsToSelector:@selector(KKDyDetaiCommentReplyViewTouched:)]) {
        [self.delegate KKDyDetaiCommentReplyViewTouched:self];
    }
}
@end
