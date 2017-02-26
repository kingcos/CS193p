//
//  ValidationWindow.swift
//  UIWindow-Demo
//
//  Created by 买明 on 26/02/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class ValidationWindow: UIWindow {
    
    var textField: UITextField?
    static let sharedInstance = ValidationWindow(frame: UIScreen.main.bounds)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: CGRect(x: 10, y: 50, width: 200, height: 20))
        label.text = "请输入密码"
        addSubview(label)
        
        let textField = UITextField(frame: CGRect(x: 10, y: 80, width: 200, height: 20))
        textField.backgroundColor = UIColor.white
        textField.isSecureTextEntry = true
        self.textField = textField
        addSubview(textField)
        
        let button = UIButton(frame: CGRect(x: 10, y: 110, width: 200, height: 44))
        button.backgroundColor = UIColor.blue
        button.titleLabel?.textColor = UIColor.black
        button.setTitle("确定", for: .normal)
        button.addTarget(self, action: #selector(completeButtonPressed), for: .touchUpInside)
        addSubview(button)

        backgroundColor = UIColor.yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func completeButtonPressed() {
        let textContent = textField?.text
        textField?.text?.removeAll()
        if textContent == "abcd" {
            textField?.resignFirstResponder()
            resignKey()
            isHidden = true
        } else {
            showErrorAlertView()
        }
    }
    
    func showErrorAlertView() {
        let alertView = UIAlertView(title: "密码错误",
                                    message: "正确密码是 abcd",
                                    delegate: self,
                                    cancelButtonTitle: "Ok")
        
        alertView.show()
    }

    func show() {
        makeKey()
        isHidden = false
    }
}
