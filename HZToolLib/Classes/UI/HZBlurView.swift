//
//  HZBlurView.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation
import UIKit

enum HZBlurType{
    case none
    case defaultLight
    case defaultDark
    /// style , alpha
    case custom(UIBlurEffect.Style?, CGFloat?)
    
    var alpha: CGFloat{
        switch self {
        case .none:
            return 0
        case .defaultLight:
            return 0.95
        case .defaultDark:
            return 0.9
        case .custom( _, let cGFloat):
            return cGFloat ?? 1
        }
    }
    var style: UIBlurEffect.Style{
        switch self {
        case .none:
            return .extraLight
        case .defaultLight:
            return .extraLight
        case .defaultDark:
            if #available(iOS 13.0, *) {
                return .systemMaterialDark
            } else {
                // Fallback on earlier versions
                return .dark
            }
        case .custom( let style, _):
            return style ?? .extraLight
        }
    }
}

// TODO: -


protocol HZBlurProtocol{
    var blurType: HZBlurType?{ get set }
    var blurView: UIVisualEffectView?{ get set }
    
    func makeBlurEffect()
}

var kHZBlurTypeKey = "HZBlurTypeKey"
var kHZBlurViewKey = "HZBlurViewKey"

extension HZBlurProtocol where Self: UIView{
    var blurType: HZBlurType?{
        get{
            return objc_getAssociatedObject(self, &kHZBlurTypeKey) as? HZBlurType
        }
        set{
            objc_setAssociatedObject(self, &kHZBlurTypeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            setNeedsLayout()
        }
    }
    var blurView: UIVisualEffectView?{
        get{
            return objc_getAssociatedObject(self, &kHZBlurViewKey) as? UIVisualEffectView
        }
        set{
            objc_setAssociatedObject(self, &kHZBlurViewKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func makeBlurEffect(){
        guard let type = blurType else{
            cleanBlurEffect()
            return
        }
        
        if case .none = type{
            cleanBlurEffect()
            return
        }
        if blurView == nil{
            blurView = UIVisualEffectView()
            insertSubview(blurView!, at: 0)
        }
        
        blurView?.frame = bounds
        blurView?.layer.cornerRadius = layer.cornerRadius
        blurView?.layer.maskedCorners = layer.maskedCorners
        blurView?.layer.masksToBounds = layer.masksToBounds
        blurView?.clipsToBounds = clipsToBounds
        blurView?.alpha = type.alpha
        blurView?.effect = {
            let effect = UIBlurEffect(style: type.style)
            return effect
        }()
    }
    private func cleanBlurEffect(){
        blurView?.effect = nil
        blurView?.removeFromSuperview()
    }
}


// MARK: - Blur
class HZBlurView: UIView, HZBlurProtocol{
    override func layoutSubviews() {
        super.layoutSubviews()
        makeBlurEffect()
    }
}
class HZBlurImageView: UIImageView, HZBlurProtocol{
    override func layoutSubviews() {
        super.layoutSubviews()
        makeBlurEffect()
    }
}
class HZBlurButton: UIButton, HZBlurProtocol{
    override func layoutSubviews() {
        super.layoutSubviews()
        makeBlurEffect()
    }
}
class HZBlurLabel: UILabel, HZBlurProtocol{
    override func layoutSubviews() {
        super.layoutSubviews()
        makeBlurEffect()
    }
}
