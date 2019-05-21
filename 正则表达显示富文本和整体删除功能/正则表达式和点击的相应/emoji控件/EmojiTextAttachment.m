//
//  EmojiTextAttachment.m
//  InputEmojiExample
//
//  Created by zorro on 15/3/7.
//  Copyright (c) 2015年 tutuge. All rights reserved.
//

#import "EmojiTextAttachment.h"

@implementation EmojiTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    //Return new image size
    return [self scaleImageSizeToWidth:_emojiSize];
}

// Scale image size
- (CGRect)scaleImageSizeToWidth:(CGFloat)width {
    //Scale factor
    CGFloat factor = 1.0;
    
    //Get image size
    CGSize oriSize = [self.image size];
    
    //Calculate factor
    if (_emojiSize==0) {
        
    }else{
         factor = (CGFloat) (width / oriSize.width);   
    }
    
    //Get new size
    if (!_offsetY) {
        _offsetY=-4;
    }
    if (_type==1) {
        _offsetY=-10;
    }
    CGRect newSize = CGRectMake(0, _offsetY, oriSize.width * factor, oriSize.height * factor);
    
    return newSize;
    
}
@end
