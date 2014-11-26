class FacebookAccount < ActiveRecord::Base
  belongs_to :person

  validates :uid, presence: true
  validates :person, presence: true

  def self.find_or_create_for_facebook(auth)

    where(provider: auth.provider, uid: auth.uid).first_or_create do |fb_account|
      fb_account.uid = auth.uid
      fb_account.provider = auth.provider
      fb_account.build_person(first_name: auth.info.first_name, last_name: auth.info.last_name)
    end
  end

end
