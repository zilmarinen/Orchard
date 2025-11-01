//
//  ZoneActionsInspector.swift
//
//  Created by Zack Brown on 08/08/2025.
//

import AppKit
import Base

internal protocol ZoneActionsInspectorDelegate: AnyObject {
    
    func zoneActionsInspector(_ inspector: ZoneActionsInspector,
                              didRequestDeletionFor selection: Document.Selection)
    
    func zoneActionsInspector(_ inspector: ZoneActionsInspector,
                              didRequestEditingFor selection: Document.Selection)
}

internal class ZoneActionsInspector: InspectorStackView {
    
    private lazy var editButton = with(NSButton(title: "Edit Zone",
                                            target: self,
                                            action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemBlue
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private lazy var deleteButton = with(NSButton(title: "Delete Zone",
                                            target: self,
                                            action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hasDestructiveAction = true
        $0.bezelColor = .systemRed
        $0.setContentHuggingPriority(.low,
                                     for: .horizontal)
    }
    
    private let viewModel: ZoneInspectorViewModel
    private weak var delegate: ZoneActionsInspectorDelegate?
    
    internal required init(viewModel: ZoneInspectorViewModel,
                           delegate: ZoneActionsInspectorDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(title: "Actions",
                   accentColor: .systemGray)
        
        addArrangedSubview(editButton)
        addArrangedSubview(deleteButton)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ZoneActionsInspector {
    
    @objc
    internal func button(_ sender: NSButton) {
        
        switch sender {
            
        case editButton:
            
            delegate?.zoneActionsInspector(self,
                                           didRequestEditingFor: .zone(coordinate: viewModel.coordinate))
            
        case deleteButton:
            
            delegate?.zoneActionsInspector(self,
                                           didRequestDeletionFor: .zone(coordinate: viewModel.coordinate))
            
        default: fatalError("Invalid sender for button action")
        }
    }
}
