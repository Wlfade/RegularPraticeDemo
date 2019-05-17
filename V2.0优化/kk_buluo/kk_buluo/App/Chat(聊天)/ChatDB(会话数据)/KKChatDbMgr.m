//
//  KKChatDbMgr.m
//  kk_buluo
//
//  Created by david on 2019/3/29.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKChatDbMgr.h"
//三方
#import <FMDB.h>

/** Documents文件夹的路径 */
#define kDocPath    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject


#define kUserInfoDb       @"userInfoDb"//用户
#define kUserInfoTable    @"userInfoTable"

#define kGroupInfoDb      @"groupInfoDb"//群
#define kGroupInfoTable   @"groupInfoTable"

#define kIdKey   @"idStr"
#define kNameKey   @"name"
#define kLogoKey   @"logoUrl"
#define kGroupMemberKey   @"groupMemberNumber"




@interface KKChatDbMgr ()

@property (nonatomic, strong) NSLock *userLock;
@property (nonatomic, strong)FMDatabase *userInfoDb;

@property (nonatomic, strong) NSLock *groupLock;
@property (nonatomic, strong)FMDatabase *groupInfoDb;
@end

@implementation KKChatDbMgr

static KKChatDbMgr *chatDbMgr = nil;
static dispatch_once_t onceToken;

#pragma mark - lazy load
-(NSLock *)userLock {
    if (!_userLock) {
        _userLock = [[NSLock alloc]init];
    }
    return _userLock;
}

-(NSLock *)groupLock {
    if (!_groupLock) {
        _groupLock = [[NSLock alloc]init];
    }
    return _groupLock;
}

-(FMDatabase *)userInfoDb {
    
    if (!_userInfoDb) {
        [self.userLock lock];
        
         //1.创建db(仅仅是创建fmdb.db文件,并没有打开)
        NSString *componentStr = [NSString stringWithFormat:@"%@.db",kUserInfoDb];
        NSString *dbFilePath = [kDocPath stringByAppendingPathComponent:componentStr];
        _userInfoDb = [FMDatabase databaseWithPath:dbFilePath];
        
        //2.执行sql创建表
        if ([_userInfoDb open]) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key, %@ text, %@ text, %@ text)",kUserInfoTable,kIdKey,kNameKey,kLogoKey];
            BOOL isSucess = [_userInfoDb executeUpdate:sql];
            if(!isSucess){
                CCLOG(@"创建表失败:%@", _userInfoDb.lastError);
            }
        }
        //3.关闭db
        [_userInfoDb close];
        [self.userLock unlock];
    }
    
    return _userInfoDb;
}

-(FMDatabase *)groupInfoDb {
    if (!_groupInfoDb) {
        [self.groupLock lock];
        
        //1.创建db(仅仅是创建fmdb.db文件,并没有打开)
        NSString *componentStr = [NSString stringWithFormat:@"%@.db",kGroupInfoDb];
        NSString *dbFilePath = [kDocPath stringByAppendingPathComponent:componentStr];
        _groupInfoDb = [FMDatabase databaseWithPath:dbFilePath];
        
        //2.执行sql创建表
        if ([_groupInfoDb open]) {
            NSString *sql = [NSString stringWithFormat:@"create table if not exists %@ (id integer primary key, %@ text, %@ text, %@ text, %@ text)",kGroupInfoTable,kIdKey,kNameKey,kLogoKey,kGroupMemberKey];
            BOOL isSucess = [_groupInfoDb executeUpdate:sql];
            if(!isSucess){
                CCLOG(@"创建表失败:%@", _groupInfoDb.lastError);
            }
        }
        //3.关闭db
        [_groupInfoDb close];
        [self.groupLock unlock];
    }
    return _groupInfoDb;
}


#pragma mark - life circle
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        chatDbMgr = [[KKChatDbMgr alloc] init];
    });
    return chatDbMgr;
}


#pragma mark - userInfo
-(void)saveUserInfo:(KKChatDbModel *)model {
    
    FMDatabase *db = self.userInfoDb;
    NSString *table = kUserInfoTable;
    KKChatDbModel *inDbModel = [self getDbUserInfo:model.idStr];
    
    //1.有数据,更新表
    if (inDbModel) {
        [self.userLock lock];
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set %@='%@',%@='%@' where %@='%@'",table,kNameKey,model.name,kLogoKey,model.logoUrl,kIdKey,model.idStr];
            BOOL isSuccess = [db executeUpdate:sql];
            if (!isSuccess) {
                CCLOG(@"更新userInfo表数据失败:%@", db.lastError);
            }
        }
        [db close];
        [self.userLock unlock];
        return;
    }
    
    //2.插入数据
    [self.userLock lock];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@) values ('%@','%@','%@')",table,kIdKey,kNameKey,kLogoKey,model.idStr,model.name,model.logoUrl];
        BOOL isSuccess = [db executeUpdate:sql];
        if (!isSuccess) {
            CCLOG(@"插入userInfo表数据失败:%@", db.lastError);
        }
    }
    [db close];
    [self.userLock unlock];
}


-(KKChatDbModel *)getDbUserInfo:(NSString *)idStr {
    
    FMDatabase *db = self.userInfoDb;
    NSString *table = kUserInfoTable;
    KKChatDbModel *model;
    
    //1.打开db
    [self.userLock lock];
    if ([db open]) {
        NSString *name = kNameKey;
        NSString *logo = kLogoKey;
        NSString *selectSql = [NSString stringWithFormat:@"select %@,%@ from %@ where %@='%@'",name,logo,table,kIdKey,idStr];
        //2.查表
        FMResultSet *resultSet = [db executeQuery:selectSql];
        while ([resultSet next]) {
            if (model) {
                break;
            }else {
                model = [[KKChatDbModel alloc]init];
                model.idStr = idStr;
                model.name = [resultSet stringForColumn:name];
                model.logoUrl = [resultSet stringForColumn:logo];
            }
        }
    }
    //3.关闭db
    [db close];
    [self.userLock unlock];
    
    //4.return
    return model;
}

-(void)removeUserInfo:(NSString *)idStr {
    
    if (idStr.length < 1) {
        return;
    }
    
    FMDatabase *db = self.userInfoDb;
    NSString *table = kUserInfoTable;
    
    //1.打开db
    [self.userLock lock];
    if ([db open]) {
        //2.删除
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@='%@'",table,kIdKey,idStr];
        BOOL isSuccess = [db executeUpdate:sql];
        if (!isSuccess) {
            CCLOG(@"删除groupInfo表id=%@数据失败:%@", idStr, db.lastError);
        }
    }
    //3.关闭db
    [db close];
    [self.userLock unlock];
}


#pragma mark - groupInfo
-(void)saveGroupInfo:(KKChatDbModel *)model {
    
    FMDatabase *db = self.groupInfoDb;
    NSString *table = kGroupInfoTable;
    KKChatDbModel *inDbModel = [self getDbGroupInfo:model.idStr];
    
    //1.有数据,更新表
    if (inDbModel) {
        [self.groupLock lock];
        if ([db open]) {
            NSString *sql = [NSString stringWithFormat:@"update %@ set %@='%@',%@='%@',%@='%@' where %@='%@'",table,kNameKey,model.name,kLogoKey,model.logoUrl,kGroupMemberKey,inDbModel.groupMemberNumber,kIdKey,model.idStr];
            BOOL isSuccess = [db executeUpdate:sql];
            if (!isSuccess) {
                CCLOG(@"更新groupInfo表数据失败:%@", db.lastError);
            }
        }
        [db close];
        [self.groupLock unlock];
        return;
    }
    
    //2.插入数据
    [self.groupLock lock];
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@) values ('%@','%@','%@','%@')",table,kIdKey,kNameKey,kLogoKey,kGroupMemberKey,model.idStr,model.name,model.logoUrl,model.groupMemberNumber];
        BOOL isSuccess = [db executeUpdate:sql];
        if (!isSuccess) {
            CCLOG(@"插入groupInfo表数据失败:%@", db.lastError);
        }
    }
    [db close];
    [self.groupLock unlock];
}

-(KKChatDbModel *)getDbGroupInfo:(NSString *)idStr {
    
    FMDatabase *db = self.groupInfoDb;
    NSString *table = kGroupInfoTable;
    KKChatDbModel *model;
    
    //1.打开db
    [self.groupLock lock];
    if ([db open]) {
        NSString *name = kNameKey;
        NSString *logo = kLogoKey;
        NSString *groupMember = kGroupMemberKey;
        NSString *selectSql = [NSString stringWithFormat:@"select %@,%@,%@ from %@ where %@='%@'",name,logo,groupMember,table,kIdKey,idStr];
        //2.查表
        FMResultSet *resultSet = [db executeQuery:selectSql];
        while ([resultSet next]) {
            if (model) {
                break;
            }else {
                model = [[KKChatDbModel alloc]init];
                model.idStr = idStr;
                model.name = [resultSet stringForColumn:name];
                model.logoUrl = [resultSet stringForColumn:logo];
                model.groupMemberNumber = [resultSet stringForColumn:groupMember];
            }
        }
    }
    //3.关闭db
    [db close];
    [self.groupLock unlock];
    
    //4.return
    return model;
}

-(void)removeGroupInfo:(NSString *)idStr {

    if (idStr.length < 1) {
        return;
    }
    
    FMDatabase *db = self.groupInfoDb;
    NSString *table = kGroupInfoTable;
    
    //1.打开db
    [self.groupLock lock];
    if ([db open]) {
        //2.删除
        NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@='%@'",table,kIdKey,idStr];
        BOOL isSuccess = [db executeUpdate:sql];
        if (!isSuccess) {
            CCLOG(@"删除groupInfo表id=%@数据失败:%@", idStr, db.lastError);
        }
    }
    //3.关闭db
    [db close];
    [self.groupLock unlock];
}


#pragma mark - other
-(void)clearAllTableData {
    [self clearTable:kUserInfoTable formDb:self.userInfoDb];
    [self clearTable:kGroupInfoTable formDb:self.groupInfoDb];
}

-(void)clearTable:(NSString *)table formDb:(FMDatabase *)db {
    
    NSLock *lock = self.groupLock;
    if ([table isEqualToString:kUserInfoTable]) {
        lock = self.userLock;
    }
    [lock lock];
    //2.插入数据
    if ([db open]) {
        NSString *sql = [NSString stringWithFormat:@"delete from %@",table];
        BOOL isSuccess = [db executeUpdate:sql];
        if (!isSuccess) {
            CCLOG(@"clear表%@数据失败:%@",table , db.lastError);
        }
    }
    [db close];
    [lock unlock];
}

@end
