module Api
  module V1
    class GamesController < BaseController 
      def create
      	begin
    	  @game = @current_user.games.initial.create(jackpot_door: rand(1..3))
    	  render json: { meta: {status: true, msg: 'Game Set up'}, response: {game_id: @game.id} }, status:200
    	rescue
    	  render json: { meta: {status: false, msg: 'Unable to start game'} }, status: 401
    	end 
      end

      def play
      	begin
          @game = Game.find(game_params[:game_id])
          render json: { meta: {status: false, msg: 'Unauthorized Access'} }, status: 401 if @game.user != @current_user
          prob = eval(game_params[:p])
          prob_sum = prob[0] + prob[1] + prob[2]
          render json: { meta: {status: false, msg: 'Probabilities should add to 1'} }, status: 401 if prob_sum > 1
      	  if @game.status == 'initial'
      	  	new_prize = @game.prize * game_params[:p][@game.jackpot_door.to_i].to_i
      	    @game.update!(prize: new_prize, status: Game.statuses['mid']) 
      	    render json: { meta: {status: true, msg: 'Game Set up'}, response: {open_gate: ([1,2,3] - [@game.jackpot_door]).sample, prize: 0} }, status:200
      	  elsif @game.status == 'mid'
      	  	new_prize = @game.prize * game_params[:p][@game.jackpot_door.to_i].to_i 
      	  	@game.update!(prize: new_prize, status: Game.statuses['finish'])
      	  	render json: { meta: {status: true, msg: 'Game Set up'}, response: {open_gate: @game.jackpot_door, prize: @game.prize} }, status:200
      	  else
      	  	render json: { meta: {status: false, msg: 'Game already over'} }, status: 401
      	  end
      	rescue
    	  render json: { meta: {status: false, msg: 'Unable to progress'} }, status: 401
      	end
      end

      def game_params
      	params.permit(:game_id, :p)
      end 
    end
  end
end
