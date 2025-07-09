//
//  WorldContainerController.swift
//  Base
//
//  Created by Zack Brown on 09/07/2025.
//

import Container

public protocol WorldContainerDelegate: ContainerViewController {}

public class WorldContainerController: ContainerViewController {
    
    private weak var delegate: WorldContainerDelegate?
    
    public init(delegate: WorldContainerDelegate) {
        
        self.delegate = delegate
        
        super.init()
    }
}
