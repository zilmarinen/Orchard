//
//  FootpathInspectorCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Harvest
import Meadow

class FootpathInspectorCoordinator: FootpathCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var tile: FootpathTile2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? FootpathUtilityCoordinator.ViewState,
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
    
    override func popUp(popUp: NSPopUpButton) {
        
        super.popUp(popUp: popUp)
        
        guard let tile = tile else { return }
        
        switch popUp {
        
        case controller.inspectorTypePopUp:
            
            guard let tileType = FootpathTileType(rawValue: popUp.indexOfSelectedItem) else { return }
            
            tile.tileType = tileType
            
        default: break
        }
    }
    
    override func refresh() {
        
        guard let footpath = editor?.map.footpath,
              let tile = tile else { return }
        
        controller.gridRenderingButton.state = footpath.isHidden ? .off : .on
        controller.chunkCountLabel.integerValue = footpath.chunks.count
                 
        controller.tileBox.isHidden = false
        controller.materialBox.isHidden = true
        
        controller.neighbourCountLabel.integerValue = tile.neighbours.count
        controller.tileRenderingButton.state = tile.isHidden ? .off : .on
        controller.tileCoordinateView.coordinate = tile.coordinate
        controller.inspectorTypePopUp.selectItem(at: tile.tileType.rawValue)
    }
}

extension FootpathInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = scene.hitTest(point: position.end)
                
                guard let tile = scene.map.footpath.find(tile: hit) else { return }
                
                self.toggle(inspector: .footpath, with: FootpathUtilityCoordinator.ViewState.inspector(node: tile))
                
            default: break
            }
        }
    }
}
