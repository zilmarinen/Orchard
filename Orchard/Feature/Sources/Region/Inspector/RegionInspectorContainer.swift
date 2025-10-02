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

internal class RegionInspectorContainer: StackContainerViewController {
    
    private lazy var toolSelectionController = ToolInspectorViewController(dataSource: viewModel,
                                                                           delegate: self)
    
    private lazy var toolSelectionContainer = ToolSelectionContainer(dataSource: viewModel,
                                                                     delegate: self)
    
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
        
        insert(viewController: toolSelectionController)
        insert(viewController: toolSelectionContainer)
    }
}

extension RegionInspectorContainer: @preconcurrency ToolInspectorDelegate {
    
    func toolInspectorViewController(_ inspector: ToolInspectorViewController,
                                     didSelect tool: Tool) {
        
        viewModel.select(tool: tool)
        
        toolSelectionContainer.reload()
    }
}

extension RegionInspectorContainer: @preconcurrency ToolSelectionContainerDelegate {}
