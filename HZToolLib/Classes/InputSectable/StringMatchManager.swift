//
//  StringMatchManager.swift
//  InputInspectable
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

public struct StringMatchManager {
    
    /// 处理正则，有时候正则因为带有转义符，导致匹配失败
    ///
    /// - Parameter regExs: regExs description
    /// - Returns: return value description
    static func transferRegExs(regExs: [InputRegEx.Name]) -> [InputRegEx.Name] {
        var regexs = [InputRegEx.Name]()
        var tmp = ""
        for regex in regExs {
            tmp = regex.rawValue.replacingOccurrences(of: "\\\\", with: "\\")
            if !tmp.isEmpty {
                regexs.append(InputRegEx.Name(rawValue: tmp))
            }
        }
        return regexs
    }
    
    /// 匹配字符串
    ///
    /// - Parameters:
    ///   - string: string description
    ///   - regEx: regEx description
    /// - Returns: 匹配结果
    static func matchString(string: String, regEx:InputRegEx.Name) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx.rawValue)
        return predicate.evaluate(with: string)
    }
    
    /// 匹配字符串
    ///
    /// - Parameters:
    ///   - string: string description
    ///   - regExs: regExs description
    /// - Returns: 匹配结果
    static func matchString(string: String, regExs:[InputRegEx.Name]) -> Bool {
        var result = true
        for regEx in regExs {
            let tmp = matchString(string: string, regEx: regEx)
            result = result && tmp
            if !tmp {break}
        }
        return result
    }
    
    ///必须包含大写字母，小写字母和数字并长度在8-20
    static func matchPassword8_20Ruler(password: String) -> Bool {
        let regex = "^(?=.*[0-9].*)(?=.*[A-Z].*)(?=.*[a-z].*).{8,20}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: password)
        return isValid
    }

}
