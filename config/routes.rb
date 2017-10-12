Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    constraints ApiVersion.new(1) do
      scope :module => :v1 do
        post '/login/'        => 'sessions#login'
        post '/signup/'       => 'sessions#signup'

        get '/max_game_scores' => 'users#max_game_scores'
        get '/max_total_scores' => 'users#max_total_scores'

        resources :games, only: [:create] do
        	post '/play/'	  => 'games#play'	
        end
      end
    end
  end
end
