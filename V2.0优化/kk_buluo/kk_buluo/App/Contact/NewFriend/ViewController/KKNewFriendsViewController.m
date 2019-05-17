//
//  KKNewFriendsViewController.m
//  kk_buluo
//
//  Created by new on 2019/3/16.
//  Copyright © 2019年 yaya. All rights reserved.
//

#import "KKNewFriendsViewController.h"
#import "KKNewFriendsCell.h"
#import "KKNewFriendsModel.h"

@interface KKNewFriendsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *nearlyThreeDaysApplies; /// threeDaysAgoApplies
@property (nonatomic, strong) NSMutableArray *threeDaysAgoApplies;

@end

@implementation KKNewFriendsViewController
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[KKNewFriendsCell class] forCellReuseIdentifier:@"cellID"];
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

- (NSMutableArray *)nearlyThreeDaysApplies {
    if (!_nearlyThreeDaysApplies) {
        _nearlyThreeDaysApplies = [NSMutableArray array];
    }
    return _nearlyThreeDaysApplies;
}

- (NSMutableArray *)threeDaysAgoApplies {
    if (!_threeDaysAgoApplies) {
        _threeDaysAgoApplies = [NSMutableArray array];
    }
    return _threeDaysAgoApplies;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count == 0) {
        return 0;
    }else if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count == 0) {
        return 0;
    }else if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
        return self.nearlyThreeDaysApplies.count;
    }else if (self.threeDaysAgoApplies.count != 0 && self.nearlyThreeDaysApplies.count == 0){
        return self.threeDaysAgoApplies.count;
    }else {
        if (section == 0) {
            return self.nearlyThreeDaysApplies.count;
        }else {
            return self.threeDaysAgoApplies.count;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return 30;
    }else {
        return 0.0001;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKNewFriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count == 0) {
        
    }else if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
        cell.friendsModel = self.nearlyThreeDaysApplies[indexPath.row];
    }else if (self.threeDaysAgoApplies.count != 0 && self.nearlyThreeDaysApplies.count == 0){
        cell.friendsModel = self.threeDaysAgoApplies[indexPath.row];
    }else {
        if (indexPath.section == 0) {
            cell.friendsModel = self.nearlyThreeDaysApplies[indexPath.row];
        }else {
            cell.friendsModel = self.threeDaysAgoApplies[indexPath.row];
        }
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *sectionHeader = [[UIView alloc] init];
        [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1/1.0];
        sectionHeader.backgroundColor =  [UIColor colorWithRed:214/255.0 green:214/255.0 blue:214/255.0 alpha:1/1.0];
        UILabel *label = [[UILabel alloc]init];
        label.frame = CGRectMake(15, 10, 43, 13);
        label.adjustsFontSizeToFitWidth = YES;
        [sectionHeader addSubview:label];
        label.font = [UIFont fontWithName:@"PingFangTC-Medium" size:18];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1/1.0];
        if (self.threeDaysAgoApplies.count == 0 && self.nearlyThreeDaysApplies.count != 0){
            label.text = self.sectionArray[0];
        }else if (self.threeDaysAgoApplies.count != 0 && self.nearlyThreeDaysApplies.count == 0){
            label.text = self.sectionArray[1];
        }else {
            label.text = self.sectionArray[section];
        }
        return sectionHeader;
    }else {
        return nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.sectionArray = @[@"近三天", @"三天前"];
    self.title = @"新朋友";
    
    [self getNewFriendRequest];
}
- (void)getNewFriendRequest {
    WS(weakSelf)
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_APPLY_FRIEND_QUERY" forKey:@"service"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
       
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        [weakSelf.threeDaysAgoApplies addObjectsFromArray:[KKNewFriendsModel mj_objectArrayWithKeyValuesArray:responseDic[@"threeDaysAgoApplies"]]];
        [weakSelf.nearlyThreeDaysApplies addObjectsFromArray:[KKNewFriendsModel mj_objectArrayWithKeyValuesArray:responseDic[@"nearlyThreeDaysApplies"]]];
        
        if (self.threeDaysAgoApplies.count != 0 || self.nearlyThreeDaysApplies.count == 0) {
            [self.tableView reloadData];
        }

    }];
}
@end
