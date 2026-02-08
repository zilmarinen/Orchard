//
//  ToolOptionsViewModel.swift
//  Core
//
//  Created by Zack Brown on 08/02/2026.
//

import Base
import Harvest

@MainActor
public class ToolOptionsViewModel {
    
    private(set) public var biome: Biome = .boreal
    
    private(set) public var tool: Tool
    private(set) public var cursorStyle: CursorStyle = .vertex
    
    public init(tool: Tool) {
        
        self.tool = tool
    }
}

extension ToolOptionsViewModel {
    
    // MARK: Tool
    
    public func select(tool value: Tool) {
        
        self.tool = value
    }
    
    // MARK: Cursor
    
    public var cursorStyles: [CursorStyle] {
        
        [.vertex,
         .triangle,
         .hexagonal]
    }
    
    public func select(cursorStyle value: CursorStyle) {
        
        self.cursorStyle = value
    }
    
    // MARK: Biome
    
    internal func select(biome value: Biome) {
        
        self.biome = value
    }
}
