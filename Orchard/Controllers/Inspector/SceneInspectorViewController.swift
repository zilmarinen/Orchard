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
    @IBOutlet weak var gridColorWell: NSColorWell!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        inspectable.meadow.floor.drawGrid = sender.state == .on
    }
    
    @IBAction func colorWell(_ sender: NSColorWell) {
     
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case backgroundColorWell:
            
            inspectable.meadow.floor.backgroundColor = Color(red: Double(sender.color.redComponent), green: Double(sender.color.greenComponent), blue: Double(sender.color.blueComponent), alpha: Double(sender.color.alphaComponent))
            
        case gridColorWell:
            
            inspectable.meadow.floor.gridColor = Color(red: Double(sender.color.redComponent), green: Double(sender.color.greenComponent), blue: Double(sender.color.blueComponent), alpha: Double(sender.color.alphaComponent))
            
        default: break
        }
        
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
