//
//  RegionInspectorContainer.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base
import Container
import Design
import Scrutinator

internal protocol RegionInspectorContainerDelegate: AnyObject {}

internal class RegionInspectorContainer: ContainerViewController {
    
    private let emptyViewController = EmptyViewController.noSelection
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionInspectorContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionInspectorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        reload()
    }
    
    internal func reload() {
        
        switch viewModel.selection {
         
        case .none: set(content: emptyViewController)
        case .portal(let triangle):
            
            set(content: PortalInspectorController(triangle: triangle,
                                                   delegate: self))
        }
    }
}

extension RegionInspectorContainer: @preconcurrency PortalInspectorControllerDelegate {}
