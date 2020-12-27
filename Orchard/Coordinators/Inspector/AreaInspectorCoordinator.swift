//
//  AreaInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class AreaInspectorCoordinator: Coordinator<AreaInspectorViewController>, Inspector, MouseObservable {
    
    var mouseObserver: UUID?
    
    var inspectable: AreaInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .area(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: AreaInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        refresh()
        
        subscribeToMouseEvents()
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
}

extension AreaInspectorCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkBox.isHidden = inspectable.chunk == nil
        controller.tileBox.isHidden = inspectable.tile == nil
        
        controller.chunkCountLabel.integerValue = inspectable.area.children.count
        controller.gridRenderingButton.state = (inspectable.area.isHidden ? .off : .on)
        
        guard let chunk = inspectable.chunk else { return }
        
        controller.tileCountLabel.integerValue = chunk.children.count
        controller.chunkRenderingButton.state = chunk.isHidden ? .off : .on
        controller.chunkCoordinateView.coordinate = chunk.coordinate
        
        guard let tile = inspectable.tile else { return }
        
        controller.neighbourCountLabel.integerValue = tile.neighbours.count
        controller.tileRenderingButton.state = tile.isHidden ? .off : .on
        controller.tileCoordinateView.coordinate = tile.coordinate
        controller.typePopUp.selectItem(at: tile.tileType.rawValue)
        controller.slopeButton.state = (tile.slope == nil ? .off : .on)
        controller.directionPopUp.isEnabled = tile.slope != nil
        
        if let slope = tile.slope {
            
            controller.directionPopUp.selectItem(at: slope.rawValue)
        }
    }
}

extension AreaInspectorCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .down(let position, _):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position.start, category: [.area, .areaChunk]),
                      let tile = scene.meadow.area.find(tile: Coordinate(vector: hit)) else { return }
                
                self.didSelect(node: tile)
                
            default: break
            }
        }
    }
}
