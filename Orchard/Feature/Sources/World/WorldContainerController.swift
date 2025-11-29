//
//  WorldContainerController.swift
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base
import Deltille

public protocol WorldContainerDelegate: NSWindowController {
    
    func worldContainerController(_ container: WorldContainerController,
                                  didRequestEditingFor selection: Document.Selection)
}

public class WorldContainerController: NSSplitViewController,
                                       @preconcurrency HasToolbar {
    
    private enum Constant {
        
        static let defaultSidebarThickness = 256.0
    }
    
    public lazy var toolbar = Toolbar(eventHandler: self)
    
    private lazy var sidebarContainer = WorldSidebarContainer(viewModel: viewModel,
                                                              delegate: self)
    private lazy var editorContainer = WorldEditorContainer(viewModel: viewModel,
                                                            delegate: self)
    private lazy var inspectorContainer = WorldInspectorContainer(viewModel: viewModel,
                                                                  delegate: self)
    
    private lazy var sidebarItem = with(NSSplitViewItem(sidebarWithViewController: sidebarContainer)) {
        
        $0.allowsFullHeightLayout = true
        $0.maximumThickness = Constant.defaultSidebarThickness
        $0.minimumThickness = Constant.defaultSidebarThickness
        $0.titlebarSeparatorStyle = .line
    }
    
    private lazy var editorItem = NSSplitViewItem(viewController: editorContainer)
    private lazy var inspectorItem = with(NSSplitViewItem(inspectorWithViewController: inspectorContainer)) {
        
        $0.allowsFullHeightLayout = true
        $0.maximumThickness = Constant.defaultSidebarThickness
        $0.minimumThickness = Constant.defaultSidebarThickness
        $0.titlebarSeparatorStyle = .line
    }
    
    private let viewModel: WorldViewModel
    private weak var delegate: WorldContainerDelegate?
    
    public init(triangle: Triangle,
                document: Document,
                delegate: WorldContainerDelegate) {
        
        self.viewModel = .init(triangle: triangle,
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

extension WorldContainerController: @preconcurrency ToolbarDelegate {
    
    public func toolbar(_ toolbar: Toolbar,
                        didTap toolbarItem: NSToolbarItem.Item) {
        
        print("Toolbar item [\(toolbarItem.identifier)]")
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: Toolbar) -> [NSToolbarItem.Identifier] {
        
        [.toggleSidebar,
         .sidebarTrackingSeparator,
         .share,
         .inspectorTrackingSeparator,
         .flexibleSpace,
         .toggleInspector]
    }
}

extension WorldContainerController {
    
    private func presentDeletionAlert(selection: Document.Selection) {
        
        switch selection {
            
        case .region(let triangle): presentDeleteRegionAlert(triangle: triangle)
        case .zone(let triangle): presentDeleteZoneAlert(triangle: triangle)
        default: fatalError("Invalid selection for deletion \(selection)")
        }
    }
    
    private func presentDeleteRegionAlert(triangle: Triangle) {
        
        guard let window = delegate?.window,
              let intermediate = viewModel.region(for: triangle) else { return }
        
        let alert = NSAlert(type: .deleteRegion(identifier: intermediate.displayName),
                            buttons: [.cancel,
                                      .deleteRegion])
        
        alert.beginSheetModal(for: window) { [weak self] response in
            
            guard let self,
                  response != .alertFirstButtonReturn else { return }
            
            self.viewModel.delete(region: triangle)
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
    
    private func presentDeleteZoneAlert(triangle: Triangle) {
        
        guard let window = delegate?.window,
              let intermediate = viewModel.zone(for: triangle) else { return }
        
        let alert = NSAlert(type: .deleteZone(identifier: intermediate.displayName),
                            buttons: [.cancel,
                                      .deleteZone])
        
        alert.beginSheetModal(for: window) { [weak self] response in
            
            guard let self,
                  response != .alertFirstButtonReturn else { return }
            
            self.viewModel.delete(zone: triangle)
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

extension WorldContainerController: @preconcurrency WorldSidebarContainerDelegate {
    
    func worldSidebarContainer(_ container: WorldSidebarContainer,
                               didRequestDeletionFor selection: Document.Selection) {
        
        presentDeletionAlert(selection: selection)
    }
    
    func worldSidebarContainer(_ container: WorldSidebarContainer,
                               didRequestEditingFor selection: Document.Selection) {
        
        delegate?.worldContainerController(self,
                                           didRequestEditingFor: selection)
    }
    
    // When item is selected from sidebar;
    // - focus editor view
    // - select appropriate inspector view
    
    internal func worldSidebarContainer(_ container: WorldSidebarContainer,
                                        didSelect selection: Document.Selection) {
        
        viewModel.update(selection: selection)
        
        editorContainer.focus()
        inspectorContainer.reload()
    }
}

extension WorldContainerController: @preconcurrency WorldEditorContainerDelegate {
    
    // When item is selected from editor;
    // - select appropriate item in sidebar
    // - focus editor view
    // - select appropriate inspector view
    
    internal func worldEditorContainer(_ container: WorldEditorContainer,
                                       didSelect selection: Document.Selection) {
        
        viewModel.update(selection: selection)
        
        sidebarContainer.reload()
        editorContainer.focus()
        inspectorContainer.reload()
    }
}

extension WorldContainerController: @preconcurrency WorldInspectorContainerDelegate {
    
    internal func worldInspectorContainer(_ container: WorldInspectorContainer,
                                          didRequestDeletionFor selection: Document.Selection) {
        
        presentDeletionAlert(selection: selection)
    }
    
    internal func worldInspectorContainer(_ container: WorldInspectorContainer,
                                          didRequestEditingFor selection: Document.Selection) {
        
        delegate?.worldContainerController(self,
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
