//
//  WaterInspectorCoordinator.swift
//
//  Created by Zack Brown on 21/03/2021.
//

import Cocoa
import Meadow

class WaterInspectorCoordinator: WaterCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var tile: WaterTile2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? WaterUtilityCoordinator.ViewState,
              case let .inspector(node) = option else { return }
        
        tile = node
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        tile = nil
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func button(button: NSButton) {
        
        super.button(button: button)
        
        guard let tile = tile else { return }
        
        switch button {
        
        case controller.tileRenderingButton:
            
            tile.isHidden = button.state == .off
            
        default: break
        }
    }
    
    override func numberStepper(numberStepper: NumberStepper) {
        
        super.numberStepper(numberStepper: numberStepper)
        
        guard let tile = tile else { return }
        
        switch numberStepper {
        
        case controller.tileCoordinateView.yStepper:
            
            tile.coordinate = Coordinate(x: tile.coordinate.x, y: numberStepper.stepper.integerValue, z: tile.coordinate.z)
            
        default: break
        }
    }
    
    override func popUp(popUp: NSPopUpButton) {
        
        super.popUp(popUp: popUp)
        
        guard let tile = tile else { return }
        
        switch popUp {
        
        case controller.inspectorTypePopUp:
            
            guard let tileType = WaterTileType(rawValue: popUp.indexOfSelectedItem) else { return }
            
            tile.tileType = tileType
            
        default: break
        }
    }
    
    override func refresh() {
        
        guard let water = editor?.water,
              let tile = tile else { return }
        
        controller.gridRenderingButton.state = water.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = water.chunks.count
                 
        controller.tileBox.isHidden = false
        controller.materialBox.isHidden = true
        
        controller.neighbourCountLabel.integerValue = tile.neighbours.count
        controller.tileRenderingButton.state = tile.isHidden ? .off : .on
        controller.tileCoordinateView.coordinate = tile.coordinate
        controller.inspectorTypePopUp.selectItem(at: tile.tileType.rawValue)
    }
}

extension WaterInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = map.hitTest(point: position.end)
                
                guard let node = map.meadow.water.find(tile: hit) else { return }
                
                self.toggle(inspector: .water, with: WaterUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}
