class Me::Show < BrowserAction
  param input : String = "input"
  param output : String = "output"

  get "/me" do
    op = SaveTranscompileTask.new
    #op.input_code = input
    #@op.output_code = output
    html ShowPage,  operation: op
  end
end
