//
//  WorldContainer.swift
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base
import Deltille
import Design

public protocol WorldContainerDelegate: NSWindowController {
    
    func worldContainer(_ container: WorldContainer,
                        didRequestEditingFor selection: Document.Selection)
}

public class WorldContainer: NSSplitViewController,
                                       @preconcurrency HasToolbar {
    
    public lazy var toolbar = Toolbar(eventHandler: self)
    
    private lazy var sidebarContainer = WorldSidebarContainer(viewModel: viewModel,
                                                              delegate: self)
    private lazy var editorContainer = WorldEditorContainer(viewModel: viewModel,
                                                            delegate: self)
    private lazy var inspectorContainer = WorldInspectorContainer(viewModel: viewModel,
                                                                  delegate: self)
    
    private lazy var sidebarItem = with(NSSplitViewItem(sidebarWithViewController: sidebarContainer)) {
        
        $0.maximumThickness = .defaultSidebarThickness
        $0.minimumThickness = .defaultSidebarThickness
    }
    
    private lazy var editorItem = with(NSSplitViewItem(viewController: editorContainer)) {
    
        $0.canCollapse = false
        $0.canCollapseFromWindowResize = false
    }
    
    private lazy var inspectorItem = with(NSSplitViewItem(inspectorWithViewController: inspectorContainer)) {
        
        $0.maximumThickness = .defaultSidebarThickness
        $0.minimumThickness = .defaultSidebarThickness
    }
    
    private let viewModel: WorldViewModel
    private weak var delegate: WorldContainerDelegate?
    
    public init(vertex: Triangle.Vertex,
                document: Document,
                delegate: WorldContainerDelegate) {
        
        self.viewModel = .init(vertex: vertex,
                               document: document)
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
        
        title = "World"
        
        insertSplitViewItem(sidebarItem,
                            at: splitViewItems.count)
        insertSplitViewItem(editorItem,
                            at: splitViewItems.count)
        insertSplitViewItem(inspectorItem,
                            at: splitViewItems.count)
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension WorldContainer: @preconcurrency ToolbarDelegate {
    
    public func toolbar(_ toolbar: Toolbar,
                        didTap toolbarItem: NSToolbarItem.Item) {
        
        print("Toolbar item [\(toolbarItem.identifier)]")
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: Toolbar) -> [NSToolbarItem.Identifier] {
        
        [.toggleSidebar,
         .sidebarTrackingSeparator,
         .inspectorTrackingSeparator,
         .flexibleSpace,
         .toggleInspector]
    }
}

extension WorldContainer {
    
    private func presentDeletionAlert(selection: Document.Selection) {
        
        switch selection {
            
        case .region(let vertex): presentDeleteRegionAlert(vertex: vertex)
        case .zone(let vertex): presentDeleteZoneAlert(vertex: vertex)
        default: fatalError("Invalid selection for deletion \(selection)")
        }
    }
    
    private func presentDeleteRegionAlert(vertex: Triangle.Vertex) {
        
        guard let window = delegate?.window,
              let intermediate = viewModel.region(intermediate: vertex) else { return }
        
        let alert = NSAlert(type: .deleteRegion(identifier: intermediate.displayName),
                            buttons: [.cancel,
                                      .deleteRegion])
        
        alert.beginSheetModal(for: window) { [weak self] response in
            
            guard let self,
                  response != .alertFirstButtonReturn else { return }
            
            do {
                
                try self.viewModel.delete(region: vertex)
            }
            catch {
                
                self.delegate?.present(error: error)
            }
            
            self.viewModel.updateDefaultSelection()
            
            // When item is deleted;
            // - reload sidebar
            // - reload editor
            // - select appropriate inspector view
            
            self.sidebarContainer.reload()
            self.editorContainer.reload()
            self.inspectorContainer.reload()
        }
    }
    
    private func presentDeleteZoneAlert(vertex: Triangle.Vertex) {
        
        guard let window = delegate?.window,
              let intermediate = viewModel.zone(intermediate: vertex) else { return }
        
        let alert = NSAlert(type: .deleteZone(identifier: intermediate.displayName),
                            buttons: [.cancel,
                                      .deleteZone])
        
        alert.beginSheetModal(for: window) { [weak self] response in
            
            guard let self,
                  response != .alertFirstButtonReturn else { return }
            
            do {
                
                try self.viewModel.delete(zone: vertex)
            }
            catch {
                
                self.delegate?.present(error: error)
            }
            
            self.viewModel.updateDefaultSelection()
            
            // When item is deleted;
            // - reload sidebar
            // - reload editor
            // - select appropriate inspector view
            
            self.sidebarContainer.reload()
            self.editorContainer.reload()
            self.inspectorContainer.reload()
        }
    }
}

extension WorldContainer: @preconcurrency WorldSidebarContainerDelegate {
    
    func worldSidebarContainer(_ container: WorldSidebarContainer,
                               didRequestDeletionFor selection: Document.Selection) {
        
        presentDeletionAlert(selection: selection)
    }
    
    func worldSidebarContainer(_ container: WorldSidebarContainer,
                               didRequestEditingFor selection: Document.Selection) {
        
        delegate?.worldContainer(self,
                                 didRequestEditingFor: selection)
    }
    
    // When item is selected from sidebar;
    // - focus editor view
    // - select appropriate inspector view
    //   - show inspector view if hidden
    
    internal func worldSidebarContainer(_ container: WorldSidebarContainer,
                                        didSelect selection: Document.Selection) {
        
        viewModel.update(selection: selection)
        
        editorContainer.focus()
        inspectorContainer.reload()
        
        inspectorItem.isCollapsed = false
    }
}

extension WorldContainer: @preconcurrency WorldEditorContainerDelegate {
    
    // When item is selected from editor;
    // - select appropriate item in sidebar
    // - focus editor view
    // - select appropriate inspector view
    //   - show inspector view if hidden
    
    internal func worldEditorContainer(_ container: WorldEditorContainer,
                                       didSelect selection: Document.Selection) {
        
        viewModel.update(selection: selection)
        
        sidebarContainer.reload()
        editorContainer.focus()
        inspectorContainer.reload()
        
        inspectorItem.isCollapsed = false
    }
}

extension WorldContainer: @preconcurrency WorldInspectorContainerDelegate {
    
    internal func worldInspectorContainer(_ container: WorldInspectorContainer,
                                          didRequestDeletionFor selection: Document.Selection) {
        
        presentDeletionAlert(selection: selection)
    }
    
    internal func worldInspectorContainer(_ container: WorldInspectorContainer,
                                          didRequestEditingFor selection: Document.Selection) {
        
        delegate?.worldContainer(self,
                                 didRequestEditingFor: selection)
    }
    
    // When item properties are modified from inspector;
    // - select appropriate item in sidebar
    // - focus editor view
    
    internal func worldInspectorContainer(_ container: WorldInspectorContainer,
                                          didUpdate selection: Document.Selection) {
        
        sidebarContainer.reload()
        editorContainer.focus()
    }
}
