//
//  Array.swift
//  Base
//
//  Created by Zack Brown on 06/08/2025.
//

extension Array where Element == any TreeNode {
    
    public func parent(for child: Element) -> Element? {
        
        for node in self {
            
            if node.contains(child: child) {
                
                return node
            }
            
            if let parent = node.children?.parent(for: child) {
                
                return parent
            }
        }
        
        return nil
    }
}
