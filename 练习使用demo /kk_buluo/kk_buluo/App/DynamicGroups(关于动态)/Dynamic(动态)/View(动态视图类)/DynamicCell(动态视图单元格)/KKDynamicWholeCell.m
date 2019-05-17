//
//  KKDynamicWholeCell.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/15.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicWholeCell.h"
//-----------View
#import "KKDyHeadView.h" //头像昵称视图
#import "KKDynamicTextView.h" //内容视图
#import "BBDynamicImageView.h" //动态图片视图
#import "KKDynamicCardView.h" //动态名片视图
#import "KKOperationView.h" //动态操作视图

//-----------Item
#import "KKDynamicWholeItem.h"

#import "BBDynamicImageItem.h" //图片动态

#import "KKLikeOrCancelLikeQuery.h" //点赞功能模块

//-----------ViewController
#import "KKDynamicTransmitViewController.h" //动态转发
#import "DynamicDetailViewController.h" //动态详情

@interface KKDynamicWholeCell()
<
KKDyHeadViewDelegate,
KKOperationViewDelegate
>
/** 头像信息视图 */
@property (nonatomic, weak) KKDyHeadView *dynamicHeadView;

/** 内容信息视图 */
@property (nonatomic, weak) KKDynamicTextView *dynamicTextView;

/** 动态图片视图 */
@property (nonatomic, weak) BBDynamicImageView *dynamicImageView;

/** 动态转发名片视图 */
@property (nonatomic, weak) KKDynamicCardView *dynamicCardView;

/** 动态操作视图 */
@property (nonatomic, weak) KKOperationView *dynamicOperationView;

/*图片数据字典*/
@property (nonatomic, strong) NSDictionary *properties;

/*图片数据模型*/
@property (nonatomic, strong) BBDynamicImageItem *imageItem;

@end

@implementation KKDynamicWholeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self _creatSubView];
    }
    return self;
}
- (void)_creatSubView{
    //1.头像
    KKDyHeadView *dynamicHeadView = [[KKDyHeadView alloc]init];
    dynamicHeadView.delegate = self;
    self.dynamicHeadView = dynamicHeadView;
    [self.contentView addSubview:dynamicHeadView];
    
    //2.内容
    KKDynamicTextView *dynamicTextView = [[KKDynamicTextView alloc]init];
    self.dynamicTextView = dynamicTextView;
    [self.contentView addSubview:dynamicTextView];
    
    //3.图片
    BBDynamicImageView *dynamicImageView = [[BBDynamicImageView alloc]init];
    self.dynamicImageView = dynamicImageView;
    [self.contentView addSubview:dynamicImageView];
    //4.名片
    KKDynamicCardView *dynamicCardView = [[KKDynamicCardView alloc]init];
    self.dynamicCardView = dynamicCardView;
    
    WS(weakSelf);
    dynamicCardView.tapBlock = ^{
        DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
        dydetailVC.subjectId = weakSelf.dynamicWholeItem.dynamicCardItem.subjectId;
        [weakSelf.viewController.navigationController pushViewController:dydetailVC animated:YES];
    };
    
    [self.contentView addSubview:dynamicCardView];
    //5.操作
    KKOperationView *dynamicOperationView = [[KKOperationView alloc]init];
    dynamicOperationView.delegate = self;
    self.dynamicOperationView = dynamicOperationView;
    [self.contentView addSubview:dynamicOperationView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    //头像
    self.dynamicHeadView.frame = CGRectMake(0, 0, selfWidth, _dynamicWholeItem.dynamicHeadItem.dynamicHeadHeight);
    //文本
    self.dynamicTextView.frame = CGRectMake(0, self.dynamicHeadView.bottom, selfWidth, _dynamicWholeItem.dynamicTextItem.dyTextHeight);
    //图片
    if (_dynamicWholeItem.isImages == YES) {
        self.dynamicImageView.frame = CGRectMake(0, self.dynamicTextView.bottom, selfWidth, _dynamicWholeItem.dynamicImageitem.dynamicImageHeight);
    }else{
        self.dynamicImageView.frame = CGRectMake(0, self.dynamicTextView.bottom, selfWidth, 0);
    }
    //名片
    if (_dynamicWholeItem.isTransmitSubject == YES) {
         self.dynamicCardView.frame = CGRectMake(0, self.dynamicImageView.bottom, selfWidth, _dynamicWholeItem.dynamicCardItem.dyCardHeight);
    }else{
         self.dynamicCardView.frame = CGRectMake(0, self.dynamicImageView.bottom, selfWidth,0);
    }
    //操作
    self.dynamicOperationView.frame = CGRectMake(0, self.dynamicCardView.bottom, selfWidth, _dynamicWholeItem.dynamicOperationItem.dyOperationHeight);
}

//传值
- (void)setDynamicWholeItem:(KKDynamicWholeItem *)dynamicWholeItem{
    _dynamicWholeItem = dynamicWholeItem;
    
    //头像昵称
    _dynamicHeadView.dyHeadItem = dynamicWholeItem.dynamicHeadItem;
    //文本内容
    _dynamicTextView.dyTextItem = dynamicWholeItem.dynamicTextItem;
    //图片内容
    if (dynamicWholeItem.isImages == YES) {
        _dynamicImageView.dynamicImageItem = dynamicWholeItem.dynamicImageitem;
    }
    _dynamicImageView.hidden = !dynamicWholeItem.isImages;
    //名片内容
    if (dynamicWholeItem.isTransmitSubject == YES) {
        _dynamicCardView.dyCardItem = dynamicWholeItem.dynamicCardItem;
    }
    _dynamicCardView.hidden = !dynamicWholeItem.isTransmitSubject;
    //操作内容
    _dynamicOperationView.dyOperationItem = dynamicWholeItem.dynamicOperationItem;
}

#pragma mark KKDyHeadViewDelegate
- (void)KKDyHeadView:(KKDyHeadView *)dyHeadView didClickFunction:(UIButton *)sender{
    
//    CGPoint p = [dyHeadView convertPoint:sender.frame.origin toView:self.viewController.view];
    CGPoint p = [dyHeadView convertPoint:sender.frame.origin toView:self.window];

    p.x += sender.frame.size.width / 2;
    p.y += sender.frame.size.height / 2;
    
//    p.y += STATUS_AND_NAV_BAR_HEIGHT;
    
    if ([self.delegate respondsToSelector:@selector(KKDynamicWholeCell:withHeadViewPoint:)]) {
        [self.delegate KKDynamicWholeCell:self withHeadViewPoint:p];
    }
}
- (void)KKDyHeadView:(KKDyHeadView *)dyHeadView didClickFocus:(KKDynamicHeadItem *)dyHeadItem{
    if ([self.delegate respondsToSelector:@selector(KKDynamicWholeCellfocusActionFocus:)]) {
        [self.delegate KKDynamicWholeCellfocusActionFocus:self];
    }
}
#pragma mark KKOperationViewDelegate
- (void)KKOperationViewDidShare:(KKOperationView *)OperationView{
    
    KKDynamicWholeItem *dynamicWholeItem = self.dynamicWholeItem;
    
    KKDynamicCardItem *cardItem = nil;
    //判断这个动态是否为转发
    if (dynamicWholeItem.isTransmitSubject) {
        cardItem = dynamicWholeItem.dynamicCardItem;
        if (dynamicWholeItem.dynamicCardItem.deleted == YES) {
            [CC_NoticeView showError:@"该动态已被删除，不可转发"];
            return;
        }
    }else{
        cardItem = [KKDynamicCardItem mj_objectWithKeyValues:dynamicWholeItem.dynamicDictionary];
        dynamicWholeItem.dynamicCardItem = cardItem;
        
    }
    KKDynamicTransmitViewController *dyTransVC = [[KKDynamicTransmitViewController alloc]init];
    dyTransVC.dynamicWholeItem = dynamicWholeItem;
    WS(weakSelf);
    dyTransVC.transBlock = ^(KKDynamicWholeItem * _Nonnull wholeItem) {
        weakSelf.dynamicWholeItem = wholeItem;
    };
    [self.viewController.navigationController pushViewController:dyTransVC animated:YES];
    
}
- (void)KKOperationViewDidComment:(KKOperationView *)OperationView{
    DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
    dydetailVC.subjectId = _dynamicWholeItem.subjectId;
    [self.viewController.navigationController pushViewController:dydetailVC animated:YES];
    
    [dydetailVC doCommentAction];
    
}
- (void)KKOperationViewDidLike:(KKOperationView *)OperationView withLiked:(BOOL)liked{
    KKDynamicWholeItem *dynamicWholeItem = self.dynamicWholeItem;
    
    [KKLikeOrCancelLikeQuery requestIsClickLike:liked withLikeCount:dynamicWholeItem.dynamicOperationItem.likeCount withObjectId:_dynamicWholeItem.subjectId withType:@"SUBJECT" withFinish:^(BOOL liked, NSInteger count) {
        KKDynamicWholeItem *dynamicWholeItem = self.dynamicWholeItem;
        dynamicWholeItem.dynamicOperationItem.liked = liked;
        if (liked == YES) {
            dynamicWholeItem.dynamicOperationItem.likeCount +=1;
        }else{
            dynamicWholeItem.dynamicOperationItem.likeCount -=1;
        }

        self.dynamicWholeItem = dynamicWholeItem;
    }];
    
}





@end
