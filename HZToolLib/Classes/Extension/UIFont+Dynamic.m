//
//  UIFont+Dynamic.m
//  GifEditor
//
//  Created by quanhai on 2022/4/9.
//

#import "UIFont+Dynamic.h"
#import <CoreText/CoreText.h>

@implementation UIFont (Dynamic)

+ (UIFont *)customFontWithPath:(NSString*)path size:(CGFloat)size{
	
	NSURL *fontUrl = [NSURL fileURLWithPath:path];
	CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)fontUrl);
	CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
	CGDataProviderRelease(fontDataProvider);
	CTFontManagerRegisterGraphicsFont(fontRef, NULL);
	NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
	UIFont *font = [UIFont fontWithName:fontName size:size];
	CGFontRelease(fontRef);
	return font;
}

@end
