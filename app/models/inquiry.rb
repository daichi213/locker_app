class Inquiry < ApplicationRecord
    belongs_to :user
    has_one :solution
    validates :title, presence: true

    def Inquiry.list_of_title
        ["パスワード関係",
            "サイトの使用方法について",
            "取引関係について",
            "サイトの不具合の報告",
            "その他"]
    end
end