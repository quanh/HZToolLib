//
//  BaseViewController.swift
//  GifEditor
//
//  Created by chunyu on 2022/3/26.
//

import UIKit

open class BaseViewController: UIViewController {

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return AppConfig.shared.statusBarStyle
	}
	
    open override func loadView() {
        super.loadView()
        /// 替换原生导航栏
        swizzled_loadView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
             
        view.backgroundColor = .white
        setupNavigation()
    }
  
    public func setupNavigation() {
        nav.navigationBar.shadowColor = AppConfig.shared.defaultNavShadowColor
        nav.navigationBar.backgroundColor = AppConfig.shared.defaultNavBarColor
        nav.navigationBar.titleAttribute = AppConfig.shared.defaultNavFontAttribute
        if (navigationController?.viewControllers.count ?? 0) > 1 {
            setBackItem()
        }
    }
    
    public func setBackItem() {
        nav.navigationBar.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: AppConfig.shared.navLeftImageName), style: .plain, target: self, action: #selector(didBackClick))
    }
    
    @objc public  func didBackClick() {
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
            return
        }
        navigationController?.popViewController(animated: true)
    }

    open override var modalPresentationStyle: UIModalPresentationStyle {
        set { }
        get {
            return .fullScreen
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

	open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return AppConfig.shared.supportOrientations
	}
}
