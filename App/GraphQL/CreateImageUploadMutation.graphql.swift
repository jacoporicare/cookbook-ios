// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import API

public class CreateImageUploadMutation: GraphQLMutation {
  public static let operationName: String = "CreateImageUpload"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateImageUpload($contentType: String!) { createImageUpload(contentType: $contentType) { __typename key uploadUrl } }"#
    ))

  public var contentType: String

  public init(contentType: String) {
    self.contentType = contentType
  }

  public var __variables: Variables? { ["contentType": contentType] }

  public struct Data: API.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { API.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("createImageUpload", CreateImageUpload.self, arguments: ["contentType": .variable("contentType")]),
    ] }
    public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
      CreateImageUploadMutation.Data.self
    ] }

    /// Presign a direct-to-S3 staging upload for a recipe image original. The returned key is submitted as imageId to createRecipe/updateRecipe, which promotes it.
    public var createImageUpload: CreateImageUpload { __data["createImageUpload"] }

    /// CreateImageUpload
    ///
    /// Parent Type: `ImageUploadTarget`
    public struct CreateImageUpload: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { API.Objects.ImageUploadTarget }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("key", API.ID.self),
        .field("uploadUrl", String.self),
      ] }
      public static var __fulfilledFragments: [any ApolloAPI.SelectionSet.Type] { [
        CreateImageUploadMutation.Data.CreateImageUpload.self
      ] }

      /// Opaque image key; PUT the original to uploadUrl, then pass this as imageId to createRecipe/updateRecipe.
      public var key: API.ID { __data["key"] }
      /// Presigned S3 URL to PUT the original file to (send the same Content-Type).
      public var uploadUrl: String { __data["uploadUrl"] }
    }
  }
}
