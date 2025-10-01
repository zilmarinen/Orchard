//
//  ToolInspectorViewModel.swift
//  Core
//
//  Created by Zack Brown on 01/10/2025.
//

import Base

@MainActor
internal class ToolInspectorViewModel {
    
    private(set) var selectedTool: Tool
    
    internal init(selectedTool: Tool) {
        
        self.selectedTool = selectedTool
    }
}

extension ToolInspectorViewModel {
    
    internal var tools: [Tool] {
        
        Tool.allCases
    }
    
    internal func tool(at index: Int) -> Tool {
        
        .allCases[index]
    }
}
