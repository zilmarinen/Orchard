//
//  RegionEditorContainer.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base
import Container
import Deltille
import Editor
import Euclid
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
    
    override func key(down keyCode: NSEvent.KeyCode) {
        
        print("Key down: \(keyCode.id)")
    }
    
    override func key(held keyCodes: Set<NSEvent.KeyCode>) {
        
        var offset = Vector.zero
        
        for keyCode in keyCodes {
            
            switch keyCode {
                
            case .a: offset.x -= 1
            case .d: offset.x += 1
            case .s: offset.z += 1
            case .w: offset.z -= 1
            default: break
            }
        }
        
        editorView.translate(x: offset.x, z: offset.z)
    }
    
    override func key(up keyCode: NSEvent.KeyCode) {
        
        print("Key up: \(keyCode.id)")
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
            
            editorView.set(cursor: viewModel.cursorStyle)
            editorView.set(cursor: hit.pointInWorld)
            
        default: break
        }
    }
    
    override func cursor(down event: CursorEvent) {
        
        guard case .down(let location,
                         let button) = event,
              let hit = editorView.hitTest(point: location),
              viewModel.canEdit(vertex: hit.vertex) else { return }
        
        switch viewModel.tool {
            
        case .foliage: update(foliage: hit,
                              button: button)
            
        case .footpaths: update(footpath: hit,
                                button: button)
            
        case .staircases: update(staircases: hit,
                                 button: button)
        
        case .terrain: update(terrain: hit,
                              button: button)
        
        case .water: update(water: hit,
                            button: button)
            
        default: break
        }
    }
    
    override func scroll(delta: CGPoint) {
        
        editorView.set(zoom: Float(delta.y))
    }
}

// MARK: Foliage

extension RegionEditorContainer {
    
    private func update(foliage hit: HitTest,
                        button: CursorEvent.Button) {
     
        guard button == .left else {
            
            return editorView.remove(foliage: hit.triangle)
        }
        
        editorView.set(foliage: hit.triangle)
    }
}

// MARK: Footpaths

extension RegionEditorContainer {
    
    private func update(footpath hit: HitTest,
                        button: CursorEvent.Button) {
     
        guard button == .left else {
            
            return editorView.remove(footpath: hit.vertex)
        }
        
        editorView.set(viewModel.footpathType,
                       for: hit.vertex)
    }
}

// MARK: Staircases

extension RegionEditorContainer {
    
    private func update(staircases hit: HitTest,
                        button: CursorEvent.Button) {
        
        guard button == .left else {
            
            return editorView.remove(staircase: hit.triangle)
        }
        
        editorView.set(viewModel.stoop,
                       for: hit.triangle)
    }
}

// MARK: Terrain

extension RegionEditorContainer {
    
    private func update(terrain hit: HitTest,
                        button: CursorEvent.Button) {
        
        let sculpt = viewModel.sculpt
        let paint = viewModel.paint
        
        viewModel.vertices(for: hit).forEach {
            
            let tile = editorView.get(biome: $0)
            
            let biome = paint ? viewModel.biome : (tile?.biome ?? viewModel.biome)
            
            let elevation = tile?.elevation ?? 0
            let adjustment = button == .left ? 1 : -1
            let adjusted = sculpt ? max(0, elevation + adjustment) : elevation
            
            editorView.set(adjusted > 0 ? biome : nil,
                           adjusted,
                           for: $0)
        }
    }
}

// MARK: Water

extension RegionEditorContainer {
    
    private func update(water hit: HitTest,
                        button: CursorEvent.Button) {
        
        let biome = editorView.get(biome: hit.vertex)
        let tile = editorView.get(water: hit.triangle)
        let elevation = tile?.elevation ?? biome?.elevation ?? 0
        let adjusted = max(0, button == .left ? elevation + 1 : elevation - 1)
        
        viewModel.tiles(for: hit).forEach {
            
            editorView.set(viewModel.waterType,
                           adjusted,
                           for: $0)
        }
    }
}
