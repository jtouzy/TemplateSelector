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
    fetch: fetchHandler()
  )
}

private let cachingKey = "OFFLINE_DATA"
private let fetchURL = "https://ptitchevreuil.github.io/mojo/templates.json"

private func fetchHandler() -> TemplateService.Fetch {
  return {
    guard let url = URL(string: fetchURL) else {
      throw FetchTemplateError.invalidFetchingURL
    }
    do {
      // NOTE: We try to invoke the URL in first step
      let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))
      guard let httpResponse = response as? HTTPURLResponse else {
        throw FetchTemplateError.httpResponseCannotBeParsed
      }
      if (200...299).contains(httpResponse.statusCode) == false {
        throw FetchTemplateError.invalidHttpResponseStatusCode
      }
      UserDefaults.standard.setValue(data, forKey: cachingKey)
      return data
    } catch {
      // NOTE: If any error occurs, just check if the data is cached locally
      guard let cached = UserDefaults.standard.data(forKey: cachingKey) else {
        throw error
      }
      return cached
    }
  }
}
