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
    
    public let triangle: Triangle
    public var identifier: String?
    
    public init(triangle: Triangle) {
     
        self.triangle = triangle
    }
    
    public var displayName: String { identifier ?? triangle.id }
    public var image: NSImage? { NSImage(image: .triangle) }
    
    public var children: [any TreeNode]? { nil }
}
