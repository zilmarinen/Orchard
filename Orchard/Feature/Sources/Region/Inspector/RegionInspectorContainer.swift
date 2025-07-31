//
//  RegionInspectorContainer.swift
//  Feature
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Container

internal protocol RegionInspectorContainerDelegate: AnyObject {}

internal class RegionInspectorContainer: ContainerViewController {
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionInspectorContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionInspectorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
}
