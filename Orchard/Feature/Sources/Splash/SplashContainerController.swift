//
//  SplashContainerController.swift
//  Feature
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base
import Container

public protocol SplashContainerDelegate: AnyObject {
    
    func splashContainerDidFinish(_ container: SplashContainerController)
}

public class SplashContainerController: ContainerViewController {
    
    private lazy var loadButton = with(NSButton(title: "Splash",
                                                target: self,
                                                action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let gradient = GradientView(primaryColor: .systemBlue,
                                        secondaryColor: .systemPurple)
    
    private weak var delegate: SplashContainerDelegate?
    
    public init(delegate: SplashContainerDelegate) {
        
        self.delegate = delegate
        
        super.init()
        
        title = "Orchard"
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.addSubview(gradient)
        view.addSubview(loadButton)
        
        loadButton.center(in: view)
    }
}

extension SplashContainerController {
    
    @objc
    private func button(_ sender: NSButton) {
        
        delegate?.splashContainerDidFinish(self)
    }
}
