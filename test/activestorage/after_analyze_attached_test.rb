require "test_helper"

class Activestorage::AfterAnalyzeAttachedTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @user = User.create!
  end

  test "triggers after_analyze_attached callback after analyzing attachment" do
    perform_enqueued_jobs do
      @user.avatar.attach(
        io: File.open(Rails.root.join("../fixtures/files/test.jpg")),
        filename: "test.jpg",
        content_type: "image/jpeg"
      )

      @user.reload
      assert_not_nil @user.avatar.metadata[:after_analyze_attached_called_at]
      assert_equal "avatar", @user.avatar.metadata[:after_analyze_attached_attachment_name]
      assert_equal @user.avatar.id, @user.avatar.metadata[:after_analyze_attached_attachment_id]

      100.times do
        @user.pictures.attach(
          io: File.open(Rails.root.join("../fixtures/files/test.jpg")),
          filename: "test.jpg",
          content_type: "image/jpeg"
        )

        @user.reload
        assert_not_nil @user.pictures.last.metadata[:after_analyze_attached_called_at]
        assert_equal "pictures", @user.pictures.last.metadata[:after_analyze_attached_attachment_name]
        assert_equal @user.pictures.last.id, @user.pictures.last.metadata[:after_analyze_attached_attachment_id]
      end
    end

    assert @user.reload.avatar_analyzed
    assert_equal 100, @user.pictures_analyzed

    10.times do
      @user.documents.attach(
        io: File.open(Rails.root.join("../fixtures/files/test.txt")),
        filename: "test.txt",
        content_type: "text/plain"
      )
    end

    assert @user.reload.documents_analyzed
    assert_equal 10, @user.documents_analyzed
  end
end
