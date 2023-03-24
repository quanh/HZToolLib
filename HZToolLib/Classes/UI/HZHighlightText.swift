//
//  HZHighlightText.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation
import UIKit
import SnapKit


struct WHHighlightText{
    var textArr: [String] = ["For", "Example"]{
        didSet{
            text = textArr.joined(separator: seprator)
            let pargraph = NSMutableParagraphStyle()
            pargraph.minimumLineHeight = paragraphLineHeight
            pargraph.lineSpacing = lineSpacing
    //        pargraph.paragraphSpacing = paragraphSpacing
            attr = NSMutableAttributedString(string: text, attributes: [
                .font: font,
                .foregroundColor: normalColor,
                .paragraphStyle: pargraph
            ])
        }
    }
    var highlightTextArr: [String] = ["Example"]
    var seprator: String = " "
    var font: UIFont = .systemFont(ofSize: 20, weight: .bold)
    var paragraphLineHeight: CGFloat = 36
    var lineSpacing: CGFloat = 0
//    var paragraphSpacing: CGFloat = 10
    var highlightColor: UIColor? = .blue
    var highlightHeight: CGFloat = 6
    var normalColor: UIColor = .black
    
    var preferWidth: CGFloat = UIScreen.main.bounds.width
    var offsetWithBaseline: CGFloat = -2
    
    private(set) var text: String = ""
    private(set) var attr: NSAttributedString = NSAttributedString(string: "")
    
    var shadowRects: [CGRect]{
        let size = attr.sizeFit(CGSize(width: preferWidth, height: CGFLOAT_MAX))
        var rects: [CGRect] = []
        for highlightText in highlightTextArr{
            if let range = text.range(of: highlightText){
                // ranges
                let nsrange = NSRange(range, in: text)
                let rect = attr.boundingRectForRange(nsrange, size: size)
                rects.append(rect)
            }
        }
        
        return rects
    }
}



class WHHighlightLabel: UIView{
    private var highlightText: WHHighlightText = WHHighlightText()
    
    lazy private var shadowLayers: [CALayer] = []
    lazy private var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    convenience init(highlightText: WHHighlightText) {
        self.init(frame: .zero)
        self.highlightText = highlightText
        setupHighlight()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHighlight(){
        label.attributedText = highlightText.attr
        let rects = highlightText.shadowRects
        for rect in rects {
            let frame = CGRect(x: rect.origin.x, y: rect.origin.y + highlightText.font.ascender + highlightText.offsetWithBaseline, width: rect.width, height: highlightText.highlightHeight)
            let layer = createShadowLayer(frame)
            self.layer.insertSublayer(layer, at: 0)
            shadowLayers.append(layer)
        }
    }
    
    
    private func createShadowLayer(_ frame: CGRect) -> CALayer{
        let layer = CALayer()
        layer.frame = frame
        layer.backgroundColor = highlightText.highlightColor?.cgColor
        layer.cornerRadius = highlightText.highlightHeight/2
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        return layer
    }
}
