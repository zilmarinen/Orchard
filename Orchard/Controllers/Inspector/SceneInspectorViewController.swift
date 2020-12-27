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
    @IBOutlet weak var gridColorWell: NSColorWell!
    
    @IBOutlet weak var gridRenderingButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        inspectable.camera.floor.drawGrid = sender.state == .on
    }
    
    @IBAction func colorWell(_ sender: NSColorWell) {
     
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case backgroundColorWell:
            
            inspectable.camera.floor.backgroundColor = Color(red: Double(sender.color.redComponent), green: Double(sender.color.greenComponent), blue: Double(sender.color.blueComponent), alpha: Double(sender.color.alphaComponent))
            
        case gridColorWell:
            
            inspectable.camera.floor.gridColor = Color(red: Double(sender.color.redComponent), green: Double(sender.color.greenComponent), blue: Double(sender.color.blueComponent), alpha: Double(sender.color.alphaComponent))
            
        default: break
        }
        
        coordinator?.refresh()
    }
    
    @IBAction func popUp(_ sender: NSPopUpButton) {
        
        guard let inspectable = coordinator?.inspectable,
              let season = Season(rawValue: sender.indexOfSelectedItem) else { return }
        
        inspectable.world = World(season: season)
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
