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
      attachments = ActiveStorage::Attachment.where(blob: blob)
      attachments.each do |attachment|
        attachment_name = attachment.name.to_sym
        callbacks = self.class.after_analyze_attached_callbacks[attachment_name]
        callbacks.each { instance_eval(&_1) }
      end
    end
  end
end

ActiveSupport.on_load(:active_storage_blob) { include ActiveStorage::AfterAnalyzeAttached::BlobCallbacks }
ActiveSupport.on_load(:active_record)       { include ActiveStorage::AfterAnalyzeAttached::RecordCallbacks }
