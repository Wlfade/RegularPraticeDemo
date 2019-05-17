//
//  HHBaseModel.h
//  HHSLive
//
//  Created by 郦道元  on 2017/7/27.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HHBaseModel : NSObject


@property(nonatomic,assign)BOOL success;  // true,
@property(nonatomic,copy)NSString *nowDate;// ": "2017-11-07 09:35:34",
@property(nonatomic,assign)BOOL jumpLogin;//": false,


#pragma mark - optional ovveride
/**
 json转为模型后调用,方便对model的转化
 */
-(void)didFinishConvertToModel;

@end
