//
//  KKChatSearchVC.m
//  kk_buluo
//
//  Created by david on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatSearchVC.h"
#import <RongIMKit/RongIMKit.h>
//view
#import "KKChatSearchBar.h"

@interface KKChatSearchVC ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,
UIGestureRecognizerDelegate>
//searchView
@property (nonatomic, strong) KKChatSearchBar *searchBar;
//tableView
@property(nonatomic, strong) UITableView *resultTableView;
@property(nonatomic, strong) DGLabel *emptyLabel;

@property (nonatomic, strong) NSArray <RCSearchConversationResult *>*searchResult;

@end

@implementation KKChatSearchVC

#pragma mark - lazy load

- (DGLabel *)emptyLabel {
    if (!_emptyLabel) {
        _emptyLabel = [[DGLabel alloc] initWithFrame:CGRectMake(10, 45, self.view.frame.size.width - 20, 16)];
        _emptyLabel.font = [UIFont systemFontOfSize:14.f];
        _emptyLabel.textAlignment = NSTextAlignmentCenter;
        _emptyLabel.numberOfLines = 0;
        [self.resultTableView addSubview:_emptyLabel];
    }
    return _emptyLabel;
}


#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    [self setupNavi];
    [self setupUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    if ([self.resultTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.resultTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    if ([self.resultTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.resultTableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   
}

#pragma mark - UI
-(void)setupNavi {

    //1.searchV
    UIView *searchV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    //2.searchBar
    KKChatSearchBar *searchBar = [[KKChatSearchBar alloc] initWithFrame:CGRectMake(0, 0, searchV.frame.size.width - 65, 44)];
    [searchV addSubview:searchBar];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor blueColor];
    [searchBar becomeFirstResponder];
   
    //3.cancelBtn
    DGButton *cancelBtn = [DGButton btnWithFontSize:[ccui getRH:18] title:@"取消" titleColor:COLOR_HEX(0x0099ff)];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(searchBar.frame)-3, CGRectGetMinY(searchBar.frame), 55, 44);
    WS(weakSelf);
    [cancelBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickCancelButton];
    }];
    [searchV addSubview:cancelBtn];
    
    //4.设置navi
    self.navigationItem.titleView = searchV;
}


-(void)setupUI {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.resultTableView = tableV;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.tableFooterView = [UIView new];
    [tableV setSeparatorColor:COLOR_HEX(0xdfdfdf)];
    [self.view addSubview:tableV];
}

#pragma mark - interaction
- (void)clickCancelButton {
    if ([self.delegate respondsToSelector:@selector(onSearchCancelClick)]) {
        [self.delegate onSearchCancelClick];
    }
    [self.searchBar resignFirstResponder];
}

#pragma mark - delegate

#pragma mark tableViewDelegate
#pragma mark  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdStr = @"cellId";
    NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdStr];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdStr];
    }
    
    RCSearchConversationResult *sResult = self.searchResult[row];
    cell.textLabel.text = [NSString stringWithFormat:@"有%d条连天记录",sResult.matchCount];
    return cell;
}

#pragma mark  UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchText = searchBar.text;
    
    NSArray *conversationTypeArr = @[@(ConversationType_GROUP), @(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)];
    NSArray *msgTypeArr = @[
                            [RCTextMessage getObjectName], [RCRichContentMessage getObjectName], [RCFileMessage getObjectName]
                            ];
    self.searchResult = [[RCIMClient sharedRCIMClient] searchConversations:conversationTypeArr messageType:msgTypeArr keyword:searchText];
    
    [searchBar resignFirstResponder];
    [self.resultTableView reloadData];
}

#pragma mark - notification


#pragma mark - request


#pragma mark - jump



@end
