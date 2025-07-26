//
//  WorldSidebarContainer.swift
//  Feature
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Container
import Deltille
import OutlineView

internal protocol WorldSidebarContainerDelegate: AnyObject {
    
    func worldSidebarContainer(_ container: WorldSidebarContainer,
                               didSelect coordinate: Coordinate?)
}

internal class WorldSidebarContainer: VerticalStackContainerViewController {
    
    private lazy var outlineViewController = OutlineViewController(delegate: self)
    
    private let viewModel: WorldViewModel
    private weak var delegate: WorldSidebarContainerDelegate?
    
    internal init(viewModel: WorldViewModel,
                  delegate: WorldSidebarContainerDelegate) {
        
        self.viewModel = viewModel
        self.delegate = delegate
        
        super.init()
    }
    
    internal override func viewDidLoad() {
        
        super.viewDidLoad()
        
        insert(viewController: outlineViewController)
    }
}

extension WorldSidebarContainer: @preconcurrency OutlineViewControllerDelegate {
    
    internal var contents: [any TreeNode] { viewModel.contents }
    
    internal func outlineViewController(_ controller: OutlineViewController,
                                        viewForItem item: any TreeNode) -> NSTableRowView? {
        
        guard !item.isGroup else {
        
            let view = SidebarGroupView()
            
            view.text = item.name
            
            return view
        }
        
        let view = SidebarItemView()
        
        view.text = item.name
        view.image = item.image
        view.badge = !item.isLeaf ? "\(item.childCount)" : nil
        
        return view
    }
    
    internal func outlineViewController(_ controller: OutlineViewController,
                                        didSelect item: any TreeNode,
                                        atIndex index: Int) {
        
        guard let item = item as? RegionIntermediate else {
            
            delegate?.worldSidebarContainer(self,
                                            //didSelect: nil)
                                            didSelect: .unitX)
            return
        }
        
        delegate?.worldSidebarContainer(self,
                                        didSelect: item.coordinate)
    }
}
