json.extract! reservation, :id, :user_id, :court_id, :starts_at, :ends_at, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
