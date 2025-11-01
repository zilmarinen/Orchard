//
//  ToolInspectorViewModel.swift
//
//  Created by Zack Brown on 01/10/2025.
//

import Base
import Harvest

@MainActor
public class ToolInspectorViewModel {
    
    public private(set) var tool: Tool = .terrain
    
    public private(set) var cursorStyle: CursorStyle = .vertex
    
    public init() {}
}

extension ToolInspectorViewModel {
    
    // MARK: Tool
    
    internal var tools: [Tool] {
        
        Tool.allCases
    }
    
    internal func tool(at index: Int) -> Tool {
        
        tools[index]
    }
    
    internal func select(tool value: Tool) {
        
        tool = value
        
        guard !allowedCursorStyles.contains(cursorStyle),
              let value = allowedCursorStyles.first else { return }
        
        select(cursorStyle: value)
    }
    
    // MARK: Cursor Style
    
    internal var cursorStyles: [CursorStyle] {
        
        CursorStyle.allCases
    }
    
    internal var allowedCursorStyles: [CursorStyle] {
        
        switch tool {
            
        case .terrain: CursorStyle.allCases
            
        case .foliage: [.triangle]
    
        case .water: [.hexagonal,
                      .triangle]
            
        default: [.vertex]
        }
    }
    
    internal func cursorStyle(index value: CursorStyle) -> Int {
        
        cursorStyles.firstIndex(of: value) ?? 0
    }
    
    internal func cursorStyle(at index: Int) -> CursorStyle {
        
        cursorStyles[index]
    }
    
    internal func select(cursorStyle value: CursorStyle) {
        
        cursorStyle = value
    }
}
