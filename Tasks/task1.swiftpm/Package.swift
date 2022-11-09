// swift-tools-version: 5.6

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "task1.counter",
    platforms: [
        .iOS("15.2")
    ],
    products: [
        .iOSApplication(
            name: "task1.counter",
            targets: ["AppModule"],
            bundleIdentifier: "edu.apple.2022.xta.task1.task1-counter",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .beachball),
            accentColor: .presetColor(.purple),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: "."
        )
    ]
)