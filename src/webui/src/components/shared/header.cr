class Shared::Header < BaseComponent
  needs user_email : String

  def render
    nav class: "navbar navbar-expand-lg navbar-light bg-light" do
      a "Webtrans", class: "navbar-brand ms-3", href: "/"
      
      form class: "form-inline ms-auto me-3" do 
        text "#{user_email}    "
        link "Sign out", to: SignIns::Delete, class: "btn btn-outline-success my-2 my-sm-0"
      end
    end
  end
end
