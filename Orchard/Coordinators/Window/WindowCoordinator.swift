//
//  WindowCoordinator.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa
import Harvest
import Meadow

class WindowCoordinator: Coordinator<WindowController> {
    
    lazy var splitViewCoordinator: SplitViewCoordinator = {
        
        guard let viewController = controller.splitViewController else { fatalError("Invalid view controller hierarchy") }
        
        let coordinator = SplitViewCoordinator(controller: viewController)
        
        coordinator.parent = self
        
        return coordinator
    }()
    
    override init(controller: WindowController) {
        
        super.init(controller: controller)
        
        controller.coordinator = self
    }
    
    required public init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func start(with option: StartOption?) {
        
        super.start(with: option)
        
        start(child: splitViewCoordinator, with: option)
    }
}

extension WindowCoordinator {
    
    override func toggle(editor: SceneCoordinator.ViewState) {
        
        splitViewCoordinator.sceneCoordinator.toggle(editor: editor)
        splitViewCoordinator.inspectorCoordinator.tabViewCoordinator.toggle(inspector: .empty)
        splitViewCoordinator.toolbarCoordinator.controller.toggle(inspector: .empty)
        
        switch editor {
        
        case .editor:
            
            splitViewCoordinator.controller.show(panel: .toolbar)
            splitViewCoordinator.controller.show(panel: .inspector)
            
        case .meadow:
            
            splitViewCoordinator.controller.hide(panel: .toolbar)
            splitViewCoordinator.controller.hide(panel: .inspector)
        }
    }
    
    override func toggle(splitView panel: SplitViewController.Panel) {
     
        splitViewCoordinator.controller.toggle(splitView: panel)
    }
    
    override func export() throws {
        
        guard let scene = splitViewCoordinator.spriteView?.scene as? Scene2D else { return }
        
        let panel = NSSavePanel()

        panel.canCreateDirectories = true
        panel.prompt = "Export"
        panel.title = "Export"
        panel.nameFieldStringValue = "\(scene.map.identifier).\(Document.Constants.sceneGraphFileType)"
        
        panel.begin { (response) in
            
            guard response == .OK, let url = panel.url else { return }
            
            let encoder = JSONEncoder()
            
            let sceneGraph = try? encoder.encode(scene.map)
            
            try? sceneGraph?.write(to: url, options: .atomic)
        }
    }
}
