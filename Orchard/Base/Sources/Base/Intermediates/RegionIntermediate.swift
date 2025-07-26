//
//  RegionIntermediate.swift
//  Base
//
//  Created by Zack Brown on 21/07/2025.
//

import AppKit
import Deltille
import Foundation

public class RegionIntermediate: NSObject,
                                 Codable,
                                 TreeNode {
    
    public let coordinate: Coordinate
    public var identifier: String?
    
    public init(coordinate: Coordinate) {
     
        self.coordinate = coordinate
    }
    
    public var name: String { identifier ?? coordinate.id }
    public var image: NSImage? { NSImage(image: .triangle) }
    
    public var children: [Any]? { nil }
}
