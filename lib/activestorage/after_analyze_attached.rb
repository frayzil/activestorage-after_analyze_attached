require "activestorage/after_analyze_attached/version"
require "active_storage/engine"
require "rails"

module ActiveStorage::AfterAnalyzeAttached
  module BlobCallbacks
    extend ActiveSupport::Concern

    included do
      define_callbacks :analyze
      set_callback(:analyze, :after) { attachments.map(&:record).uniq.each { _1.blob_analyzed self } }
    end

    def analyze = run_callbacks(:analyze) { super }
  end

  module RecordCallbacks
    extend ActiveSupport::Concern

    class_methods do
      def after_analyze_attached(name, &callback)
        after_analyze_attached_callbacks[name.to_sym] << callback
      end

      def after_analyze_attached_callbacks
        @after_analyze_attached_callbacks ||= Hash.new { |hash, key| hash[key] = [] }
      end
    end

    def blob_analyzed(blob)
      after_analyze_attached_callbacks(blob).each { instance_eval(&_1) }
    end

    def after_analyze_attached_callbacks(blob)
      attachment_names = ActiveStorage::Attachment.where(blob: blob).pluck(:name).map(&:to_sym)
      attachment_names.flat_map { |name| self.class.after_analyze_attached_callbacks[name] }
    end
  end
end

ActiveSupport.on_load(:active_storage_blob) { include ActiveStorage::AfterAnalyzeAttached::BlobCallbacks }
ActiveSupport.on_load(:active_record)       { include ActiveStorage::AfterAnalyzeAttached::RecordCallbacks }
