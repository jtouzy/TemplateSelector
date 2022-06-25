//
//  Environment+Mock.swift
//  TemplateSelector
//
//  Created by Jérémy TOUZY on 25/06/2022.
//

#if DEBUG
import Domain

extension Main.Environment {
  static let mock: Self = .init(
    fetchTemplates: fetchTemplatesHandler()
  )
}

private func fetchTemplatesHandler() -> Main.Environment.FetchTemplates {
  return {
    .init(
      value: .success([
        Template(
          id: .init(),
          name: "Mocked Template",
          element: .init(
            id: .init(),
            relativeSize: .init(width: 1, height: 1),
            children: [
              .init(
                id: .init(),
                relativePosition: .init(x: 0.5, y: 0.5),
                relativeSize: .init(width: 0.3, height: 0.3),
                anchorX: .center,
                anchorY: .center,
                backgroundColor: .yellow
              )
            ],
            backgroundColor: .blue
          )
        ),
        Template(
          id: .init(),
          name: "Mocked Template 2",
          element: .init(
            id: .init(),
            relativeSize: .init(width: 1, height: 1),
            children: [
              .init(
                id: .init(),
                relativePosition: .init(x: .zero, y: 0.5),
                relativeSize: .init(width: 0.5, height: 0.5),
                anchorX: .left,
                anchorY: .bottom,
                backgroundColor: .yellow
              )
            ],
            backgroundColor: .red
          )
        )
      ])
    )
  }
}
#endif
