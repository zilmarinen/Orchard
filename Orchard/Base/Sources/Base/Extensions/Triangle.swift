//
//  Triangle.swift
//  Base
//
//  Created by Zack Brown on 15/05/2026.
//

import Deltille
import Euclid

extension Triangle {

    public struct HitTest {
        
        public let pointInWorld: Vector
        public let triangle: Triangle
        public let vertex: Triangle.Vertex
        
        public init(_ pointInWorld: Vector,
                    _ scale: Triangle.Scale) {
            
            let triangle = Triangle(pointInWorld,
                                    scale)
            
            self.pointInWorld = pointInWorld
            self.triangle = triangle
            self.vertex = triangle.closest(pointInWorld,
                                           scale)
        }
    }
}
