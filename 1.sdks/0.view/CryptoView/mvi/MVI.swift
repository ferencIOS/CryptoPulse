//
//  MVI.swift
//  CryptoView
//
//  Created by francesco scalise on 19/03/24.
//

import Foundation

struct MVI {
    
    /// `State` represents the UI state of a SwiftUI view at a given point in time.
    ///
    /// Conform to the `State` protocol to define the properties that represent the view's data.
    /// This could include anything from user input to data fetched from an external source.
    /// The conforming type is typically a struct with properties marked with `@Published` if
    /// using a class, to allow SwiftUI views to react to changes in the state.
    protocol State {}
    
    /// `Intent` represents user actions that can mutate the state of the application.
    ///
    /// Conform to the `Intent` protocol to define different user actions as an enumeration.
    /// Each case of the enumeration should represent a unique user intent that triggers
    /// a change in the application's state. Intents are dispatched to a ViewModel, where
    /// they are processed to produce a new state or side effects.
    protocol Intent {}
    
    /// `Effect` represents side effects that are a result of processing user intents.
    ///
    /// Conform to the `Effect` protocol to define outcomes of user actions that do not
    /// directly mutate the state but instead cause side effects such as navigation,
    /// showing alerts, or other asynchronous operations. Effects are handled separately
    /// from state changes to maintain a clean separation of concerns.
    protocol Effect {}
}

/// A `ViewModel` acts as an intermediary between the view's intents and the application's state,
/// processing user actions and updating the state accordingly.
///
/// Conform to the `ViewModel` protocol to implement the logic that responds to intents and
/// manages the state of the UI. The ViewModel also triggers effects as necessary, based on
/// the processing of intents. It is responsible for the core logic of the MVI architecture.
///
/// - Parameters:
///   - S: A type that conforms to the `State` protocol, representing the state of the UI.
///   - I: A type that conforms to the `Intent` protocol, representing actions from the user.
///   - E: A type that conforms to the `Effect` protocol, representing side effects of actions.
///
/// The ViewModel should be an `ObservableObject` to allow SwiftUI views to observe changes
/// to the state and re-render as necessary.
protocol ViewModel: ObservableObject {
    associatedtype S: MVI.State
    associatedtype I: MVI.Intent
    associatedtype E: MVI.Effect

    /// The current state of the UI.
    var state: S { get set }

    /// Processes an intent to mutate the state or trigger an effect.
    ///
    /// - Parameter intent: The user action to process.
    func dispatch(_ intent: I)

    /// Triggers an effect as a result of processing an intent.
    ///
    /// - Parameter effect: The side effect to trigger.
    func trigger(_ effect: E)
}
