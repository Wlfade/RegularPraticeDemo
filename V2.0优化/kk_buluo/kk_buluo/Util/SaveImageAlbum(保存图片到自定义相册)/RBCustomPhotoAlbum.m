//
//  RBCustomPhotoAlbum.m
//  SavePhotoDemo
//
//  Created by 单车 on 2019/1/14.
//  Copyright © 2019 allison. All rights reserved.
//

#import "RBCustomPhotoAlbum.h"
#import <Photos/Photos.h>

#import "SubmitView.h"

@interface RBCustomPhotoAlbum ()
/** 获得当前App对应的自定义相册 */
@property (nonatomic,strong) PHAssetCollection *createdCollection;
@end

@implementation RBCustomPhotoAlbum
static RBCustomPhotoAlbum *_shareInstance;
+ (instancetype)shareInstance {
    if (_shareInstance == nil) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _shareInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _shareInstance;
}
#pragma mark - 获得当前App对应的自定义相册
- (PHAssetCollection *)createdCollection
{
    // 获得APP名字
    NSString *title = [NSBundle mainBundle].infoDictionary[(__bridge NSString *)kCFBundleNameKey];

    // 抓取所有的自定义相册
    PHFetchResult<PHAssetCollection *> *collections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];

    // 查找当前App对应的自定义相册
    for (PHAssetCollection *collection in collections) {
        if ([collection.localizedTitle isEqualToString:title]) {
            return collection;
        }
    }

    /** 当前App对应的自定义相册没有被创建过 **/
    // 创建一个【自定义相册】
    NSError *error = nil;
    __block NSString *createdCollectionID = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        createdCollectionID = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:title].placeholderForCreatedAssetCollection.localIdentifier;
    } error:&error];

    if (error) return nil;

    // 根据唯一标识获得刚才创建的相册
    return [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[createdCollectionID] options:nil].firstObject;
}
#pragma mark - 获得相片
- (PHFetchResult<PHAsset *> *)createdAssets:(nonnull UIImage *)image
{
    NSError *error = nil;
    __block NSString *assetID = nil;
    // 保存图片到【相机胶卷】
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
    } error:&error];

    if (error) return nil;

    // 获取刚才保存的相片
    return [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil];
}

#pragma mark --  <保存图片到相册>
- (void)saveImageIntoAlbum:(nonnull UIImage *)image withNeedReminder:(BOOL)reminder{

    PHAuthorizationStatus oldStatus = [PHPhotoLibrary authorizationStatus];
    //请求、检查访问权限
    //如果用户还没有做出选择、会自动弹框，用户对弹框做出选择后，才会调用block
    //如果之前已经做出选择,会直接执行block
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == PHAuthorizationStatusDenied) {
                //用户拒绝当前APP 访问权限
                if (oldStatus != PHAuthorizationStatusNotDetermined) {
                    [self showAlertMessage:@"请允许打开访问相册权限"];
                }
            }else if (status == PHAuthorizationStatusAuthorized) { // 用户允许当前App访问相册
                [self allowdToSaveImage:image withRemind:reminder];
            } else if (status == PHAuthorizationStatusRestricted) { // 无法访问相册
                [self showAlertMessage:@"因系统原因，无法访问相册"];
            }
        });
    }];
}
- (void)allowdToSaveImage:(UIImage *)image withRemind:(BOOL)remind{

    // 1.先保存图片到【相机胶卷】
    PHFetchResult<PHAsset *> *createdAssets = [self createdAssets:image];
    if (createdAssets == nil) {
        if (remind) {
            [self showSubmitAlert:@"保存图片失败"];
        }
    }
    // 2.拥有一个【自定义相册】
    PHAssetCollection * createdCollection = self.createdCollection;
    if (createdCollection == nil) {
        if (remind) {
            [self showAlertMessage:@"创建或者获取相册失败"];
        }
        return;
    }

    // 添加刚才保存的图片到【自定义相册】
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdCollection];
        [request insertAssets:createdAssets atIndexes:[NSIndexSet indexSetWithIndex:0]];
    } error:&error];

    // 最后的判断
    if (error) {;
        if (remind) {
            [self showSubmitAlert:@"保存图片失败"];
        }
    } else {
        if (remind) {
//            [self showSubmitAlert:@"保存图片成功"];
            [self showSubmitAlert:@"保存图片成功" withImageType:CheckMark];
        }
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void)showAlertMessage:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil
                                                   message:message
                                                  delegate:nil
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"确定", nil];

    [alert show];
}

- (void)showSubmitAlert:(NSString *)subSting withImageType:(ImageType)type{
    SubmitView *submitView = [[SubmitView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 80, SCREEN_HEIGHT / 2 - 80, 160, 120)];
    submitView.backgroundColor = [UIColor clearColor];
    submitView.myImageType = type;
    submitView.textString = subSting;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:submitView];
//    [cc]
//    [CC_NoticeView showError:subSting];
}
- (void)showSubmitAlert:(NSString *)subSting{

    [CC_NoticeView showError:subSting];
}
@end
