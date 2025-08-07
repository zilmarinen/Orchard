//
//  WorldInspectorContainer.swift
//  Feature
//
//  Created by Zack Brown on 12/07/2025.
//

import Base
import Container
import Inspector

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
        
        set(content: EmptyViewController.noSelection)
        
        reload()
    }
    
    internal func reload() {
        
        switch viewModel.selection {
            
        case .none: set(content: emptyViewController)
        case .region(let coordinate):
            
            set(content: RegionInspectorViewController(coordinate: coordinate,
                                                       document: viewModel.document,
                                                       delegate: self))
            
        case .zone(let coordinate):
            
            set(content: ZoneInspectorViewController(coordinate: coordinate,
                                                     document: viewModel.document,
                                                     delegate: self))
        }
    }
}

extension WorldInspectorContainer: @preconcurrency RegionInspectorDelegate {
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didRequestDeletionFor selection: Document.Selection) {
        
        delegate?.worldInspectorContainer(self,
                                          didRequestDeletionFor: selection)
    }
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didRequestEditingFor selection: Document.Selection) {
        
        delegate?.worldInspectorContainer(self,
                                          didRequestEditingFor: selection)
    }
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didUpdate selection: Document.Selection) {
        
        delegate?.worldInspectorContainer(self,
                                          didUpdate: selection)
    }
}

extension WorldInspectorContainer: @preconcurrency ZoneInspectorDelegate {
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didRequestEditingFor selection: Document.Selection) {
        
        delegate?.worldInspectorContainer(self,
                                          didRequestEditingFor: selection)
    }
    
    func zoneInsepectorViewController(_ viewController: ZoneInspectorViewController,
                                      didUpdate selection: Document.Selection) {
        
        delegate?.worldInspectorContainer(self,
                                          didUpdate: selection)
    }
}
