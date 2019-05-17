//
//  HHPaginator.h
//  HHSLive
//
//  Created by 郦道元  on 2017/9/28.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "HHBaseModel.h"

@interface HHPaginator : HHBaseModel


@property(nonatomic,assign)NSInteger items;// = 1;
@property(nonatomic,assign)NSInteger itemsPerPage;// = 20;
@property(nonatomic,assign)NSInteger page;// = 1+1>pages;
@property(nonatomic,assign)NSInteger pages;// = 1;


@end
