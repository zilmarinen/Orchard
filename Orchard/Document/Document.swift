//
//  Document.swift
//  Orchard
//
//  Created by Zack Brown on 03/11/2020.
//

import Cocoa

class Document: NSDocument {
    
    enum Constants {
        
        static let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        static let windowIndentifier = NSStoryboard.SceneIdentifier("WindowController")
    }
    
    let coordinator: WindowCoordinator

    override init() {
        
        guard let windowController = Constants.storyboard.instantiateController(withIdentifier: Constants.windowIndentifier) as? WindowController else { fatalError("Invalid view controller hierarchy") }
        
        coordinator = WindowCoordinator(controller: windowController)
        
        super.init()
    }

    override class var autosavesInPlace: Bool {
        
        return true
    }

    override func makeWindowControllers() {
        
        self.addWindowController(coordinator.controller)
        
        coordinator.start(with: nil)
    }

    override func data(ofType typeName: String) throws -> Data {

        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }

    override func read(from data: Data, ofType typeName: String) throws {

        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
}
