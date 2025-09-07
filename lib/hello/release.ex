defmodule Hello.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix
  installed.
  """
  @app :hello

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def create_db do
    load_app()

    for repo <- repos() do
      case repo.__adapter__().storage_up(repo.config()) do
        :ok ->
          IO.puts("✅ Database created successfully for #{inspect(repo)}")
        {:error, :already_up} ->
          IO.puts("✅ Database already exists for #{inspect(repo)}")
        {:error, term} ->
          IO.puts("❌ Error creating database for #{inspect(repo)}: #{inspect(term)}")
          System.halt(1)
      end
    end
  end

  def drop_db do
    load_app()

    for repo <- repos() do
      case repo.__adapter__().storage_down(repo.config()) do
        :ok ->
          IO.puts("✅ Database dropped successfully for #{inspect(repo)}")
        {:error, :already_down} ->
          IO.puts("✅ Database already dropped for #{inspect(repo)}")
        {:error, term} ->
          IO.puts("❌ Error dropping database for #{inspect(repo)}: #{inspect(term)}")
          System.halt(1)
      end
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
