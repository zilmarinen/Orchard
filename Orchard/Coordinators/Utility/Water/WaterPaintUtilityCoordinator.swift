//
//  WaterPaintUtilityCoordinator.swift
//  Orchard
//
//  Created by Zack Brown on 15/09/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

import Meadow
import Terrace

class WaterPaintUtilityCoordinator: Coordinator<WaterUtilityViewController> {
    
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

extension WaterPaintUtilityCoordinator {

    func stateDidChange(from previousState: ViewState?, to currentState: ViewState) {

        DispatchQueue.main.async {
            
            self.controller.buildBox.isHidden = true
            self.controller.paintBox.isHidden = false
            
            self.controller.utilityTypePopUp.removeAllItems()
            
            WaterUtilityCoordinator.Utility.allCases.forEach { utility in
                
                self.controller.utilityTypePopUp.addItem(withTitle: utility.title)
            }
            
            self.controller.paintToolTypePopUp.removeAllItems()
            
            WaterUtilityCoordinator.ToolType.allCases.forEach { toolType in
                
                self.controller.paintToolTypePopUp.addItem(withTitle: toolType.title)
            }
            
            self.controller.paintTypePopUp.removeAllItems()
            
            WaterType.allCases.forEach { waterType in
                
                self.controller.paintTypePopUp.addItem(withTitle: waterType.description)
            }
            
            switch self.viewModel.state {
                
            case .paint(let inspector, let toolType, let waterType):
                
                self.controller.utilityTypePopUp.selectItem(at: WaterUtilityCoordinator.Utility.paint.rawValue)
                
                self.controller.paintToolTypePopUp.selectItem(at: toolType.rawValue)
                
                self.controller.paintTypePopUp.selectItem(at: waterType.rawValue)
                
                self.controller.chunkCountLabel.integerValue = inspector.inspectable.grid.childCount
                self.controller.gridRenderingButton.state = (inspector.inspectable.grid.isHidden ? .off : .on)
                
            default: break
            }
        }
    }
}

extension WaterPaintUtilityCoordinator {

    func stateDidChange(from previousState: SceneView.CursorState?, to currentState: SceneView.CursorState) {
        
        DispatchQueue.main.async {
            
            switch currentState {
                
            case .tracking(let position, _):
            
                guard let hit = self.sceneView?.hitTest(point: position.start, category: .terrain) else { return }
                    
                self.viewModel.paint(hit: hit)
                
            default: break
            }
        }
    }
}
