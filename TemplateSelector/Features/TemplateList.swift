//
//  TemplateList.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import ComposableArchitecture
import SwiftUI

enum TemplateList {
}

// MARK: -TemplateList.State

extension TemplateList {
  enum State: Equatable {
    case loadingTemplates
    case displayed(data: [Template])
    case loadingFailure
  }
}

// MARK: -TemplateList.Action

extension TemplateList {
  enum Action {
    case onAppear
    case templateFetched(Result<[Template], NSError>)
    case templateSelected(Template)
  }
}

// MARK: -TemplateList.Environment

extension TemplateList {
  struct Environment {
    let fetchTemplates: () -> Effect<Result<[Template], NSError>, Never>
  }
}

// MARK: -TemplateList.Reducer

extension TemplateList {
  static let reducer: Reducer<State, Action, Environment> = .init { state, action, environment in
    switch action {
    case .onAppear:
      state = .loadingTemplates
      return environment.fetchTemplates().map(Action.templateFetched)
    case .templateFetched(.success(let templates)):
      state = .displayed(data: templates)
    case .templateFetched(.failure):
      state = .loadingFailure
    case .templateSelected(let template):
      ()
    }
    return .none
  }
}

// MARK: -TemplateList.View

private struct UI {
  struct Grid {
    static let numberOfColumns: Int = 3
    static let columns: [SwiftUI.GridItem] = {
      (0..<numberOfColumns).map { _ in .init() }
    }()
    static let padding = UI.GridItem.padding
  }
  struct GridItem {
    static let height: CGFloat = 150
    static let padding: CGFloat = 16.0

    static func frame(in containerSize: CGSize) -> CGSize {
      let totalInnerPadding = (CGFloat(UI.Grid.numberOfColumns) - 1) * padding
      let availableWidthInContainer = containerSize.width - totalInnerPadding
      return .init(
        width: availableWidthInContainer / CGFloat(UI.Grid.numberOfColumns),
        height: height
      )
    }
  }
}

extension TemplateList {
  struct View: SwiftUI.View {
    let store: Store<State, Action>
    @ObservedObject var viewStore: ViewStore<State, Action>

    init(store: Store<State, Action>) {
      self.store = store
      self.viewStore = ViewStore(store)
    }

    var body: some SwiftUI.View {
      NavigationView {
        stateBasedView(
          using: viewStore.state,
          onTemplateTap: { viewStore.send(.templateSelected($0)) }
        )
        .navigationTitle("Choose a template")
      }
      .onAppear { viewStore.send(.onAppear) }
    }
  }
}

@ViewBuilder
private func stateBasedView(
  using state: TemplateList.State,
  onTemplateTap: @escaping (Template) -> Void
) -> some View {
  switch state {
  case .loadingTemplates:
    ProgressView()
  case .displayed(let data):
    templateListView(using: data, onTap: onTemplateTap)
  case .loadingFailure:
    Text("Failure!")
  }
}

@ViewBuilder
private func templateListView(
  using templates: [Template],
  onTap: @escaping (Template) -> Void
) -> some View {
  GeometryReader { proxy in
    ScrollView {
      LazyVGrid(columns: UI.Grid.columns, spacing: .zero) {
        ForEach(templates) { template in
          TemplateRenderer(template: template, onTap: { _ in })
            .frame(UI.GridItem.frame(in: proxy.size))
            .onTapGesture { onTap(template) }
        }
      }
    }
  }
  .padding(UI.Grid.padding)
}
