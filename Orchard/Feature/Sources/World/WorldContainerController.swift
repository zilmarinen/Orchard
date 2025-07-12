//
//  WorldContainerController.swift
//  Base
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base

public protocol WorldContainerDelegate: AnyObject {
    
    func worldContainer(_ container: WorldContainerController,
                        didSelect region: Bool)
}

public class WorldContainerController: NSSplitViewController {
    
    private let sidebarContainer = WorldSidebarContainer()
    private lazy var editorContainer = WorldEditorContainer(delegate: self)
    private let inspectorContainer = NSViewController()
    
    private lazy var sidebarItem = with(NSSplitViewItem(sidebarWithViewController: sidebarContainer)) {
        
        $0.allowsFullHeightLayout = true
        $0.maximumThickness = 256
        $0.minimumThickness = 128
        $0.titlebarSeparatorStyle = .line
    }
    
    private lazy var editorItem = NSSplitViewItem(viewController: editorContainer)
    private lazy var inspectorItem = with(NSSplitViewItem(inspectorWithViewController: inspectorContainer)) {
        
        $0.allowsFullHeightLayout = true
        $0.maximumThickness = 256
        $0.minimumThickness = 128
        $0.titlebarSeparatorStyle = .line
    }
    
    unowned(unsafe) private let document: Document
    private weak var delegate: WorldContainerDelegate?
    
    public init(document: Document,
                delegate: WorldContainerDelegate) {
        
        self.document = document
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

extension WorldContainerController: @preconcurrency WorldEditorDelegate {
    
    internal func worldEditorContainer(_ container: WorldEditorContainer,
                                       didSelect region: Bool) {
        
        delegate?.worldContainer(self,
                                 didSelect: region)
    }
}
