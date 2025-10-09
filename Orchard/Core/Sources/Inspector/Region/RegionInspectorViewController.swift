//
//  RegionInspectorViewController.swift
//  Feature
//
//  Created by Zack Brown on 24/07/2025.
//

import AppKit
import Base
import Deltille

public protocol RegionInspectorDelegate: AnyObject {
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didRequestDeletionFor selection: Document.Selection)
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didRequestEditingFor selection: Document.Selection)
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didUpdate selection: Document.Selection)
}

public class RegionInspectorViewController: InspectorViewController {
    
    private lazy var intermediateInspector = RegionIntermediateInspector(viewModel: viewModel,
                                                                         delegate: self)
    
    private lazy var actionsInspector = RegionActionsInspector(viewModel: viewModel,
                                                               delegate: self)
    
    private let viewModel: RegionInspectorViewModel
    private weak var delegate: RegionInspectorDelegate?
    
    public init(coordinate: Coordinate,
                document: Document,
                delegate: RegionInspectorDelegate) {
        
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
        
        addArrangedSubview(intermediateInspector)
        addArrangedSubview(actionsInspector)
    }
}

extension RegionInspectorViewController: @preconcurrency RegionIntermediateInspectorDelegate {
    
    internal func regionIntermediateInspector(_ inspector: RegionIntermediateInspector,
                                              didUpdate selection: Document.Selection) {
        
        delegate?.regionInsepectorViewController(self,
                                                 didUpdate: selection)
    }
}

extension RegionInspectorViewController: @preconcurrency RegionActionsInspectorDelegate {
    
    internal func regionActionsInspector(_ inspector: RegionActionsInspector,
                                         didRequestDeletionFor selection: Document.Selection) {
        
        delegate?.regionInsepectorViewController(self,
                                                 didRequestDeletionFor: selection)
    }
    
    internal func regionActionsInspector(_ inspector: RegionActionsInspector,
                                        didRequestEditingFor selection: Document.Selection) {
        
        delegate?.regionInsepectorViewController(self,
                                                 didRequestEditingFor: selection)
    }
}
