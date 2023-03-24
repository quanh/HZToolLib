//
//  UIView+Line.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation
import UIKit

enum UIViewLineDirection{
    case horizental
    case vertical
}

extension UIView{
    //MARK:- 绘制虚线
    
    /// 绘制虚线
    /// - Parameters:
    ///   - strokeColor: 线条颜色
    ///   - lineWidth: 线条宽度
    ///   - lineLength: 线条长度
    ///   - lineSpacing: 线条间隔
    func drawDashLine(direction: UIViewLineDirection = .horizental, strokeColor: UIColor, lineWidth: CGFloat = 1, lineLength: Int = 10, lineSpacing: Int = 5) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPhase = 0
        //每一段虚线长度 和 每两段虚线之间的间隔
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength), NSNumber(value: lineSpacing)]
        let path = CGMutablePath()
        switch direction {
        case .horizental:
            path.move(to: CGPoint(x: 0, y: (layer.bounds.height-lineWidth)/2))
            path.addLine(to: CGPoint(x: layer.bounds.width, y: (bounds.height-lineWidth)/2))
        case .vertical:
            path.move(to: CGPoint(x: (layer.bounds.width-lineWidth)/2, y: 0))
            path.addLine(to: CGPoint(x: (layer.bounds.height-lineWidth)/2, y: layer.bounds.height))
        }
        
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}


class HZLineView: UIView{
    public var direction: UIViewLineDirection = .horizental{
        didSet{
            setNeedsDisplay()
        }
    }
    
    public var leading: CGFloat = 0
    public var trailing: CGFloat = 0
    public var lineWidth: CGFloat = 1
    /// > 0 画虚直线， = 0 画实直线
    public var lineSpacing: CGFloat = 0
    public var lineLength: CGFloat = 5
    public var lineColor: UIColor? = .black
    public var lineStyle: CAShapeLayerLineJoin = .bevel
    
    /// 绘制虚直线
    public static func dashline(direction: UIViewLineDirection = .horizental, leading: CGFloat = 0, trailing: CGFloat = 0, lineWidth: CGFloat = 1, lineSpacing: CGFloat = 4, lineLength: CGFloat = 8, lineColor: UIColor? = .black, lineStyle: CAShapeLayerLineJoin = .bevel) -> HZLineView{
        let dashLine = HZLineView()
        dashLine.direction = direction
        dashLine.leading = leading
        dashLine.trailing = trailing
        dashLine.lineWidth = lineWidth
        dashLine.lineSpacing = lineSpacing
        dashLine.lineLength = lineLength
        dashLine.lineColor = lineColor
        dashLine.lineStyle = lineStyle
        return dashLine
    }
    /// 绘制实直线
    public static func line(direction: UIViewLineDirection = .horizental,leading: CGFloat = 0, trailing: CGFloat = 0, lineWidth: CGFloat = 1, lineColor: UIColor? = .black, lineStyle: CAShapeLayerLineJoin = .bevel) -> HZLineView{
        let dashLine = HZLineView()
        dashLine.direction = direction
        dashLine.leading = leading
        dashLine.trailing = trailing
        dashLine.lineWidth = lineWidth
        dashLine.lineColor = lineColor
        dashLine.lineStyle = lineStyle
        return dashLine
    }
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.setLineWidth(lineWidth)
        context?.setStrokeColor(lineColor?.cgColor ?? UIColor.black.cgColor)
        let lengths = [max(0, lineLength), max(0, lineSpacing)]
        context?.setLineDash(phase: 0, lengths: lengths)
        switch direction {
        case .horizental:
            context?.move(to: CGPoint(x: leading, y: rect.size.height/2 - lineWidth/2))
            context?.addLine(to: CGPoint(x: rect.size.width - trailing, y: rect.size.height/2 - lineWidth/2))
        case .vertical:
            context?.move(to: CGPoint(x: rect.size.width/2 - lineWidth/2, y: leading))
            context?.addLine(to: CGPoint(x: rect.size.width/2 - lineWidth/2, y: rect.size.height - trailing))
        }
        context?.strokePath()
        context?.closePath()
    }
}

