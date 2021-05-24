defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias DiscussWeb.{Topic, Comment}

  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic
      |> Discuss.Repo.get(topic_id)
      |> Discuss.Repo.preload(:comments)

    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic

    changeset = topic
    |> Ecto.build_assoc(:comments)
    |> Comment.changeset(%{content: content})

    case Discuss.Repo.insert(changeset) do
      {:ok, comment} ->
        broadcast!(socket,
                    "comments:#{socket.assigns.topic.id}:new",
                    %{comment: comment}
        )
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end
end
