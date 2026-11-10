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
    public var identifier: String
    
    public init(_ triangle: Triangle,
                _ identifier: String? = nil) {
     
        self.triangle = triangle
        self.identifier = identifier ?? triangle.id
    }
    
    public var displayName: String { identifier }
    public var image: NSImage? { NSImage(icon: .triangle) }
    
    public var children: [any TreeNode]? { nil }
}
