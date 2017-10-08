module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :set_current_user
      skip_before_action :requires_login
      before_action :validate_login_parameters, only: [:new]

      def login
        @user = User.where(email: params[:email]).first if params[:email].present?
        if @user && @user.authenticate(params[:password])
          render json: { token: Token.encode(@user.id), id: @user.id , name: @user.name}
        else
          render json: { error: 'Invalid credentials' }, status: :unauthorized
        end
      end

      def signup
        begin
          @user = User.create! sign_up_params
          render json: { token: Token.encode(@user.id), id: @user.id , name: @user.name} and return
        rescue ActiveRecord::RecordNotUnique => e
          render json: { error: "User already exists" } and return
        rescue ActiveRecord::RecordInvalid => e
          render json: { error: e.message } and return
        end      
      end

      private
      def sign_up_params
        params.permit(:name, :email, :password, :password_confirmation)
      end

      def validate_login_parameters
        render(json: { error: 'empty username or email or password' }) && return if params[:email].blank? || params[:password].blank?
      end
    end
  end
end