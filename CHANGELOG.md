# Changelog

## [0.2.0] - 2024-07-08

### Added
- Access to attachment and blob objects in callback methods
- Example: `after_analyze_attached :avatar do |attachment, blob| ... end`

## [0.1.1] - 2024-05-23

### Changed
- Patch release with minor improvements

## [0.1.0] - 2024-01-18

### Added
- Initial release
- `after_analyze_attached` callback for Active Storage attachments
- Support for both single and multiple attachments
- Rails 8.0+ compatibility 