//
//  ToolInspectorViewController.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import AppKit
import Base

public protocol ToolInspectorDelegate: AnyObject {
    
    func toolInspectorViewController(_ inspector: ToolInspectorViewController,
                                     didSelect tool: Tool)
}

public class ToolInspectorViewController: InspectorViewController {
    
    private lazy var toolPanel = ToolSelectionInspector(dataSource: dataSource,
                                                        delegate: self)
    
    private let dataSource: ToolSelectionInspectorDataSource
    private weak var delegate: ToolInspectorDelegate?
    
    public init(dataSource: ToolSelectionInspectorDataSource,
                delegate: ToolInspectorDelegate) {
        
        self.dataSource = dataSource
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(toolPanel)
    }
}

extension ToolInspectorViewController: @preconcurrency ToolSelectionInspectorDelegate {
    
    func toolSelectionInspector(_ inspector: ToolSelectionInspector,
                                didSelect tool: Tool) {
        
        delegate?.toolInspectorViewController(self,
                                              didSelect: tool)
    }
}
