//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by 买明 on 06/03/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class EmotionsViewController: VCLLoggingViewController {
    
    // 表情字典：代替 switch-case
    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "sad": FacialExpression(eyes: .closed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "worried": FacialExpression(eyes: .open, mouth: .smirk)
    ]

    // 预备 segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 目标 segue
        var destinationViewController = segue.destination
        
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier,
            let expression = emotionalFaces[identifier] {
            faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }

}
