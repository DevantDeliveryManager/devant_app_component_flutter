/// Account types on the backend. The value sent is [name] (`userType`).
enum UserRole { seeker, healer }

/// The role this app signs in and registers. The single place it is defined.
const UserRole appUserRole = UserRole.healer;
