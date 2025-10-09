//
//  RegionInspectorContainer.swift
//  Feature
//
//  Created by Zack Brown on 30/07/2025.
//

import Base
import Container
import Inspector

internal protocol RegionInspectorContainerDelegate: AnyObject {}

internal class RegionInspectorContainer: ContainerViewController {
    
    private lazy var toolSelectionContainer = ToolSelectionContainer(viewModel: viewModel.toolSelectionViewModel)
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionInspectorContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionInspectorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        set(content: toolSelectionContainer)
    }
}
