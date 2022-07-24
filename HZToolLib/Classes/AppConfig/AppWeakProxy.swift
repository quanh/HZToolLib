//
//  AppWeakProxy.swift
//  GifEditor
//
//  Created by chunyu on 2022/3/28.
//

import UIKit

// 引入中间对象，防止循环引用
class AppWeakProxy: NSObject {

    private weak var target: NSObjectProtocol?
    
    init(target: NSObjectProtocol) {
        self.target = target
        super.init()
    }
    
    class func proxy(withTarget target: NSObjectProtocol) -> AppWeakProxy {
        return AppWeakProxy(target: target)
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        return target?.responds(to: aSelector) ?? false
    }
    
}

