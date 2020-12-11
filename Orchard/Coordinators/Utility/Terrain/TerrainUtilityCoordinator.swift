//
//  TerrainUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class TerrainUtilityCoordinator: Coordinator<TerrainUtilityViewController>, Inspector {
    
    enum Constants {
        
        static let tabViewIndentifier = NSStoryboard.SceneIdentifier("TerrainUtilityTabViewController")
    }
    
    lazy var tabViewCoordinator: TerrainUtilityTabViewCoordinator = {
        
        guard let viewController = NSStoryboard.utility.instantiateController(withIdentifier: Constants.tabViewIndentifier) as? TerrainUtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    var inspectable: TerrainInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .terrain(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: TerrainUtilityViewController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: SceneGraphNode?) {
        
        super.start(with: option)
        
        start(child: tabViewCoordinator, with: option)
        
        if controller.isViewLoaded {
            
            toggle(terrain: .build)
            
            refresh()
        }
    }
}

extension TerrainUtilityCoordinator {
    
    override func toggle(terrain utility: TerrainUtilityTabViewCoordinator.Tab) {
        
        tabViewCoordinator.toggle(terrain: utility)
        
        controller.buildButton.contentTintColor = (utility == .build ? .alternateSelectedControlColor : .controlColor)
        controller.paintButton.contentTintColor = (utility == .paint ? .alternateSelectedControlColor : .controlColor)
    }
}

extension TerrainUtilityCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkCountLabel.integerValue = inspectable.terrain.children.count
        
        controller.gridRenderingButton.state = (inspectable.terrain.isHidden ? .off : .on)
    }
}
