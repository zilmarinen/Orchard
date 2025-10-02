//
//  ToolSelectionContainer.swift
//  Core
//
//  Created by Zack Brown on 02/10/2025.
//

import Base
import Container

public protocol ToolSelectionContainerDelegate: AnyObject {
    
}

public class ToolSelectionContainer: ContainerViewController {
    
    private let dataSource: ToolSelectionInspectorDataSource
    private weak var delegate: ToolSelectionContainerDelegate?
    
    public init(dataSource: ToolSelectionInspectorDataSource,
                delegate: ToolSelectionContainerDelegate) {
        
        self.dataSource = dataSource
        self.delegate = delegate
        
        super.init()
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        reload()
    }
    
    public func reload() {
     
        switch dataSource.selectedTool {
            
        case .terrain:
            
            set(content: TerrainInspectorViewController())
            
        default:
            
            set(content: .init())
        }
    }
}
