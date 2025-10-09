//
//  ToolSelectionViewModel.swift
//  Core
//
//  Created by Zack Brown on 09/10/2025.
//

import Base
import Deltille
import Foundation
import Harvest

@MainActor
public class ToolSelectionViewModel {
    
    public private(set) var selectedTool: Tool
 
    internal let toolInspectorViewModel = ToolInspectorViewModel(selectedTool: .terrain)
    internal let terrainInspectorViewModel = TerrainInspectorViewModel(terrainType: .boreal)
    
    public init(selectedTool: Tool) {
        
        self.selectedTool = selectedTool
    }
}

// MARK: Tool

extension ToolSelectionViewModel {
    
    internal func select(tool value: Tool) {
        
        selectedTool = value
    }
}

// MARK: Terrain

extension ToolSelectionViewModel {
    
    public var terrainType: TerrainType {
        
        terrainInspectorViewModel.terrainType
    }
    
    internal func select(terrainType value: TerrainType) {
        
        terrainInspectorViewModel.select(terrainType: value)
    }
}
