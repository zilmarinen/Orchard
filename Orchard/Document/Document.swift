//
//  Document.swift
//  Orchard
//
//  Created by Zack Brown on 23/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class Document: NSDocument {
    
    let coordinator: WindowCoordinator

    override init() {
        
        let controller = NSStoryboard.main!.instantiateController(withIdentifier: OrchardWindowController.sceneIdentifier) as! OrchardWindowController
        
        self.coordinator = WindowCoordinator(controller: controller)
        
        super.init()
    }
    
    override class var autosavesInPlace: Bool {
        
        return true
    }
    
    override func makeWindowControllers() {
        
        self.addWindowController(coordinator.controller)
        
        coordinator.start(with: Meadow())
    }
    
    override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
        
        guard let meadow = coordinator.meadow else { throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": "Unable to find valid instance of meadow."]) }
     
        let encoder = JSONEncoder()
        
        var wrappers: [String : FileWrapper] = [:]
        
        let data = try encoder.encode(meadow)
        
        wrappers["world.meadow"] = FileWrapper(regularFileWithContents: data)
        
        return FileWrapper(directoryWithFileWrappers: wrappers)
    }
    
    override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
        
        do {
            
            let meadowWrapper = fileWrapper.fileWrappers?.first { return !$0.value.isDirectory }?.value
            
            let data = meadowWrapper?.regularFileContents
            
            if meadowWrapper == nil || data == nil {
                
                throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": "Unable to find .meadow in file wrapper."])
            }
            
            let decoder = JSONDecoder()
            
            let json = try decoder.decode(MeadowJSON.self, from: data!)
            
            coordinator.start(with: Meadow(json: json))
        }
        catch {
            
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": error])
        }
    }
}
