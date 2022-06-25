# TemplateSelector

## Architecture

I'm way more comfortable using TCA in SwiftUI apps. I think it's the architecture that represents the real lifecycle of an app, and even if there's a little gap to understand (because it's a bit different from classic MVVM or MVC), I think it's clearly worth it.

So, let's take an overview of TCA with this schema (from a previous presentation I made to my company) :

<img src="https://user-images.githubusercontent.com/5709133/175787258-82895d20-2cb4-483d-bf5c-de60d3b26de1.png"/>

* `View` : Classic SwiftUI view. The only required dependency is to have a Store, which will trigger actions and from which we can read state values from.

* `State` : Representation of the module data. It can be represented as an enum if the view can have slightly different states, but in most cases, it's a plain old struct. The state will be read by the view to display those informations.

* `Action` : An enum representing all the actions that the view can trigger (every button click you want to control, a page swipe, a lifecycle event, ...)

* `Reducer` : The reducer will take the action in input, make changes to the state, then return a side effect. It's just basically a simple function. Side effects are here to exclude everything that it's not directly linked to the module (see Environment for more explanations)

* `Environment` : A black box provided to the TCA module to allow executing more complex logic outside of the module, and impact it later. For example, if you want to call an API, the module just has to expose an asynchronous function. The implementation of the call will be provided when you launch the module. If you're in a mock mode for example, you can provide mocked results instead of real API call.

## Testing priorities

Why is only some code tested ? In my opinion not all the code must be tested, but only the most relevant one. In this case :

* `AppleExtensions` : Code present in this module could be used everywhere in the app as utilities. It needs to work perfectly, and checked on every update. In most of the cases, tests of those kinds of utilities are cheap to implement, so it's another good point for that!

* `Domain/Template functions` : The core of the app is rendering the JSON elements. So it seems logical to implement tests for all the SwiftUI layout calculations.

* `Features` : The features are written in TCA. With TCA modules, the most relevant code to test is the reducer, which contains all the module logic. The TCA library also offers some good tools to easily test those reducers. So tests are implemented in those modules too.

With more time, the JSON parsing logic can be tested too. Default values are handled in the decoding specific function, so it would be nice to check this complex decoding implementation.
