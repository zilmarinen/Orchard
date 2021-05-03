//
//  PortalBuildCoordinator.swift
//
//  Created by Zack Brown on 16/03/2021.
//

import Cocoa
import Harvest
import Meadow

class PortalBuildCoordinator: PortalCoordinator, MouseObservable {
    
    var mouseObserver: UUID?
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        subscribeToMouseEvents(tracksIdleEvents: true)
        
        guard controller.isViewLoaded else { return }
        
        refresh()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
    
    override func popUp(popUp: NSPopUpButton) {
        
        refresh()
    }
    
    override func refresh() {
        
        guard let portals = editor?.harvest.portals else { return }
        
        controller.gridRenderingButton.state = portals.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = portals.chunks.count
                 
        controller.nodeBox.isHidden = true
        controller.buildBox.isHidden = false
        controller.segueBox.isHidden = true
        
        guard let portalType = PortalType(rawValue: self.controller.buildTypePopUp.indexOfSelectedItem) else { return }
        
        controller.segueBox.isHidden = portalType == .spawn
    }
}

extension PortalBuildCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let map = spriteView.scene as? Scene2D,
                  let portalType = PortalType(rawValue: self.controller.buildTypePopUp.indexOfSelectedItem),
                  let direction = Cardinal(rawValue: self.controller.buildDirectionPopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = map.hitTest(point: position.start)
                
                switch clickType {
                
                case .right:
                    
                    let endHit = map.hitTest(point: position.end)
                    
                    let bounds = GridBounds(start: startHit, end: endHit)
                    
                    bounds.enumerate(y: 0) { coordinate in
                        
                        map.harvest.portals.remove(chunk: coordinate)
                    }
                    
                default:
                    
                    let identifier = self.controller.buildIdentifierLabel.stringValue
                    let segueScene = self.controller.segueSceneLabel.stringValue
                    let segueIdentifier = self.controller.segueIdentifierLabel.stringValue
                    
                    guard !identifier.isEmpty else { return }
                    
                    if portalType != .spawn {
                        
                        guard !segueScene.isEmpty,
                              !segueIdentifier.isEmpty else { return }
                    }
                    
                    guard let surfaceTile = map.harvest.surface.find(tile: startHit) else { return }
                    
                    _ = map.harvest.portals.add(portal: portalType, coordinate: surfaceTile.coordinate) { portal in
                        
                        portal.identifier = identifier
                        portal.segue = PortalSegue(direction: direction, scene: segueScene, identifier: segueIdentifier)
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
