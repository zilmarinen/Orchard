//
//  Responder.swift
//  Orchard
//
//  Created by Zack Brown on 24/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import SceneKit
import Terrace

@objc extension Responder {
    
    //MARK: Window
    
    func toggle(panel: SplitViewController.Panel) { responder?.toggle(panel: panel) }
    func toggle(tab: SidebarTabViewCoordinator.ViewState.Tab) { responder?.toggle(tab: tab) }
    
    //MARK: Scene Graph
    
    func didSelect(node: SceneGraphNode) { responder?.didSelect(node: node) }
    
    //MARK: Scene
    var scene: Scene? { responder?.scene }
    var sceneView: SceneView? { responder?.sceneView }
}
