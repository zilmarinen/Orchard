//
//  PortalInspectorCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Harvest
import Meadow

class PortalInspectorCoordinator: PortalCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    weak var chunk: PortalChunk2D?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: false)
        
        guard let option = option as? PortalUtilityCoordinator.ViewState,
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
        
        guard let portals = editor?.harvest.portals,
              let chunk = chunk else { return }
        
        controller.gridRenderingButton.state = portals.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = portals.chunks.count
                 
        controller.nodeBox.isHidden = false
        controller.buildBox.isHidden = true
        controller.segueBox.isHidden = chunk.portalType == .spawn
        
        controller.nodeRenderingButton.state = chunk.isHidden ? .off : .on
        controller.nodeCoordinateView.coordinate = chunk.footprint?.coordinate ?? .zero
        
        controller.inspectorTypePopUp.selectItem(at: chunk.portalType.rawValue)
        controller.inspectorIdentifierLabel.stringValue = chunk.identifier
        
        controller.buildDirectionPopUp.selectItem(at: chunk.segue.direction.rawValue)
        
        controller.segueSceneLabel.stringValue = chunk.segue.scene
        controller.segueIdentifierLabel.stringValue = chunk.segue.identifier
    }
}

extension PortalInspectorCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Scene2D else { return }
            
            switch currentState {
            
            case .up(let position, _):
                
                let hit = map.hitTest(point: position.end)
                
                guard let node = map.harvest.portals.find(chunk: hit) else { return }
                
                self.toggle(inspector: .portal, with: PortalUtilityCoordinator.ViewState.inspector(node: node))
                
            default: break
            }
        }
    }
}
