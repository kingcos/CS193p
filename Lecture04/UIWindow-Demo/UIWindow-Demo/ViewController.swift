//
//  ViewController.swift
//  UIWindow-Demo
//
//  Created by 买明 on 25/02/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                      UIAlertViewDelegate {

    var myWindow: UIWindow?
    
    @IBAction func clickAlertWindow(_ sender: UIButton) {
        // UIAlertView 在 iOS 9 中过时
        let alertView = UIAlertView(title: "AlertView",
                                    message: "Demo",
                                    delegate: self,
                                    cancelButtonTitle: "Ok")
        
        alertView.show()
        
//        let alertController = UIAlertController(title: "UIAlertController",
//                                                message: "Demo",
//                                                preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "Ok",
//                                                style: .cancel,
//                                                handler: nil))
//        present(alertController, animated: true)
    }
    
    @IBAction func clickCustomWindow(_ sender: UIButton) {
        myWindow = UIWindow(frame: UIScreen.main.bounds)
        myWindow?.windowLevel = UIWindowLevelNormal
        myWindow?.backgroundColor = UIColor.red
        myWindow?.isHidden = false
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(hideWindow(with:)))
        myWindow?.addGestureRecognizer(gesture)
    }
    
    func hideWindow(with guesture: UIGestureRecognizer) {
        myWindow?.isHidden = true
        myWindow = nil
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let window = alertView.window
        print("alertView windowLevel: \(window?.windowLevel)\n")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

