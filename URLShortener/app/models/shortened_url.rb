# == Schema Information
#
# Table name: shortened_urls
#
#  id         :integer          not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ActiveRecord::Base
  validates :long_url, uniqueness: true, presence: true
  validates :short_url, uniqueness: true, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: 'User'

  def self.random_code
    short = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(short_url: short)
      short = SecureRandom.urlsafe_base64
    end
    short
  end

  def self.create_new(user, long_string)
    mixed_url = ShortenedUrl.random_code
    ShortenedUrl.create!(short_url: mixed_url, long_url: long_string, user_id: user.id)
  end
end
