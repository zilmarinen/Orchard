//
//  OutlineViewNode.swift
//  Core
//
//  Created by Zack Brown on 23/07/2025.
//

import AppKit
import Base

public struct OutlineViewNode: TreeNode {
    
    public let displayName: String
    public let image: NSImage?
    
    public var children: [any Base.TreeNode]?
    
    public let isGroup: Bool
    
    public init(displayName: String,
                image: NSImage? = nil,
                children: [any Base.TreeNode]? = nil,
                isGroup: Bool = false) {
        
        self.displayName = displayName
        self.image = image
        self.children = children
        self.isGroup = isGroup
    }
    
    public static func == (lhs: OutlineViewNode,
                           rhs: OutlineViewNode) -> Bool {
        
        lhs.displayName == rhs.displayName
    }
    
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(displayName)
    }
}
