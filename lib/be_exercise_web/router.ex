defmodule BeExerciseWeb.Router do
  use BeExerciseWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BeExerciseWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: BeExercise.ApiSpec
  end

  scope "/", BeExerciseWeb do
    pipe_through :api

    get "/users", UserController, :get_users
    post "/invite-users", EmailController, :invite_users
  end

  scope "/api" do
    pipe_through :api
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  scope "/swagger" do
    pipe_through(:browser)

    get("/", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi")
  end

  # Other scopes may use custom stacks.
  # scope "/api", BeExerciseWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:be_exercise, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: BeExerciseWeb.Telemetry
    end
  end
end
