
# Renders index page if not logged in. Otherwise redirects to `Task::ShowCreatePage`.
class Home::Index < BrowserAction
  include Auth::AllowGuests

  get "/" do
    if current_user?
      redirect Task::ShowCreatePage
    else
      html Home::IndexPage
    end
  end
end
