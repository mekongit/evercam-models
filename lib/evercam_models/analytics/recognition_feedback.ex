defmodule Analytics.RecognitionFeedback do
  use Evercam.Schema

  defmodule BoundingBox do
    use Evercam.Schema

    @primary_key false
    embedded_schema do
      field(:xmin, :float)
      field(:ymin, :float)
      field(:xmax, :float)
      field(:ymax, :float)
    end

    def changeset(struct, attrs) do
      fields = __MODULE__.__schema__(:fields)

      struct
      |> cast(attrs, fields)
      |> validate_required(fields)
    end
  end

  # recognition feedback results
  defmodule Result do
    use Evercam.Schema

    @primary_key false
    embedded_schema do
      embeds_one(:bounding_box, BoundingBox)
      field(:confidence, :float)
      field(:detected_text, :string)
    end

    def changeset(struct, attrs) do
      fields = __MODULE__.__schema__(:fields)

      struct
      |> cast(attrs, [:confidence, :detected_text])
      |> cast_embed(:bounding_box)
      |> validate_required(fields)
    end
  end

  schema "recognition_feedbacks" do
    field(:cameraex, :string)
    field(:username, :string)
    field(:snapshot_time, :utc_datetime)
    field(:confidence_range, :map)
    embeds_many(:results, Result)
    field(:is_corrected, :boolean)
    timestamps(type: :utc_datetime_usec, default: Calendar.DateTime.now_utc())
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:cameraex, :username, :snapshot_time, :confidence_range, :is_corrected])
    |> cast_embed(:results)
  end
end
