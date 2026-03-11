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
    
    public let origin: Triangle.Vertex
    public var identifier: String?
    
    public init(origin: Triangle.Vertex) {
     
        self.origin = origin
    }
    
    public var displayName: String { identifier ?? origin.id }
    public var image: NSImage? { NSImage(icon: .triangle) }
    
    public var children: [any TreeNode]? { nil }
}
