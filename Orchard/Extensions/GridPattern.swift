//
//  GridPattern.swift
//
//  Created by Zack Brown on 12/05/2021.
//

import Harvest
import Meadow

extension GridPattern where T == Tile2D? {
    
    var count: Int {
        
        return (north == nil ? 0 : 1) +
                (east == nil ? 0 : 1) +
                (south == nil ? 0 : 1) +
                (west == nil ? 0 : 1) +
                (northEast == nil ? 0 : 1) +
                (northWest == nil ? 0 : 1) +
                (southWest == nil ? 0 : 1) +
                (southEast == nil ? 0 : 1)
    }
}
