//
//  RegionToolsMenu.swift
//  Core
//
//  Created by Zack Brown on 20/02/2026.
//

import AppKit
import Harvest

public class RegionToolsMenu: NSMenu {
    
    required public init(target: AnyObject,
                         action: Selector) {
        
        super.init(title: "Region Tools")
        
        for tool in Tool.allCases {
            
            let item = NSMenuItem(title: tool.id,
                                  action: action,
                                  keyEquivalent: "")
            
            item.image = tool.image
            item.target = target
            
            addItem(item)
        }
    }
    
    @available(*, unavailable)
    required public init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

extension RegionToolsMenu {
    
    @MainActor
    public func popUp(_ sender: NSButton) {
        
        let origin = CGPoint(x: sender.bounds.origin.x + sender.bounds.midX,
                             y: sender.bounds.origin.y + sender.bounds.midY)
        
        popUp(positioning: items.first,
              at: origin,
              in: sender)
    }
}

