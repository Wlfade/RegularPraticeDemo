//
//  KKFollowListVC.m
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKFollowListVC.h"

//view
#import "KKFollowListTableViewCell.h"
//model
#import "KKMyCommentListModel.h"

#define kFollowCell @"KKFollowListTableViewCell"

@interface KKFollowListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong) HHPaginator *paginator;
/* 动态表数据数组 */
@property(nonatomic,strong) NSMutableArray <KKMyCommentSimpleModel *>*mutArr;

@end

@implementation KKFollowListVC

#pragma mark - lazy load
-(NSMutableArray <KKMyCommentSimpleModel *>*)mutArr{
    if (!_mutArr) {
        _mutArr = [NSMutableArray array];
    }
    return _mutArr;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavi];
    [self setupUI];
}


#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@""];
}

-(void)setupUI {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView = tableV;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    [tableV setSeparatorColor:COLOR_HEX(0xdfdfdf)];
    [self.view addSubview:tableV];
    //cell
    [tableV registerClass:[KKFollowListTableViewCell class] forCellReuseIdentifier:kFollowCell];
    
    //fotter
    tableV.tableFooterView = [UIView new];
}



#pragma mark - delegate

#pragma mark tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mutArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger row = indexPath.row;
    
    //1.获取cell
    KKFollowListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFollowCell forIndexPath:indexPath];
    
    //3.return
    return cell;
}



#pragma mark  UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:80];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    

    
}

#pragma mark - request
/* 动态 */
- (void)requestCommentList {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    //service
    [params safeSetObject:@"MY_COMMENT_SUBJECT_QUERY" forKey:@"service"];
    [params setObject:self.paginator?@(self.paginator.page):@(1) forKey:@"currentPage"];
    
    //2.请求
    [[CC_HttpTask getInstance]post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *errorStr, ResModel *resultModel) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if (errorStr) {
            [CC_NoticeView showError:errorStr];
            
        }else{
            //BBLOG(@"%@",resultModel.resultDic);
            NSDictionary *resultDic = resultModel.resultDic;
            NSDictionary *responseDic = resultDic[@"response"];
            
            
            KKMyCommentListModel *commentListModel = [KKMyCommentListModel mj_objectWithKeyValues:responseDic];
            self.paginator = commentListModel.paginator;
            
            //3.1 取出动态数组
            
            //3.2 更新数据
            if (self.paginator.page == 1) {
                [self.mutArr removeAllObjects];
            }
            
            [self.mutArr addObjectsFromArray:commentListModel.commentSimpleList];
            
            //3.3 刷新tableView
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - jump


@end
