//
//  DrawColors.swift
//  SwiftLearning
//
//  Created by 权海 on 2022/7/24.
//

import Foundation

var drawColors: DrawColors = DrawColors(.none)

enum DrawColorsInitType{
    case none
    case hex
    case int32
}

struct DrawColors{
    // 16进制颜色集合
    public var hexValues: [String] = [] // test passed
    public var int32Values: [__uint32_t] = [] // test passed
    
    private var colors = """
    FFB6C1,FFC0CB,DC143C,FFF0F5,DB7093,FF69B4,FF1493,C71585,DA70D6,D8BFD8,DDA0DD,EE82EE,FF00FF,8B008B,800080,BA55D3,9400D3,9932CC,4B0082,8A2BE2,9370DB,7B68EE,6A5ACD,483D8B,E6E6FA,F8F8FF,0000FF,0000CD,191970,00008B,000080,4169E1,6495ED,B0C4DE,778899,708090,1E90FF,F0F8FF,4682B4,87CEFA,87CEEB,00BFFF,ADD8E6,B0E0E6,5F9EA0,F0FFFF,E1FFFF,AFEEEE,00FFFF,D4F2E7,00CED1,2F4F4F,008B8B,008080,48D1CC,20B2AA,40E0D0,7FFFAA,00FA9A,00FF7F,F5FFFA,3CB371,2E8B57,F0FFF0,90EE90,98FB98,8FBC8F,32CD32,00FF00,228B22,008000,006400,7FFF00,7CFC00,ADFF2F,556B2F,F5F5DC,FAFAD2,FFFFF0,FFFFE0,FFFF00,808000,BDB76B,FFFACD,EEE8AA,F0E68C,FFD700,FFF8DC,DAA520,FFFAF0,FDF5E6,F5DEB3,FFE4B5,FFA500,FFEFD5,FFEBCD,FFDEAD,FAEBD7,D2B48C,DEB887,FFE4C4,FF8C00,FAF0E6,CD853F,FFDAB9,F4A460,D2691E,8B4513,FFF5EE,A0522D,FFA07A,FF7F50,FF4500,E9967A,FF6347,FFE4E1,FA8072,FFFAFA,F08080,BC8F8F,CD5C5C,FF0000,A52A2A,B22222,8B0000,800000,FFFFFF,F5F5F5,DCDCDC,D3D3D3,C0C0C0,A9A9A9,808080,696969,000000
    """
    
    init(_ type: DrawColorsInitType){
        switch type{
        case .none:
            break
        case .hex:
            var hexArray: [String] = []
            let colorArray = colors.components(separatedBy: ",")
            for color in colorArray{
                hexArray.append("#" + color)
            }
            hexValues = hexArray
        case .int32:
            var int32Array: [__uint32_t] = []
            let colorArray = colors.components(separatedBy: ",")
            for color in colorArray{
                let scanner = Scanner(string: color)
                var int32: __uint32_t = 0
                if withUnsafeMutablePointer(to: &int32, {
                    if #available(iOS 13.0, *){
                        return (__uint32_t(scanner.scanInt32() ?? 0) != 0)
                    }else{
                        return scanner.scanHexInt32($0)
                    }
                }){
                    int32Array.append(int32)
                }
            }
            int32Values = int32Array
        }
        
    }
    
    /*  */
    static func loadColors(){
        DispatchQueue.global().async {
            drawColors = DrawColors(.hex)
//            let colors = Colors(.int32)
        }
    }
}


