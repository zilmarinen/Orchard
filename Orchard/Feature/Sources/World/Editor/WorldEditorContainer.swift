//
//  WorldEditorContainer.swift
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Deltille

internal protocol WorldEditorContainerDelegate: AnyObject {
    
    func worldEditorContainer(_ container: WorldEditorContainer,
                              didSelect selection: Document.Selection)
}

internal class WorldEditorContainer: NSViewController {
    
    private let viewModel: WorldViewModel
    private weak var delegate: WorldEditorContainerDelegate?
    
    internal init(viewModel: WorldViewModel,
                  delegate: WorldEditorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //
    }
    
    internal func reload() {
     
        //TODO: Reload scene
    }
    
    internal func focus() {
     
        //TODO: Focus on selection
    }
}
