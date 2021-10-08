//
//  FocusedValues.swift
//
//  Created by Zack Brown on 02/10/2021.
//

import SwiftUI

struct DocumentFocusedValueKey: FocusedValueKey {
    
    typealias Value = Binding<Document>
}

extension FocusedValues {
    
    var document: DocumentFocusedValueKey.Value? {
        
        get { self[DocumentFocusedValueKey.self] }
        
        set { self[DocumentFocusedValueKey.self] = newValue }
    }
}
