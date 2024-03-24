# CryptoPulse

CryptoPulse is a sleek iOS application designed to keep cryptocurrency enthusiasts and investors updated with the latest market trends. Utilizing the power of Swift 5.10 and SwiftUI, this app provides real-time insights into the top ten cryptocurrencies by market cap, detailed analytics, and historical price data.

For a comprehensive walkthrough of CryptoPulse's features and functionality, please refer to our video demonstration: 

![Demo](demo.gif)

## Features

- **Top Cryptocurrencies**: Displays a list of the top ten cryptocurrencies by market cap.
- **Crypto Details**: Tapping on a cryptocurrency navigates to a detailed view, showcasing the crypto's description, website link, and historical price data over the last week.
- **Interactive Market Chart**: Utilizing [Apple's Charts library](https://developer.apple.com/documentation/charts) for a simple yet informative market chart visualization.
- **SwiftUI for an enhanced UI/UX experience**: Leveraging SwiftUI for a responsive and intuitive user interface.

## Getting Started

### Prerequisites

- Xcode 15.3
- Swift 5.10

### Setup

1. Clone the repository to your local machine.
2. Open `crypto-pulse.xcworkspace` in Xcode.
3. To run on a simulator, select an iPhone 15 (or newer) from the target device list.

**Note**: If you wish to run the app on a physical device, you will need to modify the `Bundle Identifier` and `Team` to match your provisioning profile.

### Running the App

1. Build the project by pressing `Cmd + B`.
2. Run the app by pressing `Cmd + R`. This will launch the selected simulator or physical device.

## Architecture

CryptoPulse is built using the Model-View-Intent (MVI) architecture, ensuring a robust, maintainable, and scalable codebase.

- **Model**: Represents the app's data structure, encapsulating the business logic.
- **View**: Swift UI views that render the user interface based on the current state.
- **Intent**: User actions that can mutate the state of the application, processed by the ViewModel.
- **Effect**: Represents the side effects of processing user intents within the application. Unlike state changes, which directly modify the UI's appearance or data, effects typically handle operations that have broader implications for the app's functionality.
- **ViewModel**: Acts as a bridge between the View's intents and the app's Model, managing the UI state and triggering effects.

## Dependencies

CryptoPulse is developed using entirely native APIs, including the utilization of Apple's Charts library for charting functionalities, ensuring a seamless and integrated user experience.

## Contributing

Feel free to fork the project and submit pull requests with new features or fixes. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the LICENSE file for details.