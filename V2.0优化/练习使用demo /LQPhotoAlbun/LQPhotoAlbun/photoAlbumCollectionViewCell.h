//
//  photoAlbumCollectionViewCell.h
//  LQPhotoAlbun
//
//  Created by liang lee on 2018/5/9.
//  Copyright © 2018年 liang lee. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol photoAlbumCollectionViewCellDelegate;
@interface photoAlbumCollectionViewCell : UICollectionViewCell<UIScrollViewDelegate>


@property(nonatomic,strong)UIImageView* imageView;

@property(nonatomic,strong)UIScrollView* scrollowView;

@property(nonatomic,weak)id <photoAlbumCollectionViewCellDelegate> delegete;

@end

@protocol photoAlbumCollectionViewCellDelegate <NSObject>

/** 单击图片 */
-(void)textAndImageView:(photoAlbumCollectionViewCell* )item didTapWithImageView:(UIImageView* )imageView;

/** 长按图片 */
-(void)textAndImageView:(photoAlbumCollectionViewCell* )item didLongPressWithImageView:(UIImageView* )imageView WithPoint:(CGPoint )point;



@end
