//
//  ToolContainerController.swift
//  Core
//
//  Created by Zack Brown on 09/10/2025.
//

import Base
import Container

internal class ToolContainerController: ContainerViewController {
    
    internal let viewModel: ToolSelectionViewModel
    
    internal init(viewModel: ToolSelectionViewModel) {
        
        self.viewModel = viewModel
        
        super.init()
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        reload()
    }
    
    internal func reload() {
     
        switch viewModel.selectedTool {
            
        case .foliage:
            
            set(content: FoliageInspectorViewController(viewModel: viewModel.foliageInspectorViewModel))
            
        case .terrain:
            
            set(content: TerrainInspectorViewController(viewModel: viewModel.terrainInspectorViewModel))
            
        default:
            
            set(content: .init())
        }
    }
}
