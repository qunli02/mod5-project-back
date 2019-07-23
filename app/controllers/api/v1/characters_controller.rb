class Api::V1::CharactersController < ApplicationController
  before_action :find_charater, only: [:update]
  def index
    @charaters = Character.all
    render json: @charaters
  end

  def update
    @charater.update(charater_params)
    if @charater.save
      render json: @charater, status: :accepted
    else
      render json: { errors: @charater.errors.full_messages }, status: :unprocessible_entity
    end
  end

  private

  def charater_params
    params.permit(:player_id, :hp, :ability, :alliance)
  end

  def find_charater
    @charater = Character.find(params[:id])
  end
end
