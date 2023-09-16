//
//  OrchardDocument.swift
//
//  Created by Zack Brown on 09/09/2023.
//

import SwiftUI
import UniformTypeIdentifiers

class Document: FileDocument, ObservableObject {
    
    internal enum DocumentError: Error {
        
        case invalidDocumentFormat
    }
    
    static var readableContentTypes: [UTType] { [.document] }
    
    internal var file: FileWrapper
    
    init() {
        
        self.file = FileWrapper(directoryWithFileWrappers: [:])
    }

    required init(configuration: ReadConfiguration) throws {
        
        guard configuration.contentType == .document else { throw CocoaError(.fileReadUnsupportedScheme) }
        
        self.file = configuration.file
        
        //read file contents
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        
        //write file contents
        
        return file
    }
}
