//
//  WorldEditorContainer.swift
//  Feature
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Container
import Deltille
import Editor
import Euclid
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
            
            editorView.add(region: region.coordinate)
        }
    }
    
    internal func focus() {
        
        switch viewModel.selection {
            
        case .region(let coordinate):
            
            let vertex = Grid.Triangle.Vertex(coordinate)
            
            editorView.camera.focus(on: vertex.position(.region))
            
        default: break
        }
    }
    
    override func cursor(hover event: CursorEvent) {
        
        switch event {
            
        case .hover(let location):
            
            guard let hit = editorView.hitTest(point: location) else { return }
            
            overlayController.update(mouse: location)
            overlayController.update(cursor: hit.pointInWorld)
            
            overlayController.update(coordinate: hit.triangle.vertex.position)
            
            editorView.cursor.focus(on: hit.pointInWorld)
            
        default: break
        }
    }
    
    override func cursor(up event: CursorEvent) {
        
        guard case .up(let start,
                       let location,
                       let delta,
                       let button) = event else { return }
        
        print("Up: [\(start)] - [\(location)] - [\(delta)] - [\(button)]")
    }
    
    override func cursor(down event: CursorEvent) {
        
        guard case .down(let location,
                         _) = event,
              let hit = editorView.hitTest(point: location) else { return }
        
        let vertex = Grid.Triangle.Vertex(hit.pointInWorld,
                                          .region)
        
        delegate?.worldEditorContainer(self,
                                       didSelect: .region(coordinate: vertex.position))
    }
    
    override func cursor(drag event: CursorEvent) {
        
        super.cursor(drag: event)
        
        guard case .drag(_,
                         let location,
                         let delta,
                         let button) = event else { return }
        
        overlayController.update(mouse: location)
        
        guard button == .right else { return }
        
        print("Moving: [\(delta)]")
    }
    
    override func scroll(delta: CGPoint) {
        
        editorView.camera.zoom(delta: Float(delta.y))
    }
}
