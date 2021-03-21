//
//  SplitViewController.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class SplitViewController: NSSplitViewController {
    
    enum Constants {
            
        static var openPanelWidth: CGFloat = 280.0
        static var closedPanelWidth: CGFloat = 0.0
    }
    
    @objc enum Panel: Int {
        
        case toolbar
        case scene
        case inspector
    }
    
    enum Divider: Int {
     
        case left
        case right
    }
    
    weak var coordinator: SplitViewCoordinator?
    
    var toolbarViewController: ToolbarViewController? {
        
        return children.first { type(of: $0) == ToolbarViewController.self } as? ToolbarViewController
    }
    
    var sceneViewController: SceneViewController? {
        
        return children.first { type(of: $0) == SceneViewController.self } as? SceneViewController
    }
    
    var inspectorViewController: InspectorViewController? {
        
        return children.first { type(of: $0) == InspectorViewController.self } as? InspectorViewController
    }
    
    func hide(panel: Panel) {
        
        let subview = splitView.subviews[panel.rawValue]
        
        guard !splitView.isSubviewCollapsed(subview) else { return }
        
        switch panel {
        
        case .toolbar:
            
            splitView.setPosition(0, ofDividerAt: Divider.left.rawValue)
        
        case .inspector:
            
            splitView.setPosition(splitView.frame.width, ofDividerAt: Divider.right.rawValue)
            
        default: break
        }
    }
    
    func show(panel: Panel) {
        
        let subview = splitView.subviews[panel.rawValue]
        
        guard splitView.isSubviewCollapsed(subview) else { return }
        
        switch panel {
        
        case .toolbar:
            
            splitView.setPosition(Constants.openPanelWidth, ofDividerAt: Divider.left.rawValue)
        
        case .inspector:
            
            splitView.setPosition((CGFloat(splitView.frame.width) - Constants.openPanelWidth), ofDividerAt: Divider.right.rawValue)
            
        default: break
        }
    }
}

extension SplitViewController {
    
    override func toggle(splitView panel: Panel) {
        
        let subview = splitView.subviews[panel.rawValue]
        
        let width = splitView.isSubviewCollapsed(subview) ? Constants.openPanelWidth : Constants.closedPanelWidth
        
        switch panel {
        
        case .toolbar:
            
            splitView.setPosition(width, ofDividerAt: Divider.left.rawValue)
            
        case .inspector:
            
            splitView.setPosition((CGFloat(splitView.frame.width) - width), ofDividerAt: Divider.right.rawValue)
            
        default: break
        }
    }
}
