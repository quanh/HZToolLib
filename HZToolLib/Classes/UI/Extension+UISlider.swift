//
//  Extension+UISlider.swift
//  GifEditor
//
//  Created by quanhai on 2022/4/17.
//

import Foundation
import UIKit
import SnapKit


extension UISlider{
	static func createSlider(min: Float = 0, max: Float = 1, value: Float = 0, tag: Int = 0, selector: Selector? = nil, target: AnyObject? = nil) -> UISlider{
		let slider = UISlider()
		slider.thumbTintColor = .orange
		slider.minimumTrackTintColor = .lightGray
		slider.maximumTrackTintColor = .lightGray
		slider.minimumValue = min
		slider.maximumValue = max
		slider.value = value
		slider.tag = tag
		if let selector = selector, let target = target {
			slider.addTarget(target, action: selector, for: .valueChanged)
		}

		return slider
	}
	static func createDebounceSlider(min: Float = 0, max: Float = 1, value: Float = 0, tag: Int = 0, selector: Selector? = nil, target: AnyObject? = nil) -> UISlider{
		let slider = UISlider()
		slider.thumbTintColor = .orange
		slider.minimumTrackTintColor = .lightGray
		slider.maximumTrackTintColor = .lightGray
		slider.minimumValue = min
		slider.maximumValue = max
		slider.value = value
		slider.tag = tag
		if let selector = selector, let target = target {
			slider.addTarget(target, action: selector, for: .touchUpInside)
		}

		return slider
	}
}

class HZSlider: UIView{
	lazy private var minValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 11)
		label.textColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
		return label
	}()
	lazy private var maxValueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 11)
		label.textColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
		return label
	}()
	lazy private var slider: UISlider = {
		let slider = UISlider()
		slider.thumbTintColor = .orange
		slider.minimumTrackTintColor = .lightGray
		slider.maximumTrackTintColor = .lightGray
		slider.addTarget(self, action: #selector(sliderValueDebounceChanged(sender:)), for: .touchUpInside)
		slider.addTarget(self, action: #selector(sliderValueChanged(sender:)), for: .valueChanged)
		return slider
	}()
	lazy private var valueLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 12, weight: .medium)
		label.textColor = UIColor(red: 216/255.0, green: 216/255.0, blue: 216/255.0, alpha: 1)
		label.textAlignment = .center
		return label
	}()
	private var valueSufix: String = ""
	weak var target: AnyObject?
	private var sel: Selector?
	private var min: Float = 0
	private var max: Float = 1
	private var currentValue: Float = 0
	
	public var shouldDebounce: Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		addSubview(minValueLabel)
		addSubview(maxValueLabel)
		addSubview(slider)
		addSubview(valueLabel)
		
		minValueLabel.snp.makeConstraints { make in
			make.left.equalToSuperview()
			make.height.equalTo(20)
			make.centerY.equalTo(slider)
		}
		slider.snp.makeConstraints { make in
			make.left.equalTo(minValueLabel.snp.right).offset(6)
			make.top.equalToSuperview()
			make.height.equalTo(32)
			make.bottom.equalTo(-22)
		}
		maxValueLabel.snp.makeConstraints { make in
			make.right.equalToSuperview()
			make.left.equalTo(slider.snp.right).offset(4)
			make.height.equalTo(20)
			make.centerY.equalTo(slider)
		}
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		guard slider.frame.width > 0 else { return }
		let ratio = (currentValue - min)/(max - min)
		let centerX = slider.frame.minX + CGFloat(ratio) * slider.bounds.width
		valueLabel.frame = CGRect(x: centerX - 80/2, y: slider.frame.maxY + 2, width: 80, height: 20)
	}
	
	@objc private func sliderValueChanged(sender: UISlider){
		currentValue = sender.value
		if let sel = sel, !shouldDebounce {
			target?.performSelector(onMainThread: sel, with: sender, waitUntilDone: true)
		}
		updateValueLabel()
	}
	
	@objc private func sliderValueDebounceChanged(sender: UISlider){
		if let sel = sel, shouldDebounce {
			target?.performSelector(onMainThread: sel, with: sender, waitUntilDone: true)
		}
	}
	
	private func updateValueLabel(){
		valueLabel.text = "\(Int(currentValue))" + valueSufix
		setNeedsLayout()
		layoutIfNeeded()
	}
	
	static func createSlider(min: Float = 0, max: Float = 1, value: Float = 0, tag: Int = 0, selector: Selector? = nil, target: AnyObject? = nil, valueSufix: String = "") -> HZSlider{
		let slider = Self()
		slider.slider.minimumValue = min
		slider.slider.maximumValue = max
		slider.slider.value = value
		slider.slider.tag = tag
		if let selector = selector, let target = target {
			slider.target = target
			slider.sel = selector
		}
	
		slider.valueSufix = valueSufix
		slider.minValueLabel.text = "\(Int(min))" + valueSufix
		slider.maxValueLabel.text = "\(Int(max))" + valueSufix
		slider.min = min
		slider.max = max
		slider.currentValue = value
		slider.updateValueLabel()

		return slider
	}
	
	static func createDebounceSlider(min: Float = 0, max: Float = 1, value: Float = 0, tag: Int = 0, selector: Selector? = nil, target: AnyObject? = nil, valueSufix: String = "") -> HZSlider{
		let slider = Self()
		slider.shouldDebounce = true
		slider.slider.minimumValue = min
		slider.slider.maximumValue = max
		slider.slider.value = value
		slider.slider.tag = tag
		if let selector = selector, let target = target {
			slider.target = target
			slider.sel = selector
		}
	
		slider.valueSufix = valueSufix
		slider.minValueLabel.text = "\(Int(min))" + valueSufix
		slider.maxValueLabel.text = "\(Int(max))" + valueSufix
		slider.min = min
		slider.max = max
		slider.currentValue = value
		slider.updateValueLabel()

		return slider
	}
}
