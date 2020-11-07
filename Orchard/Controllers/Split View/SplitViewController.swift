//
//  SplitViewController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class SplitViewController: NSSplitViewController {
    
    enum Constants {
            
        static var openPanelWidth: CGFloat = 210.0
        static var closedPanelWidth: CGFloat = 0.0
    }
    
    @objc enum Panel: Int {
        
        case sceneGraph
        case scene
        case sidebar
    }
    
    enum Divider: Int {
     
        case left
        case right
    }
    
    weak var coordinator: SplitViewCoordinator?
    
    var sceneGraphViewController: SceneGraphViewController? {
        
        return children.first { type(of: $0) == SceneGraphViewController.self } as? SceneGraphViewController
    }
    
    var sceneViewController: SceneViewController? {
        
        return children.first { type(of: $0) == SceneViewController.self } as? SceneViewController
    }
    
    var sidebarViewController: SidebarViewController? {
        
        return children.first { type(of: $0) == SidebarViewController.self } as? SidebarViewController
    }
}

extension SplitViewController {
    
    override func toggle(splitView panel: Panel) {
        
        let subview = splitView.subviews[panel.rawValue]
        
        let width = splitView.isSubviewCollapsed(subview) ? Constants.openPanelWidth : Constants.closedPanelWidth
        
        switch panel {
        
        case .sceneGraph:
            
            splitView.setPosition(width, ofDividerAt: Divider.left.rawValue)
            
        case .sidebar:
            
            splitView.setPosition((CGFloat(splitView.frame.width) - width), ofDividerAt: Divider.right.rawValue)
            
        default: break
        }
    }
}
