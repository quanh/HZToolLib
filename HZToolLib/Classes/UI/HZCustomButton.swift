//
//  HZCustomButton.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation
import UIKit

class HZCustomButton: UIButton {

    enum ImagePostion {
        case left
        case right
        case top
        case bottom
    }

    public let imagePostion: ImagePostion
    public let interitemSpace: CGFloat

    init(postion: ImagePostion, interitemSpace space: CGFloat = 0) {
        imagePostion = postion
        interitemSpace = space
        super.init(frame: .zero)

        contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var intrinsicContentSize: CGSize {
        let imageSize = imageView?.intrinsicContentSize ?? .zero
        let titleSize = titleLabel?.intrinsicContentSize ?? .zero

         guard let _ = imageView?.image, let _ = titleLabel?.text else {
            return super.intrinsicContentSize
        }

        switch imagePostion {
        case .left, .right:
            return CGSize(width: imageSize.width + interitemSpace + titleSize.width + contentEdgeInsets.left + contentEdgeInsets.right,
                          height: max(imageSize.height, titleSize.height) + contentEdgeInsets.top + contentEdgeInsets.bottom)

        case .bottom, .top:
            return CGSize(width: max(imageSize.width, titleSize.width) + contentEdgeInsets.left + contentEdgeInsets.right,
                         height: imageSize.height + interitemSpace + titleSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let _ = imageView?.image, let _ = titleLabel?.text else {
            return
        }

        var imageWidth: CGFloat = 0.0
        var imageHeight: CGFloat = 0.0
        if let imgView = self.imageView {
            //    获取按钮图片的宽高
            let imgSize = (currentImage != nil) ? imgView.intrinsicContentSize : CGSize.zero
            imageWidth = imgSize.width
            imageHeight = imgSize.height
        }

        var labelWidth: CGFloat = 0.0
        var labelHeight: CGFloat = 0.0
        if let label = self.titleLabel {
            //    获取文字的宽高
            let labelSize = label.intrinsicContentSize
            labelWidth = labelSize.width
            labelHeight = labelSize.height
        }

        var imageOffset: CGFloat = 0

        if constraints.isEmpty {   //frame 布局
            let contentW = bounds.width - contentEdgeInsets.left - contentEdgeInsets.right

            if contentW >= labelWidth + imageWidth {
                imageOffset = labelWidth / 2
            } else {
                imageOffset = contentW > imageWidth ?  (contentW - imageWidth)/2 : 0
            }

        } else {   //自动布局
            
            if bounds.size != intrinsicContentSize {
                invalidateIntrinsicContentSize()
            }
            
            var constraintWidth: CGFloat = 0
            for item in constraints {
                if item.firstAttribute == .width {
                    constraintWidth = item.constant
                }
            }
            
            if constraintWidth > 0 {
                let constraintWidth = bounds.width - contentEdgeInsets.left - contentEdgeInsets.right

                if constraintWidth >= labelWidth + imageWidth {
                    imageOffset = labelWidth / 2
                } else {
                    imageOffset = constraintWidth > imageWidth ?  (constraintWidth - imageWidth)/2 : 0
                }
                
            }else{
                imageOffset =  labelWidth > imageWidth ?  (labelWidth - imageWidth)/2 : 0
            }
        }

        //按钮图片文字的位置 EdgeInsets 都是相对原来的位置变化
          var titleTop: CGFloat = 0.0, titleLeft: CGFloat = 0.0, titleBottom: CGFloat = 0.0, titleRight: CGFloat = 0.0
          var imageTop: CGFloat = 0.0, imageLeft: CGFloat = 0.0, imageBottom: CGFloat = 0.0, imageRight: CGFloat = 0.0

          switch imagePostion {
          case .left:
              //    图片在左、文字在右;
              imageTop = 0
              imageBottom = 0
              imageLeft =  -interitemSpace / 2.0
              imageRight = interitemSpace / 2.0

              titleTop = 0
              titleBottom = 0
              titleLeft = interitemSpace / 2
              titleRight = -interitemSpace / 2

          case .top://    图片在上，文字在下
              imageTop = -(labelHeight / 2.0 + interitemSpace / 2.0)//图片上移半个label高度和半个space高度  给label使用
              imageBottom = (labelHeight / 2.0 + interitemSpace / 2.0)
              imageLeft = imageOffset
              imageRight = -imageOffset

              titleLeft = -imageWidth
              titleRight = 0
              titleTop = imageHeight / 2.0 + interitemSpace / 2.0//文字下移半个image高度和半个space高度
              titleBottom = -(imageHeight / 2.0 + interitemSpace / 2.0)

          case .right://    图片在右，文字在左
              imageTop = 0
              imageBottom = 0
              imageRight = -(labelWidth + interitemSpace / 2.0)
              imageLeft = labelWidth + interitemSpace / 2.0

              titleTop = 0
              titleLeft = -(imageWidth + interitemSpace / 2.0)
              titleBottom = 0
              titleRight = imageWidth + interitemSpace / 2.0

          case .bottom://    图片在下，文字在上
              imageLeft =  imageOffset
              imageRight = -imageOffset
              imageBottom = -(labelHeight / 2.0 + interitemSpace / 2.0)
              imageTop = labelHeight / 2.0 + interitemSpace / 2.0//图片下移半个label高度和半个space高度  给label使用

              titleTop = -(imageHeight / 2.0 + interitemSpace / 2.0)
              titleBottom = imageHeight / 2.0 + interitemSpace / 2.0
              titleLeft =  -imageWidth
              titleRight = 0
          }

          imageEdgeInsets = UIEdgeInsets(top: imageTop, left: imageLeft, bottom: imageBottom, right: imageRight)
          titleEdgeInsets = UIEdgeInsets(top: titleTop, left: titleLeft, bottom: titleBottom, right: titleRight)

    }
}
