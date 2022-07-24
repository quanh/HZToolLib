//
//  UIWindow+Screen.swift
//  SwiftLearning
//
//  Created by 权海 on 2022/7/24.
//

import Foundation

extension UIWindow {
    /* 当前展示的window scene */
    @available(iOS 13.0, *)
    static func currentWindowScene() -> UIWindowScene?{
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter({
                $0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
        return connectedScenes.first
    }
    
    /* 当前展示的window */
    static func currentUIWindow() -> UIWindow? {
        if #available(iOS 13.0, *){
            let window = currentWindowScene()?
                .windows
                .first { $0.isKeyWindow }

            return window
        }else{
            return UIApplication.shared.windows.first
        }
    }
    
    /* 状态栏 */
    static func statusBarHeight() -> CGFloat {
        guard let window = currentUIWindow() else {
            return 20
        }
        if #available(iOS 13.0, *){
            return window.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
        }else{
            return UIApplication.shared.statusBarFrame.height
        }
    }
    
    /* 导航栏 */
    static let navBarHeight: CGFloat = 44
    /* 状态栏 + 导航栏 */
    static func statusNavBarHeight() -> CGFloat{
        return statusBarHeight() + navBarHeight
    }
    /* 底部安全区域 */
    static func safeAreaBottomHeight() -> CGFloat {
        guard let window = currentUIWindow() else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }
    /* tabbar + 安全区域 */
    static func tabbarHeight() -> CGFloat{
        let tabbarH: CGFloat = 49
        guard let window = currentUIWindow() else {
            return tabbarH
        }
        return window.safeAreaInsets.bottom + tabbarH
    }
    
    /// 是否是刘海屏（notch screen）
    static let hasNotch: Bool = {
        var window: UIWindow? = UIWindow.currentUIWindow()

        guard let unwrapedWindow = window else{
            return false
        }
        if unwrapedWindow.safeAreaInsets.left > 0 || unwrapedWindow.safeAreaInsets.bottom > 0 {
            return true
        }
       return false
    }()
}
