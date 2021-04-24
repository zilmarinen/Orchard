//
//  FoliageInspectorCoordinator.swift
//
//  Created by Zack Brown on 15/03/2021.
//

import Cocoa
import Meadow

class FoliageInspectorCoordinator: FoliageCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var chunk: FoliageChunk2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? FoliageUtilityCoordinator.ViewState,
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
    
    override func button(button: NSButton) {
        
        super.button(button: button)
        
        guard let chunk = chunk else { return }
        
        switch button {
        
        case controller.nodeRenderingButton:
            
            chunk.isHidden = button.state == .off
            
        default: break
        }
    }
    
    override func popUp(popUp: NSPopUpButton) {
        
        super.popUp(popUp: popUp)
        
        guard let chunk = chunk else { return }
        
        switch popUp {
        
        case controller.inspectorTypePopUp:
            
            guard let foliageType = FoliageType(rawValue: popUp.indexOfSelectedItem) else { return }
            
            chunk.foliageType = foliageType
            
        default: break
        }
    }
    
    override func refresh() {
        
        guard let foliage = editor?.foliage,
              let chunk = chunk else { return }
        
        controller.gridRenderingButton.state = foliage.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = foliage.chunks.count
                 
        controller.nodeBox.isHidden = false
        controller.plantBox.isHidden = true
        
        controller.nodeRenderingButton.state = chunk.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = chunk.footprint.coordinate
        controller.inspectorTypePopUp.selectItem(at: chunk.foliageType.rawValue)
    }
}

extension FoliageInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Map else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = map.hitTest(point: position.end)
                
                guard let node = map.meadow.foliage.find(chunk: hit) else { return }
                
                self.toggle(inspector: .foliage, with: FoliageUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}

