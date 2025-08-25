//
//  WorldIntermediate.swift
//  Base
//
//  Created by Zack Brown on 14/07/2025.
//

import AppKit
import Deltille

internal struct WorldIntermediate: Codable {
    
    internal let regions: [Grid.Coordinate]
    internal let zones: [Grid.Coordinate]
}
