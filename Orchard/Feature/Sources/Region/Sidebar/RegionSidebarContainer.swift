//
//  RegionSidebarContainer.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Container

internal protocol RegionSidebarContainerDelegate: AnyObject {}

internal class RegionSidebarContainer: ContainerViewController {
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionSidebarContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionSidebarContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
}
