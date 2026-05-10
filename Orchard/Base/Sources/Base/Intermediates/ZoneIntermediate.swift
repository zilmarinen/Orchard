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
    
    public let vertex: Triangle.Vertex
    public var identifier: String?
    
    public init(vertex: Triangle.Vertex) {
     
        self.vertex = vertex
    }
    
    public var displayName: String { identifier ?? vertex.id }
    public var image: NSImage? { NSImage(icon: .triangle) }
    
    public var children: [any TreeNode]? { nil }
}
