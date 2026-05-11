//
//  WorldIntermediate.swift
//
//  Created by Zack Brown on 14/07/2025.
//

import AppKit
import Deltille

internal struct WorldIntermediate: Codable {
    
    internal let regions: [RegionIntermediate]
    internal let zones: [ZoneIntermediate]
}
