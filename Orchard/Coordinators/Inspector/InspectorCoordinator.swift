//
//  InspectorCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class InspectorCoordinator: Coordinator<InspectorViewController> {
    
    override init(controller: InspectorViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        controller.inspectorButton.contentTintColor = .systemPink
    }
}
