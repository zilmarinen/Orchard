//
//  SplitViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow

class SplitViewCoordinator: Coordinator<SplitViewController> {
    
    lazy var sceneGraphCoordinator: SceneGraphCoordinator = {
       
        guard let viewController = controller.sceneGraphViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneGraphCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var sceneCoordinator: SceneCoordinator = {
       
        guard let viewController = controller.sceneViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SceneCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var sidebarCoordinator: SidebarCoordinator = {
       
        guard let viewController = controller.sidebarViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SidebarCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    weak var focus: SceneGraphNode?
    
    override init(controller: SplitViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        guard let scene = option as? Scene else { fatalError("Invalid start option") }
        
        focus = scene
        
        start(child: sceneGraphCoordinator, with: option)
        start(child: sceneCoordinator, with: option)
        start(child: sidebarCoordinator, with: option)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        stop(child: sceneGraphCoordinator)
        stop(child: sceneCoordinator)
        stop(child: sidebarCoordinator)
    }
}

extension SplitViewCoordinator {
    
    override var sceneView: SceneView? { sceneCoordinator.controller._sceneView }
    
    override var selectedNode: SceneGraphNode? { focus }
    
    override func didSelect(node: SceneGraphNode) {
        
        focus = node
        
        sceneGraphCoordinator.focus(node: node)
        sceneCoordinator.focus(node: node)
        sidebarCoordinator.focus(node: node)
    }
    
    override func toggle(season: Int) {
        
        guard let season = Season(rawValue: season),
              let scene = sceneView?.scene as? Scene else { return }
        
        scene.meadow.world = World(season: season)
        
        scene.meadow.soil()
    }
}
