//
//  NSResponder.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

@objc extension NSResponder {
    
    func toggle(panel: SplitViewController.Panel) { responder?.toggle(panel: panel) }
    func toggle(tab: SidebarTabViewCoordinator.Tab) { responder?.toggle(tab: tab) }
    
    func didSelect(node: SceneGraphNode) { responder?.didSelect(node: node) }
    func focus(node: SceneGraphNode) { responder?.focus(node: node) }
    
    var responder: NSResponder? { nextResponder }
    
    var selectedNode: SceneGraphNode? { responder?.selectedNode }
}
