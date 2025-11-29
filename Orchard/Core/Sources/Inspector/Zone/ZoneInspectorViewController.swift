//
//  ZoneInspectorViewController.swift
//
//  Created by Zack Brown on 28/07/2025.
//

import AppKit
import Base
import Deltille

public protocol ZoneInspectorDelegate: AnyObject {
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didRequestDeletionFor selection: Document.Selection)
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didRequestEditingFor selection: Document.Selection)
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didUpdate selection: Document.Selection)
}

public class ZoneInspectorViewController: InspectorViewController {
    
    private lazy var intermediateInspector = ZoneIntermediateInspector(viewModel: viewModel,
                                                                       delegate: self)
    
    private lazy var actionsInspector = ZoneActionsInspector(viewModel: viewModel,
                                                             delegate: self)
    
    private let viewModel: ZoneInspectorViewModel
    private weak var delegate: ZoneInspectorDelegate?
    
    public init(triangle: Triangle,
                document: Document,
                delegate: ZoneInspectorDelegate) {
        
        self.viewModel = .init(triangle: triangle,
                               document: document)
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(intermediateInspector)
        addArrangedSubview(actionsInspector)
    }
}

extension ZoneInspectorViewController: @preconcurrency ZoneIntermediateInspectorDelegate {
    
    internal func zoneIntermediateInspector(_ inspector: ZoneIntermediateInspector,
                                            didUpdate selection: Document.Selection) {
        
        delegate?.zoneInsepectorViewController(self,
                                               didUpdate: selection)
    }
}

extension ZoneInspectorViewController: @preconcurrency ZoneActionsInspectorDelegate {
    
    internal func zoneActionsInspector(_ inspector: ZoneActionsInspector,
                                       didRequestDeletionFor selection: Document.Selection) {
        
        delegate?.zoneInsepectorViewController(self,
                                               didRequestDeletionFor: selection)
    }
    
    internal func zoneActionsInspector(_ inspector: ZoneActionsInspector,
                                       didRequestEditingFor selection: Document.Selection) {
        
        delegate?.zoneInsepectorViewController(self,
                                               didRequestEditingFor: selection)
    }
}
