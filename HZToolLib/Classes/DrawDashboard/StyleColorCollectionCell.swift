//
//  StyleColorCollectionCell.swift
//  GifEditor
//
//  Created by quanhai on 2022/4/5.
//

import Foundation
import UIKit


class StyleColorCollectionCell: UICollectionViewCell{
    open var clearColorImgaeName: String = "color-none"
    open var selectedColor: UIColor = .orange
	
	public var bgColor: UIColor = .white{
		didSet{
			imageView.backgroundColor = bgColor
			imageView.image = bgColor == .clear ? UIImage(named: clearColorImgaeName) : nil
		}
	}
	public var colorSelected: Bool = false{
		didSet{
			coverView.isHidden = !colorSelected
		}
	}
	
	lazy private var coverView: UIView = {
		let view = UIView()
		view.backgroundColor = .init(white: 0, alpha: 0.2)
		view.layer.borderWidth = 2
		view.layer.borderColor = selectedColor.cgColor
		view.isHidden = true
		return view
	}()
	lazy private var imageView: UIImageView = {
		let imageView = UIImageView()
		imageView.contentMode = .scaleAspectFill
		return imageView
	}()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(imageView)
		contentView.addSubview(coverView)
		imageView.snp.makeConstraints { make in
			make.edges.equalTo(UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
		}
		coverView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override class func description() -> String {
		return "StyleColorCollectionCell"
	}
}
