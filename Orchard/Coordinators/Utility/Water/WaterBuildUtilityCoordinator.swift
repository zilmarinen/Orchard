//
//  WaterBuildUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 15/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class WaterBuildUtilityCoordinator: Coordinator<WaterUtilityViewController> {
    
    var cursorObserver: UUID? = nil
    
    lazy var viewModel: ViewModel = {
       
        return ViewModel(initialState: .empty)
    }()

    override init(controller: WaterUtilityViewController) {
        
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

extension WaterBuildUtilityCoordinator {

    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {

        DispatchQueue.main.async {
            
            self.controller.buildBox.isHidden = false
            self.controller.paintBox.isHidden = true
            
            self.controller.utilityTypePopUp.removeAllItems()
            
            WaterUtilityCoordinator.Utility.allCases.forEach { utility in
                
                self.controller.utilityTypePopUp.addItem(withTitle: utility.title)
            }
            
            self.controller.buildToolTypePopUp.removeAllItems()
            
            WaterUtilityCoordinator.ToolType.allCases.forEach { toolType in
                
                self.controller.buildToolTypePopUp.addItem(withTitle: toolType.title)
            }
            
            self.controller.buildTypePopUp.removeAllItems()
            
            WaterType.allCases.forEach { waterType in
                
                self.controller.buildTypePopUp.addItem(withTitle: waterType.description)
            }
            
            switch self.viewModel.state {
                
            case .build(let inspector, let toolType, let waterType):
                
                self.controller.utilityTypePopUp.selectItem(at: WaterUtilityCoordinator.Utility.build.rawValue)
                
                self.controller.buildToolTypePopUp.selectItem(at: toolType.rawValue)
                
                self.controller.buildTypePopUp.selectItem(at: waterType.rawValue)
                
                self.controller.chunkCountLabel.integerValue = inspector.inspectable.grid.childCount
                self.controller.gridRenderingButton.state = (inspector.inspectable.grid.isHidden ? .off : .on)
                
            default: break
            }
        }
    }
}

extension WaterBuildUtilityCoordinator {

    func stateDidChange(from previousState: SceneView.CursorState?, to currentState: SceneView.CursorState) {
        
        DispatchQueue.main.async {
            
            switch currentState {
                
            case .down(let position, let type):
            
                guard let hit = self.sceneView?.hitTest(point: position.start, category: .meadow) ?? self.sceneView?.hitTest(point: position.start, category: .terrain) else { return }
                
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

