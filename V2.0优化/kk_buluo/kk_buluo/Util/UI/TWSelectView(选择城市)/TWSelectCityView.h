//
//  TWSelectCityView.h
//  TWCitySelectView
//
//  Created by TreeWriteMac on 16/6/30.
//  Copyright © 2016年 Raykin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TWSelectCityView : UIView
-(void)showCityView:(void(^)(NSString *proviceStr,NSString *cityStr))selectedBlock;

@end
