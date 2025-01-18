# user_profile_management

User Profile Management project designed to perform advanced user profile management, including CRUD functions. The app supports offline data caching and error handling.
## Getting Started

### API & Data Handling
- `GET`: Fetch user profiles.
- `POST`: Add new user profiles.
- `PUT`: Update existing user profiles.
- `DELETE`: Remove user profiles.
- endpoint = "https://jsonplaceholder.typicode.com/users";


- **Data handling**:
    - Uses `SharedPreferences` to store data locally for offline support.
    - Uses `Dio` to handel data from json
    - Uses `connectivity_plus` to check internet connection 

## **Contributors**
- [AhmedRoshdy](https://github.com/ARoshdy123)
- [Marina](https://github.com/ARoshdy123)
- [Osama](https://github.com)