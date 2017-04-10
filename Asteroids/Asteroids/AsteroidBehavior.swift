//
//  AsteroidBehavior.swift
//  Asteroids
//
//  Created by 买明 on 09/04/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class AsteroidBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    var speedLimit: CGFloat = 300.0
    
    private var asteroids = [AsteroidView]()
    private var collisionHandlers = [String : (Void) -> Void]()
    
    private lazy var collider: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
//        behavior.collisionMode = .everything
        behavior.collisionMode = .boundaries
//        behavior.translatesReferenceBoundsIntoBoundary = true
        behavior.collisionDelegate = self
        return behavior
    }()
    
    private lazy var physics: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1
        behavior.allowsRotation = true
        behavior.friction = 0
        behavior.resistance = 0
        return behavior
    }()
    
    lazy var acceleration: UIGravityBehavior = {
        let behavior = UIGravityBehavior()
        behavior.magnitude = 0
        return behavior
    }()
    
    override init() {
        super.init()
        
        addChildBehavior(collider)
        addChildBehavior(physics)
        addChildBehavior(acceleration)
        
        physics.action = { [weak self] in
            for asteroid in self?.asteroids ?? [] {
                let velocity = self!.physics.linearVelocity(for: asteroid)
                let excessHorizontalVelocity = min(self!.speedLimit - velocity.x, 0)
                let excessVerticalVelocity = min(self!.speedLimit - velocity.y, 0)
                self!.physics.addLinearVelocity(CGPoint(x: excessHorizontalVelocity, y: excessVerticalVelocity), for: asteroid)
            }
        }
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if let name = identifier as? String,
            let handler = collisionHandlers[name] {
            handler()
        }
    }
    
    func addAsteroid(_ asteroid: AsteroidView) {
        asteroids.append(asteroid)
        collider.addItem(asteroid)
        physics.addItem(asteroid)
        acceleration.addItem(asteroid)
        startRecapturingWaywardAsteroids()
    }
    
    func removeAsteroid(_ asteroid: AsteroidView) {
        if let index = asteroids.index(of: asteroid) {
            asteroids.remove(at: index)
        }
        collider.removeItem(asteroid)
        physics.removeItem(asteroid)
        acceleration.removeItem(asteroid)
        if asteroids.isEmpty {
            stopRecapturingWaywardAsteroids()
        }
    }
    
    func pushAllAsteroids(by magnitude: Range<CGFloat> = 0..<0.5) {
        for asteroid in asteroids {
            let pusher = UIPushBehavior(items: [asteroid], mode: .instantaneous)
            pusher.magnitude = CGFloat.random(in: magnitude)
            pusher.angle = CGFloat.random(in: 0..<CGFloat.pi * 2)
            pusher.action = { [unowned pusher] in
                pusher.dynamicAnimator?.removeBehavior(pusher)
            }
            addChildBehavior(pusher)
        }
    }
    
    func setBoundary(_ path: UIBezierPath?, named name: String, handler: ((Void) -> Void)?) {
        collider.removeBoundary(withIdentifier: name as NSString)
        collisionHandlers[name] = nil
        if path != nil {
            collider.addBoundary(withIdentifier: name as NSString, for: path!)
            collisionHandlers[name] = handler
        }
    }
    
    var recaptureCount = 0
    private weak var recaptureTimer: Timer?
    
    private func startRecapturingWaywardAsteroids() {
        if recaptureTimer == nil {
            recaptureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
                for asteroid in self?.asteroids ?? [] {
                    if let asteroidFieldBounds = asteroid.superview?.bounds, !asteroidFieldBounds.contains(asteroid.center) {
                        asteroid.center.x = asteroid.center.x.truncatingRemainder(dividingBy: asteroidFieldBounds.width)
                        if asteroid.center.x < 0 { asteroid.center.x += asteroidFieldBounds.width }
                        asteroid.center.y = asteroid.center.y.truncatingRemainder(dividingBy: asteroidFieldBounds.height)
                        if asteroid.center.y < 0 { asteroid.center.y += asteroidFieldBounds.height }
                        self?.dynamicAnimator?.updateItem(usingCurrentState: asteroid)
                        self?.recaptureCount += 1
                    }
                }
            }
        }
    }
    
    private func stopRecapturingWaywardAsteroids() {
        recaptureTimer?.invalidate()
    }
}
