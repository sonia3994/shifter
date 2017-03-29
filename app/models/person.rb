class Person < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  has_many :appointments
  
  default_scope { order('name ASC') }
  
  scope :actives, -> { where(active: true) }
  scope :inactives, -> { where(active: false) }
  
  validates :name, :group, :email, :phone, :user, presence: true
  validates_plausible_phone :phone
end
