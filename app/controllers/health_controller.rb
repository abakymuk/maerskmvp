class HealthController < ActionController::Base
  def index
    render json: { ok: true, env: Rails.env }, status: :ok
  end
end
