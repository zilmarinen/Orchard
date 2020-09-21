//
//  FootpathBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 16/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class FootpathBuildUtilityCoordinator: Coordinator<FootpathUtilityViewController> {
    
    var cursorObserver: UUID? = nil
    
    lazy var viewModel: ViewModel = {
       
        return ViewModel(initialState: .empty)
    }()

    override init(controller: FootpathUtilityViewController) {
        
        super.init(controller: controller)
        
        viewModel.subscribe(stateDidChange(from:to:))
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        viewModel.start(with: option)
        
        cursorObserver = sceneView?.cursorObserver.subscribe(stateDidChange(from:to:))
    }
    
    override func stop(then completion: CoordinatorCompletionBlock?) {
        
        if let cursorObserver = cursorObserver {
            
            sceneView?.cursorObserver.unsubscribe(cursorObserver)
        }
        
        viewModel.stop()
        
        completion?()
    }
}

extension FootpathBuildUtilityCoordinator {

    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {

        DispatchQueue.main.async {
            
            self.controller.buildBox.isHidden = false
            self.controller.paintBox.isHidden = true
            
            self.controller.utilityTypePopUp.removeAllItems()
            
            FootpathUtilityCoordinator.Utility.allCases.forEach { utility in
                
                self.controller.utilityTypePopUp.addItem(withTitle: utility.title)
            }
            
            self.controller.buildToolTypePopUp.removeAllItems()
            
            FootpathUtilityCoordinator.ToolType.allCases.forEach { toolType in
                
                self.controller.buildToolTypePopUp.addItem(withTitle: toolType.title)
            }
            
            self.controller.buildTypePopUp.removeAllItems()
            
            FootpathType.allCases.forEach { footpathType in
                
                self.controller.buildTypePopUp.addItem(withTitle: footpathType.description)
            }
            
            switch self.viewModel.state {
                
            case .build(let inspector, let toolType, let footpathType):
                
                self.controller.utilityTypePopUp.selectItem(at: FootpathUtilityCoordinator.Utility.build.rawValue)
                
                self.controller.buildToolTypePopUp.selectItem(at: toolType.rawValue)
                
                self.controller.buildTypePopUp.selectItem(at: footpathType.rawValue)
                
                self.controller.chunkCountLabel.integerValue = inspector.inspectable.grid.childCount
                self.controller.gridRenderingButton.state = (inspector.inspectable.grid.isHidden ? .off : .on)
                
            default: break
            }
        }
    }
}

extension FootpathBuildUtilityCoordinator {

    func stateDidChange(from previousState: SceneView.CursorState?, to currentState: SceneView.CursorState) {
        
        DispatchQueue.main.async {
            
            switch currentState {
                
            case .down(let position, let type):
            
                guard let hit = self.sceneView?.hitTest(point: position.start, category: .terrain) else { return }
                
                switch type {
                    
                case .left:
                    
                    self.viewModel.build(hit: hit)
                    
                case .right:
                    
                    self.viewModel.remove(hit: hit)
                    
                default: break
                }
                
            default: break
            }
        }
    }
}
