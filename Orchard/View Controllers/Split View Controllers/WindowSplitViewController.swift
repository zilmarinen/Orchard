//
//  WindowSplitViewController.swift
//  Orchard
//
//  Created by Zack Brown on 17/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Cocoa

class WindowSplitViewController: NSSplitViewController {
    
    enum Panel: Int {
        
        case sceneGraph
        case scene
        case utilities
    }
    
    enum Divider: Int {
     
        case left
        case right
    }
    
    var sceneGraphViewController: SceneGraphViewController?
    var sceneViewController: SceneViewController?
    var sidebarViewController: SidebarViewController?
}

extension WindowSplitViewController {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        sceneGraphViewController = children.first { return type(of: $0) == SceneGraphViewController.self } as? SceneGraphViewController
        
        sceneViewController = children.first { return type(of: $0) == SceneViewController.self } as? SceneViewController
        
        sidebarViewController = children.first { return type(of: $0) == SidebarViewController.self } as? SidebarViewController
    }
}

extension WindowSplitViewController {
    
    func toggle(panel: Panel) {
        
        let subview = splitView.subviews[panel.rawValue]
        
        let panelWidth = CGFloat(250.0)
        
        switch panel {
        
        case .sceneGraph:
            
            let position = CGFloat(splitView.isSubviewCollapsed(subview) ? panelWidth : 0.0)
            
            splitView.setPosition(position, ofDividerAt: Divider.left.rawValue)
            
        case .utilities:
            
            let width = CGFloat(splitView.frame.width)
            
            let position = CGFloat(splitView.isSubviewCollapsed(subview) ? (width - panelWidth) : width)
            
            splitView.setPosition(position, ofDividerAt: Divider.right.rawValue)
            
        default: break
        }
    }
}
