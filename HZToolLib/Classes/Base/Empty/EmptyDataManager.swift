//
//  EmptyDataManager.swift
//  GifEditor
//
//  Created by quanhai on 2022/5/2.
//

// ### just for example

import Foundation
import UIKit

extension UIImage{
	enum EmptyDataImageAsset: String {
		case empty
	}
	
	convenience init!(empty: EmptyDataImageAsset) {
		self.init(named: empty.rawValue)
	}
}

extension String{
	enum EmptyDataString: String{
		case empty_draft = "gif_empty_draft"
		case empty_publish = "gif_empty_publish"
	}
	
	init(empty: EmptyDataString) {
		self = empty.rawValue
	}
}


enum EmptyDataPlacholderType: String {
	case empty_draft
	case empty_publish

	func info() -> (imageName: UIImage.EmptyDataImageAsset?, title: String.EmptyDataString?, buttonTitle: String.EmptyDataString?){
		var placeholderInfo: (imageName: UIImage.EmptyDataImageAsset?, title: String.EmptyDataString?, buttonTitle: String.EmptyDataString?)
		switch self {
		case .empty_draft:
			placeholderInfo.imageName = .empty
			placeholderInfo.title = .empty_draft
		case .empty_publish:
			placeholderInfo.imageName = .empty
			placeholderInfo.title = .empty_publish
		}
		return placeholderInfo
	}
	
	func topOffset() -> CGFloat{
		switch self {
			/// 没有navigationbar 的时候， 或者scrollview 不是从顶部开始的时候另外返还
//        case .empty_info:
//            return 0
		default:
			return 0.0//CommonSize.navbarHeight
		}
	}
}

extension UIScrollView{
	 func setEmptyDataManager(manager: EmptyDataManager){
		self.emptyDataSetSource = manager
		self.emptyDataSetDelegate = manager
	}
}

class EmptyDataManager: NSObject {
	///  nil 时/非空数组不显示， 空数组则显示
	open var allowRefresh: Bool = true
	open var dataSource: [Any]?
	///  按钮点击事件
	open var actionButtonClick: (() -> Void)?
	private var type: EmptyDataPlacholderType = .empty_draft
	private var placeholderInfo: (imageName: UIImage.EmptyDataImageAsset?, title: String.EmptyDataString?, buttonTitle: String.EmptyDataString?)
	
	init(_ placeholderType: EmptyDataPlacholderType) {
		super.init()
		self.type = placeholderType
		self.placeholderInfo = self.type.info()
	}
}

extension EmptyDataManager: EmptyDataSetSource{
	func customView(forEmptyDataSet scrollView: UIScrollView) -> UIView? {
		let actionView: EmptyDataActionView = EmptyDataActionView(offset: self.type.topOffset())
		if self.placeholderInfo.imageName != nil{
			actionView.image = UIImage(empty: self.placeholderInfo.imageName!)
		}
		actionView.title = self.placeholderInfo.title!.rawValue.localized
		actionView.actionTitle = self.placeholderInfo.buttonTitle?.rawValue
		
		return actionView
	}
	
	/*
	func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
		guard self.placeholderInfo.imageName != nil else { return nil }
		return UIImage(empty: self.placeholderInfo.imageName!)
	}
	
	func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
		guard self.placeholderInfo.title != nil else { return nil }
		let attrTitle = NSMutableAttributedString(string: self.placeholderInfo.title!.rawValue)
		attrTitle.addAttributes([NSAttributedString.Key.font: regularFont(14), NSAttributedString.Key.foregroundColor : UIColor(rgb: 0x787878)], range: NSRange(location: 0, length: attrTitle.string.count))
		return attrTitle
	}
	
	func buttonTitle(forEmptyDataSet scrollView: UIScrollView, for state: UIControl.State) -> NSAttributedString? {
		guard self.placeholderInfo.buttonTitle != nil else { return nil }
		let attrTitle = NSMutableAttributedString(string: self.placeholderInfo.buttonTitle!.rawValue)
		attrTitle.addAttributes([NSAttributedString.Key.font: regularFont(14), NSAttributedString.Key.foregroundColor : UIColor(rgb: 0xFF5D8C)], range: NSRange(location: 0, length: attrTitle.string.count))
		return attrTitle
	}
	*/
}

extension EmptyDataManager: EmptyDataSetDelegate{
    @objc func emptyDataSetShouldFadeIn(_ scrollView: UIScrollView) -> Bool {
		return true
	}
	func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
		if dataSource == nil { return false }
		return dataSource!.count == 0
	}
	func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
		return allowRefresh
	}
}


//MARK: -  custom emptydataset view
class EmptyDataActionView: UIView {
	private var topOffset: CGFloat = 0.0
	open var image: UIImage?{
		didSet{
			imageView?.image = image
		}
	}
	open var title: String?{
		didSet{
			titleLabel?.text = title
		}
	}
	open var actionTitle: String?{
		didSet{
			actionView?.isHidden = actionTitle == nil
			actionView?.title = title
		}
	}
	open var actionHandler: (() -> Void)?
	private var topView: UIView?
	private var imageView: UIImageView?
	private var titleLabel: UILabel?
	private var actionView: EdgeTitleView?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	convenience init(offset: CGFloat) {
		self.init()
		self.topOffset = offset
		setupSubviews()
		layoutConstrains()
		bindAction()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

//MARK: - bind action
extension EmptyDataActionView{
	private func bindAction(){
		let tap = UITapGestureRecognizer(target: self, action: #selector(actionViewTapped))
		actionView?.addGestureRecognizer(tap)
	}
	
	@objc private func actionViewTapped(){
		guard actionHandler != nil else { return }
		actionHandler!()
	}
}

//MARK: - subviews
extension EmptyDataActionView{
	private func setupSubviews(){
//        topView = UIView()
		imageView = UIImageView()
		imageView?.contentMode = .scaleAspectFill
		
		titleLabel = UILabel()
		titleLabel?.font = .systemFont(ofSize: 14)
		titleLabel?.textColor = UIColor(rgb: 0x787878)
		titleLabel?.textAlignment = .center
		titleLabel?.numberOfLines = 0
		
		actionView = EdgeTitleView()
		actionView?.layer.borderWidth = 1
		actionView?.layer.borderColor = UIColor(rgb: 0xFF5D8C).cgColor
		actionView?.radius = 36.0
		actionView?.edges = UIEdgeInsets(top: 8, left: 36, bottom: 8, right: 36)
		
//        addSubview(topView!)
		addSubview(imageView!)
		addSubview(titleLabel!)
		addSubview(actionView!)
	}
	private func layoutConstrains(){
		titleLabel?.snp.makeConstraints({ (make) in
			make.centerX.equalToSuperview()
			make.centerY.equalToSuperview().offset(self.topOffset)
			make.left.equalTo(25.0)
		})
		imageView?.snp.makeConstraints({ (make) in
			make.top.greaterThanOrEqualTo(20.0)
			make.centerX.equalToSuperview()
			make.width.height.equalTo(70.0)
			make.bottom.equalTo(titleLabel!.snp.top).offset(-6.0)
		})
		actionView?.snp.makeConstraints({ (make) in
			make.top.equalTo(titleLabel!.snp.bottom).offset(22)
			make.centerX.equalToSuperview()
			make.bottom.lessThanOrEqualTo(-20.0)
		})
	}
}


//MARK: - 带边距的label样式
class EdgeTitleView: UIView {
	open var estimateWidth: CGFloat = UIScreen.main.bounds.width
	open var edges: UIEdgeInsets = UIEdgeInsets(top: 2.0, left: 8.0, bottom: 2.0, right: 8.0){
		didSet{
			titleLabel?.snp.remakeConstraints({ (make) in
				make.edges.equalTo(self.edges)
			})
		}
	}
	open var radius: CGFloat = 0.0
	open var title: String?{
		didSet{
			titleLabel?.text = title
			caculateHeight()
		}
	}
	open var font: UIFont?{
		didSet{
			titleLabel?.font = font
		}
	}
	open var textColor: UIColor = .white{
		didSet{
			titleLabel?.textColor = textColor
		}
	}
	open var numberOfLines: Int = 1{
		didSet{
			titleLabel?.numberOfLines = numberOfLines
		}
	}
	open var alignment: NSTextAlignment = .center{
		didSet{
			titleLabel?.textAlignment = alignment
		}
	}
	///
	open var viewHeight: CGFloat = 0
	private var titleLabel: UILabel?
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		titleLabel = UILabel()
		titleLabel?.textAlignment = .center
		
		addSubview(titleLabel!)
		titleLabel?.snp.makeConstraints({ (make) in
			make.edges.equalTo(self.edges)
		})
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		let cornerRadius = min(bounds.height/2.0, radius)
		self.layer.cornerRadius = cornerRadius
		self.layer.masksToBounds = cornerRadius > 0
	}
	
	private func caculateHeight(){
		let size = titleLabel?.sizeThatFits(CGSize(width: estimateWidth, height: 0)) ?? .zero
		viewHeight = 0
		viewHeight += edges.top + edges.bottom
		viewHeight += size.height
	}
}
