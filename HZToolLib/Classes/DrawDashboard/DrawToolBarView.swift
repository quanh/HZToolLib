//
//  DrawToolBarView.swift
//  ImageEditor
//
//  Created by quanhai on 2022/3/15.
//

import Foundation
import UIKit

protocol DrawToolBarViewDelegate: NSObject{
	func penceilChanged(isErase: Bool)
	func colorChanged(color: String)
	func lineWidthChanged(width: CGFloat)
	func redo()
	func undo()
	func clean()
}

class DrawToolBarView: UIView{
    open var bgColor: UIColor = .white
    public var colors: [String] = drawColors.hexValues
	public var currenColor: String = "#FFFFFF"{
		didSet{
			if let index = colors.firstIndex(of: currenColor) {
				selectedIndex = index
				collectionView.performBatchUpdates {
					collectionView.reloadData()
				} completion: { _ in
					self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: false)
				}

			}
		}
	}
	public var canRedo: Bool = false{
		didSet{
			redoButton.isEnabled = canRedo
		}
	}
	public var canUndo: Bool = false{
		didSet{
			undoButton.isEnabled = canUndo
		}
	}
	public var canClean: Bool = false{
		didSet{
			clearButton.isEnabled = canClean
		}
	}
	weak var delegate: DrawToolBarViewDelegate?
	
	static let toolBarHeight: CGFloat = 32
	static let controlAreaHeight: CGFloat = 146
	
	lazy private var toolBarView: UIView = {
		let view = UIView()
		view.backgroundColor = UIColor(hexString: "#181818", alpha: 0.6)
		return view
	}()
	lazy private var controlContentView: UIView = {
		let view = UIView()
		view.backgroundColor = bgColor
		return view
	}()
	
	lazy private var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 22, height: 22)
		layout.minimumLineSpacing = 0
		layout.minimumInteritemSpacing = 0
		layout.sectionInset = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 10)
		layout.scrollDirection = .horizontal
		let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
		collectionView.backgroundColor = bgColor
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.allowsMultipleSelection = false
		collectionView.showsHorizontalScrollIndicator = false
		collectionView.alwaysBounceHorizontal = true
        collectionView.register(StyleColorCollectionCell.self, forCellWithReuseIdentifier: StyleColorCollectionCell.description())
		return collectionView
	}()
	lazy private var slider: UISlider = UISlider.createSlider(min: 1, max: 50, value: 10, selector: #selector(sliderValueChanged(sender: )), target: self)

	lazy private var pencielButton: UIButton = {
		let button = UIButton()
		button.setImage(UIImage(named: "pen"), for: .normal)
		button.addTarget(self, action: #selector(buttonOnClick(button:)), for: .touchUpInside)
		return button
	}()
	lazy private var redoButton: UIButton = {
		let button = UIButton()
		button.tag = 0
		button.isEnabled = false
		button.setImage(UIImage(named: "do"), for: .normal)
		button.addTarget(self, action: #selector(redoAndUndoOnclick(button:)), for: .touchUpInside)
		return button
	}()
	lazy private var undoButton: UIButton = {
		let button = UIButton()
		button.tag = 1
		button.isEnabled = false
		button.setImage(UIImage(named: "undo"), for: .normal)
		button.addTarget(self, action: #selector(redoAndUndoOnclick(button:)), for: .touchUpInside)
		return button
	}()
	lazy private var clearButton: UIButton = {
		let button = UIButton()
		button.tag = 2
		button.isEnabled = false
		button.setImage(UIImage(named: "clear"), for: .normal)
		button.addTarget(self, action: #selector(clean), for: .touchUpInside)
		return button
	}()
	lazy private var colorLabel: UILabel = {
		let label = UILabel()
		label.text = "text_style_color".localized
		label.font = .systemFont(ofSize: 12)
		label.textColor = UIColor(rgb: 0x9B9B9B)
		return label
	}()
	lazy private var sizeLabel: UILabel = {
		let label = UILabel()
		label.text = "gif_draw_size".localized
		label.font = .systemFont(ofSize: 12)
		label.textColor = UIColor(rgb: 0x9B9B9B)
		return label
	}()
	
	private var isErase = false{
		didSet{
			delegate?.penceilChanged(isErase: isErase)
		}
	}
	private var selectedIndex: Int = 0
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(toolBarView)
		addSubview(controlContentView)
		toolBarView.addSubview(pencielButton)
		toolBarView.addSubview(undoButton)
		toolBarView.addSubview(redoButton)
		toolBarView.addSubview(clearButton)
		controlContentView.addSubview(colorLabel)
		controlContentView.addSubview(sizeLabel)
		controlContentView.addSubview(collectionView)
		controlContentView.addSubview(slider)
		
		toolBarView.snp.makeConstraints { make in
			make.left.top.right.equalToSuperview()
			make.height.equalTo(DrawToolBarView.toolBarHeight)
		}
		controlContentView.snp.makeConstraints { make in
			make.left.bottom.right.equalToSuperview()
			make.top.equalTo(toolBarView.snp.bottom)
		}
		
		pencielButton.snp.makeConstraints { make in
			make.centerY.right.equalToSuperview()
			make.size.equalTo(CGSize(width: 44, height: 32))
		}
		undoButton.snp.makeConstraints { make in
			make.left.equalToSuperview()
			make.centerY.equalToSuperview()
			make.size.equalTo(CGSize(width: 44, height: 32))
		}
		redoButton.snp.makeConstraints { make in
			make.left.equalTo(undoButton.snp.right)
			make.centerY.equalToSuperview()
			make.size.equalTo(CGSize(width: 44, height: 32))
		}
		clearButton.snp.makeConstraints { make in
			make.left.equalTo(redoButton.snp.right)
			make.centerY.equalToSuperview()
			make.size.equalTo(CGSize(width: 44, height: 32))
		}
		colorLabel.snp.makeConstraints { make in
			make.left.equalTo(21)
			make.height.equalTo(40)
			make.top.equalTo(38)
		}
		collectionView.snp.makeConstraints { make in
			make.left.equalTo(93)
			make.right.equalTo(0)
			make.height.equalTo(46)
			make.centerY.equalTo(colorLabel)
		}
		sizeLabel.snp.makeConstraints { make in
			make.left.equalTo(21)
			make.height.equalTo(40)
			make.top.equalTo(colorLabel.snp.bottom)
		}
		slider.snp.makeConstraints { make in
			make.centerY.equalTo(sizeLabel)
			make.left.equalTo(93)
			make.right.equalTo(-20)
			make.height.equalTo(24)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc private func sliderValueChanged(sender: UISlider){
		delegate?.lineWidthChanged(width: CGFloat(sender.value))
	}
	@objc private func buttonOnClick(button: UIButton){
		isErase = !isErase
		let imageName = isErase ? "eraser" : "pen"
		pencielButton.setImage(UIImage(named: imageName), for: .normal)
	}
	@objc private func redoAndUndoOnclick(button: UIButton){
		if button.tag == 0{
			delegate?.redo()
		}else{
			delegate?.undo()
		}
	}
	@objc private func clean(){
		delegate?.clean()
	}
}

extension DrawToolBarView: UICollectionViewDelegate{
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		selectedIndex = indexPath.row
		delegate?.colorChanged(color: colors[indexPath.row])
		collectionView.reloadData()
	}
}
extension DrawToolBarView: UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return colors.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell: StyleColorCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: StyleColorCollectionCell.description(), for: indexPath) as! StyleColorCollectionCell
		let colorHex = colors[indexPath.row]
        cell.bgColor = UIColor(hexString: colorHex)

		cell.colorSelected = selectedIndex == indexPath.row
		return cell
	}
}
