//
//  TreeNode.swift
//
//  Created by Zack Brown on 18/07/2025.
//

import AppKit
import Foundation

public protocol TreeNode: Equatable,
                          Hashable {
    
    var displayName: String { get }
    var image: NSImage? { get }
    
    var isGroup: Bool { get }
    var isLeaf: Bool { get }
    
    var children: [any TreeNode]? { get }
    var childCount: Int { get }
    
    func child(at index: Int) -> any TreeNode
    func contains(child: any TreeNode) -> Bool
}

extension TreeNode {
    
    public var isGroup: Bool { false }
    
    public var isLeaf: Bool { children?.isEmpty ?? true }
    
    public var childCount: Int { children?.count ?? 0 }
    
    public func child(at index: Int) -> any TreeNode {
     
        guard let children,
              index < childCount else { fatalError("Invalid child index") }
        
        return children[index]
    }
    
    public func contains(child: any TreeNode) -> Bool {
        
        guard let children else { return false }
        
        for node in children {
            
            if node.isEqual(to: child) {
                
                return true
            }
        }
        
        return false
    }
    
    public func isEqual<T: Equatable>(to rhs: T) -> Bool {
        
        guard let lhs = self as? T else { return false }
        
        return lhs == rhs
    }
}
