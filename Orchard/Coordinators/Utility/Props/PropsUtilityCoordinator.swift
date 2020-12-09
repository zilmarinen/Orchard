//
//  PropsUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa
import Meadow

class PropsUtilityCoordinator: Coordinator<PropsUtilityViewController>, Inspector {
    
    enum Constants {
        
        static let tabViewIndentifier = NSStoryboard.SceneIdentifier("PropsUtilityTabViewController")
    }
    
    lazy var tabViewCoordinator: PropsUtilityTabViewCoordinator = {
        
        guard let viewController = NSStoryboard.utility.instantiateController(withIdentifier: Constants.tabViewIndentifier) as? PropsUtilityTabViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = PropsUtilityTabViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    var inspectable: PropsInspectable? {
        
        guard let selectedNode = selectedNode else { return nil }
        
        switch Inspectable(node: selectedNode) {
        
        case .props(let inspectable):
            
            return inspectable
            
        default: return nil
        }
    }
    
    override init(controller: PropsUtilityViewController) {
        
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
            
            toggle(props: .build)
            
            refresh()
        }
    }
}

extension PropsUtilityCoordinator {
    
    override func toggle(props utility: PropsUtilityTabViewCoordinator.Tab) {
        
        tabViewCoordinator.toggle(props: utility)
        
        controller.buildButton.contentTintColor = (utility == .build ? .alternateSelectedControlColor : .controlColor)
        controller.paintButton.contentTintColor = (utility == .paint ? .alternateSelectedControlColor : .controlColor)
    }
}

extension PropsUtilityCoordinator {
    
    func refresh() {
        
        guard controller.isViewLoaded, let inspectable = inspectable else { return }
        
        controller.propCountLabel.integerValue = inspectable.props.children.count
        
        controller.gridRenderingButton.state = (inspectable.props.isHidden ? .off : .on)
    }
}
