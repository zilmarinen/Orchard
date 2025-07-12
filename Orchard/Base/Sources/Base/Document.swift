//
//  Document.swift
//  Base
//
//  Created by Zack Brown on 11/07/2025.
//

import Cocoa

public class Document: NSDocument {

    override init() {
        
        super.init()
        
        //
    }

    public override class var autosavesInPlace: Bool { true }

    public override func makeWindowControllers() {
        
        let storyboard = NSStoryboard(name: NSStoryboard.main,
                                      bundle: nil)
        
        let windowController = storyboard.instantiateController(withIdentifier: NSStoryboard.scene) as! NSWindowController
        
        addWindowController(windowController)
    }
    
    public override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        let wrappers: [String: FileWrapper] = [:]
        
        return FileWrapper(directoryWithFileWrappers: wrappers)
        
//        throw NSError(domain: NSOSStatusErrorDomain,
//                      code: unimpErr,
//                      userInfo: nil)
    }
    public override nonisolated func read(from fileWrapper: FileWrapper,
                                   ofType typeName: String) throws {
        
        //
        
        // Insert code here to read your document from the given data of the specified type, throwing an error in case of failure.
        // Alternatively, you could remove this method and override read(from:ofType:) instead.
        // If you do, you should also override isEntireFileLoaded to return false if the contents are lazily loaded.
        
        //throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
}
