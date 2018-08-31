//
//  Document.swift
//  Orchard
//
//  Created by Zack Brown on 23/05/2018.
//  Copyright © 2018 Script Orchard. All rights reserved.
//

import Meadow

class Document: NSDocument {
    
    let windowController: OrchardWindowController

    override init() {
        
        self.windowController = NSStoryboard.main!.instantiateController(withIdentifier: OrchardWindowController.sceneIdentifier) as! OrchardWindowController
        
        guard let viewController = windowController.contentViewController as? OrchardViewController else { fatalError("Invalid view controller hierarchy") }
        
        viewController.viewModel.state = .editor(viewController.meadow)
        
        super.init()
    }
    
    override class var autosavesInPlace: Bool {
        
        return true
    }
    
    override func makeWindowControllers() {
        
        self.addWindowController(windowController)
    }
    
    override func data(ofType typeName: String) throws -> Data {
        
        guard let viewController = windowController.contentViewController as? OrchardViewController else { fatalError("Invalid view controller hierarchy") }
        
        do {
            
            switch viewController.viewModel.state {
                
            case .editor(let meadow):
            
                let encoder = JSONEncoder()
        
                let data = try encoder.encode(meadow)
            
                return data
            
            default: throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": "Invalid state"])
            }
        }
        catch {
            
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": error])
        }
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        
        guard let viewController = windowController.contentViewController as? OrchardViewController else { fatalError("Invalid view controller hierarchy") }
        
        do {
            
            switch viewController.viewModel.state {
                
            case .editor(let meadow):
                
                let decoder = JSONDecoder()
                
                let intermediate = try decoder.decode(MeadowIntermediate.self, from: data)
                
                meadow.load(intermediate: intermediate)
                
            default: break
            }
        }
        catch {
        
            throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": error])
        }
    }
}
