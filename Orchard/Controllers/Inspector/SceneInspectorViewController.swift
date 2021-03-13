//
//  SceneInspectorViewController.swift
//  Orchard
//
//  Created by Zack Brown on 06/11/2020.
//

import Cocoa
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
            
            for season in Season.allCases {
                
                seasonPopUp.addItem(withTitle: season.description)
            }
        }
    }
    
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    
    @IBAction func colorWell(_ sender: NSColorWell) {
     
        guard let spriteView = coordinator?.spriteView else { return }
        
        spriteView.scene?.backgroundColor = backgroundColorWell.color
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
