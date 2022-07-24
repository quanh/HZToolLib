//
//  ToastProgressView.swift
//  GifEditor
//
//  Created by 刘成 on 2022/6/28.
//

import UIKit

class ToastProgressView: UIButton {

    //零时数据存储
    private var currentProgress :CGFloat = 0
    //设置绘图线宽
    let lineWith :CGFloat = 3.0
    
    var progress : (current: Int,allCount: Int) = (0,1) {
          //willSet观察属性值的变化
          willSet (newValue){
            //获取当前的进度值
              if newValue.current == 0 {
                  currentProgress = 0.5 / CGFloat(newValue.allCount)
              }else{
                  currentProgress = CGFloat(newValue.current) / CGFloat(newValue.allCount)
              }
              self.setNeedsDisplay()
          }
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        layer.cornerRadius = 10.0
        setTitleColor(UIColor.white, for: .normal)
        layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        //设置进度圆显示数字样式
        let str = String(format: "%.0f%%", currentProgress * 100)
        setTitle(str, for: .normal)
        
        let size = rect.size
        let arcCenter = CGPoint(x: size.width*0.5, y: size.height*0.5)
        let radius = min(size.width, size.height)*0.5 - 10
        let startAngle = CGFloat(-CGFloat.pi * 0.5)
        let endAngle = currentProgress*2*CGFloat.pi + startAngle
       
        let excircle = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat.pi * 2, clockwise: true)
        excircle.lineWidth = lineWith
        UIColor.gray.set()
        excircle.lineCapStyle = .round//设置线样式
        excircle.stroke()
        
        // 内圆设置
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = self.lineWith//设置线宽
        path.lineCapStyle = .round
        UIColor.white.set()
        //绘制路径
//        path.addLine(to: arcCenter)
        path.stroke()
    }
}
