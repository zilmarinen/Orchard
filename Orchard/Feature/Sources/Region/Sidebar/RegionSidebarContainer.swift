//
//  RegionSidebarContainer.swift
//
//  Created by Zack Brown on 30/07/2025.
//

import AppKit
import Base
import Container
import Design
import Silhouette

internal protocol RegionSidebarContainerDelegate: AnyObject {}

internal class RegionSidebarContainer: ContainerViewController {
    
    private lazy var outlineViewController = OutlineViewController(delegate: self)
    
    private let viewModel: RegionViewModel
    private weak var delegate: RegionSidebarContainerDelegate?
    
    internal init(viewModel: RegionViewModel,
                  delegate: RegionSidebarContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        set(content: outlineViewController)
        
        reload()
    }
    
    internal func reload() {
        
        viewModel.reload()
        
        outlineViewController.reload()
        
        switch viewModel.selection {
            
        case .portal(let triangle):
            
            //TODO: implement selection (see world sidebar container)
            break
            
        default: break
        }
    }
}

extension RegionSidebarContainer: @preconcurrency OutlineViewControllerDelegate {
    
    internal var contents: [any TreeNode] { viewModel.contents }
    
    internal func outlineViewController(_ controller: OutlineViewController,
                                        viewForItem item: any TreeNode) -> NSTableRowView? {
        
        guard !item.isGroup else {
        
            let view = SidebarGroupView()
            
            view.text = item.displayName
            
            return view
        }
        
        let view = SidebarItemView()
        
        view.text = item.displayName
        view.image = item.image
        view.badge = !item.isLeaf ? "\(item.childCount)" : nil
        
        return view
    }
    
    internal func outlineViewController(_ controller: OutlineViewController,
                                        didSelect item: any TreeNode,
                                        atIndex index: Int) {
        
        //TODO: Implement me
    }
    
    internal func outlineViewController(_ controller: OutlineViewController,
                                        menuFor item: any TreeNode) -> NSMenu? {
        
        //TODO: Implement me
        nil
    }
}
