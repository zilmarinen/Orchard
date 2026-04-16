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
    
    private lazy var toolOverlay = with(EditorToolOverlay(delegate: self)) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var cursorOverlay = with(EditorCursorOverlay()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private lazy var toolsMenu = RegionToolsMenu(target: self,
                                                 action: #selector(menuItem(_:)))
    
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
        
        view.addSubview(toolOverlay)
        view.addSubview(cursorOverlay)
        
        NSLayoutConstraint.activate([
            
            toolOverlay.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            toolOverlay.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            
            cursorOverlay.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cursorOverlay.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor)
        ])
        
        //TODO: Refactor scene loading
        viewModel.load(editor: editorView)
    }
    
    internal func focus() {
        
        switch viewModel.selection {
            
        case .portal(let vertex):
            
            editorView.camera(focus: vertex.position(.tile))
            
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
            
        case .slopes: update(slopes: hit,
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
        
        cursorOverlay.update(hit: hit)
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

extension RegionEditorContainer {

    @objc
    private func menuItem(_ sender: NSMenuItem) {
        
        guard let tool = Tool(rawValue: sender.title.lowercased()) else { return }
        
        viewModel.select(tool: tool)
    }
}

// MARK: Tool Overlay

extension RegionEditorContainer: @preconcurrency EditorToolOverlayDelegate {
    
    func editorToolOverlay(_ overlay: EditorToolOverlay,
                           didTapTool button: NSButton) {
        
        toolsMenu.popUp(button)
    }
    
    func editorToolOverlay(_ overlay: EditorToolOverlay,
                           didTapOptions button: NSButton) {
        
        let viewController = ToolOptionsContainer(viewModel: viewModel.toolOptionsViewModel)
        
        present(viewController,
                asPopoverRelativeTo: button.bounds,
                of: button,
                preferredEdge: .maxY,
                behavior: .transient,
                hasFullSizeContent: true)
    }
}

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
                                        didSelect: .portal(vertex: hit.triangle.vertex))
    }
}

// MARK: Slopes

extension RegionEditorContainer {
    
    private func update(slopes hit: HitTest,
                        button: MouseButton) {
        
        guard button == .left else {
            
            return editorView.remove(slope: hit.triangle)
        }
        
        editorView.set(viewModel.slope,
                       viewModel.rise,
                       viewModel.cast,
                       for: hit.triangle)
    }
}

// MARK: Terrain

extension RegionEditorContainer {
    
    private func update(terrain hit: HitTest,
                        button: MouseButton) {
        
        viewModel.vertices(for: hit).forEach {
            
            let tile = editorView.get(biome: $0)
            
            let biome = viewModel.sculpt ? (tile?.biome ?? viewModel.biome) : viewModel.biome
            
            let elevation = tile?.elevation ?? 0
            let adjustment = button == .left ? 1 : -1
            let adjusted = viewModel.sculpt ? max(0, elevation + adjustment) : elevation
            
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
            
            editorView.remove(water: $0)
            
            guard adjusted > 0 else { return }
            
            editorView.set(viewModel.waterType,
                           adjusted,
                           for: $0)
        }
    }
}
