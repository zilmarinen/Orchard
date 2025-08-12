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
import Harvest

internal protocol WorldEditorContainerDelegate: AnyObject {
    
    func worldEditorContainer(_ container: WorldEditorContainer,
                              didSelect selection: Document.Selection)
}

internal class WorldEditorContainer: EditorContainer<WorldView> {
    
    private let overlayController = WorldEditorOverlayController()
    
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
        
        insert(viewController: overlayController)
        
        reload()
    }
    
    internal func reload() {
        
        //
    }
    
    internal func focus() {
        
        switch viewModel.selection {
            
        case .region(let coordinate):
            
            print("Focusing: \(coordinate.id)")
            
        default: break
        }
    }
    
    override func cursor(hover: CGPoint) {
        
        overlayController.update(cursor: hover)
    }
}
