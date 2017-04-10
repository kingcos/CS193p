//
//  CoreGraphicsExtensions.swift
//  Asteroids
//
//  Created by CS193p Instructor.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import CoreGraphics

extension CGFloat {
    static func random(in range: Range<CGFloat>) -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UInt32.max)*(range.upperBound-range.lowerBound)+range.lowerBound
    }
    static let up = -CGFloat.pi/2
    static let down = CGFloat.pi/2
    static let left = CGFloat.pi
    static let right: CGFloat = 0
}

extension CGSize {
    static func square(_ size: CGFloat) -> CGSize {
        return CGSize(width: size, height: size)
    }
    
    static func *(_ size: CGSize, by: CGFloat) -> CGSize {
        return CGSize(width: size.width * sqrt(by), height: size.height * sqrt(by))
    }
    
    static func /(_ size: CGSize, by: CGFloat) -> CGSize {
        return CGSize(width: size.width / sqrt(by), height: size.height / sqrt(by))
    }
    
    var minEdge: CGFloat { return min(width, height) }
    
    var area: CGFloat { return width * height }
}

extension CGRect
{
    var mid: CGPoint { return CGPoint(x: midX, y: midY) }
    
    init(squareCenteredAt center: CGPoint, size: CGFloat) {
        let origin = CGPoint(x: center.x - size / 2, y: center.y - size / 2)
        self.init(origin: origin, size: CGSize.square(size))
    }
    
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x-size.width/2, y: center.y-size.height/2), size: size)
    }
    
    var randomPoint: CGPoint {
        return CGPoint(x: CGFloat.random(in: 0..<size.width), y: CGFloat.random(in: 0..<size.height))
    }
}

extension CGPoint {
    func denormalized(in rect: CGRect) -> CGPoint {
        return CGPoint(x: rect.origin.x + x * rect.size.width, y: rect.origin.y + y * rect.size.height)
    }
    
    static func -(left: CGPoint, right: CGPoint) -> CGVector {
        return CGVector(dx: left.x-right.x, dy: left.y-right.y)
    }
}

extension CGVector
{
    var angle: CGFloat {
        let angle = atan(abs(dy)/abs(dx))
        if dx > 0 && dy < 0 {
            return -angle
        } else if dx < 0 && dy < 0 {
            return -CGFloat.pi + angle
        } else if dx > 0 && dy > 0 {
            return -CGFloat.pi*2 + angle
        } else if dx < 0 && dy > 0 {
            return -CGFloat.pi - angle
        } else if dx < 0 && dy == 0 {
            return -CGFloat.pi
        } else if dx == 0 && dy < 0 {
            return -CGFloat.pi/2
        } else if dx == 0 && dy > 0 {
            return -3*CGFloat.pi/2
        } else {
            return 0
        }
    }
}
