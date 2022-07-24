//
//  Extension+UIFont.swift
//  GifEditor
//
//  Created by chunyu on 2022/3/26.
//

import UIKit

extension UIFont {
    enum FontWeightStyle {
        case light, semibold, medium, regular, thin, ultralight
    }
    
    static func pingFang(fontSize: CGFloat, style: FontWeightStyle = .regular) -> UIFont {
        var fontName: String?
        var fontWeight: UIFont.Weight?
        
        switch style {
        case .light:
            fontName = "PingFangSC-Light"
            fontWeight = UIFont.Weight.light
        case .semibold:
            fontName = "PingFangSC-Semibold"
            fontWeight = UIFont.Weight.semibold
        case .medium:
            fontName = "PingFangSC-Medium"
            fontWeight = UIFont.Weight.medium
        case .thin:
            fontName = "PingFangSC-Thin"
            fontWeight = UIFont.Weight.thin
        case .ultralight:
            fontName = "PingFangSC-Ultralight"
            fontWeight = UIFont.Weight.ultraLight
            
        default:
            fontName = "PingFangSC-Regular"
            fontWeight = UIFont.Weight.regular
        }
        
        let font = UIFont(name: fontName!, size: fontSize)
        
        if let f = font {
            return f
        } else {
            return UIFont.systemFont(ofSize: fontSize, weight: fontWeight!)
        }
    }
}
