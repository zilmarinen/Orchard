//
//  BuildingsUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 01/02/2021.
//

import Cocoa
import Meadow

class BuildingsUtilityCoordinator: Coordinator<BuildingsUtilityViewController>, Inspector {
    
    enum Constants {
        
        static let tabViewIndentifier = NSStoryboard.SceneIdentifier("BuildingsUtilityTabViewController")
    }
    
    lazy var tabViewCoordinator: BuildingsUtilityTabViewCoordinator = {
        
        guard let viewController = NSStoryboard.utility.instantiateController(withIdentifier: Constants.tabViewIndentifier) as? BuildingsUtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = BuildingsUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    var inspectable: BuildingInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .buildings(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: BuildingsUtilityViewController) {
        
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
            
            toggle(buildings: .build)
            
            refresh()
        }
    }
}

extension BuildingsUtilityCoordinator {
    
    override func toggle(buildings utility: BuildingsUtilityTabViewCoordinator.Tab) {
        
        tabViewCoordinator.toggle(buildings: utility)
        
        controller.buildButton.contentTintColor = (utility == .build ? .alternateSelectedControlColor : .controlColor)
    }
}

extension BuildingsUtilityCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkCountLabel.integerValue = inspectable.buildings.children.count
        
        controller.gridRenderingButton.state = (inspectable.buildings.isHidden ? .off : .on)
    }
}
