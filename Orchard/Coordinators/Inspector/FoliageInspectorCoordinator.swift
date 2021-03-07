//
//  FoliageInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 07/12/2020.
//

import Cocoa
import Meadow

class FoliageInspectorCoordinator: Coordinator<FoliageInspectorViewController>, Inspector, MouseObservable {
    
    var mouseObserver: UUID?
    
    var inspectable: FoliageInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .foliage(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: FoliageInspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        refresh()
    }
}

extension FoliageInspectorCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkBox.isHidden = inspectable.chunk == nil
        controller.tileBox.isHidden = inspectable.tile == nil
        
        controller.chunkCountLabel.integerValue = inspectable.foliage.children.count
        controller.tileCountLabel.integerValue = inspectable.chunk?.children.count ?? 0
        controller.neighbourCountLabel.integerValue = inspectable.tile?.neighbours.count ?? 0
        
        controller.gridRenderingButton.state = (inspectable.foliage.isHidden ? .off : .on)
        controller.chunkRenderingButton.state = (inspectable.chunk?.isHidden ?? false ? .off : .on)
        controller.tileRenderingButton.state = (inspectable.tile?.isHidden ?? false ? .off : .on)
        
        controller.chunkCoordinateView.coordinate = inspectable.chunk?.bounds.start ?? .zero
        controller.tileCoordinateView.coordinate = inspectable.tile?.coordinate ?? .zero
    }
}

extension FoliageInspectorCoordinator {
    
    func stateDidChange(from previousState: SceneView.MouseState?, to currentState: SceneView.MouseState) {
        
        DispatchQueue.main.async { [weak self] in
            
            guard let self = self else { return }
            
            switch currentState {
            
            case .down(let position, _):
                
                guard let sceneView = self.sceneView,
                      let scene = sceneView.scene as? Scene,
                      let hit = sceneView.hitTest(point: position.start, category: [.terrain, .terrainChunk]),
                      let tile = scene.meadow.foliage.find(tile: Coordinate(vector: hit)) else { return }
                
                self.didSelect(node: tile)
                
            default: break
            }
        }
    }
}
