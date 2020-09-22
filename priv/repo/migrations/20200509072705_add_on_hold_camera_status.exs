defmodule Evercam.Repo.Migrations.AddOnHoldCameraStatus do
  use Ecto.Migration

  def change do
    execute("ALTER TYPE public.camera_status ADD VALUE 'on_hold'")
  end
end
