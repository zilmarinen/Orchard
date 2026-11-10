//
//  WorldEditorContainer.swift
//
//  Created by Zack Brown on 10/07/2025.
//

import Alluvium
import AppKit
import Base
import Container
import Deltille
import Design
import Harvest

internal protocol WorldEditorContainerDelegate: AnyObject {
    
    func worldEditorContainer(_ container: WorldEditorContainer,
                              didSelect selection: Document.Selection)
}

internal class WorldEditorContainer: ContainerViewController {
    
    private lazy var editorController = EditorViewController(dataSource: self,
                                                             delegate: self)
    
    private let viewModel: WorldViewModel
    private weak var delegate: WorldEditorContainerDelegate?
    
    internal init(viewModel: WorldViewModel,
                  delegate: WorldEditorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
        
        set(content: editorController)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        reload()
    }
    
    internal func reload() {
     
        viewModel.load()
        
        focus()
    }
    
    internal func focus() {
     
        //
    }
}

extension WorldEditorContainer: EditorViewDataSource {}

extension WorldEditorContainer: EditorViewDelegate {}
