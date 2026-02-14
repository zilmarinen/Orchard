//
//  RegionInspectorContainer.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base

internal protocol RegionInspectorContainerDelegate: AnyObject {}

internal class RegionInspectorContainer: NSViewController {
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionInspectorContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionInspectorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //
    }
}
