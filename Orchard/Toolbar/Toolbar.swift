//
//  Toolbar.swift
//  Orchard
//
//  Created by Zack Brown on 11/07/2025.
//

import AppKit
import Base

protocol ToolbarDelegate: AnyObject {
    
    func toolbar(_ toolbar: Toolbar,
                 didTap toolbarItem: NSToolbarItem.ItemIdentifier)
}

internal class Toolbar: NSToolbar,
                        NSToolbarDelegate {
    
    private static let identifier: NSToolbar.Identifier = .init("orchard.toolbar")

    private lazy var debug = with(NSToolbarItem(identifier: .debug)) {
        
        $0.target = self
        $0.action = #selector(toolbarItem(_:))
    }
    
    private weak var eventHandler: ToolbarDelegate?
    
    init(eventHandler: ToolbarDelegate) {
        
        self.eventHandler = eventHandler
        
        super.init(identifier: Self.identifier)
        
        allowsDisplayModeCustomization = false
        allowsExtensionItems = false
        allowsUserCustomization = false
        delegate = self
        displayMode = .iconOnly
    }
}

extension Toolbar {
 
    @objc
    private func toolbarItem(_ sender: NSToolbarItem) {
        
        guard let identifier = NSToolbarItem.ItemIdentifier(rawValue: sender.itemIdentifier.rawValue) else { return }
        
        eventHandler?.toolbar(self,
                              didTap: identifier)
    }
}

extension Toolbar {
    
    public func toolbar(_ toolbar: NSToolbar,
                        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                        willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        guard let identifier = NSToolbarItem.ItemIdentifier(rawValue: itemIdentifier.rawValue) else { return nil }
        
        switch identifier {
            
        case .debug: return debug
        }
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        [.toggleSidebar,
         .sidebarTrackingSeparator,
         .inspectorTrackingSeparator,
         .flexibleSpace,
         .toggleInspector]
    }
    
    public func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { toolbarDefaultItemIdentifiers(toolbar) }
    
    public func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { toolbarDefaultItemIdentifiers(toolbar) }
}
