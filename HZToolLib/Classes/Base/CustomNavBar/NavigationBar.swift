//
//  NavigationBar.swift
//  BaseKit
//
//  Created by  on 2019/2/16.
//  Copyright © 2019 yy. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView{
    func removeAllArrangedView(){
        for view in arrangedSubviews{
            view.removeFromSuperview()
        }
    }
}

public class NavigationBarAppearance{
    
    public static let appearance = NavigationBarAppearance()
    private init(){}
    
    public var titleAttribute : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.hzFont(font: .PingFangSC(weight: .medium, size: 16)), NSAttributedString.Key.foregroundColor:UIColor.white]
    public var itemAttribute : [NSAttributedString.Key : Any] = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.white]
    
    /// 左边的items离左边的距离
    public var leftViewSpace : CGFloat = 12
    public var leftViewsSpace : CGFloat = 8
    public var rightViewSpace : CGFloat = 12
    public var rightViewsSpace : CGFloat = 8
    
    public var backgroundColor = UIColor.white
    public var backgroundImage : UIImage?
    public var shadowColor : UIColor = UIColor.lightGray
    public var shadowImage : UIImage?
    public var shadowHeight : CGFloat = 1
}


public class NavigationBar : UIView {
    
    public var titleAttribute : [NSAttributedString.Key : Any] = NavigationBarAppearance.appearance.titleAttribute {
        didSet{
            if let text = title{
                self._titleView.attributedText = NSAttributedString.init(string: text, attributes: titleAttribute)
            }
            if let color = titleAttribute[.foregroundColor] as? UIColor{
                self._titleView.textColor = color
            }
            if let font = titleAttribute[.font] as? UIFont{
                self._titleView.font = font
            }
        }
    }
    
    public var attributeTitle : NSAttributedString?{
        didSet{
            self._titleView.attributedText = attributeTitle
        }
    }
    
    public var title : String?{
        didSet{
            if let title = title{
                self._titleView.attributedText = NSAttributedString.init(string: title, attributes: titleAttribute)
            }else{
               self._titleView.attributedText = nil
            }
        }
    }
    
    public var titleColor: UIColor? {
        set{
            var attribute = titleAttribute
            attribute[.foregroundColor] = newValue ?? titleAttribute[.foregroundColor] as? UIColor
            titleAttribute = attribute
        }
        get{ return titleAttribute[.foregroundColor] as? UIColor }
    }
    
    public var titleView : UIView?{
        didSet{
            oldValue?.removeFromSuperview()
           
            guard let titleView = titleView else{
                self.titleView = _titleView
                self.container.addSubview(_titleView)
                makeTitleViewConstans(titleView: _titleView)
                return
            }
            titleView.removeConstraints(titleView.constraints)
            titleView.updateFrameToAutoLayout()
            self.container.addSubview(titleView)
            makeTitleViewConstans(titleView: titleView)
        }
    }
    
    private func makeTitleViewConstans(titleView: UIView){
        titleView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        let centerXConstraint = titleView.centerXAnchor.constraint(equalTo: container.centerXAnchor)
        
        centerXConstraint.priority = UILayoutPriority(700)
        centerXConstraint.isActive = true
        
        let leftConstarint = titleView.leftAnchor.constraint(greaterThanOrEqualTo: leftStackView.rightAnchor)
        if  leftView != nil || !(leftViews?.isEmpty ?? true) {
            leftConstarint.constant = 10
        }
        leftConstarint.isActive = true
        
        let rightConstarint = titleView.rightAnchor.constraint(lessThanOrEqualTo: rightStackView.leftAnchor)
        if  rightView != nil || !(rightViews?.isEmpty ?? true) {
            rightConstarint.constant = -10
        }
        rightConstarint.isActive = true
    }
    
    public lazy var leftItemRightAnchor : NSLayoutXAxisAnchor = {
        return self.leftStackView.rightAnchor
    }()
    private lazy var leftStackView : UIStackView = {
        let s = UIStackView()
        s.axis = NSLayoutConstraint.Axis.horizontal
        s.alignment = UIStackView.Alignment.fill
        s.spacing = self.leftViewsSpace
        s.distribution = .equalSpacing
        return s
    }()
    public var leftView : UIView?{
        didSet{
            self.leftStackView.removeAllArrangedView()
            guard let leftView = leftView else{return}
            leftView.updateFrameToAutoLayout()
            self.leftStackView.addArrangedSubview(leftView)
        }
    }

    public var leftViews : [UIView]?{
        didSet{
            self.leftStackView.removeAllArrangedView()
            guard let leftViews = leftViews else{return}
            for view in leftViews{
                view.updateFrameToAutoLayout()
                self.leftStackView.addArrangedSubview(view)
            }
        }
    }
    
    public lazy var rightItemLeftAnchor : NSLayoutXAxisAnchor = {
        return self.rightStackView.leftAnchor
    }()
    private lazy var rightStackView : UIStackView = {
        let s = UIStackView()
        s.axis = NSLayoutConstraint.Axis.horizontal
        s.alignment = UIStackView.Alignment.center
        s.spacing = self.rightViewsSpace
        s.distribution = .fillProportionally
        s.clipsToBounds = false
        return s
    }()
    public var rightView : UIView?{
        didSet{
            self.rightStackView.removeAllArrangedView()
            guard let rightView = rightView else{return}
            rightView.updateFrameToAutoLayout()
            self.rightStackView.addArrangedSubview(rightView)
        }
    }
    
    public var rightViews : [UIView]?{
        didSet{
            self.rightStackView.removeAllArrangedView()
            guard let rightViews = rightViews else{return}
            for view in rightViews{
                view.updateFrameToAutoLayout()
                self.rightStackView.addArrangedSubview(view)
            }
        }
    }
    
    public var backgroundImage : UIImage?{
        didSet{
            self.backgroundImageView.image = backgroundImage
        }
    }
    public var shadowColor : UIColor?{
        didSet{
            self.shadowImageView.backgroundColor = shadowColor
        }
    }
    public var shadowImage : UIImage?{
        didSet{
            self.shadowImageView.image = shadowImage
        }
    }
    public var shadowHeight : CGFloat = NavigationBarAppearance.appearance.shadowHeight{
        didSet{
            shadowImageView.heightAnchor.constraint(equalToConstant: shadowHeight).isActive = true
        }
    }
    
    public override var backgroundColor: UIColor?{
        set{
            self.backgroundImageView.backgroundColor = newValue
        }get{
            return self.backgroundImageView.backgroundColor
        }
    }
    
    ///标题是否需要跟随透明
    public var isTitleViewTransparency = false
    ///左边是否跟随透明
    public var isLeftItemsTransparency = false
    ///右边是否跟随透明
    public var isRightItemsTransparency = false
    
    public var transparency : CGFloat = 1{
        didSet{
            self.backgroundImageView.alpha = transparency
            self.shadowImageView.alpha = transparency
            
            if isTitleViewTransparency{
                self.titleView?.alpha = transparency
            }
            if isLeftItemsTransparency{
                self.leftStackView.alpha = transparency
            }
            if isRightItemsTransparency{
                self.rightStackView.alpha = transparency
            }
        }
    }
    
    public var itemAttribute : [NSAttributedString.Key : Any] = NavigationBarAppearance.appearance.itemAttribute
    
    public var itemTintColor: UIColor? = UIColor.white {
         didSet {
            itemAttribute = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15),NSAttributedString.Key.foregroundColor:itemTintColor ?? UIColor.black]
            
            leftView?.tintColor = itemTintColor
            leftViews?.forEach({$0.tintColor = itemTintColor})
            rightView?.tintColor = itemTintColor
            rightViews?.forEach({$0.tintColor = itemTintColor})
            
            if let lview = leftView as? UIButton {
                makeItemAttributeTitle(button: lview)
            }
            if let rview = rightView as? UIButton {
              makeItemAttributeTitle(button: rview)
            }
            
            for view in leftViews ?? [] {
                if let b = view as? UIButton {
                  makeItemAttributeTitle(button: b)
                }
            }
            
            for view in rightViews ?? [] {
                if let b = view as? UIButton {
                 makeItemAttributeTitle(button: b)
                }
            }
         }
     }
    
    private func makeItemAttributeTitle(button: UIButton){
        if let title = button.title(for: .normal){
              button.setAttributedTitle(NSAttributedString(string: title, attributes: itemAttribute), for: .normal)
        }
    }
    
    
    public var leftViewSpace : CGFloat = NavigationBarAppearance.appearance.leftViewSpace{
        didSet{
            leftStackView.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: leftViewSpace).isActive = true
        }
    }
    public var leftViewsSpace : CGFloat = NavigationBarAppearance.appearance.leftViewsSpace{
        didSet{
            self.leftStackView.spacing = leftViewsSpace
        }
    }
    public var rightViewSpace : CGFloat = NavigationBarAppearance.appearance.rightViewSpace{
        didSet{
            rightStackView.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -rightViewSpace).isActive = true
        }
    }
    public var rightViewsSpace : CGFloat = NavigationBarAppearance.appearance.rightViewsSpace{
        didSet{
            self.rightStackView.spacing = rightViewsSpace
        }
    }
    
    public var isFullScreen: Bool = true {
        didSet {
            if oldValue != isFullScreen {
                containerFullTopConstraint?.isActive = isFullScreen
                containerTopConstraint?.isActive = !isFullScreen
            }
        }
    }
    
    //不包含statusbar 外部addview都在这个view上面
    private let container = UIView()
    private let _titleView = UILabel()
    private let backgroundImageView = UIImageView()
    private let shadowImageView = UIImageView()
    
    public private(set) var containerFullTopConstraint :NSLayoutConstraint?
    public private(set) var containerTopConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let appearance = NavigationBarAppearance.appearance
        
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.contentMode = .scaleAspectFill
        self.backgroundImageView.backgroundColor = appearance.backgroundColor
        backgroundImageView.image = appearance.backgroundImage
        super.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: super.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: super.bottomAnchor).isActive = true
        backgroundImageView.leftAnchor.constraint(equalTo: super.leftAnchor).isActive = true
        backgroundImageView.rightAnchor.constraint(equalTo: super.rightAnchor).isActive = true
        
        shadowImageView.layer.masksToBounds = true
        shadowImageView.contentMode = .scaleAspectFill
        shadowImageView.image = appearance.shadowImage
        shadowImageView.backgroundColor = appearance.shadowColor
        super.addSubview(shadowImageView)
        shadowImageView.translatesAutoresizingMaskIntoConstraints = false
        shadowImageView.heightAnchor.constraint(equalToConstant: self.shadowHeight).isActive = true
        shadowImageView.bottomAnchor.constraint(equalTo: super.bottomAnchor).isActive = true
        shadowImageView.leftAnchor.constraint(equalTo: super.leftAnchor).isActive = true
        shadowImageView.rightAnchor.constraint(equalTo: super.rightAnchor).isActive = true
        
        container.backgroundColor = UIColor.clear
        super.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        containerFullTopConstraint = container.topAnchor.constraint(equalTo: super.topAnchor, constant: safeTopHeight)
        containerTopConstraint = container.topAnchor.constraint(equalTo: super.topAnchor, constant: 0)
        containerFullTopConstraint?.isActive = isFullScreen
        containerTopConstraint?.isActive = !isFullScreen
        container.bottomAnchor.constraint(equalTo: super.bottomAnchor).isActive = true
        container.leftAnchor.constraint(equalTo: super.leftAnchor).isActive = true
        container.rightAnchor.constraint(equalTo: super.rightAnchor).isActive = true
        
        if let color = titleAttribute[.foregroundColor] as? UIColor{
            self._titleView.textColor = color
        }
        if let font = titleAttribute[.font] as? UIFont{
            self._titleView.font = font
        }
        self.titleView = _titleView
        
        container.addSubview(_titleView)
        container.addSubview(rightStackView)
        container.addSubview(leftStackView)
        
        _titleView.translatesAutoresizingMaskIntoConstraints = false
        _titleView.leftAnchor.constraint(greaterThanOrEqualTo: leftStackView.rightAnchor, constant: 10).isActive = true
        _titleView.rightAnchor.constraint(lessThanOrEqualTo: rightStackView.leftAnchor, constant: -10).isActive = true
        _titleView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        _titleView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        
        leftStackView.translatesAutoresizingMaskIntoConstraints = false
        leftStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        leftStackView.topAnchor.constraint(equalTo: self.container.topAnchor).isActive = true
        leftStackView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor).isActive = true
        leftStackView.leftAnchor.constraint(equalTo: self.container.leftAnchor, constant: leftViewSpace).isActive = true
        
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        rightStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        rightStackView.topAnchor.constraint(equalTo: self.container.topAnchor).isActive = true
        rightStackView.bottomAnchor.constraint(equalTo: self.container.bottomAnchor).isActive = true
        rightStackView.rightAnchor.constraint(equalTo: self.container.rightAnchor, constant: -rightViewSpace).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
//        DDLogInfo("deinit navigationBar")
        
    }
    
    public override func addSubview(_ view: UIView) {
        container.addSubview(view)
    }

    public var leftBarButtonItem: UIBarButtonItem? {
        didSet {
            leftView = createOptionView(item: leftBarButtonItem)
        }
    }
    
    public var leftBarButtonItems: [UIBarButtonItem]? {
        didSet {
            leftViews = leftBarButtonItems?.map({createView(item: $0)})
        }
    }
    
    public var rightBarButtonItem: UIBarButtonItem? {
        didSet {
            rightView = createOptionView(item: rightBarButtonItem)
        }
    }
    
    public var rightBarButtonItems: [UIBarButtonItem]? {
        didSet {
            rightViews = rightBarButtonItems?.map({createView(item: $0)})
        }
    }
}


extension NavigationBar {
    func createView(item: UIBarButtonItem)->UIView{
           if let view = item.customView{
               return view
           }
           if let systemItem = item.value(forKey: "systemItem") as? Int,systemItem == 6 || systemItem == 5{
               let v = UIView()
               v.backgroundColor = UIColor.clear
               v.widthAnchor.constraint(equalToConstant: max(item.width, 30)).isActive = true
               v.heightAnchor.constraint(equalToConstant: 0.1).isActive = true
               return v
           }
           
           let b = UIButton.init(type: UIButton.ButtonType.custom)
           if let title = item.title{
               b.setAttributedTitle(NSAttributedString.init(string: title, attributes: self.itemAttribute), for: UIControl.State.normal)
           }
           
           var rendModel: UIImage.RenderingMode = item.image?.renderingMode ?? .automatic
           if rendModel != .alwaysOriginal {
               rendModel = .alwaysTemplate
           }
           
           b.setTitle(item.title, for: UIControl.State.normal)
           b.setImage(item.image?.withRenderingMode(rendModel), for: UIControl.State.normal)
           b.tintColor = self.itemTintColor
           if let sel = item.action{
               b.addTarget(item.target, action: sel, for: UIControl.Event.touchUpInside)
           }
           return b
       }
       
       func createOptionView(item: UIBarButtonItem?)->UIView?{
           guard let item = item else{return nil}
           return createView(item: item)
       }
}


extension UIView{
    func updateFrameToAutoLayout(){
        self.translatesAutoresizingMaskIntoConstraints = false
        if self.bounds.width > 0 && self.bounds.height > 0 {
            self.widthAnchor.constraint(equalToConstant: max(self.bounds.width, 30)).isActive = true
            let heightConstarint = self.heightAnchor.constraint(equalToConstant: self.bounds.height)
            heightConstarint.priority = UILayoutPriority(rawValue: 900)
            heightConstarint.isActive = true
        } else if bounds.width > 0 {
            let size = self.intrinsicContentSize
            
            self.widthAnchor.constraint(equalToConstant: max(self.bounds.width, 30)).isActive = true
            let heightConstarint =  self.heightAnchor.constraint(equalToConstant: size.height)
            heightConstarint.priority = UILayoutPriority(rawValue: 900)
            heightConstarint.isActive = true
        } else if bounds.height > 0 {
            let size = self.intrinsicContentSize
            
            self.widthAnchor.constraint(equalToConstant:max(size.width + 4, 30)).isActive = true
            let heightConstarint =  self.heightAnchor.constraint(equalToConstant: bounds.height)
            heightConstarint.priority = UILayoutPriority(rawValue: 900)
            heightConstarint.isActive = true
        } else {
            let size = self.intrinsicContentSize
            
            self.widthAnchor.constraint(equalToConstant: max(size.width + 4, 30)).isActive = true
            let heightConstarint =  self.heightAnchor.constraint(equalToConstant: 44)
            heightConstarint.priority = UILayoutPriority(rawValue: 900)
            heightConstarint.isActive = true
        }
    }
}




