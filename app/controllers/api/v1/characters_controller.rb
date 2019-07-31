class Api::V1::CharactersController < ApplicationController
  before_action :find_character, only: [:update]
  def index
    @characters = Character.all
    render json: @characters
  end

  def create
    byebug
  end

  def update
    @character.update(character_params)
    @player = Player.find(params['player_id'])
    @game = Game.find(@player.game_id)

    if params["damage"] === 7
      damage = @character.hp - 7
      @character.update(damage:damage)
    elsif params["damage"] === "allie"
      @character.update(damage:0)
    elsif !!params["damage"]
      @character.update(damage:@character.damage + params["damage"])
    end
    if @character.damage < 0
      @character.update(damage: 0)
    end
    if @character.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(CharacterSerializer.new(@character)).serializable_hash
      serialized_data[:player]={}
      serialized_data[:player]['amiaplayer'] = "characterUpdate"
      PlayersChannel.broadcast_to @game, serialized_data
      render json: @character, status: :accepted
    else
      render json: { errors: @character.errors.full_messages }, status: :unprocessible_entity
    end
  end

  private

  def character_params
    params.permit(:player_id, :hp, :ability, :alliance, :location, :name, :win_condition)
  end

  def find_character
    @character = Character.find(params[:id])
  end
end
