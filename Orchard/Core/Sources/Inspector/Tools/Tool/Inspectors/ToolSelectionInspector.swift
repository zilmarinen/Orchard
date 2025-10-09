//
//  ToolSelectionInspector.swift
//  Core
//
//  Created by Zack Brown on 01/10/2025.
//

import AppKit
import Base

internal protocol ToolSelectionInspectorDelegate: AnyObject {
    
    func toolSelectionInspector(_ inspector: ToolSelectionInspector,
                                didSelect tool: Tool)
}

internal class ToolSelectionInspector: InspectorStackView {
    
    private lazy var toolPopUp = with(NSPopUpButton(title: "Tool",
                                                    target: self,
                                                    action: #selector(popUpButton(_:)))) {
        
        $0.addItems(withTitles: viewModel.tools.map { $0.id })
        $0.selectItem(withTitle: viewModel.selectedTool.id)
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private let viewModel: ToolInspectorViewModel
    private weak var delegate: ToolSelectionInspectorDelegate?
    
    internal required init(viewModel: ToolInspectorViewModel,
                           delegate: ToolSelectionInspectorDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(title: "Tools")
        
        addArrangedSubview(toolPopUp)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ToolSelectionInspector {
    
    @objc
    internal func popUpButton(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case toolPopUp:
            
            let tool = viewModel.tool(at: sender.indexOfSelectedItem)
            
            viewModel.select(tool: tool)
            
            delegate?.toolSelectionInspector(self,
                                             didSelect: viewModel.selectedTool)
            
        default: fatalError("Invalid sender for button action")
        }
    }
}
