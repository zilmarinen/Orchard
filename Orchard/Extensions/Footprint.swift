//
//  Footprint.swift
//
//  Created by Zack Brown on 17/03/2021.
//

import Foundation
import Meadow
//TODO: delete this once footprints are loaded from prop model files
extension Footprint {
    
    init(coordinate: Coordinate, rotation: Cardinal, size: Int) {
        
        var nodes: [Coordinate] = []
        
        for x in 0..<size {
            
            for z in 0..<size {
                
                nodes.append(Coordinate(x: x, y: coordinate.y, z: z))
            }
        }
        
        self.init(coordinate: coordinate, rotation: rotation, nodes: nodes)
    }
    
    init(coordinate: Coordinate, rotation: Cardinal, size: CGSize) {
        
        var nodes: [Coordinate] = []
        
        for x in 0..<Int(size.width) {
            
            for z in 0..<Int(size.height) {
                
                nodes.append(Coordinate(x: x, y: coordinate.y, z: z))
            }
        }
        
        self.init(coordinate: coordinate, rotation: rotation, nodes: nodes)
    }
}
