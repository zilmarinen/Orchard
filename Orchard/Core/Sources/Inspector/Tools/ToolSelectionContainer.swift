//
//  ToolSelectionContainer.swift
//  Core
//
//  Created by Zack Brown on 09/10/2025.
//

import Base
import Container

public class ToolSelectionContainer: StackContainerViewController {
    
    private lazy var toolInspectorController = ToolInspectorViewController(viewModel: viewModel.toolInspectorViewModel,
                                                                           delegate: self)
    
    private lazy var toolContainerController = ToolContainerController(viewModel: viewModel)
    
    private let viewModel: ToolSelectionViewModel
    
    public init(viewModel: ToolSelectionViewModel) {
        
        self.viewModel = viewModel
        
        super.init()
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        insert(viewController: toolInspectorController)
        insert(viewController: toolContainerController)
    }
}

extension ToolSelectionContainer: @preconcurrency ToolInspectorDelegate {
    
    internal func toolInspectorViewController(_ inspector: ToolInspectorViewController,
                                              didSelect tool: Tool) {
        
        toolContainerController.reload()
    }
}
