module Api
  module V1
    class UsersController < BaseController
      skip_before_action :set_current_user
      skip_before_action :requires_login

      def max_game_scores
      	@users = User.order(max_score: :desc).limit(10)
      end

      def max_total_scores
      	@users = User.order(total_score: :desc).limit(10)
      end

    end
  end
end
