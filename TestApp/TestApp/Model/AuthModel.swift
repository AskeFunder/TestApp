// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let authModel = try? newJSONDecoder().decode(AuthModel.self, from: jsonData)

import Foundation

// MARK: - AuthModel
struct AuthModel: Codable {
    let idToken, accessToken: String
    let expiresIn: Int
    let tokenType, refreshToken, scope: String

    enum CodingKeys: String, CodingKey {
        case idToken = "id_token"
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case scope
    }
}
