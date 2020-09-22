Postgrex.Types.define(Evercam.PostgresTypes,
                    [
                      {Geo.PostGIS.Extension, library: Geo}
                    ] ++ Ecto.Adapters.Postgres.extensions(),
                    json: Jason)
