defmodule EdgeBuilder.CharacterController do
  use Phoenix.Controller

  alias EdgeBuilder.Models.Character
  import Ecto.Query, only: [from: 2]

  plug :action

  def edit(conn, %{"id" => id}) do
    render conn, "edit.html", character: Character.full_character(id)
  end

  def update(conn, params = %{"id" => id, "character" => character_params}) do
    changesets = %{
      character: [character_changeset(id, character_params)],
      talents: talent_changesets(id, params["talents"])
    }

    if changesets |> Map.values |> List.flatten |> Enum.all?(&(&1.valid?)) do
      changesets
        |> Enum.map(fn {type, sets} -> {type, Enum.map(sets, &apply_changeset/1)} end)
        |> Enum.into(%{})

      delete_missing(id, EdgeBuilder.Models.Talent, changesets[:talents])

      conn
        |> put_status(200)
        |> text "ok"
    else
      conn
        |> put_status(400)
        |> text "not ok"
    end
  end

  defp character_changeset(id, params) do
    Character.full_character(id)
      |> Character.changeset(params)
  end

  defp talent_changesets(character_id, params) when is_map(params) do
    params
      |> Map.values
      |> Enum.map(&(Map.put(&1, "character_id", character_id)))
      |> Enum.map(fn talent_params ->
        case talent_params do
          %{"id" => id} -> EdgeBuilder.Repo.get(EdgeBuilder.Models.Talent, id)
          _ -> %EdgeBuilder.Models.Talent{}
        end |> EdgeBuilder.Models.Talent.changeset(talent_params)
      end)
  end
  defp talent_changesets(_,_), do: []

  defp apply_changeset(c) do
    if is_nil(Ecto.Changeset.get_field(c, :id)) do
      EdgeBuilder.Repo.insert(c)
    else
      EdgeBuilder.Repo.update(c)
    end
  end

  defp delete_missing(character_id, model, changesets) do
    EdgeBuilder.Repo.delete_all(
      from m in model,
        where: m.character_id == ^character_id,
        where: not m.id in ^Enum.map(changesets, &(Ecto.Changeset.get_field(&1, :id)))
    )
  end
end