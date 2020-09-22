defmodule Evercam.Repo.Migrations.AddStatusTypeWaitingToCameras do
  use Ecto.Migration

  def change do
    execute("ALTER TYPE public.camera_status ADD VALUE 'waiting'")
  end
end
