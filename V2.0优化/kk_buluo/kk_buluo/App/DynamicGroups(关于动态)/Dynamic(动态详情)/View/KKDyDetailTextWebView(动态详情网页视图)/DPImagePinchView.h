//
//  DPImagePinchView.h
//  JCZJ
//
//  Created by sunny_ios on 16/3/28.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "BaseViewController.h"
#import "BaseViewController.h"
@interface DPImagePinchView : UIScrollView <UIScrollViewDelegate> {
    UIImageView *_imageView;
}

@property (nonatomic, strong) UIImageView *imageView;

@end

@interface DPImageShowViewControl : BaseViewController

- (instancetype)initWitImageUrlStrs:(NSArray *)urls currentIndex:(NSInteger)curIndex;
 
@end
