//
//  BaseNavigationController.swift
//  GifEditor
//
//  Created by chunyu on 2022/3/26.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        nav.navigationBarEnable = true
        
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        isNavigationBarHidden = true
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        interactivePopGestureRecognizer?.isEnabled = viewControllers.count > 0
        viewController.hidesBottomBarWhenPushed = viewControllers.count >= 1
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        // 解决iOS 14 popToRootViewController tabbar不自动显示问题
        if animated {
            let popController = viewControllers.last
            popController?.hidesBottomBarWhenPushed = false
        }
        return super.popToRootViewController(animated: animated)
    }
}


class OBFullGestureNavigationController: BaseNavigationController {
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        object_setClass(interactivePopGestureRecognizer!.self, UIPanGestureRecognizer.self)
    }
}


extension BaseNavigationController: UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
        }

        if navigationController.viewControllers.count == 1 {
            navigationController.interactivePopGestureRecognizer?.isEnabled = false
            navigationController.interactivePopGestureRecognizer?.delegate = nil
        }
    }
}
