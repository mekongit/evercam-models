defmodule Evercam.Repo.Migrations.AddForeignKeyConstraint do
  use Ecto.Migration

  def change do

		alter table(:access_rights) do
			modify :token_id, references(:access_tokens)
			modify :camera_id, references(:cameras)
			modify :grantor_id, references(:users)
			modify :account_id, references(:users)
		end

		alter table(:access_tokens) do
			modify :user_id, references(:users)
			modify :grantor_id, references(:users)
		end

		alter table(:archives) do
			modify :camera_id, references(:cameras)
			modify :requested_by, references(:users)
		end

		alter table(:camera_share_requests) do
			modify :camera_id, references(:cameras)
			modify :user_id, references(:users)
		end

		alter table(:camera_shares) do
			modify :camera_id, references(:cameras)
			modify :user_id, references(:users)
			modify :sharer_id, references(:users)
		end

		alter table(:cameras) do
			modify :owner_id, references(:users)
			modify :model_id, references(:vendor_models)
		end

		alter table(:cloud_recordings) do
			modify :camera_id, references(:cameras)
		end

		alter table(:users) do
			modify :country_id, references(:countries)
		end

		alter table(:vendor_models) do
			modify :vendor_id, references(:vendors)
		end
  end
end
