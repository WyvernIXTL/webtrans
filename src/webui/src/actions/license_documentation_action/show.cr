class LicenseDocumentationAction::Show < BrowserAction
    include Auth::AllowGuests
  
    get "/license/" do
      html LicenseDocumentation::LicenseDocumentation
    end
  end