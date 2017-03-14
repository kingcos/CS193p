//
//  MyTextField.swift
//  UITextField-Demo
//
//  Created by 买明 on 14/03/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class MyTextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        print(#function)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        print(#function)
        return super.resignFirstResponder()
    }
    
}
