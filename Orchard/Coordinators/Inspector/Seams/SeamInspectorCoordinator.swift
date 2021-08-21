//
//  SeamInspectorCoordinator.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import Cocoa
import Harvest
import Meadow

class SeamInspectorCoordinator: SeamCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var tile: SeamTile2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? SeamUtilityCoordinator.ViewState,
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
    
    override func refresh() {
        
        guard let seams = editor?.map.seams,
              let tile = tile else { return }
        
        controller.gridRenderingButton.state = seams.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = seams.chunks.count
                 
        controller.nodeBox.isHidden = false
        controller.buildBox.isHidden = true
        controller.segueBox.isHidden = false
        
        controller.nodeRenderingButton.state = tile.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = tile.coordinate
        
        controller.inspectorIdentifierLabel.stringValue = tile.identifier
        
        controller.buildDirectionPopUp.selectItem(at: tile.segue.direction.rawValue)
        
        controller.segueSceneLabel.stringValue = tile.segue.scene
        controller.segueIdentifierLabel.stringValue = tile.segue.identifier
    }
}

extension SeamInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = scene.hitTest(point: position.end)
                
                guard let node = scene.map.seams.find(tile: hit) else { return }
                
                self.toggle(inspector: .seam, with: SeamUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}
