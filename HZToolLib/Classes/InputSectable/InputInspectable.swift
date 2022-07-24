//
//  InputInspectable.swift
//  InputInspectable
//
//  Created by mac on 2018/12/12.
//  Copyright © 2018 mac. All rights reserved.
//


#if os(macOS)
import AppKit
public typealias TextField = NSTextField
public typealias TextView = NSTextView
#elseif os(tvOS)
#else
import UIKit
public typealias TextField = UITextField
public typealias TextView = UITextView
#endif

public class InputInspectableComponent<Base: AnyObject> {
    var maxInput: Int = 0
    var inputRegExs = [InputRegEx.Name]()
    var historyText = ""
    public unowned var base: Base
    deinit {
//        print("xxxxxxxx deinit xxxxxxxxxxx")
        #if os(iOS) || os(watchOS)
            NotificationCenter.default.removeObserver(self, name: UITextField.textDidBeginEditingNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UITextField.textDidChangeNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
        #endif
    }
    
    public init(_ base: Base) {
        self.base = base
//        print("xxxxxxxxxx init xxxxxxxxxxxx")
        #if os(macOS)
        //MARK: todo...implementation macOS
        #elseif os(tvOS)
        #else
            if let tv = self.base as? UITextView {
                tv.autocorrectionType = .no
            }
            NotificationCenter.default.addObserver(forName: UITextField.textDidBeginEditingNotification, object: nil, queue: OperationQueue.main) { [weak self] notification in
                guard let tf = notification.object as? UITextField, let `self` = self else {return}
                if tf.isEqual(self.base) {
                    if self.inputRegExs.isEmpty {return}
                    if self.historyText.isEmpty {return}
                    var currentText = self.historyText
                    let isMatch = StringMatchManager.matchString(string: currentText, regExs: self.inputRegExs)
                    if !isMatch {
                        currentText = ""
                    }
                    self.historyText = currentText
                    tf.text = currentText
                } else {
//                    print("other textfield do not manage")
                }
            }

            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] notification in
                guard let tf = notification.object as? UITextField, let `self` = self else {return}
                if tf.isEqual(self.base) {
                    let currentText = tf.text ?? ""
                    let maxLength = self.maxInput
                    var isMatch = true
                    var isHighLight = false
                    if let selectRange = tf.markedTextRange, let _ = tf.position(from: selectRange.start, offset: 0) {
                        isHighLight = true
                    }

                    if !isHighLight {
                        if !self.inputRegExs.isEmpty { ///有正则匹配
                            isMatch = StringMatchManager.matchString(string: currentText, regExs: self.inputRegExs)
                            if isMatch {
                                if currentText.count > maxLength && self.maxInput > 0 {
                                    tf.text = String(currentText.prefix(maxLength))
                                } else {
                                    tf.text = currentText
                                }
                                self.historyText = currentText
                            } else {
                                if currentText.isEmpty {
                                    self.historyText = "";
                                }
                                if self.historyText.isEmpty {
                                    tf.text = ""
                                } else {
                                    tf.text = self.historyText
                                }
                            }
                        } else {
                            if currentText.count > maxLength && self.maxInput > 0 {
                                tf.text = String(currentText.prefix(maxLength))
                            } else {
                                tf.text = currentText
                            }
                            self.historyText = tf.text ?? ""
                        }
                    }
                } else {
//                    print("other textfield do not manage")
                }
            }

            NotificationCenter.default.addObserver(forName: UITextView.textDidBeginEditingNotification, object: nil, queue: OperationQueue.main) { [weak self] notification in
                guard let tv = notification.object as? UITextView, let `self` = self else {return}
                if tv.isEqual(self.base) {
                    if self.inputRegExs.isEmpty {return};
                    if self.historyText.isEmpty {return};
                    var currentText = self.historyText
                    let isMatch = StringMatchManager.matchString(string: currentText, regExs: self.inputRegExs)
                    if !isMatch {
                        currentText = ""
                    }
                    self.historyText = currentText
                    tv.text = currentText
                } else {
//                    print("other textview do not manage")
                }
            }

            NotificationCenter.default.addObserver(forName: UITextView.textDidChangeNotification, object: nil, queue: OperationQueue.main) { [weak self] notification in
                guard let tv = notification.object as? UITextView, let `self` = self else {return}
                if tv.isEqual(self.base) {
                    let currentText = tv.text ?? ""
                    let maxLength = self.maxInput
                    var isMatch = true
                    var isHighLight = false
                    if let selectRange = tv.markedTextRange, let _ = tv.position(from: selectRange.start, offset: 0) {
                        isHighLight = true
                    }

                    if !isHighLight {
                        if !self.inputRegExs.isEmpty {
                            isMatch = StringMatchManager.matchString(string: currentText, regExs: self.inputRegExs)
                            if isMatch {
                                if currentText.count > maxLength && self.maxInput > 0 {
                                    tv.text = String(currentText.prefix(maxLength))
                                } else {
                                    tv.text = currentText
                                }
                                self.historyText = tv.text
                            } else {
                                if currentText.isEmpty {
                                    self.historyText = ""
                                }
                                if (self.historyText.isEmpty) {
                                    tv.text = ""
                                } else {
                                    tv.text = self.historyText
                                }
                            }
                        } else {
                            if currentText.count > maxLength && self.maxInput > 0 {
                                tv.text = String(currentText.prefix(maxLength))
                            } else {
                                tv.text = currentText
                            }
                            self.historyText = tv.text ?? ""
                        }
                    }
                } else {
//                    print("other textview do not manage")
                }
            }
        #endif
    }
}

public protocol InputInspectable {
    associatedtype Base: AnyObject
    var input_compont: InputInspectableComponent<Base>? { get }
}

///不是存储属性
//extension InputInspectable {
//    public var compont: InputInspectableComponent<Self> {
//        get {
//            return InputInspectableComponent(self)
//        }
//        set {}
//    }
//}

extension TextField : InputInspectable {
    private struct AssociatedKeys {
        static var componetKey: String = "TextFiled_componetKey"
    }
    
    public var input_compont: InputInspectableComponent<TextField>? {
        get {
            guard let c = objc_getAssociatedObject(self, &AssociatedKeys.componetKey) as? InputInspectableComponent<TextField> else {
                let cc = InputInspectableComponent<TextField>(self)
                objc_setAssociatedObject(self, &AssociatedKeys.componetKey, cc, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cc
            }
            return c
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.componetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension TextView : InputInspectable {
    private struct AssociatedKeys {
        static var componetKey: String = "TextView_componetKey"
    }
    public var input_compont: InputInspectableComponent<TextView>? {
        get {
            guard let c = objc_getAssociatedObject(self,  &AssociatedKeys.componetKey) as? InputInspectableComponent<TextView> else {
                let cc = InputInspectableComponent<TextView>(self)
                objc_setAssociatedObject(self, &AssociatedKeys.componetKey, cc, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return cc
            }
            return c
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.componetKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}


