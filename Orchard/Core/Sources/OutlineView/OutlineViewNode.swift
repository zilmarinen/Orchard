//
//  OutlineViewNode.swift
//  Core
//
//  Created by Zack Brown on 23/07/2025.
//

import AppKit
import Base

public struct OutlineViewNode: TreeNode {
    
    public let name: String
    public let image: NSImage?
    
    public var children: [any Base.TreeNode]?
    
    public let isGroup: Bool
    
    public init(name: String,
                image: NSImage? = nil,
                children: [any Base.TreeNode]? = nil,
                isGroup: Bool = false) {
        
        self.name = name
        self.image = image
        self.children = children
        self.isGroup = isGroup
    }
}
