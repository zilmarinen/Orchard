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
import Toolbox

internal protocol RegionEditorContainerDelegate: AnyObject {
    
    func regionEditorContainer(_ container: RegionEditorContainer,
                               didSelect selection: RegionViewModel.Selection)
}

internal class RegionEditorContainer: ContainerViewController {
    
    private lazy var editorController = RegionEditorViewController(viewModel: viewModel,
                                                                   delegate: self)
    
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
        
        super.init()
        
        set(content: editorController)
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
        
        reload()
    }
    
    internal func reload() {
        
        do {
            
            try viewModel.load()
        }
        catch {
            
            //TODO: Handle error
            presentError(error)
        }
    }
    
    internal func focus() {
        
        switch viewModel.selection {
            
        case .portal(let vertex):
            
            viewModel.camera(focus: vertex.position(.tile))
            
        default: break
        }
    }
}

extension RegionEditorContainer {

    @objc
    private func menuItem(_ sender: NSMenuItem) {
        
        guard let tool = Tool(rawValue: sender.title.lowercased()) else { return }
        
        viewModel.select(tool: tool)
    }
}

// MARK: Region Editor

extension RegionEditorContainer: @preconcurrency RegionEditorViewDelegate {
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    keyDown keyCode: NSEvent.KeyCode) {
     
        switch keyCode {
            
        case .q: viewModel.camera(rotate: .clockwise)
        case .e: viewModel.camera(rotate: .counterClockwise)
        case .r: viewModel.cursor(rotate: .clockwise)
        default: break
        }
    }
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    click button: MouseButton,
                                    location: CGPoint) {
        
        // ignore events outside of active region
        guard let hit = viewModel.hit(location),
              viewModel.canEdit(hit.vertex) else { return }
        
        // ignore events when popover controller is active / dismissed
        guard presentedViewControllers?.isEmpty ?? true else { return }
        
        switch viewModel.tool {
            
        case .buildings:
            
            viewModel.update(buildings: hit,
                             button: button)
            
        case .fences:
            
            viewModel.update(fence: hit,
                             button: button)

        case .foliage:
            
            viewModel.update(foliage: hit,
                             button: button)
            
        case .footpaths:
            
            viewModel.update(footpath: hit,
                             button: button)
            
        case .portals:
            
            viewModel.update(portal: hit,
                             button: button)
            
        case .slopes:
            
            viewModel.update(slopes: hit,
                             button: button)
        
        case .terrain:
            
            viewModel.update(terrain: hit,
                             button: button)
        
        case .water:
            
            viewModel.update(water: hit,
                             button: button)
            
        default: break
        }
    }
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    hover location: CGPoint) {
        
        guard let hit = viewModel.hit(location) else { return }
        
        viewModel.cursor(focus: hit.pointInWorld)
        
        cursorOverlay.update(hit)
    }
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    magnify magnification: Double) {
        
        viewModel.camera(zoom: magnification)
    }
    
    func regionEditorViewController(_ viewController: RegionEditorViewController,
                                    pan button: MouseButton,
                                    location: CGPoint,
                                    translation: CGPoint) {
        
        viewModel.camera(translate: .init(translation.x,
                                          0.0,
                                          translation.y))
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
