//
//  SubmitView.h
//  JCZJ
//
//  Created by apple on 15/12/8.
//  Copyright © 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CheckMark = 0,   //
    YellowStar = 1, //
    FakeStar = 2,
    Fork=3,
} ImageType;

@interface SubmitView : UIView{
    NSString *textString;
    
    ImageType myImageType;
}

@property(nonatomic,retain) NSString *textString;
@property(nonatomic,assign) ImageType myImageType;

@end
