//
//  TemplateListTests.swift
//  TemplateSelectorTests
//
//  Created by Jérémy TOUZY on 25/06/2022.
//

@testable import TemplateSelector

import ComposableArchitecture
import Domain
import Efs
import SwiftUI
import XCTest

extension Template {
  static let mock: Self = .init(
    id: .init(),
    name: "TemplateName",
    element: .init(id: .init(), relativeSize: .init(width: 0.5, height: 0.5), backgroundColor: .clear)
  )
}
extension TemplateList {
  typealias TestStore = ComposableArchitecture.TestStore<State, State, Action, Action, Environment>
}

final class TemplateListTests: XCTestCase {
  private func createStore(
    state: TemplateList.State,
    fetchTemplates: @escaping TemplateList.Environment.FetchTemplates = Efs.failing()
  ) -> TemplateList.TestStore {
    .init(
      initialState: state,
      reducer: TemplateList.reducer,
      environment: .init(fetchTemplates: fetchTemplates)
    )
  }
}

extension TemplateListTests {
  func test_onAppear() {
    // Given
    let result = [Template.mock]
    let fetchingResult: Result<[Template], NSError> = .success(result)
    let store = createStore(
      state: .loadingTemplates,
      fetchTemplates: { .init(value: fetchingResult) }
    )
    // When/Then
    store.send(.onAppear)
    store.receive(.templateFetched(fetchingResult)) { state in
      state = .displayed(data: result)
    }
  }
  func test_onAppear_failingCase() {
    // Given
    let fetchingResult: Result<[Template], NSError> = .failure(NSError(domain: "", code: 22))
    let store = createStore(
      state: .loadingTemplates,
      fetchTemplates: { .init(value: fetchingResult) }
    )
    // When/Then
    store.send(.onAppear)
    store.receive(.templateFetched(fetchingResult)) { state in
      state = .loadingFailure
    }
  }
}
