//
//  DynamicDetailViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/18.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "DynamicDetailViewController.h"
//-----------------view
#import "KKDynamicDetailHeadView.h"
#import "KKDyDeCountInforView.h" //动态转发、评论、点赞数视图
#import "KKDyDeBottomOperationView.h"
#import "KKDyDeCommentPopView.h"
#import "KKDyDeMoreSheetMenu.h" //更多分享弹窗
//-----------------model
#import "KKDynamicWholeItem.h"
#import "KKDyDetailWholeItem.h"
#import "KKDynamicOperationItem.h"
#import "KKDynamicCardItem.h"
#import "MenuItem.h"
//-----------------Controller
#import "KKDyDeTransmitViewController.h" //转发
#import "KKDyDetailCommentViewController.h" //评论
#import "KKDyLikeViewController.h" //点赞

#import "KKDynamicTransmitViewController.h" //转发

#import "KKMyFriendViewController.h" //发送给好友

#import "KKChatVC.h"

//---------Tool
#import "KKLikeOrCancelLikeQuery.h"

//融云相关
#import "KKChatDynamicMsgContent.h"

#import "COMMENT_CREATE_BEFORE_QUERY.h"

@interface DynamicDetailViewController ()
<
TableViewScrollingProtocol,
KKDyDeCountInforViewDelegate,
KKDyDeBottomOperationViewDelegate,
KKDyDeCommentPopViewDelegate,
KKDyDeMoreSheetMenuDelegate
>

@property (nonatomic,weak) KKDyDeTransmitViewController *tesl1;

@property (nonatomic,weak) KKDyDetailCommentViewController *tesl2;

@property (nonatomic,weak) KKDyLikeViewController *tesl3;

@property (nonatomic,strong) KKDynamicWholeItem *dynamicWholeItem;
@property (nonatomic,strong) KKDyDetailWholeItem *dyDetailWholeItem;
@property (nonatomic,strong) KKDynamicOperationItem *dynamicOperationItem;

@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) KKDynamicDetailHeadView *dynamicDetailView;

//评论、转发、点赞数视图 中部 操作视图
@property (nonatomic,strong) KKDyDeCountInforView *dyDeCountInfroView;
//底部 评论、转发、点赞数 操作视图
@property (nonatomic,weak) KKDyDeBottomOperationView *bottomOperationView;

//当前显示的视图控制器
@property (nonatomic, weak) UIViewController *showingVC;

//各个控制器的偏移量
@property (nonatomic, strong) NSMutableDictionary *offsetYDict;

//评论的最大字数
@property(nonatomic,assign)NSInteger commentCount;

//是否成功请求到数据
@property (nonatomic, assign)BOOL isHasInfor;
@end

@implementation DynamicDetailViewController

- (NSMutableDictionary *)offsetYDict {
    if (!_offsetYDict) {
        _offsetYDict = [NSMutableDictionary dictionary];
        for (BaseTableViewController *vc in self.childViewControllers) {
            NSString *addressStr = [NSString stringWithFormat:@"%p", vc];
            _offsetYDict[addressStr] = @(CGFLOAT_MIN);
        }
    }
    return _offsetYDict;
}
//调用评论功能
- (void)doCommentAction{
    [self KKDyDeBottomOperationWriteAction:self.bottomOperationView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_dyDetailWholeItem) {
        [self refreshInfor];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavi];
    [self addChildsControllers];
    KKDyDeBottomOperationView *bottomOperationView = [[KKDyDeBottomOperationView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_HEIGHT, TAB_BAR_HEIGHT)];
    bottomOperationView.delegate = self;
    self.bottomOperationView = bottomOperationView;
    [self.view addSubview:bottomOperationView];
    
    [self requestTopicDetailQuery:^(KKDyDetailWholeItem *wholeItem) {
        self.dyDetailWholeItem = wholeItem;
        
        self.dynamicOperationItem = wholeItem.dynamicOperationItem;
        
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0,STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, wholeItem.dyDetailWholeHeight + 40)];
        
        [self.view addSubview:headView];
        
        KKDynamicDetailHeadView *dyDetailView = [self creatHeadWithWholeItem:wholeItem];
        [headView addSubview:dyDetailView];
        
        KKDyDeCountInforView *dyDeCountInfroView = [[KKDyDeCountInforView alloc]initWithFrame:CGRectMake(0, wholeItem.dyDetailWholeHeight, SCREEN_WIDTH, 40) withOperationItem:self.dynamicOperationItem];
        dyDeCountInfroView.delegate = self;
        self.dyDeCountInfroView = dyDeCountInfroView;
        [headView addSubview:dyDeCountInfroView];
        
        self.headView = headView;
        
        //        [dyDeCountInfroView.delegate KKDyDeCountInforViewDidSelected:0];
        [dyDeCountInfroView.delegate KKDyDeCountInforViewDidSelected:1];
        
        bottomOperationView.OperationItem = wholeItem.dynamicOperationItem;
    }];
    
    WS(weakSelf);
    [COMMENT_CREATE_BEFORE_QUERY requestCommentCountComplete:^(NSInteger limtCount) {
        weakSelf.commentCount = limtCount;
    }];
}

/** 创建导航栏 */
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    self.naviBarTitle = @"详情";
    
    DGButton *rightItemBtn = [DGButton btnWithImg:[UIImage imageNamed:@"dydetail_more_icon"]];
    [self.naviBar addSubview:rightItemBtn];
    [rightItemBtn addClickBlock:^(DGButton *btn) {
        if (self->_isHasInfor == YES) {
            KKDyDeMoreSheetMenu *sheetMenu = [KKDyDeMoreSheetMenu showInView:self.view withViewController:self withDyDetailWholeItem:self.dyDetailWholeItem];
            
            sheetMenu.delegate = self;
        }else{
            return;
        }
    }];
    [rightItemBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-9);
        make.width.mas_equalTo([ccui getRH:49]);
        make.height.mas_equalTo([ccui getRH:49]);
    }];
    
    [rightItemBtn setImageEdgeInsets:UIEdgeInsetsMake(34, 34, 0, 0)];
}
#pragma mark KKDyDeCountInforView
- (void)KKDyDeCountInforViewDidSelected:(NSInteger)SelectedIndex{
    [self selected:SelectedIndex];
}

/** 操作视图的操作点击功能 */
- (void)selected:(NSInteger)selected{
    [_showingVC.view removeFromSuperview];
    
    //取出对应的选中的子控制器
    BaseTableViewController *newVC = self.childViewControllers[selected];
    if (!newVC.view.superview) {
        [self.view addSubview:newVC.view];
        newVC.view.frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT - TAB_BAR_HEIGHT);
    }
    NSString *nextAddressStr = [NSString stringWithFormat:@"%p", newVC];
    CGFloat offsetY = [_offsetYDict[nextAddressStr] floatValue];
    
    newVC.tableView.contentOffset = CGPointMake(0, offsetY);
    
    [self.view insertSubview:newVC.view belowSubview:self.naviBar];
    if (offsetY <= _headView.height - 40){
        [newVC.view addSubview:_headView];
        for (UIView *view in newVC.view.subviews) {
            if ([view isKindOfClass:[UIImageView class]]) {
                [newVC.view insertSubview:_headView belowSubview:view];
                break;
            }
        }
        CGRect rect = self.headView.frame;
        rect.origin.y = 0;
        self.headView.frame = rect;
    }  else {
        [self.view insertSubview:_headView belowSubview:self.naviBar];
        CGRect rect = self.headView.frame;
        rect.origin.y = STATUS_AND_NAV_BAR_HEIGHT - (_headView.height - 40);
        
        self.headView.frame = rect;
    }
    _showingVC = newVC;
}

/** 创建头部显示页面并带入数据 */
- (KKDynamicDetailHeadView *)creatHeadWithWholeItem:(KKDyDetailWholeItem *)wholeItem{
    if (!_dynamicDetailView) {
        _dynamicDetailView = [[KKDynamicDetailHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, wholeItem.dyDetailWholeHeight)withDyDetailWholeItem:wholeItem];
        _dynamicDetailView.backgroundColor = [UIColor whiteColor];
    }else{
        _dynamicDetailView.dyDetailWholeItem = wholeItem;
    }
    
    return _dynamicDetailView;
}
#pragma mark Request
/* SUBJECT_DETAIL_BY_LOGIN 动态详情的数据请求 */
- (void)requestTopicDetailQuery:(void(^)(KKDyDetailWholeItem *))finish{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params safeSetObject:_subjectId forKey:@"subjectId"];
    
    [params setObject:@"SUBJECT_DETAIL_BY_LOGIN" forKey:@"service"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
            
            self.isHasInfor = NO;
            
        }else{
            self.isHasInfor = YES;
            BBLOG(@"%@",resultModel.resultDic);
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
            KKDyDetailWholeItem *dyDetailWholeItem = [KKDyDetailWholeItem KKDyDetailWholeItemTransmakeTheDict:responseDic];
            
            self.dynamicWholeItem = [self makeFromDydetailWholeItem:dyDetailWholeItem];
            
            [KKDyDetailWholeItem dynamicDetailHeadViewHeight:dyDetailWholeItem];
            finish(dyDetailWholeItem);
        }
    }];
}
-(void)setIsHasInfor:(BOOL)isHasInfor{
    _isHasInfor = isHasInfor;
    self.bottomOperationView.hidden = !isHasInfor;
}
#pragma mark AddChildVC
/** 添加子控制器 */
- (void)addChildsControllers{
    
    WS(weakSelf);
    KKDyDeTransmitViewController *tesl1 = [[KKDyDeTransmitViewController alloc]init];
    self.tesl1 = tesl1;
    tesl1.sourceId = _subjectId;
    tesl1.refreshBlock = ^{
//        NSLog(@"刷新请求");
        [weakSelf reFreshHeadViewInfor];
    };
    tesl1.delegate = self;
    
    KKDyDetailCommentViewController *tesl2 = [[KKDyDetailCommentViewController alloc]init];
    self.tesl2 = tesl2;
    tesl2.objectId = _subjectId;
    tesl2.refreshBlock = ^{
        [weakSelf reFreshHeadViewInfor];
    };
    tesl2.delegate = self;
    
    KKDyLikeViewController *tesl3 = [[KKDyLikeViewController alloc]init];
    self.tesl3 = tesl3;
    tesl3.sourceId = _subjectId;
    tesl3.refreshBlock = ^{
        [weakSelf reFreshHeadViewInfor];
    };
    tesl3.delegate = self;
    
    [self addChildViewController:tesl1];
    
    [self addChildViewController:tesl2];
    
    [self addChildViewController:tesl3];
}
- (void)reFreshHeadViewInfor{
    [self requestTopicDetailQuery:^(KKDyDetailWholeItem *wholeItem) {
        self.dyDetailWholeItem = wholeItem;
        
        self.dynamicOperationItem = wholeItem.dynamicOperationItem;
        
        self.dynamicDetailView.dyDetailWholeItem = wholeItem;
        
        [self.dynamicDetailView makeSetDyDetailWholeItem:wholeItem];
        
        self.bottomOperationView.OperationItem = wholeItem.dynamicOperationItem;
    }];
}
#pragma mark - BaseTabelView Delegate
- (void)tableViewScroll:(UITableView *)tableView offsetY:(CGFloat)offsetY{
    
//    NSLog(@"%f",offsetY);
    if (offsetY > (_headView.height - 40) ){
        if (![_headView.superview isEqual:self.view]) {
            [self.view insertSubview:_headView belowSubview:self.naviBar];
        }
        CGRect rect = self.headView.frame;
        rect.origin.y = STATUS_AND_NAV_BAR_HEIGHT - (_headView.height - 40);
        
        self.headView.frame = rect;
    } else {
        if (![_headView.superview isEqual:tableView]) {
            for (UIView *view in tableView.subviews) {
                if ([view isKindOfClass:[UIImageView class]]) {
                    [tableView insertSubview:_headView belowSubview:view];
                    break;
                }
            }
        }
        CGRect rect = self.headView.frame;
        rect.origin.y = 0;
        
        self.headView.frame = rect;
    }
    
}

- (void)tableViewDidEndDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    _headView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > (_headView.height - 40) - STATUS_AND_NAV_BAR_HEIGHT)
    {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                self->_offsetYDict[key] = @(offsetY);
            }
            else if ([self->_offsetYDict[key] floatValue] <= (self->_headView.height - 40) - STATUS_AND_NAV_BAR_HEIGHT){
                self->_offsetYDict[key] = @((self->_headView.height - 40) - STATUS_AND_NAV_BAR_HEIGHT);
            }
        }];
    } else {
        if (offsetY <= (_headView.height - 40) - STATUS_AND_NAV_BAR_HEIGHT)
        {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                self->_offsetYDict[key] = @(offsetY);
            }];
        }
    }
    [self loadOffsetYDic];
}

- (void)tableViewDidEndDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    _headView.userInteractionEnabled = YES;
    
    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    if (offsetY > (_headView.height - 40) - STATUS_AND_NAV_BAR_HEIGHT)
        
    {
        [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:addressStr]) {
                self->_offsetYDict[key] = @(offsetY);
            } else if ([self->_offsetYDict[key] floatValue] <= (self->_headView.height - 40) -  STATUS_AND_NAV_BAR_HEIGHT) {
                self->_offsetYDict[key] = @((self->_headView.height - 40) - STATUS_AND_NAV_BAR_HEIGHT);
            }
        }];
    } else {
        if (offsetY <= (_headView.height - 40) - STATUS_AND_NAV_BAR_HEIGHT) {
            [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                self->_offsetYDict[key] = @(offsetY);
            }];
        }
    }
    [self loadOffsetYDic];
}
- (void)tableViewDidEndHeadRefresh:(UITableView *)tableView{
    //    NSString *addressStr = [NSString stringWithFormat:@"%p", _showingVC];
    [self.offsetYDict enumerateKeysAndObjectsUsingBlock:^(NSString  *key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        self->_offsetYDict[key] = @(0);
    }];
    [self loadOffsetYDic];
    
}
- (void)loadOffsetYDic{
    //    NSLog(@"偏移量保存数据:%@",_offsetYDict);
//    BBLOG(@"偏移量保存数据:%@",_offsetYDict);
}
- (void)tableViewWillBeginDecelerating:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    _headView.userInteractionEnabled = NO;
}

- (void)tableViewWillBeginDragging:(UITableView *)tableView offsetY:(CGFloat)offsetY {
    _headView.userInteractionEnabled = NO;
}
/** 默认的列数 */
- (CGFloat)TableHeaderImgHeight:(UITableViewController *)ViewController{
    return _headView.height - 40;
}

- (CGFloat)TableHeaderSwitchBarHeight:(UITableViewController *)ViewController{
    return 40;
}

#pragma mark KKDyDeBottomOperationViewDelegate
//写内容代理调用
- (void)KKDyDeBottomOperationWriteAction:(KKDyDeBottomOperationView *)inforView{
    
//    commentPopView.freeTextView.placeholder = [NSString stringWithFormat:@"输入上限%ld字",(long)self.commentCount];

    NSString *placeStr = [NSString stringWithFormat:@"输入上限%ld字",(long)self.commentCount ? (long)self.commentCount:200];
    
    KKDyDeCommentPopView *commentPopView = [KKDyDeCommentPopView KKDyDeCommentPopViewShow:self isNeedImage:YES withPlaceString:placeStr];
    commentPopView.delegate = self;
}
//写内容代理调用
- (void)KKDyDeBottomOperationCommentAction:(KKDyDeBottomOperationView *)inforView withOperationItem:(KKDynamicOperationItem *)operationItem{
    BBLOG(@"写内容");
    
    if ([self.showingVC isKindOfClass:[KKDyDeTransmitViewController class]]) {
        //        [self.tesl1 refreshTransmitInfor];
        
        //        UITableView *tableView = self.tesl1.tableView;
        //
        //        CGPoint offset = tableView.contentOffset;
        //
        //        [tableView setContentOffset:offset animated:YES];
        
    }
    if ([self.showingVC isKindOfClass:[KKDyDetailCommentViewController class]]) {
        UITableView *tableView = self.tesl2.tableView;
        
        CGPoint offset = tableView.contentOffset;
        
        CGSize contextSize = tableView.contentSize;
        
        if (contextSize.height > SCREEN_HEIGHT) {
            offset.y = contextSize.height - tableView.bounds.size.height;
            
            if (offset.y > _headView.height - 40) {
                offset.y = _headView.height - 40;
            }
        }else{
            offset.y = 0;
        }
        
        [self.tesl2.delegate tableViewScroll:self.tesl2.tableView offsetY:offset.y];
        
        [self.tesl2.tableView setContentOffset:offset animated:YES];
    }
    if ([self.showingVC isKindOfClass:[KKDyLikeViewController class]]) {
        //        [self.tesl3 refreshLikeInfor];
    }
    
    //    [KKDyDeCommentPopView KKDyDeCommentPopViewShow];
    
    //    //定位到评论区
    //    if (_replyCommentArr.count > 0) {
    //        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //        [_subjectTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    //    }
    //    else{
    //        CGPoint offset = _subjectTableView.contentOffset;
    //
    //        CGSize contextSize = _subjectTableView.contentSize;
    //
    //        if(contextSize.height > SCREEN_HEIGHT){
    //            offset.y = contextSize.height - _subjectTableView.bounds.size.height;
    //        }else{
    //            offset.y = 0;
    //        }
    //        [_subjectTableView setContentOffset:offset animated:YES];
    //    }
}
//点赞代理调用
- (void)KKDyDeBottomOperationLikeAction:(KKDyDeBottomOperationView *)inforView withOperationItem:(KKDynamicOperationItem *)operationItem{
    WS(weakself);
    [KKLikeOrCancelLikeQuery requestIsClickLike:operationItem.liked withLikeCount:_dynamicWholeItem.dynamicOperationItem.likeCount withObjectId:_dyDetailWholeItem.subjectId withType:@"SUBJECT" withFinish:^(BOOL liked, NSInteger count) {
        [weakself refreshInfor];
    }];
}
//收藏代理调用
- (void)KKDyDeBottomOperationCollectAction:(KKDyDeBottomOperationView *)inforView withOperationItem:(KKDynamicOperationItem *)operationItem{
    BBLOG(@"收藏");
    [self transMakeTheOperation:operationItem complete:^(KKDynamicOperationItem *operationItem) {
        self.dyDetailWholeItem.dynamicOperationItem = operationItem;
        inforView.OperationItem = operationItem;
    }];
}
/*收藏网络请求*/
- (void)transMakeTheOperation:(KKDynamicOperationItem *)operationItem complete:(void(^)(KKDynamicOperationItem *))complete{
    NSString *serviceStr = @"";
    if (operationItem.collected != YES) {
        serviceStr = @"CREATE_COLLECT";
    }else{
        serviceStr = @"CANCEL_COLLECT";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:_dyDetailWholeItem.subjectId forKey:@"objectId"];
    [params setObject:serviceStr forKey:@"service"];
    
    [params safeSetObject:@"SUBJECT" forKey:@"objectType"];
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            operationItem.collected = !operationItem.collected;
            
            if (operationItem.collected == YES) {
                [CC_NoticeView showError:@"收藏成功"];
            }else{
                [CC_NoticeView showError:@"取消收藏成功"];
            }
            
            complete(operationItem);
        }
    }];
}
/**
 动态详情的模型转化成动态模型
 */
- (KKDynamicWholeItem *)makeFromDydetailWholeItem:(KKDyDetailWholeItem *)DydetailWholeItem{
    
    KKDynamicWholeItem *dynamicWholeItem = [[KKDynamicWholeItem alloc]init];
    //动态id
    dynamicWholeItem.subjectId = DydetailWholeItem.subjectId;
    //动态时间
    dynamicWholeItem.nowDate = DydetailWholeItem.nowDate;
    //动态头部信息
    dynamicWholeItem.dynamicHeadItem = DydetailWholeItem.dynamicHeadItem;
    //动态文本内容
    dynamicWholeItem.dynamicTextItem = DydetailWholeItem.dynamicTextItem;
    //动态是否有图片
    dynamicWholeItem.isImages = DydetailWholeItem.isImages;
    //动态图片
    dynamicWholeItem.dynamicImageitem = DydetailWholeItem.dynamicImageitem;
    //动态操作
    dynamicWholeItem.dynamicOperationItem = DydetailWholeItem.dynamicOperationItem;
    dynamicWholeItem.isTransmitSubject = DydetailWholeItem.isTransmitSubject;
//    dynamicWholeItem.isTransmitSubject = NO;

    
    if (DydetailWholeItem.isTransmitSubject) {
        dynamicWholeItem.dynamicCardItem = DydetailWholeItem.dynamicCardItem;
    }else{
        KKDynamicCardItem *cardItem = [KKDynamicCardItem mj_objectWithKeyValues:DydetailWholeItem.dynamicDictionary];
        dynamicWholeItem.dynamicCardItem = cardItem;
    }
    
    dynamicWholeItem.cellHeight = [KKDynamicWholeItem cellHeight:dynamicWholeItem];
    
    return dynamicWholeItem;
}
//转发动态
//- (void)transMitAction{
//    //动态详情的 模型转换成 动态模型
//    KKDynamicWholeItem *dynamicWholeItem = self.dynamicWholeItem;
//
//    KKDynamicTransmitViewController *dyTransVC = [[KKDynamicTransmitViewController alloc]init];
//    dyTransVC.dynamicWholeItem = dynamicWholeItem;
//
//    [self.navigationController pushViewController:dyTransVC animated:YES];
//}
- (void)transMitAction:(NSMutableString *_Nullable)mutableString{
    KKDynamicWholeItem *dynamicWholeItem = self.dynamicWholeItem;
    
    if (self.dynamicWholeItem.dynamicCardItem != nil && self.dynamicWholeItem.dynamicCardItem.deleted == YES) {
        [CC_NoticeView showError:@"该动态已被删除，不可转发"];
        return;
    }
    
    KKDynamicTransmitViewController *dyTransVC = [[KKDynamicTransmitViewController alloc]init];
    if (mutableString != nil) {
        //        NSMutableAttributedString *attSummary=[[NSMutableAttributedString alloc] initWithString:mutableString];
        
        dyTransVC.selfDefineText = mutableString;
        
    }
    dyTransVC.dynamicWholeItem = dynamicWholeItem;
    
    [self.navigationController pushViewController:dyTransVC animated:YES];
}
//转发代理调用
- (void)KKDyDeBottomOperationTransmitAction:(KKDyDeBottomOperationView *)inforView withOperationItem:(KKDynamicOperationItem *)operationItem{
    BBLOG(@"转发");
    [self transMitAction:nil];
}
#pragma mark KKDyDeCommentPopViewDelegate
- (void)KKDyDeCommentPopViewDidSend:(KKDyDeCommentPopView *)commentPopView mutString:(NSMutableString *)mutableString{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"COMMENT_CREATE" forKey:@"service"];
    [params setObject:@"SUBJECT" forKey:@"objectType"];
    [params setObject:_dyDetailWholeItem.subjectId forKey:@"objectId"];
    
    
    [params safeSetObject:mutableString forKey:@"content"];
    
    if (mutableString.length > self.commentCount) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CC_NoticeView showError:[NSString stringWithFormat:@"评论内容最多为%ld",self.commentCount]];
        });
        return;
    }
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            BBLOG(@"%@",resultModel.resultDic);
            
            //关闭动态详情评论的弹出框
            [KKDyDeCommentPopView hideWithViewController:self withCompletion:^{
                [CC_NoticeView showError:@"评论成功"];
                [self refreshInfor];
            }];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (commentPopView.isNeedTransmit == YES) {
                    [self transMitAction:mutableString];
                }
            });
        }
    }];
}
- (CGFloat)maxTextCountInKKDyDeCommentPopView:(KKDyDeCommentPopView *)commentPopView{
    if (self.commentCount) {
        return self.commentCount;
    }else{
        return 200;
    }
}
//刷新操作
- (void)refreshInfor{
    [self requestTopicDetailQuery:^(KKDyDetailWholeItem *wholeItem) {
        //同时刷新里面的 动态数据模型
        self.dynamicWholeItem = [self makeFromDydetailWholeItem:wholeItem];
        
        self.dyDetailWholeItem = wholeItem;
        
        self.dynamicOperationItem = wholeItem.dynamicOperationItem;
        
        self.dyDeCountInfroView.dyOperationItem = wholeItem.dynamicOperationItem;
        
        self.bottomOperationView.OperationItem = wholeItem.dynamicOperationItem;
        
        if ([self.showingVC isKindOfClass:[KKDyDeTransmitViewController class]]) {
            [self.tesl1 refreshTransmitInfor];
        }
        if ([self.showingVC isKindOfClass:[KKDyDetailCommentViewController class]]) {
            [self.tesl2 refreshCommentInfor];
        }
        if ([self.showingVC isKindOfClass:[KKDyLikeViewController class]]) {
            [self.tesl3 refreshLikeInfor];
        }
        
        NSDictionary *dynamicRefreshDic = [NSDictionary dictionaryWithObjectsAndKeys:self->_subjectId, @"subjectId",self.dynamicWholeItem,@"dynamicWholeItem",nil];
        NSNotification *notification = [NSNotification notificationWithName:@"DynamicRefresh" object:nil userInfo:dynamicRefreshDic];
        if (![self.dynamicWholeItem.objectType isEqualToString:@"PERSONAL_ARTICLE"]) {
            [[NSNotificationCenter defaultCenter]postNotification:notification];

        }
    }];
}
#pragma mark KKDyDeMoreSheetMenuDelegate
- (void)shareMenuDidClickCloseBtn:(KKDyDeMoreSheetMenu *)menu{
    
    [KKDyDeMoreSheetMenu hideWithViewController:self withCompletion:nil];
    
}
- (void)shareMenuDidSelect:(KKDyDeMoreSheetMenu *)menu withMenuItem:(MenuItem *)item{
    [KKDyDeMoreSheetMenu hideWithViewController:self withCompletion:^{
        
        if (item.cleckBlock) {
            item.cleckBlock();
        }
        
        if ([item.title isEqualToString:@"转发到广场"]) {
            [self transMitAction:nil];
        }
        
        if ([item.title isEqualToString:@"发送给朋友"]) {
            [self pushToMyFriendListVC];
        }
        if([item.title isEqualToString:@"收藏"] || [item.title isEqualToString:@"取消收藏"]){
            
            KKDynamicOperationItem *operationItem = self.dynamicOperationItem;
            
            [self transMakeTheOperation:operationItem complete:^(KKDynamicOperationItem *operationItem) {
                self.dyDetailWholeItem.dynamicOperationItem = operationItem;
                self.bottomOperationView.OperationItem = operationItem;
                self.dynamicOperationItem = operationItem;
            }];
        }
        
    }];
}

#pragma mark - jump
-(void)pushToMyFriendListVC {
    KKMyFriendViewController *vc = [[KKMyFriendViewController alloc] init];
    WS(weakSelf);
    vc.selectedBlock = ^(KKContactUserInfo * _Nonnull userInfo) {
        //1.发动态消息
        [weakSelf rcSendDynamicMsgTo:userInfo];
        //2.跳转至会话
        [weakSelf pushToChatVC:userInfo];
    };
    
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)pushToChatVC:(KKContactUserInfo *)kUserInfo {
    KKChatVC *chatVC = [[KKChatVC alloc]initWithConversationType:ConversationType_PRIVATE targetId:kUserInfo.userId];
    [self.navigationController pushViewController:chatVC animated:YES];
}

#pragma mark - 融云发送消息
-(void)rcSendDynamicMsgTo:(KKContactUserInfo *)kUserInfo {
    ////动态详情的 模型转换成 动态模型
    //    KKDynamicWholeItem *wholeItem =[KKDynamicWholeItem mj_objectWithKeyValues:self.dyDetailWholeItem.dynamicDictionary] self.dynamicWholeItem;
    
    KKDyDetailWholeItem *wholeItem = self.dyDetailWholeItem;
    
    KKChatDynamicMsgContent *msgContent = [[KKChatDynamicMsgContent alloc]init];
    msgContent.idStr = wholeItem.subjectId;
    msgContent.title = wholeItem.dynamicTitleItem.title;
    msgContent.summary = wholeItem.dynamicTextItem.summary;
    msgContent.imgUrl = wholeItem.firstImageUrl;
    msgContent.type = msgContent.title.length<1 ? 1 : 2;
    msgContent.tagStr = [@"by-" stringByAppendingString:wholeItem.dynamicHeadItem.userName];
    
    
    [[RCIM sharedRCIM] sendMessage:ConversationType_PRIVATE targetId:kUserInfo.userId content:msgContent pushContent:@"分享动态" pushData:msgContent.title success:^(long messageId) {
        CCLOG(@"分享成功了");
    } error:^(RCErrorCode nErrorCode, long messageId) {
        CCLOG(@"分享失败了");
    }];
}
@end
