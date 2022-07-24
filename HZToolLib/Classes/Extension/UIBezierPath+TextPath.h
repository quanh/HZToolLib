//
//  UIBezierPath+TextPath.h
//  GifEditor
//
//  Created by quanhai on 2022/4/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
	HZTextPathDirectionHorizental,
	HZTextPathDirectionVertical,
} HZTextPathDirection;

@interface UIBezierPath (TextPath)

+ (UIBezierPath *)pathOf:(NSAttributedString *)attr maxWidth: (CGFloat)width;
+ (UIBezierPath *)pathOf:(NSAttributedString *)attr maxWidth: (CGFloat)width aix: (HZTextPathDirection)direction;

+ (UIBezierPath *)pathWithAttributeText: (NSAttributedString *)attrString;
+ (UIBezierPath *)pathWithText:(NSString *)text attributes:(NSDictionary *)attrs;
+ (UIBezierPath *)pathWithText:(NSString *)text font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
