//
//  FaceViewController.swift
//  FaceIt
//
//  Created by 买明 on 24/02/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class FaceViewController: VCLLoggingViewController {
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            let handler = #selector(FaceView.changeScale(byReactingTo:))
            // 捏合手势（目标为 faceView）
            let pinchRecognizer = UIPinchGestureRecognizer(target: faceView, action: handler)
            faceView.addGestureRecognizer(pinchRecognizer)
            // 点按手势
//            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggleEyes(byReactingTp:)))
//            tapRecognizer.numberOfTapsRequired = 1
//            faceView.addGestureRecognizer(tapRecognizer)
            // 上下扫手势
            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeUpRecognizer.direction = .up
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeDownRecognizer.direction = .down
            faceView.addGestureRecognizer(swipeUpRecognizer)
            faceView.addGestureRecognizer(swipeDownRecognizer)
            
            // 初始化时并不调用 didSet；一旦 Outlet 连接到，才调用 didSet
            updateUI()
        }
    }
    
    // 初始化表情
    var expression = FacialExpression(eyes: .closed, mouth: .neutral) {
        didSet {
            updateUI()
        }
    }
    
    private let mouthCurvatures = [FacialExpression.Mouth.grin: 0.5,
                                   .frown: -1.0,
                                   .smile: 1.0,
                                   .neutral: 0.0,
                                   .smirk: -0.5]
    
    private struct HeadShake {
        static let angle = CGFloat.pi / 6
        static let segmentDuration: TimeInterval = 0.5
    }
    
    private func rotateFace(by angle: CGFloat) {
        faceView.transform = faceView.transform.rotated(by: angle)
    }
    
    private func shakeHead() {
        UIView.animate(withDuration: HeadShake.segmentDuration,
                       animations: { self.rotateFace(by: HeadShake.angle) },
                       completion: { finished in
                        if finished {
                            UIView.animate(withDuration: HeadShake.segmentDuration,
                                           animations: { self.rotateFace(by: -HeadShake.angle * 2) },
                                           completion: { finished in
                                            UIView.animate(withDuration: HeadShake.segmentDuration,
                                                           animations: { self.rotateFace(by: HeadShake.angle) })
                            })
                        }
        })
    }
    
    // 更新 UI
    private func updateUI() {
        switch expression.eyes {
        case .open:
            // ?: 当 faceView 未初始化（为 nil），则后续代码不执行；若不加 ? 且为 nil 时，程序崩溃
            faceView?.eyesOpen = true
        case .closed:
            faceView?.eyesOpen = false
        case .squinting:
            faceView?.eyesOpen = false
        }
        
        faceView?.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
    }
    
    func toggleEyes(byReactingTp tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let eyes: FacialExpression.Eyes = (expression.eyes == .closed) ? .open : .closed
            expression = FacialExpression(eyes: eyes, mouth: expression.mouth)
        }
    }
    
    func increaseHappiness() {
        expression = expression.happier
    }
    
    func decreaseHappiness() {
        expression = expression.sadder
    }
    
    @IBAction func shakeHead(_ sender: UITapGestureRecognizer) {
        shakeHead()
    }
}

