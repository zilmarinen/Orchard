//
//  AppFlowContainer.swift
//  Orchard
//
//  Created by Zack Brown on 09/07/2025.
//

import Container
import Region
import Splash
import World

class AppFlowContainer: ContainerViewController {
    
    private var regionContainerController: RegionContainerController? { content as? RegionContainerController }
    private var splashContainerController: SplashContainerController? { content as? SplashContainerController }
    private var worldContainerController: WorldContainerController? { content as? WorldContainerController }
    
    private var presentingRegion: Bool { regionContainerController != nil }
    private var presentingSplash: Bool { splashContainerController != nil }
    private var presentingWorld: Bool { worldContainerController != nil }
    
    private let document: Document
    
    init(document: Document) {
        
        self.document = document
        
        super.init()
        
        showSplash()
    }
}

extension AppFlowContainer {
    
    private func showRegion() {
        
        guard !presentingRegion else { return }
        
        content = RegionContainerController(delegate: self)
    }
    
    private func showSplash() {
        
        guard !presentingSplash else { return }
        
        content = SplashContainerController(delegate: self)
    }
    
    private func showWorld() {
        
        guard !presentingWorld else { return }
        
        content = WorldContainerController(delegate: self)
    }
}

extension AppFlowContainer: RegionContainerDelegate {}

extension AppFlowContainer: SplashContainerDelegate {
    
    func splashContainerDidFinish(_ container: SplashContainerController) { showWorld() }
}

extension AppFlowContainer: WorldContainerDelegate {}
