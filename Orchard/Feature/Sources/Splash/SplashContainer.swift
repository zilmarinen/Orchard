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
    
    private lazy var loadButton = with(NSButton(title: "Splash",
                                                target: self,
                                                action: #selector(button(_:)))) {
        
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //TODO: Remove Timer
    private var timer: Timer?
    
    private weak var delegate: SplashContainerDelegate?
    
    public init(delegate: SplashContainerDelegate) {
        
        self.delegate = delegate
        
        super.init()
        
        title = "Orchard"
        
        self.timer = Timer.scheduledTimer(timeInterval: 2.0,
                                          target: self,
                                          selector: #selector(timer(_:)),
                                          userInfo: nil,
                                          repeats: false)
    }
    
    public override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.splashBackground.cgColor
        
        view.addSubview(loadButton)
        view.addSubview(imageView)
        
        imageView.center(in: view)
        
        //TODO: remove splash button
        NSLayoutConstraint.activate([
            
            loadButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                               constant: -16.0),
            loadButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

extension SplashContainer {
    
    @objc
    private func button(_ sender: NSButton) {
        
        delegate?.splashContainerDidFinish(self)
    }
    
    @objc
    private func timer(_ sender: Timer) {
     
        delegate?.splashContainerDidFinish(self)
    }
}
