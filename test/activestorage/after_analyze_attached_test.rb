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

      100.times do
        @user.pictures.attach(
          io: File.open(Rails.root.join("../fixtures/files/test.jpg")),
          filename: "test.jpg",
          content_type: "image/jpeg"
        )
      end
    end

    assert @user.reload.avatar_analyzed
    assert_equal 100, @user.pictures_analyzed
  end
end
