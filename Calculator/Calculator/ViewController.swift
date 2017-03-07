//
//  ViewController.swift
//  Calculator
//
//  Created by 买明 on 15/02/2017.
//  Copyright © 2017 买明. All rights reserved.
//  [Powered by kingcos](https://github.com/kingcos/CS193P_2017)

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    private var brain = CalculatorBrain()
    
    // 存储属性
    var userIsInTheMiddleOfTyping = false
    
    // 计算属性
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = true
        }
        
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        if let result = brain.result {
            displayValue = result
        }
        
    }
    
    override func viewDidLoad() {
//        brain.addUnaryOperation(named: "✅") { (value) -> Double in
//            return sqrt(value)
//        }
        
//        brain.addUnaryOperation(named: "✅") {
//            return sqrt($0)
//        }
        
//        brain.addUnaryOperation(named: "✅") {
//            self.display.textColor = UIColor.green
//            return sqrt($0)
//        }
        
        // weak
//        brain.addUnaryOperation(named: "✅") { [weak self] in
//            // self 为 Optional
//            self?.display.textColor = UIColor.green
//            return sqrt($0)
//        }
//
//        brain.addUnaryOperation(named: "✅") { [weak weakSelf = self] in
//            weakSelf?.display.textColor = UIColor.green
//            return sqrt($0)
//        }
        
        // unowned
//        brain.addUnaryOperation(named: "✅") { [me = self] in
//            me.display.textColor = UIColor.green
//            return sqrt($0)
//        }
//        
//        brain.addUnaryOperation(named: "✅") { [unowned me = self] in
//            me.display.textColor = UIColor.green
//            return sqrt($0)
//        }
//        
//        brain.addUnaryOperation(named: "✅") { [unowned self = self] in
//            self.display.textColor = UIColor.green
//            return sqrt($0)
//        }
        
        brain.addUnaryOperation(named: "✅") { [unowned self] in
            self.display.textColor = UIColor.green
            return sqrt($0)
        }
    }
    
}

