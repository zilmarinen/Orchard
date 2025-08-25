//
//  ZoneInspectorViewController.swift
//  Core
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
    
    private lazy var intermediatePanel = ZoneIntermediateInspector(viewModel: viewModel,
                                                                   delegate: self)
    
    private lazy var actionsPanel = ZoneActionsInspector(viewModel: viewModel,
                                                         delegate: self)
    
    private let viewModel: ZoneInspectorViewModel
    private weak var delegate: ZoneInspectorDelegate?
    
    public init(coordinate: Grid.Coordinate,
                document: Document,
                delegate: ZoneInspectorDelegate) {
        
        self.viewModel = .init(coordinate: coordinate,
                               document: document)
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        addArrangedSubview(intermediatePanel)
        addArrangedSubview(actionsPanel)
    }
}

extension ZoneInspectorViewController: @preconcurrency ZoneIntermediateInspectorDelegate {
    
    func zoneIntermediateInspector(_ inspector: ZoneIntermediateInspector,
                                   didUpdate selection: Document.Selection) {
        
        delegate?.zoneInsepectorViewController(self,
                                               didUpdate: selection)
    }
}

extension ZoneInspectorViewController: @preconcurrency ZoneActionsInspectorDelegate {
    
    func zoneActionsInspector(_ inspector: ZoneActionsInspector,
                              didRequestDeletionFor selection: Document.Selection) {
        
        delegate?.zoneInsepectorViewController(self,
                                               didRequestDeletionFor: selection)
    }
    
    func zoneActionsInspector(_ inspector: ZoneActionsInspector,
                              didRequestEditingFor selection: Document.Selection) {
        
        delegate?.zoneInsepectorViewController(self,
                                               didRequestEditingFor: selection)
    }
}
