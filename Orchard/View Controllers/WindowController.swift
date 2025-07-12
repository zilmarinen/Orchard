//
//  WindowController.swift
//  Orchard
//
//  Created by Zack Brown on 10/07/2025.
//

import AppKit
import Base
import Region
import Splash
import World

public class WindowController: NSWindowController {
    
    private lazy var toolbar = Toolbar(eventHandler: self)
    
    private var regionContainerController: RegionContainerController? { contentViewController as? RegionContainerController }
    private var splashContainerController: SplashContainerController? { contentViewController as? SplashContainerController }
    private var worldContainerController: WorldContainerController? { contentViewController as? WorldContainerController }
    
    private var presentingRegion: Bool { regionContainerController != nil }
    private var presentingSplash: Bool { splashContainerController != nil }
    private var presentingWorld: Bool { worldContainerController != nil }
    
    required public init?(coder: NSCoder) {
        
        super.init(coder: coder)
    }
    
    public override func windowDidLoad() {
        
        super.windowDidLoad()
        
        window?.toolbar = toolbar
        window?.toolbarStyle = .unifiedCompact
        window?.subtitle = "Orchard"
        
        showSplash()
    }
    
    private func set(content: NSViewController) {
        
        contentViewController = content
        
        toolbar.validateVisibleItems()
    }
}

extension WindowController: ToolbarDelegate {
    
    func toolbar(_ toolbar: Toolbar,
                 didTap toolbarItem: NSToolbarItem.ItemIdentifier) {
        
        switch toolbarItem {
            
        case .debug: print("Debug")
        }
    }
}

extension WindowController {
    
    private func showRegion() {
        
        guard !presentingRegion else { return }
        
        toolbar.isVisible = true
        
        set(content: RegionContainerController(delegate: self))
    }
    
    private func showSplash() {
        
        guard !presentingSplash else { return }
        
        toolbar.isVisible = false
        
        set(content: SplashContainerController(delegate: self))
    }
    
    private func showWorld() {
        
        guard !presentingWorld,
              let document = self.document as? Document else { return }
        
        toolbar.isVisible = true
        
        set(content: WorldContainerController(document: document,
                                              delegate: self))
    }
}

extension WindowController: RegionContainerDelegate {}

extension WindowController: SplashContainerDelegate {
    
    public func splashContainerDidFinish(_ container: SplashContainerController) { showWorld() }
}

extension WindowController: WorldContainerDelegate {
    
    public func worldContainer(_ container: WorldContainerController,
                               didSelect region: Bool) {
        
        showRegion()
    }
}
