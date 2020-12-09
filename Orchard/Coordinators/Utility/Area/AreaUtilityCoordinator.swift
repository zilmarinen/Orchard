//
//  AreaUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class AreaUtilityCoordinator: Coordinator<AreaUtilityViewController>, Inspector {
    
    enum Constants {
        
        static let tabViewIndentifier = NSStoryboard.SceneIdentifier("AreaUtilityTabViewController")
    }
    
    lazy var tabViewCoordinator: AreaUtilityTabViewCoordinator = {
        
        guard let viewController = NSStoryboard.utility.instantiateController(withIdentifier: Constants.tabViewIndentifier) as? AreaUtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = AreaUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    var inspectable: AreaInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .area(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: AreaUtilityViewController) {
        
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
            
            toggle(area: .build)
            
            refresh()
        }
    }
}

extension AreaUtilityCoordinator {
    
    override func toggle(area utility: AreaUtilityTabViewCoordinator.Tab) {
        
        tabViewCoordinator.toggle(area: utility)
        
        controller.buildButton.contentTintColor = (utility == .build ? .alternateSelectedControlColor : .controlColor)
        controller.paintButton.contentTintColor = (utility == .paint ? .alternateSelectedControlColor : .controlColor)
    }
}

extension AreaUtilityCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.chunkCountLabel.integerValue = inspectable.area.children.count
        
        controller.gridRenderingButton.state = (inspectable.area.isHidden ? .off : .on)
    }
}
