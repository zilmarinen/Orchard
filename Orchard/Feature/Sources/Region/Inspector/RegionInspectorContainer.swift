//
//  RegionInspectorContainer.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base
import Inspector

internal protocol RegionInspectorContainerDelegate: AnyObject {}

internal class RegionInspectorContainer: InspectorViewController {
    
    private lazy var toolInspector = ToolSelectionInspector(viewModel: viewModel.toolInspectorViewModel,
                                                            delegate: self)
    
    private lazy var footpathInspector = FootpathInspector(viewModel: viewModel.footpathInspectorViewModel)
    private lazy var foliageInspector = FoliageInspector(viewModel: viewModel.foliageInspectorViewModel)
    
    private lazy var terrainInspector = TerrainInspector(viewModel: viewModel.terrainInspectorViewModel)
    private lazy var waterInspector = WaterInspector(viewModel: viewModel.waterInspectorViewModel)
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionInspectorContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionInspectorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        reload()
    }
    
    private func reload() {
        
        removeAllArrangedSubviews()
        
        addArrangedSubview(toolInspector)
        
        switch viewModel.tool {
            
        case .foliage: addArrangedSubview(foliageInspector)
        case .footpaths: addArrangedSubview(footpathInspector)
        case .terrain: addArrangedSubview(terrainInspector)
        case .water: addArrangedSubview(waterInspector)
            
        default: break
        }
    }
}

extension RegionInspectorContainer: @preconcurrency ToolSelectionInspectorDelegate {
    
    func toolSelectionInspector(_ inspector: ToolSelectionInspector,
                                didSelect tool: Tool) {
        
        reload()
    }
}
