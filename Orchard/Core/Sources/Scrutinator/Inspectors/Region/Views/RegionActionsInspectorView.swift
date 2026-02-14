//
//  RegionActionsInspectorView.swift
//  Core
//
//  Created by Zack Brown on 11/02/2026.
//

import AppKit
import Base
import Design

internal protocol RegionActionsInspectorViewDelegate: AnyObject {
    
    func regionActionsInspectorView(_ view: RegionActionsInspectorView,
                                    didSelect action: RegionActionsInspectorView.Action)
}

internal class RegionActionsInspectorView: InspectorGroupView {
    
    internal enum Action: String,
                          CaseIterable,
                          Identifiable {
    
        case create
        case delete
        case edit
        
        public var id: String { rawValue.capitalized }
    }
    
    private lazy var createButton = with(NSButton(title: "Create Region",
                                                      target: self,
                                                      action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemIndigo
        $0.toolTip = "Create a new region"
    }
    
    private lazy var editButton = with(NSButton(title: "Edit Region",
                                                target: self,
                                                action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.bezelColor = .systemBlue
        $0.toolTip = "Edit this region"
    }
    
    private lazy var deleteButton = with(NSButton(title: "Delete Region",
                                                  target: self,
                                                  action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.hasDestructiveAction = true
        $0.bezelColor = .systemRed
        $0.toolTip = "Delete this region"
    }
    
    private let viewModel: RegionInspectorViewModel
    private weak var delegate: RegionActionsInspectorViewDelegate?
    
    internal init(viewModel: RegionInspectorViewModel,
                  delegate: RegionActionsInspectorViewDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        title = "Actions"
        
        guard viewModel.hasIntermediate else {
            
            addArrangedSubview(createButton)
            
            return
        }
        
        addArrangedSubview(editButton)
        addArrangedSubview(deleteButton)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RegionActionsInspectorView {
    
    @objc
    private func button(_ sender: NSButton) {
        
        let action: Action = {
            
            switch sender {
                
            case createButton: .create
            case deleteButton: .delete
            default: .edit
            }
        }()
        
        delegate?.regionActionsInspectorView(self,
                                             didSelect: action)
    }
}
