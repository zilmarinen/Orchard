//
//  PortalUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 09/12/2020.
//

import Cocoa
import Meadow

class PortalUtilityCoordinator: Coordinator<PortalUtilityViewController>, Inspector {
    
    enum Constants {
        
        static let tabViewIndentifier = NSStoryboard.SceneIdentifier("PortalUtilityTabViewController")
    }
    
    lazy var tabViewCoordinator: PortalUtilityTabViewCoordinator = {
        
        guard let viewController = NSStoryboard.utility.instantiateController(withIdentifier: Constants.tabViewIndentifier) as? PortalUtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PortalUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    var inspectable: PortalsInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .portals(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: PortalUtilityViewController) {
        
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
            
            toggle(portals: .build)
            
            refresh()
        }
    }
}

extension PortalUtilityCoordinator {
    
    override func toggle(portals utility: PortalUtilityTabViewCoordinator.Tab) {
        
        tabViewCoordinator.toggle(portals: utility)
        
        controller.buildButton.contentTintColor = (utility == .build ? .alternateSelectedControlColor : .controlColor)
    }
}

extension PortalUtilityCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.portalCountLabel.integerValue = inspectable.portals.children.count
        
        controller.gridRenderingButton.state = (inspectable.portals.isHidden ? .off : .on)
    }
}

