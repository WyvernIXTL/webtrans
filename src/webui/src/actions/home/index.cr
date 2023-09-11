
# Renders index page if not logged in. Otherwise redirects to `Me::Show`.
class Home::Index < BrowserAction
  include Auth::AllowGuests

  get "/" do
    if current_user?
      redirect Me::Show
    else
      html Home::IndexPage
    end
  end
end
