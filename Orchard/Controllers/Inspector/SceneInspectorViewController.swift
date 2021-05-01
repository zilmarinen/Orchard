//
//  SceneInspectorViewController.swift
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa
import Harvest
import Meadow

class SceneInspectorViewController: NSViewController {
    
    @IBOutlet weak var sceneNameLabel: NSTextField! {
        
        didSet {
            
            sceneNameLabel.delegate = self
        }
    }
    
    @IBOutlet weak var seasonPopUp: NSPopUpButton! {
        
        didSet {
            
            seasonPopUp.removeAllItems()
            
            for option in Season.allCases {
                
                seasonPopUp.addItem(withTitle: option.description)
            }
        }
    }
    
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    
    @IBAction func colorWell(_ sender: NSColorWell) {
     
        guard let spriteView = coordinator?.spriteView,
              let map = spriteView.scene as? Scene2D else { return }
        
        map.backgroundColor = backgroundColorWell.color
        map.graph.color = backgroundColorWell.color
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        //
    }
    
    weak var coordinator: SceneInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

extension SceneInspectorViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        
        guard let spriteView = coordinator?.spriteView else { return }
        
        spriteView.scene?.name = sceneNameLabel.stringValue
    }
}
