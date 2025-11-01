//
//  WorldEditorContainer.swift
//  Feature
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
            
            editorView.add(region: region.coordinate)
        }
    }
    
    internal func focus() {
        
        switch viewModel.selection {
            
        case .region(let coordinate):
            
            let vertex = Triangle.Vertex(coordinate)
            
            editorView.set(camera: vertex.position(.region))
            
        default: break
        }
    }
    
    override func cursor(hover event: CursorEvent) {
        
        switch event {
            
        case .hover(let location):
            
            guard let hit = editorView.hitTest(point: location) else { return }
            
            let region = hit.triangle.transpose(.tile,
                                                .region)
            
            let hexagon = Hexagon(hit.pointInWorld,
                                  .chunk)
            
            overlayController.update(triangle: region)
            overlayController.update(vertex: hit.vertex)
            overlayController.update(hexagon: hexagon)
            
            editorView.set(cursor: hit.pointInWorld)
            
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
        
        let triangle = Triangle(hit.pointInWorld,
                                .region)
        
        delegate?.worldEditorContainer(self,
                                       didSelect: .region(coordinate: triangle.vertex.position))
    }
    
    override func cursor(drag event: CursorEvent) {
        
        super.cursor(drag: event)
        
        guard case .drag(_,
                         _,
                         let delta,
                         let button) = event else { return }
        
        guard button == .right else { return }
        
        print("Moving: [\(delta)]")
    }
    
    override func scroll(delta: CGPoint) {
        
        editorView.set(zoom: Float(delta.y))
    }
}
