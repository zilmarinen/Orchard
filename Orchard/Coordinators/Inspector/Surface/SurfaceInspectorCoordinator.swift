//
//  SurfaceInspectorCoordinator.swift
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa
import Harvest
import Meadow

class SurfaceInspectorCoordinator: SurfaceCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var tile: SurfaceTile2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? SurfaceUtilityCoordinator.ViewState,
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
        
        case controller.inspectorTileTypePopUp:
            
            guard let tileType = SurfaceTileType(rawValue: popUp.indexOfSelectedItem) else { return }
            
            tile.tileType = tileType
            
        case controller.inspectorMaterialPopUp:
            
            guard let material = SurfaceMaterial(rawValue: popUp.indexOfSelectedItem) else { return }
            
            tile.material = material
            
        default: break
        }
    }
    
    override func refresh() {
        
        guard let surface = editor?.map.surface,
              let tile = tile else { return }
        
        controller.gridRenderingButton.state = surface.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = surface.chunks.count
                 
        controller.tileBox.isHidden = false
        controller.materialBox.isHidden = true
        controller.elevationBox.isHidden = true
        controller.edgeBox.isHidden = true
        
        controller.neighbourCountLabel.integerValue = tile.neighbours.count
        controller.tileRenderingButton.state = tile.isHidden ? .off : .on
        controller.tileCoordinateView.coordinate = tile.coordinate
        controller.inspectorTileTypePopUp.selectItem(at: tile.tileType.rawValue)
        
        controller.inspectorMaterialPopUp.selectItem(at: tile.material?.rawValue ?? SurfaceMaterial.allCases.count)
    }
}

extension SurfaceInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = scene.hitTest(point: position.end)
                
                guard let node = scene.map.surface.find(tile: hit) else { return }
                
                self.toggle(inspector: .surface, with: SurfaceUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}
