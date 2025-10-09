//
//  ToolInspectorViewController.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import AppKit
import Base

internal protocol ToolInspectorDelegate: AnyObject {
    
    func toolInspectorViewController(_ inspector: ToolInspectorViewController,
                                     didSelect tool: Tool)
}

internal class ToolInspectorViewController: InspectorViewController {
    
    private lazy var toolInspector = ToolSelectionInspector(viewModel: viewModel,
                                                            delegate: self)
    
    private let viewModel: ToolInspectorViewModel
    private weak var delegate: ToolInspectorDelegate?
    
    internal init(viewModel: ToolInspectorViewModel,
                  delegate: ToolInspectorDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(toolInspector)
    }
}

extension ToolInspectorViewController: @preconcurrency ToolSelectionInspectorDelegate {
    
    internal func toolSelectionInspector(_ inspector: ToolSelectionInspector,
                                         didSelect tool: Tool) {
        
        delegate?.toolInspectorViewController(self,
                                              didSelect: tool)
    }
}
