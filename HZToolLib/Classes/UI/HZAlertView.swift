//
//  HZAlertView.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation
import UIKit
import SnapKit


class HZAlertView: UIView{
    /// 是否使用自动布局， 默认使用frame 布局， 即 innerView需要给定frame
    ///  使用自动布局会使用autoLayout 来自适应大小,  innerMaxHeight仅在该情况下生效（限制innerView的最大高）
    ///  如果innerView 内部需要滚动， 请在innerView 上增加scrollView 来实现
    @objc var autoLayout: Bool = false{
        didSet{
//            if autoLayout{
//                contentView.snp.makeConstraints { make in
//                    make.left.right.equalToSuperview()
//                    make.top.equalTo(self.snp.bottom)
//                }
//            }
        }
    }

    @objc var innerMaxHeight: CGFloat = UIScreen.main.bounds.height - 88
    
    @objc var innerMinHeight: CGFloat = 120
    
    @objc var innerView: UIView?{
        didSet{
            if oldValue != nil{
                oldValue!.removeFromSuperview()
            }
            guard let innerView = innerView else { return }
            contentView.addSubview(innerView)
            if autoLayout{
                innerView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
                innerView.setContentHuggingPriority(.defaultLow, for: .vertical)
                innerView.snp.makeConstraints { make in
                    make.edges.equalToSuperview()
                }
            }
        }
    }
    
    @objc var canDissmissWhenTapMask = true
    @objc var hasMask = true{
        didSet{
            if !hasMask{
                maskedView.removeFromSuperview()
            }else{
                insertSubview(maskedView, at: 0)
            }
        }
    }
    
    public var isShow: Bool{
        return showOnSuper
    }
    private var showOnSuper = false
    private var isDissmiss = false
    
    lazy private var maskedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        view.addGestureRecognizer(tap)
        return view
    }()
    lazy private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 32
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor(hex: "#72AE8C").withAlphaComponent(0.29).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -10)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 20
        return view
    }()
    
    private var finalFrame: CGRect = .zero
    private var originFrame: CGRect = .zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(maskedView)
        addSubview(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        showOnSuper = false
        isDissmiss = false
    }
    
    public func configContent(_ backgroundColor: UIColor = .white, cornerRadius: CGFloat = 10, maskedCorners: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]){
        contentView.backgroundColor = backgroundColor
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.maskedCorners = maskedCorners
    }
    
    private func resetFrame(){
        var height: CGFloat = innerMinHeight
        if let innerView = innerView{
            height = innerView.bounds.height
        }
        originFrame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: height)
        finalFrame = CGRect(x: 0, y: bounds.height - originFrame.height, width: originFrame.width, height: originFrame.height)
        maskedView.frame = bounds
    }
    
    @objc func showAnimation(_ onView: UIView? = UIWindow.currentUIWindow()){
        guard let onView  else { return }
        let height = innerView?.bounds.height ?? innerMinHeight
        frame = hasMask ? onView.bounds : CGRect(x: 0, y: onView.bounds.height - height, width: onView.bounds.width, height: height)
        self.showOnSuper = true
        if autoLayout{
            contentView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalTo(self.snp.bottom)
            }
            maskedView.frame = bounds
            onView.addSubview(self)
            setNeedsLayout()
            layoutIfNeeded()
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.35) {
                    self.maskedView.alpha = 0.5
                    self.contentView.snp.remakeConstraints { make in
                        make.left.right.bottom.equalToSuperview()
                        make.height.greaterThanOrEqualTo(self.innerMinHeight)
                        make.height.lessThanOrEqualTo(self.innerMaxHeight)
                    }
                    self.layoutIfNeeded()
                }
            }
            return
        }
        resetFrame()
        contentView.frame = originFrame
        onView.addSubview(self)
        UIView.animate(withDuration: 0.35) {
            self.contentView.frame = self.finalFrame
            self.maskedView.alpha = 0.5
        }
    }
    
    @objc private func dismiss(){
        if !canDissmissWhenTapMask{
            return
        }
        dismissAnimation(true)
    }
    
    @objc func dismissAnimation(_ animation: Bool = true, completion: (() -> Void)? = nil){
        if !animation{
            self.removeFromSuperview()
            completion?()
            return
        }
        guard !isDissmiss else { return }
        isDissmiss = true
        
        if autoLayout{
            setNeedsLayout()
            UIView.animate(withDuration: 0.25, animations: {
                self.maskedView.alpha = 0
                self.contentView.snp.remakeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.height.greaterThanOrEqualTo(self.innerMinHeight)
                    make.height.lessThanOrEqualTo(self.innerMaxHeight)
                    make.top.equalTo(self.snp.bottom)
                }
                self.layoutIfNeeded()
            }) { _ in
                self.removeFromSuperview()
                completion?()
            }
            return
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.maskedView.alpha = 0
            self.contentView.frame = self.originFrame
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}
