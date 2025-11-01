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
    
    public var tool: Tool {
        
        toolInspectorViewModel.tool
    }
    
    public var cursorStyle: CursorStyle {
        
        toolInspectorViewModel.cursorStyle
    }
}

// MARK: Foliage

extension ToolSelectionViewModel {
    
    //
}

// MARK: Terrain

extension ToolSelectionViewModel {
    
    public var biome: Biome {
        
        terrainInspectorViewModel.biome
    }
    
    public var sculpt: Bool {
        
        terrainInspectorViewModel.sculpt
    }
    
    public var paint: Bool {
        
        terrainInspectorViewModel.paint
    }
}
