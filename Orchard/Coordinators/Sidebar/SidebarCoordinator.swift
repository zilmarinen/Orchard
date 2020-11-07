//
//  SidebarCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Meadow

class SidebarCoordinator: Coordinator<SidebarViewController> {
    
    lazy var tabViewCoordinator: SidebarTabViewCoordinator = {
        
        guard let viewController = controller.tabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SidebarTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: SidebarViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        guard let scene = option as? Scene else { fatalError("Invalid start option") }
        
        start(child: tabViewCoordinator, with: option)
        
        focus(node: scene)
    }
}

extension SidebarCoordinator {
    
    override func focus(node: SceneGraphNode) {
        
        toggle(sidebar: .inspector)
    }
    
    override func toggle(sidebar tab: SidebarTabViewCoordinator.Tab) {
        
        tabViewCoordinator.toggle(sidebar: tab)
        
        controller.inspectorButton.contentTintColor = (tab == .inspector ? .alternateSelectedControlColor : .controlColor)
        controller.utilityButton.contentTintColor = (tab == .utility ? .alternateSelectedControlColor : .controlColor)
    }
}
