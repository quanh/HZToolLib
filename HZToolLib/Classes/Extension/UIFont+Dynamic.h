//
//  UIFont+Dynamic.h
//  GifEditor
//
//  Created by quanhai on 2022/4/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Dynamic)

+ (UIFont *)customFontWithPath:(NSString*)path size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
