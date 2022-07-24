//
//  Toast+Ex.swift
//  HappyPerformance
//
//  Created by Scott_Yu on 2019/6/13.
//  Copyright © 2019 Andy. All rights reserved.
//

import UIKit

class Toast: NSObject {

    static func showMessage(_ message: String?) {
        if message?.isEmpty ?? true { return }
        DispatchQueue.main.async {
			if #available(iOS 13.0, *){
                UIWindow.currentUIWindow()?.makeToast(message, position: .center)
			}else{
                UIWindow.currentUIWindow()?.makeToast(message, position: .center)
			}
            
        }
    }
}

extension UIView{
	func startLoading(){
		DispatchQueue.main.async {
			self.makeToastActivity(.center)
		}
	}
	func endLoading(){
		DispatchQueue.main.async {
			self.hideToastActivity()
		}
	}
}
