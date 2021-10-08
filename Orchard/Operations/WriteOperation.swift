//
//  WriteOperation.swift
//
//  Created by Zack Brown on 26/09/2021.
//

import Foundation
import PeakOperation

class WriteOperation: ConcurrentOperation, ConsumesResult, ProducesResult {
    
    public var input: Result<Data, Error> = Result { throw ResultError.noResult }
    public var output: Result<Void, Error> = Result { throw ResultError.noResult }
    
    let url: URL
    let filename: String
    
    init(url: URL, filename: String) {
        
        self.url = url
        self.filename = filename
        
        super.init()
    }
    
    override func execute() {
        
        do {
            
            let data = try input.get()
            
            let file = FileWrapper(regularFileWithContents: data)
            
            let folder = FileWrapper(directoryWithFileWrappers: ["\(filename).graph" : file])
            
            try folder.write(to: url, options: .atomic, originalContentsURL: url)
            
            output = .success(())
        }
        catch {
            
            output = .failure(error)
        }
        
        finish()
    }
}
