//
//  FootpathInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/12/2020.
//

import Cocoa
import Meadow

class FootpathInspectorCoordinator: Coordinator<FootpathInspectorViewController>, Inspector {
    
    var inspectable: FootpathInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .footpath(let inspectable):
            
            return (inspectable.footpath, inspectable.chunk, inspectable.tile)
            
        default: return nil
        }
    }
    
    override init(controller: FootpathInspectorViewController) {
        
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

extension FootpathInspectorCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkBox.isHidden = inspectable.chunk == nil
        controller.tileBox.isHidden = inspectable.tile == nil
        
        controller.chunkCountLabel.integerValue = inspectable.footpath.children.count
        controller.tileCountLabel.integerValue = inspectable.chunk?.children.count ?? 0
        controller.neighbourCountLabel.integerValue = inspectable.tile?.children.count ?? 0
        
        controller.gridRenderingButton.state = (inspectable.footpath.isHidden ? .off : .on)
        controller.chunkRenderingButton.state = (inspectable.chunk?.isHidden ?? false ? .off : .on)
        controller.tileRenderingButton.state = (inspectable.tile?.isHidden ?? false ? .off : .on)
        
        controller.chunkCoordinateView.coordinate = inspectable.chunk?.coordinate ?? .zero
        controller.tileCoordinateView.coordinate = inspectable.tile?.coordinate ?? .zero
    }
}
