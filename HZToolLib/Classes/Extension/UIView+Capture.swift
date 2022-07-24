//
//  UIView+Capture.swift
//  GifEditor
//
//  Created by quanhai on 2022/4/19.
//

import Foundation
import UIKit

var kUIViewCaptureImagesKey = "kCaptureImages"
var kUIViewCaptureTimerKey = "kUIViewCaptureTimer"


extension UIView{
	var captureImages: [UIImage]? {
		get{
			return objc_getAssociatedObject(self, &kUIViewCaptureImagesKey) as? [UIImage]
		}
		set{
			objc_setAssociatedObject(self, &kUIViewCaptureImagesKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
	var captureDisplayTimer: Timer?{
		get{
			return objc_getAssociatedObject(self, &kUIViewCaptureTimerKey) as? Timer
		}
		set{
			objc_setAssociatedObject(self, &kUIViewCaptureTimerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	public func captureImage() -> UIImage?{
		var image: UIImage?
		UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
		if let context = UIGraphicsGetCurrentContext() {
//			context.saveGState()
			layer.presentation()?.render(in: context)
			image = UIGraphicsGetImageFromCurrentImageContext()
//			context.restoreGState()
		}
		UIGraphicsEndImageContext()
		return image
	}
	public func asImage() -> UIImage?{
		let render = UIGraphicsImageRenderer(bounds: bounds)
		return render.image { context in
			drawHierarchy(in: bounds, afterScreenUpdates: true)
		}
	}
	
	
	/// 1s抓取多少次
	/// - Parameter interval: FPS ， 抓取间隔时间 = 1000/FPS （60fps  间隔16.66ms）
	public func startCapture(fps: NSInteger){
		print("capture size: ", bounds)
		guard fps > 0 && fps <= 1000 else { return }
		if let _ = captureDisplayTimer {
			invlidateCaptureDispalyTimer()
		}
		captureImages = []
		let timeInterval = 1000.0/Double(fps)
		captureDisplayTimer = Timer(timeInterval: timeInterval/1000, target: self, selector: #selector(captureImageOnce), userInfo: nil, repeats: true)
		RunLoop.current.add(captureDisplayTimer!, forMode: .common)
		captureDisplayTimer?.fire()
	}
	
	@objc private func captureImageOnce(){
		guard let image = asImage() else {
			return
		}
		var images: [UIImage] = captureImages ?? []
		images.append(image)
		captureImages = images
	}
	private func invlidateCaptureDispalyTimer(){
		captureDisplayTimer?.invalidate()
		captureDisplayTimer = nil
	}
	
	public func endCapture() -> [UIImage]{
		invlidateCaptureDispalyTimer()
		let images = captureImages ?? []
		captureImages = nil // 这里一定要清空缓存， 不然会占用大量内存
		return images
	}
	public func cleanCaptureMemory(){
		invlidateCaptureDispalyTimer()
		captureImages = nil
	}
}
