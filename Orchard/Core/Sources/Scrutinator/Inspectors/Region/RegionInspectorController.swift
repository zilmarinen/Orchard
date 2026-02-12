//
//  RegionInspectorController.swift
//  Core
//
//  Created by Zack Brown on 11/02/2026.
//

import AppKit
import Base
import Design

public protocol RegionInspectorControllerDelegate: AnyObject {}

public class RegionInspectorController: InspectorStackViewContainer {
    
    private lazy var regionView = with(RegionInspectorView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "Region"
    }
    
    private lazy var actionsView = with(ActionsInspectorView(actions: [.create,
                                                                       .delete,
                                                                       .edit])) {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "Actions"
    }
    
    private weak var delegate: RegionInspectorControllerDelegate?
    
    public init(delegate: RegionInspectorControllerDelegate? = nil) {
     
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
