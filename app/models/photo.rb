# == Schema Information
#
# Table name: photos
#
#  id           :integer          not null, primary key
#  patient_id   :integer
#  date         :datetime
#  comments     :string(255)
#  content_type :string(255)
#  name_string  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Photo < ActiveRecord::Base
  include DateValidators
  attr_accessible :comments, :content_type, :date, :name_string, :patient_id, :patient
  belongs_to :patient
  validates_presence_of :patient_id, :date
  validate :not_future
#  validates_format_of :content_type, :with => /^image/, :message => "--- you can only upload pictures "

  # ToDo these just have to do with uploading and will probably be removed & a tool used
  def picture=(picture_field)
    self.name = base_part_of(picture_field.original_filename)
    self.content_type = picture_field.content_type.chomp
    self.data = picture_field.read
  end

  def base_part_of(file_name)
    name = File.basename(file_name)
    name.gsub(/[^\w._-]/, '')
  end

end
