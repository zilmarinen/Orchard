//
//  RegionContainerController.swift
//  Feature
//
//  Created by Zack Brown on 09/07/2025.
//

import Container

public protocol RegionContainerDelegate: ContainerViewController {}

public class RegionContainerController: ContainerViewController {
    
    private weak var delegate: RegionContainerDelegate?
    
    public init(delegate: RegionContainerDelegate) {
        
        self.delegate = delegate
        
        super.init()
    }
}
