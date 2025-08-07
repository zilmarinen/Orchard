//
//  RegionActionsInspector.swift
//  Core
//
//  Created by Zack Brown on 07/08/2025.
//

import AppKit
import Base

internal protocol RegionActionsInspectorDelegate: AnyObject {
    
    func regionActionsInspector(_ inspector: RegionActionsInspector,
                                didRequestDeletionFor selection: Document.Selection)
    
    func regionActionsInspector(_ inspector: RegionActionsInspector,
                                didRequestEditingFor selection: Document.Selection)
}

internal class RegionActionsInspector: InspectorStackView {
    
    private lazy var editButton = with(NSButton(title: "Edit Region",
                                            target: self,
                                            action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemBlue
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private lazy var deleteButton = with(NSButton(title: "Delete Region",
                                            target: self,
                                            action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hasDestructiveAction = true
        $0.bezelColor = .systemRed
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private let viewModel: RegionInspectorViewModel
    private weak var delegate: RegionActionsInspectorDelegate?
    
    internal required init(viewModel: RegionInspectorViewModel,
                           delegate: RegionActionsInspectorDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(title: "Actions")
        
        addArrangedSubview(editButton)
        
        guard viewModel.hasIntermediate else { return }

        addArrangedSubview(deleteButton)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RegionActionsInspector {
    
    @objc
    internal func button(_ sender: NSButton) {
        
        switch sender {
            
        case editButton:
            
            delegate?.regionActionsInspector(self,
                                             didRequestEditingFor: .region(coordinate: viewModel.coordinate))
            
        case deleteButton:
            
            delegate?.regionActionsInspector(self,
                                             didRequestDeletionFor: .region(coordinate: viewModel.coordinate))
            
        default: fatalError("Invalid sender for button action")
        }
    }
}
