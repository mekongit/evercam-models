defmodule Evercam.Repo.Migrations.AddFtpStatusType do
  use Ecto.Migration

  def change do
    execute("ALTER TYPE public.camera_status ADD VALUE 'ftp'")
  end
end
