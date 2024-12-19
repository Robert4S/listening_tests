defmodule ExListeningWeb.Router do
  use ExListeningWeb, :router

  import ExListeningWeb.TeacherAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ExListeningWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_teacher
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ExListeningWeb do
    pipe_through :browser

    get "/", RedirectIfAuthenticated, []
    live "/join", StudentJoin.Index, :index
    live "/homes", HomesLive.Index, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", ExListeningWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ex_listening, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ExListeningWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", ExListeningWeb do
    pipe_through [:browser, :redirect_if_teacher_is_authenticated]

    live_session :redirect_if_teacher_is_authenticated,
      on_mount: [{ExListeningWeb.TeacherAuth, :redirect_if_teacher_is_authenticated}] do
      live "/teachers/log_in", TeacherLoginLive, :new
    end

    post "/teachers/log_in", TeacherSessionController, :create
  end

  scope "/", ExListeningWeb do
    pipe_through [:browser, :require_authenticated_teacher]

    live_session :require_authenticated_teacher,
      on_mount: [{ExListeningWeb.TeacherAuth, :ensure_authenticated}] do
      live "/teachers/settings", TeacherSettingsLive, :edit
      live "/teachers/register", TeacherRegistrationLive, :new
      live "/teachers/settings/confirm_email/:token", TeacherSettingsLive, :confirm_email
      live "/upload", AudioLive.Upload, :upload

      live "/students", StudentLive.Index, :index
      live "/students/new", StudentLive.Index, :new
      live "/students/:id/edit", StudentLive.Index, :edit

      live "/students/:id", StudentLive.Show, :show
      live "/students/:id/show/edit", StudentLive.Show, :edit

      live "/classes", ClassLive.Index, :index
      live "/classes/new", ClassLive.Index, :new
      live "/classes/:id/edit", ClassLive.Index, :edit

      live "/classes/:id", ClassLive.Show, :show
      live "/classes/:id/show/edit", ClassLive.Show, :edit

      live "/tests", ListeningTestLive.Index, :index
      live "/tests/new", ListeningTestLive.Index, :new
      live "/tests/:id/edit", ListeningTestLive.Index, :edit
      live "/tests/:id/execute", ListeningTestLive.Execute, :execute

      live "/tests/:id", ListeningTestLive.Show, :show
      live "/tests/:id/show/edit", ListeningTestLive.Show, :edit

      live "/dashboard", DashboardLive.Index, :index
    end
  end

  scope "/", ExListeningWeb do
    pipe_through [:browser]

    delete "/teachers/log_out", TeacherSessionController, :delete

    live_session :current_teacher,
      on_mount: [{ExListeningWeb.TeacherAuth, :mount_current_teacher}] do
      live "/teachers/confirm/:token", TeacherConfirmationLive, :edit
      live "/teachers/confirm", TeacherConfirmationInstructionsLive, :new
    end
  end
end

defmodule ExListeningWeb.RedirectIfAuthenticated do
  import Plug.Conn
  import Phoenix.Controller

  alias ExListeningWeb.Router.Helpers, as: Routes

  def init(default), do: default

  def call(conn, _opts) do
    if conn.assigns[:current_teacher] do
      conn
      |> redirect(to: "/dashboard")
      |> halt()
    else
      conn
      |> redirect(to: "/join")
      |> halt()
    end
  end
end
