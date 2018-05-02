//
//  Persistence.swift
//  SingleResponsibility
//
//  Created by Tim Beals on 2018-02-05.
//  Copyright © 2018 Tim Beals. All rights reserved.
//

import Foundation

class Persistence {
    
    func save(journal: Journal, to file: String, override: Bool = false ) {
        //functionality for save
    }
    
    func load(journal: Journal, from file: String) -> Journal{
        //functionality for load
        return Journal()
    }
    
}
