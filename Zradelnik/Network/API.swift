// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class LoginMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation Login($username: String!, $password: String!) {
      login(username: $username, password: $password) {
        __typename
        token
      }
    }
    """

  public let operationName: String = "Login"

  public var username: String
  public var password: String

  public init(username: String, password: String) {
    self.username = username
    self.password = password
  }

  public var variables: GraphQLMap? {
    return ["username": username, "password": password]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("login", arguments: ["username": GraphQLVariable("username"), "password": GraphQLVariable("password")], type: .nonNull(.object(Login.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: Login) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "login": login.resultMap])
    }

    public var login: Login {
      get {
        return Login(unsafeResultMap: resultMap["login"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "login")
      }
    }

    public struct Login: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["AuthPayload"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("token", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String) {
        self.init(unsafeResultMap: ["__typename": "AuthPayload", "token": token])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }
    }
  }
}

public final class RecipeDetailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query RecipeDetail($id: ID!) {
      recipe(id: $id) {
        __typename
        id
        title
        fullImageUrl: imageUrl(size: {width: 1080, height: 1080}, format: WEBP)
        directions
        sideDish
        preparationTime
        servingCount
        ingredients {
          __typename
          id
          name
          isGroup
          amount
          amountUnit
        }
      }
    }
    """

  public let operationName: String = "RecipeDetail"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("recipe", arguments: ["id": GraphQLVariable("id")], type: .object(Recipe.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(recipe: Recipe? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "recipe": recipe.flatMap { (value: Recipe) -> ResultMap in value.resultMap }])
    }

    public var recipe: Recipe? {
      get {
        return (resultMap["recipe"] as? ResultMap).flatMap { Recipe(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "recipe")
      }
    }

    public struct Recipe: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Recipe"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageUrl", alias: "fullImageUrl", arguments: ["size": ["width": 1080, "height": 1080], "format": "WEBP"], type: .scalar(String.self)),
          GraphQLField("directions", type: .scalar(String.self)),
          GraphQLField("sideDish", type: .scalar(String.self)),
          GraphQLField("preparationTime", type: .scalar(Int.self)),
          GraphQLField("servingCount", type: .scalar(Int.self)),
          GraphQLField("ingredients", type: .list(.nonNull(.object(Ingredient.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, fullImageUrl: String? = nil, directions: String? = nil, sideDish: String? = nil, preparationTime: Int? = nil, servingCount: Int? = nil, ingredients: [Ingredient]? = nil) {
        self.init(unsafeResultMap: ["__typename": "Recipe", "id": id, "title": title, "fullImageUrl": fullImageUrl, "directions": directions, "sideDish": sideDish, "preparationTime": preparationTime, "servingCount": servingCount, "ingredients": ingredients.flatMap { (value: [Ingredient]) -> [ResultMap] in value.map { (value: Ingredient) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var fullImageUrl: String? {
        get {
          return resultMap["fullImageUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "fullImageUrl")
        }
      }

      public var directions: String? {
        get {
          return resultMap["directions"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "directions")
        }
      }

      public var sideDish: String? {
        get {
          return resultMap["sideDish"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "sideDish")
        }
      }

      public var preparationTime: Int? {
        get {
          return resultMap["preparationTime"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "preparationTime")
        }
      }

      public var servingCount: Int? {
        get {
          return resultMap["servingCount"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "servingCount")
        }
      }

      public var ingredients: [Ingredient]? {
        get {
          return (resultMap["ingredients"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Ingredient] in value.map { (value: ResultMap) -> Ingredient in Ingredient(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Ingredient]) -> [ResultMap] in value.map { (value: Ingredient) -> ResultMap in value.resultMap } }, forKey: "ingredients")
        }
      }

      public struct Ingredient: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Ingredient"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("isGroup", type: .nonNull(.scalar(Bool.self))),
            GraphQLField("amount", type: .scalar(Double.self)),
            GraphQLField("amountUnit", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(id: GraphQLID, name: String, isGroup: Bool, amount: Double? = nil, amountUnit: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Ingredient", "id": id, "name": name, "isGroup": isGroup, "amount": amount, "amountUnit": amountUnit])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var id: GraphQLID {
          get {
            return resultMap["id"]! as! GraphQLID
          }
          set {
            resultMap.updateValue(newValue, forKey: "id")
          }
        }

        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        public var isGroup: Bool {
          get {
            return resultMap["isGroup"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "isGroup")
          }
        }

        public var amount: Double? {
          get {
            return resultMap["amount"] as? Double
          }
          set {
            resultMap.updateValue(newValue, forKey: "amount")
          }
        }

        public var amountUnit: String? {
          get {
            return resultMap["amountUnit"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "amountUnit")
          }
        }
      }
    }
  }
}

public final class RecipeListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query RecipeList {
      recipes {
        __typename
        id
        title
        thumbImageUrl: imageUrl(size: {width: 640, height: 640}, format: WEBP)
      }
    }
    """

  public let operationName: String = "RecipeList"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("recipes", type: .nonNull(.list(.nonNull(.object(Recipe.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(recipes: [Recipe]) {
      self.init(unsafeResultMap: ["__typename": "Query", "recipes": recipes.map { (value: Recipe) -> ResultMap in value.resultMap }])
    }

    public var recipes: [Recipe] {
      get {
        return (resultMap["recipes"] as! [ResultMap]).map { (value: ResultMap) -> Recipe in Recipe(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: Recipe) -> ResultMap in value.resultMap }, forKey: "recipes")
      }
    }

    public struct Recipe: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Recipe"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("title", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageUrl", alias: "thumbImageUrl", arguments: ["size": ["width": 640, "height": 640], "format": "WEBP"], type: .scalar(String.self)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, title: String, thumbImageUrl: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Recipe", "id": id, "title": title, "thumbImageUrl": thumbImageUrl])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      public var title: String {
        get {
          return resultMap["title"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "title")
        }
      }

      public var thumbImageUrl: String? {
        get {
          return resultMap["thumbImageUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "thumbImageUrl")
        }
      }
    }
  }
}
