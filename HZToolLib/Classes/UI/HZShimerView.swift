//
//  HZShimerView.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation
import UIKit


class HZShimmerView: UIView{
    lazy private var colorLayer: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.frame = bounds
        layer.startPoint = CGPoint(x: -0.5, y: 0.5)
        layer.endPoint = CGPoint(x: 1.5, y: 0.5)
        layer.colors = colors
        layer.locations = [-1, -0.5, 0]
        return layer
    }()
    lazy private var colorMaskLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.red.cgColor
        return layer
    }()
    
    private var duration: Double = 1.5
    private var colors: [CGColor] = [
        UIColor(rgb: 0x083A3A, alpha: 0).cgColor,
        UIColor(rgb: 0x083A3A, alpha: 0.05).cgColor,
        UIColor(rgb: 0x083A3A, alpha: 0).cgColor
    ]
    
    public static func addShimmerAnimationTo(_ view: UIView){
        let coverView = HZShimmerView(frame: view.bounds)
        coverView.showAnimationOn(view)
    }
    
    /// 为布局后（ frame 已确定）的视图添加动画
    ///  确保子视图设置了正确的cornerRadius 、frame已确定
    public func showAnimation(with colors: [CGColor]? = nil, duration: Double = 1.5, path: UIBezierPath){
        if let colors, colors.count > 0{
            self.colors = colors
        }
        self.duration = duration
        
        layer.addSublayer(colorLayer)
        addMaskPath(path)
        addAnimation()
    }
    
    public func showAnimationOn(_ view: UIView, path: UIBezierPath? = nil){
        backgroundColor = view.backgroundColor
        showAnimation(path: path ?? view.genSubViewPaths())
        view.addSubview(self)
    }
    
    private func addMaskPath(_ path: UIBezierPath){
        colorMaskLayer.path = path.cgPath
        colorLayer.mask = colorMaskLayer
    }
    
    private func addAnimation(){
        let animation = locationAnimation()
        colorLayer.add(animation, forKey: "gradient-color-location-animation")
    }
    
    private func locationAnimation() -> CAAnimation{
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = colorLayer.locations
        animation.toValue = [1, 1.5, 2]
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.repeatCount = Float.greatestFiniteMagnitude
        animation.isRemovedOnCompletion = false
        return animation
    }
}


extension UIView{
    func genSubViewPaths() -> UIBezierPath{
        let path = UIBezierPath()
        for subview in subviews{
            let subPath = UIBezierPath(roundedRect: subview.frame, cornerRadius: subview.layer.cornerRadius)
            path.append(subPath)
        }
        return path
    }
    
    func showShimmer(){
        HZShimmerView.addShimmerAnimationTo(self)
    }
}
