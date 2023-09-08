class ApiDocumentationAction::Show < BrowserAction
  include Auth::AllowGuests

  get "/api/" do
    html ApiDocumentation::ApiDocumentation
  end
end