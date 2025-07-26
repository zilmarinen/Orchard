//
//  EditorContainer.swift
//  Core
//
//  Created by Zack Brown on 12/07/2025.
//

import AppKit
import Container

public protocol EditorContainerDelegate: AnyObject {}

public class EditorContainer: VerticalStackContainerViewController {
    
    private let editorController = EditorViewController()
    private let toolbarController = EditorToolbarController()
    
    private weak var delegate: EditorContainerDelegate?
    
    public init(delegate: EditorContainerDelegate) {
        
        self.delegate = delegate
        
        super.init()
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        insert(viewController: editorController)
        insert(viewController: toolbarController)
    }
}
