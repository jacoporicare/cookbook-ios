// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
@_spi(Execution) @_spi(Unsafe) import ApolloAPI

nonisolated public struct CreateImageUploadMutation: GraphQLMutation {
  public static let operationName: String = "CreateImageUpload"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateImageUpload($contentType: String!) { createImageUpload(contentType: $contentType) { __typename key uploadUrl } }"#
    ))

  public var contentType: String

  public init(contentType: String) {
    self.contentType = contentType
  }

  @_spi(Unsafe) public var __variables: Variables? { ["contentType": contentType] }

  nonisolated public struct Data: API.SelectionSet {
    @_spi(Unsafe) public let __data: DataDict
    @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

    @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
    @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
      .field("createImageUpload", CreateImageUpload.self, arguments: ["contentType": .variable("contentType")]),
    ] }
    @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CreateImageUploadMutation.Data.self
    ] }

    /// Presign a direct-to-S3 staging upload for a recipe image original. The returned key is submitted as imageId to createRecipe/updateRecipe, which promotes it.
    public var createImageUpload: CreateImageUpload { __data["createImageUpload"] }

    /// CreateImageUpload
    ///
    /// Parent Type: `ImageUploadTarget`
    nonisolated public struct CreateImageUpload: API.SelectionSet {
      @_spi(Unsafe) public let __data: DataDict
      @_spi(Unsafe) public init(_dataDict: DataDict) { __data = _dataDict }

      @_spi(Execution) public static var __parentType: any ApolloAPI.ParentType { API.Objects.ImageUploadTarget }
      @_spi(Execution) public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("key", API.ID.self),
        .field("uploadUrl", String.self),
      ] }
      @_spi(Execution) public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CreateImageUploadMutation.Data.CreateImageUpload.self
      ] }

      /// Opaque image key; PUT the original to uploadUrl, then pass this as imageId to createRecipe/updateRecipe.
      public var key: API.ID { __data["key"] }
      /// Presigned S3 URL to PUT the original file to (send the same Content-Type).
      public var uploadUrl: String { __data["uploadUrl"] }
    }
  }
}
