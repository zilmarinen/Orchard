//
//  WorldSidebarContainer.swift
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Container
import Deltille
import Design
import Harvest
import Silhouette

internal protocol WorldSidebarContainerDelegate: AnyObject {
    
    func worldSidebarContainer(_ container: WorldSidebarContainer,
                               didRequestDeletionFor selection: Document.Selection)
    
    func worldSidebarContainer(_ container: WorldSidebarContainer,
                               didRequestEditingFor selection: Document.Selection)
    
    func worldSidebarContainer(_ container: WorldSidebarContainer,
                               didSelect selection: Document.Selection)
}

internal class WorldSidebarContainer: ContainerViewController {
    
    // MARK: Menu Actions
    
    private lazy var deleteRegionAction = NSMenuItem(title: "Delete Region",
                                                     action: #selector(menuItem(_:)),
                                                     keyEquivalent: "")
    
    private lazy var deleteZoneAction = NSMenuItem(title: "Delete Zone",
                                                   action: #selector(menuItem(_:)),
                                                   keyEquivalent: "")
    
    private lazy var editRegionAction = NSMenuItem(title: "Edit Region",
                                                   action: #selector(menuItem(_:)),
                                                   keyEquivalent: "")
    
    private lazy var editZoneAction = NSMenuItem(title: "Edit Zone",
                                                 action: #selector(menuItem(_:)),
                                                 keyEquivalent: "")
    
    // MARK: Menus
    
    private lazy var regionMenu = with(NSMenu(title: "Region")) {
        
        $0.addItem(editRegionAction)
        $0.addItem(deleteRegionAction)
    }
    
    private lazy var zoneMenu = with(NSMenu(title: "Zone")) {
        
        $0.addItem(editZoneAction)
        $0.addItem(deleteZoneAction)
    }
    
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
        
        set(content: outlineViewController)
        
        reload()
    }
    
    internal func reload() {
        
        viewModel.reload()
        
        outlineViewController.reload()
        
        switch viewModel.selection {
            
        case .region(let vertex):
            
            guard let intermediate = viewModel.region(intermediate: vertex) else { return }
            
            outlineViewController.select(item: intermediate)
            
        case .zone(let vertex):
            
            guard let intermediate = viewModel.zone(intermediate: vertex) else { return }
            
            outlineViewController.select(item: intermediate)
            
        default: break
        }
    }
}

extension WorldSidebarContainer {
    
    @objc
    internal func menuItem(_ sender: NSMenuItem) {
        
        switch sender {
            
        case deleteRegionAction,
             editRegionAction:
            
            guard let item = sender.representedObject as? RegionIntermediate else { return }
            
            guard sender == deleteRegionAction else {
                
                delegate?.worldSidebarContainer(self,
                                                didRequestEditingFor: .region(vertex: item.vertex))
                
                return
            }
            
            delegate?.worldSidebarContainer(self,
                                            didRequestDeletionFor: .region(vertex: item.vertex))
            
        case deleteZoneAction,
             editZoneAction:
            
            guard let item = sender.representedObject as? ZoneIntermediate else { return }
            
            guard sender == deleteZoneAction else {
                
                delegate?.worldSidebarContainer(self,
                                                didRequestEditingFor: .zone(vertex: item.vertex))
                
                return
            }
            
            delegate?.worldSidebarContainer(self,
                                            didRequestDeletionFor: .zone(vertex: item.vertex))
            
        default: fatalError("Invalid sender for menu item")
        }
    }
}

extension WorldSidebarContainer: @preconcurrency OutlineViewControllerDelegate {
    
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
        
        switch item {
            
        case let item as RegionIntermediate:
            
            delegate?.worldSidebarContainer(self,
                                            didSelect: .region(vertex: item.vertex))
            
        case let item as ZoneIntermediate:
            
            delegate?.worldSidebarContainer(self,
                                            didSelect: .zone(vertex: item.vertex))
            
        default:
            
            delegate?.worldSidebarContainer(self,
                                            didSelect: .none)
        }
    }
    
    internal func outlineViewController(_ controller: OutlineViewController,
                                        menuFor item: any TreeNode) -> NSMenu? {
        
        switch item {
            
        case let item as RegionIntermediate:
            
            regionMenu.title = item.displayName
            
            deleteRegionAction.representedObject = item
            editRegionAction.representedObject = item
            
            return regionMenu
            
        case let item as ZoneIntermediate:
            
            zoneMenu.title = item.displayName
            
            deleteZoneAction.representedObject = item
            editZoneAction.representedObject = item
            
            return zoneMenu
            
        default: return nil
        }
    }
}
