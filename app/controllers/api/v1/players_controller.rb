class Api::V1::PlayersController < ApplicationController
  before_action :find_player, only: [:update]
  def index
    @players = Player.all
    render json: @players
  end

  def create

  end

  def update
    @player.update(player_params)
    Character.create(player_id:@player.id, hp: 10, name:"none")
    game= @player.game
    if @player.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(PlayerSerializer.new(@player)).serializable_hash
      serialized_data[:player]['amiaplayer'] = "player"
      PlayersChannel.broadcast_to game, serialized_data
      # testVariable = {dana: 'test'}
      # PlayersChannel.broadcast_to game, testVariable
      # byebug
      render json: @player, status: :accepted
    else
      render json: { errors: @player.errors.full_messages }, status: :unprocessible_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:game_id, :name, :location)
  end

  def find_player
    @player = Player.find(params[:id])
  end
end
