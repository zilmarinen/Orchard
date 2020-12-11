//
//  FootpathUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 03/12/2020.
//

import Cocoa
import Meadow

class FootpathUtilityCoordinator: Coordinator<FootpathUtilityViewController>, Inspector {
    
    enum Constants {
        
        static let tabViewIndentifier = NSStoryboard.SceneIdentifier("FootpathUtilityTabViewController")
    }
    
    lazy var tabViewCoordinator: FootpathUtilityTabViewCoordinator = {
        
        guard let viewController = NSStoryboard.utility.instantiateController(withIdentifier: Constants.tabViewIndentifier) as? FootpathUtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = FootpathUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    var inspectable: FootpathInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .footpath(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: FootpathUtilityViewController) {
        
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
            
            toggle(footpath: .build)
            
            refresh()
        }
    }
}

extension FootpathUtilityCoordinator {
    
    override func toggle(footpath utility: FootpathUtilityTabViewCoordinator.Tab) {
        
        tabViewCoordinator.toggle(footpath: utility)
        
        controller.buildButton.contentTintColor = (utility == .build ? .alternateSelectedControlColor : .controlColor)
        controller.paintButton.contentTintColor = (utility == .paint ? .alternateSelectedControlColor : .controlColor)
    }
}

extension FootpathUtilityCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkCountLabel.integerValue = inspectable.footpath.children.count
        
        controller.gridRenderingButton.state = (inspectable.footpath.isHidden ? .off : .on)
    }
}
