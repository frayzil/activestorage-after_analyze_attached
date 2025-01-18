# Activestorage::AfterAnalyzeAttached

[![CI](https://github.com/frayzil/activestorage-after_analyze_attached/actions/workflows/ci.yml/badge.svg)](https://github.com/frayzil/activestorage-after_analyze_attached/actions/workflows/ci.yml)
[![Coverage](https://raw.githubusercontent.com/frayzil/activestorage-after_analyze_attached/main/.github/badges/coverage.svg)](https://github.com/frayzil/activestorage-after_analyze_attached/actions/workflows/ci.yml)

A Rails gem that provides a callback for when Active Storage attachments are analyzed. This is particularly useful when you need to perform actions after Active Storage has analyzed an attachment, such as updating flags, triggering background jobs, or updating the UI.

## Why use this gem?

Active Storage analyzes uploaded files asynchronously to extract metadata like image dimensions, document page count, etc. However, there's no built-in way to hook into this analysis completion event. This gem provides that missing callback, allowing you to:

- Update UI when image processing is complete
- Trigger downstream processing after file analysis
- Track progress of batch uploads
- Maintain analysis state for attachments

## Usage

This gem adds an `after_analyze_attached` callback that you can use in your models. The callback is triggered after Active Storage analyzes an attachment.

Example:

```ruby
class Product < ApplicationRecord
  has_one_attached :thumbnail
  has_many_attached :gallery_images

  # Update UI when thumbnail is ready
  after_analyze_attached :thumbnail do
    broadcast_replace_to :products,
      target: dom_id(self, :thumbnail_status),
      partial: "products/thumbnail_status",
      locals: { product: self }
  end

  # Track gallery processing progress
  after_analyze_attached :gallery_images do
    increment!(:processed_images_count)
    if processed_images_count == gallery_images.count
      update!(gallery_ready: true)
      GalleryProcessingJob.perform_later(self)
    end
  end
end

class Document < ApplicationRecord
  has_one_attached :pdf
  belongs_to :organization

  # Trigger OCR when PDF is analyzed
  after_analyze_attached :pdf do
    OcrProcessingJob.perform_later(self)
    organization.members.each do |member|
      DocumentMailer.ready_for_review(member, self).deliver_later
    end
  end
end
```

In these examples:
- Product thumbnails trigger UI updates via Turbo Streams when ready
- Gallery images track processing progress and trigger a job when complete
- Documents start OCR processing and notify team members when ready

## Installation

Add this line to your application's Gemfile:

```ruby
gem "activestorage-after_analyze_attached"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install activestorage-after_analyze_attached
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/frayzil/activestorage-after_analyze_attached.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
