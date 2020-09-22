defmodule Evercam.Repo.Migrations.CreateBatteryReadingsTable do
  use Ecto.Migration

  def change do
    create table(:battery_readings) do
      add :pid, :string
      add :fw, :string
      add :serial_no, :string
      add :voltage, :integer
      add :i_value, :integer
      add :vpv_value, :integer
      add :ppv_value, :integer
      add :cs_value, :integer
      add :err_value, :integer
      add :h19_value, :integer
      add :h20_value, :integer
      add :h21_value, :integer
      add :h22_value, :integer
      add :h23_value, :integer
      add :datetime, :string
      add :battery_id, :integer
      add :il_value, :integer
      add :mppt_value, :integer
      add :load_value, :string
      add :p_value, :integer
      add :consumed_amphours, :integer
      add :soc_value, :integer
      add :time_to_go, :integer
      add :alarm, :string
      add :relay, :string
      add :ar_value, :integer
      add :bmv_value, :integer
      add :h1_value, :integer
      add :h2_value, :integer
      add :h3_value, :integer
      add :h4_value, :integer
      add :h5_value, :integer
      add :h6_value, :integer
      add :h7_value, :integer
      add :h8_value, :integer
      add :h9_value, :integer
      add :h10_value, :integer
      add :h11_value, :integer

      timestamps()
    end
  end
end
