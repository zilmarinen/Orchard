//
//  ToolOptionsContainer.swift
//  Core
//
//  Created by Zack Brown on 07/02/2026.
//

import AppKit
import Base
import Container
import Design

public class ToolOptionsContainer: ContainerViewController {
 
    internal let viewModel: ToolOptionsViewModel
    
    public init(viewModel: ToolOptionsViewModel) {
        
        self.viewModel = viewModel
        
        super.init()
        
        switch viewModel.tool {
            
        case .buildings: set(content: BuildingToolOptionsContainer(viewModel: viewModel))
        case .foliage: set(content: FoliageToolOptionsContainer(viewModel: viewModel))
        case .footpaths: set(content: FootpathToolOptionsContainer(viewModel: viewModel))
        case .portals: set(content: PortalToolOptionsContainer(viewModel: viewModel))
        case .staircases: set(content: StaircaseToolOptionsContainer(viewModel: viewModel))
        case .terrain: set(content: TerrainToolOptionsContainer(viewModel: viewModel))
        case .water: set(content: WaterToolOptionsContainer(viewModel: viewModel))
        default: set(content: EmptyViewController(text: viewModel.tool.id))
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
