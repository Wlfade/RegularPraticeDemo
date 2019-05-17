//
//  KKDisplayPhotoView.m
//  JCZJ
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "KKDisplayPhotoView.h"

@implementation KKDisplayPhotoView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    
    if (self) {
        
        UIImageView *photoImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 5, frame.size.width-5, frame.size.height-5)];
        self.photoImageView = photoImageView;
        photoImageView.contentMode =  UIViewContentModeScaleAspectFill;
        photoImageView.clipsToBounds  = YES;
        [self addSubview:photoImageView];
        
        CC_Button *removeButton=[CC_Button buttonWithType:UIButtonTypeCustom];
        self.removeButton = removeButton;
        removeButton.frame=CGRectMake(frame.size.width-20, 0, 22, 22);
        [removeButton setBackgroundImage:[UIImage imageNamed:@"subject_circleDelete_icon"] forState:UIControlStateNormal];
        [self addSubview:removeButton];
    }
    
    return self;
    
}

- (void)removeButtonTapped{
    [self removeFromSuperview];
}


@end
