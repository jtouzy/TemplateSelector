//
//  Environment+Live.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import ComposableArchitecture
import SwiftUI

extension Main.Environment {
  static let live: Self = .init(
    fetchTemplates: fetchTemplatesHandler()
  )
}

private enum FetchTemplateError: Error {
  case errorDuringInvocation(cause: Error)
  case invalidFetchingURL
}

private func fetchTemplatesHandler() -> Main.Environment.FetchTemplates {
  return {
    Effect.task {
      do {
        guard let url = URL(string: "https://ptitchevreuil.github.io/mojo/templates.json") else {
          throw FetchTemplateError.invalidFetchingURL
        }
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let decoded = try jsonDecoder.decode(TemplateAPI.Response.self, from: data)
        return decoded.templates
      } catch {
        print("Error occured during call: \(error)")
        throw FetchTemplateError.errorDuringInvocation(cause: error)
      }
    }
    .eraseToNSError()
    .catchToEffect()
  }
}
