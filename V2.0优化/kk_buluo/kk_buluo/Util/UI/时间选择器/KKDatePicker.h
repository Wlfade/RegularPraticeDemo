//
//  KKDatePicker.h
//  kk_buluo
//
//  Created by david on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKDatePicker : UIView

-(void)showDatePiker:(void(^)(NSDate *date))selectedBlock;
@end

NS_ASSUME_NONNULL_END
