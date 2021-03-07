//
//  BuildingsUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 01/02/2021.
//

import Cocoa

class BuildingsUtilityViewController: NSViewController {
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var containerView: NSView!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var gridRenderingButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case gridRenderingButton:
            
            inspectable.buildings.isHidden = sender.state == .off
        
        case buildButton:
            
            coordinator?.toggle(buildings: .build)
            
        default: break
        }
    }
    
    weak var coordinator: BuildingsUtilityCoordinator?
    
    var tabViewController: BuildingsUtilityTabViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let viewController = coordinator?.tabViewCoordinator.controller, let container = containerView else { return }
        
        addChild(viewController)
        
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.frame = container.bounds
        
        container.addSubview(viewController.view)
        container.addConstraint(NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: viewController.view, attribute: .top, multiplier: 1.0, constant: 0.0))
        container.addConstraint(NSLayoutConstraint(item: container, attribute: .leading, relatedBy: .equal, toItem: viewController.view, attribute: .leading, multiplier: 1.0, constant: 0.0))
        container.addConstraint(NSLayoutConstraint(item: container, attribute: .bottom, relatedBy: .equal, toItem: viewController.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        container.addConstraint(NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: viewController.view, attribute: .trailing, multiplier: 1.0, constant: 0.0))
        
        coordinator?.toggle(buildings: .build)
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}
