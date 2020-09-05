//
//  SplitViewController.swift
//  Orchard
//
//  Created by Zack Brown on 17/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import AppKit

class SplitViewController: NSSplitViewController {
    
    enum Constant {
        
        static var openPanelWidth: CGFloat = 210.0
        static var closedPanelWidth: CGFloat = 0.0
    }
    
    @objc enum Panel: Int {
        
        case sceneGraph
        case scene
        case inspector
    }
    
    enum Divider: Int {
     
        case left
        case right
    }
    
    weak var coordinator: SplitViewCoordinator?
    
    var sceneGraphViewController: SceneGraphViewController? {
        
        return children.first { return type(of: $0) == SceneGraphViewController.self } as? SceneGraphViewController
    }
    
    var sceneViewController: SceneViewController? {
        
        return children.first { return type(of: $0) == SceneViewController.self } as? SceneViewController
    }
    
    var sidebarViewController: SidebarViewController? {
        
        return children.first { return type(of: $0) == SidebarViewController.self } as? SidebarViewController
    }
}

extension SplitViewController {
    
    override func toggle(panel: Panel) {
        
        let subview = splitView.subviews[panel.rawValue]
        
        let width = splitView.isSubviewCollapsed(subview) ? Constant.openPanelWidth : Constant.closedPanelWidth
        
        switch panel {
        
        case .sceneGraph:
            
            splitView.setPosition(width, ofDividerAt: Divider.left.rawValue)
            
        case .inspector:
            
            splitView.setPosition((CGFloat(splitView.frame.width) - width), ofDividerAt: Divider.right.rawValue)
            
        default: break
        }
    }
}
