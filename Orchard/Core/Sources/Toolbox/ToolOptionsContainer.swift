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

public protocol ToolOptionsContainerDelegate: AnyObject {}

public class ToolOptionsContainer: ContainerViewController {
 
    internal let viewModel: ToolOptionsViewModel
    internal weak var delegate: ToolOptionsContainerDelegate?
    
    public init(viewModel: ToolOptionsViewModel,
                delegate: ToolOptionsContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
        
        switch viewModel.tool {
            
        case .buildings: self.content = BuildingToolOptionsContainer(viewModel: viewModel)
        case .foliage: self.content = FoliageToolOptionsContainer(viewModel: viewModel)
        case .footpaths: self.content = FootpathToolOptionsContainer(viewModel: viewModel)
        case .staircases: self.content = StaircaseToolOptionsContainer(viewModel: viewModel)
        case .terrain: self.content = TerrainToolOptionsContainer(viewModel: viewModel)
        case .water: self.content = WaterToolOptionsContainer(viewModel: viewModel)
        default: self.content = EmptyViewController(text: viewModel.tool.id)
        }
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
