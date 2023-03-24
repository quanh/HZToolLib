//
//  Extension+UIImage.swift
//  GifEditor
//
//  Created by quanhai on 2022/3/17.
//

import Foundation
import UIKit
import ImageIO

extension UIImage {
    
    func addWaterMark(_ logo: UIImage) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        logo.draw(in: CGRect(x: size.width - 40 - 10, y: size.height - 40 - 10, width: 40, height: 40))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
    func addWaterMark(_ text: String) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        self.draw(in: rect)
        
        let attributes = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20),
                                  NSAttributedString.Key.foregroundColor : UIColor .white]
        let string = text as NSString
        let height = UIFont.systemFont(ofSize: 20).lineHeight
        string.draw(in: CGRect(x: size.width - 60, y: size.height - height - 5, width: 50, height: height), withAttributes: attributes)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
    static func createImage(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
	func scaleImage(scaleSize:CGFloat) -> UIImage {
		let reSize = CGSize(width: self.size.width * scaleSize, height: self.size.height * scaleSize)
		return reSizeImage(reSize: reSize)
	}
	func reSizeImage(reSize:CGSize) -> UIImage {
		UIGraphicsBeginImageContextWithOptions(reSize,false, UIScreen.main.scale)
		self.draw(in: CGRect(x: 0, y: 0, width: reSize.width, height: reSize.height))
		guard let reSizeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() else { return self }
		UIGraphicsEndImageContext()
		return reSizeImage
	}
	
	func resize(toKB sizeKB: CGFloat) -> UIImage{
		guard let data = self.pngData() else { return self }
		var dataBytes: CGFloat = CGFloat(data.count)/1000.0
		var scale = 0.9
		var resultImage: UIImage = self
		while dataBytes > sizeKB && scale > 0.1{
			scale = scale - 0.1
			resultImage = scaleImage(scaleSize: scale)
			if let resizeData = resultImage.pngData() {
				dataBytes = CGFloat(resizeData.count)/1000.0
			}else{
				break
			}
			if dataBytes <= sizeKB || scale <= 0.1{
				break
			}
		}
		return resultImage
	}
	
	func compress(toKB sizeKB: CGFloat) -> Data?{
		guard var data = self.jpegData(compressionQuality: 1) else { return nil }
		var dataBytes: CGFloat = CGFloat(data.count)/(1024.0 * 8)
        var maxQuality: CGFloat = 0.9
        let minQuality: CGFloat = 0.001
        var quality: CGFloat = 0
		
        while dataBytes > sizeKB  && quality > 0.0019{
			quality = (maxQuality + minQuality)/2
			data = self.jpegData(compressionQuality: quality)!
			dataBytes = CGFloat(data.count)/(1024.0 * 8)
            maxQuality = quality
		}
        
        if dataBytes <= sizeKB{
            return data
        }
        
        let targetSize = CGSize(width: size.width*0.95, height: size.height*0.95)
        guard let resizeImage = UIImage(data: data)?.resized(to: targetSize) else{
            return data
        }
        return resizeImage.compress(toKB: sizeKB)
	}
	
	func corped(in rect: CGRect) -> UIImage?{
		if rect.size == .zero{
			return nil
		}
		let x = rect.origin.x * scale
		let y = rect.origin.y * scale
		let width = rect.size.width * scale
		let height = rect.size.height * scale
		let targetRect = CGRect(x: x, y: y, width: width, height: height)
		guard let cImage = cgImage, let imageRef = cImage.cropping(to: targetRect) else{
			return nil
		}
		
		let image = UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
		return image
	}
    
    // 使图片渲染到指定大小范围， 图片需要剪切的范围（比例均衡）
    func targetRect(_ renderSize: CGSize) -> CGRect{
        if renderSize == .zero{
            return CGRect(x: 0, y: 0, width: size.width, height: size.height)
        }
        let widthRatio = size.width/renderSize.width
        let heightRatio = size.height/renderSize.height
        var targetSize: CGSize = size
        if widthRatio > heightRatio{
            // 以高为基准
            let width = size.height * (renderSize.width/renderSize.height)
            targetSize = CGSize(width: width, height: size.height)
        }else{
            // 以宽为基准
            let height = size.width * (renderSize.height/renderSize.width)
            targetSize = CGSize(width: size.width, height: height)
        }
        let x = (size.width - targetSize.width)/2
        let y = (size.height - targetSize.height)/2
        return CGRect(x: x, y: y, width: targetSize.width, height: targetSize.height)
    }
	
	/** 切中间的正方形区域 */
	func corpSquareRect() -> UIImage?{
		let originSize = size

		var corpRect: CGRect = .zero
		if originSize.width > originSize.height{
			let offsetX = (originSize.width - originSize.height)/2
			corpRect = CGRect(x: offsetX, y: 0, width: originSize.height, height: originSize.height)
		}else{
			let offsetY = (originSize.height - originSize.width)/2
			corpRect = CGRect(x: 0, y: offsetY, width: originSize.width, height: originSize.width)
		}
		
		return corped(in: corpRect)
	}
	
	/** resize 成正方形， 如果小于约定大小， 则不压缩了 */
	func resizeSuqare(_ estimateWidthHeight: CGFloat = 250) -> UIImage?{
		if estimateWidthHeight <= 0{
			return nil
		}
		guard let image = corpSquareRect() else {
			return nil
		}
		if image.size.width <= estimateWidthHeight{
			return image
		}
		
		return image.resized(to: CGSize(width: estimateWidthHeight, height: estimateWidthHeight))
	}
}

extension UIImage{
    func flip() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(self.size, false, UIScreen.main.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.scaleBy(x: -1, y: 1)
        ctx?.translateBy(x: -self.size.width, y: 0)
        self.draw(in: CGRect(origin: .zero, size: self.size))
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    func roundedCorners(radius: CGFloat? = nil, corners: UIRectCorner = .allCorners) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).addClip()
        draw(in: rect)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    static func gradientImage(_ type: HZGradientType?, estimateSize: CGSize = CGSize(width: 1, height: 1)) -> UIImage?{
        guard let type = type else{
            return nil
        }
        
        var hzColors: [UIColor]?
        var hzLocations: [CGFloat]?
        var startPoint: CGPoint = .zero
        var endPoint: CGPoint = .zero
        
        switch type {
        case .topToBottom(let colors, let locations):
            hzColors = colors
            hzLocations = locations
            startPoint = CGPoint(x: 0.5, y: 0)
            endPoint = CGPoint(x: 0.5, y: 1)
        case .leftToRight(let colors, let locations):
            hzColors = colors
            hzLocations = locations
            startPoint = CGPoint(x: 0, y: 0.5)
            endPoint = CGPoint(x: 1, y: 0.5)
        case .topLeftToBottomRight(let colors, let locations):
            hzColors = colors
            hzLocations = locations
            startPoint = CGPoint(x: 0, y: 0)
            endPoint = CGPoint(x: 1, y: 1)
        case .bottomLeftToTopRight(let colors, let locations):
            hzColors = colors
            hzLocations = locations
            startPoint = CGPoint(x: 0, y: 1)
            endPoint = CGPoint(x: 1, y: 0)
        case .custom(let colors, let locations, let sPoint, let ePoint):
            hzColors = colors
            hzLocations = locations
            startPoint = sPoint
            endPoint = ePoint
        }
        
        let colors = hzColors?.map({ return $0.cgColor }) ?? []
        if hzLocations?.count ?? 0 == 0{
            hzLocations = [0, 1]
        }
        
        let layer = CAGradientLayer()
        layer.frame = CGRect(x: 0, y: 0, width: estimateSize.width, height: estimateSize.height)
        layer.colors = colors
        layer.locations = hzLocations?.map({ return NSNumber(value: $0) })
        layer.startPoint = startPoint
        layer.endPoint = endPoint
        
        
        UIGraphicsBeginImageContextWithOptions(estimateSize, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}


enum HZGradientType{
    case leftToRight(colors: [UIColor]?, locations: [CGFloat]?)
    case topToBottom(colors: [UIColor]?, locations: [CGFloat]?)
    case topLeftToBottomRight(colors: [UIColor]?, locations: [CGFloat]?)
    case bottomLeftToTopRight(colors: [UIColor]?, locations: [CGFloat]?)
    case custom(colors: [UIColor]?, locations: [CGFloat]?, startPoint: CGPoint, endPoint: CGPoint)
}
