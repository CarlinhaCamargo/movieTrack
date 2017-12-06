//
//  MovieDTO.swift
//  MovieTrack
//
//  Created by Carla de Oliveira Camargo on 03/12/17.
//  Copyright © 2017 Carla de Oliveira Camargo. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieDTO: Mappable {
    var title : String?
    var year : String?
    var rated : String?
    var released : String?
    var runtime : String?
    var genre : String?
    var director : String?
    var writer : String?
    var actors : String?
    var plot : String?
    var language : String?
    var country : String?
    var awards : String?
    var poster : String?
    var ratings : [RatingsDTO]?
    var metascore : String?
    var imdbRating : String?
    var imdbVotes : String?
    var imdbID : String?
    var type : String?
    var dVD : String?
    var boxOffice : String?
    var production : String?
    var website : String?
    var response : Bool?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        title <- map["Title"]
        year <- map["Year"]
        rated <- map["Rated"]
        released <- map["Released"]
        runtime <- map["Runtime"]
        genre <- map["Genre"]
        director <- map["Director"]
        writer <- map["Writer"]
        actors <- map["Actors"]
        plot <- map["Plot"]
        language <- map["Language"]
        country <- map["Country"]
        awards <- map["Awards"]
        poster <- map["Poster"]
        ratings <- map["Ratings"]
        metascore <- map["Metascore"]
        imdbRating <- map["imdbRating"]
        imdbVotes <- map["imdbVotes"]
        imdbID <- map["imdbID"]
        type <- map["Type"]
        dVD <- map["DVD"]
        boxOffice <- map["BoxOffice"]
        production <- map["Production"]
        website <- map["Website"]
        response <- map["Response"]
        
    }
    
    

}
