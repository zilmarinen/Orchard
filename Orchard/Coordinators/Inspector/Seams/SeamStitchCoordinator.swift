//
//  SeamStitchCoordinator.swift
//
//  Created by Zack Brown on 01/06/2021.
//

import Cocoa
import Harvest
import Meadow

class SeamStitchCoordinator: SeamCoordinator, MouseObservable {
    
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
        
        guard let seams = editor?.map.seams else { return }
        
        controller.gridRenderingButton.state = seams.isHidden ? .off : .on
        controller.nodeCountLabel.integerValue = seams.chunks.count
                 
        controller.nodeBox.isHidden = true
        controller.buildBox.isHidden = false
        controller.segueBox.isHidden = false
    }
}

extension SeamStitchCoordinator {
    
    func stateDidChange(from previousState: SpriteView.MouseState?, to currentState: SpriteView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self,
                  let spriteView = self.spriteView,
                  let scene = spriteView.scene as? Scene2D,
                  let direction = Cardinal(rawValue: self.controller.buildDirectionPopUp.indexOfSelectedItem) else { return }
            
            switch currentState {
            
            case .up(let position, let clickType):
                
                let startHit = scene.hitTest(point: position.start)
                let endHit = scene.hitTest(point: position.end)
                
                switch clickType {
                
                case .right:
                
                    let bounds = GridBounds(start: startHit, end: endHit)
                
                    bounds.enumerate(y: 0) { coordinate in
                    
                        scene.map.seams.remove(tile: coordinate)
                    }
                    
                default:
                    
                    let identifier = self.controller.buildIdentifierLabel.stringValue
                    let segueScene = self.controller.segueSceneLabel.stringValue
                    let segueIdentifier = self.controller.segueIdentifierLabel.stringValue
                    
                    guard !identifier.isEmpty,
                          !segueScene.isEmpty,
                          !segueIdentifier.isEmpty else { return }
                    
                    _ = scene.map.seams.add(seam: startHit) { seam in
                        
                        seam.identifier = identifier
                        seam.segue = PortalSegue(direction: direction, scene: segueScene, identifier: segueIdentifier)
                    }
                }
                
            default: break
            }
            
            self.refresh()
        }
    }
}
