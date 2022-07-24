//
//  SwiftClass.swift
//  GifEditor
//
//  Created by quanhai on 2022/5/2.
//

import Foundation
import UIKit


extension String{
		
	public func controllerInstance() -> UIViewController?{
		guard let bundleName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String,
		let controllerClass = NSClassFromString(bundleName + "." + self) as? UIViewController.Type else {
				return nil
			}

		let controller = controllerClass.init()
		return controller
	}
}
