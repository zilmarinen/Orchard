//
//  RegionContainerController.swift
//  Feature
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base
import Deltille

public protocol RegionContainerDelegate: AnyObject {
    
    func regionContainerDidFinish(_ container: RegionContainerController)
}

public class RegionContainerController: NSSplitViewController,
                                        @preconcurrency HasToolbar {
     
    private enum Constant {
         
        static let defaultSidebarThickness = 256.0
    }
     
    public lazy var toolbar = Toolbar(eventHandler: self)
    
    private lazy var sidebarContainer = RegionSidebarContainer(viewModel: viewModel,
                                                               delegate: self)
    private lazy var editorContainer = RegionEditorContainer(viewModel: viewModel,
                                                             delegate: self)
    private lazy var inspectorContainer = RegionInspectorContainer(viewModel: viewModel,
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
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionContainerDelegate?
    
    public init(coordinate: Grid.Coordinate,
                document: Document,
                delegate: RegionContainerDelegate) {
        
        self.viewModel = .init(coordinate: coordinate,
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

extension RegionContainerController: @preconcurrency ToolbarDelegate {
    
    public func toolbar(_ toolbar: Toolbar,
                        didTap toolbarItem: NSToolbarItem.Item) {
        
        switch toolbarItem {
            
        case .chevronBackward:
            
            NSApp.sendAction(#selector(Document.save(_:)),
                             to: nil,
                             from: self)
            
            delegate?.regionContainerDidFinish(self)
            
        default: fatalError("Invalid sender for toolbar item")
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

extension RegionContainerController: @preconcurrency RegionSidebarContainerDelegate {}
extension RegionContainerController: @preconcurrency RegionEditorContainerDelegate {}
extension RegionContainerController: @preconcurrency RegionInspectorContainerDelegate {}
