//
//  ViewController.swift
//  Lecture05-Demo
//
//  Created by 买明 on 03/03/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // 在 Attributes Inspector 中勾选 User Interaction Enabled
    @IBOutlet weak var pannableLabel: UILabel! {
        didSet {
            let panGestureRecognizer = UIPanGestureRecognizer(
                target: self, action: #selector(ViewController.pan(recognizer:))
            )
            pannableLabel.addGestureRecognizer(panGestureRecognizer)
        }
    }
    
    @IBOutlet weak var tapLabel: UILabel! {
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(
                target: self, action: #selector(ViewController.tap(recognizer:))
            )
            tapLabel.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    func pan(recognizer: UIPanGestureRecognizer) {
        print("pan 手势状态枚举原始值：\(recognizer.state.rawValue)")
        
        switch recognizer.state {
        case .changed: fallthrough
        case .ended:
            let point = recognizer.translation(in: pannableLabel)
            let center = pannableLabel.center
            
            recognizer.view?.center = CGPoint(x: center.x + point.x, y: center.y)
            recognizer.setTranslation(CGPoint.zero, in: pannableLabel)
        default:
            break
        }
    }

    func tap(recognizer: UITapGestureRecognizer) {
        print("tap 手势状态枚举原始值：\(recognizer.state.rawValue)")
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
        
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

