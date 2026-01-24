//
//  WorldEditorContainer.swift
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Deltille
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
        focus()
    }
    
    internal func reload() {
        
        editorView.clear()
        
        for region in viewModel.regions {
            
            editorView.add(region: region)
        }
    }
    
    internal func focus() {
        
        switch viewModel.selection {
            
        case .region(let triangle):
            
            editorView.camera(focus: triangle.position(.region))
            
        default: break
        }
    }
    
    override func cursor(click button: MouseButton,
                         location: CGPoint) {
        
        guard let hit = editorView.hitTest(point: location) else { return }
        
        let triangle = Triangle(hit.pointInWorld,
                                .region)
        
        delegate?.worldEditorContainer(self,
                                       didSelect: .region(triangle: triangle))
    }
    
    override func cursor(hover location: CGPoint) {
        
        guard let hit = editorView.hitTest(point: location) else { return }
        
        let region = hit.triangle.transpose(.tile,
                                            .region)
        
        let hexagon = Hexagon(hit.pointInWorld,
                              .chunk)
        
        overlayController.update(triangle: region)
        overlayController.update(vertex: hit.vertex)
        overlayController.update(hexagon: hexagon)
        
        editorView.cursor(focus: hit.pointInWorld)
    }
    
    override func cursor(magnify magnification: Double) {
        
        editorView.camera(zoom: magnification)
    }
    
    override func cursor(pan button: MouseButton,
                         location: CGPoint,
                         translation: CGPoint) {
        
        editorView.camera(translate: .init(translation.x,
                                           0.0,
                                           translation.y))
    }
}
