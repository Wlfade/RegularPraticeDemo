//
//  BBDynamicBlowUpCell.h
//  BananaBall
//
//  Created by 单车 on 2018/2/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BBDynamicBlowUpCell;
@protocol BBDynamicBlowUpCellDelegate <NSObject>
- (void) BBDynamicBlowUpCellTap:(BBDynamicBlowUpCell *)blowUpCell;
@end
@interface BBDynamicBlowUpCell : UICollectionViewCell
@property (nonatomic,weak)id<BBDynamicBlowUpCellDelegate> delegate;
@property (nonatomic,strong)UIImageView *imageView;
@end
