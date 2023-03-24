//
//  Extension+Attr.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation
import UIKit

extension NSAttributedString{
    
    /// 获取NSAttributeString正确的排版大小 , boundingRect 经常错误
    /// - Parameter size: 适配大小
    /// - Returns: 最终大小
    func sizeFit(_ size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: CGFLOAT_MAX)) -> CGSize{
        let textContainer = NSTextContainer(size: size)
        textContainer.maximumNumberOfLines = 0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.lineFragmentPadding = 0
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let storage = NSTextStorage(attributedString: self)
        storage.addLayoutManager(layoutManager)
        
        layoutManager.glyphRange(forBoundingRect: CGRect(origin: .zero, size: size), in: textContainer)
        let rect = layoutManager.usedRect(for: textContainer)
        return rect.size
    }
    
    func boundingRectForRange(_ range: NSRange, size: CGSize) -> CGRect{
        let textContainer = NSTextContainer(size: size)
        textContainer.maximumNumberOfLines = 0
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.lineFragmentPadding = 0
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let storage = NSTextStorage(attributedString: self)
        storage.addLayoutManager(layoutManager)
        
        var actualRange = NSRange()
        layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: &actualRange)
        return layoutManager.boundingRect(forGlyphRange: actualRange, in: textContainer)
    }
}
