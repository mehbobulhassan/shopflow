# ShopFlow Dependencies

## State Management
**Package:**  
flutter_riverpod
**Purpose:**  
Application state management and state coordination.
**Why:**  
ShopFlow has shared state such as authentication, products, wishlist, cart and orders.
**When we will use it:**  
When feature state actually needs to be introduced.
**Explaination:**
Riverpod will not replace every local UI state. Simple local state such as
password visibility, temporary UI selections, animation state, and text editing
can remain local to the relevant widget.

## Networking
**Package:**  
http
**Purpose:**  
REST API communication.
**Why:**  
ShopFlow needs REST API communication, but it does not currently require advanced HTTP-client features such as interceptors or extensive request configuration. `http` keeps the networking layer simple while helping us understand HTTP fundamentals directly.
**When we will use it:**  
When the ShopFlow data layer starts communicating with the REST API.

## Navigation
**Package:**
go_router
**Purpose:**
Application-level navigation and authentication-aware routing.
**Why:**
ShopFlow requires centralized authentication-aware navigation. `go_router` provides a structured routing system that fits the application's authenticated and unauthenticated route requirements.
**When we will use it:**
When the application routing and authentication flow are implemented.

## Local Persistence
**Package:**
shared_preferences
**What needs persistence:**
Session information and user preferences.
**Why:**
ShopFlow's first version only needs simple local persistence. `shared_preferences` provides simple key-value storage without introducing unnecessary complexity.
**Source of truth:**
The backend is authoritative for server-owned data such as products, wishlist, cart, and orders. Local persistence is only used for client-side session information and preferences.
**When we will use it:**
When authentication/session restoration or user preferences are implemented.

## Serialization / Models
**Approach:**
Manual `fromJson` / `toJson`
**Purpose:**
Convert API JSON data to Dart models and Dart models to JSON.
**Why:**
ShopFlow is my first serious project and my main goal is learning. Manual mapping will help me understand JSON parsing, Dart models, and the relationship between API data and application models instead of hiding the process behind code generation.
**When we will use it:**
When API models and REST data mapping are implemented.

## Authentication
**Authentication provider:**
To be finalized before authentication implementation.
**Required capabilities:**
- Signup
- Login
- Session restoration
- Logout
- Authentication failure handling

## Testing
**Approach:**
Use Flutter's existing testing capabilities without adding another testing library for now.
**Unit tests:**
Repositories, data mapping, business logic, and validation.
**Widget tests:**
Screens, widgets, user interactions, and UI states.
**Integration tests:**
Important user flows such as Login → Home, Product → Cart, and Cart → Checkout → Order.
**When we will use it:**
Tests will be introduced alongside the features and logic they verify.

## Dependency Rules
A package is added only when:
1. Flutter/Dart doesn't provide a reasonable solution.
2. The package solves a real project requirement.
3. Its maintenance/community quality is acceptable.
4. The added complexity is justified.

## Other

| Requirement | Candidate | Decision | Reason |
|-------------|-----------|----------|--------|
| State management | Riverpod | flutter_riverpod | ShopFlow has shared state such as authentication, products, wishlist, cart, and orders. Riverpod will be introduced when feature state actually needs it. |
| HTTP | http / Dio | http | ShopFlow needs REST API communication, but does not currently require advanced HTTP-client features. `http` keeps networking simple while helping me understand HTTP fundamentals. |
| Navigation | Navigator / go_router | go_router | ShopFlow requires centralized authentication-aware navigation, and `go_router` provides a structured routing approach for authenticated and unauthenticated routes. |
| Local storage | shared_preferences / database | shared_preferences | The first version only needs simple persistence for session information and preferences. A key-value solution is sufficient without introducing database complexity. |
| JSON | Manual / json_serializable | Manual fromJson/toJson | ShopFlow is my first serious project and learning is a major goal. Manual mapping helps me understand JSON parsing and Dart model conversion directly. |
| Authentication | Backend/provider TBD | TBD | The authentication provider will be finalized before authentication implementation because the backend decision has not been made yet. |

| Requirement | Candidate | Decision | Reason |
|-------------|-----------|----------|--------|
| Testing | Flutter testing / additional library | Flutter's existing testing capabilities | Unit, widget, and integration testing can be handled with Flutter's existing testing capabilities for the current project. |