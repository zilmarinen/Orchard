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
        
        $0.addItems(withTitles: dataSource.tools.map { $0.id })
        $0.selectItem(withTitle: dataSource.selectedTool.id)
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private let dataSource: ToolSelectionInspectorDataSource
    private weak var delegate: ToolSelectionInspectorDelegate?
    
    internal required init(dataSource: ToolSelectionInspectorDataSource,
                           delegate: ToolSelectionInspectorDelegate) {
        
        self.dataSource = dataSource
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
            
            delegate?.toolSelectionInspector(self,
                                             didSelect: dataSource.tool(at: sender.indexOfSelectedItem))
            
        default: fatalError("Invalid sender for button action")
        }
    }
}
