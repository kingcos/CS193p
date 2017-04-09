//
//  FaceView.swift
//  FaceIt
//
//  Created by 买明 on 24/02/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {

    // 半径
    private var skullRadius: CGFloat {
        // bounds & frame: 可以参考我的 [iOS 中的 bounds & frame](http://www.jianshu.com/p/edb2ae03115c) 一文
        return min(bounds.size.width, bounds.size.height) / 2.0 * scale
    }
    // 圆心
    private var skullCenter: CGPoint {
        // center 是基于父控件坐标系得来的；而这里需要基于自己坐标系得来的中心坐标
        // return convert(center, from: superview)
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private lazy var leftEye: EyeView = self.createEye()
    private lazy var rightEye: EyeView = self.createEye()
    
    // 比例
    private struct Ratios {
        static let skullRadiusToEyeOffset: CGFloat = 3.0
        static let skullRadiusToEyeRadius: CGFloat = 10.0
        static let skullRadiusToMouthWidth: CGFloat = 1.0
        static let skullRadiusToMouthHeight: CGFloat = 3.0
        static let skullRadiusToMouthOffset: CGFloat = 3.0
    }
    
    // 眼睛枚举
    private enum Eye {
        case left
        case right
    }
    
    // 必须指定类型，才能在 Attributes Inspector 设置；设值后重新绘制 setNeedsDisplay()
    @IBInspectable
    var scale: CGFloat = 0.8 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 {
        didSet {
            leftEye.lineWidth = lineWidth
            rightEye.lineWidth = lineWidth
            
            setNeedsDisplay()
        }
    }
    @IBInspectable
    var lineColor: UIColor = .blue {
        didSet {
            leftEye.color = lineColor
            rightEye.color = lineColor
            
            setNeedsDisplay()
        }
    }
    
    // 嘴巴弧度 1.0: Smile, -1.0: Frown
    @IBInspectable
    var mouthCurvature: Double = 0.0 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = true {
        didSet {
            leftEye.eyesOpen = eyesOpen
            rightEye.eyesOpen = eyesOpen
            
//            setNeedsDisplay()
        }
    }

    // 若不自定义绘制，则不要重写该方法（将会影响性能）
    override func draw(_ rect: CGRect) {
        // set() = setFill() + setStroke()
        lineColor.set()
        pathForSkull().stroke()
//        pathForEye(.left).stroke()
//        pathForEye(.right).stroke()
        pathForMouth().stroke()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        positionEye(leftEye, center: centerOfEye(.left))
        positionEye(rightEye, center: centerOfEye(.right))
    }
    
    private func createEye() -> EyeView {
        let eye = EyeView()
        eye.isOpaque = false
        eye.color = lineColor
        eye.lineWidth = lineWidth
        addSubview(eye)
        return eye
    }
    
    private func positionEye(_ eye: EyeView, center: CGPoint) {
        let size = skullRadius / Ratios.skullRadiusToEyeRadius * 2
        eye.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: size, height: size))
        eye.center = center
    }
    
    private func pathForSkull() -> UIBezierPath {
        // 绘制路径（圆）
        let path = UIBezierPath(arcCenter: skullCenter, radius: skullRadius, startAngle: 0.0, endAngle: 2.0 * CGFloat.pi, clockwise: false)
        
        // 线宽
        path.lineWidth = lineWidth
        return path
    }
    
    private func centerOfEye(_ eye: Eye) -> CGPoint {
        let eyeOffset = skullRadius / Ratios.skullRadiusToEyeOffset
        var eyeCenter = skullCenter
        
        eyeCenter.y -= eyeOffset
        eyeCenter.x += ((eye == .left) ? -1 : 1) * eyeOffset
        
        return eyeCenter
    }
    
//    private func pathForEye(_ eye: Eye) -> UIBezierPath {
//        let eyeRadius = skullRadius / Ratios.skullRadiusToEyeRadius
//        let eyeCenter = centerOfEye(eye)
//        let path: UIBezierPath
//        
//        if eyesOpen {
//            path = UIBezierPath(arcCenter: eyeCenter, radius: eyeRadius, startAngle: 0, endAngle: 2.0 * CGFloat.pi, clockwise: false)
//        } else {
//            path = UIBezierPath()
//            path.move(to: CGPoint(x: eyeCenter.x - eyeRadius, y: eyeCenter.y))
//            path.addLine(to: CGPoint(x: eyeCenter.x + eyeRadius, y: eyeCenter.y))
//        }
//        
//        path.lineWidth = lineWidth
//        return path
//    }

    private func pathForMouth() -> UIBezierPath {
        let mouthWidth = skullRadius / Ratios.skullRadiusToMouthWidth
        let mouthHeight = skullRadius / Ratios.skullRadiusToMouthHeight
        let mouthOffset = skullRadius / Ratios.skullRadiusToMouthOffset
        
        let mouthRect = CGRect(x: skullCenter.x - mouthWidth / 2,
                               y: skullCenter.y + mouthOffset,
                               width: mouthWidth,
                               height: mouthHeight)
        
        let smileOffset = CGFloat(max(-1, min(mouthCurvature, 1))) * mouthRect.height
        
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.midY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.midY)
        
        let cp1 = CGPoint(x: start.x + mouthRect.width / 3.0, y: start.y + smileOffset)
        let cp2 = CGPoint(x: end.x - mouthRect.width / 3.0, y: end.y + smileOffset)
        
//        let path = UIBezierPath(rect: mouthRect)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    // 捏合手势放大缩小
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
}
