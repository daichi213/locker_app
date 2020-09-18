class BaggageRequest < ApplicationRecord
  belongs_to :user, class_name: "User"
  #  optional: true
  has_many :to_users, class_name: "BaggageRequestToUser", foreign_key: "baggage_request_id"
  # TODO BaggageRequestとTransactionへの紐付けが難しいため、includesを使用したメソッドを作成する

  # after_commit :calculate_my_point

  accepts_nested_attributes_for :to_users

  # TODO VALIDATION追加
  # TODO relationのテスト追加

  def get_to_user
    self.to_users.find_by(del_flag: 0)
  end

  def get_baggage_request_to_in_required(user_id)
    BaggageRequestToUser.get_baggage_request_to_in_required(user_id, self.id)
  end

  def get_baggage_request_to_in_requires(user_id)
    BaggageRequest.to_users.find_by(required_id: user_id)
  end

  # :to_usersで該当する条件をwhere句で取得してそれに紐づくBaggageRequestのレコードを取得
  def BaggageRequest.get_required_baggage_request(user_id)
    BaggageRequest.includes(
      :to_users
    ).where(
      "required_id LIKE ? AND del_flag LIKE ?", user_id, 0
    ).references(:to_users)
  end

  def BaggageRequest.get_request_in_transaction(user_id)
    BaggageRequest.where(
      "leaver_end_authenticate LIKE ? AND
       receiver_end_authenticate LIKE ?",
       1, 1
    )
  end

  def BaggageRequest.get_intend_to_request(user_id)
    BaggageRequest.where(
      "user_id LIKE ? AND approval_flag LIKE ? AND
       leaver_start_authenticate LIKE ?",
       user_id, 1, 0
    )
  end

  def BaggageRequest.get_receiving_in_transaction(user_id)
    BaggageRequest.where(
      "leaver_start_authenticate LIKE ? AND
       receiver_start_authenticate LIKE ? AND
       receiver_end_authenticate LIKE ?",
       1, 1, 0
    ).includes(
      :to_users
    ).where(
      "required_id LIKE ? AND del_flag LIKE ?", user_id, 0
    ).references(
      :to_users
    )
  end

  def BaggageRequest.get_leaving_in_transaction(user_id)
    BaggageRequest.where(
      "leaver_start_authenticate LIKE ? AND
       receiver_start_authenticate LIKE ? AND
       leaver_end_authenticate LIKE ?",
       1, 1, 0
    ).includes(
      :to_users
    ).where(
      "requires_id LIKE ? AND del_flag LIKE ?", user_id, 0
    ).references(
      :to_users
    )
  end

  # userの評価ポイントの実装
  # def calculate_my_point
  #   user = self.user
  #   my_point_sum = user.active_requries.map{|request| request.leaver_point}.sum
  #   num = user.active_requries.map{|request| request.leaver_point}.count
  #   self.leaver_point
  # end
end
