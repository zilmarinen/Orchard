//
//  WorldContainerController.swift
//  Base
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base
import Deltille

public protocol WorldContainerDelegate: AnyObject {}

public class WorldContainerController: NSSplitViewController {
    
    private enum Constant {
        
        static let defaultSidebarThickness = 256.0
    }
    
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
    
    public init(document: Document,
                delegate: WorldContainerDelegate) {
        
        self.viewModel = .init(document: document)
        self.delegate = delegate
        
        super.init(nibName: nil,
                   bundle: nil)
        
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

extension WorldContainerController: @preconcurrency WorldSidebarContainerDelegate {
    
    internal func worldSidebarContainer(_ container: WorldSidebarContainer,
                                        didSelect coordinate: Coordinate?) {
        
        if let coordinate{
            
            viewModel.update(selection: .region(coordinate: coordinate))
        }
        else {
            
            viewModel.update(selection: .none)
        }
        
        inspectorContainer.reload()
    }
}

extension WorldContainerController: @preconcurrency WorldEditorContainerDelegate {
    
    internal func worldEditorContainer(_ container: WorldEditorContainer,
                                       didSelect coordinate: Coordinate) {
        
        print("Editor selected Region: \(coordinate.id)")
        
        viewModel.update(selection: .region(coordinate: coordinate))
    }
}

extension WorldContainerController: @preconcurrency WorldInspectorContainerDelegate {
    
    func worldInspectorContainer(_ container: WorldInspectorContainer,
                                 didUpdate coordinate: Coordinate) {
        
        //
    }
}
