//
//  Document.swift
//  Orchard
//
//  Created by Zack Brown on 09/07/2025.
//

import Cocoa
import UniformTypeIdentifiers

class Document: NSDocument {

    override init() {
        
        super.init()
        
        //
    }

    override class var autosavesInPlace: Bool { true }

    override func makeWindowControllers() {
        
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Document Window Controller")) as! NSWindowController
        
        windowController.contentViewController = AppFlowContainer(document: self)
        
        self.addWindowController(windowController)
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        throw NSError(domain: NSOSStatusErrorDomain,
                      code: unimpErr,
                      userInfo: nil)
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        
        // Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override read(from:ofType:) instead.
        // If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
        
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
}
