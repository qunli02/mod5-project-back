class Api::V1::GamesController < ApplicationController
  before_action :find_game, only: [:update]
  def index
    @games = Game.all
    render json: @games
  end

  def create
    # game = Game.new(game_params)
    # if game.save
    #   serialized_data = ActiveModelSerializers::Adapter::Json.new(
    #     GameSerializer.new(game)
    #   ).serializable_hash
    #   ActionCable.server.broadcast 'games_channel', serialized_data
    #   head :ok
    # end
    @game = Game.create()
    8.times{Player.create(name:"none", game_id:@game.id)}
    @players = [-8..-1].map{|x|Player.all[x]}
    @players.flatten!
    render json: @players
  end

  def update
    @game.update(game_params)
    if @game.save
      render json: @game, status: :accepted
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessible_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:id)
  end

  def find_game
    @game = Game.find(params[:id])
  end
end
