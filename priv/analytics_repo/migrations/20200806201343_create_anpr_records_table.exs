defmodule Evercam.AnalyticsRepo.Migrations.CreateAnprRecordsTable do
  use Ecto.Migration

  def change do
    create table(:anpr_records) do
      add(:cameraex, :string, null: false)
      add(:capture_time, :utc_datetime, null: false)
      add(:plate_number, :string, null: false)
      add(:pic_name, :string)
      add(:direction, :string)
      timestamps()
    end

    # can't store duplicated ANPR snapshots
    create unique_index(:anpr_records, [:pic_name])
  end
end
