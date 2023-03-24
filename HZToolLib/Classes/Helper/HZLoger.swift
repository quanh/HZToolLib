//
//  HZLoger.swift
//  HZToolLib
//
//  Created by 权海 on 2023/3/24.
//

import Foundation


public func hzprint(_ items: Any...,
              file: String = #file,
              method: String = #function,
              line: Int = #line){
    #if DEBUG
        hz_print(message: items, fileName: file,methodName: method,lineNumber: line)
    #endif
}

private func hz_print<T>(message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) {
    //获取当前时间
    let now = Date().hz_string(withFormat: "yyyy-MM-dd HH:mm:ss.SSS")
    let lastName = ((fileName as NSString).pathComponents.last!)
    print("\(now) [\(lastName)-\(lineNumber)]: \(message)")
}
