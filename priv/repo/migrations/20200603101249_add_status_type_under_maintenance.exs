defmodule Evercam.Repo.Migrations.AddStatusTypeUnderMaintenance do
  use Ecto.Migration

  def change do
    execute("ALTER TYPE public.camera_status ADD VALUE 'under_maintenance'")
  end
end
