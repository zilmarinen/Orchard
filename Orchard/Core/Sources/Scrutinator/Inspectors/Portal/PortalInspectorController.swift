//
//  PortalInspectorController.swift
//  Core
//
//  Created by Zack Brown on 15/02/2026.
//

import AppKit
import Base
import Deltille
import Design

public protocol PortalInspectorControllerDelegate: AnyObject {}

public class PortalInspectorController: InspectorStackViewContainer {
    
    private lazy var portalView = with(PortalInspectorView(viewModel: viewModel,
                                                           delegate: self)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let viewModel: PortalInspectorViewModel
    private weak var delegate: PortalInspectorControllerDelegate?
    
    public init(vertex: Triangle.Vertex,
                delegate: PortalInspectorControllerDelegate? = nil) {
     
        self.viewModel = .init(vertex: vertex)
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
        
        addArrangedSubview(portalView)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension PortalInspectorController: @preconcurrency PortalInspectorViewDelegate {
    
    func portalInspectorView(_ view: PortalInspectorView,
                             didUpdate identifier: String) {
        
        //
    }
}
