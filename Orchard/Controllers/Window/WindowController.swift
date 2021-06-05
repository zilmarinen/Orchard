//
//  WindowController.swift
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class WindowController: NSWindowController {
    
    var splitViewController: SplitViewController? { contentViewController as? SplitViewController }
    
    @IBOutlet weak var sidebarToggle: NSSegmentedControl!
    @IBOutlet weak var editorToggle: NSSegmentedControl!
    
    weak var coordinator: WindowCoordinator?
    
    @IBAction func menuItem(_ sender: NSMenuItem) {
            
        try? coordinator?.export()
    }
    
    @IBAction func segmentedControl(_ sender: NSSegmentedControl) {
        
        guard let state = coordinator?.splitViewCoordinator.sceneCoordinator.viewModel.state else { return }
        
        switch sender {
        
        case editorToggle:
            
            switch state {
            
            case .editor:
                
                coordinator?.toggle(editor: .meadow)
                
            case .meadow:
                
                coordinator?.toggle(editor: .editor)
            }
            
        case sidebarToggle:
            
            switch state {
            
            case .editor:
                
                coordinator?.toggle(splitView: (sender.selectedSegment == 0 ? .toolbar : .inspector))
                
            default: break
            }
            
        default: break
        }
    }
}
