# Little Lemon Food Ordering App (SwiftUI + Core Data)

Target: iOS 16+, Xcode 15+.

## Setup in Xcode
1. File > New > Project > iOS > App. Product Name: `LittleLemon`, Interface: SwiftUI, Language: Swift, Storage: None.
2. Delete the template `ContentView.swift`.
3. Drag the `LittleLemon/` folder contents (all `.swift` files and `LittleLemon.xcdatamodeld`) into the project target, with "Copy items if needed" and the LittleLemon target checked.
4. Select the `Dish` entity in `LittleLemon.xcdatamodeld`, open the Data Model Inspector, and set Codegen to **Manual/None** (the `Dish` class is already provided).
5. Build and run.

## Wireframe
`python3 generate_wireframe.py` creates `wireframe.jpg` in this folder (requires `pip install pillow`).

## Notes
- Menu JSON URL and image base URL are in `Models/AppConfig.swift`. Confirm them against your course instructions.
- Hero and profile images use SF Symbols as placeholders, so no image assets are required.
- The category list (`MenuSection`) is named to avoid clashing with SwiftUI's own `Menu` type.
