//
//  RegionEditorContainer.swift
//  Feature
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Container

internal protocol RegionEditorContainerDelegate: AnyObject {}

internal class RegionEditorContainer: ContainerViewController {
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionEditorContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionEditorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
}
