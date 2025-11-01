//
//  ToolSelectionInspector.swift
//
//  Created by Zack Brown on 01/10/2025.
//

import AppKit
import Base

public protocol ToolSelectionInspectorDelegate: AnyObject {
    
    func toolSelectionInspector(_ inspector: ToolSelectionInspector,
                                didSelect tool: Tool)
}

public class ToolSelectionInspector: InspectorStackView {
    
    private lazy var toolPopUp = with(NSPopUpButton(title: "Tool",
                                                    target: self,
                                                    action: #selector(popUpButton(_:)))) {
        
        $0.addItems(withTitles: viewModel.tools.map { $0.id })
        $0.selectItem(withTitle: viewModel.tool.id)
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private lazy var cursorStyleSegmentedControl = with(NSSegmentedControl(images: viewModel.cursorStyles.compactMap { $0.image },
                                                                           trackingMode: .selectOne,
                                                                           target: self,
                                                                           action: #selector(segmentedControl(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.toolTip = "Cursor Style"
        $0.setSelected(true,
                       forSegment: viewModel.cursorStyle(index: viewModel.cursorStyle))
    }
    
    private let viewModel: ToolInspectorViewModel
    private weak var delegate: ToolSelectionInspectorDelegate?
    
    public required init(viewModel: ToolInspectorViewModel,
                         delegate: ToolSelectionInspectorDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(title: "Tools",
                   accentColor: .systemGray)
        
        addArrangedSubview(toolPopUp)
        addArrangedSubview(cursorStyleSegmentedControl)
        
        reload()
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func reload() {
        
        for index in viewModel.cursorStyles.indices {
            
            let cursorStyle = viewModel.cursorStyles[index]
            let allowed = viewModel.allowedCursorStyles.contains(cursorStyle)
            let selected = viewModel.cursorStyle == cursorStyle
            
            cursorStyleSegmentedControl.setToolTip(cursorStyle.id,
                                                   forSegment: index)
            
            cursorStyleSegmentedControl.setEnabled(allowed,
                                                   forSegment: index)
            
            cursorStyleSegmentedControl.setSelected(selected,
                                                    forSegment: index)
        }
    }
}

extension ToolSelectionInspector {
    
    @objc
    internal func segmentedControl(_ sender: NSSegmentedControl) {
     
        switch sender {
            
        case cursorStyleSegmentedControl:
            
            let cursorStyle = viewModel.cursorStyle(at: sender.indexOfSelectedItem)
            
            viewModel.select(cursorStyle: cursorStyle)
            
        default: break
        }
    }
    
    @objc
    internal func popUpButton(_ sender: NSPopUpButton) {
        
        switch sender {
            
        case toolPopUp:
            
            let tool = viewModel.tool(at: sender.indexOfSelectedItem)
            
            viewModel.select(tool: tool)
            
            delegate?.toolSelectionInspector(self,
                                             didSelect: viewModel.tool)
            
            reload()
            
        default: break
        }
    }
}
