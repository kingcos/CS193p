//
//  FacialExpression.swift
//  FaceIt
//
//  Created by 买明 on 25/02/2017.
//  Copyright © 2017 买明. All rights reserved.
//

import Foundation

struct FacialExpression {
    
    let eyes: Eyes
    let mouth: Mouth
    
    enum Eyes: Int {
        case open
        case closed
        // 眯着眼
        case squinting
    }
    
    enum Mouth: Int {
        // ☹️ 0
        case frown
        // 😠 1
        case smirk
        // 😐 2
        case neutral
        // 😁 3
        case grin
        // 😊 4
        case smile
        
        var sadder: Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .frown
        }
        
        var happier: Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .smile
        }
    }
    
    var sadder: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.sadder)
    }
    
    var happier: FacialExpression {
        return FacialExpression(eyes: self.eyes, mouth: self.mouth.happier)
    }
    
}
