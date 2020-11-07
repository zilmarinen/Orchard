//
//  TerrainUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 05/11/2020.
//

import Cocoa
import Meadow

class TerrainUtilityCoordinator: Coordinator<TerrainUtilityViewController> {
    
    enum Constants {
        
        static let storyboard = NSStoryboard(name: NSStoryboard.Name("Utility"), bundle: nil)
        static let tabViewIndentifier = NSStoryboard.SceneIdentifier("TerrainUtilityTabViewController")
        
        static let sceneGraphWrapperIdentifier = "scene.graph"
    }
    
    lazy var tabViewCoordinator: TerrainUtilityTabViewCoordinator = {
        
        guard let viewController = Constants.storyboard.instantiateController(withIdentifier: Constants.tabViewIndentifier) as? TerrainUtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = TerrainUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
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
