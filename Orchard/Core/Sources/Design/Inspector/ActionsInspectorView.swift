//
//  ActionsInspectorView.swift
//  Core
//
//  Created by Zack Brown on 11/02/2026.
//

import AppKit
import Base

public class ActionsInspectorView: InspectorGroupView {
    
    public enum Action: String,
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
        $0.bezelColor = .systemMint
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
    
    required public init(actions: [Action]) {
        
        super.init(frame: .zero)
        
        addArrangedSubview(createButton)
        addArrangedSubview(deleteButton)
        addArrangedSubview(editButton)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension ActionsInspectorView {
    
    @objc
    private func button(_ sender: NSButton) {
        
        
    }
}
