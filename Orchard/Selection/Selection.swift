//
//  Selection.swift
//  Orchard
//
//  Created by Zack Brown on 22/12/2020.
//

import Meadow

struct Selection {
    
    let start: Coordinate
    let end: Coordinate
    
    init(start: Coordinate, end: Coordinate) {
        
        let minimumX = min(start.x, end.x)
        let minimumZ = min(start.z, end.z)
        let maximumX = max(start.x, end.x)
        let maximumZ = max(start.z, end.z)
        
        self.start = Coordinate(x: minimumX, y: start.y, z: minimumZ)
        self.end = Coordinate(x: maximumX, y: end.y, z: maximumZ)
    }
}
