//
//  UIBezierPath+TextPath.m
//  GifEditor
//
//  Created by quanhai on 2022/4/19.
//

#import "UIBezierPath+TextPath.h"
#import <CoreText/CoreText.h>


@implementation UIBezierPath (TextPath)


+ (UIBezierPath *)pathOf:(NSAttributedString *)attr maxWidth: (CGFloat)width{
	return [UIBezierPath pathOf:attr maxWidth:width aix:HZTextPathDirectionHorizental];
}

+ (UIBezierPath *)pathOf:(NSAttributedString *)attr maxWidth: (CGFloat)width aix: (HZTextPathDirection)direction{
	CGMutablePathRef paths = CGPathCreateMutable();
	
	NSAttributedString *attrString = attr;
	CTLineRef lineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
	CFArrayRef runArrRef = CTLineGetGlyphRuns(lineRef);
	
	CGRect attrRect = [attrString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
	CGFloat lineHeight = ceil(attrRect.size.height);
    NSAttributedString *oneCharAttr = [[[NSMutableAttributedString alloc] initWithAttributedString:attr] attributedSubstringFromRange:NSMakeRange(0, 1)];
    CGRect oneCharRect = [oneCharAttr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGFloat charWidth = ceil(oneCharRect.size.width);
	
	for (int runIndex = 0; runIndex < CFArrayGetCount(runArrRef); runIndex++) {
		const void *run = CFArrayGetValueAtIndex(runArrRef, runIndex);
		CTRunRef runb = (CTRunRef)run;
		
		const void *CTFontName = kCTFontAttributeName;
		
		const void *runFontC = CFDictionaryGetValue(CTRunGetAttributes(runb), CTFontName);
		CTFontRef runFontS = (CTFontRef)runFontC;
		
		if (direction == HZTextPathDirectionHorizental){
			int line = 0;
			CGFloat newX = .0;
			CGFloat prefixWidth = 0.0;
			
			for (int i = 0; i < CTRunGetGlyphCount(runb); i++) {
				CFRange range = CFRangeMake(i, 1);
				CGGlyph glyph = 0;
				CTRunGetGlyphs(runb, range, &glyph);
				CGPoint position = CGPointZero;
				CTRunGetPositions(runb, range, &position);
				
				CGFloat glyphWidth = position.x;
                int currentLine = floorf((glyphWidth + charWidth)/width); //(int)glyphWidth/width;
				
				// 每次触发换行
				if (currentLine > line) {
					line = currentLine;
					newX = 0;
					prefixWidth = glyphWidth;
				}else{
					newX = glyphWidth - prefixWidth;
				}
				
				CGPathRef path = CTFontCreatePathForGlyph(runFontS, glyph, nil);
				CGFloat y = position.y - (CGFloat)line * lineHeight;
				CGAffineTransform transform = CGAffineTransformMakeTranslation(newX, y);
				CGPathAddPath(paths, &transform, path);
				
				CGPathRelease(path);
			}
		}else{
			int line = 0;
			CGFloat newX = 0.0;
			CGFloat newY = 0.0;
			int prefixIndex = 0;
			
			for (int i = 0; i < CTRunGetGlyphCount(runb); i++) {
				CFRange range = CFRangeMake(i, 1);
				CGGlyph glyph = 0;
				CTRunGetGlyphs(runb, range, &glyph);
				CGPoint position = CGPointZero;
				CTRunGetPositions(runb, range, &position);
				
//				CGFloat glyphWidth = position.x;
				int currentLine = (int)lineHeight * i/width;
				
				// 每次触发换行
				if (currentLine > line) {
					line = currentLine;
					newY = 0;
					prefixIndex = i;
					newX += lineHeight;
				}else{
					newY = lineHeight * (i - prefixIndex);
				}
				
				CGPathRef path = CTFontCreatePathForGlyph(runFontS, glyph, nil);
				CGAffineTransform transform = CGAffineTransformMakeTranslation(newX, -newY);
				CGPathAddPath(paths, &transform, path);
				
				CGPathRelease(path);
			}
		}
		CFRelease(runb);
		CFRelease(runFontS);
	}
	
	UIBezierPath *bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint:CGPointZero];
	[bezierPath appendPath:[UIBezierPath bezierPathWithCGPath:paths]];
	
	CGPathRelease(paths);
	
	return bezierPath;
}

+ (UIBezierPath *)pathWithText:(NSString *)text attributes:(NSDictionary *)attrs {
	NSAssert(text!= nil && attrs != nil, @"参数不能为空");
	NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
	return [self pathWithAttributeText:attrString];
}

+ (UIBezierPath *)pathWithAttributeText: (NSAttributedString *)attrString{
	CGMutablePathRef paths = CGPathCreateMutable();
	CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
	CFArrayRef runArray = CTLineGetGlyphRuns(line);
	
	for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
	{
		CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
		CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
		
		for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
		{
			CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
			CGGlyph glyph;
			CGPoint position;
			CTRunGetGlyphs(run, thisGlyphRange, &glyph);
			CTRunGetPositions(run, thisGlyphRange, &position);
			{
				CGPathRef path = CTFontCreatePathForGlyph(runFont, glyph, NULL);
				CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
				CGPathAddPath(paths, &t,path);
				CGPathRelease(path);
			}
		}
	}
	CFRelease(line);
	UIBezierPath *path = [UIBezierPath bezierPath];
	[path moveToPoint:CGPointZero];
	[path appendPath:[UIBezierPath bezierPathWithCGPath:paths]];
	CGPathRelease(paths);
	return path;
}

+ (UIBezierPath *)pathWithText:(NSString *)text font:(UIFont *)font {
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    if (!ctFont) return nil;
    NSDictionary *attrs = @{ (__bridge id)kCTFontAttributeName:(__bridge id)ctFont };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    CFRelease(ctFont);
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFTypeRef)attrString);
    if (!line) return nil;
    
    CGMutablePathRef cgPath = CGPathCreateMutable();
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    for (CFIndex iRun = 0, iRunMax = CFArrayGetCount(runs); iRun < iRunMax; iRun++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runs, iRun);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        for (CFIndex iGlyph = 0, iGlyphMax = CTRunGetGlyphCount(run); iGlyph < iGlyphMax; iGlyph++) {
            CFRange glyphRange = CFRangeMake(iGlyph, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, glyphRange, &glyph);
            CTRunGetPositions(run, glyphRange, &position);
            
            CGPathRef glyphPath = CTFontCreatePathForGlyph(runFont, glyph, NULL);
            if (glyphPath) {
                CGAffineTransform transform = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(cgPath, &transform, glyphPath);
                CGPathRelease(glyphPath);
            }
        }
    }
    UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:cgPath];
    CGRect boundingBox = CGPathGetPathBoundingBox(cgPath);
    CFRelease(cgPath);
    CFRelease(line);
    
    [path applyTransform:CGAffineTransformMakeScale(1.0, -1.0)];
    [path applyTransform:CGAffineTransformMakeTranslation(0.0, boundingBox.size.height)];
    
    return path;
}

@end
