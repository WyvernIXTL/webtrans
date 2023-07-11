class Home::IndexPage < AuthLayout
  def content
    div class: "px-4 py-5 my-5 text-center" do
      h1 "Webtrans", class: "display-5 fw-bold"
      div class: "col-lg-6 mx-auto" do
        para "Webservice for transcoding functions.", class: "lead mb-4"
        div class: "d-grid gap-2 d-sm-flex justify-content-sm-center" do
          link "Proceed as Guest", to: SignUps::New, class: "btn btn-outline-secondary btn-lg px-4"
          link "Login", to: SignIns::New, class: "btn btn-primary btn-lg px-4 me-sm-3"
        end
      end
    end
  end
end