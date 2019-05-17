//
//  DGLabel.m
//  DGTool
//
//  Created by jczj on 2018/8/23.
//  Copyright © 2018年 david. All rights reserved.
//

#import "DGLabel.h"

@interface DGLabel ()
//tapGr
@property (nonatomic,copy) void(^tapBlock)(NSInteger tag);
@property (nonatomic, assign) float timeInterval;

@end

@implementation DGLabel

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



/** 创建 制定text,font,color的label */
+ (DGLabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color {
    return [self labelWithText:text fontSize:fontSize color:color bold:NO];
}

/** 创建 制定text,font,color,isBold的label */
+ (DGLabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color bold:(BOOL)isBold {
    
    DGLabel *label = [[DGLabel alloc]init];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    
    if (isBold) {
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    return label;
}

#pragma mark - tap
/** 添加tap收拾 */
-(void)addTapWithTimeInterval:(float)timeInterval tapBlock:(void(^)(NSInteger tag))tapBlock {
    //1.tapGr
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSelf:)];
    [self addGestureRecognizer:tap];
    
    //2.block
    self.tapBlock = tapBlock;
    self.userInteractionEnabled = YES;
    self.timeInterval = timeInterval>0 ? timeInterval : 0;
}

/** tap操作 */
-(void)tapSelf:(UITapGestureRecognizer *)gr {
    if (self.tapBlock) {
        self.tapBlock(self.tag);
    }
    
    self.userInteractionEnabled = NO;
    [self performSelector:@selector(changeEnabled:) withObject:gr afterDelay:self.timeInterval];
}

/** 改变userInteractionEnabled */
- (void)changeEnabled:(UITapGestureRecognizer *)gr {
    self.userInteractionEnabled = YES;
}

@end
