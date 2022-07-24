//
//  DrawViewController.swift
//  ImageEditor
//
//  Created by quanhai on 2022/3/15.
//

import Foundation
import UIKit
import SnapKit
//import YYImage

extension UIApplication{
	@available(iOS 13.0, *)
	func currentSence() -> UIWindowScene?{
		let sences = connectedScenes.filter({$0.activationState == .foregroundActive}).map({$0 as? UIWindowScene}).compactMap({$0})
		return sences.first
	}
	func safeAreaInset() -> UIEdgeInsets{
		if #available(iOS 15.0, *){
			return UIApplication.shared.currentSence()?.keyWindow?.safeAreaInsets ?? .zero
		}else{
			return UIApplication.shared.windows.first?.safeAreaInsets ?? .zero
		}
	}
}


class DrawViewController: BaseViewController{
    lazy private var emptyBackgroundView: UIImageView = {
        let imageView = UIImageView()
        if let image = UIImage(named: "transparent"){
            imageView.backgroundColor = UIColor(patternImage: image)
        }
        return imageView
    }()
	private var dashboard = DrawDashboard()
	private var toolBarView = DrawToolBarView()

    public var addDrawBlock: ((UIImage?) -> Void)?
    
	private var topBarHeight: CGFloat{
		return UIApplication.shared.safeAreaInset().top
	}
	private var bottomBarHeight: CGFloat{
		return DrawToolBarView.controlAreaHeight + UIApplication.shared.safeAreaInset().bottom
	}
	private var toolBarHeight: CGFloat{
		return DrawToolBarView.controlAreaHeight + DrawToolBarView.toolBarHeight
	}
	lazy private var exportButton: UIButton = {
		let button = UIButton(frame: CGRect(x: 0, y: 0, width: 55, height: 24))
		button.titleLabel?.font = .systemFont(ofSize: 14)
        button.backgroundColor = .blue
		button.setTitle("gif_draw_export".localized, for: .normal)
		button.setTitleColor( UIColor(rgb: 0x222222), for: .normal)
		button.addTarget(self, action: #selector(export), for: .touchUpInside)
		button.layer.cornerRadius = 5
		return button
	}()
    
	override func viewDidLoad() {
		super.viewDidLoad()
        view.backgroundColor = .black
		nav.navigationBar.title = "gif_draw_title".localized
		nav.navigationBar.rightView = exportButton
		dashboard.backgroundColor = .clear
		toolBarView.currenColor = "#FFFFFF"
		setupSubviews()
		toolBarView.delegate = self
	}
	
	private func setupSubviews(){
		dashboard.delegate = self
		view.addSubview(emptyBackgroundView)
		view.addSubview(dashboard)
		view.addSubview(toolBarView)
        
        emptyBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(nav.navigationBarHeight)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(toolBarView.snp.top)
        }
        dashboard.snp.makeConstraints { make in
            make.edges.equalTo(emptyBackgroundView)
        }
        toolBarView.snp.makeConstraints { make in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(DrawToolBarView.toolBarHeight + bottomBarHeight)
        }

	}
	
	@objc private func export(){
        
        if dashboard.hasDraw() {
            guard let image = dashboard.generateImage() else{
                return
            }
            if addDrawBlock != nil {
                addDrawBlock!(image)
            }
            navigationController?.popViewController(animated: true)
        }
        
	}
}

extension DrawViewController: DrawDashboardDelegate{
	func updateStatus(canRedo: Bool, canUndo: Bool, canClean: Bool) {
		toolBarView.canUndo = canUndo
		toolBarView.canRedo = canRedo
		toolBarView.canClean = canClean
	}
	
	
}

extension DrawViewController: DrawToolBarViewDelegate{
	func redo() {
		dashboard.redo()
	}
	
	func undo() {
		dashboard.undo()
	}
	
	func penceilChanged(isErase: Bool) {
		dashboard.isEraser = isErase
	}
	
	func colorChanged(color: String) {
		dashboard.lineColor = color
	}
	
	func lineWidthChanged(width: CGFloat) {
		dashboard.lineWidth = width
	}
	
	func clean() {
		dashboard.clean()
	}
}
