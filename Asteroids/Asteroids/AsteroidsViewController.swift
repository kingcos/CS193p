//
//  AsteroidsViewController.swift
//  Asteroids
//
//  Created by 买明 on 09/04/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import UIKit

class AsteroidsViewController: UIViewController {
    
    private var asteroidField: AsteroidFieldView!
    private var ship: SpaceshipView!
    private var asteroidBehavior = AsteroidBehavior()

    private lazy var animator: UIDynamicAnimator = UIDynamicAnimator(referenceView: self.asteroidField)

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        initializeIfNeeded()
        animator.addBehavior(asteroidBehavior)
        asteroidBehavior.pushAllAsteroids()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        animator.removeBehavior(asteroidBehavior)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        asteroidField?.center = view.bounds.mid
        repositionShip()
    }
    
    private func initializeIfNeeded() {
        if asteroidField == nil {
            asteroidField = AsteroidFieldView(frame: CGRect(center: view.bounds.mid,
                                                            size: view.bounds.size * Constants.asteroidFieldMagnitude))
            view.addSubview(asteroidField)
            let shipSize = view.bounds.size.minEdge * Constants.shipSizeToMinBoundsEdgeRatio
            ship = SpaceshipView(frame: CGRect(squareCenteredAt: asteroidField.center, size: shipSize))
            view.addSubview(ship)
            repositionShip()
            asteroidField.asteroidBehavior = asteroidBehavior
            asteroidField.addAsteroids(count: Constants.initialAsteroidCount,
                                       exclusionZone: ship.convert(ship.bounds, to: asteroidField))
        }
    }
    
    private func repositionShip() {
        if asteroidField != nil {
            ship.center = asteroidField.center
            asteroidBehavior.setBoundary(ship.shieldBoundary(in: asteroidField),
                                         named: Constants.shipBoundaryName) { [weak self] in
                                            if let ship = self?.ship {
                                                if !ship.shieldIsActive {
                                                    ship.shieldIsActive = true
                                                    ship.shieldLevel -= Constants.Shield.activationCost
                                                    Timer.scheduledTimer(withTimeInterval: Constants.Shield.duration,
                                                                         repeats: false) { timer in
                                                                            ship.shieldIsActive = false
                                                                            if ship.shieldLevel == 0 {
                                                                                ship.shieldLevel = 100
                                                                            }
                                                    }
                                                }
                                            }
            }
        }
    }
    
    
    @IBAction func burn(_ sender: UILongPressGestureRecognizer) {
        switch sender.state {
        case .began,.changed:
            ship.direction = (sender.location(in: view) - ship.center).angle
            burn()
        case .ended:
            endBurn()
        default: break
        }
    }
    
    private func burn() {
        ship.enginesAreFiring = true
        asteroidBehavior.acceleration.angle = ship.direction - CGFloat.pi
        asteroidBehavior.acceleration.magnitude = Constants.burnAcceleration
    }
    
    private func endBurn() {
        ship.enginesAreFiring = false
        asteroidBehavior.acceleration.magnitude = 0
    }
    
    // MARK: Constants
    
    private struct Constants {
        static let initialAsteroidCount = 20
        static let shipBoundaryName = "Ship"
        static let shipSizeToMinBoundsEdgeRatio: CGFloat = 1/5
        static let asteroidFieldMagnitude: CGFloat = 10             // as a multiple of view.bounds.size
        static let normalizedDistanceOfShipFromEdge: CGFloat = 0.2
        static let burnAcceleration: CGFloat = 0.07                 // points/s/s
        struct Shield {
            static let duration: TimeInterval = 1.0       // how long shield stays up
            static let updateInterval: TimeInterval = 0.2 // how often we update shield level
            static let regenerationRate: Double = 5       // per second
            static let activationCost: Double = 15        // per activation
            static var regenerationPerUpdate: Double
            { return Constants.Shield.regenerationRate * Constants.Shield.updateInterval }
            static var activationCostPerUpdate: Double
            { return Constants.Shield.activationCost / (Constants.Shield.duration/Constants.Shield.updateInterval) }
        }
        static let defaultShipDirection: [UIInterfaceOrientation:CGFloat] = [
            .portrait : CGFloat.up,
            .portraitUpsideDown : CGFloat.down,
            .landscapeLeft : CGFloat.right,
            .landscapeRight : CGFloat.left
        ]
        static let normalizedAsteroidFieldCenter: [UIInterfaceOrientation:CGPoint] = [
            .portrait : CGPoint(x: 0.5, y: 1.0-Constants.normalizedDistanceOfShipFromEdge),
            .portraitUpsideDown : CGPoint(x: 0.5, y: Constants.normalizedDistanceOfShipFromEdge),
            .landscapeLeft : CGPoint(x: Constants.normalizedDistanceOfShipFromEdge, y: 0.5),
            .landscapeRight : CGPoint(x: 1.0-Constants.normalizedDistanceOfShipFromEdge, y: 0.5),
            .unknown : CGPoint(x: 0.5, y: 0.5)
        ]
    }

}

