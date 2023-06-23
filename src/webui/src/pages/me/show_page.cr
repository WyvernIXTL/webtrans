class Me::ShowPage < MainLayout
  def content
    input = "input"
    output = "output"

    div class: "container h-100 w-100" do 
      div class: "row h-100 w-100" do
        div class: "col" do
          div class: "form-floating mx-auto h-100 py-2 ms-2" do
            textarea input, class: "form-control mx-auto h-100"
          end
        end
        div class: "col-md-auto my-auto" do
          submit "Go!", class: "btn btn-outline-secondary p-3 mx-auto my-auto"
        end 
        div class: "col" do
          div class: "form-floating mx-auto h-100 py-2 me-2" do
            textarea output, class: "form-control mx-auto h-100", attrs: [:readonly]
          end
        end
      end
    end
  end
end
