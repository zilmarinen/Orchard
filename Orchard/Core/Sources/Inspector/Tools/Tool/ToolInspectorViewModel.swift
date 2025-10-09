//
//  ToolInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 01/10/2025.
//

import Base

@MainActor
internal class ToolInspectorViewModel {
    
    private(set) var selectedTool: Tool = .terrain
}

extension ToolInspectorViewModel {
    
    internal var tools: [Tool] {
        
        Tool.allCases
    }
    
    internal func tool(at index: Int) -> Tool {
        
        tools[index]
    }
    
    internal func select(tool value: Tool) {
        
        selectedTool = value
    }
}
