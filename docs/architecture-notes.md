### Why are features grouped by responsibility?
Features are grouped by responsibility so related business functionality stays together and the project remains organized.
### Why are Search and Category part of Products?
Search and Category are part of Products because both are used for discovering and browsing products.
### Why does Home currently only have Presentation?
Home currently only has Presentation because its main responsibility is to compose and display content from other features rather than own separate data or business logic.
### When should a feature get Data/Domain layers?
A feature should get a Data layer when it needs to retrieve, store, or communicate with external data. It should get a Domain layer when it has meaningful business rules, entities, or use cases.
### What is the purpose of core?
The purpose of core is to contain application-wide infrastructure such as routing, theme, global errors, constants, and genuinely generic utilities.
### What is the purpose of shared?
The purpose of shared is to contain genuinely reusable components, such as widgets or extensions, that are used across multiple features.