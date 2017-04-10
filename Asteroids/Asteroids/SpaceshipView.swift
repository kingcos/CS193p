//
//  SpaceshipView.swift
//  Asteroids
//
//  Created by CS193p Instructor.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

class SpaceshipView: UIView
{
    // MARK: Public API
    
    var enginesAreFiring = false { didSet { if !exploding { resetShipImage() } } }
    var direction: CGFloat = 0 { didSet { updateDirection() } }
    var shieldLevel: Double = 100 { didSet { shieldLevel = min(max(shieldLevel, 0), 100); shieldLevelChanged() } }
    var shieldIsActive = false { didSet { setNeedsDisplay() } }

    func shieldBoundary(in view: UIView) -> UIBezierPath { return getShieldPath(in: view) }
    
    // MARK: Private Implementation
    
    private struct Constants {
        static let explosionDuration: TimeInterval = 1.5
        static let explosionToFadeRatio: Double = 1/4
        static let shieldActiveLinewidthRatio: CGFloat = 3
        static let shipImage = UIImage(named: "ship")
        static let shipWithEnginesFiringImage = UIImage(named: "shipfiring")
        static let explosionImage = UIImage.animatedImageNamed("explosion", duration: 1.5)
    }
    
    private var shieldLinewidth: CGFloat = 1.0 { didSet { setNeedsDisplay() } }
    private let imageView = UIImageView(image: Constants.shipImage)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        resetShipImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        resetShipImage()
    }
    
    private func resetShipImage() {
        imageView.isHidden = (shieldLevel == 0)
        if imageView.superview == nil {
            isOpaque = false
            addSubview(imageView)
        }
        imageView.image = enginesAreFiring ? Constants.shipWithEnginesFiringImage : Constants.shipImage
        updateImageViewFrame()
        updateDirection()
        imageView.alpha = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageViewFrame()
    }
    
    private func updateImageViewFrame() {
        if !exploding && imageView.transform == CGAffineTransform.identity {
            imageView.frame = bounds
        }
    }
    
    private func updateDirection() {
        if !exploding {
            imageView.transform = CGAffineTransform.identity.rotated(by: direction)
        }
    }
    
    private func shieldLevelChanged() {
        if !exploding {
            if shieldLevel == 0 && !imageView.isHidden {
                explode()
            } else {
                imageView.isHidden = (shieldLevel == 0)
                setNeedsDisplay()
            }
        }
    }

    // MARK: Drawing

    private var shieldColor: UIColor {
        let red: CGFloat = shieldLevel < 50 ? 1 : 0
        let green: CGFloat = shieldLevel > 25 ? 1 : 0
        return UIColor(red: red, green: green, blue: 0, alpha: 1)
    }
    
    private func getShieldPath(level: Double = 100, in view: UIView? = nil) -> UIBezierPath {
        var middle = CGPoint(x: bounds.midX, y: bounds.midY)
        if view != nil { middle = self.convert(middle, to: view) }
        let radius = min(bounds.size.width, bounds.size.height) / 2 - shieldLinewidth
        let startAngle = -CGFloat.pi/2
        let endAngle = -CGFloat.pi/2 + CGFloat(level)/100 * CGFloat.pi*2
        let path = UIBezierPath(arcCenter: middle, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        path.lineWidth = shieldLinewidth * (shieldIsActive ? Constants.shieldActiveLinewidthRatio : 1)
        return path
    }
    
    override func draw(_ rect: CGRect) {
        if shieldLevel > 0 && shieldLevel < 100 && !exploding {
            UIColor.lightGray.setStroke()
            getShieldPath().stroke()
            shieldColor.setStroke()
            getShieldPath(level: shieldLevel).stroke()
        }
    }
    
    // MARK: Exploding
    
    private var exploding: Bool {
        return imageView.image == Constants.explosionImage
    }
    
    private func explode() {
        imageView.image = Constants.explosionImage
        imageView.transform = CGAffineTransform.identity
        imageView.startAnimating()
        setNeedsDisplay()

        let smallerFrame = imageView.frame.insetBy(dx: imageView.bounds.size.width * 0.30, dy: imageView.bounds.size.height * 0.30)
        let biggerFrame = imageView.frame.insetBy(dx: -imageView.bounds.size.width * 0.15, dy: -imageView.bounds.size.height * 0.15)
        imageView.frame = smallerFrame
        let explodeTime = Constants.explosionDuration * Constants.explosionToFadeRatio
        UIView.animate(withDuration: explodeTime, animations: { [imageView = self.imageView] in
            imageView.frame = biggerFrame
        }, completion: { [imageView = self.imageView] finished in
            UIView.animate(withDuration: Constants.explosionDuration - explodeTime, animations: {
                imageView.alpha = 0
                imageView.frame = smallerFrame
            }, completion: { finished in
                self.resetShipImage()
            })
        })
    }
}
