//
//  UIView+ajustment.swift
//  GifEditor
//
//  Created by 权海 on 2022/7/9.
//

import Foundation
import UIKit

extension CGSize{
    /** 在 containerSize 中按原比例充满， 返回缩放后的正确size */
    func ajust(into containerSize: CGSize = .zero) -> CGSize{
        guard containerSize != .zero else{
            return self
        }
        
        let containerAspectRatio = containerSize.height / containerSize.width
        var targetSize: CGSize = .zero
        if height / width > containerAspectRatio{
            // 按照高度缩放
            let ratio = height / containerSize.height
            targetSize = CGSize(width: width / ratio, height: containerSize.height)
        }else{
            // 按照宽度缩放
            let ratio = width / containerSize.width
            targetSize = CGSize(width: containerSize.width, height: height / ratio)
        }
        return targetSize
    }
}
