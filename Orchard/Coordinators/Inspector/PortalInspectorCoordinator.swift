//
//  PortalInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 09/12/2020.
//

import Cocoa
import Meadow

class PortalInspectorCoordinator: Coordinator<PortalInspectorViewController>, Inspector {
    
    var inspectable: PortalsInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .portals(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: PortalInspectorViewController) {
        
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

extension PortalInspectorCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkBox.isHidden = inspectable.portal == nil
        
        controller.portalCountLabel.integerValue = inspectable.portals.children.count
        controller.gridRenderingButton.state = (inspectable.portals.isHidden ? .off : .on)
        
        guard let portal = inspectable.portal else { return }
        
        controller.portalRenderingButton.state = (portal.isHidden ? .off : .on)
    }
}
