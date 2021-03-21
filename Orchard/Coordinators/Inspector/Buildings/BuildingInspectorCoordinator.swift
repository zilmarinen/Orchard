//
//  BuildingInspectorCoordinator.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Meadow

class BuildingInspectorCoordinator: BuildingCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var building: Building2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? BuildingUtilityCoordinator.ViewState,
              case let .inspector(node) = option else { return }
        
        building = node
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        building = nil
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let buildings = editor?.buildings,
              let building = building else { return }
        
        controller.gridRenderingButton.state = buildings.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = buildings.buildings.count
                 
        controller.nodeBox.isHidden = false
        controller.buildBox.isHidden = true
        
        controller.nodeRenderingButton.state = building.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = building.footprint.coordinate
    }
}

extension BuildingInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = map.hitTest(point: position.end)
                
                guard let node = map.meadow.buildings.find(building: hit) else { return }
                
                self.toggle(inspector: .surface, with: BuildingUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}


