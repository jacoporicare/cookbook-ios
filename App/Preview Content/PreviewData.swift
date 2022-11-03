//
//  PreviewData.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

import API
import ApolloAPI
import Foundation

var recipePreviewData: [RecipeDetails] = load("recipeData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

extension RecipeDetails: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case gridImageUrl
        case listImageUrl
        case fullImageUrl
        case directions
        case sideDish
        case preparationTime
        case servingCount
        case ingredients
        case cookedHistory
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.init(data: DataDict([
            "id": try values.decode(String.self, forKey: .id),
            "title": try values.decode(String.self, forKey: .title),
            "gridImageUrl": try values.decode(String?.self, forKey: .gridImageUrl),
            "listImageUrl": try values.decode(String?.self, forKey: .listImageUrl),
            "fullImageUrl": try values.decode(String?.self, forKey: .fullImageUrl),
            "directions": try values.decode(String?.self, forKey: .directions),
            "sideDish": try values.decode(String?.self, forKey: .sideDish),
            "preparationTime": try values.decode(Int?.self, forKey: .preparationTime),
            "servingCount": try values.decode(Int?.self, forKey: .servingCount),
            "ingredients": try values.decode([Ingredient].self, forKey: .ingredients),
            "cookedHistory": try values.decode([CookedHistory].self, forKey: .cookedHistory)
        ], variables: nil))
    }
}

extension RecipeDetails.Ingredient: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case isGroup
        case amount
        case amountUnit
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.init(data: DataDict([
            "id": try values.decode(String.self, forKey: .id),
            "name": try values.decode(String.self, forKey: .name),
            "isGroup": try values.decode(Bool.self, forKey: .isGroup),
            "amount": try values.decode(Double?.self, forKey: .amount),
            "amountUnit": try values.decode(String?.self, forKey: .amountUnit)
        ], variables: nil))
    }
}

extension RecipeDetails.CookedHistory: Decodable {
    enum CodingKeys: String, CodingKey {
        case date
        case user
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(data: DataDict([
            "date": try values.decode(API.Date.self, forKey: .date),
            "user": try values.decode(User.self, forKey: .user),
        ], variables: nil))
    }
}

extension RecipeDetails.CookedHistory.User: Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case displayName
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.init(data: DataDict([
            "id": try values.decode(String.self, forKey: .id),
            "displayName": try values.decode(String.self, forKey: .displayName)
        ], variables: nil))
    }
}

