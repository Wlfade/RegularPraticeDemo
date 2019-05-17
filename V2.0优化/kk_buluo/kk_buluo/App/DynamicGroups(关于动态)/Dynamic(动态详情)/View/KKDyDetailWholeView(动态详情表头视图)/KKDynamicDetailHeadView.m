//
//  KKDynamicDetailHeadView.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKDynamicDetailHeadView.h"
//-------------------view
#import "KKDyDetailTitleView.h" //标题视图
#import "KKDyDetailHeadView.h" //头像昵称视图

#import "SubjectsWebView.h" //网页视图

#import "KKDynamicTextView.h" //内容视图


#import "BBDynamicImageView.h" //动态图片视图
#import "KKDynamicCardView.h" //动态转发卡片视图
#import "KKDyDetailAccessView.h" //浏览数视图
//-------------------model
#import "KKDyDetailWholeItem.h"

#import "DynamicDetailViewController.h"

@interface KKDynamicDetailHeadView ()
<KKDyDetailHeadViewDelegate>
/** 标题视图 */
@property (nonatomic, weak) KKDyDetailTitleView *dynamicTitleView;
/** 头像信息视图 */
@property (nonatomic, weak) KKDyDetailHeadView *dynamicHeadView;
/** 内容信息视图 */
@property (nonatomic, weak) KKDynamicTextView *dynamicTextView;

///** webView */
//@property (nonatomic,strong) SubjectsWebView *subjectsWeb;

/** 动态图片视图 */
@property (nonatomic, weak) BBDynamicImageView *dynamicImageView;
/** 动态转发名片视图 */
@property (nonatomic, weak) KKDynamicCardView *dynamicCardView;
/** 浏览数视图 */
@property (nonatomic, weak) KKDyDetailAccessView *dynamicAccView;
@end

@implementation KKDynamicDetailHeadView

- (instancetype)init{
    if (self = [super init]) {
        [self creatSubView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withDyDetailWholeItem:(KKDyDetailWholeItem *)dyDetailWholeItem{
    if (self = [super initWithFrame:frame]) {
        self.dyDetailWholeItem = dyDetailWholeItem;
        [self creatSubView];
    }
    return self;
}
- (void)creatSubView{
    
    KKDyDetailHeadView *dynamicHeadView = [[KKDyDetailHeadView alloc]init];
    dynamicHeadView.delegate = self;
    self.dynamicHeadView = dynamicHeadView;
    [self addSubview:dynamicHeadView];
    
    //1.头像
    KKDyDetailTitleView *dynamicTitleView = [[KKDyDetailTitleView alloc]init];
    self.dynamicTitleView = dynamicTitleView;
    [self addSubview:dynamicTitleView];
    
    //2.内容
    KKDynamicTextView *dynamicTextView = [[KKDynamicTextView alloc]init];
    self.dynamicTextView = dynamicTextView;
    [self addSubview:dynamicTextView];
    
//    SubjectsWebView *subjectsWeb=[[SubjectsWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
//    subjectsWeb.backgroundColor = [UIColor redColor];
//    [self addSubview:subjectsWeb];
//    self.subjectsWeb = subjectsWeb;
    
    //3.图片
    BBDynamicImageView *dynamicImageView = [[BBDynamicImageView alloc]init];
    self.dynamicImageView = dynamicImageView;
    [self addSubview:dynamicImageView];
    
    //4.名片
    KKDynamicCardView *dynamicCardView = [[KKDynamicCardView alloc]init];
    self.dynamicCardView = dynamicCardView;
    WS(weakSelf);
    dynamicCardView.tapBlock = ^{
        DynamicDetailViewController *dydetailVC = [[DynamicDetailViewController alloc]init];
        dydetailVC.subjectId = weakSelf.dyDetailWholeItem.dynamicCardItem.subjectId;
        [weakSelf.viewController.navigationController pushViewController:dydetailVC animated:YES];
    };
    [self addSubview:dynamicCardView];
    
    KKDyDetailAccessView *dynamicAccView = [[KKDyDetailAccessView alloc]init];
    self.dynamicAccView = dynamicAccView;
    [self addSubview:dynamicAccView];
    
    

    
    //6.展示信息的webView
//    [_subjectsWeb loadWebWithHtmlStr:_dyDetailWholeItem.dynamicTextItem.summary withFinishCallbackBlock:^(NSString *error) {
//        CGFloat subjectsWebViewH = self->_subjectsWeb.frame.size.height;
//        if (error) {
//            if ([error isEqualToString:@"empty"]) {
//                [weakSelf refreshFrameWithWebHeight:0];
//            }
//        }else{
//            [weakSelf refreshFrameWithWebHeight:subjectsWebViewH];
//        }
//    }];
    
    [self refreshFrameWithWebHeight:0];
    

}

- (void)refreshFrameWithWebHeight:(CGFloat )webHeitht{
    //开始布局
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    //标题
    if (_dyDetailWholeItem.dynamicTitleItem) {
        self.dynamicTitleView.frame = CGRectMake(0, 5, selfWidth, _dyDetailWholeItem.dynamicTitleItem.titleHeight);
    }else{
        self.dynamicTitleView.frame = CGRectMake(0, 0, selfWidth, 0);
    }
    
    
    //头像
    self.dynamicHeadView.frame = CGRectMake(0, _dynamicTitleView.bottom, selfWidth, _dyDetailWholeItem.dynamicHeadItem.dynamicHeadHeight);
    
    
//    self.subjectsWeb.frame = CGRectMake(0, self.dynamicHeadView.bottom, selfWidth, webHeitht);
    
    
    //文本
    self.dynamicTextView.frame = CGRectMake(0, self.dynamicHeadView.bottom, selfWidth, _dyDetailWholeItem.dynamicTextItem.dyTextHeight);

    
    
    //图片
    if (_dyDetailWholeItem.isImages == YES) {
        self.dynamicImageView.frame = CGRectMake(0, self.dynamicTextView.bottom, selfWidth, _dyDetailWholeItem.dynamicImageitem.dynamicImageHeight);
    }else{
        self.dynamicImageView.frame = CGRectMake(0, self.dynamicTextView.bottom, selfWidth, 0);
    }
    
    //名片
    if (_dyDetailWholeItem.isTransmitSubject == YES) {
        self.dynamicCardView.frame = CGRectMake(0, self.dynamicImageView.bottom, selfWidth, _dyDetailWholeItem.dynamicCardItem.dyCardHeight);
    }else{
        self.dynamicCardView.frame = CGRectMake(0, self.dynamicImageView.bottom, selfWidth,0);
    }
    
    self.dynamicAccView.frame = CGRectMake(0, self.dynamicCardView.bottom, selfWidth, _dyDetailWholeItem.dynamicAccessCountItem.dynamicAccessHeight);
    
    [self makeSetDyDetailWholeItem:self.dyDetailWholeItem];

}
//赋值
- (void)makeSetDyDetailWholeItem:(KKDyDetailWholeItem *)dyDetailWholeItem{
    _dyDetailWholeItem = dyDetailWholeItem;
    //标题
    if (dyDetailWholeItem.dynamicTitleItem) {
        _dynamicTitleView.titleItem = dyDetailWholeItem.dynamicTitleItem;
    }
    //头像昵称
    _dynamicHeadView.dyHeadItem = dyDetailWholeItem.dynamicHeadItem;
    //文本内容
    _dynamicTextView.dyTextItem = dyDetailWholeItem.dynamicTextItem;
    //图片内容
    if (dyDetailWholeItem.isImages == YES) {
        _dynamicImageView.dynamicImageItem = dyDetailWholeItem.dynamicImageitem;
    }
    _dynamicImageView.hidden = !dyDetailWholeItem.isImages;
    
    //名片内容
    if (dyDetailWholeItem.isTransmitSubject == YES) {
        _dynamicCardView.dyCardItem = dyDetailWholeItem.dynamicCardItem;
    }
    _dynamicCardView.hidden = !dyDetailWholeItem.isTransmitSubject;

    
    _dynamicAccView.dyDetailAccItem = dyDetailWholeItem.dynamicAccessCountItem;
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    
    [self setNeedsLayout];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    CGFloat selfWidth = self.bounds.size.width;
//    CGFloat selfHeight = self.bounds.size.height;
    
//    //头像
//    self.dynamicHeadView.frame = CGRectMake(0, 0, selfWidth, _dyDetailWholeItem.dynamicHeadItem.dynamicHeadHeight);
//    //文本
//    self.dynamicTextView.frame = CGRectMake(0, self.dynamicHeadView.bottom, selfWidth, _dyDetailWholeItem.dynamicTextItem.dyTextHeight);
//    //图片
//    if (_dyDetailWholeItem.isImages == YES) {
//        self.dynamicImageView.frame = CGRectMake(0, self.dynamicTextView.bottom, selfWidth, _dyDetailWholeItem.dynamicImageitem.dynamicImageHeight);
//    }else{
//        self.dynamicImageView.frame = CGRectMake(0, self.dynamicTextView.bottom, selfWidth, 0);
//    }
}
#pragma mark KKDyDetailHeadViewDelegate
-(void)KKDyDetailHeadViewDidFocus:(KKDyDetailHeadView *)detailHeadView withDyHeadItem:(KKDynamicHeadItem *)dyHeadItem withFocus:(BOOL)focus{
    
    NSString *serviceStr = @"";
    if (focus == YES) {
        serviceStr = @"USER_FOLLOW_CREATE";
    }else{
        serviceStr = @"USER_FOLLOW_CANCEL";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:dyHeadItem.userId forKey:@"objectId"];
    
    if ([dyHeadItem.commonObjectTypeName isEqualToString:@"GUILD_INDEX"]) {
        [params setValue:@"GUILD_INDEX" forKey:@"subscribeType"];
    }else {
        [params setValue:@"USER" forKey:@"subscribeType"];
    }
    
    [params setObject:serviceStr forKey:@"service"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            dyHeadItem.focus = focus;
            
            self.dyDetailWholeItem.dynamicHeadItem = dyHeadItem;
            
            detailHeadView.dyHeadItem = dyHeadItem;
            
            BBLOG(@"%@",resultModel.resultDic);
        }
    }];

}
@end
