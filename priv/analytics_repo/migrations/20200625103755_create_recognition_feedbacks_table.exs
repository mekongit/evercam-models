defmodule Evercam.AnalyticsRepo.Migrations.CreateRecognitionFeedbacksTable do
  use Ecto.Migration

  def change do
    create table(:recognition_feedbacks) do
      add(:cameraex, :string, null: false)
      add(:username, :string, null: false)
      add(:snapshot_time, :utc_datetime, null: false)
      add(:confidence_range, :json)
      add(:results, :json)
      add(:is_corrected, :boolean, default: false)
      timestamps()
    end
  end
end
