//
//  RandFunc.swift
//  FlappyBird
//
//  Created by Edward Chien on 1/3/20.
//  Copyright © 2020 Edward Chien. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat{
    
    static func random() -> CGFloat{
        
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    static func random(min : CGFloat, max: CGFloat) -> CGFloat{
        return CGFloat.random() * (max-min) + min
    }
    
}
