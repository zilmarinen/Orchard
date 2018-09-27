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
        
        if let screen = self.windowController.window?.screen {
        
            self.windowController.window?.setFrame(screen.visibleFrame, display: true, animate: true)
        }
        
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
        
        switch viewController.viewModel.state {
            
        case .editor(let meadow, _):
            
            do {
                
                let encoder = JSONEncoder()
                
                let data = try encoder.encode(meadow)
                
                return data
            }
            catch {
                
                throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": error])
            }
            
        default: throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": "Invalid view model state"])
        }
    }
    
    override func read(from data: Data, ofType typeName: String) throws {
        
        guard let viewController = windowController.contentViewController as? OrchardViewController else { fatalError("Invalid view controller hierarchy") }
        
        switch viewController.viewModel.state {
            
        case .editor(let meadow, let cursorModel):
            
            do {
                
                let decoder = JSONDecoder()
                
                let intermediate = try decoder.decode(MeadowIntermediate.self, from: data)
                
                viewController.viewModel.state = .loading(meadow, cursorModel, intermediate)
            }
            catch {
                
                throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: ["Error": error])
            }
            
        default: break
        }
    }
}
