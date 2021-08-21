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
    
    @IBOutlet weak var sceneIdentifierLabel: NSTextField! {
        
        didSet {
            
            sceneIdentifierLabel.delegate = self
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
    
    @IBAction func popUp(_ sender: NSPopUpButton) {}
    
    weak var coordinator: SceneInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

extension SceneInspectorViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        
        guard let sender = obj.object as? NSTextField,
              let spriteView = coordinator?.spriteView,
              let scene = spriteView.scene as? Scene2D else { return }
        
        switch sender {
        
        case sceneNameLabel:
            
            scene.map.name = sender.stringValue
            
        case sceneIdentifierLabel:
            
            scene.map.identifier = sender.stringValue
            
        default: break
        }
    }
}
