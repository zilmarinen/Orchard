//
//  ZoneIntermediate.swift
//
//  Created by Zack Brown on 26/07/2025.
//

import AppKit
import Deltille
import Foundation

public class ZoneIntermediate: NSObject,
                               Codable,
                               TreeNode {
    
    public let coordinate: Coordinate
    public var identifier: String?
    
    public init(coordinate: Coordinate) {
     
        self.coordinate = coordinate
    }
    
    public var displayName: String { identifier ?? coordinate.id }
    public var image: NSImage? { NSImage(image: .triangle) }
    
    public var children: [any TreeNode]? { nil }
}
