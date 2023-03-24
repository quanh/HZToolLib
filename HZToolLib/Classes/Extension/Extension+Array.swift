//
//  Extension+Array.swift
//  GifEditor
//
//  Created by chunyu on 2022/3/28.
//

import Foundation

extension Array where Element: Equatable {
    // 去重
    func removeDuplicate() -> Array {
        return self.enumerated().filter { (index, value) -> Bool in
            return self.firstIndex(of: value) == index
        }.map { (_, value) in
            return value
        }
    }
    
	
}

extension Collection{
	func serializationToString() -> String?{
		if (!JSONSerialization.isValidJSONObject(self)){
			hzprint("无法解析")
			return nil
		}
		if let data = try? JSONSerialization.data(withJSONObject: self, options: []){
			let jsonString = String(data: data, encoding: String.Encoding.utf8)
			return jsonString
		}
		return nil
	}
}
