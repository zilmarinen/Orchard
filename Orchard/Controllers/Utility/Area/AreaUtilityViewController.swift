//
//  AreaUtilityViewController.swift
//  Orchard
//
//  Created by Zack Brown on 08/12/2020.
//

import Cocoa

class AreaUtilityViewController: NSViewController {
    
    @IBOutlet weak var buildButton: NSButton!
    @IBOutlet weak var paintButton: NSButton!
    @IBOutlet weak var containerView: NSView!
    
    @IBOutlet weak var chunkCountLabel: NSTextField!
    @IBOutlet weak var gridRenderingButton: NSButton!
    
    @IBAction func button(_ sender: NSButton) {
        
        guard let inspectable = coordinator?.inspectable else { return }
        
        switch sender {
        
        case gridRenderingButton:
            
            inspectable.area.isHidden = sender.state == .off
        
        case buildButton:
            
            coordinator?.toggle(area: .build)
            
        case paintButton:
            
            coordinator?.toggle(area: .paint)
            
        default: break
        }
    }
    
    weak var coordinator: AreaUtilityCoordinator?
    
    var tabViewController: AreaUtilityTabViewController?
    
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
        
        coordinator?.toggle(area: .build)
    }
    
    override func viewWillAppear() {
        
        super.viewWillAppear()
        
        coordinator?.refresh()
    }
}

