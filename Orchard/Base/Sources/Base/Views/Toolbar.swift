//
//  Toolbar.swift
//
//  Created by Zack Brown on 11/07/2025.
//

import AppKit

public protocol ToolbarDelegate: AnyObject {
    
    func toolbar(_ toolbar: Toolbar,
                 didTap toolbarItem: NSToolbarItem.Item)
    
    func toolbarDefaultItemIdentifiers(_ toolbar: Toolbar) -> [NSToolbarItem.Identifier]
}

public class Toolbar: NSToolbar,
                      NSToolbarDelegate {
    
    private lazy var back = with(NSToolbarItem(item: .chevronBackward)) {
        
        $0.target = self
        $0.action = #selector(toolbarItem(_:))
    }
    
    private lazy var share = with(NSToolbarItem(item: .share)) {
        
        $0.target = self
        $0.action = #selector(toolbarItem(_:))
    }
    
    private weak var eventHandler: ToolbarDelegate?
    
    public init(eventHandler: ToolbarDelegate) {
        
        self.eventHandler = eventHandler
        
        super.init(identifier: "orchard.toolbar")
        
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
        
        guard let identifier = NSToolbarItem.Item(rawValue: sender.label) else { return }
        
        eventHandler?.toolbar(self,
                              didTap: identifier)
        
        selectedItemIdentifier = nil
    }
}

extension Toolbar {
    
    public func toolbar(_ toolbar: NSToolbar,
                        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
                        willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        
        switch itemIdentifier {
            
        case .chevronBackward: back
        case .share: share
        default: fatalError("Invalid toolbar item [\(itemIdentifier.rawValue)]")
        }
    }
    
    public func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        eventHandler?.toolbarDefaultItemIdentifiers(self) ?? []
    }
    
    public func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] { toolbarDefaultItemIdentifiers(toolbar) }
    
    public func toolbarSelectableItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        
        [.chevronBackward,
         .share]
    }
}
