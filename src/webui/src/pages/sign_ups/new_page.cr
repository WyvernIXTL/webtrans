class SignUps::NewPage < AuthLayout
  needs operation : SignUpUser

  def content
    div class: "h-100 d-flex align-items-center justify-content-center" do
      div class: "width-lg" do
        h1 "Sign Up"
        render_sign_up_form(@operation)
      end
    end
    
  end

  private def render_sign_up_form(op)
    form_for SignUps::Create do
      sign_up_fields(op)
      submit "Sign Up", flow_id: "sign-up-button", class: "btn btn-primary btn-block mb-4"
    end
    link "Sign in instead", to: SignIns::New
  end

  private def sign_up_fields(op)
    mount Shared::Field, attribute: op.email, label_text: "Email", &.email_input(autofocus: "true")
    mount Shared::Field, attribute: op.password, label_text: "Password", &.password_input
    mount Shared::Field, attribute: op.password_confirmation, label_text: "Confirm Password", &.password_input
  end
end
