//
//  RegionContainer.swift
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base
import Deltille
import Design

public protocol RegionContainerDelegate: NSWindowController {
    
    func regionContainer(_ container: RegionContainer,
                         didFinishEditingRegion vertex: Triangle.Vertex)
}

public class RegionContainer: NSSplitViewController,
                              @preconcurrency HasToolbar {
     
    public lazy var toolbar = Toolbar(eventHandler: self)
    
    private lazy var sidebarContainer = RegionSidebarContainer(viewModel: viewModel,
                                                               delegate: self)
    private lazy var editorContainer = RegionEditorContainer(viewModel: viewModel,
                                                             delegate: self)
    private lazy var inspectorContainer = RegionInspectorContainer(viewModel: viewModel,
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
        $0.isCollapsed = true
    }
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionContainerDelegate?
    
    public init(vertex: Triangle.Vertex,
                document: Document,
                delegate: RegionContainerDelegate) {
        
        self.viewModel = .init(vertex: vertex,
                               document: document)
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
        
        title = viewModel.identifier
        
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

extension RegionContainer: @preconcurrency ToolbarDelegate {
    
    public func toolbar(_ toolbar: Toolbar,
                        didTap toolbarItem: NSToolbarItem.Item) {
        
        switch toolbarItem {
            
        case .chevronBackward:
            
            do {
                
                try viewModel.save()
                
                NSApp.sendAction(#selector(Document.save(_:)),
                                 to: nil,
                                 from: self)
                
                delegate?.regionContainer(self,
                                          didFinishEditingRegion: viewModel.region.vertex)
            }
            catch {
                
                delegate?.present(error: error)
            }
        }
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: Toolbar) -> [NSToolbarItem.Identifier] {
        
        [.toggleSidebar,
         .sidebarTrackingSeparator,
         .chevronBackward,
         .inspectorTrackingSeparator,
         .flexibleSpace,
         .toggleInspector]
    }
}

extension RegionContainer: @preconcurrency RegionSidebarContainerDelegate {}

extension RegionContainer: @preconcurrency RegionEditorContainerDelegate {
    
    // When item is selected from editor;
    // - select appropriate item in sidebar
    // - focus editor view
    // - select appropriate inspector view
    //   - show inspector view if hidden
    
    internal func regionEditorContainer(_ container: RegionEditorContainer,
                                        didSelect selection: RegionViewModel.Selection) {
        
        viewModel.update(selection: selection)
        
        sidebarContainer.reload()
        editorContainer.focus()
        inspectorContainer.reload()
        
        inspectorItem.isCollapsed = false
    }
}

extension RegionContainer: @preconcurrency RegionInspectorContainerDelegate {}
