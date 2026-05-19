//
//  SplashContainer.swift
//
//  Created by Zack Brown on 09/07/2025.
//

import AppKit
import Base
import Container

public protocol SplashContainerDelegate: AnyObject {
    
    func splashContainerDidFinish(_ container: SplashContainer)
}

public class SplashContainer: ContainerViewController {
    
    private lazy var imageView = with(NSImageView()) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = .splashIcon
    }
    
    private weak var delegate: SplashContainerDelegate?
    
    public init(delegate: SplashContainerDelegate) {
        
        self.delegate = delegate
        
        super.init()
        
        title = "Orchard"
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.splashBackground.cgColor
        
        view.addSubview(imageView)
        
        imageView.center(in: view)
    }
    
    public override func viewDidAppear() {
        
        super.viewDidAppear()
        
        Debouncer.perform(context: "Splash",
                          after: .debounceInterval) { [weak self] in
            
            guard let self else { return}
            
            self.delegate?.splashContainerDidFinish(self)
        }
    }
}
