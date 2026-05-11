//
//  RegionIntermediate.swift
//
//  Created by Zack Brown on 21/07/2025.
//

import AppKit
import Deltille
import Foundation

public class RegionIntermediate: NSObject,
                                 Codable,
                                 TreeNode {
    
    public let vertex: Triangle.Vertex
    public var identifier: String
    
    public init(_ vertex: Triangle.Vertex,
                _ identifier: String? = nil) {
     
        self.vertex = vertex
        self.identifier = identifier ?? vertex.id
    }
    
    public var displayName: String { identifier }
    public var image: NSImage? { NSImage(icon: .triangle) }
    
    public var children: [any TreeNode]? { nil }
}
