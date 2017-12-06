//
//  RatingsDTO.swift
//  MovieTrack
//
//  Created by Carla de Oliveira Camargo on 03/12/17.
//  Copyright © 2017 Carla de Oliveira Camargo. All rights reserved.
//

import Foundation
import ObjectMapper

class RatingsDTO: Mappable {
   
    var source : String?
    var value : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        source <- map["Source"]
        value <- map["Value"]
    }
}
