//
//  PortalInspectorView.swift
//  Core
//
//  Created by Zack Brown on 15/02/2026.
//

import AppKit
import Base
import Design

internal protocol PortalInspectorViewDelegate: AnyObject {
    
    func portalInspectorView(_ view: PortalInspectorView,
                             didUpdate identifier: String)
}

internal class PortalInspectorView: InspectorGroupView {
    
    private lazy var coordinate = with(CoordinateControl(title: "Coordinate",
                                                         value: .zero)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var textLabel = with(TextFieldControl(title: "Identifier",
                                                       value: "portal identifier goes here")) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        $0.valueDidChange = { [weak self] value in
        
            guard let self else { return }
            
            //
        }
    }
    
    private let viewModel: PortalInspectorViewModel
    private weak var delegate: PortalInspectorViewDelegate?
    
    internal init(viewModel: PortalInspectorViewModel,
                  delegate: PortalInspectorViewDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(frame: .zero)
        
        title = "Portal"
        
        addArrangedSubview(coordinate)
        addArrangedSubview(textLabel)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
