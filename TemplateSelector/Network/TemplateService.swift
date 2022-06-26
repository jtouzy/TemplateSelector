//
//  TemplateService.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 26/06/2022.
//

import Domain
import Foundation

struct TemplateService {
  typealias Fetch = () async throws -> Data

  private let fetch: Fetch

  init(fetch: @escaping Fetch) {
    self.fetch = fetch
  }
}

private enum FetchTemplateError: Error {
  case invalidFetchingURL
  case invalidHttpResponseStatusCode
  case httpResponseCannotBeParsed
}

extension TemplateService {
  func fetchTemplates() async throws -> [Template] {
    do {
      let data = try await fetch()
      let jsonDecoder = JSONDecoder()
      jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
      let decoded = try jsonDecoder.decode(TemplateAPI.Response.self, from: data)
      return decoded.templates
    } catch {
      print("Error occured during call: \(error)")
      throw error
    }
  }
}

extension TemplateService {
  static let live: Self = .init(
    fetch: {
      guard let url = URL(string: "https://ptitchevreuil.github.io/mojo/templates.json") else {
        throw FetchTemplateError.invalidFetchingURL
      }
      let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
      guard let httpResponse = response as? HTTPURLResponse else {
        throw FetchTemplateError.httpResponseCannotBeParsed
      }
      if (200...299).contains(httpResponse.statusCode) == false {
        throw FetchTemplateError.invalidHttpResponseStatusCode
      }
      return data
    }
  )
}
