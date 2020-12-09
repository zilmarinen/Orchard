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
    
    @IBOutlet weak var backgroundColorWell: NSColorWell!
    
    @IBAction func colorWell(_ sender: NSColorWell) {
     
        guard let inspectable = coordinator?.inspectable else { return }
        
        inspectable.backgroundColor = Color(red: Double(sender.color.redComponent), green: Double(sender.color.greenComponent), blue: Double(sender.color.blueComponent), alpha: Double(sender.color.alphaComponent))
        
        coordinator?.didSetScene(backgroundColor: sender.color)
        
        coordinator?.refresh()
    }
    
    weak var coordinator: SceneInspectorCoordinator?
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

extension SceneInspectorViewController: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        
        guard let obj = obj.object as? NSTextField, let inspectable = coordinator?.inspectable, obj == sceneNameLabel else { return }
        
        inspectable.name = sceneNameLabel.stringValue
    }
}
