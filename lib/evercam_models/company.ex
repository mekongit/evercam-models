defmodule Company do
  use Evercam.Schema

  @required_fields [:exid, :name]
  @optional_fields [:website, :linkedin_url, :size, :session_count, :updated_at, :inserted_at]

  schema "companies" do
    has_many :users, User, foreign_key: :company_id

    field :exid, :string
    field :name, :string
    field :website, :string
    field :size, :integer
    field :session_count, :integer
    field :linkedin_url, :string
  
    timestamps(type: :utc_datetime_usec, default: Calendar.DateTime.now_utc)
  end

  def all do
    Company
    |> preload(:users)
    |> Repo.all
  end

  def by_exid(id) do
    Company
    |> where(exid: ^String.downcase(id))
    |> preload(:users)
    |> Repo.one
  end

  def create_company(company_id, name, optional_params \\ %{}) do
    company_params =
      %{
        exid: company_id,
        name: name
      } |> Map.merge(optional_params)

    company_changeset = changeset(%Company{}, company_params)
    case Repo.insert(company_changeset) do
      {:ok, company} -> {:ok, company}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def update_company(company, company_params) do
    company_changeset = Company.changeset(company, company_params)

    case Repo.update(company_changeset) do
      {:ok, updated_company} -> {:ok, updated_company}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def changeset(model, params \\ :invalid) do
    model
    |> cast(params, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
