//
//  WorldEditorContainer.swift
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Container
import Deltille
import Design

internal protocol WorldEditorContainerDelegate: AnyObject {
    
    func worldEditorContainer(_ container: WorldEditorContainer,
                              didSelect selection: Document.Selection)
}

internal class WorldEditorContainer: ContainerViewController {
    
    private lazy var editorController = WorldEditorViewController(viewModel: viewModel,
                                                                  delegate: self)
    
    private lazy var cursorOverlay = with(EditorCursorOverlay()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
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
        
        view.addSubview(cursorOverlay)
        
        NSLayoutConstraint.activate([
            
            cursorOverlay.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cursorOverlay.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
        
        reload()
    }
    
    internal func reload() {
     
        viewModel.load()
        
        focus()
    }
    
    internal func focus() {
     
        switch viewModel.selection {
            
        case .region(let vertex):
            
            let focus = vertex.position(.region)
            
            viewModel.camera(focus: .init(x: focus.x,
                                          y: focus.z))
            
        default: break
        }
    }
}

extension WorldEditorContainer: @preconcurrency WorldEditorViewDelegate {
    
    func worldEditorViewController(_ viewController: WorldEditorViewController,
                                   click button: MouseButton,
                                   location: CGPoint) {
        
        guard let hit = viewModel.hit(location) else { return }
        
        delegate?.worldEditorContainer(self,
                                       didSelect: .region(vertex: hit.triangle.vertex))
    }
    
    func worldEditorViewController(_ viewController: WorldEditorViewController,
                                   hover location: CGPoint) {
        
        guard let hit = viewModel.hit(location) else { return }
        
        viewModel.cursor(focus: hit)
        
        cursorOverlay.update(hit)
    }
    
    func worldEditorViewController(_ viewController: WorldEditorViewController,
                                   magnify magnification: Double) {
        
        viewModel.camera(zoom: magnification)
    }
    
    func worldEditorViewController(_ viewController: WorldEditorViewController,
                                   pan button: MouseButton,
                                   location: CGPoint,
                                   translation: CGPoint) {
        
        viewModel.camera(translate: translation)
    }
}
