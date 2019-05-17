//
//  GEmotionView.h
//  JCZJ
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GEmotionDelegate <NSObject>

- (void)GEmotionTapped:(NSDictionary *)infoDic;

@end

typedef enum : NSUInteger{
    GEmotionTypeNormal ,
    GEmotionTypeSend
}GEmotionType;


@interface GEmotionView : UIView<UIScrollViewDelegate>{
    NSArray *nameArray;
    NSMutableDictionary *data;
}

@property (nonatomic, weak) id <GEmotionDelegate> delegate;

@property (nonatomic, strong) UIButton *sendBtn ;
@property (nonatomic, strong) UIImageView *emotionTagImageView ;

- (id)initWithFrame:(CGRect)frame GEmotion:(GEmotionType)type ;
@end
