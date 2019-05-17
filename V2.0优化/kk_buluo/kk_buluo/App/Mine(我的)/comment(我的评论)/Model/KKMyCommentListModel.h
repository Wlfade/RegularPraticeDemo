//
//  KKMyCommentListModel.h
//  kk_buluo
//
//  Created by david on 2019/3/25.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HHPaginator.h"

@class
KKMyCommentSimpleModel,
KKMyCommentTopicSimpleModel,
KKMyCommentTopicObjectModel,
KKMyCommentTopicObjectImagePropertiesModel,
KKMyCommentTopicObjectImagePropertiesUrlModel;

@interface KKMyCommentListModel : NSObject

@property (nonatomic, strong) NSArray <KKMyCommentSimpleModel *>*commentSimpleList;

@property (nonatomic, strong) HHPaginator *paginator;

@end


//---------------------------------------------------------
@interface KKMyCommentSimpleModel : NSObject

@property (nonatomic, copy) NSString *nowDate;

@property (nonatomic, copy) NSString *commonObjectName;

@property (nonatomic, copy) NSString *commonObjectId;

@property (nonatomic, copy) NSString *commonObjectLogoUrl;

@property (nonatomic, copy) NSString *idStr;//原id

@property (nonatomic, copy) NSString *content;

@property (nonatomic, copy) NSAttributedString *attributedContent;//content处理后可显示表情的content

@property (nonatomic, copy) NSString *gmtCreate;

@property (nonatomic, assign) BOOL userDeleted;

@property (nonatomic, assign) BOOL systemDeleted;

@property (nonatomic, assign) NSInteger floor;


@property (nonatomic, strong) KKMyCommentTopicSimpleModel *topicSimple;

@end


@interface KKMyCommentTopicSimpleModel : NSObject

@property (nonatomic, copy) NSString *commonObjectName;

@property (nonatomic, copy) NSString *commonObjectId;

@property (nonatomic, copy) NSString *commonObjectLogoUrl;

@property (nonatomic, strong) KKMyCommentTopicObjectModel *topicObject;

@end


@interface KKMyCommentTopicObjectModel : NSObject

@property (nonatomic, copy) NSString *commonObjectName;

@property (nonatomic, copy) NSString *commonObjectId;

@property (nonatomic, copy) NSString *commonObjectLogoUrl;

@property (nonatomic, copy) NSString *subjectId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *summary;

@property (nonatomic, copy) NSAttributedString *attributedSummary;//summary处理后可显示表情的summary

@property (nonatomic, strong) KKMyCommentTopicObjectImagePropertiesModel *properties;
@end


@interface KKMyCommentTopicObjectImagePropertiesModel : NSObject

@property (nonatomic, strong) NSArray <KKMyCommentTopicObjectImagePropertiesUrlModel *>*smallImageList;
@property (nonatomic, strong) NSArray <KKMyCommentTopicObjectImagePropertiesUrlModel *>*middleImageList;
@property (nonatomic, strong) NSArray <KKMyCommentTopicObjectImagePropertiesUrlModel *>*largerImageList;
@property (nonatomic, strong) NSArray <KKMyCommentTopicObjectImagePropertiesUrlModel *>*originalImageList;
@end


@interface KKMyCommentTopicObjectImagePropertiesUrlModel : NSObject

@property (nonatomic, copy) NSString *url;

@end
