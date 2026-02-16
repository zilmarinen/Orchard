//
//  RegionEditorContainer.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base
import Container
import Deltille
import Design
import Euclid
import Harvest
import Proscenium
import Toolbox

internal protocol RegionEditorContainerDelegate: AnyObject {
    
    func regionEditorContainer(_ container: RegionEditorContainer,
                               didSelect selection: RegionViewModel.Selection)
}

internal class RegionEditorContainer: EditorContainer<RegionView> {
    
    private lazy var editorToolOverlay = with(EditorToolOverlay(delegate: self)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionEditorContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionEditorContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(editorToolOverlay)
        
        NSLayoutConstraint.activate([
            
            editorToolOverlay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editorToolOverlay.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
        
        //TODO: Refactor scene loading
        viewModel.load(editor: editorView)
    }
    
    internal func focus() {
        
        switch viewModel.selection {
            
        case .portal(let triangle):
            
            editorView.camera(focus: triangle.position(.tile))
            
        default: break
        }
    }
    
    // MARK: Keyboard Events
    
    override func key(down keyCode: NSEvent.KeyCode) {
        
        switch keyCode {
            
        case .q: editorView.camera(rotate: .clockwise)
        case .e: editorView.camera(rotate: .counterClockwise)
        case .r: editorView.cursor(rotate: .clockwise)
        default: break
        }
    }
    
    // MARK: Cursor Events
    
    override func cursor(click button: MouseButton,
                         location: CGPoint) {
        
        // ignore events outside of active region
        guard let hit = editorView.hitTest(point: location),
              viewModel.canEdit(vertex: hit.vertex) else { return }
        
        // ignore events when popover controller is active / dismissed
        guard presentedViewControllers?.isEmpty ?? true else { return }
        
        switch viewModel.tool {
            
        case .buildings: update(buildings: hit,
                                button: button)

        case .foliage: update(foliage: hit,
                              button: button)
            
        case .footpaths: update(footpath: hit,
                                button: button)
            
        case .portals: update(portal: hit,
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
    
    override func cursor(hover location: CGPoint) {
        
        guard let hit = editorView.hitTest(point: location) else { return }
        
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

// MARK: Tool Overlay

extension RegionEditorContainer: @preconcurrency EditorToolOverlayDelegate {
    
    func editorToolOverlay(_ overlay: EditorToolOverlay,
                           didTapTool button: NSButton) {
        
        let viewController = ToolSelectionContainer(delegate: self)
        
        present(viewController,
                asPopoverRelativeTo: button.bounds,
                of: button,
                preferredEdge: .maxY,
                behavior: .transient,
                hasFullSizeContent: true)
    }
    
    func editorToolOverlay(_ overlay: EditorToolOverlay,
                           didTapOptions button: NSButton) {
        
        let viewController = ToolOptionsContainer(viewModel: viewModel.toolOptionsViewModel,
                                                  delegate: self)
        
        present(viewController,
                asPopoverRelativeTo: button.bounds,
                of: button,
                preferredEdge: .maxY,
                behavior: .transient,
                hasFullSizeContent: true)
    }
}

// MARK: Tool Selection

extension RegionEditorContainer: @preconcurrency ToolSelectionContainerDelegate {
    
    func toolSelectionContainer(_ container: ToolSelectionContainer,
                                didSelect tool: Tool) {
        
        viewModel.select(tool: tool)
    }
}

// MARK: Tool Options

extension RegionEditorContainer: @preconcurrency ToolOptionsContainerDelegate {}

// MARK: Buildings

extension RegionEditorContainer {
    
    private func update(buildings hit: HitTest,
                        button: MouseButton) {
     
        guard button == .left else {
            
            return editorView.remove(building: hit.triangle)
        }
        
        editorView.set(viewModel.septomino,
                       for: hit.triangle)
    }
}

// MARK: Foliage

extension RegionEditorContainer {
    
    private func update(foliage hit: HitTest,
                        button: MouseButton) {
     
        guard button == .left else {
            
            return editorView.remove(foliage: hit.triangle)
        }
        
        editorView.set(foliage: hit.triangle)
    }
}

// MARK: Footpaths

extension RegionEditorContainer {
    
    private func update(footpath hit: HitTest,
                        button: MouseButton) {
     
        guard button == .left else {
            
            return editorView.remove(footpath: hit.vertex)
        }
        
        editorView.set(viewModel.footpathType,
                       for: hit.vertex)
    }
}

// MARK: Portals

extension RegionEditorContainer {
    
    private func update(portal hit: HitTest,
                        button: MouseButton) {
        
        guard button == .left else {
            
            //TODO: tidy up delegation of deselection
            delegate?.regionEditorContainer(self,
                                            didSelect: .none)
            
            return editorView.remove(portal: hit.triangle)
        }
        
        editorView.add(portal: hit.triangle)
        
        //TODO: tidy up delegation of selection / creation
        delegate?.regionEditorContainer(self,
                                        didSelect: .portal(triangle: hit.triangle))
    }
}

// MARK: Staircases

extension RegionEditorContainer {
    
    private func update(staircases hit: HitTest,
                        button: MouseButton) {
        
        guard button == .left else {
            
            return editorView.remove(staircase: hit.triangle)
        }
        
        editorView.set(viewModel.staircaseType,
                       for: hit.triangle)
    }
}

// MARK: Terrain

extension RegionEditorContainer {
    
    private func update(terrain hit: HitTest,
                        button: MouseButton) {
        
        let sculpt = true//viewModel.sculpt
        let paint = true//viewModel.paint
        
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
                        button: MouseButton) {
        
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
