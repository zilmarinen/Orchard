//
//  CGPoint.swift
//  Base
//
//  Created by Zack Brown on 09/10/2025.
//

import Euclid
import Foundation

extension CGPoint {
    
    internal init(_ vector: Vector) {
        
        self.init(x: vector.x,
                  y: vector.z)
    }
}
