//
//  TreeNode.swift
//  Base
//
//  Created by Zack Brown on 18/07/2025.
//

import AppKit
import Foundation

public protocol TreeNode {
    
    associatedtype Child = TreeNode
    
    var name: String { get }
    var image: NSImage? { get }
    
    var isGroup: Bool { get }
    var isLeaf: Bool { get }
    
    var children: [Child]? { get }
    var childCount: Int { get }
    
    func child(at index: Int) -> Child
}

extension TreeNode {
    
    public var isGroup: Bool { false }
    
    public var isLeaf: Bool { children?.isEmpty ?? true }
    
    public var childCount: Int { children?.count ?? 0 }
    
    public func child(at index: Int) -> Child {
     
        guard let children else { fatalError("Invalid child index") }
        
        return children[index]
    }
}
