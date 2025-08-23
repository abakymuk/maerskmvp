class HealthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["PATH_INFO"] == "/healthz" && env["REQUEST_METHOD"] == "GET"
      [ 200, { "Content-Type" => "application/json" }, [ JSON.generate({ ok: true, env: Rails.env }) ] ]
    else
      @app.call(env)
    end
  end
end

Rails.application.config.middleware.insert_before 0, HealthMiddleware
