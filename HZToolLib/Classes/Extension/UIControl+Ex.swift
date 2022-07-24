//
//  UIControl+Ex.swift
//  GifEditor
//
//  Created by chunyu on 2022/3/28.
//

import UIKit

private var edgeKey = "touchEdgeKey"

// 扩大点击区域
extension UIControl {
    
    private var touch_insets: UIEdgeInsets? {
        get {
            if let temp = objc_getAssociatedObject(self, &edgeKey) as? UIEdgeInsets  {
                return temp
            }
            return nil
        }
        set {
            objc_setAssociatedObject(self, &edgeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard !self.isHidden && self.alpha != 0 else {
            return false
        }
        
        let rect = self.enlargeRect()
        
        if rect.equalTo(self.bounds) {
            return super.point(inside: point, with: event)
        }
        return rect.contains(point) ? true : false
    }
    
    private func enlargeRect() -> CGRect {
        guard let edge = self.touch_insets else {
            return self.bounds
        }
        
        let rect = CGRect(x: self.bounds.minX - edge.left, y: self.bounds.minY - edge.top, width: self.bounds.width + edge.left + edge.right, height: self.bounds.height + edge.top + edge.bottom)
        
        return rect
    }
    
    func enlargeValidTouchArea(insets: UIEdgeInsets) {
        self.touch_insets = insets
    }
    
    func enlargeValidTouchArea(inset: CGFloat) {
        guard inset != 0 else {
            return
        }
        self.touch_insets = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
}
