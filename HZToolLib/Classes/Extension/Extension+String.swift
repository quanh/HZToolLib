//
//  Extension+String.swift
//  GifEditor
//
//  Created by quanhai on 2022/3/17.
//

import Foundation
import UIKit

extension String {
	var localized: String {
		return NSLocalizedString(self, comment: self)
	}
	// MARK: 字符串转字典
   func stringValueDic(_ str: String) -> [String : Any]?{
		let data = str.data(using: String.Encoding.utf8)
		if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
			return dict
		}
		return nil
	}
	// MARK: 字符串转字典
	func toDic() -> [String : Any]?{
		 let data = self.data(using: String.Encoding.utf8)
		 if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
			 return dict
		 }
		 return nil
	 }
	
	func rectWithFont(size: CGSize, font: UIFont) -> CGRect {
		return self.boundingRect(with: size, options:.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context:nil)
	}
}
