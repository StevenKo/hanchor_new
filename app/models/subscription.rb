class Subscription < ActiveRecord::Base
	validates :email, presence: true, on: :create
end
