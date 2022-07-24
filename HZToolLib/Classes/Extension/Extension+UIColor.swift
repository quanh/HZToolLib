//
//  Extension+UIColor.swift
//  GifEditor
//
//  Created by quanhai on 2022/3/17.
//

import Foundation
import UIKit



extension UIColor{
	class func color(rgb: __uint32_t) -> UIColor{
		return UIColor(red: CGFloat(((rgb & 0xFF0000) >> 16))/255.0,
					   green: CGFloat(((rgb & 0xFF00) >> 8))/255.0,
					   blue: CGFloat((rgb & 0xFF))/255.0,
					   alpha: 1)
	}
	class func color(rgb: __uint32_t, alpha: CGFloat) -> UIColor{
		return UIColor(red: CGFloat(((rgb & 0xFF0000) >> 16))/255.0,
		green: CGFloat(((rgb & 0xFF00) >> 8))/255.0,
		blue: CGFloat((rgb & 0xFF))/255.0,
		alpha: alpha)
	}
	
	class func color(rgba: __uint32_t) -> UIColor{
		return UIColor(red: CGFloat(((rgba & 0xFF000000) >> 24))/255.0,
		green: CGFloat(((rgba & 0xFF0000) >> 16))/255.0,
		blue: CGFloat(((rgba & 0xFF00) >> 8))/255.0,
		alpha: CGFloat((rgba & 0xFF))/255.0)
	}
	
	convenience init(rgb: __uint32_t) {
		self.init(red: CGFloat(((rgb & 0xFF0000) >> 16))/255.0,
				  green: CGFloat(((rgb & 0xFF00) >> 8))/255.0,
				  blue: CGFloat((rgb & 0xFF))/255.0,
				  alpha: 1)
	}
	convenience init(rgb: __uint32_t, alpha: CGFloat) {
		self.init(red: CGFloat(((rgb & 0xFF0000) >> 16))/255.0,
				  green: CGFloat(((rgb & 0xFF00) >> 8))/255.0,
				  blue: CGFloat((rgb & 0xFF))/255.0,
				  alpha: alpha)
	}
	
	convenience init(rgba: __uint32_t) {
		self.init(red: CGFloat(((rgba & 0xFF000000) >> 24))/255.0,
				  green: CGFloat(((rgba & 0xFF0000) >> 16))/255.0,
				  blue: CGFloat((rgba & 0xFF00) >> 8)/255.0,
				  alpha: CGFloat((rgba & 0xFF))/255.0)
	}
	
	convenience init(hexString: String, alpha: CGFloat = 1.0) {
		let hexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
		let scanner = Scanner(string: hexString)
		 
		if hexString.hasPrefix("#") {
            if #available(iOS 13.0, *){
                scanner.currentIndex = scanner.string.index(after: scanner.string.startIndex)
            }else{
                scanner.scanLocation = 1
            }
		}
		 
		var color: UInt32 = 0
        if #available(iOS 13.0, *){
            color = UInt32(scanner.scanInt32() ?? 0)
        }else{
            scanner.scanHexInt32(&color)
        }
		 
		let mask = 0x000000FF
		let r = Int(color >> 16) & mask
		let g = Int(color >> 8) & mask
		let b = Int(color) & mask
		 
		let red   = CGFloat(r) / 255.0
		let green = CGFloat(g) / 255.0
		let blue  = CGFloat(b) / 255.0
		 
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
	
		var hz_red: CGFloat {
			var r: CGFloat = 0
			getRed(&r, green: nil, blue: nil, alpha: nil)
			return r
		}
		var hz_green: CGFloat {
			var g: CGFloat = 0
			getRed(nil, green: &g, blue: nil, alpha: nil)
			return g
		}
		var hz_blue: CGFloat {
			var b: CGFloat = 0
			getRed(nil, green: nil, blue: &b, alpha: nil)
			return b
		}
		var hz_alpha: CGFloat {
			return cgColor.alpha
		}
}
