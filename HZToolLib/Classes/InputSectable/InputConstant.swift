//
//  InputConstant.swift
//  InputInspectable
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

//
// custom regex. just like NSNotification.Name
//
// extension UIView {
//     public static var textDidBeginEditingNotification = InputRegEx.Name(rawValue: "")
// }
//

extension InputRegEx {
    public struct Name {
        private(set) var rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        /// 限制只能输入数字
        public static var numberOnly : Name {
            return Name(rawValue: "^[0-9]*$")
        }
        
        /// 限制只能输入数字，且第一位不能为0
        public static var numberOnlyFirstNotZero : Name {
            return Name(rawValue: "^[1-9][0-9]*$")
        }
       
        /// 0或者非零数
        public static var zeroOrNotZero : Name {
            return Name(rawValue: "^(0|[1-9][0-9]*)$")
        }
        
        /// 不包含零的整数（正负整数）
        public static var naturalNumber : Name {
            return Name(rawValue: "^-|-?[1-9]\\d*$")
        }
        
        /// 只能输入中文
        public static var chineseOnly : Name {
            return Name(rawValue: "^[\u{4e00}-\u{9fa5}]{0,}$")
        }

        /// 只能输入英文字符
        public static var englishOnly : Name {
            return Name(rawValue: "^[A-Za-z]+$")
        }
        
        /// 英文字符或者数字
        public static var englishOrNumber : Name {
            return Name(rawValue: "^[A-Za-z0-9]+$")
        }

        /// 英文和数字  或者非零数
        public static var englishOrNaturalNumber : Name {
            return Name(rawValue: "^(-|-?[1-9]\\d*)|([A-Za-z1-9]|[A-Za-z1-9][A-Za-z0-9]+)$")
        }

        /// 英文数字中文，不包含符号
        public static var englishOrNumberOrChinese : Name {
            return Name(rawValue: "^[a-zA-Z0-9\u{4e00}-\u{9fa5}]+$")
        }
        
        /// 英文数字中文，部分符号
        public static var englishOrNumberOrChineseAndSomePunctuation : Name {
            return Name(rawValue: "^[a-zA-Z0-9\u{4e00}-\u{9fa5},.!，。！“”@#%()¥？?]+$")
        }
        
        /// 不能输入中文
        public static var allCharExceptChinese : Name {
            return Name(rawValue: "^[^\u{4e00}-\u{9fa5}]{0,}$")
        }

        /// 整数或者浮点数
        public static var IntOrDouble : Name {
            return Name(rawValue: "^[0-9]+([.]{1}[0-9]+){0,1}$")
        }
        
        /// 身份证
        public static var IDCard : Name {
            return Name(rawValue: "^[xX0-9]+$")
        }
        
        /// 验证身份证，弱验证（只验证了为数和末尾X）
        public static var CheckIDCard : Name {
            return Name(rawValue: "^(\\d{14}|\\d{17})(\\d|[xX])$")
        }

        /// 验证电话号码，弱验证（只验证位数和1开头）
        public static var CheckPhoneNumber : Name {
            return Name(rawValue: "^(1\\d{10})")
        }
        
        /// 验证邮箱
        public static var CheckEmail : Name {
            return Name(rawValue: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        }
        //MARK: - quanhai 2019.10.11
        /// 英文字母开头， 只能输入英文和数字
        public static var startWithNoNumber: Name{
            return Name(rawValue: "^[a-zA-Z][A-Z0-9a-z]*$")
        }
        
    }
}

public struct InputRegEx {
    public var name: InputRegEx.Name
    public init(name: InputRegEx.Name) {
        self.name = name
    }
}
