//
//  BuildingInspectorCoordinator.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Harvest
import Meadow

class BuildingInspectorCoordinator: BuildingCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var chunk: BuildingChunk2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? BuildingUtilityCoordinator.ViewState,
              case let .inspector(node) = option else { return }
        
        chunk = node
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        chunk = nil
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func refresh() {
        
        guard let buildings = editor?.map.buildings,
              let chunk = chunk else { return }
        
        controller.gridRenderingButton.state = buildings.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = buildings.chunks.count
                 
        controller.nodeBox.isHidden = false
        controller.buildBox.isHidden = true
        
        controller.nodeRenderingButton.state = chunk.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = chunk.footprint.coordinate
    }
}

extension BuildingInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = scene.hitTest(point: position.end)
                
                guard let node = scene.map.buildings.find(chunk: hit) else { return }
                
                self.toggle(inspector: .surface, with: BuildingUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}


