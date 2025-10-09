//
//  RegionEditorContainer.swift
//  Feature
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base
import Container
import Deltille
import Editor
import Harvest

internal protocol RegionEditorContainerDelegate: AnyObject {}

internal class RegionEditorContainer: EditorContainer<RegionView> {
    
    private let overlayController = RegionEditorOverlayController()
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionEditorContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionEditorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        insert(viewController: overlayController)
        
        viewModel.load(editor: editorView)
    }
    
    override func cursor(hover event: CursorEvent) {
        
        switch event {
            
        case .hover(let location):
            
            guard let hit = editorView.hitTest(point: location) else { return }
            
            let hexagon = Hexagon(hit.pointInWorld,
                                  .chunk)
            
            overlayController.update(triangle: hit.triangle)
            overlayController.update(vertex: hit.vertex)
            overlayController.update(hexagon: hexagon)
            
            editorView.cursor.focus(on: hit.pointInWorld)
            
        default: break
        }
    }
    
    override func cursor(down event: CursorEvent) {
        
        guard case .down(let location,
                         let button) = event,
              let hit = editorView.hitTest(point: location),
              viewModel.canEdit(vertex: hit.vertex) else { return }
        
        switch viewModel.selectedTool {
        
        case .terrain:
            
            update(terrain: hit,
                   button: button)
            
        default: break
        }
    }
    
    override func scroll(delta: CGPoint) {
        
        editorView.camera.zoom(delta: Float(delta.y))
    }
}

// MARK: Terrain

extension RegionEditorContainer {
    
    private func update(terrain hit: HitTest,
                        button: CursorEvent.Button) {
        
        let heightMap = editorView.terrain.get(value: hit.vertex)
        let height = heightMap?.height ?? 0
        
        switch button {
            
        case .left:
            
            editorView.terrain.set(height + 1,
                                   viewModel.terrainType,
                                   for: hit.vertex)
            
        case .right:
            
            editorView.terrain.set(max(0, height - 1),
                                   viewModel.terrainType,
                                   for: hit.vertex)
        }
    }
}
