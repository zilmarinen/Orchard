//
//  InspectorTabViewCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 20/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class InspectorTabViewCoordinator: Coordinator<InspectorTabViewController> {
    
    lazy var viewModel: ViewModel = {
        
        return ViewModel(initialState: .empty)
    }()
    
    lazy var areaInspectorCoordinator: AreaInspectorCoordinator = {
       
        guard let viewController = self.controller.children[ViewState.Tab.area.rawValue] as? AreaInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = AreaInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var foliageInspectorCoordinator: FoliageInspectorCoordinator = {
       
        guard let viewController = self.controller.children[ViewState.Tab.foliage.rawValue] as? FoliageInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FoliageInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var footpathInspectorCoordinator: FootpathInspectorCoordinator = {
       
        guard let viewController = self.controller.children[ViewState.Tab.footpath.rawValue] as? FootpathInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FootpathInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var meadowInspectorCoordinator: MeadowInspectorCoordinator = {
       
        guard let viewController = self.controller.children[ViewState.Tab.meadow.rawValue] as? MeadowInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = MeadowInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var terrainInspectorCoordinator: TerrainInspectorCoordinator = {
       
        guard let viewController = self.controller.children[ViewState.Tab.terrain.rawValue] as? TerrainInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    lazy var waterInspectorCoordinator: WaterInspectorCoordinator = {
       
        guard let viewController = self.controller.children[ViewState.Tab.water.rawValue] as? WaterInspectorViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = WaterInspectorCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
 
    override init(controller: InspectorTabViewController) {
        
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

extension InspectorTabViewCoordinator {
    
    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {
        
        DispatchQueue.main.async {
         
            self.stopChildren()
            
            switch currentState {
                
            case .area(let node):
                
                self.start(child: self.areaInspectorCoordinator, with: node)
                
            case .foliage(let node):
                
                self.start(child: self.foliageInspectorCoordinator, with: node)
                
            case .footpath(let node):
                
                self.start(child: self.footpathInspectorCoordinator, with: node)
                
            case .meadow(let node):
                
                self.start(child: self.meadowInspectorCoordinator, with: node)
                
            case .terrain(let node):
                
                self.start(child: self.terrainInspectorCoordinator, with: node)
                
            case .water(let node):
                
                self.start(child: self.waterInspectorCoordinator, with: node)
                
            default: break
            }
            
            self.controller.selectedTabViewItemIndex = currentState.tab.rawValue
        }
    }
}

extension InspectorTabViewCoordinator: SceneGraphObserver {
    
    func focus(node: SceneGraphNode) {
        
        self.viewModel.select(node: node)
    }
}
