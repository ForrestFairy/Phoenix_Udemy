defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
  Returns a list of strings representing a deck of cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five"]
    suits = ["Spades", "Clubs", "Hearts", "Diamonds"]

    ## option one

    # cards = for suit <-suits do
    #   for value <- values do
    #     "#{value} fof #{suit}"
    #   end
    # end
    # List.flatten(cards)

    ## option two

    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  def shuffle(deck) do
    Enum.shuffle(deck)
  end

  @doc """
  Determines wheter a deck contains a given card

  ## Examples

      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  @doc """
  Divides a deck into a hand and the reminder of the deck.
  The `hand_size` argument indicates how many cards
  should be in the hand.

  ## Examples

      iex> deck = Cards.create_deck()
      iex> {hand, deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]

  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, deck} -> :erlang.binary_to_term(deck)
      {:error, _reason} -> "That file does not exist"
    end
  end

  def create_hand(hand_size) do
    create_deck()
    |> shuffle()
    |> deal(hand_size)
  end
end
