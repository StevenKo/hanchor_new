class Subscription < ActiveRecord::Base
	validates :email, presence: true, on: :create
	validates_format_of :email, :with => /@/
end
