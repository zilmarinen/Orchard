//
//  FoliageUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 07/12/2020.
//

import Cocoa
import Meadow

class FoliageUtilityCoordinator: Coordinator<FoliageUtilityViewController>, Inspector {
    
    enum Constants {
        
        static let tabViewIndentifier = NSStoryboard.SceneIdentifier("FoliageUtilityTabViewController")
    }
    
    lazy var tabViewCoordinator: FoliageUtilityTabViewCoordinator = {
        
        guard let viewController = NSStoryboard.utility.instantiateController(withIdentifier: Constants.tabViewIndentifier) as? FoliageUtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FoliageUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    var inspectable: FoliageInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .foliage(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: FoliageUtilityViewController) {
        
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
            
            toggle(foliage: .build)
            
            refresh()
        }
    }
}

extension FoliageUtilityCoordinator {
    
    override func toggle(foliage utility: FoliageUtilityTabViewCoordinator.Tab) {
        
        tabViewCoordinator.toggle(foliage: utility)
        
        controller.buildButton.contentTintColor = (utility == .build ? .alternateSelectedControlColor : .controlColor)
        controller.paintButton.contentTintColor = (utility == .paint ? .alternateSelectedControlColor : .controlColor)
    }
}

extension FoliageUtilityCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkCountLabel.integerValue = inspectable.foliage.children.count
        
        controller.gridRenderingButton.state = (inspectable.foliage.isHidden ? .off : .on)
    }
}
