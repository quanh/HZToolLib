//
//  Number+Ex.swift
//  GifMaker
//
//  Created by chunyu on 2022/3/16.
//

import UIKit


extension Double {
    
    func roundTo(places: Int) -> Self {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Float {
    
    func roundTo(places: Int) -> Self {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

