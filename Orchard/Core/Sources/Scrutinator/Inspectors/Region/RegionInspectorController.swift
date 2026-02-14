//
//  RegionInspectorController.swift
//  Core
//
//  Created by Zack Brown on 11/02/2026.
//

import AppKit
import Base
import Deltille
import Design

public protocol RegionInspectorControllerDelegate: AnyObject {
    
    func regionInspectorController(_ controller: RegionInspectorController,
                                   didRequestDeletionFor selection: Document.Selection)
    func regionInspectorController(_ controller: RegionInspectorController,
                                   didRequestEditingFor selection: Document.Selection)
    
    func regionInspectorController(_ controller: RegionInspectorController,
                                   didUpdate identifier: String)
}

public class RegionInspectorController: InspectorStackViewContainer {
    
    private lazy var regionView = with(RegionInspectorView(viewModel: viewModel,
                                                           delegate: self)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var actionsView = with(RegionActionsInspectorView(viewModel: viewModel,
                                                                   delegate: self)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let viewModel: RegionInspectorViewModel
    private weak var delegate: RegionInspectorControllerDelegate?
    
    public init(triangle: Triangle,
                document: Document,
                delegate: RegionInspectorControllerDelegate? = nil) {
     
        self.viewModel = .init(triangle: triangle,
                               document: document)
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
        
        addArrangedSubview(regionView)
        addArrangedSubview(SeparatorView())
        addArrangedSubview(actionsView)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RegionInspectorController: @preconcurrency RegionInspectorViewDelegate {
    
    internal func regionInspectorView(_ view: RegionInspectorView,
                                      didUpdate identifier: String) {
        
        viewModel.update(identifier: identifier)
        
        delegate?.regionInspectorController(self,
                                            didUpdate: identifier)
    }
}

extension RegionInspectorController: @preconcurrency RegionActionsInspectorViewDelegate {
    
    internal func regionActionsInspectorView(_ view: RegionActionsInspectorView,
                                             didSelect action: RegionActionsInspectorView.Action) {
        
        switch action {
            
        case .create,
             .edit:
            
            delegate?.regionInspectorController(self,
                                                didRequestEditingFor: .region(triangle: viewModel.triangle))
            
        case .delete:
            
            delegate?.regionInspectorController(self,
                                                didRequestDeletionFor: .region(triangle: viewModel.triangle))
        }
    }
}
