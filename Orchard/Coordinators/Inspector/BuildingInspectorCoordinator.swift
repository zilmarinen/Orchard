//
//  BuildingInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 01/02/2021.
//

import Cocoa
import Meadow

class BuildingInspectorCoordinator: Coordinator<BuildingInspectorViewController>, Inspector, MouseObservable {
    
    var mouseObserver: UUID?
    
    var inspectable: BuildingInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .buildings(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: BuildingInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        refresh()
        
        subscribeToMouseEvents(tracksIdleEvents: false)
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        unsubscribeFromMouseEvents()
        
        super.stop(then: completion)
    }
}

extension BuildingInspectorCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkBox.isHidden = inspectable.chunk == nil
        controller.tileBox.isHidden = inspectable.tile == nil
        controller.layerBox.isHidden = inspectable.layer == nil
        
        controller.chunkCountLabel.integerValue = inspectable.buildings.children.count
        controller.gridRenderingButton.state = (inspectable.buildings.isHidden ? .off : .on)
        
        guard let chunk = inspectable.chunk else { return }
        
        controller.tileCountLabel.integerValue = chunk.children.count
        controller.chunkRenderingButton.state = chunk.isHidden ? .off : .on
        controller.chunkCoordinateView.coordinate = chunk.bounds.start
        
        guard let tile = inspectable.tile else { return }
        
        controller.layerCountLabel.integerValue = tile.children.count
        controller.neighbourCountLabel.integerValue = tile.neighbours.count
        controller.tileRenderingButton.state = tile.isHidden ? .off : .on
        controller.tileCoordinateView.coordinate = tile.coordinate
        
        for index in 0..<tile.children.count {
            
            controller.layerPopUp.addItem(withTitle: "Layer \(index + 1)")
        }
        
        guard let layer = inspectable.layer else { return }
        
        controller.layerRenderingButton.state = layer.isHidden ? .off : .on
        controller.layerColorWell.color = layer.color.color
        
        guard let index = tile.index(of: layer) else { return }
        
        controller.layerPopUp.selectItem(at: index)
    }
}

extension BuildingInspectorCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .down(let position, _):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position.start, category: [.buildings, .buildingChunk]),
                      let tile = scene.meadow.buildings.find(tile: Coordinate(vector: hit)) else { return }
                
                self.didSelect(node: tile)
                
            default: break
            }
        }
    }
}
