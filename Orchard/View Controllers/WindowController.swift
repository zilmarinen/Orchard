//
//  WindowController.swift
//  Orchard
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Deltille
import Splash
import World

public class WindowController: NSWindowController {
    
    private var splashContainer: SplashContainer? { contentViewController as? SplashContainer }
    private var worldContainer: WorldContainer? { contentViewController as? WorldContainer }
    
    private var presentingSplash: Bool { splashContainer != nil }
    private var presentingWorld: Bool { worldContainer != nil }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    public override func windowDidLoad() {
        
        super.windowDidLoad()
        
        showSplash()
    }
    
    private func set(content: NSViewController) {
        
        guard let window else { return }
        
        window.subtitle = content.title ?? ""
        window.titlebarAppearsTransparent = true
        
        contentViewController = content
        
        guard let content = content as? HasToolbar else {
            
            window.toolbar = nil
            window.titleVisibility = .hidden
            
            return
        }
        
        window.toolbar = content.toolbar
        window.titleVisibility = .visible
    }
}

extension WindowController {
    
    private func showSplash() {
        
        guard !presentingSplash else { return }
        
        set(content: SplashContainer(delegate: self))
    }
    
    private func showWorld(focus: Triangle? = nil) {
        
        guard !presentingWorld,
              let document = self.document as? Document else { return }
        
        set(content: WorldContainer(triangle: focus ?? .zero,
                                    document: document,
                                    delegate: self))
    }
    
    private func showZone(triangle: Triangle) {
        
        //
    }
}

extension WindowController: SplashContainerDelegate {
    
    public func splashContainerDidFinish(_ container: SplashContainer) {
        
        guard document != nil else { fatalError("Invalid document") }
        
        showWorld()
    }
}

extension WindowController: WorldContainerDelegate {
    
    public func worldContainer(_ container: WorldContainer,
                               didRequestEditingFor selection: Document.Selection) {
        
        switch selection {
            
        case .zone(let triangle): showZone(triangle: triangle)
        default: break
        }
    }
}
