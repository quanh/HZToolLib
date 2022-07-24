//
//  CacheHandler.swift
//  GifEditor
//
//  Created by quanhai on 2022/5/2.
//

import Foundation

class CacheHandler: NSObject {
	
	static func getCache() -> String {
		let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
		
		// 取出文件夹下所有文件数组
		let fileArr = FileManager.default.subpaths(atPath: cachePath!)
		
		//快速枚举出所有文件名 计算文件大小
		var size = 0
		for file in fileArr! {
			
			// 把文件名拼接到路径中
			let path = cachePath! + ("/\(file)")
			// 取出文件属性
			let floder = try! FileManager.default.attributesOfItem(atPath: path)
			// 用元组取出文件大小属性
			for (key, fileSize) in floder {
				// 累加文件大小
				if key == FileAttributeKey.size {
					size += (fileSize as AnyObject).integerValue
				}
			}
		}
		
		let totalCache = Double(size) / 1024.00 / 1024.00
		return String(format: "%.2fMB", totalCache)
	}
	
	static func daleteCache() {

		let cachePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
		let fileArr = FileManager.default.subpaths(atPath: cachePath!)
		for file in fileArr! {

			let path = (cachePath! as NSString).appending("/\(file)")

			if FileManager.default.fileExists(atPath: path) {

				do {

					try FileManager.default.removeItem(atPath: path)

				} catch {

				}

			}

		}
	}
}
