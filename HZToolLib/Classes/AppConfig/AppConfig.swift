//
//  AppConfig.swift
//  OnlyBrain
//
//  Created by yc on 2021/3/11.
//

import UIKit
import AdSupport

final class AppConfig {
    static let shared = AppConfig()
    
    public var navLeftImageName: String = "arrow-left"
    public var statusBarStyle: UIStatusBarStyle = .lightContent
    public var defaultNavBarColor: UIColor = .white
    public var defaultNavFontAttribute: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 16, weight: .medium)]
    public var defaultNavShadowColor: UIColor? = nil
    
    public var supportOrientations: UIInterfaceOrientationMask = [.portrait]

    
//MARK: -
    
    ///渠道名称
    static let channelName: String = {
        #if DEBUG
        return "test"
        #else
        return "App_store"
        #endif
    }()
    
    
    static let appName: String = appInfo(of: "CFBundleDisplayName")
        
    static let appVersion: String = "v\(appInfo(of: "CFBundleShortVersionString"))"

    static let version: String = appInfo(of: "CFBundleShortVersionString")

    static let appBuildVersion: String = appInfo(of: "CFBundleVersion")

    static let bundleIdentifier: String = Bundle.main.bundleIdentifier ?? ""

    static let deviceName: String = UIDevice.current.name

    static let deviceType: String = UIDevice.current.model

    static let deviceIDFA: String = {
        return ASIdentifierManager.shared().advertisingIdentifier.uuidString
    }()
    
    static let deviceSystemName: String = {
        return UIDevice.current.systemName
    }()

    static let deviceSystemVersion: String = {
        return UIDevice.current.systemVersion
    }()
    
    class func appInfo(of keyName: String) -> String {
        return Bundle.main.object(forInfoDictionaryKey: keyName) as? String ?? ""
    }
    
    class func openSettings()  {
        guard let URL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(URL) {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
    }
    
}
