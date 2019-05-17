//
//  KKChatSearchVC.m
//  kk_buluo
//
//  Created by david on 2019/3/22.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatSearchVC.h"
#import "KKChatSearchMoreVC.h"
#import "KKChatVC.h"
//view
#import "KKChatSearchBar.h"
#import "KKChatListSearchTableViewCell.h"
//融云
#import <RongIMKit/RongIMKit.h>

#define kChatListSearchCell @"KKChatListSearchTableViewCell"

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
    self.view.backgroundColor = COLOR_BG;
    
    [self setupNavi];
    [self setupUI];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
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


#pragma mark - UI
-(void)setupNavi {

    
    //1.searchV
    UIView *searchV = [[UIView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT, SCREEN_WIDTH, 44)];
    
    //2. searchBar
    KKChatSearchBar *searchBar = [[KKChatSearchBar alloc] initWithFrame:CGRectMake(0, 0, searchV.frame.size.width - 65, 44) hasBorder:NO];
    [searchV addSubview:searchBar];
    self.searchBar = searchBar;
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor blueColor];
    [searchBar becomeFirstResponder];
   
    //3.cancelBtn
    DGButton *cancelBtn = [DGButton btnWithFontSize:[ccui getRH:18] title:@"取消" titleColor:COLOR_BLACK_TEXT];
    cancelBtn.frame = CGRectMake(CGRectGetMaxX(searchBar.frame)-3, CGRectGetMinY(searchBar.frame), 55, 44);
    WS(weakSelf);
    [cancelBtn addClickBlock:^(DGButton *btn) {
        [weakSelf clickCancelButton];
    }];
    [searchV addSubview:cancelBtn];
    
    //4.设置navi
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self hideBackButton:YES];
    [self.naviBar addSubview:searchV];
}


-(void)setupUI {
    
    UITableView *tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, self.view.frame.size.width, SCREEN_HEIGHT-STATUS_AND_NAV_BAR_HEIGHT-HOME_INDICATOR_HEIGHT) style:UITableViewStylePlain];
    self.resultTableView = tableV;
    tableV.backgroundColor = [UIColor clearColor];
    tableV.delegate = self;
    tableV.dataSource = self;
    [tableV setSeparatorColor:COLOR_HEX(0xdfdfdf)];
    [self.view addSubview:tableV];
    //cell
    [tableV registerClass:[KKChatListSearchTableViewCell class] forCellReuseIdentifier:kChatListSearchCell];
    
    //fotter
    tableV.tableFooterView = [UIView new];
}


#pragma mark tool
-(UIView *)createSeactionHeaderView:(NSString *)text {
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = UIColor.whiteColor;
    //1.label
    DGLabel *label = [DGLabel labelWithText:text fontSize:[ccui getRH:13] color:COLOR_GRAY_TEXT];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:10]);
        make.centerY.mas_equalTo(0);
    }];
    //2.grayLine
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = COLOR_BG;
    [view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1.5);
    }];
    return view;
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

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(self.searchResult.count > 0){
        return [self createSeactionHeaderView:@"聊天记录"];
    }
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSInteger row = indexPath.row;
    
    //1.获取cell
    KKChatListSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChatListSearchCell forIndexPath:indexPath];
    
    //2.设置cell
    RCSearchConversationResult *sResult = self.searchResult[row];
    RCConversation *conversation = sResult.conversation;
    if (conversation.conversationType == ConversationType_GROUP) {
        [[RCIM sharedRCIM].groupInfoDataSource getGroupInfoWithGroupId:conversation.targetId completion:^(RCGroup *groupInfo) {
            [cell.headIconImageView sd_setImageWithURL:Url(groupInfo.portraitUri)];
            cell.nameLabel.text = groupInfo.groupName;
            cell.msgLabel.text = [NSString stringWithFormat:@"%d条相关的记录",sResult.matchCount];
        }];
        
    }else {
        [[RCIM sharedRCIM].userInfoDataSource getUserInfoWithUserId:conversation.targetId completion:^(RCUserInfo *userInfo) {
            [cell.headIconImageView sd_setImageWithURL:Url(userInfo.portraitUri)];
            cell.nameLabel.text = userInfo.name;
            cell.msgLabel.text = [NSString stringWithFormat:@"%d条相关的记录",sResult.matchCount];
        }];
    }
    
    //3.return
    return cell;
}



#pragma mark  UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(self.searchResult.count > 0){
        return 30;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //1.获取cell
    KKChatListSearchTableViewCell *cell = (KKChatListSearchTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //2.搜索消息
    RCSearchConversationResult *sResult = self.searchResult[indexPath.row];
    RCConversation *conversation = sResult.conversation;
    NSArray <RCMessage *>*msgArr = [[RCIMClient sharedRCIMClient] searchMessages:conversation.conversationType targetId:conversation.targetId keyword:self.searchBar.text count:sResult.matchCount startTime:0];
    
    if(msgArr.count > 1){
        [self pushToSearchMoreVcWithMsgArr:msgArr naviTitle:cell.nameLabel.text];
    }else {
        [self pushToChatVC:conversation.conversationType targetId:conversation.targetId];
    }
    
}


#pragma mark UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //1.search
    NSArray *conversationTypeArr = @[@(ConversationType_GROUP), @(ConversationType_PRIVATE),@(ConversationType_DISCUSSION)];
    NSArray *msgTypeArr = @[
                            [RCTextMessage getObjectName], [RCRichContentMessage getObjectName], [RCFileMessage getObjectName]
                            ];
    self.searchResult = [[RCIMClient sharedRCIMClient] searchConversations:conversationTypeArr messageType:msgTypeArr keyword:searchText];
    //2.reload
    [self.resultTableView reloadData];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}



#pragma mark - notification


#pragma mark - request


#pragma mark - jump

-(void)pushToChatVC:(RCConversationType)type targetId:(NSString *)targetId {
    KKChatVC *chatVC = [[KKChatVC alloc]initWithConversationType:type targetId:targetId];
    [self.navigationController pushViewController:chatVC animated:YES];
}

-(void)pushToSearchMoreVcWithMsgArr:(NSArray <RCMessage *>*)msgArr naviTitle:(NSString *)title {
    KKChatSearchMoreVC *moreVC = [[KKChatSearchMoreVC alloc]init];
    moreVC.msgArr = msgArr;
    moreVC.naviTitleStr = title;
    moreVC.keywords = self.searchBar.text;
    [self.navigationController pushViewController:moreVC animated:YES];
}

@end
