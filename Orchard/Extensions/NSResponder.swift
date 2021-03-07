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
    
    func toggle(area utility: AreaUtilityTabViewCoordinator.Tab) { responder?.toggle(area: utility) }
    func toggle(buildings utility: BuildingsUtilityTabViewCoordinator.Tab) { responder?.toggle(buildings: utility) }
    func toggle(foliage utility: FoliageUtilityTabViewCoordinator.Tab) { responder?.toggle(foliage: utility) }
    func toggle(footpath utility: FootpathUtilityTabViewCoordinator.Tab) { responder?.toggle(footpath: utility) }
    func toggle(portals utility: PortalUtilityTabViewCoordinator.Tab) { responder?.toggle(portals: utility) }
    func toggle(props utility: PropsUtilityTabViewCoordinator.Tab) { responder?.toggle(props: utility) }
    func toggle(terrain utility: TerrainUtilityTabViewCoordinator.Tab) { responder?.toggle(terrain: utility) }
    
    func didSelect(node: SceneGraphNode) { responder?.didSelect(node: node) }
    func focus(node: SceneGraphNode) { responder?.focus(node: node) }
    
    var responder: NSResponder? { nextResponder }
    
    var sceneView: SceneView? { responder?.sceneView }
    var selectedNode: SceneGraphNode? { responder?.selectedNode }
}
