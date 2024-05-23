defmodule CardzWeb.Router do
  use CardzWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {CardzWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CardzWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/projects", CardzWeb do
    pipe_through :browser

    live "/", ProjectLive.Index, :index
    live "/new", ProjectLive.Index, :new
    live "/:id/edit", ProjectLive.Index, :edit

    live "/:id", ProjectLive.Show, :show
    live "/:id/show/edit", ProjectLive.Show, :edit

    live "/:id/edit/cards/new", ProjectLive.Show, :new_card
    live "/:id/edit/cards/:card_id/edit", ProjectLive.Show, :edit_card

    live "/:id/columns/new", ProjectLive.Show, :new_column
    live "/:id/columns/:column_id", ProjectLive.Show, :show_column
    live "/:id/columns/:column_id/edit", ProjectLive.Show, :edit_column

    live "/:project_id/cards", CardLive.Index, :index
    live "/:project_id/cards/new", CardLive.Index, :new
    live "/:project_id/cards/:id/edit", CardLive.Index, :edit
    live "/:project_id/cards/:card_id", CardLive.Show, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", CardzWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:cardz, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CardzWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
