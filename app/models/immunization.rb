# == Schema Information
#
# Table name: immunizations
#
#  id         :integer          not null, primary key
#  bcg        :string(255)
#  opv1       :string(255)
#  opv2       :string(255)
#  opv3       :string(255)
#  opv4       :string(255)
#  dpt1       :string(255)
#  dpt2       :string(255)
#  dpt3       :string(255)
#  dpt4       :string(255)
#  tt1        :string(255)
#  tt2        :string(255)
#  tt3        :string(255)
#  tt4        :string(255)
#  hepb1      :string(255)
#  hepb2      :string(255)
#  hepb3      :string(255)
#  hepb4      :string(255)
#  measles1   :string(255)
#  measles2   :string(255)
#  mmr1       :string(255)
#  mmr2       :string(255)
#  hib1       :string(255)
#  hib2       :string(255)
#  hib3       :string(255)
#  hib4       :string(255)
#  mening     :string(255)
#  pneumo     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Immunization < ActiveRecord::Base
  # attr_accessible :title, :body
end
