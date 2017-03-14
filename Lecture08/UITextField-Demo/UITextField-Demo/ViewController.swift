//
//  ViewController.swift
//  UITextField-Demo
//
//  Created by 买明 on 14/03/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var myStoryboardTextField: MyTextField!
    var myCodeTextField: MyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStoryboardTextField()
        setupCodeTextField()
        
        setupKeyboardNotification()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupStoryboardTextField() {
        // 大小写类型
        myStoryboardTextField.autocapitalizationType = .words
        // 自动改正类型
        myStoryboardTextField.autocorrectionType = .yes
        // 返回键类型
        myStoryboardTextField.returnKeyType = .done
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        button.backgroundColor = UIColor.red
        button.setTitle("Hi! I am an Input Accessory View", for: .normal)
        button.addTarget(self, action: #selector(clickInputAccessoryViewButton(_:)), for: .touchUpInside)
        myStoryboardTextField.inputAccessoryView = button
    }
    
    func setupCodeTextField() {
        myCodeTextField = MyTextField(frame: myStoryboardTextField.frame)
        myCodeTextField.center = view.center
        myCodeTextField.placeholder = "UITextField From Code"
        myCodeTextField.borderStyle = .roundedRect
        
        // 输入内容显示为密文
        myCodeTextField.isSecureTextEntry = true
        // 键盘类型
        myCodeTextField.keyboardType = .numberPad
        // 开始编辑时清空原有内容
        myCodeTextField.clearsOnBeginEditing = true
        
        // 设置代理
        myCodeTextField.delegate = self
        
        view.addSubview(myCodeTextField)
    }
    
    func clickInputAccessoryViewButton(_ sender: UIButton) {
        _ = myStoryboardTextField.resignFirstResponder()
    }

    // 代理方法: 当按下 Return 时被调用
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(#function)
        return textField.resignFirstResponder()
    }
    
    // 代理方法: 当完成输入后被调用
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("\(#function) - \(textField.text ?? "")")
    }
    
    func setupKeyboardNotification() {
        // 通知
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardAppeared(_:)),
                                               name: Notification.Name.UIKeyboardDidShow,
                                               object: view.window)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDisappeared(_:)),
                                               name: Notification.Name.UIKeyboardDidHide,
                                               object: view.window)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillAppear(_:)),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: view.window)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillDisappear(_:)),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: view.window)
    }
    
    func keyboardAppeared(_ notification: Notification) {
        print("\(#function) - \(notification.userInfo ?? [:])")
    }
    
    func keyboardDisappeared(_ notification: Notification) {
        print(#function)
    }
    
    func keyboardWillAppear(_ notification: Notification) {
        print(#function)
    }
    
    func keyboardWillDisappear(_ notification: Notification) {
        print(#function)
    }
    
}

