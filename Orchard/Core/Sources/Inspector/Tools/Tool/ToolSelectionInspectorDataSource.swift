//
//  ToolSelectionInspectorDataSource.swift
//  Core
//
//  Created by Zack Brown on 01/10/2025.
//

import Base

public protocol ToolSelectionInspectorDataSource: AnyObject {
    
    var selectedTool: Tool { get }
    
    var tools: [Tool] { get }
    
    func tool(at index: Int) -> Tool
}

@MainActor
open class ToolInspectorViewModel {
    
    private(set) var selectedTool: Tool
    
    public init(selectedTool: Tool) {
        
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
