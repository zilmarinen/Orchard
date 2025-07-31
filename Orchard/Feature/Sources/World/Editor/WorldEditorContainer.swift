//
//  WorldEditorContainer.swift
//  Feature
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Container
import Editor

internal protocol WorldEditorContainerDelegate: AnyObject {
    
    func worldEditorContainer(_ container: WorldEditorContainer,
                              didSelect selection: Document.Selection)
}

internal class WorldEditorContainer: ContainerViewController {
    
    private lazy var editorContainer = EditorContainer(delegate: self)
    
    private let viewModel: WorldViewModel
    private weak var delegate: WorldEditorContainerDelegate?
    
    internal init(viewModel: WorldViewModel,
                  delegate: WorldEditorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        set(content: editorContainer)
    }
}

extension WorldEditorContainer: EditorContainerDelegate {}
