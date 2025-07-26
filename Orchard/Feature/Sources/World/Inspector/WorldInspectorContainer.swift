//
//  WorldInspectorContainer.swift
//  Feature
//
//  Created by Zack Brown on 12/07/2025.
//

import Base
import Container
import Deltille
import Inspector

internal protocol WorldInspectorContainerDelegate: AnyObject {
    
    func worldInspectorContainer(_ container: WorldInspectorContainer,
                                 didUpdate coordinate: Coordinate)
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
    }
    
    internal func reload() {
        
        switch viewModel.selection {
            
        case .none: set(content: emptyViewController)
        case .region(let coordinate):
            
            set(content: RegionInspectorViewController(coordinate: coordinate,
                                                       document: viewModel.document,
                                                       delegate: self))
        }
    }
}

extension WorldInspectorContainer: @preconcurrency RegionInspectorDelegate {
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didRequestEditingFor coordinate: Coordinate) {
        
        print("Coordinate: \(coordinate.id)")
    }
    
    func regionInsepectorViewController(_ viewController: RegionInspectorViewController,
                                        didUpdate coordinate: Coordinate) {
        
        delegate?.worldInspectorContainer(self,
                                          didUpdate: coordinate)
    }
}
