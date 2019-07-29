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
    @players = @game.players
    render json: @players
  end

  def update
    all_characters={
      shadow:[
        {
          name:"Wight",
          alliance: "shadow",
          hp: 14,
          win_condition:"All Hunter characters are dead OR 3 Neutral characters are dead",
          ability: "When your turn is over, you may take an additional number of turns equal to the amount of dead characters.(Only once per game)"
        },
        {
          name:"Vampire",
          alliance: "shadow",
          hp: 13,
          win_condition:"All Hunter characters are dead OR 3 Neutral characters are dead",
          ability: "If you attack a player and inflict damage. You heal 2 points of your own damage."
        },
        {
          name:"Ultra Soul",
          alliance: "shadow",
          hp: 11,
          win_condition:"All Hunter characters are dead OR 3 Neutral characters are dead",
          ability: "At the start of your turn. You can give 3 points of damage to one character who is at the underworld Gate."
        },
        {
          name:"Werewolf",
          alliance: "shadow",
          hp: 14,
          win_condition:"All Hunter characters are dead OR 3 Neutral characters are dead",
          ability: "After you are attacked. You can attack that character immediately."
        },
        {
          name:"Valkyrie",
          alliance: "shadow",
          hp: 13,
          win_condition:"All Hunter characters are dead OR 3 Neutral characters are dead",
          ability: "When you attack. Your damage range is 1-4."
        },
        {
          name:"Unknown",
          alliance: "shadow",
          hp: 11,
          win_condition:"All Hunter characters are dead OR 3 Neutral characters are dead",
          ability: "You may lie when givena hermit card. You don't have to reveal your identity to do this."
        }
      ],
      hunter:[
        {
          name:"Ellen",
          alliance: "hunter",
          hp: 10,
          win_condition:"All the shadow characters are dead",
          ability: "At the start of your turn. Choose a character and void his/her ability ability until the end of the game(Only once per game)"
        },
        {
          name:"Fu-ka",
          alliance: "hunter",
          hp: 12,
          win_condition:"All the shadow characters are dead",
          ability: "At the start of your turn, You can set the damage of any character to 7.(Only once per game)"
        },
        {
          name:"George",
          alliance: "hunter",
          hp: 14,
          win_condition:"All the shadow characters are dead",
          ability: "At the start of your turn. You can pick any player and give him/her random damage 1-4.(Only once per game)"
        },
        {
          name:"Gregor",
          alliance: "hunter",
          hp: 14,
          win_condition:"All the shadow characters are dead",
          ability: "Can only be used when your turn is over. You cannot receive any damage until the start of your next turn(Only once per game)"
        },
        {
          name:"Emi",
          alliance: "hunter",
          hp: 10,
          win_condition:"All the shadow characters are dead",
          ability: "When you move. You can roll dice as normal or move to the adjacent area card."
        },
        {
          name:"Franklin",
          alliance: "hunter",
          hp: 12,
          win_condition:"All the shadow characters are dead",
          ability: "At the start of your turn. You can pick any player and give him/her random damage of 1-6.(Only once per game)"
        }
      ],
      neutral:[
        {
          name:"David",
          alliance: "neutral",
          hp: 13,
          win_condition:"You have 3 or more of the following:'Talisman','Spear of longius','Holy Robe','Sliver Rosary'.",
          ability: "You may take one equipment card of your choice from any discard pile.(Only once per game.)"
        },
        {
          name:"Bryan",
          alliance: "neutral",
          hp: 10,
          win_condition:"Your attack kills a character whose HP is 13 or more OR you are on the 'Erstwhile Alter' when the game is over",
          ability: "If your attack kills a character whose HP is 12 or less. You must reveal your identity"
        },
        {
          name:"Agnes",
          alliance: "neutral",
          hp: 8,
          win_condition:"The player after you wins",
          ability: "Can only be used at the start of your turn. Changes your win condition to 'The player before you wins.'"
        },
        {
          name:"Charles",
          alliance: "neutral",
          hp: 11,
          win_condition:"At the time you kill another character. The total number of dead character is 3 or more.",
          ability: "By taking 2 points of damage, You may attack a character twice"
        },
        {
          name:"Daniel",
          alliance: "neutral",
          hp: 13,
          win_condition:"You are the first character to die OR all Shadow charcters are dead and you are not.",
          ability: "As soon as another player dies. you must reveal your identity."
        },
        {
          name:"Catherine",
          alliance: "neutral",
          hp: 11,
          win_condition:"You die first OR You are one of the last two characters remaining",
          ability: "Heals 1 point of your own damage at the start of your turn."
        },
        {
          name:"Allie",
          alliance: "neutral",
          hp: 8,
          win_condition:"You're not dead when the game is over",
          ability: "Fully heal your damage.(Only once per game)"
        }
      ]
    }
    @game.update(turn: params["turn"]["id"])
    @player = Player.find(params["turn"]["id"])
    if @player.character.name === "none"
      if params["amountOfPlayer"] == 4
        shadow_number = 2
        hunter_number = 2
        neutral_number = 0
      elsif params["amountOfPlayer"] == 5
        shadow_number = 2
        hunter_number = 2
        neutral_number = 1
      elsif params["amountOfPlayer"] == 6
        shadow_number = 2
        hunter_number = 2
        neutral_number = 2
      elsif params["amountOfPlayer"] == 7
        shadow_number = 2
        hunter_number = 2
        neutral_number = 3
      elsif params["amountOfPlayer"] == 8
        shadow_number = 3
        hunter_number = 3
        neutral_number = 2
      end
      character_in_play= all_characters[:hunter].sample(shadow_number)
      character_in_play << all_characters[:shadow].sample(hunter_number)
      character_in_play << all_characters[:neutral].sample(neutral_number)
      character_in_play.flatten!
      character_in_play.shuffle!
      players = @game.players.select{|x| x.name != "none"}
      players.each_with_index do |player, ind|
        player.character.update(character_in_play[ind])
      end
    end
    @player = Player.find(params["turn"]["id"])
    if @game.save
      serialized_data = ActiveModelSerializers::Adapter::Json.new(PlayerSerializer.new(@player)).serializable_hash
      serialized_data[:player]['amiaplayer'] = "turn"
      PlayersChannel.broadcast_to @game, serialized_data
      @game.players.each do |single_player|
        serialized_data = ActiveModelSerializers::Adapter::Json.new(PlayerSerializer.new(single_player)).serializable_hash
        serialized_data[:player]['amiaplayer'] = "player"
        PlayersChannel.broadcast_to @game, serialized_data
      end
      render json: @game, status: :accepted
    else
      render json: { errors: @game.errors.full_messages }, status: :unprocessible_entity
    end
  end

  private

  def game_params
    params.require(:game).permit(:id,:turn)
  end

  def find_game
    @game = Game.find(params[:id])
  end
end
