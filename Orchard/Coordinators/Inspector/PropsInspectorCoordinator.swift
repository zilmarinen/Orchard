//
//  PropsInspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class PropsInspectorCoordinator: Coordinator<PropsInspectorViewController>, Inspector {
    
    var inspectable: PropsInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .props(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: PropsInspectorViewController) {
        
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

extension PropsInspectorCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkBox.isHidden = inspectable.prop == nil
        
        controller.propCountLabel.integerValue = inspectable.props.children.count
        controller.gridRenderingButton.state = (inspectable.props.isHidden ? .off : .on)
        
        guard let prop = inspectable.prop else { return }
        
        controller.propRenderingButton.state = (prop.isHidden ? .off : .on)
    }
}
