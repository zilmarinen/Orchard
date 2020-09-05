//
//  Inspector.swift
//  Orchard
//
//  Created by Zack Brown on 28/04/2020.
//  Copyright © 2020 Script Orchard. All rights reserved.
//

protocol Inspector {
    
    associatedtype Inspectable
    
    var inspector: Inspectable? { get set }
}
