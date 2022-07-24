//
//  UIViewController+NavigationBar.swift
//  NB
//
//  Created by on 2019/3/1.
//  Copyright © 2019 yy. All rights reserved.
//

import Foundation
import UIKit

private var NavigationBarKey: Void?
extension UIViewController {
    fileprivate var bk_NavigationBar : NavigationBar{
        set{
            objc_setAssociatedObject(self, &NavigationBarKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
        get{
            if let bar = objc_getAssociatedObject(self, &NavigationBarKey) as? NavigationBar{
                return bar
            }else{
                let bar = NavigationBar()
                objc_setAssociatedObject(self, &NavigationBarKey, bar, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return bar
            }
        }
    }
    
    /// 方法交换
    func swizzled_loadView() {
        if let nav = self.navigationController,nav._navigationBarEnable{
            let originView = self.view ?? UIView()
            let bound = self.view.bounds
            let container = Container.init(bar: self.bk_NavigationBar, originView: originView,frame:bound,viewController:self)
            self.view = container
        }
    }
    
}


public extension NBWrapper where Base: UIViewController{
    var originView : UIView?{
        if let v = self.base.view as? Container{
            return v.originView
        }
        return self.base.view
    }
    var containerView : UIView{
        return self.base.view
    }
    var navigationBar : NavigationBar{
        return base.bk_NavigationBar
    }
    var navigationBarHeight : CGFloat{
        return UIWindow.statusNavBarHeight()
    }
}

private var NavigationBarEnableKey: Void?
extension UINavigationController{
    fileprivate var _navigationBarEnable : Bool{
        set{
            objc_setAssociatedObject(self, &NavigationBarEnableKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
        get{
            return (objc_getAssociatedObject(self, &NavigationBarEnableKey) as? Bool) ?? false
        }
    }
}

public extension NBWrapper where Base : UINavigationController{
    var navigationBarEnable : Bool{
        set{
            self.base.isNavigationBarHidden = newValue
            self.base._navigationBarEnable = newValue
        }
        get{
            return self.base._navigationBarEnable
        }
    }
}
