// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct RecipeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - title
  ///   - directions
  ///   - sideDish
  ///   - preparationTime
  ///   - servingCount
  ///   - ingredients
  ///   - tags
  public init(title: String, directions: Swift.Optional<String?> = nil, sideDish: Swift.Optional<String?> = nil, preparationTime: Swift.Optional<Int?> = nil, servingCount: Swift.Optional<Int?> = nil, ingredients: Swift.Optional<[IngredientInput]?> = nil, tags: Swift.Optional<[String]?> = nil) {
    graphQLMap = ["title": title, "directions": directions, "sideDish": sideDish, "preparationTime": preparationTime, "servingCount": servingCount, "ingredients": ingredients, "tags": tags]
  }

  public var title: String {
    get {
      return graphQLMap["title"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "title")
    }
  }

  public var directions: Swift.Optional<String?> {
    get {
      return graphQLMap["directions"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "directions")
    }
  }

  public var sideDish: Swift.Optional<String?> {
    get {
      return graphQLMap["sideDish"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "sideDish")
    }
  }

  public var preparationTime: Swift.Optional<Int?> {
    get {
      return graphQLMap["preparationTime"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "preparationTime")
    }
  }

  public var servingCount: Swift.Optional<Int?> {
    get {
      return graphQLMap["servingCount"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "servingCount")
    }
  }

  public var ingredients: Swift.Optional<[IngredientInput]?> {
    get {
      return graphQLMap["ingredients"] as? Swift.Optional<[IngredientInput]?> ?? Swift.Optional<[IngredientInput]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "ingredients")
    }
  }

  public var tags: Swift.Optional<[String]?> {
    get {
      return graphQLMap["tags"] as? Swift.Optional<[String]?> ?? Swift.Optional<[String]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "tags")
    }
  }
}

public struct IngredientInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - amount
  ///   - amountUnit
  ///   - name
  ///   - isGroup
  public init(amount: Swift.Optional<Double?> = nil, amountUnit: Swift.Optional<String?> = nil, name: String, isGroup: Swift.Optional<Bool?> = nil) {
    graphQLMap = ["amount": amount, "amountUnit": amountUnit, "name": name, "isGroup": isGroup]
  }

  public var amount: Swift.Optional<Double?> {
    get {
      return graphQLMap["amount"] as? Swift.Optional<Double?> ?? Swift.Optional<Double?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var amountUnit: Swift.Optional<String?> {
    get {
      return graphQLMap["amountUnit"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amountUnit")
    }
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var isGroup: Swift.Optional<Bool?> {
    get {
      return graphQLMap["isGroup"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isGroup")
    }
  }
}

public final class MeQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Me {
      me {
        __typename
        displayName
      }
    }
    """

  public let operationName: String = "Me"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("me", type: .nonNull(.object(Me.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(me: Me) {
      self.init(unsafeResultMap: ["__typename": "Query", "me": me.resultMap])
    }

    public var me: Me {
      get {
        return Me(unsafeResultMap: resultMap["me"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "me")
      }
    }

    public struct Me: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("displayName", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(displayName: String) {
        self.init(unsafeResultMap: ["__typename": "User", "displayName": displayName])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var displayName: String {
        get {
          return resultMap["displayName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "displayName")
        }
      }
    }
  }
}

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

public final class RecipesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Recipes {
      recipes {
        __typename
        ...RecipeDetails
      }
    }
    """

  public let operationName: String = "Recipes"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + RecipeDetails.fragmentDefinition)
    return document
  }

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
          GraphQLFragmentSpread(RecipeDetails.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var recipeDetails: RecipeDetails {
          get {
            return RecipeDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateRecipeMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation CreateRecipe($recipe: RecipeInput!, $image: Upload) {
      createRecipe(recipe: $recipe, image: $image) {
        __typename
        ...RecipeDetails
      }
    }
    """

  public let operationName: String = "CreateRecipe"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + RecipeDetails.fragmentDefinition)
    return document
  }

  public var recipe: RecipeInput
  public var image: String?

  public init(recipe: RecipeInput, image: String? = nil) {
    self.recipe = recipe
    self.image = image
  }

  public var variables: GraphQLMap? {
    return ["recipe": recipe, "image": image]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createRecipe", arguments: ["recipe": GraphQLVariable("recipe"), "image": GraphQLVariable("image")], type: .nonNull(.object(CreateRecipe.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createRecipe: CreateRecipe) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createRecipe": createRecipe.resultMap])
    }

    public var createRecipe: CreateRecipe {
      get {
        return CreateRecipe(unsafeResultMap: resultMap["createRecipe"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createRecipe")
      }
    }

    public struct CreateRecipe: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Recipe"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(RecipeDetails.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var recipeDetails: RecipeDetails {
          get {
            return RecipeDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class UpdateRecipeMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation UpdateRecipe($id: ID!, $recipe: RecipeInput!, $image: Upload) {
      updateRecipe(id: $id, recipe: $recipe, image: $image) {
        __typename
        ...RecipeDetails
      }
    }
    """

  public let operationName: String = "UpdateRecipe"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + RecipeDetails.fragmentDefinition)
    return document
  }

  public var id: GraphQLID
  public var recipe: RecipeInput
  public var image: String?

  public init(id: GraphQLID, recipe: RecipeInput, image: String? = nil) {
    self.id = id
    self.recipe = recipe
    self.image = image
  }

  public var variables: GraphQLMap? {
    return ["id": id, "recipe": recipe, "image": image]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateRecipe", arguments: ["id": GraphQLVariable("id"), "recipe": GraphQLVariable("recipe"), "image": GraphQLVariable("image")], type: .nonNull(.object(UpdateRecipe.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateRecipe: UpdateRecipe) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateRecipe": updateRecipe.resultMap])
    }

    public var updateRecipe: UpdateRecipe {
      get {
        return UpdateRecipe(unsafeResultMap: resultMap["updateRecipe"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "updateRecipe")
      }
    }

    public struct UpdateRecipe: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Recipe"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(RecipeDetails.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var recipeDetails: RecipeDetails {
          get {
            return RecipeDetails(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class DeleteRecipeMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation DeleteRecipe($id: ID!) {
      deleteRecipe(id: $id)
    }
    """

  public let operationName: String = "DeleteRecipe"

  public var id: GraphQLID

  public init(id: GraphQLID) {
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deleteRecipe", arguments: ["id": GraphQLVariable("id")], type: .nonNull(.scalar(Bool.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deleteRecipe: Bool) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deleteRecipe": deleteRecipe])
    }

    public var deleteRecipe: Bool {
      get {
        return resultMap["deleteRecipe"]! as! Bool
      }
      set {
        resultMap.updateValue(newValue, forKey: "deleteRecipe")
      }
    }
  }
}

public struct RecipeDetails: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment RecipeDetails on Recipe {
      __typename
      id
      title
      gridImageUrl: imageUrl(size: {width: 640, height: 640}, format: WEBP)
      listImageUrl: imageUrl(size: {width: 240, height: 180}, format: WEBP)
      fullImageUrl: imageUrl(size: {width: 1280, height: 960}, format: WEBP)
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
    """

  public static let possibleTypes: [String] = ["Recipe"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("title", type: .nonNull(.scalar(String.self))),
      GraphQLField("imageUrl", alias: "gridImageUrl", arguments: ["size": ["width": 640, "height": 640], "format": "WEBP"], type: .scalar(String.self)),
      GraphQLField("imageUrl", alias: "listImageUrl", arguments: ["size": ["width": 240, "height": 180], "format": "WEBP"], type: .scalar(String.self)),
      GraphQLField("imageUrl", alias: "fullImageUrl", arguments: ["size": ["width": 1280, "height": 960], "format": "WEBP"], type: .scalar(String.self)),
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

  public init(id: GraphQLID, title: String, gridImageUrl: String? = nil, listImageUrl: String? = nil, fullImageUrl: String? = nil, directions: String? = nil, sideDish: String? = nil, preparationTime: Int? = nil, servingCount: Int? = nil, ingredients: [Ingredient]? = nil) {
    self.init(unsafeResultMap: ["__typename": "Recipe", "id": id, "title": title, "gridImageUrl": gridImageUrl, "listImageUrl": listImageUrl, "fullImageUrl": fullImageUrl, "directions": directions, "sideDish": sideDish, "preparationTime": preparationTime, "servingCount": servingCount, "ingredients": ingredients.flatMap { (value: [Ingredient]) -> [ResultMap] in value.map { (value: Ingredient) -> ResultMap in value.resultMap } }])
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

  public var gridImageUrl: String? {
    get {
      return resultMap["gridImageUrl"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "gridImageUrl")
    }
  }

  public var listImageUrl: String? {
    get {
      return resultMap["listImageUrl"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "listImageUrl")
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
