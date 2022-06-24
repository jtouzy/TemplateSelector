//
//  Main.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 24/06/2022.
//

import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

enum Main {
}

// MARK: -Main.State

extension Main {
  struct State: Equatable {
    var templateListState: TemplateList.State
    var templateEditorState: TemplateEditor.State?
  }
}
extension Main.State {
  static let initial: Self = .init(templateListState: .loadingTemplates)
}

// MARK: -Main.Action

extension Main {
  enum Action {
    case templateList(TemplateList.Action)
    case templateEditor(TemplateEditor.Action)
    case templateEditorStateChanged(TemplateEditor.State?)
  }
}

// MARK: -Main.Environment

extension Main {
  struct Environment {
    typealias FetchTemplates = TemplateList.Environment.FetchTemplates
    let fetchTemplates: FetchTemplates
  }
}

// MARK: -Main.Reducer

extension Main {
  static let localReducer: Reducer<State, Action, Environment> = .init { state, action, environment in
    switch action {
    case .templateList(let templateListAction):
      guard case .templateSelected(let template) = templateListAction else {
        return .none
      }
      state.templateEditorState = .init(editedTemplate: template)
    case .templateEditor(let templateEditorAction):
      guard case .closeTapped = templateEditorAction else {
        return .none
      }
      state.templateEditorState = .none
    case .templateEditorStateChanged(let newState):
      state.templateEditorState = newState
    }
    return .none
  }
  static let reducer: Reducer<State, Action, Environment> = .combine(
    TemplateList.reducer.pullback(
      state: \.templateListState,
      action: /Action.templateList,
      environment: { .init(fetchTemplates: $0.fetchTemplates) }
    ),
    TemplateEditor.reducer.optional().pullback(
      state: \.templateEditorState,
      action: /Action.templateEditor,
      environment: { _ in }
    ),
    localReducer
  )
}

// MARK: -Main.View

extension Main {
  struct View: SwiftUI.View {
    let store: Store<State, Action>
    @ObservedObject var viewStore: ViewStore<State, Action>

    init(store: Store<State, Action>) {
      self.store = store
      self.viewStore = ViewStore(store)
    }

    var body: some SwiftUI.View {
      TemplateList.View(
        store: store.scope(state: \.templateListState, action: Action.templateList)
      )
      .fullScreenCover(
        unwrapping: viewStore.binding(get: \.templateEditorState, send: Action.templateEditorStateChanged)
      ) { _ in
        IfLetStore(
          store.scope(state: \.templateEditorState, action: Action.templateEditor),
          then: TemplateEditor.View.init(store:)
        )
      }
    }
  }
}
