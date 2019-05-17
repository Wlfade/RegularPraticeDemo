//
//  KKComDeHeadView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/27.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKComDeHeadView.h"
#import "KKDyDetailCommentHeadView.h"
#import "KKDyDetailCommentTextView.h" //内容视图
#import "KKDyDetailCommentImageView.h" //评论的图片内容
#import "KKComDeSubItem.h"
@interface KKComDeHeadView ()
@property (nonatomic, weak) KKDyDetailCommentHeadView *dyCommentHeadView;

/** 内容信息视图 */
@property (nonatomic, weak) KKDyDetailCommentTextView *dynamicTextView;

@property (nonatomic, weak) KKDyDetailCommentImageView *commentImageView;
@end

@implementation KKComDeHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{
    //1.头像
    KKDyDetailCommentHeadView *dyCommentHeadView = [[KKDyDetailCommentHeadView alloc]init];
    dyCommentHeadView.backgroundColor = [UIColor whiteColor];
    self.dyCommentHeadView = dyCommentHeadView;
    [self addSubview:dyCommentHeadView];
    //2.内容
    KKDyDetailCommentTextView *dynamicTextView = [[KKDyDetailCommentTextView alloc]init];
    dynamicTextView.backgroundColor = [UIColor whiteColor];
    self.dynamicTextView = dynamicTextView;
    [self addSubview:dynamicTextView];
    
    //3.图片
    KKDyDetailCommentImageView *commentImageView = [[KKDyDetailCommentImageView alloc]init];
    commentImageView.backgroundColor = [UIColor whiteColor];
    self.commentImageView = commentImageView;
    [self addSubview:commentImageView];
}
- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    //头像
    self.dyCommentHeadView.frame = CGRectMake(0, 0, selfWidth, _comDeSubItem.dynamicHeadItem.dynamicHeadHeight);
    //文本
    self.dynamicTextView.frame = CGRectMake(52, self.dyCommentHeadView.bottom, selfWidth - 52, _comDeSubItem.dynamicComTextItem.dyComTextHeight);
    //图片
    self.commentImageView.frame = CGRectMake(0, self.dynamicTextView.bottom, selfHeight, _comDeSubItem.dyImageHeight);

}
- (void)setComDeSubItem:(KKComDeSubItem *)comDeSubItem{
    _comDeSubItem = comDeSubItem;
    
    _dyCommentHeadView.dyHeadItem = _comDeSubItem.dynamicHeadItem;
    //文本内容
    _dynamicTextView.dyTextItem = _comDeSubItem.dynamicComTextItem;
    
    if(_comDeSubItem.isImages){
        _commentImageView.dynamicImageItem = _comDeSubItem.dynamicImageitem;
    }
    
//    [self setNeedsLayout];
    
}
@end
