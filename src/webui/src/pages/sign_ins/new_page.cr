class SignIns::NewPage < AuthLayout
  needs operation : SignInUser

  def content
    div class: "h-100 d-flex align-items-center justify-content-center" do
      # width-lg does what? w-25 sucks. vw-25 sucks too.
      div class: "width-lg" do
        h1 "Sign In"
        render_sign_in_form(@operation)
      end
    end
  end

  private def render_sign_in_form(op)
    form_for SignIns::Create, class: "inline" do
      sign_in_fields(op)
      submit "Sign In", flow_id: "sign-in-button", class: "btn btn-primary btn-block mb-4"
    end
    link "Reset password", to: PasswordResetRequests::New
    text " | "
    link "Sign up", to: SignUps::New
  end

  private def sign_in_fields(op)
    mount Shared::Field, attribute: op.email, label_text: "Email", &.email_input(autofocus: "true")
    mount Shared::Field, attribute: op.password, label_text: "Password", &.password_input
  end
end
