# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).


## [Unreleased]

### Added

- Nothing

### Changed

- Add support for AR 5.0.x
- Drop support for AR 3.x
- Drop support for Ruby < 2.1

### Fixed

- Nothing


## [0.3.0]

### Added

- You can now pass a nested hash for associaiton conditions (see README)

### Changed

- Now it requires at least ruby 1.9.2


## [0.2.0]

### Changed

- Use dynamic query string instead of Arel Table to generate relation (which cause the bug)
- Add a few test for compatibility with gem `squeel`

### Fixed

- You can now use this with named scopes


## 0.1.0

### Added

- Initial Release
  
  
[Unreleased]: https://github.com/AssetSync/asset_sync/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/AssetSync/asset_sync/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/AssetSync/asset_sync/compare/v0.1.0...v0.2.0
