//
//  Document.swift
//
//  Created by Zack Brown on 29/09/2021.
//

import SwiftUI
import UniformTypeIdentifiers

class Document: FileDocument, ObservableObject {
    
    enum Constants {
        
        enum FileFormat {
            
            static let graph = "graph"
        }
        
        enum Filename {
            
            static let map = "map"
        }
        
        static let mapFilename = Filename.map + "." + FileFormat.graph
    }
    
    static var readableContentTypes: [UTType] { [.model] }
    
    @Published var model: AppViewModel

    init(model: AppViewModel) {
        
        self.model = model
    }

    required init(configuration: ReadConfiguration) throws {
        
        model = try AppViewModel(fileWrapper: configuration.file)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        
        return try model.fileWrapper()
    }
}
