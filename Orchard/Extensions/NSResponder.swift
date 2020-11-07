//
//  NSResponder.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

@objc extension NSResponder {
    
    func toggle(splitView panel: SplitViewController.Panel) { responder?.toggle(splitView: panel) }
    func toggle(sidebar tab: SidebarTabViewCoordinator.Tab) { responder?.toggle(sidebar: tab) }
    func toggle(inspector tab: InspectorTabViewCoordinator.Tab) { responder?.toggle(inspector: tab) }
    func toggle(utility tab: UtilityTabViewCoordinator.Tab) { responder?.toggle(utility: tab) }
    func toggle(terrain utility: TerrainUtilityTabViewCoordinator.Tab) { responder?.toggle(terrain: utility) }
    
    func didSelect(node: SceneGraphNode) { responder?.didSelect(node: node) }
    func focus(node: SceneGraphNode) { responder?.focus(node: node) }
    
    var responder: NSResponder? { nextResponder }
    
    var selectedNode: SceneGraphNode? { responder?.selectedNode }
}
