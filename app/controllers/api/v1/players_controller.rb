class Api::V1::PlayersController < ApplicationController
  before_action :find_player, only: [:update]
  def index
    @players = Player.all
    render json: @players
  end

  # def create
  #   player = Player.new(player_params)
  #   player = Player.find(player_params[:player_id])
  #   if player.save
  #     serialized_data = ActiveModelSerializers::Adapter::Json.new(
  #       PlayerSerializer.new(player)
  #     ).serializable_hash
  #     PlayersChannel.broadcast_to player, serialized_data
  #     head :ok
  #   end
  # end

  def update
    @player.update(player_params)
    Character.create(player_id:@player.id)
    if @player.save
      render json: @player, status: :accepted
    else
      render json: { errors: @player.errors.full_messages }, status: :unprocessible_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:game_id, :name)
  end

  def find_player
    @player = Player.find(params[:id])
  end
end
