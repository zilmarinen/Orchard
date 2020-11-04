//
//  SplitViewController.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

@objc extension NSResponder {
    
    func toggle(panel: SplitViewController.Panel) { nextResponder?.toggle(panel: panel) }
}

class SplitViewController: NSSplitViewController {
    
    enum Constants {
            
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
        
        return children.first { type(of: $0) == SceneGraphViewController.self } as? SceneGraphViewController
    }
    
    var sceneViewController: SceneViewController? {
        
        return children.first { type(of: $0) == SceneViewController.self } as? SceneViewController
    }
    
    var inspectorViewController: InspectorViewController? {
        
        return children.first { type(of: $0) == InspectorViewController.self } as? InspectorViewController
    }
}

extension SplitViewController {
    
    override func toggle(panel: Panel) {
        
        let subview = splitView.subviews[panel.rawValue]
        
        let width = splitView.isSubviewCollapsed(subview) ? Constants.openPanelWidth : Constants.closedPanelWidth
        
        switch panel {
        
        case .sceneGraph:
            
            splitView.setPosition(width, ofDividerAt: Divider.left.rawValue)
            
        case .inspector:
            
            splitView.setPosition((CGFloat(splitView.frame.width) - width), ofDividerAt: Divider.right.rawValue)
            
        default: break
        }
    }
}
