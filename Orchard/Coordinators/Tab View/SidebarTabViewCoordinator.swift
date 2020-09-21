//
//  SidebarTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class SidebarTabViewCoordinator: Coordinator<SidebarTabViewController> {
    
    lazy var viewModel: ViewModel = {
        
        return ViewModel(initialState: .empty)
    }()
    
    lazy var inspectorTabViewCoordinator: InspectorTabViewCoordinator = {
       
        guard let viewController = controller.inspectorTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = InspectorTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var utilityTabViewCoordinator: UtilityTabViewCoordinator = {
       
        guard let viewController = controller.utilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = UtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: SidebarTabViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        viewModel.start(with: option)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        stopChildren()
        
        viewModel.stop()
        
        completion?()
    }
}

extension SidebarTabViewCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        DispatchQueue.main.async {
            
            self.stopChildren()
            
            switch currentState {
                
            case .inspector(let node):
                
                self.start(child: self.inspectorTabViewCoordinator, with: node)
                
            case .utility(let node):
                
                self.start(child: self.utilityTabViewCoordinator, with: node)
                
            default: break
            }
            
            self.controller.selectedTabViewItemIndex = currentState.tab.rawValue
        }
    }
}

extension SidebarTabViewCoordinator {
    
    override func toggle(tab: SidebarTabViewCoordinator.ViewState.Tab) {
        
        self.viewModel.toggle(tab: tab)
    }
}

extension SidebarTabViewCoordinator: SceneGraphObserver {
    
    func focus(node: SceneGraphNode) {
        
        guard let node = node as? SceneGraphIdentifiable else { return }
        
        self.viewModel.select(node: node)
    }
}
