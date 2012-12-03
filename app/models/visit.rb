class Visit < ActiveRecord::Base
  belongs_to :patient
  attr_protected
  validates_presence_of :date
  validate :date_past
  validate :next_visit_future

  private
  def date_past
    errors.add(:date, 'cannot be in the future') if date && (date >= DateTime.now)
  end

  def next_visit_future
    errors.add(:next_visit, 'date cannot be in the past') if next_visit && (next_visit < DateTime.now)
  end
end
