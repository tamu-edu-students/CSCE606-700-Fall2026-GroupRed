class Report < ApplicationRecord
  STATUSES = %w[ open resolved dismissed ].freeze

  belongs_to :reporter, class_name: "User", inverse_of: :reports
  belongs_to :reportable, polymorphic: true

  validates :reason, presence: true, length: { maximum: 500 }
  validates :status, inclusion: { in: STATUSES }
  validate :cannot_report_yourself

  scope :open, -> { where(status: "open") }

  # What the report is about, as shown to peiople ("Alex", "a companion reply")
  def subject_name
    reportable.respond_to?(:display_name) ? reportable.display_name : reportable_type.titlesize
  end

  private

  def cannot_report_yourself
    errors.add(:base, "You can't report yourself") if reportable == reporter
  end
end
