//
//  WorldInspectorContainer.swift
//
//  Created by Zack Brown on 12/07/2025.
//

import Base
import Container
import Design
import Scrutinator

internal protocol WorldInspectorContainerDelegate: AnyObject {
    
    func worldInspectorContainer(_ container: WorldInspectorContainer,
                                 didRequestDeletionFor selection: Document.Selection)
    
    func worldInspectorContainer(_ container: WorldInspectorContainer,
                                 didRequestEditingFor selection: Document.Selection)
    
    func worldInspectorContainer(_ container: WorldInspectorContainer,
                                 didUpdate selection: Document.Selection)
}

internal class WorldInspectorContainer: ContainerViewController {
    
    private let emptyViewController = EmptyViewController.noSelection
    
    private let viewModel: WorldViewModel
    private weak var delegate: WorldInspectorContainerDelegate?
    
    internal init(viewModel: WorldViewModel,
                  delegate: WorldInspectorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        reload()
    }
    
    internal func reload() {
        
        switch viewModel.selection {
            
        case .none: set(content: emptyViewController)
        case .region(let triangle): set(content: RegionInspectorController(delegate: self))
        case .zone(let triangle): set(content: emptyViewController)
        }
    }
}

extension WorldInspectorContainer: @preconcurrency RegionInspectorControllerDelegate {}
