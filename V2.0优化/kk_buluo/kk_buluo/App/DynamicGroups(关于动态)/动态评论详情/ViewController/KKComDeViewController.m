//
//  KKComDeViewController.m
//  kk_buluo
//
//  Created by 单车 on 2019/3/20.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKComDeViewController.h"

#import "KKDydeTransmitCell.h"

//--------------model
#import "HHPaginator.h"
#import "KKComDeSubItem.h"
#import "HHPaginator.h"

#import "KKDydeTransmitItem.h" //评论用的单元格

#import "KKComDeHeadView.h"
#import "KKDyDeCommentPopView.h"

#import "COMMENT_CREATE_BEFORE_QUERY.h"

@interface KKComDeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
KKDyDeCommentPopViewDelegate
>
@property (nonatomic,strong)NSMutableArray *commentMutArr;
@property (nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)HHPaginator *paginator;

@property(nonatomic,strong)UIView *bottomView;

//动态刷新时间
@property(nonatomic,strong)NSString *nowDate;

@property(nonatomic,assign)NSInteger commentCount;

@end

static NSString *cellIdentify = @"cellId";
@implementation KKComDeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomView];
    
    [self setupRefresh];
    

    [self requestCommentDetail:^(KKComDeSubItem *deSubItem) {
        
        CGFloat h = [KKComDeSubItem cellHeight:deSubItem];
        
        KKComDeHeadView *headView = [[KKComDeHeadView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, h)];
        headView.backgroundColor = [UIColor whiteColor];
        headView.comDeSubItem = deSubItem;
        
//        [self.tableView reloadData];
//        [self.tableView beginUpdates];
        [self.tableView setTableHeaderView:headView];
//        [self.tableView endUpdates];
    }];
    
    [self requestCommentReplyQuery];
    
    WS(weakSelf);
    [COMMENT_CREATE_BEFORE_QUERY requestCommentCountComplete:^(NSInteger limtCount) {
        weakSelf.commentCount = limtCount;
    }];
}
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        _bottomView.backgroundColor = [UIColor whiteColor];

        UIView *grayView = [[UIView alloc]init];
        grayView.layer.cornerRadius = 3;
        grayView.backgroundColor = RGB(239, 239, 239);
        [_bottomView addSubview:grayView];
        
        grayView.frame = CGRectMake(10, 10, SCREEN_WIDTH - 20, 29);
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(writeAction:)];
        [grayView addGestureRecognizer:tapGesture];
        
        UIImageView *writeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wirite_comment_icon"]];
        [grayView addSubview:writeImageView];
        
        UILabel *placeholderLabel = [[UILabel alloc]init];
        placeholderLabel.text = @"回复评论";
        placeholderLabel.font = [UIFont systemFontOfSize:15];
        placeholderLabel.textColor = RGB(153, 153, 153);
        [grayView addSubview:placeholderLabel];
        
        [writeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(grayView.mas_left).offset(4);
            make.centerY.mas_equalTo(grayView.mas_centerY);
        }];
        
        [placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(writeImageView.mas_right);
            make.centerY.mas_equalTo(grayView.mas_centerY);
        }];

    }
    return _bottomView;
}
- (void)writeAction:(UITapGestureRecognizer *)tap{
    
    NSString *placeStr = [NSString stringWithFormat:@"输入上限%ld字",(long)self.commentCount ? (long)self.commentCount:200];
    
    KKDyDeCommentPopView *commentPopView = [KKDyDeCommentPopView KKDyDeCommentPopViewShow:self isNeedImage:NO withPlaceString:placeStr];
    commentPopView.delegate = self;
}
#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
//    [self setNaviBarTitle:@"我的回复"];
    
}
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT - TAB_BAR_HEIGHT) style:UITableViewStylePlain];
        tableView.backgroundColor = RGB(244, 244, 244);
        tableView.delegate = self;
        tableView.dataSource = self;
        
        [tableView registerClass:[KKDydeTransmitCell class] forCellReuseIdentifier:cellIdentify];
        
        [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        
        _tableView = tableView;
    }
    return _tableView;
}
-(void)setupRefresh
{
    WS(weakSelf)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        SS(strongSelf)
        strongSelf->_paginator.page = 1;
        [strongSelf requestCommentReplyQuery] ;
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            [strongSelf requestCommentReplyQuery] ;
        }else{
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}
#pragma mark -UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentMutArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KKDydeTransmitItem *item = self.commentMutArr[indexPath.row];
    return [KKDydeTransmitItem cellHeight:item];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KKDydeTransmitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify forIndexPath:indexPath];
    
    KKDydeTransmitItem *item = self.commentMutArr[indexPath.row];
    item.nowDate = self.nowDate;
    cell.transmitItem = item;
    
    cell.backgroundColor = RGB(244, 244, 244);
    
    return cell;
}

/**
 请求评论细节部分
 */
- (void)requestCommentDetail:(void(^)(KKComDeSubItem *))finish
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:@"SUBJECT" forKey:@"commentObjectType"];
    [params setObject:_objectId forKey:@"objectId"];

    [params setObject:_commentId forKey:@"commentId"];

    [params setObject:@"COMMENT_QUERY_BY_COMMENT_ID" forKey:@"service"];
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            BBLOG(@"%@",resultModel.resultDic);
            
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
            self.nowDate = responseDic[@"nowDate"];
            
            
            KKComDeSubItem *comDeSubItem = [KKComDeSubItem KKComDeSubItemWithDictionary:responseDic];
            comDeSubItem.nowDate = self.nowDate;
            finish(comDeSubItem);

        }
    }];
}


/**
 评论的回复查询
 */
- (void)requestCommentReplyQuery{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"COMMENT_REPLY_QUERY" forKey:@"service"];
    [params setObject:_commentId forKey:@"commentId"];

    [params setObject:self.paginator?@(self.paginator.page):@(1) forKey:@"currentPage"];
    [params setObject:@"SUBJECT" forKey:@"objectType"];

    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            BBLOG(@"%@",resultModel.resultDic);
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
            self.nowDate = responseDic[@"nowDate"];
            
            self.paginator = [HHPaginator mj_objectWithKeyValues: responseDic[@"paginator"]];
            
            NSArray *transmitList = [NSArray arrayWithArray:responseDic[@"commentReplyList"]];
            NSMutableArray *mutTempArr = [NSMutableArray arrayWithCapacity:transmitList.count];
            for (NSDictionary *transDic in transmitList) {
                KKDydeTransmitItem *transmitItem = [KKDydeTransmitItem KKDydeReplyWithDictionary:transDic];
                [mutTempArr addObject:transmitItem];
            }
            if (self.paginator.page == 1) {
                self.commentMutArr = mutTempArr;
            }else{
                [self.commentMutArr addObjectsFromArray:mutTempArr];
            }
            [self.tableView reloadData];
        }
    }];
}
- (void)setPaginator:(HHPaginator *)paginator{
    _paginator = paginator;
    NSInteger count = _paginator.items;
    NSString *titile = [NSString stringWithFormat:@"%ld条回复",(long)count];
    [self setNaviBarTitle:titile];
}

/**
 评论的创建
 */
#pragma mark - KKDyDeCommentPopViewDelegate
- (void)KKDyDeCommentPopViewDidSend:(KKDyDeCommentPopView *)commentPopView mutString:(NSMutableString *)mutableString{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"COMMENT_REPLY_CREATE" forKey:@"service"];
    [params setObject:_commentId forKey:@"commentId"];
    
    [params safeSetObject:mutableString forKey:@"content"];
    
    if (mutableString.length > self.commentCount) {
    
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [CC_NoticeView showError:[NSString stringWithFormat:@"内容最多为%ld",self.commentCount]];
        });
        
        
        return;
    }
    
    
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
        }else{
            BBLOG(@"%@",resultModel.resultDic);
            
            [self requestCommentReplyQuery];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
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
@end
