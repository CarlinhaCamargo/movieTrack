//
//  SearchItemDTO.swift
//  MovieTrack
//
//  Created by Carla de Oliveira Camargo on 04/12/17.
//  Copyright © 2017 Carla de Oliveira Camargo. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchItemDTO: Mappable {
 
    var title: String?
    var year: String?
    var imdbID: String?
    var type: String?
    var poster: String?
    
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["Title"]
        year <- map["Year"]
        imdbID <- map["imdbID"]
        type <- map["Type"]
        poster <- map["Poster"]
    }
    
}

class SearchDTO: Mappable {
    var searchResult: [SearchItemDTO]?
    
    required init?(map: Map) {
        
    }
    required init?() {
        
    }
    
    func mapping(map: Map) {
        searchResult <- map["Search"]
    
    }
    
}


