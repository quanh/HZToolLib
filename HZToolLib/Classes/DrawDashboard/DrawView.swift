//
//  DrawDashboard.swift
//  ImageEditor
//
//  Created by quanhai on 2022/3/15.
//

import Foundation
import UIKit

struct DrawPathData{
    var colors: [String] = drawColors.hexValues
	var colorIndex: Int = 0
	var lineWidth: CGFloat = 10
	var isEraser = false
	var points: [String] = []

	func colorToIndex(_ color: String) -> Int{
		return colors.firstIndex(of: color) ?? 0
	}

	func indexToColor() -> UIColor{
		// TODO: hex -> color
		let color = colors[colorIndex]
		return UIColor(hexString: color)
	}
}
class DrawPath: UIBezierPath{
	var data: DrawPathData = DrawPathData()
}


protocol DrawDashboardDelegate: NSObject{
//	func drawFinished(canRedo: Bool, canUndo: Bool, canClean: Bool)
	func updateStatus(canRedo: Bool, canUndo: Bool, canClean: Bool)
}

/// 绘制画板
class DrawDashboard: UIView{
	// 橡皮擦/笔画粗细
	var lineWidth: CGFloat = 10
	// 笔画颜色
	var lineColor: String = "#FFFFFF"{
		didSet{
			isEraser = false
		}
	}
	// 橡皮擦
	public var isEraser = false
	public var canRedo: Bool{
		return undoPaths.count > 0
	}
	public var canUndo: Bool{
		return paths.count > 0 || tmpPaths.count > 0
	}
	public var canClean: Bool{
		return paths.count > 0
	}
	weak var delegate: DrawDashboardDelegate?
	// 绘制路径
	private var paths: [DrawPath] = []
	// undo路径
	private var undoPaths: [DrawPath] = []
	// 刚执行过clean 才会有数据
	private var tmpPaths: [DrawPath] = []
	
	// 记录边缘
	private var drawTopLeftPoint: CGPoint = .zero
	private var drawBottomRightPoint: CGPoint = .zero
	
	override func layoutSubviews() {
		super.layoutSubviews()
		if drawTopLeftPoint == .zero{
			drawTopLeftPoint = CGPoint(x: bounds.width, y: bounds.height)
		}
	}
	
    public func hasDraw() -> Bool {
        (paths.count > 0) ? true : false
    }
    
	/// 使用路径数据初始化笔画
	/// - Parameter datas: 路径数据
	public func initDrawPathData(_ datas: [DrawPathData], undoDatas: [DrawPathData]){
		for data in datas{
			let path = DrawPath()
			path.data = data
			for (i, pointStr) in data.points.enumerated(){
				let point = NSCoder.cgPoint(for: pointStr)
				if i == 0{
					path.move(to: point)
				}else{
					path.addLine(to: point)
				}
			}
			paths.append(path)
		}
		for data in undoDatas{
			let path = DrawPath()
			path.data = data
			for (i, pointStr) in data.points.enumerated(){
				let point = NSCoder.cgPoint(for: pointStr)
				if i == 0 && datas.count == 0{
					path.move(to: point)
				}else{
					path.addLine(to: point)
				}
			}
			undoPaths.append(path)
		}
		setNeedsDisplay()
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		// 手指开始触摸的位置
		let point = touch.location(in: touch.view)
		drawTopLeftPoint = CGPoint(x: min(point.x, drawTopLeftPoint.x), y: min(point.y, drawTopLeftPoint.y))
		drawBottomRightPoint = CGPoint(x: max(point.x, drawBottomRightPoint.x), y: max(point.y, drawBottomRightPoint.y))
		let path = DrawPath()
		var data = DrawPathData()
		data.isEraser = isEraser
		data.lineWidth = lineWidth
		data.colorIndex = data.colorToIndex(lineColor)
		data.points.append(NSCoder.string(for: point))
		path.data = data
		path.move(to: point)
		paths.append(path)
		delegate?.updateStatus(canRedo: canRedo, canUndo: canUndo, canClean: canClean)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let point = touch.location(in: touch.view)
		drawTopLeftPoint = CGPoint(x: min(point.x, drawTopLeftPoint.x), y: min(point.y, drawTopLeftPoint.y))
		drawBottomRightPoint = CGPoint(x: max(point.x, drawBottomRightPoint.x), y: max(point.y, drawBottomRightPoint.y))
		let prePath = paths.last
		prePath?.data.points.append(NSCoder.string(for: point))
		prePath?.addLine(to: point)
		setNeedsDisplay()
	}
	
	override func draw(_ rect: CGRect) {
		for path in paths{
			path.lineJoinStyle = .round
			path.lineCapStyle = .round
			path.lineWidth = path.data.lineWidth
			if path.data.isEraser{
				path.stroke(with: .destinationIn, alpha: 1)
				backgroundColor?.set()
			}else{
				path.stroke(with: .normal, alpha: 1)
				path.data.indexToColor().set()
			}
			path.stroke()
		}
	}
}
/// 生成图片与保存到相册
extension DrawDashboard{
	public func generateImage() -> UIImage?{
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0)
		guard let context = UIGraphicsGetCurrentContext() else{
			UIGraphicsEndImageContext()
			return nil
		}
		layer.render(in: context)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		let padding: CGFloat = 8
		let x = max(0, drawTopLeftPoint.x - padding)
		let y = max(0, drawTopLeftPoint.y - padding)
		let width = min(drawBottomRightPoint.x - drawTopLeftPoint.x + padding*2, bounds.width)
		let height = min(drawBottomRightPoint.y - drawTopLeftPoint.y + padding*2, bounds.height)
		let rect = CGRect(x: x, y: y, width: width, height: height)
		
		let result = image?.corped(in: rect)
		
		return result
	}
	public func saveToAlbum(){
		guard let image = generateImage() else { return }
		UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavedToPhotosAlbum(image:didFinishSavingWithError:contextInfo:)), nil)
	}
	
	@objc func imageSavedToPhotosAlbum(image: UIImage, didFinishSavingWithError error: Error?, contextInfo: Any){
		if error == nil {
			// success
		}
	}
}
/// 画板事件
extension DrawDashboard{
	public func clean(){
		guard canClean else { return }
		tmpPaths = Array(paths)
		paths = []
		undoPaths = []
		setNeedsDisplay()
		delegate?.updateStatus(canRedo: canRedo, canUndo: canUndo, canClean: canClean)
	}
	public func undo(){
		guard canUndo else { return }
		if tmpPaths.count > 0{
			paths = Array(tmpPaths)
			undoPaths = []
			tmpPaths = []
		}else{
			let path = paths.removeLast()
			undoPaths.append(path)
		}
		setNeedsDisplay()
		delegate?.updateStatus(canRedo: canRedo, canUndo: canUndo, canClean: canClean)
	}
	public func redo(){
		guard canRedo else { return }
		let path = undoPaths.removeLast()
		paths.append(path)
		setNeedsDisplay()
		delegate?.updateStatus(canRedo: canRedo, canUndo: canUndo, canClean: canClean)
	}
}
