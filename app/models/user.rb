class User < ApplicationRecord

    # has_many :active_relationships, class_name: "Relationship",
    #                                 foreign_key: "follower_id",
    #                                 dependent: :destroy
    # has_many :passive_relationships, class_name: "Relationship",
    #                                 foreign_key: "followed_id",
    #                                 dependent: :destroy
    # has_many :following, through: :active_relationships, source: :followed
    # has_many :followers, through: :passive_relationships, source: :follower
    has_many :receivable_baggages, class_name: "Baggage",
                                foreign_key: "user_id",
                                dependent: :destroy
    has_many :leaves, class_name: "Transaction",
                                foreign_key: "leaver_id",
                                dependent: :destroy
    has_many :received, class_name: "Transaction",
                                foreign_key: "receiver_id",
                                dependent: :destroy
    
    

    accepts_nested_attributes_for :receivable_baggages

    attr_accessor :remember_token

    before_save {self.email = email.downcase}   # または、{email.downcase!}

    # validation
    validates(:name, presence: true , length: {maximum:50})
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates(:email, presence: true , length: {maximum:255}, 
                format: {with: VALID_EMAIL_REGEX}, 
                # {case_sensitive: false}をまるごとtrueに置き換えることで大文字と小文字を区別しなくなる
                uniqueness: {case_sensitive: false})

    has_secure_password
    validates :password, presence: true, length: {minimum: 6}, allow_nil: true
    mount_uploader :picture, ImageUploader

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                    BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(remember_token)
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    # followユーザー一覧を取得
    def feed
        following_ids = "SELECT followed_id FROM relationships
                    WHERE follower_id = :user_id"
        Micropost.where("user_id IN (#{following_ids})
                    OR user_id = :user_id", user_id: id)
    end

    def follow(other_user)
        following << other_user
    end

    def unfollow(other_user)
        active_relationships.find_by(followed_id: other_user.id).destroy
    end

    def following?(other_user)
        following.include?(other_user)
    end
end