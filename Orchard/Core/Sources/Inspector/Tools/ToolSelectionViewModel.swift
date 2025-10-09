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
 
    internal let toolInspectorViewModel = ToolInspectorViewModel()
    internal let foliageInspectorViewModel = FoliageInspectorViewModel()
    internal let terrainInspectorViewModel = TerrainInspectorViewModel()
    
    public init() {}
}

// MARK: Tool

extension ToolSelectionViewModel {
    
    public var selectedTool: Tool {
        
        toolInspectorViewModel.selectedTool
    }
}

// MARK: Foliage

extension ToolSelectionViewModel {
    
    //
}

// MARK: Terrain

extension ToolSelectionViewModel {
    
    public var terrainType: TerrainType {
        
        terrainInspectorViewModel.terrainType
    }
}
