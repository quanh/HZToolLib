//
//  Extension+UIFont.swift
//  GifEditor
//
//  Created by chunyu on 2022/3/26.
//

import UIKit

extension UIFont.Weight{
    func sufix() -> String{
        if self == .bold{
            return "Bold"
        }
        if self == .semibold{
            return "Semibold"
        }
        if self == .medium{
            return "Medium"
        }
        if self == .light{
            return "Light"
        }
        return "Regular"
    }
}

enum hzFont{
    case SFPro(weight: UIFont.Weight, size: CGFloat)
    case SFProRounded(weight: UIFont.Weight, size: CGFloat)
    case SFProDisplay(weight: UIFont.Weight, size: CGFloat)
    case SFProText(weight: UIFont.Weight, size: CGFloat)
    
    case PingFangSC(weight: UIFont.Weight, size: CGFloat)
    
    var name: String?{
        switch self {
        case .SFPro(let weight, _):
            return "SFPro-" + weight.sufix()
        case .SFProRounded(let weight, _):
            return "SFProRounded-" + weight.sufix()
        case .SFProDisplay(let weight, _):
            return "SFProDisplay-" + weight.sufix()
        case .SFProText(let weight, _):
            return "SFProText-" + weight.sufix()
        case .PingFangSC(weight: let weight, _):
            return "PingFangSC-" + weight.sufix()
//        default:
//            return nil
        }
    }
    
    var font: UIFont{
        switch self {
        case .SFPro(let weight, let size),
                .SFProRounded(let weight, let size),
                .SFProDisplay(let weight, let size),
                .SFProText(let weight, let size),
                .PingFangSC(let weight, let size):
            if let name = self.name, let font = UIFont(name: name, size: size){
                return font
            }
            return .systemFont(ofSize: size, weight: weight)
        }
    }
}

extension UIFont{
    static func hzSystemFont(ofSize: CGFloat) -> UIFont{
        return hzSystemFont(ofSize: ofSize, weight: .regular)
    }
    static func hzBoldSystemFont(ofSize: CGFloat) -> UIFont{
        return hzSystemFont(ofSize: ofSize, weight: .bold)
    }
    static func hzSystemFont(ofSize: CGFloat, weight: UIFont.Weight) -> UIFont{
        return hzFont(font: .SFPro(weight: weight, size: ofSize))
    }
    
    static func hzFont(font: hzFont) -> UIFont{
        return font.font
    }
    
    public static func printAllFonts(){
        hzprint("=====> font name:\n")
        for name in familyNames{
            hzprint(name)
        }
    }
}
