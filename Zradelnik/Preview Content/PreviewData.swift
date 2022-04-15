//
//  PreviewData.swift
//  Zradelnik
//
//  Created by Jakub Řičař on 29.03.2022.
//

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
        case imageUrl
        case directions
        case sideDish
        case preparationTime
        case servingCount
        case ingredients
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        self.init(
            id: try values.decode(String.self, forKey: .id),
            title: try values.decode(String.self, forKey: .title),
            imageUrl: try values.decode(Optional<String>.self, forKey: .imageUrl),
            directions: try values.decode(Optional<String>.self, forKey: .directions),
            sideDish: try values.decode(Optional<String>.self, forKey: .sideDish),
            preparationTime: try values.decode(Optional<Int>.self, forKey: .preparationTime),
            servingCount: try values.decode(Optional<Int>.self, forKey: .servingCount),
            ingredients: try values.decode(Optional<[RecipeDetails.Ingredient]>.self, forKey: .ingredients)
        )
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
        
        self.init(
            id: try values.decode(String.self, forKey: .id),
            name: try values.decode(String.self, forKey: .name),
            isGroup: try values.decode(Bool.self, forKey: .isGroup),
            amount: try values.decode(Optional<Double>.self, forKey: .amount),
            amountUnit: try values.decode(Optional<String>.self, forKey: .amountUnit)
        )
    }
}
