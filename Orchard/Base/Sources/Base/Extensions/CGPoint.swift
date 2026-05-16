//
//  CGPoint.swift
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

extension CGPoint {
    
    public static func +(lhs: Self,
                         rhs: Self) -> Self {
        
        .init(x: lhs.x + rhs.x,
              y: lhs.y + rhs.y)
    }
    
    public static func +=(lhs: inout Self,
                          rhs: Self) {
        
        lhs = lhs + rhs
    }
    
    public static func -(lhs: Self,
                         rhs: Self) -> Self {
        
        .init(x: lhs.x - rhs.x,
              y: lhs.y - rhs.y)
    }
    
    public static func *(lhs: Self,
                         rhs: Double) -> Self {
        
        .init(x: lhs.x * rhs,
              y: lhs.y * rhs)
    }
    
    public static func /(lhs: Self,
                         rhs: Double) -> Self {
        
        .init(x: lhs.x / rhs,
              y: lhs.y / rhs)
    }
}

extension CGPoint {
    
    public var length: CGFloat {
        
        sqrt(x * x + y * y)
    }
    
    public func normalized() -> Self {
        
        let l = length
        
        guard l > 0.0 else { return .zero }
        
        return .init(x: x / length,
                     y: y / length)
    }
}
