defmodule Evercam.Repo.Migrations.CreateSmsMessagesTable do
  use Ecto.Migration

  def change do
    create table(:sms_messages) do
      add :to, :string
      add :from, :string
      add :message_id, :string
      add :status, :string
      add :text, :string
      add :type, :string
      add :user_id, :integer
      add :delivery_datetime, :naive_datetime

      timestamps()
    end
  end
end
